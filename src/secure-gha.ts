import * as core from '@actions/core'
import * as github from '@actions/github'

async function run(): Promise<void> {
  try {
    console.log("inside run ", github.context.payload.pull_request?.number)
  } catch (error) {
    if (error instanceof Error) core.setFailed(error.message)
  }
}

run()
