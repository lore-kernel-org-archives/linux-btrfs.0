From: C Anthony Risinger <anthony@extof.me>
Subject: Slow link/Capacity changed + Kernel OOPS... possible hardware issues, ideas?
Date: Thu, 7 Oct 2010 22:07:47 -0500
Message-ID: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: C Anthony Risinger <anthony@extof.me>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

well after recently talking about how i haven't had any problems with
btrfs on several machines for ~1.5yrs...

it happens :-(

) 2.6.35 kernel
) btrfs on partition 2 of sda
) no special mkfs or mount options used (except ssd)

my fianc=E9's EEE S101 netbook, w/SSD, is failing hard.  when booting
normally (subvol=3D__active), no special boot options, it hangs at
udev... it all started today, when it suddenly froze during normal
use, and i was forced to hard power off.  it hasn't started up
correctly since.  using an Archlinux rescue usb disk (archboot), i
tried to tar + ssh backup the system to another machine (i can still
mount the btrfs disk); i tried a couple times, and it always transfers
~1.3MB then pukes.  the last time i managed to get the kernel log
somehow, as it didn't lockup...

can anyone point me in the right direction?  it looks like maybe the
SSD is failing to me (all the "slow link" and "capacity changed to 0"
stuff), but i really don't know.  i knew there was a reason they were
selling these things cheap on Newegg!!!

i have backups of important data, but i'd rather not have to set the
damn thing up again; you know how it is :-), should have backed up the
whole system, whoopsie, next time.

the mayhem starts with:

"Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480"

seconds after starting the backup.

thanks,

C Anthony

kernel.log inline (2.6.35)...

