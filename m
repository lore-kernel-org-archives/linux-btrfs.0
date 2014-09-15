Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:44186 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaIOPN5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:13:57 -0400
Message-ID: <5417022A.5000101@codethink.co.uk>
Date: Mon, 15 Sep 2014 16:13:46 +0100
From: Sam Thursfield <sam.thursfield@codethink.co.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: baserock-dev@baserock.org
Subject: Unable to mount multiple subvolumes of a single disk
Content-Type: multipart/mixed;
 boundary="------------090402070901030605080509"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090402070901030605080509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

I'm having an issue with the 3.17rc5 kernel which prevents having 
multiple subvolumes of the same disk mounted.

I'm not sure exactly the cause. I thought it might be because in my 
system the root file system is itself a subvolume of the disk I'm trying 
to mount. But if I create a second disk image with two subvolumes, the 
same thing occurs -- I can only mount one of them at a time.

I've attached the output of a few commands, please let me know if you 
want more info (I'm not subscribed to the list, please keep me in To:).

We've bisected and found that the exact commit that changed the 
behaviour is this one: 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b96de000bc8bc9688b3a2abea4332bd57648a49f

I'm afraid I'm not familiar with the Btrfs code base and so I don't 
understand the exact meaning of the comments in that commit.

Thanks
Sam

-- 
Sam Thursfield, Codethink Ltd.
Office telephone: +44 161 236 5575

--------------090402070901030605080509
Content-Type: text/plain; charset=UTF-8;
 name="btrfs-debug-log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-debug-log.txt"

$ btrfs subvolume list /
ID 257 gen 15 top level 5 path systems/factory/orig
ID 261 gen 15 top level 5 path state/var
ID 263 gen 11 top level 5 path state/opt
ID 264 gen 12 top level 5 path state/srv
ID 265 gen 13 top level 5 path state/root
ID 266 gen 14 top level 5 path state/home
ID 267 gen 23 top level 5 path systems/factory/run

$ cat /etc/fstab
# Morph default system layout
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  / btrfs defaults,rw,noatime 0 1
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  /var  btrfs subvol=/state/var,defaults,rw,noatime 0 2
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  /opt  btrfs subvol=/state/opt,defaults,rw,noatime 0 2
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  /srv  btrfs subvol=/state/srv,defaults,rw,noatime 0 2
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  /root  btrfs subvol=/state/root,defaults,rw,noatime 0 2
UUID=9a1b9724-d64c-4709-9ce0-b7ad98054385  /home  btrfs subvol=/state/home,defaults,rw,noatime 0 2

$ mount /dev/sda /home -t btrfs -o subvol=/state/home,defaults,rw,noatime
mount: /dev/vda is already mounted or /home busy
       /dev/vda is already mounted on /

$ uname -a
Linux baserock 3.17.0-rc3+ #1 SMP Fri Sep 12 10:59:05 UTC 2014 x86_64 GNU/Linux

$ btrfs --version
Btrfs v0.20-rc1-334-g304f215

$ btrfs fi show
Label: 'baserock'  uuid: 9a1b9724-d64c-4709-9ce0-b7ad98054385
	Total devices 1 FS bytes used 1.45GB
	devid    1 size 4.00GB used 2.06GB path /dev/vda

Btrfs v0.20-rc1-334-g304f215

$ btrfs fi df /
Data: total=1.63GB, used=1.38GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=204.75MB, used=68.46MB
Metadata: total=8.00MB, used=0.00
: total=24.00MB, used=0.00

$ mount
/dev/vda on / type btrfs (rw,noatime,space_cache)
devtmpfs on /dev type devtmpfs (rw,relatime,size=1023164k,nr_inodes=255791,mode=755)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/lib/systemd/systemd-cgroups-agent,name=systemd)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=24,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
tmpfs on /tmp type tmpfs (rw,relatime)

