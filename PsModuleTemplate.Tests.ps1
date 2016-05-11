Import-Module PsModuleTemplate -Force

# InModuleScope PsModuleTemplate {}

Describe 'PsModuleTemplate' {

    Context 'Exported functions' {

        $actual = Get-Command -Module 'PsModuleTemplate' -CommandType Function | Select-Object -Expand Name
        Write-Host "Functions: $actual"

        It 'Exports functions in the `Public` folder' {
            $public = Get-ChildItem -Path '.\Public\*.ps1' -Exclude '__*','*.Tests.*' | Select-Object -Expand BaseName
            # Write-Host "public: $public"
            $actual | where { $public -NotContains $_ } | Should Be $null
        }

       It 'Does NOT export functions in the `Private` folder' {
            $private = Get-ChildItem -Path '.\Private\*.ps1' -Exclude '*.Tests.*' | Select-Object -Expand BaseName
            # Write-Host "private: $private"
            $private | where { $actual -NotContains $_ } | Should Be $private
        }

        It 'Does NOT Export disabled scripts (like `__*`) in the `Public` folder' {
            $disabled = Get-ChildItem -Path '.\Public\*.ps1' -Include '__*' -Exclude '*.Tests.*' | Select-Object -Expand BaseName
            # Write-Host "disabled: $disabled"
             $disabled | where { $actual -NotContains $_ } | Should Be $disabled
        }

    } # / Context

    Context 'Exported aliases' {

        $exported = Get-Alias | Where-Object { $_.ModuleName -Eq 'PsModuleTemplate' } | Select-Object -Expand Name
        Write-Host "Aliases: $exported"

        It 'Exports aliases (if defined) for functions in the `Public` folder' {}

    } # / Context

 } # / Describe
