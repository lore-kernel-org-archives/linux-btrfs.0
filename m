Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-108-0-197-17.lsanca.fios.verizon.net ([108.0.197.17]:46566
	"EHLO orca4.orcaware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3BITgQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 14:36:16 -0500
Message-ID: <5116A1AC.7040300@orcaware.com>
Date: Sat, 09 Feb 2013 11:21:16 -0800
From: Blair Zajac <blair@orcaware.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: v3.8-rc6: btrfs-transacti Tainted: GF in btrfs_orphan_commit_root
Content-Type: multipart/mixed;
 boundary="------------000009040104080404080902"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000009040104080404080902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Running an Ubuntu Raring VM which was built a week ago that is now 
running 3.8-rc6, I was booting it last night when it hung.  After a few 
forced reboots, it came back up and I found the attached in kern.log.

Mostly, the VM has been used for testing anisble deployment, so not a 
lot of work, just upgrading and installing software, then rebooting.

Are these reports useful?  Is there any additional information I can 
provide from the VM?  What happens if it gets hung again, is there 
additional information I can gather?

Regards,
Blair


--------------000009040104080404080902
Content-Type: text/plain; charset=UTF-8;
 name="kern.log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kern.log.txt"

Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: imklog 5.8.11, log source = /proc/kmsg started.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Initializing cgroup subsys cpuset
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Initializing cgroup subsys cpu
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Linux version 3.8.0-5-generic (buildd@allspice) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-20ubuntu1) ) #10-Ubuntu SMP Thu Feb 7 17:57:08 UTC 2013 (Ubuntu 3.8.0-5.10-generic 3.8.0-rc6)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Command line: BOOT_IMAGE=/@/boot/vmlinuz-3.8.0-5-generic root=UUID=4f655e6c-5ddb-43e0-975a-10f817e73124 ro rootflags=subvol=@ console=tty1 console=ttyS0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] KERNEL supported cpus:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   Intel GenuineIntel
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   AMD AuthenticAMD
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   Centaur CentaurHauls
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] e820: BIOS-provided physical RAM map:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006ccfdfff] usable
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x000000006ccfe000-0x000000006ccfffff] reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] NX (Execute Disable) protection: active
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] SMBIOS 2.4 present.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Hypervisor detected: KVM
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] No AGP bridge found
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] e820: last_pfn = 0x6ccfe max_arch_pfn = 0x400000000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] MTRR default type: write-back
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] MTRR fixed ranges enabled:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   00000-9FFFF write-back
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   A0000-BFFFF uncachable
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   C0000-FFFFF write-protect
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] MTRR variable ranges enabled:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   1 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   2 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   3 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   4 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   5 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   6 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   7 disabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] found SMP MP-table at [mem 0x000fdaf0-0x000fdaff] mapped at [ffff8800000fdaf0]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] init_memory_mapping: [mem 0x00000000-0x6ccfdfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]  [mem 0x00000000-0x6cbfffff] page 2M
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]  [mem 0x6cc00000-0x6ccfdfff] page 4k
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] kernel direct mapping tables up to 0x6ccfdfff @ [mem 0x1fffc000-0x1fffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] RAMDISK: [mem 0x3730c000-0x3797dfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: RSDP 00000000000fd990 00014 (v00 BOCHS )
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: RSDT 000000006ccfe5b0 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: FACP 000000006ccfff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: DSDT 000000006ccfe5f0 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: FACS 000000006ccfff40 00040
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: SSDT 000000006ccffea0 0009E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: APIC 000000006ccffdb0 00078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: HPET 000000006ccffd70 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: SSDT 000000006ccff720 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] No NUMA configuration found
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000006ccfdfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Initmem setup node 0 [mem 0x00000000-0x6ccfdfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   NODE_DATA [mem 0x6ccf9000-0x6ccfdfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] kvm-clock: cpu 0, msr 0:6ccf5001, boot clock
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff88006a800000-ffff88006c3fffff] on node 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Zone ranges:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   Normal   empty
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Movable zone start for each node
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Early memory node ranges
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   node   0: [mem 0x00100000-0x6ccfdfff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] On node 0 totalpages: 445579
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA zone: 64 pages used for memmap
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA zone: 6 pages reserved
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA zone: 3911 pages, LIFO batch:0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA32 zone: 6900 pages used for memmap
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000]   DMA32 zone: 434698 pages, LIFO batch:31
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: PM-Timer IO Port: 0xb008
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ0 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ2 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ5 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ9 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ10 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: IRQ11 used by override.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] nr_irqs_gsi: 40
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] e820: [mem 0x6cd00000-0xfeffbfff] available for PCI devices
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Booting paravirtualized kernel on KVM
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:1 nr_node_ids:1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88006ca00000 s85056 r8192 d21440 u2097152
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] pcpu-alloc: s85056 r8192 d21440 u2097152 alloc=1*2097152
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] pcpu-alloc: [0] 0 
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] kvm-clock: cpu 0, msr 0:6ccf5001, primary cpu clock
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] KVM setup async PF for cpu 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] kvm-stealtime: cpu 0, msr 6ca0df40
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 438609
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Policy zone: DMA32
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Kernel command line: BOOT_IMAGE=/@/boot/vmlinuz-3.8.0-5-generic root=UUID=4f655e6c-5ddb-43e0-975a-10f817e73124 ro rootflags=subvol=@ console=tty1 console=ttyS0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] __ex_table already sorted, skipping sort
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Checking aperture...
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] No AGP bridge found
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Memory: 1730968k/1782776k available (6977k kernel code, 460k absent, 51348k reserved, 6262k data, 992k init)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Hierarchical RCU implementation.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=1.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] NR_IRQS:16640 nr_irqs:256 16
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] Console: colour VGA+ 80x25
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] console [tty1] enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] console [ttyS0] enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] allocated 7340032 bytes of page_cgroup
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] hpet clockevent registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.000000] tsc: Detected 3292.518 MHz processor
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008000] Calibrating delay loop (skipped) preset value.. 6585.03 BogoMIPS (lpj=13170072)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008000] pid_max: default: 32768 minimum: 301
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008000] Security Framework initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008000] AppArmor: AppArmor initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008000] Yama: becoming mindful.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.008122] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.010090] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.011493] Mount-cache hash table entries: 256
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.012160] Initializing cgroup subsys cpuacct
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.012754] Initializing cgroup subsys memory
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.013369] Initializing cgroup subsys devices
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.013984] Initializing cgroup subsys freezer
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.014592] Initializing cgroup subsys blkio
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.015178] Initializing cgroup subsys perf_event
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.016005] Initializing cgroup subsys hugetlb
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.016677] mce: CPU supports 10 MCE banks
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.017280] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.017280] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.017280] tlb_flushall_shift: 5
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.032152] Freeing SMP alternatives: 24k freed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.037284] ACPI: Core revision 20121018
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.038338] ftrace: allocating 26563 entries in 104 pages
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.044275] Enabling x2apic
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.044732] Enabled x2apic
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.045274] Switched APIC routing to physical x2apic.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.048784] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.049521] smpboot: CPU0: Intel Xeon E312xx (Sandy Bridge) (fam: 06, model: 2a, stepping: 01)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.050821] TSC deadline timer enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.050833] Performance Events: 16-deep LBR, SandyBridge events, Intel PMU driver.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052000] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052000] ... version:                2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052000] ... bit width:              48
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052000] ... generic registers:      8
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052000] ... value mask:             0000ffffffffffff
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052004] ... max period:             000000007fffffff
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.052730] ... fixed-purpose events:   3
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.053295] ... event mask:             00000007000000ff
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.054868] Brought up 1 CPUs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.055359] smpboot: Total of 1 processors activated (6585.03 BogoMIPS)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.056225] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.057768] devtmpfs: initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.058798] EVM: security.selinux
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.059307] EVM: security.SMACK64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.059801] EVM: security.capability
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.060615] regulator-dummy: no parameters
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.061260] NET: Registered protocol family 16
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.061996] ACPI: bus type pci registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.062635] PCI: Using configuration type 1 for base access
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.063904] bio: create slab <bio-0> at 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.064096] ACPI: Added _OSI(Module Device)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.064680] ACPI: Added _OSI(Processor Device)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.065265] ACPI: Added _OSI(3.0 _SCP Extensions)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.065920] ACPI: Added _OSI(Processor Aggregator Device)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.066900] ACPI: EC: Look up EC in DSDT
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.067729] ACPI: Interpreter enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.068005] ACPI: (supports S0 S3 S4 S5)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.068785] ACPI: Using IOAPIC for interrupt routing
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.071055] ACPI: No dock devices found.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.071600] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.072015] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.072779] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.072932] pci_root PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.074016] pci_root PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075071] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075073] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075074] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075075] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075076] PCI: root bus 00: using default resources
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.075078] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.076017] PCI host bridge to bus 0000:00
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.076581] pci_bus 0000:00: root bus resource [bus 00-ff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.077278] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.078030] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.078888] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.079107] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.079396] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.080851] pci 0000:00:01.1: reg 20: [io  0xc180-0xc18f]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.081485] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.082911] pci 0000:00:01.2: reg 20: [io  0xc140-0xc15f]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.083554] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.083806] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.084010] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.084948] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.087179] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.087858] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.090880] pci 0000:00:02.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.091024] pci 0000:00:03.0: [10ec:8139] type 00 class 0x020000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.091571] pci 0000:00:03.0: reg 10: [io  0xc000-0xc0ff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.092021] pci 0000:00:03.0: reg 14: [mem 0xfebf1000-0xfebf10ff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.094655] pci 0000:00:03.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.094739] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.095305] pci 0000:00:04.0: reg 10: [io  0xc100-0xc13f]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.095831] pci 0000:00:04.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.098519] pci 0000:00:05.0: [1af4:1002] type 00 class 0x00ff00
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.098823] pci 0000:00:05.0: reg 10: [io  0xc160-0xc17f]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.100777] ACPI _OSC control for PCIe not granted, disabling ASPM
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.103282] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.104311] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.105391] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.107138] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.108050] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.109212] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.110288] vgaarb: loaded
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.110719] vgaarb: bridge control possible 0000:00:02.0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.111599] SCSI subsystem initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.112008] ACPI: bus type scsi registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.112701] libata version 3.00 loaded.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.112732] ACPI: bus type usb registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.113317] usbcore: registered new interface driver usbfs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.114009] usbcore: registered new interface driver hub
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.114771] usbcore: registered new device driver usb
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.115554] PCI: Using ACPI for IRQ routing
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.116007] PCI: pci_cache_line_size set to 64 bytes
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.116120] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.116123] e820: reserve RAM buffer [mem 0x6ccfe000-0x6fffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.116273] NetLabel: Initializing
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.116777] NetLabel:  domain hash size = 128
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.117399] NetLabel:  protocols = UNLABELED CIPSOv4
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.118062] NetLabel:  unlabeled traffic allowed by default
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.118882] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.119762] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.120427] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.125089] Switching to clocksource kvm-clock
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.130467] AppArmor: AppArmor Filesystem Enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.131129] pnp: PnP ACPI init
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.131590] ACPI: bus type pnp registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132240] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132293] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132323] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132354] pnp 00:03: [dma 2]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132368] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132434] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132484] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132554] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.132633] pnp: PnP ACPI: found 7 devices
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.133188] ACPI: ACPI bus type pnp unregistered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.139430] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.139432] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.139480] NET: Registered protocol family 2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.140226] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.141326] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.142265] TCP: Hash tables configured (established 16384 bind 16384)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.143114] TCP: reno registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.143584] UDP hash table entries: 1024 (order: 3, 32768 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.144367] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.145202] NET: Registered protocol family 1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.145795] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.146528] pci 0000:00:01.0: PIIX3: Enabling Passive Release
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.147342] pci 0000:00:01.0: Activating ISA DMA hang workarounds
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.148216] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.149024] pci 0000:00:02.0: Boot video device
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.149049] PCI: CLS 0 bytes, default 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.149094] Trying to unpack rootfs image as initramfs...
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.240579] Freeing initrd memory: 6600k freed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.242143] Initialise module verification
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.242776] audit: initializing netlink socket (disabled)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.243485] type=2000 audit(1360388757.240:1): initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.263766] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.265600] VFS: Disk quotas dquot_6.5.2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.266172] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.267297] fuse init (API version 7.20)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.267910] msgmni has been set to 3393
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.268804] Key type asymmetric registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.269381] Asymmetric key parser 'x509' registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.270023] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.271018] io scheduler noop registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.271556] io scheduler deadline registered (default)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.272234] io scheduler cfq registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.272828] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.273534] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.274370] intel_idle: does not run on family 6 model 42
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.274414] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.275382] ACPI: Power Button [PWRF]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.276828] GHES: HEST is not enabled!
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.277438] virtio-pci 0000:00:04.0: setting latency timer to 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.277722] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.278464] virtio-pci 0000:00:05.0: setting latency timer to 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.278544] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.300328] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.322059] 00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.323676] Linux agpgart interface v0.103
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.325029] brd: module loaded
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.325886] loop: module loaded
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.326517] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.326532] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.327257]  vda: vda1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.328057] ata_piix 0000:00:01.1: version 2.13
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.328129] ata_piix 0000:00:01.1: setting latency timer to 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.328319] scsi0 : ata_piix
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.328817] scsi1 : ata_piix
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.329285] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc180 irq 14
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.330123] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc188 irq 15
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.331282] libphy: Fixed MDIO Bus: probed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.331889] tun: Universal TUN/TAP device driver, 1.6
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.332548] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.333333] PPP generic driver version 2.4.2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.333945] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.334735] ehci-pci: EHCI PCI platform driver
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.335324] ehci-platform: EHCI generic platform driver
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.335989] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.336919] uhci_hcd: USB Universal Host Controller Interface driver
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.337722] uhci_hcd 0000:00:01.2: setting latency timer to 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.337729] uhci_hcd 0000:00:01.2: UHCI Host Controller
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.338395] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.339433] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c140
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.340249] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.341109] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.342060] usb usb1: Product: UHCI Host Controller
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.342727] usb usb1: Manufacturer: Linux 3.8.0-5-generic uhci_hcd
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.343499] usb usb1: SerialNumber: 0000:00:01.2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.344177] hub 1-0:1.0: USB hub found
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.344739] hub 1-0:1.0: 2 ports detected
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.345379] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.346921] serio: i8042 KBD port at 0x60,0x64 irq 1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.347593] serio: i8042 AUX port at 0x60,0x64 irq 12
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.348359] mousedev: PS/2 mouse device common for all mice
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.349244] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.350549] rtc_cmos 00:00: RTC can wake from S4
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.351356] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.352242] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.353070] device-mapper: uevent: version 1.0.3
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.353759] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.354956] cpuidle: using governor ladder
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.355559] cpuidle: using governor menu
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.356279] ledtrig-cpu: registered to indicate activity on CPUs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.357338] EFI Variables Facility v0.08 2004-May-17
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.359189] ashmem: initialized
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.360557] TCP: cubic registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.361889] NET: Registered protocol family 10
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.363681] NET: Registered protocol family 17
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.364576] Key type dns_resolver registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.365305] Loading module verification certificates
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.366557] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 677238f4b6ace6b39124ea988bd25027b71e588d'
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.367838] registered taskstats version 1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.369846] Key type trusted registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.371558] Key type encrypted registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.373468] rtc_cmos 00:00: setting system clock to 2013-02-09 05:45:56 UTC (1360388756)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.374635] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.375430] EDD information not available.
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.494385] Freeing unused kernel memory: 992k freed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.496602] Write protecting the kernel read-only data: 12288k
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.502773] Freeing unused kernel memory: 1204k freed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.508564] Freeing unused kernel memory: 1112k freed
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.578739] Disabling lock debugging due to kernel taint
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.596568] 8139cp: 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.597707] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.619966] 8139cp 0000:00:03.0 eth0: RTL-8139C+ at 0xffffc9000039e000, fa:16:3e:1e:cc:5f, IRQ 11
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.621271] 8139cp 0000:00:03.0: setting latency timer to 64
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.628363] FDC 0 is a S82078B
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.630235] 8139too: 8139too Fast Ethernet driver 0.9.28
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.656115] usb 1-1: new full-speed USB device number 2 using uhci_hcd
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.955426] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.957462] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.959555] usb 1-1: Product: QEMU USB Tablet
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.960995] usb 1-1: Manufacturer: QEMU
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    0.962291] usb 1-1: SerialNumber: 42
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    1.240150] tsc: Refined TSC clocksource calibration: 3292.530 MHz
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    2.185779] Btrfs loaded
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    2.210190] device label cloudimg-rootfs devid 1 transid 13297 /dev/vda1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    2.219243] device label cloudimg-rootfs devid 1 transid 13297 /dev/disk/by-uuid/4f655e6c-5ddb-43e0-975a-10f817e73124
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    2.224035] btrfs: disk space caching is enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    5.464559] btrfs: use lzo compression
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    5.465196] btrfs: disk space caching is enabled
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    5.483476] btrfs: truncated 1 orphans
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    5.646047] device label cloudimg-rootfs devid 1 transid 13300 /dev/vda1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.042879] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458358] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458418] acpiphp: Slot [3] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458429] acpiphp: Slot [4] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458439] acpiphp: Slot [5] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458449] acpiphp: Slot [6] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458460] acpiphp: Slot [7] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458470] acpiphp: Slot [8] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458483] acpiphp: Slot [9] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458494] acpiphp: Slot [10] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458505] acpiphp: Slot [11] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458515] acpiphp: Slot [12] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458525] acpiphp: Slot [13] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458535] acpiphp: Slot [14] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458545] acpiphp: Slot [15] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458555] acpiphp: Slot [16] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458565] acpiphp: Slot [17] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458574] acpiphp: Slot [18] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458584] acpiphp: Slot [19] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458594] acpiphp: Slot [20] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458603] acpiphp: Slot [21] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458613] acpiphp: Slot [22] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458623] acpiphp: Slot [23] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458633] acpiphp: Slot [24] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458642] acpiphp: Slot [25] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458651] acpiphp: Slot [26] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458661] acpiphp: Slot [27] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458671] acpiphp: Slot [28] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458680] acpiphp: Slot [29] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458689] acpiphp: Slot [30] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.458700] acpiphp: Slot [31] registered
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.588828] microcode: CPU0 sig=0x206a1, pf=0x1, revision=0x1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.857323] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.967668] type=1400 audit(1360388764.088:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=549 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.967917] type=1400 audit(1360388764.088:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=549 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.968064] type=1400 audit(1360388764.092:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=549 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.968389] type=1400 audit(1360388764.092:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=545 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.968634] type=1400 audit(1360388764.092:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=545 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    7.968777] type=1400 audit(1360388764.092:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=545 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    8.030070] type=1400 audit(1360388764.152:8): apparmor="STATUS" operation="profile_load" name="/usr/sbin/ntpd" pid=561 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    8.030497] type=1400 audit(1360388764.152:9): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=562 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    8.380038] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [    8.529793] 8139cp 0000:00:03.0 eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   30.552106] type=1400 audit(1360388786.676:10): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=996 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   30.552360] type=1400 audit(1360388786.676:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=996 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   30.552489] type=1400 audit(1360388786.676:12): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=996 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   30.553743] type=1400 audit(1360388786.676:13): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/ntpd" pid=997 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   30.572531] type=1400 audit(1360388786.696:14): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=999 comm="apparmor_parser"
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372740] ------------[ cut here ]------------
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372766] WARNING: at /build/buildd/linux-3.8.0/fs/btrfs/inode.c:2214 btrfs_orphan_commit_root+0x10c/0x110 [btrfs]()
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372768] Hardware name: Bochs
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372770] Modules linked in: dm_crypt(F) microcode(F) virtio_balloon(F) psmouse(F) serio_raw(F) acpiphp(F) btrfs(F) zlib_deflate(F) libcrc32c(F) ghash_clmulni_intel(F) 8139too(F) aesni_intel(F) aes_x86_64(F) xts(F) lrw(F) gf128mul(F) ablk_helper(F) cryptd(F) floppy(F) 8139cp(F)
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372789] Pid: 274, comm: btrfs-transacti Tainted: GF            3.8.0-5-generic #10-Ubuntu
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372791] Call Trace:
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372813]  [<ffffffff8105879f>] warn_slowpath_common+0x7f/0xc0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372817]  [<ffffffff810587fa>] warn_slowpath_null+0x1a/0x20
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372831]  [<ffffffffa00b1cac>] btrfs_orphan_commit_root+0x10c/0x110 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372845]  [<ffffffffa010dabb>] commit_fs_roots.isra.24+0xad/0x171 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372860]  [<ffffffffa00fdb36>] ? btrfs_scrub_pause+0xf6/0x110 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372865]  [<ffffffff816c3c1e>] ? _raw_spin_lock+0xe/0x20
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372879]  [<ffffffffa00abd0d>] btrfs_commit_transaction+0x5bd/0xab0 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372882]  [<ffffffff8107dc00>] ? finish_wait+0x80/0x80
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372895]  [<ffffffffa00a4cfd>] transaction_kthread+0x1bd/0x240 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372906]  [<ffffffffa00a4b40>] ? write_dev_flush.part.107+0xc0/0xc0 [btrfs]
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372909]  [<ffffffff8107d2c0>] kthread+0xc0/0xd0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372913]  [<ffffffff8107d200>] ? kthread_create_on_node+0x120/0x120
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372917]  [<ffffffff816cc4ac>] ret_from_fork+0x7c/0xb0
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372920]  [<ffffffff8107d200>] ? kthread_create_on_node+0x120/0x120
Feb  8 21:47:06 server-1677db72-c446-46ae-8021-7f2594aa88cc kernel: [   37.372922] ---[ end trace b6a5be0adeb704db ]---

--------------000009040104080404080902--