-----------------------------------------------------------------
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys cpuset
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys cpu
Oct  8 02:35:04 (none) kernel: Linux version 2.6.35-ARCH
(tobias@T-POWA-LX) (gcc version 4.5.1 (GCC) ) #1 SMP PREEMPT Wed Sep
29 07:17:20 UTC 2010
Oct  8 02:35:04 (none) kernel: BIOS-provided physical RAM map:
Oct  8 02:35:04 (none) kernel: BIOS-e820: 0000000000000000 -
000000000009fc00 (usable)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 000000000009fc00 -
00000000000a0000 (reserved)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 00000000000e0000 -
0000000000100000 (reserved)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 0000000000100000 -
000000003f7a0000 (usable)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 000000003f7a0000 -
000000003f7ae000 (ACPI data)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 000000003f7ae000 -
000000003f7f0000 (ACPI NVS)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 000000003f7f0000 -
000000003f800000 (reserved)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 00000000fee00000 -
00000000fee01000 (reserved)
Oct  8 02:35:04 (none) kernel: BIOS-e820: 00000000fff80000 -
0000000100000000 (reserved)
Oct  8 02:35:04 (none) kernel: Notice: NX (Execute Disable) protection
cannot be enabled: non-PAE kernel!
Oct  8 02:35:04 (none) kernel: DMI present.
Oct  8 02:35:04 (none) kernel: AMI BIOS detected: BIOS may corrupt low
RAM, working around it.
Oct  8 02:35:04 (none) kernel: e820 update range: 0000000000000000 -
0000000000010000 (usable) =3D=3D> (reserved)
Oct  8 02:35:04 (none) kernel: e820 update range: 0000000000000000 -
0000000000001000 (usable) =3D=3D> (reserved)
Oct  8 02:35:04 (none) kernel: e820 remove range: 00000000000a0000 -
0000000000100000 (usable)
Oct  8 02:35:04 (none) kernel: last_pfn =3D 0x3f7a0 max_arch_pfn =3D 0x=
100000
Oct  8 02:35:04 (none) kernel: MTRR default type: uncachable
Oct  8 02:35:04 (none) kernel: MTRR fixed ranges enabled:
Oct  8 02:35:04 (none) kernel: 00000-9FFFF write-back
Oct  8 02:35:04 (none) kernel: A0000-DFFFF uncachable
Oct  8 02:35:04 (none) kernel: E0000-E3FFF write-protect
Oct  8 02:35:04 (none) kernel: E4000-EFFFF write-through
Oct  8 02:35:04 (none) kernel: F0000-FFFFF write-protect
Oct  8 02:35:04 (none) kernel: MTRR variable ranges enabled:
Oct  8 02:35:04 (none) kernel: 0 base 000000000 mask 0C0000000 write-ba=
ck
Oct  8 02:35:04 (none) kernel: 1 base 03F800000 mask 0FF800000 uncachab=
le
Oct  8 02:35:04 (none) kernel: 2 disabled
Oct  8 02:35:04 (none) kernel: 3 disabled
Oct  8 02:35:04 (none) kernel: 4 disabled
Oct  8 02:35:04 (none) kernel: 5 disabled
Oct  8 02:35:04 (none) kernel: 6 disabled
Oct  8 02:35:04 (none) kernel: 7 disabled
Oct  8 02:35:04 (none) kernel: x86 PAT enabled: cpu 0, old
0x7040600070406, new 0x7010600070106
Oct  8 02:35:04 (none) kernel: Scanning 0 areas for low memory corrupti=
on
Oct  8 02:35:04 (none) kernel: modified physical RAM map:
Oct  8 02:35:04 (none) kernel: modified: 0000000000000000 -
0000000000010000 (reserved)
Oct  8 02:35:04 (none) kernel: modified: 0000000000010000 -
000000000009fc00 (usable)
Oct  8 02:35:04 (none) kernel: modified: 000000000009fc00 -
00000000000a0000 (reserved)
Oct  8 02:35:04 (none) kernel: modified: 00000000000e0000 -
0000000000100000 (reserved)
Oct  8 02:35:04 (none) kernel: modified: 0000000000100000 -
000000003f7a0000 (usable)
Oct  8 02:35:04 (none) kernel: modified: 000000003f7a0000 -
000000003f7ae000 (ACPI data)
Oct  8 02:35:04 (none) kernel: modified: 000000003f7ae000 -
000000003f7f0000 (ACPI NVS)
Oct  8 02:35:04 (none) kernel: modified: 000000003f7f0000 -
000000003f800000 (reserved)
Oct  8 02:35:04 (none) kernel: modified: 00000000fee00000 -
00000000fee01000 (reserved)
Oct  8 02:35:04 (none) kernel: modified: 00000000fff80000 -
0000000100000000 (reserved)
Oct  8 02:35:04 (none) kernel: initial memory mapped : 0 - 01800000
Oct  8 02:35:04 (none) kernel: found SMP MP-table at [c00ff780] ff780
Oct  8 02:35:04 (none) kernel: init_memory_mapping:
0000000000000000-00000000377fe000
Oct  8 02:35:04 (none) kernel: 0000000000 - 0000400000 page 4k
Oct  8 02:35:04 (none) kernel: 0000400000 - 0037400000 page 2M
Oct  8 02:35:04 (none) kernel: 0037400000 - 00377fe000 page 4k
Oct  8 02:35:04 (none) kernel: kernel direct mapping tables up to
377fe000 @ 15000-1a000
Oct  8 02:35:04 (none) kernel: RAMDISK: 3cf61000 - 3f77f000
Oct  8 02:35:04 (none) kernel: Allocated new RAMDISK: 0157a000 - 03d975=
64
Oct  8 02:35:04 (none) kernel: Move RAMDISK from 000000003cf61000 -
000000003f77e563 to 0157a000 - 03d97563
Oct  8 02:35:04 (none) kernel: ACPI: RSDP 000fbd00 00014 (v00 ACPIAM)
Oct  8 02:35:04 (none) kernel: ACPI: RSDT 3f7a0000 0003C (v01 A_M_I_
OEMRSDT  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: FACP 3f7a0200 00084 (v02 A_M_I_
OEMFACP  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: DSDT 3f7a0430 06292 (v01  P0019
P0019000 00000000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: FACS 3f7ae000 00040
Oct  8 02:35:04 (none) kernel: ACPI: APIC 3f7a0390 0005C (v01 A_M_I_
OEMAPIC  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: MCFG 3f7a03f0 0003C (v01 A_M_I_
OEMMCFG  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: OEMB 3f7ae040 00061 (v01 A_M_I_
AMI_OEM  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: HPET 3f7a66d0 00038 (v01 A_M_I_
OEMHPET  06000912 MSFT 00000097)
Oct  8 02:35:04 (none) kernel: ACPI: SSDT 3f7aeb80 004F0 (v01  PmRef
 CpuPm 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Local APIC address 0xfee00000
Oct  8 02:35:04 (none) kernel: 127MB HIGHMEM available.
Oct  8 02:35:04 (none) kernel: 887MB LOWMEM available.
Oct  8 02:35:04 (none) kernel: mapped low ram: 0 - 377fe000
Oct  8 02:35:04 (none) kernel: low ram: 0 - 377fe000
Oct  8 02:35:04 (none) kernel: Zone PFN ranges:
Oct  8 02:35:04 (none) kernel: DMA      0x00000010 -> 0x00001000
Oct  8 02:35:04 (none) kernel: Normal   0x00001000 -> 0x000377fe
Oct  8 02:35:04 (none) kernel: HighMem  0x000377fe -> 0x0003f7a0
Oct  8 02:35:04 (none) kernel: Movable zone start PFN for each node
Oct  8 02:35:04 (none) kernel: early_node_map[2] active PFN ranges
Oct  8 02:35:04 (none) kernel: 0: 0x00000010 -> 0x0000009f
Oct  8 02:35:04 (none) kernel: 0: 0x00000100 -> 0x0003f7a0
Oct  8 02:35:04 (none) kernel: On node 0 totalpages: 259887
Oct  8 02:35:04 (none) kernel: free_area_init_node: node 0, pgdat
c1418ac0, node_mem_map c3d99200
Oct  8 02:35:04 (none) kernel: DMA zone: 32 pages used for memmap
Oct  8 02:35:04 (none) kernel: DMA zone: 0 pages reserved
Oct  8 02:35:04 (none) kernel: DMA zone: 3951 pages, LIFO batch:0
Oct  8 02:35:04 (none) kernel: Normal zone: 1744 pages used for memmap
Oct  8 02:35:04 (none) kernel: Normal zone: 221486 pages, LIFO batch:31
Oct  8 02:35:04 (none) kernel: HighMem zone: 256 pages used for memmap
Oct  8 02:35:04 (none) kernel: HighMem zone: 32418 pages, LIFO batch:7
Oct  8 02:35:04 (none) kernel: Using APIC driver default
Oct  8 02:35:04 (none) kernel: ACPI: PM-Timer IO Port: 0x808
Oct  8 02:35:04 (none) kernel: ACPI: Local APIC address 0xfee00000
Oct  8 02:35:04 (none) kernel: ACPI: LAPIC (acpi_id[0x01]
lapic_id[0x00] enabled)
Oct  8 02:35:04 (none) kernel: ACPI: LAPIC (acpi_id[0x02]
lapic_id[0x01] enabled)
Oct  8 02:35:04 (none) kernel: ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0])
Oct  8 02:35:04 (none) kernel: IOAPIC[0]: apic_id 2, version 32,
address 0xfec00000, GSI 0-23
Oct  8 02:35:04 (none) kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0
global_irq 2 dfl dfl)
Oct  8 02:35:04 (none) kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9
global_irq 9 high level)
Oct  8 02:35:04 (none) kernel: ACPI: IRQ0 used by override.
Oct  8 02:35:04 (none) kernel: ACPI: IRQ2 used by override.
Oct  8 02:35:04 (none) kernel: ACPI: IRQ9 used by override.
Oct  8 02:35:04 (none) kernel: Using ACPI (MADT) for SMP configuration
information
Oct  8 02:35:04 (none) kernel: ACPI: HPET id: 0xffffffff base: 0xfed000=
00
Oct  8 02:35:04 (none) kernel: SMP: Allowing 2 CPUs, 0 hotplug CPUs
Oct  8 02:35:04 (none) kernel: nr_irqs_gsi: 40
Oct  8 02:35:04 (none) kernel: early_res array is doubled to 64 at
[16000 - 167ff]
Oct  8 02:35:04 (none) kernel: PM: Registered nosave memory:
000000000009f000 - 00000000000a0000
Oct  8 02:35:04 (none) kernel: PM: Registered nosave memory:
00000000000a0000 - 00000000000e0000
Oct  8 02:35:04 (none) kernel: PM: Registered nosave memory:
00000000000e0000 - 0000000000100000
Oct  8 02:35:04 (none) kernel: Allocating PCI resources starting at
3f800000 (gap: 3f800000:bf600000)
Oct  8 02:35:04 (none) kernel: Booting paravirtualized kernel on bare h=
ardware
Oct  8 02:35:04 (none) kernel: setup_percpu: NR_CPUS:8
nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
Oct  8 02:35:04 (none) kernel: PERCPU: Embedded 14 pages/cpu @c4800000
s34880 r0 d22464 u2097152
Oct  8 02:35:04 (none) kernel: pcpu-alloc: s34880 r0 d22464 u2097152
alloc=3D1*4194304
Oct  8 02:35:04 (none) kernel: pcpu-alloc: [0] 0 1
Oct  8 02:35:04 (none) kernel: Built 1 zonelists in Zone order,
mobility grouping on.  Total pages: 257855
Oct  8 02:35:04 (none) kernel: Kernel command line:
initrd=3D/boot/initrd.img rootdelay=3D10 BOOT_IMAGE=3D/boot/vmlinuz
Oct  8 02:35:04 (none) kernel: PID hash table entries: 4096 (order: 2,
16384 bytes)
Oct  8 02:35:04 (none) kernel: Dentry cache hash table entries: 131072
(order: 7, 524288 bytes)
Oct  8 02:35:04 (none) kernel: Inode-cache hash table entries: 65536
(order: 6, 262144 bytes)
Oct  8 02:35:04 (none) kernel: Enabling fast FPU save and restore... do=
ne.
Oct  8 02:35:04 (none) kernel: Enabling unmasked SIMD FPU exception
support... done.
Oct  8 02:35:04 (none) kernel: Initializing CPU#0
Oct  8 02:35:04 (none) kernel: allocated 5199680 bytes of page_cgroup
Oct  8 02:35:04 (none) kernel: please try 'cgroup_disable=3Dmemory'
option if you don't want memory cgroups
Oct  8 02:35:04 (none) kernel: Subtract (48 early reservations)
Oct  8 02:35:04 (none) kernel: #1 [0000001000 - 0000002000]   EX TRAMPO=
LINE
Oct  8 02:35:04 (none) kernel: #2 [0001000000 - 0001572184]   TEXT DATA=
 BSS
Oct  8 02:35:04 (none) kernel: #3 [0001573000 - 00015791f8]            =
 BRK
Oct  8 02:35:04 (none) kernel: #4 [00000ff790 - 0000100000]   BIOS rese=
rved
Oct  8 02:35:04 (none) kernel: #5 [00000ff780 - 00000ff790]    MP-table=
 mpf
Oct  8 02:35:04 (none) kernel: #6 [000009fc00 - 00000f1160]   BIOS rese=
rved
Oct  8 02:35:04 (none) kernel: #7 [00000f1298 - 00000ff780]   BIOS rese=
rved
Oct  8 02:35:04 (none) kernel: #8 [00000f1160 - 00000f1298]    MP-table=
 mpc
Oct  8 02:35:04 (none) kernel: #9 [0000010000 - 0000011000]      TRAMPO=
LINE
Oct  8 02:35:04 (none) kernel: #10 [0000011000 - 0000015000]     ACPI W=
AKEUP
Oct  8 02:35:04 (none) kernel: #11 [0000015000 - 0000016000]         PG=
TABLE
Oct  8 02:35:04 (none) kernel: #12 [000157a000 - 0003d98000]     NEW RA=
MDISK
Oct  8 02:35:04 (none) kernel: #13 [0003d98000 - 0003d99000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #14 [0003d99000 - 0004589000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #15 [00015721c0 - 00015721c4]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #16 [0001572200 - 00015722c0]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #17 [00015722c0 - 0001572314]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #18 [0004589000 - 000458c000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #19 [0001572340 - 000157234c]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #20 [0001572380 - 0001572980]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #21 [0001572980 - 00015729a5]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #22 [00015729c0 - 00015729e7]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #23 [0001572a00 - 0001572b18]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #24 [0001572b40 - 0001572b80]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #25 [0001572b80 - 0001572bc0]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #26 [0001572bc0 - 0001572c00]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #27 [0001572c00 - 0001572c40]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #28 [0001572c40 - 0001572c80]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #29 [0001572c80 - 0001572cc0]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #30 [0001572cc0 - 0001572d00]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #31 [0001572d00 - 0001572d40]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #32 [0001572d40 - 0001572d80]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #33 [0001572d80 - 0001572d90]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #34 [0001572dc0 - 0001572dff]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #35 [0001572e00 - 0001572e3f]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #36 [0004800000 - 000480e000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #37 [0004a00000 - 0004a0e000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #38 [0001572e40 - 0001572e44]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #39 [0001572e80 - 0001572e84]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #40 [0001572ec0 - 0001572ec8]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #41 [0001572f00 - 0001572f08]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #42 [0001572f40 - 0001572fe8]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #43 [0001579200 - 0001579268]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #44 [000458c000 - 0004590000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #45 [0004590000 - 0004610000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #46 [0004610000 - 0004650000]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: #47 [0004a0e000 - 0004f03740]         BO=
OTMEM
Oct  8 02:35:04 (none) kernel: Initializing HighMem for node 0
(000377fe:0003f7a0)
Oct  8 02:35:04 (none) kernel: Memory: 978716k/1040000k available
(2986k kernel code, 60832k reserved, 1238k data, 412k init, 130696k
highmem)
Oct  8 02:35:04 (none) kernel: virtual kernel memory layout:
Oct  8 02:35:04 (none) kernel: fixmap  : 0xfff16000 - 0xfffff000   ( 93=
2 kB)
Oct  8 02:35:04 (none) kernel: pkmap   : 0xff800000 - 0xffc00000   (409=
6 kB)
Oct  8 02:35:04 (none) kernel: vmalloc : 0xf7ffe000 - 0xff7fe000   ( 12=
0 MB)
Oct  8 02:35:04 (none) kernel: lowmem  : 0xc0000000 - 0xf77fe000   ( 88=
7 MB)
Oct  8 02:35:04 (none) kernel: .init : 0xc1421000 - 0xc1488000   ( 412 =
kB)
Oct  8 02:35:04 (none) kernel: .data : 0xc12eaacc - 0xc1420340   (1238 =
kB)
Oct  8 02:35:04 (none) kernel: .text : 0xc1000000 - 0xc12eaacc   (2986 =
kB)
Oct  8 02:35:04 (none) kernel: Checking if this processor honours the
WP bit even in supervisor mode...Ok.
Oct  8 02:35:04 (none) kernel: SLUB: Genslabs=3D13, HWalign=3D64,
Order=3D0-3, MinObjects=3D0, CPUs=3D2, Nodes=3D1
Oct  8 02:35:04 (none) kernel: Hierarchical RCU implementation.
Oct  8 02:35:04 (none) kernel: 	RCU-based detection of stalled CPUs is =
disabled.
Oct  8 02:35:04 (none) kernel: 	Verbose stalled-CPUs detection is disab=
led.
Oct  8 02:35:04 (none) kernel: NR_IRQS:512
Oct  8 02:35:04 (none) kernel: Console: colour VGA+ 80x25
Oct  8 02:35:04 (none) kernel: console [tty0] enabled
Oct  8 02:35:04 (none) kernel: hpet clockevent registered
Oct  8 02:35:04 (none) kernel: Fast TSC calibration using PIT
Oct  8 02:35:04 (none) kernel: Detected 1600.086 MHz processor.
Oct  8 02:35:04 (none) kernel: Calibrating delay loop (skipped), value
calculated using timer frequency.. 3201.51 BogoMIPS (lpj=3D5333620)
Oct  8 02:35:04 (none) kernel: pid_max: default: 32768 minimum: 301
Oct  8 02:35:04 (none) kernel: Security Framework initialized
Oct  8 02:35:04 (none) kernel: Mount-cache hash table entries: 512
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys ns
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys cpuacct
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys memory
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys devices
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys freezer
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys net_cls
Oct  8 02:35:04 (none) kernel: Initializing cgroup subsys blkio
Oct  8 02:35:04 (none) kernel: CPU: Physical Processor ID: 0
Oct  8 02:35:04 (none) kernel: CPU: Processor Core ID: 0
Oct  8 02:35:04 (none) kernel: mce: CPU supports 5 MCE banks
Oct  8 02:35:04 (none) kernel: CPU0: Thermal monitoring enabled (TM2)
Oct  8 02:35:04 (none) kernel: using mwait in idle threads.
Oct  8 02:35:04 (none) kernel: Performance Events: PEBS fmt0+, Atom
events, Intel PMU driver.
Oct  8 02:35:04 (none) kernel: ... version:                3
Oct  8 02:35:04 (none) kernel: ... bit width:              40
Oct  8 02:35:04 (none) kernel: ... generic registers:      2
Oct  8 02:35:04 (none) kernel: ... value mask:             000000ffffff=
ffff
Oct  8 02:35:04 (none) kernel: ... max period:             000000007fff=
ffff
Oct  8 02:35:04 (none) kernel: ... fixed-purpose events:   3
Oct  8 02:35:04 (none) kernel: ... event mask:             000000070000=
0003
Oct  8 02:35:04 (none) kernel: ACPI: Core revision 20100428
Oct  8 02:35:04 (none) kernel: Enabling APIC mode:  Flat.  Using 1 I/O =
APICs
Oct  8 02:35:04 (none) kernel: ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D=
2
apic2=3D-1 pin2=3D-1
Oct  8 02:35:04 (none) kernel: CPU0: Intel(R) Atom(TM) CPU N270   @
1.60GHz stepping 02
Oct  8 02:35:04 (none) kernel: APIC calibration not consistent with
PM-Timer: 159ms instead of 100ms
Oct  8 02:35:04 (none) kernel: APIC delta adjusted to PM-Timer: 833332 =
(1333327)
Oct  8 02:35:04 (none) kernel: Booting Node   0, Processors  #1 Ok.
Oct  8 02:35:04 (none) kernel: Initializing CPU#1
Oct  8 02:35:04 (none) kernel: Brought up 2 CPUs
Oct  8 02:35:04 (none) kernel: Total of 2 processors activated
(6402.80 BogoMIPS).
Oct  8 02:35:04 (none) kernel: devtmpfs: initialized
Oct  8 02:35:04 (none) kernel: NET: Registered protocol family 16
Oct  8 02:35:04 (none) kernel: ACPI: bus type pci registered
Oct  8 02:35:04 (none) kernel: PCI: MMCONFIG for domain 0000 [bus
00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
Oct  8 02:35:04 (none) kernel: PCI: not using MMCONFIG
Oct  8 02:35:04 (none) kernel: PCI: PCI BIOS revision 3.00 entry at
0xf0031, last bus=3D4
Oct  8 02:35:04 (none) kernel: PCI: Using configuration type 1 for base=
 access
Oct  8 02:35:04 (none) kernel: bio: create slab <bio-0> at 0
Oct  8 02:35:04 (none) kernel: ACPI: EC: Look up EC in DSDT
Oct  8 02:35:04 (none) kernel: ACPI: Executed 1 blocks of module-level
executable AML code
Oct  8 02:35:04 (none) kernel: ACPI: SSDT 3f7ae180 0023C (v01  PmRef
Cpu0Ist 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Dynamic OEM Table Load:
Oct  8 02:35:04 (none) kernel: ACPI: SSDT (null) 0023C (v01  PmRef
Cpu0Ist 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: SSDT 3f7ae450 00724 (v01  PmRef
Cpu0Cst 00003001 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Dynamic OEM Table Load:
Oct  8 02:35:04 (none) kernel: ACPI: SSDT (null) 00724 (v01  PmRef
Cpu0Cst 00003001 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: SSDT 3f7ae0b0 000CC (v01  PmRef
Cpu1Ist 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Dynamic OEM Table Load:
Oct  8 02:35:04 (none) kernel: ACPI: SSDT (null) 000CC (v01  PmRef
Cpu1Ist 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: SSDT 3f7ae3c0 00085 (v01  PmRef
Cpu1Cst 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Dynamic OEM Table Load:
Oct  8 02:35:04 (none) kernel: ACPI: SSDT (null) 00085 (v01  PmRef
Cpu1Cst 00003000 INTL 20060113)
Oct  8 02:35:04 (none) kernel: ACPI: Interpreter enabled
Oct  8 02:35:04 (none) kernel: ACPI: (supports S0 S3 S4 S5)
Oct  8 02:35:04 (none) kernel: ACPI: Using IOAPIC for interrupt routing
Oct  8 02:35:04 (none) kernel: PCI: MMCONFIG for domain 0000 [bus
00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000)
Oct  8 02:35:04 (none) kernel: PCI: MMCONFIG at [mem
0xe0000000-0xe3ffffff] reserved in ACPI motherboard resources
Oct  8 02:35:04 (none) kernel: PCI: Using MMCONFIG for extended config =
space
Oct  8 02:35:04 (none) kernel: ACPI: EC: GPE =3D 0x1c, I/O:
command/status =3D 0x66, data =3D 0x62
Oct  8 02:35:04 (none) kernel: ACPI: No dock devices found.
Oct  8 02:35:04 (none) kernel: PCI: Using host bridge windows from
ACPI; if necessary, use "pci=3Dnocrs" and report a bug
Oct  8 02:35:04 (none) kernel: ACPI: PCI Root Bridge [PCI0] (domain
0000 [bus 00-ff])
Oct  8 02:35:04 (none) kernel: pci_root PNP0A08:00: host bridge window
[io  0x0000-0x0cf7]
Oct  8 02:35:04 (none) kernel: pci_root PNP0A08:00: host bridge window
[io  0x0d00-0xffff]
Oct  8 02:35:04 (none) kernel: pci_root PNP0A08:00: host bridge window
[mem 0x000a0000-0x000bffff]
Oct  8 02:35:04 (none) kernel: pci_root PNP0A08:00: host bridge window
[mem 0x000d0000-0x000dffff]
Oct  8 02:35:04 (none) kernel: pci_root PNP0A08:00: host bridge window
[mem 0x3f800000-0xffffffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.0: reg 10: [mem
0xfbd00000-0xfbd7ffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.0: reg 14: [io  0xdc80-0x=
dc87]
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.0: reg 18: [mem
0xd0000000-0xdfffffff pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.0: reg 1c: [mem
0xfbcc0000-0xfbcfffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.1: reg 10: [mem
0xfbd80000-0xfbdfffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1b.0: reg 10: [mem
0xfbcb8000-0xfbcbbfff 64bit]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1b.0: PME# supported from
D0 D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:00:1b.0: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: PME# supported from
D0 D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: PME# supported from
D0 D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: PME# supported from
D0 D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.0: reg 20: [io  0xd480-0x=
d49f]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.1: reg 20: [io  0xd800-0x=
d81f]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.2: reg 20: [io  0xd880-0x=
d89f]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.3: reg 20: [io  0xdc00-0x=
dc1f]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.7: reg 10: [mem
0xfbcb7c00-0xfbcb7fff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.7: PME# supported from
D0 D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:00:1d.7: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.0: quirk: [io
0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.0: quirk: [io
0x0480-0x04bf] claimed by ICH6 GPIO
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO
decode 1 PIO at 0380 (mask 0003)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO
decode 2 PIO at 0290 (mask 0007)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.0: ICH7 LPC Generic IO
decode 3 PIO at 0068 (mask 0003)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: reg 10: [io  0x0000-0x=
0007]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: reg 14: [io  0x0000-0x=
0003]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: reg 18: [io  0x0000-0x=
0007]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: reg 1c: [io  0x0000-0x=
0003]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: reg 20: [io  0xffa0-0x=
ffaf]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: PME# supported from D3=
hot
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.2: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1f.3: reg 20: [io  0x0400-0x=
041f]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: PCI bridge to [bus 03-=
03]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [io
0xf000-0x0000] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:02:00.0: reg 10: [mem
0xfbfc0000-0xfbffffff 64bit]
Oct  8 02:35:04 (none) kernel: pci 0000:02:00.0: reg 18: [io  0xec80-0x=
ecff]
Oct  8 02:35:04 (none) kernel: pci 0000:02:00.0: PME# supported from
D3hot D3cold
Oct  8 02:35:04 (none) kernel: pci 0000:02:00.0: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: PCI bridge to [bus 02-=
02]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [io
0xe000-0xefff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [mem
0xfbf00000-0xfbffffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:01:00.0: reg 10: [mem
0xfbef0000-0xfbefffff 64bit]
Oct  8 02:35:04 (none) kernel: pci 0000:01:00.0: supports D1
Oct  8 02:35:04 (none) kernel: pci 0000:01:00.0: PME# supported from D0=
 D1 D3hot
Oct  8 02:35:04 (none) kernel: pci 0000:01:00.0: PME# disabled
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: PCI bridge to [bus 01-=
01]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [io
0xf000-0x0000] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [mem
0xfbe00000-0xfbefffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0: PCI bridge to [bus
04-04] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [io
0xf000-0x0000] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [io
0x0000-0x0cf7] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [io
0x0d00-0xffff] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
0x000a0000-0x000bffff] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
0x000d0000-0x000dffff] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
0x3f800000-0xffffffff] (subtractive decode)
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: on NUMA node 0
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0._PRT]
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P4._PRT]
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P6._PRT]
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Routing Table
[\_SB_.PCI0.P0P5._PRT]
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3
4 *5 6 7 10 11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3
4 5 6 7 *10 11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3
4 5 6 7 10 *11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3
4 5 6 7 10 *11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3
4 5 6 *7 10 11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3
*4 5 6 7 10 11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3
4 5 6 7 10 *11 12 14 15)
Oct  8 02:35:04 (none) kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs
*3 4 5 6 7 10 11 12 14 15)
Oct  8 02:35:04 (none) kernel: HEST: Table is not found!
Oct  8 02:35:04 (none) kernel: vgaarb: device added:
PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
Oct  8 02:35:04 (none) kernel: vgaarb: loaded
Oct  8 02:35:04 (none) kernel: PCI: Using ACPI for IRQ routing
Oct  8 02:35:04 (none) kernel: PCI: pci_cache_line_size set to 64 bytes
Oct  8 02:35:04 (none) kernel: reserve RAM buffer: 000000000009fc00 -
000000000009ffff
Oct  8 02:35:04 (none) kernel: reserve RAM buffer: 000000003f7a0000 -
000000003fffffff
Oct  8 02:35:04 (none) kernel: NetLabel: Initializing
Oct  8 02:35:04 (none) kernel: NetLabel:  domain hash size =3D 128
Oct  8 02:35:04 (none) kernel: NetLabel:  protocols =3D UNLABELED CIPSO=
v4
Oct  8 02:35:04 (none) kernel: NetLabel:  unlabeled traffic allowed by =
default
Oct  8 02:35:04 (none) kernel: HPET: 3 timers in total, 0 timers will
be used for per-cpu timer
Oct  8 02:35:04 (none) kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Oct  8 02:35:04 (none) kernel: hpet0: 3 comparators, 64-bit 14.318180
MHz counter
Oct  8 02:35:04 (none) kernel: Switching to clocksource tsc
Oct  8 02:35:04 (none) kernel: pnp: PnP ACPI init
Oct  8 02:35:04 (none) kernel: ACPI: bus type pnp registered
Oct  8 02:35:04 (none) kernel: pnp: PnP ACPI: found 13 devices
Oct  8 02:35:04 (none) kernel: ACPI: ACPI bus type pnp unregistered
Oct  8 02:35:04 (none) kernel: system 00:01: [mem
0xfed13000-0xfed19fff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x025c-0x025f] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x0380-0x0383] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x0400-0x041f] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x04d0-0x04d1] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x0800-0x087f] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [io  0x0480-0x04bf] has
been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0x8c000000-0x8c01ffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0xfed1c000-0xfed1ffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0xfed20000-0xfed3ffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0xfed50000-0xfed8ffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0xffb00000-0xffbfffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:08: [mem
0xfff00000-0xffffffff] could not be reserved
Oct  8 02:35:04 (none) kernel: system 00:0a: [mem
0xfec00000-0xfec00fff] could not be reserved
Oct  8 02:35:04 (none) kernel: system 00:0a: [mem
0xfee00000-0xfee00fff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:0b: [mem
0xe0000000-0xe3ffffff] has been reserved
Oct  8 02:35:04 (none) kernel: system 00:0c: [mem
0x00000000-0x0009ffff] could not be reserved
Oct  8 02:35:04 (none) kernel: system 00:0c: [mem
0x000c0000-0x000cffff] could not be reserved
Oct  8 02:35:04 (none) kernel: system 00:0c: [mem
0x000e0000-0x000fffff] could not be reserved
Oct  8 02:35:04 (none) kernel: system 00:0c: [mem
0x00100000-0x3f7fffff] could not be reserved
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: BAR 14: assigned [mem
0x3f800000-0x3f9fffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: BAR 15: assigned [mem
0x3fa00000-0x3fbfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: BAR 15: assigned [mem
0x3fc00000-0x3fdfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: BAR 15: assigned [mem
0x3fe00000-0x3fffffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: BAR 13: assigned [io
0x1000-0x1fff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: BAR 13: assigned [io
0x2000-0x2fff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: PCI bridge to [bus 03-=
03]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [io
0x1000-0x1fff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [mem
0x3f800000-0x3f9fffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0:   bridge window [mem
0x3fa00000-0x3fbfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: PCI bridge to [bus 02-=
02]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [io
0xe000-0xefff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [mem
0xfbf00000-0xfbffffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1:   bridge window [mem
0x3fc00000-0x3fdfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: PCI bridge to [bus 01-=
01]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [io
0x2000-0x2fff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [mem
0xfbe00000-0xfbefffff]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2:   bridge window [mem
0x3fe00000-0x3fffffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0: PCI bridge to [bus 04-=
04]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [io  d=
isabled]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem d=
isabled]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0:   bridge window [mem
pref disabled]
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: enabling device (0104 =
-> 0107)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: PCI INT A -> GSI 16
(level, low) -> IRQ 16
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.0: setting latency timer =
to 64
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: PCI INT B -> GSI 17
(level, low) -> IRQ 17
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.1: setting latency timer =
to 64
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: enabling device (0106 =
-> 0107)
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: PCI INT C -> GSI 18
(level, low) -> IRQ 18
Oct  8 02:35:04 (none) kernel: pci 0000:00:1c.2: setting latency timer =
to 64
Oct  8 02:35:04 (none) kernel: pci 0000:00:1e.0: setting latency timer =
to 64
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: resource 4 [io  0x0000-=
0x0cf7]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: resource 5 [io  0x0d00-=
0xffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: resource 6 [mem
0x000a0000-0x000bffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: resource 7 [mem
0x000d0000-0x000dffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:00: resource 8 [mem
0x3f800000-0xffffffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:03: resource 0 [io  0x1000-=
0x1fff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:03: resource 1 [mem
0x3f800000-0x3f9fffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:03: resource 2 [mem
0x3fa00000-0x3fbfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:02: resource 0 [io  0xe000-=
0xefff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:02: resource 1 [mem
0xfbf00000-0xfbffffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:02: resource 2 [mem
0x3fc00000-0x3fdfffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:01: resource 0 [io  0x2000-=
0x2fff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:01: resource 1 [mem
0xfbe00000-0xfbefffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:01: resource 2 [mem
0x3fe00000-0x3fffffff 64bit pref]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:04: resource 4 [io  0x0000-=
0x0cf7]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:04: resource 5 [io  0x0d00-=
0xffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:04: resource 6 [mem
0x000a0000-0x000bffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:04: resource 7 [mem
0x000d0000-0x000dffff]
Oct  8 02:35:04 (none) kernel: pci_bus 0000:04: resource 8 [mem
0x3f800000-0xffffffff]
Oct  8 02:35:04 (none) kernel: NET: Registered protocol family 2
Oct  8 02:35:04 (none) kernel: IP route cache hash table entries:
32768 (order: 5, 131072 bytes)
Oct  8 02:35:04 (none) kernel: TCP established hash table entries:
131072 (order: 8, 1048576 bytes)
Oct  8 02:35:04 (none) kernel: TCP bind hash table entries: 65536
(order: 7, 524288 bytes)
Oct  8 02:35:04 (none) kernel: TCP: Hash tables configured
(established 131072 bind 65536)
Oct  8 02:35:04 (none) kernel: TCP reno registered
Oct  8 02:35:04 (none) kernel: UDP hash table entries: 512 (order: 2,
16384 bytes)
Oct  8 02:35:04 (none) kernel: UDP-Lite hash table entries: 512
(order: 2, 16384 bytes)
Oct  8 02:35:04 (none) kernel: NET: Registered protocol family 1
Oct  8 02:35:04 (none) kernel: pci 0000:00:02.0: Boot video device
Oct  8 02:35:04 (none) kernel: PCI: CLS 32 bytes, default 64
Oct  8 02:35:04 (none) kernel: Unpacking initramfs...
Oct  8 02:35:04 (none) kernel: Freeing initrd memory: 41080k freed
Oct  8 02:35:04 (none) kernel: apm: BIOS version 1.2 Flags 0x03
(Driver version 1.16ac)
Oct  8 02:35:04 (none) kernel: apm: disabled - APM is not SMP safe.
Oct  8 02:35:04 (none) kernel: Scanning for low memory corruption
every 60 seconds
Oct  8 02:35:04 (none) kernel: audit: initializing netlink socket (disa=
bled)
Oct  8 02:35:04 (none) kernel: type=3D2000 audit(1286505283.363:1): ini=
tialized
Oct  8 02:35:04 (none) kernel: highmem bounce pool size: 64 pages
Oct  8 02:35:04 (none) kernel: VFS: Disk quotas dquot_6.5.2
Oct  8 02:35:04 (none) kernel: Dquot-cache hash table entries: 1024
(order 0, 4096 bytes)
Oct  8 02:35:04 (none) kernel: msgmni has been set to 1736
Oct  8 02:35:04 (none) kernel: alg: No test for stdrng (krng)
Oct  8 02:35:04 (none) kernel: Block layer SCSI generic (bsg) driver
version 0.4 loaded (major 254)
Oct  8 02:35:04 (none) kernel: io scheduler noop registered
Oct  8 02:35:04 (none) kernel: io scheduler deadline registered
Oct  8 02:35:04 (none) kernel: io scheduler cfq registered (default)
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.0: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.0: irq 40 for MSI/MS=
I-X
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.1: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.1: irq 41 for MSI/MS=
I-X
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.2: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: pcieport 0000:00:1c.2: irq 42 for MSI/MS=
I-X
Oct  8 02:35:04 (none) kernel: ERST: Table is not found!
Oct  8 02:35:04 (none) kernel: isapnp: Scanning for PnP cards...
Oct  8 02:35:04 (none) kernel: isapnp: No Plug & Play device found
Oct  8 02:35:04 (none) kernel: Serial: 8250/16550 driver, 4 ports, IRQ
sharing disabled
Oct  8 02:35:04 (none) kernel: PNP: PS/2 Controller
[PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Oct  8 02:35:04 (none) kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Oct  8 02:35:04 (none) kernel: serio: i8042 AUX port at 0x60,0x64 irq 1=
2
Oct  8 02:35:04 (none) kernel: mice: PS/2 mouse device common for all m=
ice
Oct  8 02:35:04 (none) kernel: cpuidle: using governor ladder
Oct  8 02:35:04 (none) kernel: cpuidle: using governor menu
Oct  8 02:35:04 (none) kernel: TCP cubic registered
Oct  8 02:35:04 (none) kernel: NET: Registered protocol family 17
Oct  8 02:35:04 (none) kernel: Using IPI No-Shortcut mode
Oct  8 02:35:04 (none) kernel: PM: Resume from disk failed.
Oct  8 02:35:04 (none) kernel: registered taskstats version 1
Oct  8 02:35:04 (none) kernel: Initalizing network drop monitor service
Oct  8 02:35:04 (none) kernel: Freeing unused kernel memory: 412k freed
Oct  8 02:35:04 (none) kernel: input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
Oct  8 02:35:04 (none) kernel: ACPI: AC Adapter [AC0] (off-line)
Oct  8 02:35:04 (none) kernel: ACPI: Battery Slot [BAT0] (battery prese=
nt)
Oct  8 02:35:04 (none) kernel: input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
Oct  8 02:35:04 (none) kernel: ACPI: Lid Switch [LID]
Oct  8 02:35:04 (none) kernel: input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
Oct  8 02:35:04 (none) kernel: ACPI: Sleep Button [SLPB]
Oct  8 02:35:04 (none) kernel: input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
Oct  8 02:35:04 (none) kernel: ACPI: Power Button [PWRB]
Oct  8 02:35:04 (none) kernel: input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Oct  8 02:35:04 (none) kernel: ACPI: Power Button [PWRF]
Oct  8 02:35:04 (none) kernel: ACPI: acpi_idle registered with cpuidle
Oct  8 02:35:04 (none) kernel: Monitor-Mwait will be used to enter C-1 =
state
Oct  8 02:35:04 (none) kernel: Monitor-Mwait will be used to enter C-2 =
state
Oct  8 02:35:04 (none) kernel: Monitor-Mwait will be used to enter C-3 =
state
Oct  8 02:35:04 (none) kernel: Marking TSC unstable due to TSC halts in=
 idle
Oct  8 02:35:04 (none) kernel: Switching to clocksource hpet
Oct  8 02:35:04 (none) kernel: thermal LNXTHERM:01: registered as therm=
al_zone0
Oct  8 02:35:04 (none) kernel: ACPI: Thermal Zone [TZ00] (59 C)
Oct  8 02:35:04 (none) kernel: input: Video Bus as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
Oct  8 02:35:04 (none) kernel: ACPI: Video Device [VGA] (multi-head:
yes  rom: no  post: no)
Oct  8 02:35:04 (none) kernel: Linux agpgart interface v0.103
Oct  8 02:35:04 (none) kernel: agpgart-intel 0000:00:00.0: Intel 945GME=
 Chipset
Oct  8 02:35:04 (none) kernel: agpgart-intel 0000:00:00.0: detected
7932K stolen memory
Oct  8 02:35:04 (none) kernel: agpgart-intel 0000:00:00.0: AGP
aperture is 256M @ 0xd0000000
Oct  8 02:35:04 (none) kernel: input: PC Speaker as
/devices/platform/pcspkr/input/input6
Oct  8 02:35:04 (none) kernel: pci_hotplug: PCI Hot Plug PCI Core versi=
on: 0.5
Oct  8 02:35:04 (none) kernel: eeepc_laptop: Eee PC Hotkey Driver
Oct  8 02:35:04 (none) kernel: eeepc_laptop: Hotkey init flags 0x41
Oct  8 02:35:04 (none) kernel: eeepc_laptop: TYPE (2000000) not
reported by BIOS, enabling anyway
Oct  8 02:35:04 (none) kernel: eeepc_laptop: PANELPOWER (4000000) not
reported by BIOS, enabling anyway
Oct  8 02:35:04 (none) kernel: eeepc_laptop: TPD (8000000) not
reported by BIOS, enabling anyway
Oct  8 02:35:04 (none) kernel: eeepc_laptop: Get control methods
supported: 0xe101713
Oct  8 02:35:04 (none) kernel: input: Asus EeePC extra buttons as
/devices/platform/eeepc/input/input7
Oct  8 02:35:04 (none) kernel: Registered led device: eeepc::touchpad
Oct  8 02:35:04 (none) kernel: rtc_cmos 00:03: RTC can wake from S4
Oct  8 02:35:04 (none) kernel: rtc_cmos 00:03: rtc core: registered
rtc_cmos as rtc0
Oct  8 02:35:04 (none) kernel: rtc0: alarms up to one month, 114 bytes
nvram, hpet irqs
Oct  8 02:35:04 (none) kernel: HDA Intel 0000:00:1b.0: PCI INT A ->
GSI 16 (level, low) -> IRQ 16
Oct  8 02:35:04 (none) kernel: HDA Intel 0000:00:1b.0: irq 43 for MSI/M=
SI-X
Oct  8 02:35:04 (none) kernel: HDA Intel 0000:00:1b.0: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: SCSI subsystem initialized
Oct  8 02:35:04 (none) kernel: libata version 3.00 loaded.
Oct  8 02:35:04 (none) kernel: ata_piix 0000:00:1f.2: version 2.13
Oct  8 02:35:04 (none) kernel: ata_piix 0000:00:1f.2: PCI INT B -> GSI
19 (level, low) -> IRQ 19
Oct  8 02:35:04 (none) kernel: ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE I=
DE ]
Oct  8 02:35:04 (none) kernel: ata_piix 0000:00:1f.2: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: scsi0 : ata_piix
Oct  8 02:35:04 (none) kernel: scsi1 : ata_piix
Oct  8 02:35:04 (none) kernel: ata1: SATA max UDMA/133 cmd 0x1f0 ctl
0x3f6 bmdma 0xffa0 irq 14
Oct  8 02:35:04 (none) kernel: ata2: PATA max UDMA/100 cmd 0x170 ctl
0x376 bmdma 0xffa8 irq 15
Oct  8 02:35:04 (none) kernel: ata1.00: ATA-8: ASUS-JM S41 SSD,
02.10102, max UDMA/100
Oct  8 02:35:04 (none) kernel: ata1.00: 63078400 sectors, multi 0: LBA
Oct  8 02:35:04 (none) kernel: ata1.00: configured for UDMA/100
Oct  8 02:35:04 (none) kernel: scsi 0:0:0:0: Direct-Access     ATA
 ASUS-JM S41 SSD  02.1 PQ: 0 ANSI: 5
Oct  8 02:35:04 (none) kernel: ATL1E 0000:02:00.0: PCI INT A -> GSI 17
(level, low) -> IRQ 17
Oct  8 02:35:04 (none) kernel: ATL1E 0000:02:00.0: setting latency time=
r to 64
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: [sda] 63078400 512-byte
logical blocks: (32.2 GB/30.0 GiB)
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 0=
0
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: [sda] Write cache:
disabled, read cache: enabled, doesn't support DPO or FUA
Oct  8 02:35:04 (none) kernel: sda: sda1 sda2 sda3
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Oct  8 02:35:04 (none) kernel: sd 0:0:0:0: Attached scsi generic sg0 ty=
pe 0
Oct  8 02:35:04 (none) kernel: cfg80211: Calling CRDA to update world
regulatory domain
Oct  8 02:35:04 (none) kernel: cfg80211: World regulatory domain update=
d:
Oct  8 02:35:04 (none) kernel: (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Oct  8 02:35:04 (none) kernel: (2402000 KHz - 2472000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
Oct  8 02:35:04 (none) kernel: (2457000 KHz - 2482000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
Oct  8 02:35:04 (none) kernel: (2474000 KHz - 2494000 KHz @ 20000
KHz), (300 mBi, 2000 mBm)
Oct  8 02:35:04 (none) kernel: (5170000 KHz - 5250000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
Oct  8 02:35:04 (none) kernel: (5735000 KHz - 5835000 KHz @ 40000
KHz), (300 mBi, 2000 mBm)
Oct  8 02:35:04 (none) kernel: ath9k 0000:01:00.0: PCI INT A -> GSI 18
(level, low) -> IRQ 18
Oct  8 02:35:04 (none) kernel: ath9k 0000:01:00.0: setting latency time=
r to 64
Oct  8 02:35:04 (none) kernel: ath: EEPROM regdomain: 0x60
Oct  8 02:35:04 (none) kernel: ath: EEPROM indicates we should expect
a direct regpair map
Oct  8 02:35:04 (none) kernel: ath: Country alpha2 being used: 00
Oct  8 02:35:04 (none) kernel: ath: Regpair used: 0x60
Oct  8 02:35:04 (none) kernel: phy0: Selected rate control algorithm
'ath9k_rate_control'
Oct  8 02:35:04 (none) kernel: Registered led device: ath9k-phy0::radio
Oct  8 02:35:04 (none) kernel: Registered led device: ath9k-phy0::assoc
Oct  8 02:35:04 (none) kernel: Registered led device: ath9k-phy0::tx
Oct  8 02:35:04 (none) kernel: Registered led device: ath9k-phy0::rx
Oct  8 02:35:04 (none) kernel: phy0: Atheros AR9280 Rev:2 mem=3D0xf8700=
000, irq=3D18
Oct  8 02:35:04 (none) kernel: usbcore: registered new interface driver=
 usbfs
Oct  8 02:35:04 (none) kernel: usbcore: registered new interface driver=
 hub
Oct  8 02:35:04 (none) kernel: usbcore: registered new device driver us=
b
Oct  8 02:35:04 (none) kernel: ehci_hcd: USB 2.0 'Enhanced' Host
Controller (EHCI) Driver
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI
23 (level, low) -> IRQ 23
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: EHCI Host Control=
ler
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: new USB bus
registered, assigned bus number 1
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: using broken
periodic workaround
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: debug port 1
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: cache line size
of 32 is not supported
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: irq 23, io mem 0x=
fbcb7c00
Oct  8 02:35:04 (none) kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, =
EHCI 1.00
Oct  8 02:35:04 (none) kernel: hub 1-0:1.0: USB hub found
Oct  8 02:35:04 (none) kernel: hub 1-0:1.0: 8 ports detected
Oct  8 02:35:04 (none) kernel: uhci_hcd: USB Universal Host Controller
Interface driver
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI
23 (level, low) -> IRQ 23
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.0: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.0: UHCI Host Control=
ler
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.0: new USB bus
registered, assigned bus number 2
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.0: irq 23, io base 0=
x0000d480
Oct  8 02:35:04 (none) kernel: hub 2-0:1.0: USB hub found
Oct  8 02:35:04 (none) kernel: hub 2-0:1.0: 2 ports detected
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI
22 (level, low) -> IRQ 22
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.1: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.1: UHCI Host Control=
ler
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.1: new USB bus
registered, assigned bus number 3
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.1: irq 22, io base 0=
x0000d800
Oct  8 02:35:04 (none) kernel: hub 3-0:1.0: USB hub found
Oct  8 02:35:04 (none) kernel: hub 3-0:1.0: 2 ports detected
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI
21 (level, low) -> IRQ 21
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.2: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.2: UHCI Host Control=
ler
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.2: new USB bus
registered, assigned bus number 4
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.2: irq 21, io base 0=
x0000d880
Oct  8 02:35:04 (none) kernel: hub 4-0:1.0: USB hub found
Oct  8 02:35:04 (none) kernel: hub 4-0:1.0: 2 ports detected
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI
20 (level, low) -> IRQ 20
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.3: setting latency
timer to 64
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.3: UHCI Host Control=
ler
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.3: new USB bus
registered, assigned bus number 5
Oct  8 02:35:04 (none) kernel: uhci_hcd 0000:00:1d.3: irq 20, io base 0=
x0000dc00
Oct  8 02:35:04 (none) kernel: hub 5-0:1.0: USB hub found
Oct  8 02:35:04 (none) kernel: hub 5-0:1.0: 2 ports detected
Oct  8 02:35:04 (none) kernel: usb 1-3: new high speed USB device
using ehci_hcd and address 2
Oct  8 02:35:04 (none) kernel: usb 1-5: new high speed USB device
using ehci_hcd and address 3
Oct  8 02:35:04 (none) kernel: hub 1-0:1.0: unable to enumerate USB
device on port 7
Oct  8 02:35:04 (none) kernel: usb 1-8: new high speed USB device
using ehci_hcd and address 5
Oct  8 02:35:04 (none) kernel: Initializing USB Mass Storage driver...
Oct  8 02:35:04 (none) kernel: scsi2 : usb-storage 1-3:1.0
Oct  8 02:35:04 (none) kernel: scsi3 : usb-storage 1-5:1.0
Oct  8 02:35:04 (none) kernel: usbcore: registered new interface
driver usb-storage
Oct  8 02:35:04 (none) kernel: USB Mass Storage support registered.
Oct  8 02:35:04 (none) kernel: scsi 2:0:0:0: Direct-Access     usb 2.0
 Flash Disk       5.00 PQ: 0 ANSI: 2
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: Attached scsi generic sg1 ty=
pe 0
Oct  8 02:35:04 (none) kernel: scsi 3:0:0:0: Direct-Access     Multi
 Flash Reader     1.00 PQ: 0 ANSI: 0
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] 2048000 512-byte
logical blocks: (1.04 GB/1000 MiB)
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: Attached scsi generic sg2 ty=
pe 0
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Write Protect is off
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Mode Sense: 0b 00 00 0=
8
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sdb: sdb1
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sd 2:0:0:0: [sdb] Attached SCSI removabl=
e disk
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] 245504 512-byte
logical blocks: (125 MB/119 MiB)
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Write Protect is off
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Mode Sense: 03 00 00 0=
0
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sdc: sdc1
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Assuming drive cache:
write through
Oct  8 02:35:04 (none) kernel: sd 3:0:0:0: [sdc] Attached SCSI removabl=
e disk
Oct  8 02:35:04 (none) kernel: floppy0: no floppy controllers found
Oct  8 02:35:04 (none) kernel: device-mapper: uevent: version 1.0.3
Oct  8 02:35:04 (none) kernel: device-mapper: ioctl: 4.17.0-ioctl
(2010-03-05) initialised: dm-devel@redhat.com
Oct  8 02:35:04 (none) kernel: Btrfs loaded
Oct  8 02:35:04 (none) kernel: device label root devid 1 transid 62826 =
/dev/sda2
Oct  8 02:35:04 (none) kernel: loop: module loaded
Oct  8 02:35:04 (none) kernel: NET: Registered protocol family 10
Oct  8 02:35:04 (none) kernel: lo: Disabled Privacy Extensions
Oct  8 02:36:42 (none) kernel: device label root devid 1 transid 62826 =
/dev/sda2
Oct  8 02:38:01 (none) kernel: ATL1E 0000:02:00.0: irq 44 for MSI/MSI-X
Oct  8 02:38:01 (none) kernel: ATL1E 0000:02:00.0: eth0: NIC Link is
Up <100 Mbps Full Duplex>
Oct  8 02:38:01 (none) kernel: ADDRCONF(NETDEV_UP): eth0: link is not r=
eady
Oct  8 02:38:01 (none) kernel: ADDRCONF(NETDEV_CHANGE): eth0: link beco=
mes ready
Oct  8 02:38:12 (none) kernel: eth0: no IPv6 routers present
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs: sda2 checksum verify failed on
24630292480 wanted 140000C found 48DE1BDD level 0
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs: sda2 checksum verify failed on
24630292480 wanted 140000C found 48DE1BDD level 0
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:26 (none) kernel: btrfs: sda2 checksum verify failed on
24630292480 wanted 140000C found 48DE1BDD level 0
Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 24630358016
24630292480
Oct  8 02:38:27 (none) kernel: ata1.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x0
Oct  8 02:38:27 (none) kernel: ata1.00: BMDMA stat 0x24
Oct  8 02:38:27 (none) kernel: ata1.00: failed command: READ DMA
Oct  8 02:38:27 (none) kernel: ata1.00: cmd
c8/00:08:7c:3b:41/00:00:00:00:00/e3 tag 0 dma 4096 in
Oct  8 02:38:27 (none) kernel: res 51/40:08:7c:3b:41/00:00:00:00:00/e3
Emask 0x9 (media error)
Oct  8 02:38:27 (none) kernel: ata1.00: status: { DRDY ERR }
Oct  8 02:38:27 (none) kernel: ata1.00: error: { UNC }
Oct  8 02:38:32 (none) kernel: ata1.00: qc timeout (cmd 0xef)
Oct  8 02:38:32 (none) kernel: ata1.00: failed to set xfermode (err_mas=
k=3D0x4)
Oct  8 02:38:37 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:38:42 (none) kernel: ata1: device not ready (errno=3D-16),
forcing hardreset
Oct  8 02:38:42 (none) kernel: ata1: soft resetting link
Oct  8 02:38:47 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:38:52 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:38:52 (none) kernel: ata1: soft resetting link
Oct  8 02:38:57 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:39:02 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:39:02 (none) kernel: ata1: soft resetting link
Oct  8 02:39:07 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:39:37 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:39:37 (none) kernel: ata1: soft resetting link
Oct  8 02:39:42 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:39:42 (none) kernel: ata1: reset failed, giving up
Oct  8 02:39:42 (none) kernel: ata1.00: disabled
Oct  8 02:39:47 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:39:52 (none) kernel: ata1: device not ready (errno=3D-16),
forcing hardreset
Oct  8 02:39:52 (none) kernel: ata1: soft resetting link
Oct  8 02:39:58 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:40:02 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:40:02 (none) kernel: ata1: soft resetting link
Oct  8 02:40:08 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:40:12 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:40:12 (none) kernel: ata1: soft resetting link
Oct  8 02:40:18 (none) kernel: ata1: link is slow to respond, please
be patient (ready=3D0)
Oct  8 02:40:43 (none) kernel: INFO: task ata_aux:633 blocked for more
than 120 seconds.
Oct  8 02:40:43 (none) kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  8 02:40:43 (none) kernel: ata_aux       D f06f9cc4     0   633
  2 0x00000000
Oct  8 02:40:43 (none) kernel: f06f9cd4 00000046 00000002 f06f9cc4
c10eaadd 00000046 00000046 c12f2680
Oct  8 02:40:43 (none) kernel: c4808140 c1180ee6 c1487140 c1487140
c1487140 f07226d0 c1487140 00000000
Oct  8 02:40:43 (none) kernel: c1182eb0 c1487140 f07226d0 00000001
00000000 7fffffff f06f9d94 f06f9d38
Oct  8 02:40:43 (none) kernel: Call Trace:
Oct  8 02:40:43 (none) kernel: [<c10eaadd>] ? kmem_cache_alloc+0x8d/0x1=
10
Oct  8 02:40:43 (none) kernel: [<c1180ee6>] ?
cfq_init_prio_data.clone.99+0x66/0x120
Oct  8 02:40:43 (none) kernel: [<c1182eb0>] ? cfq_get_queue+0x460/0x590
Oct  8 02:40:43 (none) kernel: [<c12e730d>] schedule_timeout+0x18d/0x2b=
0
Oct  8 02:40:43 (none) kernel: [<c11850fd>] ? kobject_put+0x1d/0x50
Oct  8 02:40:43 (none) kernel: [<c121b1bf>] ? put_device+0xf/0x20
Oct  8 02:40:43 (none) kernel: [<c12e6696>] wait_for_common+0x96/0x120
Oct  8 02:40:43 (none) kernel: [<c103df80>] ? default_wake_function+0x0=
/0x10
Oct  8 02:40:43 (none) kernel: [<c12e67c2>] wait_for_completion+0x12/0x=
20
Oct  8 02:40:43 (none) kernel: [<c1176448>] blk_execute_rq+0x78/0xd0
Oct  8 02:40:43 (none) kernel: [<c1176310>] ? blk_end_sync_rq+0x0/0x30
Oct  8 02:40:43 (none) kernel: [<c117295d>] ? get_request_wait+0x1d/0x1=
90
Oct  8 02:40:43 (none) kernel: [<c103570d>] ?
wakeup_preempt_entity.clone.94+0x8d/0xa0
Oct  8 02:40:43 (none) kernel: [<c1172b2b>] ? blk_get_request+0x5b/0x80
Oct  8 02:40:43 (none) kernel: [<f84318b7>] scsi_execute+0xc7/0x110 [sc=
si_mod]
Oct  8 02:40:43 (none) kernel: [<f8431985>]
scsi_execute_req+0x85/0x160 [scsi_mod]
Oct  8 02:40:43 (none) kernel: [<f84f11a0>]
sd_revalidate_disk+0x100/0x1cb0 [sd_mod]
Oct  8 02:40:43 (none) kernel: [<c1185242>] ? kobject_get+0x12/0x20
Oct  8 02:40:43 (none) kernel: [<c111faf4>] revalidate_disk+0x24/0x70
Oct  8 02:40:43 (none) kernel: [<c12e7f88>] ? mutex_unlock+0x8/0x10
Oct  8 02:40:43 (none) kernel: [<f84efc8a>] sd_rescan+0x1a/0x30 [sd_mod=
]
Oct  8 02:40:43 (none) kernel: [<f84338b4>]
scsi_rescan_device+0x74/0x100 [scsi_mod]
Oct  8 02:40:43 (none) kernel: [<c121b193>] ? get_device+0x13/0x20
Oct  8 02:40:43 (none) kernel: [<f84922dc>]
ata_scsi_dev_rescan+0x8c/0xe0 [libata]
Oct  8 02:40:43 (none) kernel: [<f8492250>] ?
ata_scsi_dev_rescan+0x0/0xe0 [libata]
Oct  8 02:40:43 (none) kernel: [<c105abc0>] worker_thread+0x110/0x250
Oct  8 02:40:43 (none) kernel: [<c102f0b0>] ? __wake_up_common+0x40/0x7=
0
Oct  8 02:40:43 (none) kernel: [<c105eb30>] ? autoremove_wake_function+=
0x0/0x40
Oct  8 02:40:43 (none) kernel: [<c105aab0>] ? worker_thread+0x0/0x250
Oct  8 02:40:43 (none) kernel: [<c105e71c>] kthread+0x6c/0x80
Oct  8 02:40:43 (none) kernel: [<c105e6b0>] ? kthread+0x0/0x80
Oct  8 02:40:43 (none) kernel: [<c1003d3e>] kernel_thread_helper+0x6/0x=
18
Oct  8 02:40:43 (none) kernel: INFO: task tar:1323 blocked for more
than 120 seconds.
Oct  8 02:40:43 (none) kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  8 02:40:43 (none) kernel: tar           D c3059b24     0  1323
1258 0x00000004
Oct  8 02:40:43 (none) kernel: c3059b34 00000082 00000002 c3059b24
c3898000 f706a000 c4382a00 c12f2680
Oct  8 02:40:43 (none) kernel: c4a08140 c10682af c1487140 c1487140
c1487140 f066af70 c1487140 00000000
Oct  8 02:40:43 (none) kernel: 00443c53 c1487140 f066af70 00000001
f066af70 c4a08140 c3059b7c c3059b44
Oct  8 02:40:43 (none) kernel: Call Trace:
Oct  8 02:40:43 (none) kernel: [<c10682af>] ? ktime_get_ts+0xff/0x130
Oct  8 02:40:43 (none) kernel: [<c12e6f1c>] io_schedule+0x5c/0xa0
Oct  8 02:40:43 (none) kernel: [<c10bd825>] sync_page+0x35/0x40
Oct  8 02:40:43 (none) kernel: [<c12e75d5>] __wait_on_bit+0x45/0x70
Oct  8 02:40:43 (none) kernel: [<c10bd7f0>] ? sync_page+0x0/0x40
Oct  8 02:40:43 (none) kernel: [<c10bda76>] wait_on_page_bit+0x86/0x90
Oct  8 02:40:43 (none) kernel: [<c105eb70>] ? wake_bit_function+0x0/0x6=
0
Oct  8 02:40:43 (none) kernel: [<f89bde39>]
read_extent_buffer_pages+0x489/0x4c0 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f8994c2b>]
btree_read_extent_buffer_pages.clone.60+0x4b/0xb0 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f89939d0>] ? btree_get_extent+0x0/0x1c=
0 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f89959b7>] read_tree_block+0x47/0x60 [=
btrfs]
Oct  8 02:40:43 (none) kernel: [<f897e185>]
read_block_for_search.clone.38+0xe5/0x330 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f8980656>]
btrfs_search_slot+0x1f6/0x670 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f89b361f>] ?
btrfs_dir_name_len+0xdf/0xf0 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f8993416>] btrfs_lookup_inode+0x36/0xb=
0 [btrfs]
Oct  8 02:40:43 (none) kernel: [<c110b83a>] ? iget5_locked+0x16a/0x190
Oct  8 02:40:43 (none) kernel: [<f89a37ec>] btrfs_iget+0xdc/0x420 [btrf=
s]
Oct  8 02:40:43 (none) kernel: [<f89a3fce>]
btrfs_lookup_dentry+0x1de/0x430 [btrfs]
Oct  8 02:40:43 (none) kernel: [<f89a422b>] btrfs_lookup+0xb/0x20 [btrf=
s]
Oct  8 02:40:43 (none) kernel: [<c10ffc1b>] do_lookup+0x15b/0x1c0
Oct  8 02:40:43 (none) kernel: [<c110183d>] link_path_walk+0x42d/0x920
Oct  8 02:40:43 (none) kernel: [<c1101e34>] path_walk+0x44/0xa0
Oct  8 02:40:43 (none) kernel: [<c1101f91>] do_path_lookup+0x51/0x90
Oct  8 02:40:43 (none) kernel: [<c110230c>] user_path_at+0x3c/0x70
Oct  8 02:40:43 (none) kernel: [<c118d8ae>] ? copy_to_user+0x2e/0x50
Oct  8 02:40:43 (none) kernel: [<c10fac85>] vfs_fstatat+0x35/0x80
Oct  8 02:40:43 (none) kernel: [<c1183b50>] ? _atomic_dec_and_lock+0x50=
/0x70
Oct  8 02:40:43 (none) kernel: [<c10faceb>] vfs_lstat+0x1b/0x20
Oct  8 02:40:43 (none) kernel: [<c10faf94>] sys_lstat64+0x14/0x30
Oct  8 02:40:43 (none) kernel: [<c10f4ef9>] ? filp_close+0x49/0x70
Oct  8 02:40:43 (none) kernel: [<c10f4f8f>] ? sys_close+0x6f/0xc0
Oct  8 02:40:43 (none) kernel: [<c100379f>] sysenter_do_call+0x12/0x28
Oct  8 02:40:47 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:40:47 (none) kernel: ata1: soft resetting link
Oct  8 02:40:52 (none) kernel: ata1: SRST failed (errno=3D-16)
Oct  8 02:40:52 (none) kernel: ata1: reset failed, giving up
Oct  8 02:40:52 (none) kernel: ata1: EH complete
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Unhandled error code
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Result: hostbyte=3D0x0=
4
driverbyte=3D0x00
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x28: 28
00 03 41 3b 7c 00 00 08 00
Oct  8 02:40:52 (none) kernel: end_request: I/O error, dev sda, sector =
54606716
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Unhandled error code
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Result: hostbyte=3D0x0=
4
driverbyte=3D0x00
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x28: 28
00 03 3d 83 74 00 00 08 00
Oct  8 02:40:52 (none) kernel: end_request: I/O error, dev sda, sector =
54362996
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] READ CAPACITY(16) fail=
ed
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Result: hostbyte=3D0x0=
4
driverbyte=3D0x00
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Sense not available.
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] READ CAPACITY failed
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Result: hostbyte=3D0x0=
4
driverbyte=3D0x00
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Sense not available.
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Asking for cache data =
failed
Oct  8 02:40:52 (none) kernel: sd 0:0:0:0: [sda] Assuming drive cache:
write through
Oct  8 02:40:52 (none) kernel: sda: detected capacity change from
32296140800 to 0
Oct  8 02:40:52 (none) kernel: ------------[ cut here ]------------
Oct  8 02:40:52 (none) kernel: WARNING: at fs/btrfs/extent_io.c:3690
copy_extent_buffer+0x117/0x150 [btrfs]()
Oct  8 02:40:52 (none) kernel: Hardware name: S101
Oct  8 02:40:52 (none) kernel: Modules linked in: ipv6 loop btrfs
zlib_deflate crc32c libcrc32c dm_crypt md_mod dm_mirror dm_region_hash
dm_log dm_mod usb_storage uhci_hcd ehci_hcd usbcore arc4 ecb ath9k
ath9k_common ath9k_hw ath mac80211 cfg80211 sg sd_mod atl1e ata_piix
libata scsi_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss
snd soundcore rtc_cmos rtc_core rtc_lib eeepc_laptop rfkill
pci_hotplug led_class sparse_keymap pcspkr intel_agp agpgart video
output thermal processor button battery ac
Oct  8 02:40:52 (none) kernel: Pid: 1291, comm: btrfs-transacti Not
tainted 2.6.35-ARCH #1
Oct  8 02:40:52 (none) kernel: Call Trace:
Oct  8 02:40:52 (none) kernel: [<c10439bd>] warn_slowpath_common+0x6d/0=
xa0
Oct  8 02:40:52 (none) kernel: [<f89be7e7>] ?
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89be7e7>] ?
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c1043a0d>] warn_slowpath_null+0x1d/0x2=
0
Oct  8 02:40:52 (none) kernel: [<f89be7e7>]
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e91d>] __push_leaf_left+0x18d/0x6d=
0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e745>] ?
btrfs_leaf_free_space+0x45/0x90 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897ef83>] push_leaf_left+0x123/0x130 =
[btrfs]
Oct  8 02:40:52 (none) kernel: [<f898013a>] split_leaf+0x5fa/0x700 [btr=
fs]
Oct  8 02:40:52 (none) kernel: [<f897a355>] ? leaf_space_used+0x85/0xb0=
 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e745>] ?
btrfs_leaf_free_space+0x45/0x90 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89c9e4d>] ?
btrfs_set_lock_blocking+0x1d/0x30 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8980a4f>]
btrfs_search_slot+0x5ef/0x670 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89817d3>]
btrfs_insert_empty_items+0x53/0xa0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898bb06>]
run_clustered_refs+0x626/0x8c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89d4c01>] ?
btrfs_find_ref_cluster+0x1/0x1a0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898be47>]
btrfs_run_delayed_refs+0xa7/0x1c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89b706b>] ?
btrfs_run_ordered_operations+0x1db/0x1f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89996f4>]
btrfs_commit_transaction+0x64/0x6f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105eb30>] ? autoremove_wake_function+=
0x0/0x40
Oct  8 02:40:52 (none) kernel: [<f899443f>]
transaction_kthread+0x20f/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8994230>] ?
transaction_kthread+0x0/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105e71c>] kthread+0x6c/0x80
Oct  8 02:40:52 (none) kernel: [<c105e6b0>] ? kthread+0x0/0x80
Oct  8 02:40:52 (none) kernel: [<c1003d3e>] kernel_thread_helper+0x6/0x=
18
Oct  8 02:40:52 (none) kernel: ---[ end trace 8b4894fc857a26c6 ]---
Oct  8 02:40:52 (none) kernel: ------------[ cut here ]------------
Oct  8 02:40:52 (none) kernel: WARNING: at fs/btrfs/extent_io.c:3690
copy_extent_buffer+0x117/0x150 [btrfs]()
Oct  8 02:40:52 (none) kernel: Hardware name: S101
Oct  8 02:40:52 (none) kernel: Modules linked in: ipv6 loop btrfs
zlib_deflate crc32c libcrc32c dm_crypt md_mod dm_mirror dm_region_hash
dm_log dm_mod usb_storage uhci_hcd ehci_hcd usbcore arc4 ecb ath9k
ath9k_common ath9k_hw ath mac80211 cfg80211 sg sd_mod atl1e ata_piix
libata scsi_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss
snd soundcore rtc_cmos rtc_core rtc_lib eeepc_laptop rfkill
pci_hotplug led_class sparse_keymap pcspkr intel_agp agpgart video
output thermal processor button battery ac
Oct  8 02:40:52 (none) kernel: Pid: 1291, comm: btrfs-transacti
Tainted: G        W   2.6.35-ARCH #1
Oct  8 02:40:52 (none) kernel: Call Trace:
Oct  8 02:40:52 (none) kernel: [<c10439bd>] warn_slowpath_common+0x6d/0=
xa0
Oct  8 02:40:52 (none) kernel: [<f89be7e7>] ?
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89be7e7>] ?
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c1043a0d>] warn_slowpath_null+0x1d/0x2=
0
Oct  8 02:40:52 (none) kernel: [<f89be7e7>]
copy_extent_buffer+0x117/0x150 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e9a1>] __push_leaf_left+0x211/0x6d=
0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897ef83>] push_leaf_left+0x123/0x130 =
[btrfs]
Oct  8 02:40:52 (none) kernel: [<f898013a>] split_leaf+0x5fa/0x700 [btr=
fs]
Oct  8 02:40:52 (none) kernel: [<f897a355>] ? leaf_space_used+0x85/0xb0=
 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e745>] ?
btrfs_leaf_free_space+0x45/0x90 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89c9e4d>] ?
btrfs_set_lock_blocking+0x1d/0x30 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8980a4f>]
btrfs_search_slot+0x5ef/0x670 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89817d3>]
btrfs_insert_empty_items+0x53/0xa0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898bb06>]
run_clustered_refs+0x626/0x8c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89d4c01>] ?
btrfs_find_ref_cluster+0x1/0x1a0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898be47>]
btrfs_run_delayed_refs+0xa7/0x1c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89b706b>] ?
btrfs_run_ordered_operations+0x1db/0x1f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89996f4>]
btrfs_commit_transaction+0x64/0x6f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105eb30>] ? autoremove_wake_function+=
0x0/0x40
Oct  8 02:40:52 (none) kernel: [<f899443f>]
transaction_kthread+0x20f/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8994230>] ?
transaction_kthread+0x0/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105e71c>] kthread+0x6c/0x80
Oct  8 02:40:52 (none) kernel: [<c105e6b0>] ? kthread+0x0/0x80
Oct  8 02:40:52 (none) kernel: [<c1003d3e>] kernel_thread_helper+0x6/0x=
18
Oct  8 02:40:52 (none) kernel: ---[ end trace 8b4894fc857a26c7 ]---
Oct  8 02:40:52 (none) kernel: ------------[ cut here ]------------
Oct  8 02:40:52 (none) kernel: kernel BUG at fs/btrfs/ctree.c:2628!
Oct  8 02:40:52 (none) kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Oct  8 02:40:52 (none) kernel: last sysfs file:
/sys/devices/virtual/bdi/btrfs-1/uevent
Oct  8 02:40:52 (none) kernel: Modules linked in: ipv6 loop btrfs
zlib_deflate crc32c libcrc32c dm_crypt md_mod dm_mirror dm_region_hash
dm_log dm_mod usb_storage uhci_hcd ehci_hcd usbcore arc4 ecb ath9k
ath9k_common ath9k_hw ath mac80211 cfg80211 sg sd_mod atl1e ata_piix
libata scsi_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_hwdep snd_pcm_oss snd_pcm snd_timer snd_page_alloc snd_mixer_oss
snd soundcore rtc_cmos rtc_core rtc_lib eeepc_laptop rfkill
pci_hotplug led_class sparse_keymap pcspkr intel_agp agpgart video
output thermal processor button battery ac
Oct  8 02:40:52 (none) kernel:
Oct  8 02:40:52 (none) kernel: Pid: 1291, comm: btrfs-transacti
Tainted: G        W   2.6.35-ARCH #1 S101/S101
Oct  8 02:40:52 (none) kernel: EIP: 0060:[<f897ee50>] EFLAGS: 00010246 =
CPU: 0
Oct  8 02:40:52 (none) kernel: EIP is at __push_leaf_left+0x6c0/0x6d0 [=
btrfs]
Oct  8 02:40:52 (none) kernel: EAX: c373a000 EBX: 00000010 ECX:
c148eedc EDX: 00000000
Oct  8 02:40:52 (none) kernel: ESI: 00000000 EDI: c2cd3f00 EBP:
c373bcf8 ESP: c373bc88
Oct  8 02:40:52 (none) kernel: DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: =
0068
Oct  8 02:40:52 (none) kernel: Process btrfs-transacti (pid: 1291,
ti=3Dc373a000 task=3Df0720cf0 task.ti=3Dc373a000)
Oct  8 02:40:52 (none) kernel: Stack:
Oct  8 02:40:52 (none) kernel: 00000cf6 0000030a c2cd3f14 c2cd3f18
00000004 c373bcac f376d270 c2cd3f0c
Oct  8 02:40:52 (none) kernel: <0> c2cd3f10 c2cd3f14 c2cd3f18 fffff000
f707e000 00000190 000001dc 00000f9b
Oct  8 02:40:52 (none) kernel: <0> 00000000 f376ea80 00000cf6 0000030a
00000000 0000f56b 00000000 f707e000
Oct  8 02:40:52 (none) kernel: Call Trace:
Oct  8 02:40:52 (none) kernel: [<f897ef83>] ? push_leaf_left+0x123/0x13=
0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898013a>] ? split_leaf+0x5fa/0x700 [b=
trfs]
Oct  8 02:40:52 (none) kernel: [<f897a355>] ? leaf_space_used+0x85/0xb0=
 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f897e745>] ?
