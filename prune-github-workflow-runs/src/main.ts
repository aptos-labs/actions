import * as core from "@actions/core";
import * as github from "@actions/github";
import * as glob from "@actions/glob";
import * as path from "path";

/**
 * The main function for the action.
 * @returns {Promise<void>} Resolves when the action is complete.
 */
export async function run(): Promise<void> {
  try {
    const token: string = core.getInput("token", { required: true });
    const owner: string = core.getInput("owner", { required: false });
    const repo: string = core.getInput("repo", { required: false });
    const dryRun: boolean = core.getInput("dry-run") !== "false"; // any value other than "false" will be considered as true to be safe

    const ghClient = github.getOctokit(token, {
      throttle: {
        onRateLimit: (retryAfter = 0, options: any) => {
          console.warn(
            `Request quota exhausted for request ${options.method} ${options.url}`,
          );
          if (options.request.retryCount === 0) {
            // only retries once
            console.log(`Retrying after ${retryAfter} seconds!`);
            return true;
          }
        },
        onAbuseLimit: (retryAfter = 0, options: any) => {
          console.warn(
            `Abuse detected for request ${options.method} ${options.url}`,
          );
          if (options.request.retryCount === 0) {
            // only retries once
            console.log(`Retrying after ${retryAfter} seconds!`);
            return true;
          }
        },
      },
      previews: ["ant-man"],
    });

    const patterns = [`.github/worklows/*.yml`, `.github/workflows/*.yaml`];
    const globber = await glob.create(patterns.join("\n"));
    const workflowFilePaths = await globber.glob();
    const workflowFilesPresentInRepo = workflowFilePaths.map((filePath) =>
      path.basename(filePath),
    );

    if (workflowFilesPresentInRepo.length === 0) {
      core.setFailed(
        "Found 0 workflow files under `.github/workflows` which is kinda odd - exiting early...",
      );
      return;
    }

    core.info(
      `\nFound the following workflow files in the repo:\n${workflowFilesPresentInRepo.join(
        "\n",
      )}`,
    );

    const workflowResponse = await ghClient.paginate(
      ghClient.rest.actions.listRepoWorkflows,
      {
        owner,
        repo,
      },
      (response) => response.data,
    );

    const obsoleteWorkflows = workflowResponse.filter(
      (workflow) =>
        !workflowFilesPresentInRepo.includes(path.basename(workflow.path)),
    );

    let totalDeleted = 0;

    core.info(
      `
Found ${obsoleteWorkflows.length} obsolete workflows:
${obsoleteWorkflows.map((wf) => `'${wf.name}' - path: ${wf.path}`).join("\n")}
Deleting their workflow runs now...`,
    );

    for (const wf of obsoleteWorkflows) {
      core.info("Deleting workflow runs of workflow: " + wf.name);

      const workflowRuns = await ghClient.paginate(
        ghClient.rest.actions.listWorkflowRuns,
        {
          owner,
          repo,
          workflow_id: wf.id,
        },
        (response) => response.data,
      );

      for (const [index, run] of workflowRuns.entries()) {
        const workflowInfo = `${dryRun ? "[DRY-RUN] " : ""}Workflow: "${wf.name}" - Deleting Run (${index + 1}/${
          workflowRuns.length
        }) - Run ID: ${run.id}`;
        core.info(workflowInfo);
        try {
          if (!dryRun) {
            await ghClient.rest.actions.deleteWorkflowRun({
              owner,
              repo,
              run_id: run.id,
            });
          }
        } catch (e: any) {
          if (e.status === 403) {
            core.warning(
              `Failed to delete workflow with 403 permission error: path: ${wf.path}, workflow_run_id: ${run.id}, message: ${e.message}. It's probably present in another branch. Skipping...`,
            );
            continue;
          }
          throw e;
        }
        totalDeleted++;
      }
    }

    core.info(`Deleted ${totalDeleted} workflow runs`);
  } catch (error) {
    // Fail the workflow run if an error occurs
    if (error instanceof Error) core.setFailed(error.message);
  }
}
