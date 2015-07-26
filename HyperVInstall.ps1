# This script configures the Hyper-V machines used for the 50331 Course.
# PowerShell 3.0 and Windows Server 2012 or Windows 8 Pro are required to perform this setup.
# The C:\ Drive should have at least 200GB of free space available.
# All the files on the 50331 Student CD should be copied to C:\Labfiles before performing this setup.

# Variables
$CLI1 = "50331-CUSTOM-CLI"		# Name of VM running Client Operating System
$CRAM = 2GB				                # RAM assigned to Client Operating System
$CLI1VHD = 80GB				                # Size of Hard-Drive for Client Operating System
$VMLOC = "C:\HyperV"			        # Location of the VM and VHDX files
$NetworkSwitch1 = "PrivateSwitch1"	# Name of the Network Switch
$W7ISO = "C:\Labfiles\Windows7.iso"	# Windows 7 ISO
$W7VFD = "C:\Labfiles\Windows7.vfd"	# Windows 7 Virtual Floppy Disk with autounattend.xml file
$WSISO = "C:\Labfiles\W2K8R2.iso"	        # Windows Server 2008 ISO
$WSVFD = "C:\Labfiles\W2K8R2.vfd"	# Windows Server 2008 Virtual Floppy Disk with autounattend.xml file

Get-VMSwitch
# sysprep /generalize /unattend:C:\MyAnswerFile.xml --- XML file for unattended install 
$dir = new-item -Path F:\VirtualMachines\IIS -ItemType d -Force
new-vm -Name IIS -MemoryStartupBytes 512MB -BootDevice vhd -VHDPath F:\VirtualMachines\BaseIIS\base.vhdx -SwitchName "Virtual network" -Path $dir -Generation 2