btrfs_leaf_free_space+0x45/0x90 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89c9e4d>] ?
btrfs_set_lock_blocking+0x1d/0x30 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8980a4f>] ?
btrfs_search_slot+0x5ef/0x670 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89817d3>] ?
btrfs_insert_empty_items+0x53/0xa0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898bb06>] ?
run_clustered_refs+0x626/0x8c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89d4c01>] ?
btrfs_find_ref_cluster+0x1/0x1a0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f898be47>] ?
btrfs_run_delayed_refs+0xa7/0x1c0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89b706b>] ?
btrfs_run_ordered_operations+0x1db/0x1f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f89996f4>] ?
btrfs_commit_transaction+0x64/0x6f0 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105eb30>] ? autoremove_wake_function+=
0x0/0x40
Oct  8 02:40:52 (none) kernel: [<f899443f>] ?
transaction_kthread+0x20f/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<f8994230>] ?
transaction_kthread+0x0/0x230 [btrfs]
Oct  8 02:40:52 (none) kernel: [<c105e71c>] ? kthread+0x6c/0x80
Oct  8 02:40:52 (none) kernel: [<c105e6b0>] ? kthread+0x0/0x80
Oct  8 02:40:52 (none) kernel: [<c1003d3e>] ? kernel_thread_helper+0x6/=
0x18
Oct  8 02:40:52 (none) kernel: Code: 18 89 5c 24 04 c7 04 24 03 da 9d
f8 89 44 24 08 e8 8b 76 96 c8 ba 61 0a 00 00 b8 d6 d9 9d f8 e8 a7 4b
6c c8 e9 68 fc ff ff 0f 0b <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00
00 00 55 89 e5 83 ec
Oct  8 02:40:52 (none) kernel: EIP: [<f897ee50>]
__push_leaf_left+0x6c0/0x6d0 [btrfs] SS:ESP 0068:c373bc88
Oct  8 02:40:52 (none) kernel: ---[ end trace 8b4894fc857a26c8 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
