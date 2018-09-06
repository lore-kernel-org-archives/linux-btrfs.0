Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:54298 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeIFUkS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 16:40:18 -0400
Received: by mail-wm0-f53.google.com with SMTP id c14-v6so11935759wmb.4
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 09:04:05 -0700 (PDT)
Subject: Re: btrfs send hung in pipe_wait
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com>
 <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
 <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
From: =?UTF-8?Q?Stefan_L=c3=b6wen?= <stefan.loewen@gmail.com>
Message-ID: <090f8da0-c29c-da5f-6e5b-ec6961706508@gmail.com>
Date: Thu, 6 Sep 2018 18:03:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------CED04A9294F52A21A72D390E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------CED04A9294F52A21A72D390E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I have one subvolume (rw) and 2 snapshots (ro) of it.

I just tested 'btrfs send <subvol> > /dev/null' and that also shows no 
IO after a while but also no significant CPU usage.
During this I tried 'ls' on the source subvolume and it hangs as well.
dmesg has some interesting messages I think (see attached dmesg.log)


On 9/6/18 5:48 PM, Chris Murphy wrote:
> On Thu, Sep 6, 2018 at 9:04 AM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
>> Update:
>> It seems like btrfs-send is not completely hung. It somewhat regularly
>> wakes up every hour to transfer a few bytes. I noticed this via a
>> periodic 'ls -l' on the snapshot file. These are the last outputs
>> (uniq'ed):
>>
>> -rw------- 1 root root 1492797759 Sep  6 08:44 intenso_white.snapshot
>> -rw------- 1 root root 1493087856 Sep  6 09:44 intenso_white.snapshot
>> -rw------- 1 root root 1773825308 Sep  6 10:44 intenso_white.snapshot
>> -rw------- 1 root root 1773976853 Sep  6 11:58 intenso_white.snapshot
>> -rw------- 1 root root 1774122301 Sep  6 12:59 intenso_white.snapshot
>> -rw------- 1 root root 1774274264 Sep  6 13:58 intenso_white.snapshot
>> -rw------- 1 root root 1774435235 Sep  6 14:57 intenso_white.snapshot
>>
>> I also monitor the /proc/3022/task/*/stack files with 'tail -f' (I
>> have no idea if this is useful) but there are no changes, even during
>> the short wakeups.
> I have a sort of "me too" here. I definitely see btrfs send just hang
> for no apparent reason, but in my case it's for maybe 15-30 seconds.
> Not an hour. Looking at top and iotop at the same time as the LED
> lights on the drives, there's  definitely zero activity happening. I
> can make things happen during this time - like I can read a file or
> save a file from/to any location including the send source or receive
> destination. It really just behaves as if the send thread is saying
> "OK I'm gonna nap now, back in a bit" and then it is.
>
> So what I end up with on drives with a minimum read-write of 80M/s, is
> a send receive that's getting me a net of about 30M/s.
>
> I have around 100 snapshots on the source device. How many total
> snapshots do you have on your source? That does appear to affect
> performance for some things, including send/receive.
>
>

--------------CED04A9294F52A21A72D390E
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Linux version 4.18.5-arch1-1-ARCH (builduser@heftig-12250) (gcc version 8.2.0 (GCC)) #1 SMP PREEMPT Fri Aug 24 12:48:58 UTC 2018
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=a83c9650-c8f8-4afe-90a6-4e80156d523d rw quiet
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dffeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfff0000-0x00000000dfffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR variable ranges disabled:
[    0.000000] Disabled
[    0.000000] x86/PAT: MTRRs disabled, skipping PAT initialization too.
[    0.000000] CPU MTRRs all blank - virtualized system.
[    0.000000] x86/PAT: Configuration [0-7]: WB  WT  UC- UC  WB  WT  UC- UC  
[    0.000000] last_pfn = 0xdfff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x0009fff0-0x0009ffff] mapped at [(____ptrval____)]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [(____ptrval____)] 99000 size 24576
[    0.000000] BRK [0x115a77000, 0x115a77fff] PGTABLE
[    0.000000] BRK [0x115a78000, 0x115a78fff] PGTABLE
[    0.000000] BRK [0x115a79000, 0x115a79fff] PGTABLE
[    0.000000] BRK [0x115a7a000, 0x115a7afff] PGTABLE
[    0.000000] BRK [0x115a7b000, 0x115a7bfff] PGTABLE
[    0.000000] BRK [0x115a7c000, 0x115a7cfff] PGTABLE
[    0.000000] BRK [0x115a7d000, 0x115a7dfff] PGTABLE
[    0.000000] BRK [0x115a7e000, 0x115a7efff] PGTABLE
[    0.000000] BRK [0x115a7f000, 0x115a7ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3712d000-0x3788dfff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000E0000 000024 (v02 VBOX  )
[    0.000000] ACPI: XSDT 0x00000000DFFF0030 00003C (v01 VBOX   VBOXXSDT 00000001 ASL  00000061)
[    0.000000] ACPI: FACP 0x00000000DFFF00F0 0000F4 (v04 VBOX   VBOXFACP 00000001 ASL  00000061)
[    0.000000] ACPI: DSDT 0x00000000DFFF0470 0021FF (v02 VBOX   VBOXBIOS 00000002 INTL 20180629)
[    0.000000] ACPI: FACS 0x00000000DFFF0200 000040
[    0.000000] ACPI: FACS 0x00000000DFFF0200 000040
[    0.000000] ACPI: APIC 0x00000000DFFF0240 00005C (v02 VBOX   VBOXAPIC 00000001 ASL  00000061)
[    0.000000] ACPI: SSDT 0x00000000DFFF02A0 0001CC (v01 VBOX   VBOXCPUT 00000002 INTL 20180629)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x11fffc000-0x11fffffff]
[    0.000000] kvm-clock: cpu 0, msr 1:1fff6001, primary cpu clock
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: using sched offset of 4903144421 cycles
[    0.000000] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x00000000dffeffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x000000011fffffff]
[    0.000000] Reserved but unavailable: 114 pages
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000011fffffff]
[    0.000000] On node 0 totalpages: 1048462
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913392 pages, LIFO batch:31
[    0.000000]   Normal zone: 2048 pages used for memmap
[    0.000000]   Normal zone: 131072 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfff0000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] [mem 0xe0000000-0xfebfffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] random: get_random_bytes called from start_kernel+0x95/0x535 with crng_init=0
[    0.000000] setup_percpu: NR_CPUS:320 nr_cpumask_bits:320 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] percpu: Embedded 46 pages/cpu @(____ptrval____) s151552 r8192 d28672 u1048576
[    0.000000] pcpu-alloc: s151552 r8192 d28672 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] PV qspinlock hash table entries: 256 (order: 0, 4096 bytes)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 1032057
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=a83c9650-c8f8-4afe-90a6-4e80156d523d rw quiet
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 4031204K/4193848K available (10252K kernel code, 1297K rwdata, 3528K rodata, 1492K init, 612K bss, 162644K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Kernel/User page tables isolation: enabled
[    0.000000] ftrace: allocating 33395 entries in 131 pages
[    0.003333] Preemptible hierarchical RCU implementation.
[    0.003333] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.003333] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.003333] 	RCU restricting CPUs from NR_CPUS=320 to nr_cpu_ids=2.
[    0.003333] 	RCU priority boosting: priority 1 delay 500 ms.
[    0.003333] 	Tasks RCU enabled.
[    0.003333] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.003333] NR_IRQS: 20736, nr_irqs: 440, preallocated irqs: 16
[    0.003333] 	Offload RCU callbacks from CPUs: (none).
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] ACPI: Core revision 20180531
[    0.003333] APIC: Switch to symmetric I/O mode setup
[    0.003333] x2apic enabled
[    0.003333] Switched APIC routing to physical x2apic.
[    0.003333] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.003333] tsc: Detected 2593.992 MHz processor
[    0.003333] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x25641074d3b, max_idle_ns: 440795244898 ns
[    0.003333] Calibrating delay loop (skipped) preset value.. 5190.15 BogoMIPS (lpj=8646640)
[    0.003333] pid_max: default: 32768 minimum: 301
[    0.003333] Security Framework initialized
[    0.003333] Yama: becoming mindful.
[    0.003570] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004426] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004459] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004470] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.004756] mce: CPU supports 0 MCE banks
[    0.004773] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.004774] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.004776] Spectre V2 : Mitigation: Full generic retpoline
[    0.004776] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch
[    0.004777] Speculative Store Bypass: Vulnerable
[    0.004874] Freeing SMP alternatives memory: 28K
[    0.006666] smpboot: CPU0: Intel(R) Core(TM) i5-4310U CPU @ 2.00GHz (family: 0x6, model: 0x45, stepping: 0x1)
[    0.023376] Performance Events: unsupported p6 CPU model 69 no PMU driver, software events only.
[    0.030018] Hierarchical SRCU implementation.
[    0.044001] NMI watchdog: Perf event create on CPU 0 failed with -2
[    0.044003] NMI watchdog: Perf NMI watchdog permanently disabled
[    0.056691] smp: Bringing up secondary CPUs ...
[    0.096721] x86: Booting SMP configuration:
[    0.096726] .... node  #0, CPUs:      #1
[    0.003333] kvm-clock: cpu 1, msr 1:1fff6041, secondary cpu clock
[    0.003333] mce: CPU supports 0 MCE banks
[    0.099496] smp: Brought up 1 node, 2 CPUs
[    0.099496] smpboot: Max logical packages: 1
[    0.099496] smpboot: Total of 2 processors activated (10380.30 BogoMIPS)
[    0.100155] devtmpfs: initialized
[    0.100155] x86/mm: Memory block size: 128MB
[    0.100565] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.100565] futex hash table entries: 512 (order: 3, 32768 bytes)
[    0.100565] pinctrl core: initialized pinctrl subsystem
[    0.100565] RTC time: 15:48:04, date: 09/06/18
[    0.100565] NET: Registered protocol family 16
[    0.100565] audit: initializing netlink subsys (disabled)
[    0.100565] audit: type=2000 audit(1536248891.398:1): state=initialized audit_enabled=0 res=1
[    0.100565] cpuidle: using governor ladder
[    0.100565] cpuidle: using governor menu
[    0.100565] ACPI: bus type PCI registered
[    0.100565] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.100565] PCI: Using configuration type 1 for base access
[    0.101195] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.101195] ACPI: Added _OSI(Module Device)
[    0.101195] ACPI: Added _OSI(Processor Device)
[    0.101195] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.101195] ACPI: Added _OSI(Processor Aggregator Device)
[    0.101195] ACPI: Added _OSI(Linux-Dell-Video)
[    0.106958] ACPI: 2 ACPI AML tables successfully acquired and loaded
[    0.111640] ACPI: Interpreter enabled
[    0.111652] ACPI: (supports S0 S5)
[    0.111653] ACPI: Using IOAPIC for interrupt routing
[    0.111886] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.112007] ACPI: Enabled 2 GPEs in block 00 to 07
[    0.116829] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.116833] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.116851] acpi PNP0A03:00: _OSC: not requesting OS control; OS requires [ExtendedConfig ASPM ClockPM MSI]
[    0.116859] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.117159] PCI host bridge to bus 0000:00
[    0.117161] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
[    0.117163] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
[    0.117164] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
[    0.117165] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfdffffff window]
[    0.117167] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.117199] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.118042] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.118603] pci 0000:00:01.1: [8086:7111] type 00 class 0x01018a
[    0.118932] pci 0000:00:01.1: reg 0x20: [io  0xd000-0xd00f]
[    0.119062] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.119063] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.119064] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.119065] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.119506] pci 0000:00:02.0: [80ee:beef] type 00 class 0x030000
[    0.120267] pci 0000:00:02.0: reg 0x10: [mem 0xe0000000-0xe07fffff pref]
[    0.141342] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.143476] pci 0000:00:03.0: reg 0x10: [mem 0xf0000000-0xf001ffff]
[    0.150098] pci 0000:00:03.0: reg 0x18: [io  0xd010-0xd017]
[    0.160890] pci 0000:00:04.0: [80ee:cafe] type 00 class 0x088000
[    0.163493] pci 0000:00:04.0: reg 0x10: [io  0xd020-0xd03f]
[    0.166746] pci 0000:00:04.0: reg 0x14: [mem 0xf0400000-0xf07fffff]
[    0.170071] pci 0000:00:04.0: reg 0x18: [mem 0xf0800000-0xf0803fff pref]
[    0.180657] pci 0000:00:05.0: [8086:2415] type 00 class 0x040100
[    0.180816] pci 0000:00:05.0: reg 0x10: [io  0xd100-0xd1ff]
[    0.180900] pci 0000:00:05.0: reg 0x14: [io  0xd200-0xd23f]
[    0.181967] pci 0000:00:07.0: [8086:7113] type 00 class 0x068000
[    0.183532] pci 0000:00:07.0: quirk: [io  0x4000-0x403f] claimed by PIIX4 ACPI
[    0.183540] pci 0000:00:07.0: quirk: [io  0x4100-0x410f] claimed by PIIX4 SMB
[    0.184839] pci 0000:00:0c.0: [8086:1e31] type 00 class 0x0c0330
[    0.186796] pci 0000:00:0c.0: reg 0x10: [mem 0xf0810000-0xf081ffff]
[    0.209673] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 *11)
[    0.209968] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 *10 11)
[    0.210051] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 *9 10 11)
[    0.210144] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 10 *11)
[    0.210380] pci 0000:00:02.0: vgaarb: setting as boot VGA device
[    0.210380] pci 0000:00:02.0: vgaarb: VGA device added: decodes=io+mem,owns=io+mem,locks=none
[    0.210380] pci 0000:00:02.0: vgaarb: bridge control possible
[    0.210380] vgaarb: loaded
[    0.210380] pps_core: LinuxPPS API ver. 1 registered
[    0.210380] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.210380] PTP clock support registered
[    0.210380] EDAC MC: Ver: 3.0.0
[    0.210399] PCI: Using ACPI for IRQ routing
[    0.210399] PCI: pci_cache_line_size set to 64 bytes
[    0.210399] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.210399] e820: reserve RAM buffer [mem 0xdfff0000-0xdfffffff]
[    0.210399] NetLabel: Initializing
[    0.210399] NetLabel:  domain hash size = 128
[    0.210399] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
[    0.210821] NetLabel:  unlabeled traffic allowed by default
[    0.210867] clocksource: Switched to clocksource kvm-clock
[    0.221523] VFS: Disk quotas dquot_6.6.0
[    0.221540] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.221613] pnp: PnP ACPI init
[    0.221685] pnp 00:00: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.221750] pnp 00:01: Plug and Play ACPI device, IDs PNP0f03 (active)
[    0.222377] pnp: PnP ACPI: found 2 devices
[    0.232385] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff, max_idle_ns: 2085701024 ns
[    0.232395] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    0.232396] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    0.232397] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff window]
[    0.232399] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfdffffff window]
[    0.232449] NET: Registered protocol family 2
[    0.232635] tcp_listen_portaddr_hash hash table entries: 2048 (order: 3, 32768 bytes)
[    0.232672] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.232753] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.232827] TCP: Hash tables configured (established 32768 bind 32768)
[    0.232863] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.232878] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.232931] NET: Registered protocol family 1
[    0.232939] NET: Registered protocol family 44
[    0.232945] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.232980] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.233032] pci 0000:00:02.0: Video device with shadowed ROM at [mem 0x000c0000-0x000dffff]
[    0.234370] PCI: CLS 0 bytes, default 64
[    0.234409] Unpacking initramfs...
[    0.338213] Freeing initrd memory: 7556K
[    0.338223] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.338225] software IO TLB [mem 0xdbff0000-0xdfff0000] (64MB) mapped at [(____ptrval____)-(____ptrval____)]
[    0.338262] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x25641074d3b, max_idle_ns: 440795244898 ns
[    0.338303] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.338345] Scanning for low memory corruption every 60 seconds
[    0.338913] Initialise system trusted keyrings
[    0.338924] Key type blacklist registered
[    0.339028] workingset: timestamp_bits=41 max_order=20 bucket_order=0
[    0.340478] zbud: loaded
[    0.341015] pstore: using lz4hc compression
[    0.344288] Key type asymmetric registered
[    0.344289] Asymmetric key parser 'x509' registered
[    0.344338] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 245)
[    0.353464] io scheduler noop registered
[    0.353466] io scheduler deadline registered
[    0.353537] io scheduler cfq registered (default)
[    0.353539] io scheduler mq-deadline registered
[    0.353540] io scheduler kyber registered
[    0.353562] io scheduler bfq registered
[    0.353807] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.353898] vesafb: mode is 640x480x32, linelength=2560, pages=0
[    0.353899] vesafb: scrolling: redraw
[    0.353900] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.353911] vesafb: framebuffer at 0xe0000000, mapped to 0x(____ptrval____), using 1216k, total 1216k
[    0.355641] Console: switching to colour frame buffer device 80x30
[    0.356625] fb0: VESA VGA frame buffer device
[    0.356695] intel_idle: Please enable MWAIT in BIOS SETUP
[    0.356790] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.356822] ACPI: Power Button [PWRF]
[    0.357042] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input1
[    0.357054] ACPI: Sleep Button [SLPF]
[    0.357286] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.357382] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:00/input/input2
[    0.359419] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.369028] ledtrig-cpu: registered to indicate activity on CPUs
[    0.369586] NET: Registered protocol family 10
[    0.375703] Segment Routing with IPv6
[    0.375741] NET: Registered protocol family 17
[    0.376325] RAS: Correctable Errors collector initialized.
[    0.376337] sched_clock: Marking stable (376110511, 0)->(772889041, -396778530)
[    0.377247] registered taskstats version 1
[    0.377258] Loading compiled-in X.509 certificates
[    0.377279] zswap: loaded using pool lzo/zbud
[    0.382531] Key type big_key registered
[    0.382765]   Magic number: 2:846:840
[    0.382805] hctosys: unable to open rtc device (rtc0)
[    0.397622] Freeing unused kernel image memory: 1492K
[    0.397694] Write protecting the kernel read-only data: 16384k
[    0.398620] Freeing unused kernel image memory: 2016K
[    0.398913] Freeing unused kernel image memory: 568K
[    0.486290] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.509470] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.509519] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.514588] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.516109] SCSI subsystem initialized
[    0.517459] ACPI: bus type USB registered
[    0.517481] usbcore: registered new interface driver usbfs
[    0.517490] usbcore: registered new interface driver hub
[    0.517934] usbcore: registered new device driver usb
[    0.525643] libata version 3.00 loaded.
[    0.526568] ata_piix 0000:00:01.1: version 2.13
[    0.526918] xhci_hcd 0000:00:0c.0: xHCI Host Controller
[    0.526924] xhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 1
[    0.626802] scsi host0: ata_piix
[    0.627903] xhci_hcd 0000:00:0c.0: hcc params 0x04000000 hci version 0x100 quirks 0x000000000000b930
[    0.628808] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 4.18
[    0.628812] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.628815] usb usb1: Product: xHCI Host Controller
[    0.628817] usb usb1: Manufacturer: Linux 4.18.5-arch1-1-ARCH xhci-hcd
[    0.628820] usb usb1: SerialNumber: 0000:00:0c.0
[    0.629055] hub 1-0:1.0: USB hub found
[    0.629119] hub 1-0:1.0: 8 ports detected
[    0.629706] xhci_hcd 0000:00:0c.0: xHCI Host Controller
[    0.629713] xhci_hcd 0000:00:0c.0: new USB bus registered, assigned bus number 2
[    0.629719] xhci_hcd 0000:00:0c.0: Host supports USB 3.0  SuperSpeed
[    0.630001] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 4.18
[    0.630005] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.630007] usb usb2: Product: xHCI Host Controller
[    0.630010] usb usb2: Manufacturer: Linux 4.18.5-arch1-1-ARCH xhci-hcd
[    0.630013] usb usb2: SerialNumber: 0000:00:0c.0
[    0.630263] hub 2-0:1.0: USB hub found
[    0.630313] hub 2-0:1.0: 6 ports detected
[    0.633536] scsi host1: ata_piix
[    0.633660] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0xd000 irq 14
[    0.633665] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xd008 irq 15
[    0.790468] ata1.01: NODEV after polling detection
[    0.790776] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
[    0.790780] ata1.00: 41943040 sectors, multi 128: LBA 
[    0.791653] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0 ANSI: 5
[    0.804543] sd 0:0:0:0: [sda] 41943040 512-byte logical blocks: (21.5 GB/20.0 GiB)
[    0.804558] sd 0:0:0:0: [sda] Write Protect is off
[    0.804561] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.804580] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.805903]  sda: sda1 sda2
[    0.806370] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.883392] raid6: sse2x1   gen()  9369 MB/s
[    0.940060] raid6: sse2x1   xor()  7066 MB/s
[    0.960277] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[    0.978338] usb 2-1: New USB device found, idVendor=152d, idProduct=0539, bcdDevice= 2.06
[    0.978341] usb 2-1: New USB device strings: Mfr=10, Product=11, SerialNumber=3
[    0.978342] usb 2-1: Product: External USB 3.0
[    0.978343] usb 2-1: Manufacturer: Intenso
[    0.978345] usb 2-1: SerialNumber: 20120625001B2
[    0.982736] usb-storage 2-1:1.0: USB Mass Storage device detected
[    0.986797] usb-storage 2-1:1.0: Quirks match for vid 152d pid 0539: 4000000
[    0.986831] scsi host2: usb-storage 2-1:1.0
[    0.987178] usbcore: registered new interface driver usb-storage
[    0.987994] usbcore: registered new interface driver uas
[    0.996720] raid6: sse2x2   gen() 11082 MB/s
[    1.053395] raid6: sse2x2   xor()  7743 MB/s
[    1.110074] raid6: sse2x4   gen() 14245 MB/s
[    1.173589] raid6: sse2x4   xor()  9852 MB/s
[    1.255531] raid6: avx2x1   gen() 24111 MB/s
[    1.317747] raid6: avx2x1   xor() 13086 MB/s
[    1.383351] raid6: avx2x2   gen() 24755 MB/s
[    1.447826] raid6: avx2x2   xor() 13015 MB/s
[    1.504458] raid6: avx2x4   gen() 24140 MB/s
[    1.560095] raid6: avx2x4   xor() 11681 MB/s
[    1.560098] raid6: using algorithm avx2x2 gen() 24755 MB/s
[    1.560099] raid6: .... xor() 13015 MB/s, rmw enabled
[    1.560101] raid6: using avx2x2 recovery algorithm
[    1.563834] xor: automatically using best checksumming function   avx       
[    1.592832] Btrfs loaded, crc32c=crc32c-intel
[    1.593655] BTRFS: device label rootfs devid 1 transid 462 /dev/sda2
[    1.628696] BTRFS info (device sda2): disk space caching is enabled
[    1.628698] BTRFS info (device sda2): has skinny extents
[    1.744316] random: fast init done
[    1.819501] systemd[1]: systemd 239 running in system mode. (+PAM -AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN +PCRE2 default-hierarchy=hybrid)
[    1.819526] systemd[1]: Detected virtualization oracle.
[    1.819532] systemd[1]: Detected architecture x86-64.
[    1.824972] systemd[1]: Set hostname to <archlinux>.
[    1.928707] random: systemd: uninitialized urandom read (16 bytes read)
[    1.928773] systemd[1]: Listening on Journal Audit Socket.
[    1.928827] random: systemd: uninitialized urandom read (16 bytes read)
[    1.928834] systemd[1]: Reached target Remote File Systems.
[    1.928840] random: systemd: uninitialized urandom read (16 bytes read)
[    1.928903] systemd[1]: Listening on Journal Socket (/dev/log).
[    1.929292] systemd[1]: Listening on udev Control Socket.
[    1.929367] systemd[1]: Listening on Journal Socket.
[    1.931671] systemd[1]: Mounting Huge Pages File System...
[    1.997814] scsi 2:0:0:0: Direct-Access     Intenso  External USB 3.0 0206 PQ: 0 ANSI: 6
[    1.999676] sd 2:0:0:0: [sdb] 1953523712 512-byte logical blocks: (1.00 TB/932 GiB)
[    2.000887] sd 2:0:0:0: [sdb] Write Protect is off
[    2.000890] sd 2:0:0:0: [sdb] Mode Sense: 27 00 00 00
[    2.001756] sd 2:0:0:0: [sdb] No Caching mode page found
[    2.001873] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    2.004627]  sdb: sdb1 sdb2
[    2.004730] sdb: p2 size 19914992 extends beyond EOD, enabling native capacity
[    2.009831]  sdb: sdb1 sdb2
[    2.010503] sdb: p2 size 19914992 extends beyond EOD, truncated
[    2.018523] sd 2:0:0:0: [sdb] Attached SCSI disk
[    2.042042] BTRFS info (device sda2): disk space caching is enabled
[    2.080132] systemd-journald[201]: Received request to flush runtime journal from PID 1
[    2.249713] ACPI: AC Adapter [AC] (on-line)
[    2.288169] ACPI: Battery Slot [BAT0] (battery present)
[    2.301989] vboxguest: host-version: 5.2.18r123745 0x1
[    2.302808] vbg_heartbeat_init: Setting up heartbeat to trigger every 2000 milliseconds
[    2.302929] input: VirtualBox mouse integration as /devices/pci0000:00/0000:00:04.0/input/input5
[    2.303794] vboxguest: misc device minor 57, IRQ 20, I/O port d020, MMIO at 0x00000000f0400000 (size 0x0000000000400000)
[    2.312124] Linux agpgart interface v0.103
[    2.344296] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    2.345557] piix4_smbus 0000:00:07.0: SMBus Host Controller at 0x4100, revision 0
[    2.356878] RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 10737418240 ms ovfl timer
[    2.356880] RAPL PMU: hw unit of domain pp0-core 2^-0 Joules
[    2.356881] RAPL PMU: hw unit of domain package 2^-0 Joules
[    2.356881] RAPL PMU: hw unit of domain dram 2^-0 Joules
[    2.356882] RAPL PMU: hw unit of domain pp1-gpu 2^-0 Joules
[    2.358252] rtc_cmos rtc_cmos: registered as rtc0
[    2.358271] rtc_cmos rtc_cmos: alarms up to one day, 114 bytes nvram
[    2.422191] mousedev: PS/2 mouse device common for all mice
[    2.469829] cryptd: max_cpu_qlen set to 1000
[    2.471599] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    2.471601] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.480494] Adding 2024444k swap on /dev/sda1.  Priority:-2 extents:1 across:2024444k FS
[    2.494788] AVX2 version of gcm_enc/dec engaged.
[    2.494790] AES CTR mode by8 optimization enabled
[    2.503205] vboxvideo: module is from the staging directory, the quality is unknown, you have been warned.
[    2.505559] [drm] VRAM 00800000
[    2.509449] [TTM] Zone  kernel: Available graphics memory: 2021432 kiB
[    2.509451] [TTM] Initializing pool allocator
[    2.509454] [TTM] Initializing DMA pool allocator
[    2.513382] checking generic (e0000000 130000) vs hw (e0000000 800000)
[    2.513383] fb: switching to vboxdrmfb from VESA VGA
[    2.513403] Console: switching to colour dummy device 80x25
[    2.513907] fbcon: vboxdrmfb (fb0) is primary device
[    2.514513] Console: switching to colour frame buffer device 100x37
[    2.515572] vboxvideo 0000:00:02.0: fb0: vboxdrmfb frame buffer device
[    2.530138] [drm] Initialized vboxvideo 1.0.0 20130823 for 0000:00:02.0 on minor 0
[    2.578072] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input7
[    2.704296] BTRFS: device label intenso_white devid 1 transid 4791 /dev/sdb1
[    3.122044] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 08:00:27:b4:cd:7d
[    3.122052] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.150681] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 59724 usecs (13312 samples)
[    3.150684] snd_intel8x0 0000:00:05.0: measured clock 222891 rejected
[    3.154776] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    3.231789] vboxsf: loading out-of-tree module taints kernel.
[    3.399563] random: crng init done
[    3.399564] random: 7 urandom warning(s) missed due to ratelimiting
[    3.527715] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 55413 usecs (13312 samples)
[    3.527719] snd_intel8x0 0000:00:05.0: measured clock 240232 rejected
[    3.935298] snd_intel8x0 0000:00:05.0: intel8x0_measure_ac97_clock: measured 57301 usecs (12288 samples)
[    3.935303] snd_intel8x0 0000:00:05.0: measured clock 214446 rejected
[    3.935305] snd_intel8x0 0000:00:05.0: clocking to 48000
[    5.270127] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[    5.270996] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   10.639523] audit: type=1006 audit(1536248901.077:2): pid=305 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=1 res=1
[   10.669563] audit: type=1006 audit(1536248901.107:3): pid=308 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=2 res=1
[   35.191243] audit: type=1006 audit(1536248925.619:4): pid=487 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=3 res=1
[   35.216098] audit: type=1006 audit(1536248925.646:5): pid=490 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=4 res=1
[   66.009078] BTRFS info (device sdb1): disk space caching is enabled
[   66.009082] BTRFS info (device sdb1): has skinny extents
[  114.645853] audit: type=1006 audit(1536249005.057:6): pid=532 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=5 res=1
[  185.862211] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.074356] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.284605] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.491055] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.680460] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.879242] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  186.898756] sd 2:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  186.898762] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a0 d0 00 08 00 00
[  186.898764] print_req_error: I/O error, dev sdb, sector 354853072
[  187.109641] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  187.345245] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  187.657844] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  187.851336] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.026882] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.215881] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.247028] sd 2:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  188.247041] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 a8 d0 00 08 00 00
[  188.247048] print_req_error: I/O error, dev sdb, sector 354855120
[  188.247221] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0, rd 1, flush 0, corrupt 0, gen 0
[  188.255311] xhci_hcd 0000:00:0c.0: WARN: HC couldn't access mem fast enough for slot 1 ep 2
[  188.413306] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.597731] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.775025] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  188.937851] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  189.108001] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  189.331634] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  189.350312] sd 2:0:0:0: [sdb] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  189.350315] sd 2:0:0:0: [sdb] tag#0 CDB: Read(10) 28 00 15 26 b0 d0 00 01 c0 00
[  189.350318] print_req_error: I/O error, dev sdb, sector 354857168
[  189.350360] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0, rd 2, flush 0, corrupt 0, gen 0
[  189.504163] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  189.712556] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  200.694085] audit: type=1006 audit(1536249091.095:7): pid=542 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=6 res=1
[  221.883915] usb 2-1: reset SuperSpeed Gen 1 USB device number 2 using xhci_hcd
[  326.168580] audit: type=1006 audit(1536249216.567:8): pid=554 uid=0 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=7 res=1
[  368.371741] INFO: task btrfs:540 blocked for more than 120 seconds.
[  368.371901]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  368.372027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  368.372179] btrfs           D    0   540    539 0x80000080
[  368.372193] Call Trace:
[  368.372221]  ? __schedule+0x29b/0x8b0
[  368.372318]  ? btrfs_bio_counter_sub+0x1e/0x50 [btrfs]
[  368.372331]  schedule+0x32/0x90
[  368.372347]  io_schedule+0x12/0x40
[  368.372361]  __lock_page+0xf9/0x140
[  368.372375]  ? add_to_page_cache_lru+0xe0/0xe0
[  368.372458]  send_extent_data+0x503/0x600 [btrfs]
[  368.372547]  process_extent+0x26f/0xb90 [btrfs]
[  368.372616]  ? __record_deleted_ref+0x20/0x20 [btrfs]
[  368.372684]  changed_cb+0xb17/0xd30 [btrfs]
[  368.372739]  ? btrfs_next_old_leaf+0x1ca/0x420 [btrfs]
[  368.372794]  btrfs_ioctl_send+0xf6d/0x1060 [btrfs]
[  368.372806]  ? kmem_cache_alloc_trace+0x181/0x1d0
[  368.372849]  ? btrfs_opendir+0x3e/0x70 [btrfs]
[  368.372901]  _btrfs_ioctl_send+0xdd/0x110 [btrfs]
[  368.372912]  ? task_change_group_fair+0xb3/0x100
[  368.372921]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  368.372928]  ? cpu_cgroup_fork+0x64/0x80
[  368.372977]  btrfs_ioctl+0x1145/0x2d00 [btrfs]
[  368.372984]  ? enqueue_entity+0x3d0/0xc20
[  368.372991]  ? __update_load_avg_se.isra.4+0x1f2/0x200
[  368.373000]  ? do_vfs_ioctl+0xa4/0x620
[  368.373005]  do_vfs_ioctl+0xa4/0x620
[  368.373014]  ? syscall_slow_exit_work+0x19b/0x1b0
[  368.373021]  ksys_ioctl+0x60/0x90
[  368.373028]  __x64_sys_ioctl+0x16/0x20
[  368.373034]  do_syscall_64+0x5b/0x170
[  368.373043]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  368.373050] RIP: 0033:0x7f5fc276179b
[  368.373051] Code: Bad RIP value.
[  368.373069] RSP: 002b:00007ffeef93b958 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  368.373075] RAX: ffffffffffffffda RBX: 00007ffeef93de00 RCX: 00007f5fc276179b
[  368.373078] RDX: 00007ffeef93ba50 RSI: 0000000040489426 RDI: 0000000000000004
[  368.373081] RBP: 0000000000000004 R08: 00007ffeef93ba50 R09: 00007f5fc266b700
[  368.373084] R10: 00007f5fc266b9d0 R11: 0000000000000246 R12: 0000000000000001
[  368.373087] R13: 0000555c74d3b260 R14: 0000000000000000 R15: 00007ffeef93cbf8
[  368.373098] INFO: task ls:551 blocked for more than 120 seconds.
[  368.373165]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  368.373228] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  368.373303] ls              D    0   551    545 0x00000080
[  368.373310] Call Trace:
[  368.373319]  ? __schedule+0x29b/0x8b0
[  368.373353]  ? percpu_counter_add_batch+0x84/0xb0
[  368.373360]  schedule+0x32/0x90
[  368.373367]  io_schedule+0x12/0x40
[  368.373375]  wait_on_page_bit+0xea/0x130
[  368.373383]  ? add_to_page_cache_lru+0xe0/0xe0
[  368.373436]  read_extent_buffer_pages+0x2b0/0x2d0 [btrfs]
[  368.373480]  btree_read_extent_buffer_pages+0xb6/0x200 [btrfs]
[  368.373526]  read_tree_block+0x51/0x70 [btrfs]
[  368.373567]  read_block_for_search.isra.15+0x18e/0x340 [btrfs]
[  368.373623]  btrfs_search_slot+0x45e/0xa00 [btrfs]
[  368.373686]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  368.373697]  ? kmem_cache_alloc+0x179/0x1d0
[  368.373749]  btrfs_iget+0x113/0x690 [btrfs]
[  368.373797]  btrfs_lookup_dentry+0x3e2/0x4b0 [btrfs]
[  368.373995]  btrfs_lookup+0xe/0x30 [btrfs]
[  368.374013]  __lookup_slow+0x97/0x160
[  368.374026]  lookup_slow+0x35/0x50
[  368.374034]  walk_component+0x1bd/0x2d0
[  368.374044]  path_lookupat.isra.11+0x75/0x200
[  368.374054]  filename_lookup.part.19+0xa0/0x170
[  368.374063]  ? preempt_count_add+0x68/0xa0
[  368.374075]  ? __check_object_size+0xfb/0x180
[  368.374084]  ? strncpy_from_user+0x4a/0x160
[  368.374095]  vfs_statx+0x73/0xe0
[  368.374106]  ? __audit_syscall_exit+0x22a/0x290
[  368.374115]  __se_sys_newlstat+0x3e/0x70
[  368.374125]  ? syscall_trace_enter+0x1d3/0x2d0
[  368.374137]  do_syscall_64+0x5b/0x170
[  368.374148]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  368.374156] RIP: 0033:0x7fba592ffdd9
[  368.374158] Code: Bad RIP value.
[  368.374174] RSP: 002b:00007ffed6ec54b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[  368.374180] RAX: ffffffffffffffda RBX: 0000560b2c69d218 RCX: 00007fba592ffdd9
[  368.374183] RDX: 0000560b2c69d230 RSI: 0000560b2c69d230 RDI: 00007ffed6ec54c0
[  368.374186] RBP: 00007ffed6ec5890 R08: 0000000000000000 R09: 0000560b2c6a203e
[  368.374189] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffed6ec54c0
[  368.374191] R13: 0000000000000000 R14: 0000000000000005 R15: 0000560b2c69d230
[  491.226820] INFO: task scsi_eh_2:144 blocked for more than 120 seconds.
[  491.227094]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  491.227220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  491.227293] scsi_eh_2       D    0   144      2 0x80000000
[  491.227300] Call Trace:
[  491.227319]  ? __schedule+0x29b/0x8b0
[  491.227327]  ? __switch_to_asm+0x34/0x70
[  491.227333]  ? __switch_to_asm+0x40/0x70
[  491.227339]  schedule+0x32/0x90
[  491.227344]  schedule_preempt_disabled+0x14/0x20
[  491.227349]  __mutex_lock.isra.0+0x220/0x530
[  491.227356]  ? __switch_to_asm+0x34/0x70
[  491.227364]  ? try_module_get.part.12+0x52/0xf0
[  491.227376]  device_reset+0x1d/0x50 [usb_storage]
[  491.227396]  scsi_eh_ready_devs+0x559/0xb80 [scsi_mod]
[  491.227405]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  491.227430]  ? __pm_runtime_resume+0x47/0x50
[  491.227444]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
[  491.227457]  ? scsi_eh_get_sense+0x1f0/0x1f0 [scsi_mod]
[  491.227469]  scsi_error_handler+0x494/0x5b0 [scsi_mod]
[  491.227483]  ? scsi_eh_get_sense+0x1f0/0x1f0 [scsi_mod]
[  491.227492]  kthread+0x112/0x130
[  491.227499]  ? kthread_flush_work_fn+0x10/0x10
[  491.227506]  ret_from_fork+0x35/0x40
[  491.227534] INFO: task btrfs-transacti:531 blocked for more than 120 seconds.
[  491.227599]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  491.227655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  491.227722] btrfs-transacti D    0   531      2 0x80000080
[  491.227727] Call Trace:
[  491.227735]  ? __schedule+0x29b/0x8b0
[  491.227741]  ? preempt_count_add+0x68/0xa0
[  491.227746]  schedule+0x32/0x90
[  491.227806]  btrfs_tree_lock+0xd1/0x1f0 [btrfs]
[  491.227814]  ? wait_woken+0x80/0x80
[  491.227845]  btrfs_lock_root_node+0x2f/0x40 [btrfs]
[  491.227876]  btrfs_search_slot+0x170/0xa00 [btrfs]
[  491.227883]  ? __switch_to_asm+0x34/0x70
[  491.227891]  ? ktime_get+0x36/0xa0
[  491.227928]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  491.227974]  ? btrfs_delete_delayed_items+0x1d2/0x350 [btrfs]
[  491.228019]  __btrfs_update_delayed_inode+0x75/0x220 [btrfs]
[  491.228075]  __btrfs_run_delayed_items+0x141/0x1d0 [btrfs]
[  491.228113]  btrfs_commit_transaction+0x18a/0x8a0 [btrfs]
[  491.228160]  ? start_transaction+0x9c/0x3f0 [btrfs]
[  491.228209]  transaction_kthread+0x13f/0x170 [btrfs]
[  491.228258]  ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  491.228266]  kthread+0x112/0x130
[  491.228273]  ? kthread_flush_work_fn+0x10/0x10
[  491.228281]  ret_from_fork+0x35/0x40
[  491.228292] INFO: task btrfs:540 blocked for more than 120 seconds.
[  491.228359]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  491.228409] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  491.228470] btrfs           D    0   540    539 0x80000080
[  491.228475] Call Trace:
[  491.228481]  ? __schedule+0x29b/0x8b0
[  491.228521]  ? btrfs_bio_counter_sub+0x1e/0x50 [btrfs]
[  491.228527]  schedule+0x32/0x90
[  491.228533]  io_schedule+0x12/0x40
[  491.228541]  __lock_page+0xf9/0x140
[  491.228547]  ? add_to_page_cache_lru+0xe0/0xe0
[  491.228586]  send_extent_data+0x503/0x600 [btrfs]
[  491.228628]  process_extent+0x26f/0xb90 [btrfs]
[  491.228667]  ? __record_deleted_ref+0x20/0x20 [btrfs]
[  491.228704]  changed_cb+0xb17/0xd30 [btrfs]
[  491.228733]  ? btrfs_next_old_leaf+0x1ca/0x420 [btrfs]
[  491.228770]  btrfs_ioctl_send+0xf6d/0x1060 [btrfs]
[  491.228779]  ? kmem_cache_alloc_trace+0x181/0x1d0
[  491.228813]  ? btrfs_opendir+0x3e/0x70 [btrfs]
[  491.228853]  _btrfs_ioctl_send+0xdd/0x110 [btrfs]
[  491.228860]  ? task_change_group_fair+0xb3/0x100
[  491.228865]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  491.228870]  ? cpu_cgroup_fork+0x64/0x80
[  491.228909]  btrfs_ioctl+0x1145/0x2d00 [btrfs]
[  491.228915]  ? enqueue_entity+0x3d0/0xc20
[  491.228920]  ? __update_load_avg_se.isra.4+0x1f2/0x200
[  491.228928]  ? do_vfs_ioctl+0xa4/0x620
[  491.228932]  do_vfs_ioctl+0xa4/0x620
[  491.228938]  ? syscall_slow_exit_work+0x19b/0x1b0
[  491.228944]  ksys_ioctl+0x60/0x90
[  491.228949]  __x64_sys_ioctl+0x16/0x20
[  491.228954]  do_syscall_64+0x5b/0x170
[  491.228961]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  491.228966] RIP: 0033:0x7f5fc276179b
[  491.228967] Code: Bad RIP value.
[  491.228982] RSP: 002b:00007ffeef93b958 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  491.228998] RAX: ffffffffffffffda RBX: 00007ffeef93de00 RCX: 00007f5fc276179b
[  491.229001] RDX: 00007ffeef93ba50 RSI: 0000000040489426 RDI: 0000000000000004
[  491.229004] RBP: 0000000000000004 R08: 00007ffeef93ba50 R09: 00007f5fc266b700
[  491.229006] R10: 00007f5fc266b9d0 R11: 0000000000000246 R12: 0000000000000001
[  491.229008] R13: 0000555c74d3b260 R14: 0000000000000000 R15: 00007ffeef93cbf8
[  491.229018] INFO: task ls:551 blocked for more than 120 seconds.
[  491.229068]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  491.229117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  491.229178] ls              D    0   551    545 0x00000080
[  491.229182] Call Trace:
[  491.229189]  ? __schedule+0x29b/0x8b0
[  491.229196]  ? percpu_counter_add_batch+0x84/0xb0
[  491.229201]  schedule+0x32/0x90
[  491.229207]  io_schedule+0x12/0x40
[  491.229213]  wait_on_page_bit+0xea/0x130
[  491.229219]  ? add_to_page_cache_lru+0xe0/0xe0
[  491.229261]  read_extent_buffer_pages+0x2b0/0x2d0 [btrfs]
[  491.229296]  btree_read_extent_buffer_pages+0xb6/0x200 [btrfs]
[  491.229331]  read_tree_block+0x51/0x70 [btrfs]
[  491.229359]  read_block_for_search.isra.15+0x18e/0x340 [btrfs]
[  491.229389]  btrfs_search_slot+0x45e/0xa00 [btrfs]
[  491.229422]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  491.229429]  ? kmem_cache_alloc+0x179/0x1d0
[  491.229465]  btrfs_iget+0x113/0x690 [btrfs]
[  491.229502]  btrfs_lookup_dentry+0x3e2/0x4b0 [btrfs]
[  491.229540]  btrfs_lookup+0xe/0x30 [btrfs]
[  491.229546]  __lookup_slow+0x97/0x160
[  491.229553]  lookup_slow+0x35/0x50
[  491.229557]  walk_component+0x1bd/0x2d0
[  491.229563]  path_lookupat.isra.11+0x75/0x200
[  491.229568]  filename_lookup.part.19+0xa0/0x170
[  491.229573]  ? preempt_count_add+0x68/0xa0
[  491.229578]  ? __check_object_size+0xfb/0x180
[  491.229584]  ? strncpy_from_user+0x4a/0x160
[  491.229590]  vfs_statx+0x73/0xe0
[  491.229595]  ? __audit_syscall_exit+0x22a/0x290
[  491.229600]  __se_sys_newlstat+0x3e/0x70
[  491.229607]  ? syscall_trace_enter+0x1d3/0x2d0
[  491.229613]  do_syscall_64+0x5b/0x170
[  491.229619]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  491.229623] RIP: 0033:0x7fba592ffdd9
[  491.229624] Code: Bad RIP value.
[  491.229631] RSP: 002b:00007ffed6ec54b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[  491.229636] RAX: ffffffffffffffda RBX: 0000560b2c69d218 RCX: 00007fba592ffdd9
[  491.229638] RDX: 0000560b2c69d230 RSI: 0000560b2c69d230 RDI: 00007ffed6ec54c0
[  491.229640] RBP: 00007ffed6ec5890 R08: 0000000000000000 R09: 0000560b2c6a203e
[  491.229643] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffed6ec54c0
[  491.229645] R13: 0000000000000000 R14: 0000000000000005 R15: 0000560b2c69d230
[  614.095081] INFO: task scsi_eh_2:144 blocked for more than 120 seconds.
[  614.095184]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  614.095248] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  614.095392] scsi_eh_2       D    0   144      2 0x80000000
[  614.095401] Call Trace:
[  614.095426]  ? __schedule+0x29b/0x8b0
[  614.095436]  ? __switch_to_asm+0x34/0x70
[  614.095443]  ? __switch_to_asm+0x40/0x70
[  614.095449]  schedule+0x32/0x90
[  614.095456]  schedule_preempt_disabled+0x14/0x20
[  614.095462]  __mutex_lock.isra.0+0x220/0x530
[  614.095469]  ? __switch_to_asm+0x34/0x70
[  614.095481]  ? try_module_get.part.12+0x52/0xf0
[  614.095497]  device_reset+0x1d/0x50 [usb_storage]
[  614.095527]  scsi_eh_ready_devs+0x559/0xb80 [scsi_mod]
[  614.095538]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  614.095572]  ? __pm_runtime_resume+0x47/0x50
[  614.095589]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
[  614.095605]  ? scsi_eh_get_sense+0x1f0/0x1f0 [scsi_mod]
[  614.095620]  scsi_error_handler+0x494/0x5b0 [scsi_mod]
[  614.095637]  ? scsi_eh_get_sense+0x1f0/0x1f0 [scsi_mod]
[  614.095650]  kthread+0x112/0x130
[  614.095659]  ? kthread_flush_work_fn+0x10/0x10
[  614.095667]  ret_from_fork+0x35/0x40
[  614.095705] INFO: task btrfs-transacti:531 blocked for more than 120 seconds.
[  614.095779]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  614.095841] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  614.095917] btrfs-transacti D    0   531      2 0x80000080
[  614.095923] Call Trace:
[  614.095932]  ? __schedule+0x29b/0x8b0
[  614.095939]  ? preempt_count_add+0x68/0xa0
[  614.095945]  schedule+0x32/0x90
[  614.096216]  btrfs_tree_lock+0xd1/0x1f0 [btrfs]
[  614.096235]  ? wait_woken+0x80/0x80
[  614.096280]  btrfs_lock_root_node+0x2f/0x40 [btrfs]
[  614.096319]  btrfs_search_slot+0x170/0xa00 [btrfs]
[  614.096328]  ? __switch_to_asm+0x34/0x70
[  614.096336]  ? ktime_get+0x36/0xa0
[  614.096381]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  614.096438]  ? btrfs_delete_delayed_items+0x1d2/0x350 [btrfs]
[  614.096491]  __btrfs_update_delayed_inode+0x75/0x220 [btrfs]
[  614.096546]  __btrfs_run_delayed_items+0x141/0x1d0 [btrfs]
[  614.096594]  btrfs_commit_transaction+0x18a/0x8a0 [btrfs]
[  614.096641]  ? start_transaction+0x9c/0x3f0 [btrfs]
[  614.096686]  transaction_kthread+0x13f/0x170 [btrfs]
[  614.096731]  ? btrfs_cleanup_transaction+0x560/0x560 [btrfs]
[  614.096739]  kthread+0x112/0x130
[  614.096795]  ? kthread_flush_work_fn+0x10/0x10
[  614.096805]  ret_from_fork+0x35/0x40
[  614.096817] INFO: task btrfs:540 blocked for more than 120 seconds.
[  614.096889]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  614.096951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  614.097027] btrfs           D    0   540    539 0x80000080
[  614.097033] Call Trace:
[  614.097042]  ? __schedule+0x29b/0x8b0
[  614.097099]  ? btrfs_bio_counter_sub+0x1e/0x50 [btrfs]
[  614.097106]  schedule+0x32/0x90
[  614.097114]  io_schedule+0x12/0x40
[  614.097123]  __lock_page+0xf9/0x140
[  614.097166]  ? add_to_page_cache_lru+0xe0/0xe0
[  614.097223]  send_extent_data+0x503/0x600 [btrfs]
[  614.097277]  process_extent+0x26f/0xb90 [btrfs]
[  614.097325]  ? __record_deleted_ref+0x20/0x20 [btrfs]
[  614.097372]  changed_cb+0xb17/0xd30 [btrfs]
[  614.097408]  ? btrfs_next_old_leaf+0x1ca/0x420 [btrfs]
[  614.097463]  btrfs_ioctl_send+0xf6d/0x1060 [btrfs]
[  614.097478]  ? kmem_cache_alloc_trace+0x181/0x1d0
[  614.097539]  ? btrfs_opendir+0x3e/0x70 [btrfs]
[  614.097605]  _btrfs_ioctl_send+0xdd/0x110 [btrfs]
[  614.097616]  ? task_change_group_fair+0xb3/0x100
[  614.097624]  ? _raw_spin_unlock_irqrestore+0x20/0x40
[  614.097630]  ? cpu_cgroup_fork+0x64/0x80
[  614.097696]  btrfs_ioctl+0x1145/0x2d00 [btrfs]
[  614.097712]  ? enqueue_entity+0x3d0/0xc20
[  614.097720]  ? __update_load_avg_se.isra.4+0x1f2/0x200
[  614.097735]  ? do_vfs_ioctl+0xa4/0x620
[  614.097742]  do_vfs_ioctl+0xa4/0x620
[  614.097754]  ? syscall_slow_exit_work+0x19b/0x1b0
[  614.097764]  ksys_ioctl+0x60/0x90
[  614.097773]  __x64_sys_ioctl+0x16/0x20
[  614.097780]  do_syscall_64+0x5b/0x170
[  614.097789]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  614.097796] RIP: 0033:0x7f5fc276179b
[  614.097798] Code: Bad RIP value.
[  614.097816] RSP: 002b:00007ffeef93b958 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  614.097822] RAX: ffffffffffffffda RBX: 00007ffeef93de00 RCX: 00007f5fc276179b
[  614.097825] RDX: 00007ffeef93ba50 RSI: 0000000040489426 RDI: 0000000000000004
[  614.097828] RBP: 0000000000000004 R08: 00007ffeef93ba50 R09: 00007f5fc266b700
[  614.097831] R10: 00007f5fc266b9d0 R11: 0000000000000246 R12: 0000000000000001
[  614.097834] R13: 0000555c74d3b260 R14: 0000000000000000 R15: 00007ffeef93cbf8
[  614.097845] INFO: task ls:551 blocked for more than 120 seconds.
[  614.097913]       Tainted: G         C O      4.18.5-arch1-1-ARCH #1
[  614.101076] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  614.103035] ls              D    0   551    545 0x00000080
[  614.103040] Call Trace:
[  614.103052]  ? __schedule+0x29b/0x8b0
[  614.103057]  ? percpu_counter_add_batch+0x84/0xb0
[  614.103063]  schedule+0x32/0x90
[  614.103068]  io_schedule+0x12/0x40
[  614.103074]  wait_on_page_bit+0xea/0x130
[  614.103079]  ? add_to_page_cache_lru+0xe0/0xe0
[  614.103119]  read_extent_buffer_pages+0x2b0/0x2d0 [btrfs]
[  614.103149]  btree_read_extent_buffer_pages+0xb6/0x200 [btrfs]
[  614.103177]  read_tree_block+0x51/0x70 [btrfs]
[  614.103200]  read_block_for_search.isra.15+0x18e/0x340 [btrfs]
[  614.103225]  btrfs_search_slot+0x45e/0xa00 [btrfs]
[  614.103251]  btrfs_lookup_inode+0x3a/0xc0 [btrfs]
[  614.103256]  ? kmem_cache_alloc+0x179/0x1d0
[  614.103283]  btrfs_iget+0x113/0x690 [btrfs]
[  614.103312]  btrfs_lookup_dentry+0x3e2/0x4b0 [btrfs]
[  614.103339]  btrfs_lookup+0xe/0x30 [btrfs]
[  614.103344]  __lookup_slow+0x97/0x160
[  614.103349]  lookup_slow+0x35/0x50
[  614.103352]  walk_component+0x1bd/0x2d0
[  614.103356]  path_lookupat.isra.11+0x75/0x200
[  614.103360]  filename_lookup.part.19+0xa0/0x170
[  614.103365]  ? preempt_count_add+0x68/0xa0
[  614.103368]  ? __check_object_size+0xfb/0x180
[  614.103372]  ? strncpy_from_user+0x4a/0x160
[  614.103377]  vfs_statx+0x73/0xe0
[  614.103382]  ? __audit_syscall_exit+0x22a/0x290
[  614.103386]  __se_sys_newlstat+0x3e/0x70
[  614.103391]  ? syscall_trace_enter+0x1d3/0x2d0
[  614.103396]  do_syscall_64+0x5b/0x170
[  614.103402]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  614.103406] RIP: 0033:0x7fba592ffdd9
[  614.103407] Code: Bad RIP value.
[  614.103415] RSP: 002b:00007ffed6ec54b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000006
[  614.103419] RAX: ffffffffffffffda RBX: 0000560b2c69d218 RCX: 00007fba592ffdd9
[  614.103421] RDX: 0000560b2c69d230 RSI: 0000560b2c69d230 RDI: 00007ffed6ec54c0
[  614.103422] RBP: 00007ffed6ec5890 R08: 0000000000000000 R09: 0000560b2c6a203e
[  614.103424] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffed6ec54c0
[  614.103426] R13: 0000000000000000 R14: 0000000000000005 R15: 0000560b2c69d230

--------------CED04A9294F52A21A72D390E--
