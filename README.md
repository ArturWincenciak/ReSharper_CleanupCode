# ReSharper CLI CleanupCode 

This is a GitHub Action that allows you to run [ReSharper's CleanupCode Command-Line Tool](https://www.jetbrains.com/help/resharper/CleanupCode.html) in order to automatically apply code style rules and fix code issues in your project.

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

Determines whether the action should automatically commit the changes made by the ReSharper's CleanupCode Command-Line Tool.

- Required: `false`
- Default: `yes`
- Accepted values: `yes`, `no`

## `jb_cleanup_code_arg`

Additional arguments to pass to the ReSharper's CleanupCode Command-Line Tool. Configure the tool with command-line parameters 
e.g. `--verbosity=INFO --profile=Built-in: Full Cleanup --exclude=**UnitTests/**.*`.

- [See more here in that clear and concise specification](https://www.jetbrains.com/help/resharper/CleanupCode.html#command-line-parameters)
- **Notice**: Never use quotation marks `"` even if the value contains spaces. The command separator is '--' (two hyphens in a row) and this
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

## Example usage

```yaml
uses: ArturWincenciak/ReSharper_CleanupCode@v1.0.0
# TODO
```