$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc3+ (root@sam-baserock-dev) (gcc version 4.7.3 (GCC) ) #1 SMP Fri Sep 12 10:59:05 UTC 2014
[    0.000000] Command line: rw init=/sbin/init rootfstype=btrfs rootflags=subvol=systems/default/run root=/dev/vda console=ttyS0 console=tty0 BOOT_IMAGE=/systems/default/kernel 
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: OpenStack Foundation OpenStack Nova, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7fffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] found SMP MP-table at [mem 0x000f0b50-0x000f0b5f] mapped at [ffff8800000f0b50]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x020f2000, 0x020f2fff] PGTABLE
[    0.000000] BRK [0x020f3000, 0x020f3fff] PGTABLE
[    0.000000] BRK [0x020f4000, 0x020f4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7fc00000-0x7fdfffff]
[    0.000000]  [mem 0x7fc00000-0x7fdfffff] page 2M
[    0.000000] BRK [0x020f5000, 0x020f5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7c000000-0x7fbfffff]
[    0.000000]  [mem 0x7c000000-0x7fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x7fe00000-0x7fffdfff]
[    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
[    0.000000] BRK [0x020f6000, 0x020f6fff] PGTABLE
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F09B0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000007FFFFB89 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000007FFFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000007FFFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x000000007FFFE000 000040
[    0.000000] ACPI: SSDT 0x000000007FFFF234 0008DD (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000007FFFFB11 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: RSDT 0x000000007FFFFB89 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffdfff]
[    0.000000]   NODE_DATA [mem 0x7fffa000-0x7fffdfff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d600000-ffff88007f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7fffdfff]
[    0.000000] On node 0 totalpages: 524188
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520190 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x80000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007fc00000 s79488 r8192 d22912 u2097152
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515975
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: rw init=/sbin/init rootfstype=btrfs rootflags=subvol=systems/default/run root=/dev/vda console=ttyS0 console=tty0 BOOT_IMAGE=/systems/default/kernel 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2046292K/2096752K available (10060K kernel code, 950K rwdata, 3184K rodata, 1092K init, 924K bss, 50460K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2399.991 MHz processor
[    0.003003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4799.98 BogoMIPS (lpj=2399991)
[    0.005004] pid_max: default: 32768 minimum: 301
[    0.006010] ACPI: Core revision 20140724
[    0.008521] ACPI: All ACPI Tables successfully acquired
[    0.010021] Security Framework initialized
[    0.011006] SELinux:  Initializing.
[    0.011945] SELinux:  Starting in permissive mode
[    0.012746] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013444] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.014199] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.015008] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes)
[    0.016164] Initializing cgroup subsys devices
[    0.017006] Initializing cgroup subsys freezer
[    0.019382] mce: CPU supports 10 MCE banks
[    0.020051] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.036809] Freeing SMP alternatives memory: 36K (ffffffff82000000 - ffffffff82009000)
[    0.038157] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.049647] smpboot: CPU0: Intel Xeon E312xx (Sandy Bridge) (fam: 06, model: 2a, stepping: 01)
[    0.052020] TSC deadline timer enabled
[    0.052042] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.
[    0.054811] x86: Booted up 1 node, 1 CPUs
[    0.055005] smpboot: Total of 1 processors activated (4799.98 BogoMIPS)
[    0.056298] devtmpfs: initialized
[    0.057369] xor: automatically using best checksumming function:
[    0.068004]    avx       : 20940.000 MB/sec
[    0.069104] RTC time: 14:42:06, date: 09/15/14
[    0.070101] NET: Registered protocol family 16
[    0.071128] cpuidle: using governor ladder
[    0.072006] cpuidle: using governor menu
[    0.073065] ACPI: bus type PCI registered
[    0.074097] PCI: Using configuration type 1 for base access
[    0.093004] raid6: sse2x1    6320 MB/s
[    0.111004] raid6: sse2x2    8097 MB/s
[    0.129008] raid6: sse2x4   10660 MB/s
[    0.130005] raid6: using algorithm sse2x4 (10660 MB/s)
[    0.131005] raid6: using ssse3x2 recovery algorithm
[    0.132042] ACPI: Added _OSI(Module Device)
[    0.133005] ACPI: Added _OSI(Processor Device)
[    0.134004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.135005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.137355] ACPI: Interpreter enabled
[    0.138010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.139933] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.141901] ACPI: (supports S0 S3 S4 S5)
[    0.142005] ACPI: Using IOAPIC for interrupt routing
[    0.143017] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.145652] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.146009] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.147009] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.148072] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.149024] PCI host bridge to bus 0000:00
[    0.150006] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.151005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.152005] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.153005] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.154006] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.155005] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.156005] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.157005] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.158044] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.158416] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.158942] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.161639] pci 0000:00:01.1: reg 0x20: [io  0xc0a0-0xc0af]
[    0.162672] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.163006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.164005] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.165005] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.166143] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
[    0.169006] pci 0000:00:01.2: reg 0x20: [io  0xc040-0xc05f]
[    0.170154] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.170560] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.171016] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.172206] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.173665] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.174706] pci 0000:00:02.0: reg 0x14: [mem 0xfebd0000-0xfebd0fff]
[    0.179677] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.179862] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.180609] pci 0000:00:03.0: reg 0x10: [io  0xc060-0xc07f]
[    0.181595] pci 0000:00:03.0: reg 0x14: [mem 0xfebd1000-0xfebd1fff]
[    0.186608] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.186941] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.187629] pci 0000:00:04.0: reg 0x10: [io  0xc000-0xc03f]
[    0.188617] pci 0000:00:04.0: reg 0x14: [mem 0xfebd2000-0xfebd2fff]
[    0.193912] pci 0000:00:05.0: [1af4:1002] type 00 class 0x00ff00
[    0.194335] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc09f]
[    0.198228] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.200102] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.202099] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.204095] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.206057] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.208000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.208085] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.209005] vgaarb: loaded
[    0.209967] vgaarb: bridge control possible 0000:00:02.0
[    0.210059] SCSI subsystem initialized
[    0.211036] libata version 3.00 loaded.
[    0.211067] ACPI: bus type USB registered
[    0.212023] usbcore: registered new interface driver usbfs
[    0.213017] usbcore: registered new interface driver hub
[    0.214026] usbcore: registered new device driver usb
[    0.215039] pps_core: LinuxPPS API ver. 1 registered
[    0.216005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.217012] PTP clock support registered
[    0.218072] Advanced Linux Sound Architecture Driver Initialized.
[    0.219007] PCI: Using ACPI for IRQ routing
[    0.220004] PCI: pci_cache_line_size set to 64 bytes
[    0.220153] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.220155] e820: reserve RAM buffer [mem 0x7fffe000-0x7fffffff]
[    0.220334] cfg80211: Calling CRDA to update world regulatory domain
[    0.221025] NetLabel: Initializing
[    0.222005] NetLabel:  domain hash size = 128
[    0.223004] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.224019] NetLabel:  unlabeled traffic allowed by default
[    0.225087] Switched to clocksource refined-jiffies
[    0.230315] pnp: PnP ACPI init
[    0.231060] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.231099] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.231131] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.231166] pnp 00:03: [dma 2]
[    0.231174] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.231247] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.231299] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.231448] pnp: PnP ACPI: found 6 devices
[    0.237425] Switched to clocksource acpi_pm
[    0.238256] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.238258] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.238259] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.238260] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.238262] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.238263] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.238264] pci_bus 0000:00: resource 10 [mem 0x80000000-0xfebfffff]
[    0.238283] NET: Registered protocol family 2
[    0.239668] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.242563] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.244172] TCP: Hash tables configured (established 16384 bind 16384)
[    0.245765] TCP: reno registered
[    0.246841] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.248421] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.250056] NET: Registered protocol family 1
[    0.251371] RPC: Registered named UNIX socket transport module.
[    0.252875] RPC: Registered udp transport module.
[    0.254163] RPC: Registered tcp transport module.
[    0.255446] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.257084] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.258587] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.260068] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.261823] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.263713] pci 0000:00:02.0: Boot video device
[    0.263750] PCI: CLS 0 bytes, default 64
[    0.272131] microcode: CPU0 sig=0x206a1, pf=0x1, revision=0x1
[    0.273633] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.276097] Scanning for low memory corruption every 60 seconds
[    0.277823] futex hash table entries: 256 (order: 2, 16384 bytes)
[    0.279358] audit: initializing netlink subsys (disabled)
[    0.280788] audit: type=2000 audit(1410792126.280:1): initialized
[    0.282537] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.285212] VFS: Disk quotas dquot_6.5.2
[    0.286429] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.288469] NFS: Registering the id_resolver key type
[    0.289834] Key type id_resolver registered
[    0.291047] Key type id_legacy registered
[    0.292260] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.293884] 9p: Installing v9fs 9p2000 file system support
[    0.295352] ceph: loaded (mds proto 32)
[    0.296550] msgmni has been set to 3996
[    0.297797] SELinux:  Registering netfilter hooks
[    0.297936] cryptomgr_test (26) used greatest stack depth: 15080 bytes left
[    0.299830] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.301988] io scheduler noop registered
[    0.303179] io scheduler deadline registered
[    0.304466] io scheduler cfq registered (default)
[    0.305822] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.307326] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.309547] ACPI: Power Button [PWRF]
[    0.311146] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.314435] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.316768] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.347911] 00:04: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.379689] 00:05: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    0.382129] Non-volatile memory driver v1.3
[    0.383383] Linux agpgart interface v0.103
[    0.384676] [drm] Initialized drm 1.1.0 20060810
[    0.386381] loop: module loaded
[    0.387605] virtio-pci 0000:00:04.0: irq 24 for MSI/MSI-X
[    0.387623] virtio-pci 0000:00:04.0: irq 25 for MSI/MSI-X
[    0.391516]  vda: unknown partition table
[    0.393672] ata_piix 0000:00:01.1: version 2.13
[    0.394696] scsi host0: ata_piix
[    0.395897] scsi host1: ata_piix
[    0.397052] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0a0 irq 14
[    0.398686] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0a8 irq 15
[    0.400665] tun: Universal TUN/TAP device driver, 1.6
[    0.402033] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.404095] virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
[    0.404114] virtio-pci 0000:00:03.0: irq 27 for MSI/MSI-X
[    0.404131] virtio-pci 0000:00:03.0: irq 28 for MSI/MSI-X
[    0.464262] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.465796] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.467218] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.468897] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.470403] sky2: driver version 1.30
[    0.471669] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.473263] ehci-pci: EHCI PCI platform driver
[    0.474530] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.476074] ohci-pci: OHCI PCI platform driver
[    0.477346] uhci_hcd: USB Universal Host Controller Interface driver
[    0.479958] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    0.481387] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    0.483630] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c040
[    0.485169] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    0.486849] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.489068] usb usb1: Product: UHCI Host Controller
[    0.490471] usb usb1: Manufacturer: Linux 3.17.0-rc3+ uhci_hcd
[    0.491968] usb usb1: SerialNumber: 0000:00:01.2
[    0.493422] hub 1-0:1.0: USB hub found
[    0.494645] hub 1-0:1.0: 2 ports detected
[    0.495977] usbcore: registered new interface driver usblp
[    0.497524] usbcore: registered new interface driver usb-storage
[    0.499084] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.502218] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.503628] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.505082] mousedev: PS/2 mouse device common for all mice
[    0.506764] rtc_cmos 00:00: RTC can wake from S4
[    0.508394] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.510172] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram
[    0.511858] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.514341] hidraw: raw HID events driver (C) Jiri Kosina
[    0.515953] usbcore: registered new interface driver usbhid
[    0.517428] usbhid: USB HID core driver
[    0.518862] Netfilter messages via NETLINK v0.30.
[    0.520276] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.521968] ctnetlink v0.93: registering with nfnetlink.
[    0.523557] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.525061] TCP: cubic registered
[    0.526187] Initializing XFRM netlink socket
[    0.527667] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.531970] NET: Registered protocol family 10
[    0.533535] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.535094] sit: IPv6 over IPv4 tunneling driver
[    0.536545] NET: Registered protocol family 17
[    0.537969] Bridge firewalling registered
[    0.539237] 9pnet: Installing 9P2000 support
[    0.540570] Key type dns_resolver registered
[    0.541867] kworker/u2:2 (50) used greatest stack depth: 14792 bytes left
[    0.543592] Key type ceph registered
[    0.544811] libceph: loaded (mon/osd proto 15/24)
[    0.546342] registered taskstats version 1
[    0.547893] Btrfs loaded
[    0.549241]   Magic number: 14:314:738
[    0.550528] console [netcon0] enabled
[    0.551672] netconsole: network logging started
[    0.553288] PM: Hibernation image not present or could not be loaded.
[    0.553291] ALSA device list:
[    0.554370]   No soundcards found.
[    0.797103] usb 1-1: new full-speed USB device number 2 using uhci_hcd
[    0.948422] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
[    0.950151] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
[    0.951899] usb 1-1: Product: QEMU USB Tablet
[    0.953153] usb 1-1: Manufacturer: QEMU
[    0.954473] usb 1-1: SerialNumber: 42
[    0.964704] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input4
[    0.967624] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU QEMU USB Tablet] on usb-0000:00:01.2-1/input0
[    1.132193] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    1.134822] md: Waiting for all devices to be available before autodetect
[    1.136633] md: If you don't use raid, use raid=noautodetect
[    1.138709] md: Autodetecting RAID arrays.
[    1.140003] md: Scanned 0 and added 0 devices.
[    1.141361] md: autorun ...
[    1.142422] md: ... autorun DONE.
[    1.143753] BTRFS: device label baserock devid 1 transid 18 /dev/root
[    1.145894] BTRFS info (device vda): disk space caching is enabled
[    1.151703] VFS: Mounted root (btrfs filesystem) on device 0:15.
[    1.153433] devtmpfs: mounted
[    1.155303] Freeing unused kernel memory: 1092K (ffffffff81eef000 - ffffffff82000000)
[    1.157683] Write protecting the kernel read-only data: 14336k
[    1.159653] Freeing unused kernel memory: 168K (ffff8800019d6000 - ffff880001a00000)
[    1.163975] Freeing unused kernel memory: 912K (ffff880001d1c000 - ffff880001e00000)
[    1.193889] systemd[1]: systemd 204 running in system mode. (-PAM -LIBWRAP -AUDIT -SELINUX +IMA +SYSVINIT -LIBCRYPTSETUP -GCRYPT -ACL +XZ)
[    1.197176] systemd[1]: Detected virtualization 'kvm'.
[    1.201515] systemd[1]: Set hostname to <baserock>.
[    1.203098] systemd[1]: Initializing machine ID from KVM UUID.
[    1.205665] random: systemd urandom read with 6 bits of entropy available
[    1.212588] systemd-efi-boo (76) used greatest stack depth: 12136 bytes left
[    1.215185] systemd-rc-loca (77) used greatest stack depth: 11880 bytes left
[    1.218571] systemd-fstab-g (78) used greatest stack depth: 11528 bytes left
[    1.254748] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory. See system logs and 'systemctl status display-manager.service' for details.
[    1.268583] tsc: Refined TSC clocksource calibration: 2399.998 MHz
[    1.273508] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    1.276712] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    1.279190] systemd[1]: Starting Remote File Systems.
[    1.282906] systemd[1]: Reached target Remote File Systems.
[    1.284474] systemd[1]: Starting Delayed Shutdown Socket.
[    1.287455] systemd[1]: Listening on Delayed Shutdown Socket.
[    1.289077] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    1.292311] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    1.294142] systemd[1]: Starting udev Kernel Socket.
[    1.297051] systemd[1]: Listening on udev Kernel Socket.
[    1.298678] systemd[1]: Starting udev Control Socket.
[    1.301605] systemd[1]: Listening on udev Control Socket.
[    1.303123] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    1.305618] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    1.307978] systemd[1]: Starting Paths.
[    1.310585] systemd[1]: Reached target Paths.
[    1.311995] systemd[1]: Starting Arbitrary Executable File Formats File System Automount Point.
[    1.316074] systemd[1]: Set up automount Arbitrary Executable File Formats File System Automount Point.
[    1.318739] systemd[1]: Starting Journal Socket.
[    1.321586] systemd[1]: Listening on Journal Socket.
[    1.323154] systemd[1]: Starting Create static device nodes in /dev...
[    1.326416] systemd[1]: Mounting POSIX Message Queue File System...
[    1.332631] systemd[1]: Starting Setup Virtual Console...
[    1.341610] systemd[1]: Mounting Debug File System...
[    1.348310] systemd[1]: Started Load Kernel Modules.
[    1.350231] systemd[1]: Mounted Configuration File System.
[    1.352476] systemd[1]: Starting Apply Kernel Variables...
[    1.356229] systemd[1]: Started Set Up Additional Binary Formats.
[    1.359053] systemd[1]: Mounted FUSE Control File System.
[    1.360639] systemd[1]: Starting udev Coldplug all Devices...
[    1.364334] systemd[1]: Mounting Huge Pages File System...
[    1.372513] systemd[1]: Starting Journal Service...
[    1.384757] systemd[1]: Started Journal Service.
[    1.386293] systemd[1]: Starting Swap.
[    1.387659] systemd-journald[95]: Failed to resolve 'systemd-journal' group: No such process
[    1.393138] systemd[1]: Reached target Swap.
[    1.396090] systemd[1]: Started File System Check on Root Device.
[    1.397701] systemd[1]: Starting Remount Root and Kernel File Systems...
[    1.405478] systemd[1]: Mounting Temporary Directory...
[    1.411351] systemd[1]: Expecting device dev-disk-by\x2duuid-9a1b9724\x2dd64c\x2d4709\x2d9ce0\x2db7ad98054385.device...
[    1.423639] systemd[1]: Started Create static device nodes in /dev.
[    1.430053] systemd[1]: Mounted POSIX Message Queue File System.
[    1.436159] systemd[1]: Started Setup Virtual Console.
[    1.444160] systemd[1]: Mounted Debug File System.
[    1.449693] systemd[1]: Started Apply Kernel Variables.
[    1.457095] systemd[1]: Mounted Huge Pages File System.
[    1.461343] systemd[1]: Mounted Temporary Directory.
[    1.464946] systemd[1]: Started udev Coldplug all Devices.
[    1.466623] systemd[1]: Starting udev Kernel Device Manager...
[    2.270180] Switched to clocksource tsc
[    9.744200] systemd-udevd[102]: starting version 204
[    9.748662] systemd[1]: Started udev Kernel Device Manager.
[   16.004394] BTRFS info (device vda): disk space caching is enabled
[   16.007678] mount (97) used greatest stack depth: 11304 bytes left
[   16.082584] systemd[1]: Unit opt.mount entered failed state.
[   16.113177] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
[   16.115485] systemd[1]: Unit home.mount entered failed state.
[   16.120092] systemd[1]: root.mount mount process exited, code=exited status=32
[   16.128351] systemd[1]: Unit opt.mount entered failed state.
[   16.128393] systemd[1]: var.mount mount process exited, code=exited status=32
[   16.128485] systemd[1]: Unit var.mount entered failed state.
[   21.159134] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
[   21.161644] systemd[1]: Unit root.mount entered failed state.
[   21.165424] systemd[1]: opt.mount mount process exited, code=exited status=32
[   21.170345] systemd[1]: Unit srv.mount entered failed state.
[   32.912297] random: nonblocking pool is initialized
[   42.752208] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
[   42.754685] systemd[1]: Unit root.mount entered failed state.
[   42.759086] systemd[1]: opt.mount mount process exited, code=exited status=32
[   42.763185] systemd[1]: home.mount mount process exited, code=exited status=32
[   47.779066] systemd[1]: root.mount mount process exited, code=exited status=32
[   47.782139] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
[   47.788300] systemd[1]: Unit root.mount entered failed state.


--------------090402070901030605080509--
