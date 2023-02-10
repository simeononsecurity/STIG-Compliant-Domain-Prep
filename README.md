
# STIG Compliant Domain Prep
*Import all the GPOs provided by SimeonOnSecurity to assist in making your domain compliant with all applicable STIGs and SRGs.*

[![VirusTotal Scan](https://github.com/simeononsecurity/STIG-Compliant-Domain-Prep/actions/workflows/virustotal.yml/badge.svg)](https://github.com/simeononsecurity/STIG-Compliant-Domain-Prep/actions/workflows/virustotal.yml)

**Note:** This script should work for most, if not all, systems without issue. While [@SimeonOnSecurity](https://github.com/simeononsecurity) creates, reviews, and tests each repo intensivly, we can not test every possible configuration nor does [@SimeonOnSecurity](https://github.com/simeononsecurity) take any responsibility for breaking your system. If something goes wrong, be prepared to submit an [issue](../../issues). Do not run this script if you don't understand what it does.

## Notes:

**This script is designed for use in Enterprise environments**

## Ansible:
We now offer a playbook collection for this script. Please see the following:
- [Github Repo](https://github.com/simeononsecurity/Windows_STIG_Ansible)
- [Ansible Galaxy](https://galaxy.ansible.com/simeononsecurity/windows_stigs)

## Additional configurations were considered from:
- [CERT - IE Scripting Engine Memory Corruption](https://kb.cert.org/vuls/id/573168/)
- [Dirteam - SSL Hardening](https://dirteam.com/sander/2019/07/30/howto-disable-weak-protocols-cipher-suites-and-hashing-algorithms-on-web-application-proxies-ad-fs-servers-and-windows-servers-running-azure-ad-connect/)
- [Microsoft - Managing Windows 10 Telemetry and Callbacks](https://docs.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services)
- [Microsoft - Specture and Meltdown Mitigations](https://support.microsoft.com/en-us/help/4072698/windows-server-speculative-execution-side-channel-vulnerabilities)
- [Microsoft - Windows 10 Privacy](https://docs.microsoft.com/en-us/windows/privacy/)
- [Microsoft - Windows 10 VDI Recomendations](https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds_vdi-recommendations-1909)
- [Microsoft - Windows Defender Application Control](https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/windows-defender-application-control-design-guide)
- [NSACyber - Application Whitelisting Using Microsoft AppLocker](https://apps.nsa.gov/iad/library/ia-guidance/tech-briefs/application-whitelisting-using-microsoft-applocker.cfm)
- [NSACyber - Hardware-and-Firmware-Security-Guidance](https://github.com/nsacyber/Hardware-and-Firmware-Security-Guidance)
- [Whonix - Disable TCP Timestamps](https://www.whonix.org/wiki/Disable_TCP_and_ICMP_Timestamps)

## STIGS/SRGs Applied:
- [Adobe Acrobat Pro DC Continuous V2R1](https://public.cyber.mil/stigs/downloads/)
- [Adobe Acrobat Reader DC Continuous V2R1](https://public.cyber.mil/stigs/downloads/)
- [Firefox V5R2](https://public.cyber.mil/stigs/downloads/) - **[Requires Separate Script](https://github.com/simeononsecurity/FireFox-STIG-Script)**
- [Google Chrome V2R4](https://public.cyber.mil/stigs/downloads/)
- [Internet Explorer 11 V1R19](https://public.cyber.mil/stigs/downloads/)
- [Microsoft Edge V1R2](https://public.cyber.mil/stigs/downloads/)
- [Microsoft .Net Framework 4 V1R9](https://public.cyber.mil/stigs/downloads/) - **[Requires Separate Script](https://github.com/simeononsecurity/.NET-STIG-Script)**
- [Microsoft Office 2013 V2R1](https://public.cyber.mil/stigs/downloads/)
- [Microsoft Office 2016 V2R1](https://public.cyber.mil/stigs/downloads/)
- [Microsoft Office 2019/Office 365 Pro Plus V2R3](https://public.cyber.mil/stigs/downloads/)
- [Microsoft OneDrive STIG V2R1](https://public.cyber.mil/stigs/downloads/)
- [Oracle JRE 8 V1R5](https://public.cyber.mil/stigs/downloads/) - **[Requires Separate Script](https://github.com/simeononsecurity/Oracle-JRE-8-STIG-Script)**
- [Windows 10 V2R2](https://public.cyber.mil/stigs/downloads/)
- [Windows Defender Antivirus V2R2](https://public.cyber.mil/stigs/downloads/) - **[Requires Separate Script](https://github.com/simeononsecurity/Windows-Defender-STIG-Script)**
- [Windows Firewall V1R7](https://public.cyber.mil/stigs/downloads/)
- [Windows Server 2012(R2) V3R2](https://public.cyber.mil/stigs/downloads/)
- [Windows Server 2016 V2R2](https://public.cyber.mil/stigs/downloads/)
- [Windows Server 2019 V2R2](https://public.cyber.mil/stigs/downloads/)
- [VMWare Horizon Agent V1R1](https://public.cyber.mil/stigs/downloads/)
- [VMWare Horizon Client V1R1](https://public.cyber.mil/stigs/downloads/)

## How to run the script:

**The script may be launched from the extracted GitHub download like this:**
```
.\sos-stig-compliant-domain-prep.ps1
```
The script we will be using must be launched from the directory containing all the other files from the [GitHub Repository](https://github.com/simeononsecurity/STIG-Compliant-Domain-Prep)


