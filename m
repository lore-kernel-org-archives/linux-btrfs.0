From: Marek Otahal <markotahal@gmail.com>
Subject: btrfs error: 'disk full' although 8 of 21 GB free
Date: Wed, 7 Apr 2010 16:59:02 +0200
Message-ID: <201004071659.03927.markotahal@gmail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_32JvLGE+icxGBvh"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Boundary-00=_32JvLGE+icxGBvh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi, 
I'm running archlinux, kernel 2.6.33.2, btrfs-progs 0.19. 
I was copying a folder (cca 2GB) to a btrfs partition(8GB free) and got a 
'disk full' error message. Had to kill the process and remove the files 
otherwise apps report full disk. 
I can always reproduce this by creating some big files on the partition. 
Since then, btrfsck reports errors, is there a way to fix them? 
Thank you, Mark

// here follows contents of files attached for your comfort

Here are some clues: 

*output of df -h: 

Filesystem            Size  Used Avail Use% Mounted on
/dev/sda5              20G   13G  6.0G  68% /
udev                   10M  248K  9.8M   3% /dev
none                  1.0G     0  1.0G   0% /dev/shm
/dev/mapper/homeDevice
                       21G   13G  8.0G  62% /home
tmpfs                 3.0G   29M  3.0G   1% /tmp
/dev/sda8             3.4G  2.3G  976M  71% /var
/dev/sda2             145M   20M  118M  15% /boot
/dev/mapper/storeDevice
                       40G   38G  2.0G  96% /mnt/store
/dev/sda10             18G  9.1G  7.4G  56% /mnt/recovery
/dev/sda12            9.8G  9.6G  206M  98% /media/disk
/dev/sda1              30G   22G  7.5G  75% /mnt/winxp

* I've heard df has issues with btrfs, but du -sh /mountpoint reports approx 
same size used

*btrfsck /dev/mapper/homeDevice - is there a way to fix these errors?? I'm 
worried to take snapshots or defragment not to make it worse. 

root 5 inode 552424 errors 2
root 5 inode 552425 errors 2
root 5 inode 552426 errors 2
root 5 inode 552427 errors 2
root 5 inode 552429 errors 2
root 5 inode 552431 errors 2
root 5 inode 552515 errors 2
found 13520416768 bytes used err is 1
total csum bytes: 12991604
total tree bytes: 217014272
total fs tree bytes: 182243328
btree space waste bytes: 63087601
file data blocks allocated: 50432675840
 referenced 12764286976
Btrfs Btrfs v0.19

*dmesg /snip/

no space left, need 32768, 0 delalloc bytes, 15466033152 bytes_used, 80084992 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 0 delalloc bytes, 15466033152 bytes_used, 80084992 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 
total
no space left, need 32768, 0 delalloc bytes, 15470936064 bytes_used, 75182080 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 
total
no space left, need 40960, 0 delalloc bytes, 15470936064 bytes_used, 75182080 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 
total
no space left, need 12288, 0 delalloc bytes, 15476994048 bytes_used, 69124096 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 
total
no space left, need 4096, 4096 delalloc bytes, 15515852800 bytes_used, 
30105600 bytes_reserved, 159744 bytes_pinned, 0 bytes_readonly, 0 may use 
15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 200704 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 200704 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 200704 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 200704 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 
bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total


* btrfs-show

Label: home  uuid: 5682534d-9365-4e78-a37b-30b51fff5e49
        Total devices 1 FS bytes used 12.59GB
        devid    1 size 20.50GB used 20.50GB path /dev/dm-2

Label: store  uuid: c2bbe121-e7f2-48f4-9fb1-77252304ce4c
        Total devices 1 FS bytes used 37.14GB
        devid    1 size 39.06GB used 39.04GB path /dev/dm-3

Btrfs Btrfs v0.19


* btrfs-debug-tree
 it's a 115MB file, i am uploading it and will post a link asap.


-- 

Marek Otahal :o)

--Boundary-00=_32JvLGE+icxGBvh
Content-Type: text/plain;
  charset="UTF-8";
  name="btrfs_dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfs_dmesg.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-ARCH (tobias@T-POWA-LX) (gcc version 4.4.3 20100316 (prerelease) (GCC) ) #1 SMP PREEMPT Mon Apr 5 05:57:38 UTC 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6e2000 (ACPI data)
 BIOS-e820: 000000007f6e2000 - 000000007f6e3000 (ACPI NVS)
 BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.5 present.
