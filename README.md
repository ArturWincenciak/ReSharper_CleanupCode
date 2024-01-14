# ReSharper CLI CleanupCode

> ### Visit the blog post to read more about the context of use cases
> [Zaoszczędź swój czas, niech kod wyczyści się sam – ReSharper CLI CleanupCode GitHub Action](https://teo-vincent.blog/2023/12/31/zaoszczedz-swoj-czas-niech-kod-wyczysci-sie-sam-resharper-cli-cleanupcode-github-action/)

GitHub Action automatically cleans up your code and creates a commit with the changes in your remote repository.

Save your time from having to do a code review and make corrections and also from having to enter a commit message each time. 
The commit with the changes is created automatically.

## Automatically clean up your code

That is a GitHub Action that allows you to run 
[ReSharper's CleanupCode Command-Line Tool](https://www.jetbrains.com/help/resharper/CleanupCode.html) 
in order to automatically apply code style rules and fix code issues in your project.

[CleanupCode will read the following preferences from DotSettings files](https://www.jetbrains.com/help/resharper/CleanupCode.html#configuring-cleanupcode-with-dotsettings):
- [Code formatting rules](https://www.jetbrains.com/help/resharper/Configure_Code_Formatting_Rules.html)
- [Syntax styles](https://www.jetbrains.com/help/resharper/Code_Syntax_Style.html)
- [File header style in C# and C++](https://www.jetbrains.com/help/resharper/File_Header_Style.html)
- [File and type layout in C#](https://www.jetbrains.com/help/resharper/File_and_Type_Layout.html)

## Inputs

The following input parameters can be passed to the action:

## `solution`

Solution or project file to be cleaned up.

- **Required: `true`**

## `fail_on_reformat_needed`

Determines whether the action should fail if the code needs to be reformatted.

- Required: `false`
- Default: `no`
- Accepted values: `yes`, `no`

## `auto_commit`

Determines whether the action should automatically commit the changes made by the `ReSharper's CleanupCode Command-Line Tool`.

- Required: `false`
- Default: `yes`
- Accepted values: `yes`, `no`

## `jb_cleanup_code_arg`

Additional arguments to pass to the `ReSharper's CleanupCode Command-Line Tool`. Configure the tool with command-line parameters, 
e.g.: `--verbosity=INFO --profile=Built-in: Full Cleanup --exclude=**UnitTests/**.*`.

- [See more here in that clear and concise specification](https://www.jetbrains.com/help/resharper/CleanupCode.html#command-line-parameters)
- **Notice**: Never use quotation marks `"` even if the value contains spaces. The command separator is `--` (two hyphens in a row) and this
  is enough to split arguments. If you use quotation marks, the behavior is undefined.
- Required: `false`
- Default: `--verbosity=WARN`

## `commit_message`

The commit message to use if `auto_commit` is set to `yes`. 

- Required: `false`
- Default: `Cleanup code`

## `commit_creator_email`

The email address to use for the git user who creates the commit if `auto_commit` is set to `yes`.

- Required: `false`
- Default: `cleanupcode@github.action`

## `commit_creator_name`

The name to use for the git user who creates the commit if `auto_commit` is set to `yes`.

- Required: `false`
- Default: `CleanupCode GitHub Action`

# [ReSharper CLI CleanupCode GitHub Action Demo Usage](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo)

In that demo project, you will find all the knowledge you need to effectively start using this action.

## Try your self demo project
1. Go to the [demo project](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo)
2. Fork this repo 
3. Create a Pull Request 
4. Go to `Actions` and observe the action in action 
5. Check out history of your repo and see newly created commit
   
## The simplest way to usage

```yaml
steps:
  - name: Cleanup Code
    uses: ArturWincenciak/ReSharper_CleanupCode@v2.0
    with:
      solution: 'ReSharperCleanupCodeDemo.sln'
```

That configuration means that the action does clean up and all cleaned up code will be committed and pushed into remote repo.
Commit will be performed with default commit message, git user email and name.

- default commit message: `Clean up code by ReSharper CLI CleanupCode Tool`
- default git user email: `cleanupcode@github.action`
- default git user name: `CleanupCode Action`

## Change commit message, git user email and name

```yaml
steps:
  - name: Cleanup Code
    uses: ArturWincenciak/ReSharper_CleanupCode@v2.0
    with:
      solution: 'ReSharperCleanupCodeDemo.sln'
      commit_message: 'Clean up the code'
      commit_creator_email: 'knuth.conway@surreal.number'
      commit_creator_name: 'Knuth Conway'
```

## Interrupt your CI/CD pipeline if Cleanup detected the code needs to be cleaned up

```yaml
steps:
  - name: Cleanup Code
    uses: ArturWincenciak/ReSharper_CleanupCode@v2.0
    with:
      solution: 'ReSharperCleanupCodeDemo.sln'
      fail_on_reformat_needed: 'yes'
```

If this setting is enabled, the process will stop and return an error code if it finds that the code needs to be cleaned
up. This can be helpful for stopping the pipeline from continuing if there are problems with the code.

## No interrupt and no clean up

```yaml
steps:
  - name: Cleanup Code
    uses: ArturWincenciak/ReSharper_CleanupCode@v2.0
    with:
      solution: 'ReSharperCleanupCodeDemo.sln'
      fail_on_reformat_needed: 'no'
      auto_commit: 'no'
```

At times, you may want to disable automatic clean up code and continue with the execution of your CI/CD pipeline, for
instance, when you need to debug subsequent steps without performing clean up.

## Interrupt the pipeline vs Clean up code 

Note that if you set the action to automatically clean up code (which can be very helpful), you risk encountering the
need to resolve conflicts later if you forget to pull the automatically-committed changes.
For some, interrupting the CI/CD pipeline and performing code cleanup locally in your IDE or by console command 
may be a more convenient option.

### Perform clean up your code locally with a fully automated commit and save your time

For such a case, I have prepared a ready-made script that you can run locally. This script will perform clean up code
and create a commit with the changes in your local repository. This will save your time from having to
enter a commit message each time. The commit with the changes will be created automatically.

- [local-dev-cleanup-code.sh](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo/blob/main/local-dev-cleanup-code.sh)
- [How to use the clean up your code bash script in local repo](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo#clean-up-your-code-in-local-repo)

> _This script can be attached to the git hooks, however, attaching this script to the `pre-commit` git hook is
not advisable as it may slow down our work considerably due to the lengthy clean up code process. It may be more
beneficial to add this script to the `pre-push` git hook instead._

## Fully configured and ready to use

```yaml
name: ReSharper CLI CleanupCode

on: [ push ]

jobs:
  cleanup:
    runs-on: ubuntu-latest
    name: Cleanup Code
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: 7.0.x

      - name: Restore Dependencies
        run: dotnet restore ReSharperCleanupCodeDemo.sln
          
      - name: Cleanup Code
        id: cleanup
        uses: ArturWincenciak/ReSharper_CleanupCode@v4.14
        with:
          solution: 'ReSharperCleanupCodeDemo.sln'
          fail_on_reformat_needed: 'no'
          auto_commit: 'yes'
          jb_cleanup_code_arg: '--verbosity=INFO --profile=Built-in: Full Cleanup --exclude=**UnitTests/**.*'
          commit_message: 'Cleanup code by ReSharper CLI CleanupCode GitHub Action'
          commit_creator_email: 'cleanup@up.action'
          commit_creator_name: 'Clean Up'
```
### Sequence of actions performed by the prepared GitHub Action
- `Checkout`: download the source code from the current repository where the Action was
initiated
- `Setup .NET`: install the specified version of .NET on the virtual machine where the Action is run 
- `Restore Dependencies`: restore all project dependencies, such as NuGet libraries
- `Cleanup Code` clean up the code

# Cleanup Code works perfectly with Inspect Code

There are situations where Cleanup Code does not do the entire job for us, but we can still greatly help ourselves and
speed up ours Code Review process by adding an additional automatic step that performs an inspection of the code and, 
adds a comments to the submitted Pull Request on our behalf.

Here in that demo project 
[ReSharper CLI CleanupCode GitHub Action Demo](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo#cleanup-code-works-perfectly-with-inspect-code), 
I show you how to combine [ReSharper CLI CleanupCode](https://github.com/marketplace/actions/resharper-cli-cleanupcode)
and [ReSharper CLI InspectCode](https://github.com/marketplace/actions/resharper-cli-inspectcode) 
using [GitHub Action Definition](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo/blob/main/.github/workflows/cleanup_code.yml)
that contains two jobs: `cleanup` and `inspection`.

Refer to 
[the demo project](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo#cleanup-code-works-perfectly-with-inspect-code)
and gain all the knowledge on how to speed up your daily development process.

```yaml
name: ReSharper CLI CleanupCode

on: [ push ]

jobs:
  cleanup:
    runs-on: ubuntu-latest
    name: Cleanup Code
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: 7.0.x

      - name: Restore Dependencies
        run: dotnet restore ReSharperCleanupCodeDemo.sln
          
      - name: Cleanup Code
        id: cleanup
        uses: ArturWincenciak/ReSharper_CleanupCode@v2.0
        with:
          solution: 'ReSharperCleanupCodeDemo.sln'
          fail_on_reformat_needed: 'no'
          auto_commit: 'yes'
          jb_cleanup_code_arg: '--verbosity=INFO --profile=Almost Full Cleanup --exclude=**UnitTests/**.*'
          commit_message: 'Cleanup code by ReSharper CLI CleanupCode GitHub Action'
          commit_creator_email: 'cleanupcode@github.action'
          commit_creator_name: 'CleanupCode Action'
  
  inspection:
    runs-on: ubuntu-latest
    name: Inspect Code
    needs: cleanup

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: 7.0.x

      - name: Restore Dependencies
        run: dotnet restore ReSharperCleanupCodeDemo.sln

      - name: Inspect code
        uses: muno92/resharper_inspectcode@1.6.5
        with:
          solutionPath: ./ReSharperCleanupCodeDemo.sln
          failOnIssue: 1
          minimumSeverity: notice
          solutionWideAnalysis: true
```

> _[ReSharper CLI InspectCode](https://github.com/marketplace/actions/resharper-cli-inspectcode) - that one I've found 
> in the Marketplace and used in the 
> [demo project](https://github.com/ArturWincenciak/ReSharper_CleanupCode_Demo#cleanup-code-works-perfectly-with-inspect-code), 
> it was an **inspiration** for me to create my own `ReSharper CLI CleanupCode` the second tool in this toolkit. These two
tools complement each other well and produce nice results._