last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask 080000000 write-back
  1 base 07F700000 mask 0FFF00000 uncachable
  2 base 07F800000 mask 0FF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000000002000 - 0000000000010000 (usable) ==> (reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000002000 (usable)
 modified: 0000000000002000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009f800 (usable)
 modified: 000000000009f800 - 00000000000a0000 (reserved)
 modified: 00000000000d2000 - 00000000000d4000 (reserved)
 modified: 00000000000dc000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000007f6d0000 (usable)
 modified: 000000007f6d0000 - 000000007f6e2000 (ACPI data)
 modified: 000000007f6e2000 - 000000007f6e3000 (ACPI NVS)
 modified: 000000007f6e3000 - 0000000080000000 (reserved)
 modified: 00000000e0000000 - 00000000f0000000 (reserved)
 modified: 00000000fec00000 - 00000000fec10000 (reserved)
 modified: 00000000fed00000 - 00000000fed00400 (reserved)
 modified: 00000000fed14000 - 00000000fed1a000 (reserved)
 modified: 00000000fed1c000 - 00000000fed90000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000ff000000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 01800000
found SMP MP-table at [c00f7b60] f7b60
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 15000-1a000
RAMDISK: 37cab000 - 37fefb12
Allocated new RAMDISK: 00100000 - 00444b12
Move RAMDISK from 0000000037cab000 - 0000000037fefb11 to 00100000 - 00444b11
ACPI: RSDP 000f7a50 00024 (v02 PTLTD )
ACPI: XSDT 7f6da0f4 0007C (v01 LENOVO CB-01    06040000  LTP 00000000)
ACPI: FACP 7f6e1d4d 000F4 (v03 INTEL  CALISTGA 06040000 ALAN 00000001)
ACPI: DSDT 7f6db2ee 069EB (v01 INTEL  CALISTGA 06040000 INTL 20061109)
ACPI: FACS 7f6e2fc0 00040
ACPI: HPET 7f6e1e41 00038 (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
ACPI: MCFG 7f6e1e79 0003C (v01 INTEL  CALISTGA 06040000 LOHR 0000005A)
ACPI: TCPA 7f6e1eb5 00032 (v01 PTLTD  CALISTGA 06040000  PTL 00000001)
ACPI: TMOR 7f6e1ee7 00026 (v01 PTLTD           06040000 PTL  00000003)
ACPI: APIC 7f6e1f0d 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 7f6e1f75 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: ASF! 7f6e1f9d 00063 (v16   CETP     CETP 06040000 PTL  00000001)
ACPI: SSDT 7f6da70c 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
ACPI: SSDT 7f6da666 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050624)
ACPI: SSDT 7f6da170 004F6 (v02  PmRef    CpuPm 00003000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
1150MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
  node 0 low ram: 00000000 - 377fe000
  node 0 bootmap 00016000 - 0001cf00
(14 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0001000000 - 00015543c4]    TEXT DATA BSS ==> [0001000000 - 00015543c4]
  #3 [0001555000 - 000155b210]              BRK ==> [0001555000 - 000155b210]
  #4 [00000f7b70 - 0000100000]    BIOS reserved ==> [00000f7b70 - 0000100000]
  #5 [00000f7b60 - 00000f7b70]     MP-table mpf ==> [00000f7b60 - 00000f7b70]
  #6 [000009f800 - 000009fc71]    BIOS reserved ==> [000009f800 - 000009fc71]
  #7 [000009fdb9 - 00000f7b60]    BIOS reserved ==> [000009fdb9 - 00000f7b60]
  #8 [000009fc71 - 000009fdb9]     MP-table mpc ==> [000009fc71 - 000009fdb9]
  #9 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
  #10 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
  #11 [0000015000 - 0000016000]          PGTABLE ==> [0000015000 - 0000016000]
  #12 [0000100000 - 0000444b12]      NEW RAMDISK ==> [0000100000 - 0000444b12]
  #13 [0000016000 - 000001d000]          BOOTMAP ==> [0000016000 - 000001d000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0007f6d0
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x00000002
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007f6d0
On node 0 totalpages: 521825
free_area_init_node: node 0, pgdat c13f9840, node_mem_map c155d000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3953 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 2302 pages used for memmap
  HighMem zone: 292308 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 0000000000002000 - 0000000000010000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 14 pages/cpu @c2800000 s34776 r0 d22568 u2097152
pcpu-alloc: s34776 r0 d22568 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517747
Kernel command line: BOOT_IMAGE=/vmlinuz26 root=/dev/disk/by-label/arch cryptdevice=/dev/sda6:preDevice resume=/dev/mapper/swapDevice ro quiet console=tty1 logo.nologo splash=silent,theme:arch-banner-icons,fadein,fadeout rootdelay=2 fastboot
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
allocated 10438720 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Initializing HighMem for node 0 (000377fe:0007f6d0)
Memory: 2049960k/2087744k available (2903k kernel code, 36332k reserved, 1201k data, 420k init, 1178440k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc1403000 - 0xc146c000   ( 420 kB)
      .data : 0xc12d5c09 - 0xc14022a8   (1201 kB)
      .text : 0xc1000000 - 0xc12d5c09   (2903 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:512
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty1] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1596.100 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.20 BogoMIPS (lpj=5320333)
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
Performance Events: Atom events, Intel PMU driver.
... version:                3
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
Checking 'hlt' instruction... OK.
ACPI: Core revision 20091214
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Booting Node   0, Processors  #1 Ok.
Initializing CPU#1
CPU1: Thermal monitoring handled by SMI
Brought up 2 CPUs
Total of 2 processors activated (6386.19 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x80000000-0xfebfffff] (ignored)
pci 0000:00:02.0: reg 10: [mem 0xf0500000-0xf057ffff]
pci 0000:00:02.0: reg 14: [io  0x1800-0x1807]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
pci 0000:00:02.0: reg 1c: [mem 0xf0600000-0xf063ffff]
pci 0000:00:02.1: reg 10: [mem 0xf0580000-0xf05fffff]
pci 0000:00:1b.0: reg 10: [mem 0xf0640000-0xf0643fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x1820-0x183f]
pci 0000:00:1d.1: reg 20: [io  0x1840-0x185f]
pci 0000:00:1d.2: reg 20: [io  0x1860-0x187f]
pci 0000:00:1d.3: reg 20: [io  0x1880-0x189f]
pci 0000:00:1d.7: reg 10: [mem 0xf0844000-0xf08443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x1180-0x11bf] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0380 (mask 0007)
pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 18: [io  0x0000-0x0007]
pci 0000:00:1f.1: reg 1c: [io  0x0000-0x0003]
pci 0000:00:1f.1: reg 20: [io  0x1810-0x181f]
pci 0000:00:1f.2: reg 10: [io  0x18c8-0x18cf]
pci 0000:00:1f.2: reg 14: [io  0x18c0-0x18c3]
pci 0000:00:1f.2: reg 18: [io  0x18a8-0x18af]
pci 0000:00:1f.2: reg 1c: [io  0x180c-0x180f]
pci 0000:00:1f.2: reg 20: [io  0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24: [mem 0xf0844400-0xf08447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20: [io  0x18e0-0x18ff]
pci 0000:02:00.0: reg 10: [mem 0xf0200000-0xf020ffff 64bit]
pci 0000:02:00.0: PME# supported from D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf02fffff]
pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-04]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xf0300000-0xf03fffff]
pci 0000:00:1c.1:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
pci 0000:05:00.0: reg 10: [mem 0xf0400000-0xf0403fff 64bit]
pci 0000:05:00.0: supports D1 D2
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 05-05]
pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff]
pci 0000:00:1e.0: PCI bridge to [bus 06-06] (subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 *3 4 5 6 7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 *3 4 5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 *5 6 7 11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
system 00:05: [io  0x0800-0x080f] has been reserved
system 00:05: [io  0x1000-0x107f] has been reserved
system 00:05: [io  0x1180-0x11bf] has been reserved
system 00:05: [io  0x1640-0x164f] has been reserved
system 00:05: [io  0xfe00] has been reserved
system 00:05: [io  0x0380-0x0384] has been reserved
system 00:05: [io  0x0386-0x0387] has been reserved
system 00:06: [io  0x06a0-0x06af] has been reserved
system 00:06: [io  0x06b0-0x06ff] has been reserved
pci 0000:00:1c.2: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1c.2: BAR 13: assigned [io  0x4000-0x4fff]
pci 0000:00:1c.0: PCI bridge to [bus 02-02]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf02fffff]
pci 0000:00:1c.0:   bridge window [mem 0xf0000000-0xf00fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 03-04]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xf0300000-0xf03fffff]
pci 0000:00:1c.1:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 05-05]
pci 0000:00:1c.2:   bridge window [io  0x4000-0x4fff]
pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff]
pci 0000:00:1c.2:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 06-06]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:02: resource 1 [mem 0xf0200000-0xf02fffff]
pci_bus 0000:02: resource 2 [mem 0xf0000000-0xf00fffff 64bit pref]
pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:03: resource 1 [mem 0xf0300000-0xf03fffff]
pci_bus 0000:03: resource 2 [mem 0xf0100000-0xf01fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
pci_bus 0000:05: resource 1 [mem 0xf0400000-0xf04fffff]
pci_bus 0000:05: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
pci_bus 0000:06: resource 3 [io  0x0000-0xffff]
pci_bus 0000:06: resource 4 [mem 0x00000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 3346k freed
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS not found.
Scanning for low memory corruption every 60 seconds
audit: initializing netlink socket (disabled)
type=2000 audit(1270625063.469:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1710
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
pcieport 0000:00:1c.1: setting latency timer to 64
pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 26 for MSI/MSI-X
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Failed to disable AUX port, but continuing anyway... Is this a SiS?
If AUX port is really absent please use the 'i8042.noaux' option.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
PM: Checking image partition /dev/mapper/swapDevice
PM: Resume from disk failed.
registered taskstats version 1
Initalizing network drop monitor service
Freeing unused kernel memory: 420k freed
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
acpi device:03: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
ACPI: Power Button [PWRB]
input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input4
ACPI: Sleep Button [SLPB]
input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input5
ACPI: Lid Switch [LID]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
ACPI: Power Button [PWRF]
[drm] Initialized drm 1.1.0 20060810
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
[drm] set up 7M of stolen space
[drm] initialized overlay support
Console: switching to colour frame buffer device 128x36
fb0: inteldrmfb frame buffer device
registered panic notifier
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.1: version 2.13
ata_piix 0000:00:1f.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
ata2: port disabled. ignoring.
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x18c8 ctl 0x18c0 bmdma 0x18b0 irq 19
ata4: SATA max UDMA/133 cmd 0x18a8 ctl 0x180c bmdma 0x18b8 irq 19
ata3.00: ATA-8: HITACHI HTS543216L9SA00, FB2ZC48C, max UDMA/100
ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
scsi 2:0:0:0: Direct-Access     ATA      HITACHI HTS54321 FB2Z PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 > sda4
sd 2:0:0:0: [sda] Attached SCSI disk
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
padlock: VIA PadLock not detected.
EXT4-fs (dm-0): mounted filesystem with ordered data mode
PM: Marking nosave pages: 0000000000002000 - 0000000000010000
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Basic memory bitmaps freed
EXT4-fs (sda5): INFO: recovery required on readonly filesystem
EXT4-fs (sda5): write access will be enabled during recovery
EXT4-fs (sda5): recovery complete
EXT4-fs (sda5): mounted filesystem with ordered data mode
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
udev: starting version 151
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: using broken periodic workaround
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0844000
intel_rng: FWH not detected
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb 1-3: new high speed USB device using ehci_hcd and address 2
tg3.c:v3.106 (January 12, 2010)
tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:02:00.0: setting latency timer to 64
sd 2:0:0:0: Attached scsi generic sg0 type 0
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0x18e0-0x18ff] conflicts with ACPI region SMBI [0x18e0-0x18ef]
ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-5: new high speed USB device using ehci_hcd and address 4
eth0: Tigon3 [partno(BCM95906) rev c002] (PCI Express) MAC address 00:23:8b:40:d5:e4
eth0: attached PHY is 5906 (10/100Base-TX Ethernet) (WireSpeed[0])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[0]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
usb 3-2: new full speed USB device using uhci_hcd and address 2
iTCO_vendor_support: vendor-support=0
ACPI: SSDT 7f6dafd5 00245 (v02  PmRef  Cpu0Ist 00003000 INTL 20050624)
ACPI: SSDT 7f6da96b 005E5 (v02  PmRef  Cpu0Cst 00003001 INTL 20050624)
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
Marking TSC unstable due to TSC halts in idle
ACPI: SSDT 7f6db21a 000D4 (v02  PmRef  Cpu1Ist 00003000 INTL 20050624)
ACPI: SSDT 7f6daf50 00085 (v02  PmRef  Cpu1Cst 00003000 INTL 20050624)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (42 C)
Switching to clocksource hpet
Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04731/0xa40000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input7
wl: module license 'Mixed/Proprietary' taints kernel.
Disabling lock debugging due to kernel taint
wl 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
wl 0000:05:00.0: setting latency timer to 64
ACPI: AC Adapter [ACAD] (off-line)
ACPI: WMI: Mapper loaded
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 27 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
Initializing USB Mass Storage driver...
ACPI: Battery Slot [BAT0] (battery present)
scsi4 : usb-storage 1-5:1.0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
Linux video capture interface: v2.00
lib80211_crypt: registered algorithm 'TKIP'
eth1: Broadcom BCM4315 802.11 Hybrid Wireless Controller 5.60.48.36 
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
uvcvideo: Found UVC 1.00 device Lenovo EasyCamera (5986:0241)
input: Lenovo EasyCamera as /devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.0/input/input9
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
leds_ss4200: no LED devices found
fuse init (API version 7.13)
scsi 4:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: [sdb] Attached SCSI removable disk
Btrfs loaded
device label home devid 1 transid 38484 /dev/mapper/homeDevice
btrfs: unlinked 2 orphans
btrfs: truncated 2 orphans
EXT4-fs (sda8): mounted filesystem with ordered data mode
EXT3-fs (sda2): mounted filesystem with writeback data mode
kjournald starting.  Commit interval 5 seconds
device label store devid 1 transid 2727 /dev/mapper/storeDevice
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda10): mounted filesystem with writeback data mode
Adding 2561300k swap on /dev/mapper/swapDevice.  Priority:-1 extents:1 across:2561300k 
Bluetooth: L2CAP ver 2.14
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bridge firewalling registered
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
ata3.00: configured for UDMA/100
ata3: EH complete
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
tg3 0000:02:00.0: irq 28 for MSI/MSI-X
tg3 0000:02:00.0: irq 28 for MSI/MSI-X
CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth1: no IPv6 routers present
process `skype' is using obsolete setsockopt SO_BSDCOMPAT
ACPI: EC: GPE storm detected, transactions will use polling mode
CE: hpet increasing min_delta_ns to 15000 nsec
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
tg3 0000:02:00.0: irq 28 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth0: link is not ready
eth1: no IPv6 routers present
CE: hpet increasing min_delta_ns to 22500 nsec
ata3.00: configured for UDMA/100
ata3: EH complete
btusb_intr_complete: hci0 urb f5c45c00 failed to resubmit (1)
btusb_bulk_complete: hci0 urb f5c45c80 failed to resubmit (1)
btusb_bulk_complete: hci0 urb f5c45000 failed to resubmit (1)
btusb_intr_complete: hci0 urb d75da880 failed to resubmit (1)
btusb_bulk_complete: hci0 urb d75dad00 failed to resubmit (1)
btusb_bulk_complete: hci0 urb d75da380 failed to resubmit (1)
no space left, need 4096, 132493312 delalloc bytes, 15326789632 bytes_used, 86839296 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 132493312 delalloc bytes, 15326789632 bytes_used, 86839296 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 132493312 delalloc bytes, 15326789632 bytes_used, 86839296 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 116936704 delalloc bytes, 15341096960 bytes_used, 88088576 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 116936704 delalloc bytes, 15341219840 bytes_used, 87965696 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 116936704 delalloc bytes, 15341219840 bytes_used, 87965696 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 116936704 delalloc bytes, 15341244416 bytes_used, 87941120 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 101662720 delalloc bytes, 15359496192 bytes_used, 84963328 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 101662720 delalloc bytes, 15359496192 bytes_used, 84963328 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 101646336 delalloc bytes, 15360020480 bytes_used, 84455424 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 89407488 delalloc bytes, 15374639104 bytes_used, 82075648 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 89407488 delalloc bytes, 15374639104 bytes_used, 82075648 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 89407488 delalloc bytes, 15374639104 bytes_used, 82075648 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
virtuoso-t[4456] general protection ip:841dc84 sp:b7726250 error:0 in virtuoso-t[8048000+88e000]
no space left, need 8192, 73736192 delalloc bytes, 15392464896 bytes_used, 79921152 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 73736192 delalloc bytes, 15392464896 bytes_used, 79921152 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 73736192 delalloc bytes, 15392464896 bytes_used, 79921152 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 57782272 delalloc bytes, 15402717184 bytes_used, 85622784 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 57782272 delalloc bytes, 15402717184 bytes_used, 85622784 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
INFO: task kio_imap4:13810 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kio_imap4     D 00000001     0 13810   4283 0x00000000
 d74c7e68 00200082 00000000 00000001 f5734e00 eac2b0d0 d74c7e84 00000000
 d3c7a90f 00000ed1 d74c7ea4 00000000 d74429c4 c2a082c0 c146b2c0 c146b2c0
 d3c46fae 00000ed1 c14667a4 00000001 c146b2c0 f4b60c40 c146b2c0 eac2b0d0
Call Trace:
 [<c12d2abf>] __mutex_lock_slowpath+0x11f/0x2d0
 [<c12d2c7b>] mutex_lock+0xb/0x20
 [<f95f8ff7>] btrfs_file_write+0xf7/0x870 [btrfs]
 [<c10f4d3c>] ? do_sync_read+0x9c/0xd0
 [<c10f89be>] ? cp_new_stat64+0xde/0xf0
 [<c115a6af>] ? security_file_permission+0xf/0x20
 [<c10f575a>] vfs_write+0x9a/0x190
 [<f95f8f00>] ? btrfs_file_write+0x0/0x870 [btrfs]
 [<c10f590d>] sys_write+0x3d/0x70
 [<c100389f>] sysenter_do_call+0x12/0x28
 [<c12d0000>] ? cpu_callback+0xd7/0x20a
no space left, need 4096, 44687360 delalloc bytes, 15416311808 bytes_used, 85123072 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 44687360 delalloc bytes, 15416311808 bytes_used, 85123072 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 44687360 delalloc bytes, 15416311808 bytes_used, 85123072 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 44687360 delalloc bytes, 15416311808 bytes_used, 85123072 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 28590080 delalloc bytes, 15432142848 bytes_used, 85389312 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 28590080 delalloc bytes, 15432179712 bytes_used, 85352448 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 7290880 delalloc bytes, 15447293952 bytes_used, 91537408 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 7290880 delalloc bytes, 15447298048 bytes_used, 91533312 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 7286784 delalloc bytes, 15447298048 bytes_used, 91537408 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 7274496 delalloc bytes, 15447298048 bytes_used, 91549696 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
INFO: task nepomukserver:4437 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
nepomukserver D f6a52b80     0  4437      1 0x00000000
 f5e0be68 00200086 f6235600 f6a52b80 00000019 00000000 f5e0bc1c c1105410
 5503d07e 00000ee0 f6235c00 f4a47f80 00000019 c2a082c0 c146b2c0 c146b2c0
 5500ed25 00000ee0 c14667a4 00000001 c146b2c0 f6ba1dc0 c146b2c0 f6085f10
Call Trace:
 [<c1105410>] ? pollwake+0x0/0x60
 [<c12d2abf>] __mutex_lock_slowpath+0x11f/0x2d0
 [<c12d2c7b>] mutex_lock+0xb/0x20
 [<f95f8ff7>] btrfs_file_write+0xf7/0x870 [btrfs]
 [<c10f4d3c>] ? do_sync_read+0x9c/0xd0
 [<c10fc136>] ? pipe_ioctl+0x76/0x80
 [<c115a6af>] ? security_file_permission+0xf/0x20
 [<c1098da4>] ? move_native_irq+0x14/0x50
 [<c10f575a>] vfs_write+0x9a/0x190
 [<f95f8f00>] ? btrfs_file_write+0x0/0x870 [btrfs]
 [<c10f590d>] sys_write+0x3d/0x70
 [<c100389f>] sysenter_do_call+0x12/0x28
INFO: task kio_imap4:13811 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kio_imap4     D 00000001     0 13811   4283 0x00000000
 d7491e68 00200086 00000000 00000001 f5010e00 eac2b540 d7491e84 00000000
 05fa39fd 00000ef0 d7491ea4 00000000 d965abc4 c2a082c0 c146b2c0 c146b2c0
 05f70bf7 00000ef0 c14667a4 00000001 c146b2c0 f4b60c40 c146b2c0 eac2b540
Call Trace:
 [<c12d2abf>] __mutex_lock_slowpath+0x11f/0x2d0
 [<c12d2c7b>] mutex_lock+0xb/0x20
 [<f95f8ff7>] btrfs_file_write+0xf7/0x870 [btrfs]
 [<c10f4d3c>] ? do_sync_read+0x9c/0xd0
 [<c10f89be>] ? cp_new_stat64+0xde/0xf0
 [<c115a6af>] ? security_file_permission+0xf/0x20
 [<c10f575a>] vfs_write+0x9a/0x190
 [<f95f8f00>] ? btrfs_file_write+0x0/0x870 [btrfs]
 [<c10f590d>] sys_write+0x3d/0x70
 [<c100389f>] sysenter_do_call+0x12/0x28
 [<c12d0000>] ? cpu_callback+0xd7/0x20a
no space left, need 32768, 0 delalloc bytes, 15466033152 bytes_used, 80084992 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 0 delalloc bytes, 15466033152 bytes_used, 80084992 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 total
no space left, need 32768, 0 delalloc bytes, 15470936064 bytes_used, 75182080 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 total
no space left, need 40960, 0 delalloc bytes, 15470936064 bytes_used, 75182080 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 total
no space left, need 12288, 0 delalloc bytes, 15476994048 bytes_used, 69124096 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 4096 may use 15546122240 total
no space left, need 4096, 4096 delalloc bytes, 15515852800 bytes_used, 30105600 bytes_reserved, 159744 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 200704 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 200704 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 200704 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 200704 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545917440 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545856000 bytes_used, 0 bytes_reserved, 61440 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545856000 bytes_used, 0 bytes_reserved, 61440 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 204800 delalloc bytes, 15545040896 bytes_used, 61440 bytes_reserved, 815104 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 1019904 delalloc bytes, 15545102336 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 1019904 delalloc bytes, 15545102336 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 1019904 delalloc bytes, 15545102336 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545102336 bytes_used, 737280 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
nepomukservices[4726]: segfault at 48 ip b77542c9 sp b3769d88 error 4 in libQtCore.so.4.6.2[b7645000+26e000]
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 12288, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 32768, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 8192, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15545839616 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
no space left, need 4096, 282624 delalloc bytes, 15501950976 bytes_used, 0 bytes_reserved, 43888640 bytes_pinned, 0 bytes_readonly, 0 may use 15546122240 total
loop: module loaded

--Boundary-00=_32JvLGE+icxGBvh
Content-Type: text/plain;
  charset="UTF-8";
  name="btrfs_dfh.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfs_dfh.txt"

Filesystem            Size  Used Avail Use% Mounted on
/dev/sda5              20G   13G  6.0G  68% /
udev                   10M  248K  9.8M   3% /dev
none                  1.0G     0  1.0G   0% /dev/shm
/dev/mapper/homeDevice
                       21G   13G  8.0G  62% /home
tmpfs                 3.0G   29M  3.0G   1% /tmp
/dev/sda8             3.4G  2.3G  976M  71% /var
/dev/sda2             145M   20M  118M  15% /boot
/dev/mapper/storeDevice
                       40G   38G  2.0G  96% /mnt/store
/dev/sda10             18G  9.1G  7.4G  56% /mnt/recovery
/dev/sda12            9.8G  9.6G  206M  98% /media/disk
/dev/sda1              30G   22G  7.5G  75% /mnt/winxp

--Boundary-00=_32JvLGE+icxGBvh
Content-Type: text/plain;
  charset="UTF-8";
  name="btrfs_btrfsck.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfs_btrfsck.txt"

root 5 inode 552424 errors 2
root 5 inode 552425 errors 2
root 5 inode 552426 errors 2
root 5 inode 552427 errors 2
root 5 inode 552429 errors 2
root 5 inode 552431 errors 2
root 5 inode 552515 errors 2
found 13520416768 bytes used err is 1
total csum bytes: 12991604
total tree bytes: 217014272
total fs tree bytes: 182243328
btree space waste bytes: 63087601
file data blocks allocated: 50432675840
 referenced 12764286976
Btrfs Btrfs v0.19

--Boundary-00=_32JvLGE+icxGBvh
Content-Type: text/plain;
  charset="UTF-8";
  name="btrfs_btrfs-show.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="btrfs_btrfs-show.txt"

Label: home  uuid: 5682534d-9365-4e78-a37b-30b51fff5e49
	Total devices 1 FS bytes used 12.59GB
	devid    1 size 20.50GB used 20.50GB path /dev/dm-2

Label: store  uuid: c2bbe121-e7f2-48f4-9fb1-77252304ce4c
	Total devices 1 FS bytes used 37.14GB
	devid    1 size 39.06GB used 39.04GB path /dev/dm-3

Btrfs Btrfs v0.19

--Boundary-00=_32JvLGE+icxGBvh--
