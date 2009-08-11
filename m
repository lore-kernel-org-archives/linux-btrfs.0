From: Atila <atila.alr@dpf.gov.br>
Subject: rm killed after disk full
Date: Tue, 11 Aug 2009 15:55:01 -0300
Message-ID: <4A81BE85.8070707@dpf.gov.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030104030006030402000707"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030104030006030402000707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

In this test (attached), the fs was 1G in size, mounted with compression.
I used the 2.6.30-r4 kernel, cut copy-pasted the fs/btrfs contents from
the btrfs-unstable git tree.

After filling a file with zeros until 'No space left on device', the
file was removed.
The rm process was killed by the system and crash messages went to
/var/log/messages.

Another strange thing happened: both df and btrfs-show showed some space
left, but the disk was full.

Obs: Creating the file with dd resulted in a 994 MB file and with dcfldd
in a 22G file. That was because dd uses bs=512 by default and dcfldd
uses bs=32k by default


Atila


--------------030104030006030402000707
Content-Type: text/plain;
 name="tests.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tests.txt"

localhost ~ # uname -a
Linux localhost 2.6.30-gentoo-r4-btrfs-git-1 #1 SMP Mon Aug 10 21:05:04 BRT 2009 i686 QEMU Virtual CPU version 0.10.50 GenuineIntel GNU/Linux
localhost ~ # mkfs.btrfs /dev/hdb1

WARNING! - Btrfs v0.19-1-g4f89b6e IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/hdb1
        nodesize 4096 leafsize 4096 sectorsize 4096 size 972.65MB
Btrfs v0.19-1-g4f89b6e
localhost ~ # mount /dev/hdb1 /mnt/teste -o compress
mount: you must specify the filesystem type
localhost ~ # modprobe btrfs
localhost ~ # mount /dev/hdb1 /mnt/teste -o compress
localhost ~ # cd /mnt/teste
localhost teste # ls
localhost teste # df -h /dev/hdb1
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdb1             973M   28K  973M   1% /mnt/teste
localhost teste # dd if=/dev/zero of=zero.dd
dd: writing to `zero.dd': No space left on device
1941722+0 records in
1941721+0 records out
994161152 bytes (994 MB) copied, 57.5689 s, 17.3 MB/s
localhost teste # sync
localhost teste # df -h /dev/hdb1
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdb1             973M  788M  186M  81% /mnt/teste
localhost teste # ls -lh
total 949M
-rw-r--r-- 1 root root 949M Aug 11 14:45 zero.dd
localhost teste # btrfs-show 
failed to read /dev/hdc
Label: none  uuid: 79848a50-9c4d-4c95-8c48-c13e97c21a0c
        Total devices 1 FS bytes used 787.21MB
        devid    1 size 972.65MB used 911.25MB path /dev/hdb1

Btrfs v0.19-1-g4f89b6e
localhost teste # rm zero.dd 
localhost teste # dcfldd if=/dev/zero of=zero.dcfldd
719872 blocks (22496Mb) written.
719993+0 records in
719992+0 records out
localhost teste # ls -lh
total 22G
-rw-r--r-- 1 root root 22G Aug 11 14:53 zero.dcfldd
localhost teste # df -h /dev/hdb1
Filesystem            Size  Used Avail Use% Mounted on
/dev/hdb1             973M  737M  237M  76% /mnt/teste
localhost teste # btrfs-show 
failed to read /dev/hdc
Label: none  uuid: 79848a50-9c4d-4c95-8c48-c13e97c21a0c
        Total devices 1 FS bytes used 736.09MB
        devid    1 size 972.65MB used 911.25MB path /dev/hdb1

Btrfs v0.19-1-g4f89b6e
localhost teste # rm zero.dcfldd 
Killed
localhost teste # 


--------------030104030006030402000707
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="messages"

Aug 11 14:42:10 localhost syslog-ng[11716]: syslog-ng starting up; versio=
n=3D'2.1.4'
Aug 11 14:42:10 localhost Initializing cgroup subsys cpuset
Aug 11 14:42:10 localhost Linux version 2.6.30-gentoo-r4-btrfs-git-1 (roo=
t@Helix) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #1 SMP Mon Aug 10 21:0=
5:04 BRT 2009
Aug 11 14:42:10 localhost KERNEL supported cpus:
Aug 11 14:42:10 localhost Intel GenuineIntel
Aug 11 14:42:10 localhost AMD AuthenticAMD
Aug 11 14:42:10 localhost NSC Geode by NSC
Aug 11 14:42:10 localhost Cyrix CyrixInstead
Aug 11 14:42:10 localhost Centaur CentaurHauls
Aug 11 14:42:10 localhost Transmeta GenuineTMx86
Aug 11 14:42:10 localhost Transmeta TransmetaCPU
Aug 11 14:42:10 localhost UMC UMC UMC UMC
Aug 11 14:42:10 localhost BIOS-provided physical RAM map:
Aug 11 14:42:10 localhost BIOS-e820: 0000000000000000 - 000000000009f000 =
(usable)
Aug 11 14:42:10 localhost BIOS-e820: 000000000009f000 - 00000000000a0000 =
(reserved)
Aug 11 14:42:10 localhost BIOS-e820: 00000000000e8000 - 0000000000100000 =
(reserved)
Aug 11 14:42:10 localhost BIOS-e820: 0000000000100000 - 0000000037ff0000 =
(usable)
Aug 11 14:42:10 localhost BIOS-e820: 0000000037ff0000 - 0000000038000000 =
(ACPI data)
Aug 11 14:42:10 localhost BIOS-e820: 00000000fffbc000 - 0000000100000000 =
(reserved)
Aug 11 14:42:10 localhost DMI 2.4 present.
Aug 11 14:42:10 localhost last_pfn =3D 0x37ff0 max_arch_pfn =3D 0x100000
Aug 11 14:42:10 localhost MTRR default type: write-back
Aug 11 14:42:10 localhost MTRR fixed ranges enabled:
Aug 11 14:42:10 localhost 00000-9FFFF write-back
Aug 11 14:42:10 localhost A0000-FFFFF uncachable
Aug 11 14:42:10 localhost MTRR variable ranges enabled:
Aug 11 14:42:10 localhost 0 base 00E0000000 mask FFFFFFFFE0000000 uncacha=
ble
Aug 11 14:42:10 localhost 1 disabled
Aug 11 14:42:10 localhost 2 disabled
Aug 11 14:42:10 localhost 3 disabled
Aug 11 14:42:10 localhost 4 disabled
Aug 11 14:42:10 localhost 5 disabled
Aug 11 14:42:10 localhost 6 disabled
Aug 11 14:42:10 localhost 7 disabled
Aug 11 14:42:10 localhost init_memory_mapping: 0000000000000000-000000003=
77fe000
Aug 11 14:42:10 localhost 0000000000 - 0000400000 page 4k
Aug 11 14:42:10 localhost 0000400000 - 0037400000 page 2M
Aug 11 14:42:10 localhost 0037400000 - 00377fe000 page 4k
Aug 11 14:42:10 localhost kernel direct mapping tables up to 377fe000 @ 7=
000-c000
Aug 11 14:42:10 localhost RAMDISK: 37d9a000 - 37fdfba9
Aug 11 14:42:10 localhost Allocated new RAMDISK: 0069d000 - 008e2ba9
Aug 11 14:42:10 localhost Move RAMDISK from 0000000037d9a000 - 0000000037=
fdfba8 to 0069d000 - 008e2ba8
Aug 11 14:42:10 localhost ACPI: RSDP 000fbd40 00014 (v00 QEMU  )
Aug 11 14:42:10 localhost ACPI: RSDT 37ff0000 00030 (v01 QEMU   QEMURSDT =
00000001 QEMU 00000001)
Aug 11 14:42:10 localhost ACPI: FACP 37ff01b4 00074 (v01 QEMU   QEMUFACP =
00000001 QEMU 00000001)
Aug 11 14:42:10 localhost ACPI: DSDT 37ff0280 01DD4 (v01   BXPC   BXDSDT =
00000001 INTL 20061109)
Aug 11 14:42:10 localhost ACPI: FACS 37ff0240 00040
Aug 11 14:42:10 localhost ACPI: SSDT 37ff2054 009E3 (v01   BXPC   BXSSDT =
00000001 INTL 20061109)
Aug 11 14:42:10 localhost ACPI: APIC 37ff2a38 000E0 (v01 QEMU   QEMUAPIC =
00000001 QEMU 00000001)
Aug 11 14:42:10 localhost ACPI: Local APIC address 0xfee00000
Aug 11 14:42:10 localhost 7MB HIGHMEM available.
Aug 11 14:42:10 localhost 887MB LOWMEM available.
Aug 11 14:42:10 localhost mapped low ram: 0 - 377fe000
Aug 11 14:42:10 localhost low ram: 0 - 377fe000
Aug 11 14:42:10 localhost node 0 low ram: 00000000 - 377fe000
Aug 11 14:42:10 localhost node 0 bootmap 00008000 - 0000ef00
Aug 11 14:42:10 localhost (9 early reservations) =3D=3D> bootmem [0000000=
000 - 00377fe000]
Aug 11 14:42:10 localhost #0 [0000000000 - 0000001000]   BIOS data page =3D=
=3D> [0000000000 - 0000001000]
Aug 11 14:42:10 localhost #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=
=3D> [0000001000 - 0000002000]
Aug 11 14:42:10 localhost #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=
=3D> [0000006000 - 0000007000]
Aug 11 14:42:10 localhost #3 [0000100000 - 00006981c4]    TEXT DATA BSS =3D=
=3D> [0000100000 - 00006981c4]
Aug 11 14:42:10 localhost #4 [000009fc00 - 0000100000]    BIOS reserved =3D=
=3D> [000009fc00 - 0000100000]
Aug 11 14:42:10 localhost #5 [0000699000 - 000069c03d]              BRK =3D=
=3D> [0000699000 - 000069c03d]
Aug 11 14:42:10 localhost #6 [0000007000 - 0000008000]          PGTABLE =3D=
=3D> [0000007000 - 0000008000]
Aug 11 14:42:10 localhost #7 [000069d000 - 00008e2ba9]      NEW RAMDISK =3D=
=3D> [000069d000 - 00008e2ba9]
Aug 11 14:42:10 localhost #8 [0000008000 - 000000f000]          BOOTMAP =3D=
=3D> [0000008000 - 000000f000]
Aug 11 14:42:10 localhost found SMP MP-table at [c00fbc20] fbc20
Aug 11 14:42:10 localhost Zone PFN ranges:
Aug 11 14:42:10 localhost DMA      0x00000000 -> 0x00001000
Aug 11 14:42:10 localhost Normal   0x00001000 -> 0x000377fe
Aug 11 14:42:10 localhost HighMem  0x000377fe -> 0x00037ff0
Aug 11 14:42:10 localhost Movable zone start PFN for each node
Aug 11 14:42:10 localhost early_node_map[2] active PFN ranges
Aug 11 14:42:10 localhost 0: 0x00000000 -> 0x0000009f
Aug 11 14:42:10 localhost 0: 0x00000100 -> 0x00037ff0
Aug 11 14:42:10 localhost On node 0 totalpages: 229263
Aug 11 14:42:10 localhost free_area_init_node: node 0, pgdat c05aa7a0, no=
de_mem_map c1000000
Aug 11 14:42:10 localhost DMA zone: 32 pages used for memmap
Aug 11 14:42:10 localhost DMA zone: 0 pages reserved
Aug 11 14:42:10 localhost DMA zone: 3967 pages, LIFO batch:0
Aug 11 14:42:10 localhost Normal zone: 1744 pages used for memmap
Aug 11 14:42:10 localhost Normal zone: 221486 pages, LIFO batch:31
Aug 11 14:42:10 localhost HighMem zone: 16 pages used for memmap
Aug 11 14:42:10 localhost HighMem zone: 2018 pages, LIFO batch:0
Aug 11 14:42:10 localhost Using APIC driver default
Aug 11 14:42:10 localhost ACPI: PM-Timer IO Port: 0xb008
Aug 11 14:42:10 localhost ACPI: Local APIC address 0xfee00000
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabl=
ed)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disab=
led)
Aug 11 14:42:10 localhost ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disab=
led)
Aug 11 14:42:10 localhost ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_=
base[0])
Aug 11 14:42:10 localhost IOAPIC[0]: apic_id 1, version 17, address 0xfec=
00000, GSI 0-23
Aug 11 14:42:10 localhost ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5=
 high level)
Aug 11 14:42:10 localhost ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9=
 high level)
Aug 11 14:42:10 localhost ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq =
10 high level)
Aug 11 14:42:10 localhost ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq =
11 high level)
Aug 11 14:42:10 localhost ACPI: IRQ5 used by override.
Aug 11 14:42:10 localhost ACPI: IRQ9 used by override.
Aug 11 14:42:10 localhost ACPI: IRQ10 used by override.
Aug 11 14:42:10 localhost ACPI: IRQ11 used by override.
Aug 11 14:42:10 localhost Enabling APIC mode:  Flat.  Using 1 I/O APICs
Aug 11 14:42:10 localhost Using ACPI (MADT) for SMP configuration informa=
tion
Aug 11 14:42:10 localhost 16 Processors exceeds NR_CPUS limit of 8
Aug 11 14:42:10 localhost SMP: Allowing 8 CPUs, 7 hotplug CPUs
Aug 11 14:42:10 localhost nr_irqs_gsi: 24
Aug 11 14:42:10 localhost PM: Registered nosave memory: 000000000009f000 =
- 00000000000a0000
Aug 11 14:42:10 localhost PM: Registered nosave memory: 00000000000a0000 =
- 00000000000e8000
Aug 11 14:42:10 localhost PM: Registered nosave memory: 00000000000e8000 =
- 0000000000100000
Aug 11 14:42:10 localhost Allocating PCI resources starting at 40000000 (=
gap: 38000000:c7fbc000)
Aug 11 14:42:10 localhost NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_nod=
e_ids:1
Aug 11 14:42:10 localhost PERCPU: Embedded 13 pages at c1704000, static d=
ata 30236 bytes
Aug 11 14:42:10 localhost Built 1 zonelists in Zone order, mobility group=
ing on.  Total pages: 227471
Aug 11 14:42:10 localhost Kernel command line: root=3D/dev/ram0 real_root=
=3D/dev/hda1 vga=3D791
Aug 11 14:42:10 localhost Enabling fast FPU save and restore... done.
Aug 11 14:42:10 localhost Enabling unmasked SIMD FPU exception support...=
 done.
Aug 11 14:42:10 localhost Initializing CPU#0
Aug 11 14:42:10 localhost NR_IRQS:512
Aug 11 14:42:10 localhost CPU 0 irqstacks, hard=3Dc1704000 soft=3Dc170500=
0
Aug 11 14:42:10 localhost PID hash table entries: 4096 (order: 12, 16384 =
bytes)
Aug 11 14:42:10 localhost Fast TSC calibration using PIT
Aug 11 14:42:10 localhost Detected 2671.222 MHz processor.
Aug 11 14:42:10 localhost Console: colour dummy device 80x25
Aug 11 14:42:10 localhost console [tty0] enabled
Aug 11 14:42:10 localhost Dentry cache hash table entries: 131072 (order:=
 7, 524288 bytes)
Aug 11 14:42:10 localhost Inode-cache hash table entries: 65536 (order: 6=
, 262144 bytes)
Aug 11 14:42:10 localhost Initializing HighMem for node 0 (000377fe:00037=
ff0)
Aug 11 14:42:10 localhost Memory: 900244k/917440k available (3306k kernel=
 code, 16504k reserved, 1574k data, 408k init, 8136k highmem)
Aug 11 14:42:10 localhost virtual kernel memory layout:
Aug 11 14:42:10 localhost fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
Aug 11 14:42:10 localhost pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Aug 11 14:42:10 localhost vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Aug 11 14:42:10 localhost lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Aug 11 14:42:10 localhost .init : 0xc05cd000 - 0xc0633000   ( 408 kB)
Aug 11 14:42:10 localhost .data : 0xc043aa0a - 0xc05c45a4   (1574 kB)
Aug 11 14:42:10 localhost .text : 0xc0100000 - 0xc043aa0a   (3306 kB)
Aug 11 14:42:10 localhost Checking if this processor honours the WP bit e=
ven in supervisor mode...Ok.
Aug 11 14:42:10 localhost Calibrating delay loop (skipped), value calcula=
ted using timer frequency.. 5342.44 BogoMIPS (lpj=3D26712220)
Aug 11 14:42:10 localhost Security Framework initialized
Aug 11 14:42:10 localhost Mount-cache hash table entries: 512
Aug 11 14:42:10 localhost Initializing cgroup subsys ns
Aug 11 14:42:10 localhost Initializing cgroup subsys cpuacct
Aug 11 14:42:10 localhost CPU: L1 I cache: 32K, L1 D cache: 32K
Aug 11 14:42:10 localhost CPU: L2 cache: 2048K
Aug 11 14:42:10 localhost Intel machine check architecture supported.
Aug 11 14:42:10 localhost Intel machine check reporting enabled on CPU#0.=

Aug 11 14:42:10 localhost Checking 'hlt' instruction... OK.
Aug 11 14:42:10 localhost SMP alternatives: switching to UP code
Aug 11 14:42:10 localhost ACPI: Core revision 20090320
Aug 11 14:42:10 localhost ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=
=3D-1 pin2=3D-1
Aug 11 14:42:10 localhost CPU0: Intel QEMU Virtual CPU version 0.10.50 st=
epping 03
Aug 11 14:42:10 localhost Brought up 1 CPUs
Aug 11 14:42:10 localhost Total of 1 processors activated (5342.44 BogoMI=
PS).
Aug 11 14:42:10 localhost CPU0 attaching NULL sched-domain.
Aug 11 14:42:10 localhost net_namespace: 992 bytes
Aug 11 14:42:10 localhost Booting paravirtualized kernel on bare hardware=

Aug 11 14:42:10 localhost xor: automatically using best checksumming func=
tion: pIII_sse
Aug 11 14:42:10 localhost pIII_sse  :   858.800 MB/sec
Aug 11 14:42:10 localhost xor: using function: pIII_sse (858.800 MB/sec)
Aug 11 14:42:10 localhost NET: Registered protocol family 16
Aug 11 14:42:10 localhost ACPI: bus type pci registered
Aug 11 14:42:10 localhost dca service started, version 1.8
Aug 11 14:42:10 localhost PCI: PCI BIOS revision 2.10 entry at 0xfb420, l=
ast bus=3D0
Aug 11 14:42:10 localhost PCI: Using configuration type 1 for base access=

Aug 11 14:42:10 localhost bio: create slab <bio-0> at 0
Aug 11 14:42:10 localhost ACPI: EC: Look up EC in DSDT
Aug 11 14:42:10 localhost ACPI: Interpreter enabled
Aug 11 14:42:10 localhost ACPI: (supports S0 S3 S4 S5)
Aug 11 14:42:10 localhost ACPI: Using IOAPIC for interrupt routing
Aug 11 14:42:10 localhost ACPI: No dock devices found.
Aug 11 14:42:10 localhost ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 11 14:42:10 localhost pci 0000:00:01.1: reg 20 io port: [0xc000-0xc00=
f]
Aug 11 14:42:10 localhost pci 0000:00:01.2: reg 20 io port: [0xc020-0xc03=
f]
Aug 11 14:42:10 localhost pci 0000:00:01.3: quirk: region b000-b03f claim=
ed by PIIX4 ACPI
Aug 11 14:42:10 localhost pci 0000:00:01.3: quirk: region b100-b10f claim=
ed by PIIX4 SMB
Aug 11 14:42:10 localhost pci 0000:00:02.0: reg 10 32bit mmio: [0xf000000=
0-0xf1ffffff]
Aug 11 14:42:10 localhost pci 0000:00:02.0: reg 14 32bit mmio: [0xf200000=
0-0xf2000fff]
Aug 11 14:42:10 localhost pci 0000:00:03.0: reg 10 io port: [0xc100-0xc1f=
f]
Aug 11 14:42:10 localhost pci 0000:00:03.0: reg 14 32bit mmio: [0xf200100=
0-0xf20010ff]
Aug 11 14:42:10 localhost pci 0000:00:04.0: reg 10 io port: [0xc200-0xc21=
f]
Aug 11 14:42:10 localhost pci_bus 0000:00: on NUMA node 0
Aug 11 14:42:10 localhost ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._=
PRT]
Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)=

Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)=

Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)=

Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)=

Aug 11 14:42:10 localhost SCSI subsystem initialized
Aug 11 14:42:10 localhost libata version 3.00 loaded.
Aug 11 14:42:10 localhost raid6: int32x1    963 MB/s
Aug 11 14:42:10 localhost raid6: int32x2   1059 MB/s
Aug 11 14:42:10 localhost raid6: int32x4    803 MB/s
Aug 11 14:42:10 localhost raid6: int32x8    753 MB/s
Aug 11 14:42:10 localhost raid6: mmxx1     2661 MB/s
Aug 11 14:42:10 localhost raid6: mmxx2     2653 MB/s
Aug 11 14:42:10 localhost raid6: sse1x1    1711 MB/s
Aug 11 14:42:10 localhost raid6: sse1x2    2044 MB/s
Aug 11 14:42:10 localhost raid6: sse2x1    2921 MB/s
Aug 11 14:42:10 localhost raid6: sse2x2    3373 MB/s
Aug 11 14:42:10 localhost raid6: using algorithm sse2x2 (3373 MB/s)
Aug 11 14:42:10 localhost PCI: Using ACPI for IRQ routing
Aug 11 14:42:10 localhost pnp: PnP ACPI init
Aug 11 14:42:10 localhost ACPI: bus type pnp registered
Aug 11 14:42:10 localhost pnp: PnP ACPI: found 7 devices
Aug 11 14:42:10 localhost ACPI: ACPI bus type pnp unregistered
Aug 11 14:42:10 localhost pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Aug 11 14:42:10 localhost pci_bus 0000:00: resource 1 mem: [0x000000-0xff=
ffffff]
Aug 11 14:42:10 localhost NET: Registered protocol family 2
Aug 11 14:42:10 localhost IP route cache hash table entries: 32768 (order=
: 5, 131072 bytes)
Aug 11 14:42:10 localhost TCP established hash table entries: 131072 (ord=
er: 8, 1048576 bytes)
Aug 11 14:42:10 localhost TCP bind hash table entries: 65536 (order: 7, 5=
24288 bytes)
Aug 11 14:42:10 localhost TCP: Hash tables configured (established 131072=
 bind 65536)
Aug 11 14:42:10 localhost TCP reno registered
Aug 11 14:42:10 localhost NET: Registered protocol family 1
Aug 11 14:42:10 localhost Trying to unpack rootfs image as initramfs...
Aug 11 14:42:10 localhost Freeing initrd memory: 2326k freed
Aug 11 14:42:10 localhost Machine check exception polling timer started.
Aug 11 14:42:10 localhost apm: BIOS version 1.2 Flags 0x03 (Driver versio=
n 1.16ac)
Aug 11 14:42:10 localhost apm: overridden by ACPI.
Aug 11 14:42:10 localhost audit: initializing netlink socket (disabled)
Aug 11 14:42:10 localhost type=3D2000 audit(1250012484.230:1): initialize=
d
Aug 11 14:42:10 localhost highmem bounce pool size: 64 pages
Aug 11 14:42:10 localhost HugeTLB registered 4 MB page size, pre-allocate=
d 0 pages
Aug 11 14:42:10 localhost VFS: Disk quotas dquot_6.5.2
Aug 11 14:42:10 localhost Dquot-cache hash table entries: 1024 (order 0, =
4096 bytes)
Aug 11 14:42:10 localhost squashfs: version 4.0 (2009/01/31) Phillip Loug=
her
Aug 11 14:42:10 localhost SGI XFS with ACLs, security attributes, realtim=
e, large block/inode numbers, no debug enabled
Aug 11 14:42:10 localhost SGI XFS Quota Management subsystem
Aug 11 14:42:10 localhost msgmni has been set to 1747
Aug 11 14:42:10 localhost alg: No test for stdrng (krng)
Aug 11 14:42:10 localhost async_tx: api initialized (async)
Aug 11 14:42:10 localhost Block layer SCSI generic (bsg) driver version 0=
=2E4 loaded (major 254)
Aug 11 14:42:10 localhost io scheduler noop registered
Aug 11 14:42:10 localhost io scheduler anticipatory registered (default)
Aug 11 14:42:10 localhost io scheduler deadline registered
Aug 11 14:42:10 localhost io scheduler cfq registered
Aug 11 14:42:10 localhost pci 0000:00:00.0: Limiting direct PCI/PCI trans=
fers
Aug 11 14:42:10 localhost pci 0000:00:01.0: PIIX3: Enabling Passive Relea=
se
Aug 11 14:42:10 localhost pci 0000:00:01.0: Activating ISA DMA hang worka=
rounds
Aug 11 14:42:10 localhost pci 0000:00:02.0: Boot video device
Aug 11 14:42:10 localhost vesafb: framebuffer at 0xf0000000, mapped to 0x=
f8080000, using 3072k, total 4096k
Aug 11 14:42:10 localhost vesafb: mode is 1024x768x16, linelength=3D2048,=
 pages=3D1
Aug 11 14:42:10 localhost vesafb: scrolling: redraw
Aug 11 14:42:10 localhost vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11=
:5:0
Aug 11 14:42:10 localhost Console: switching to colour frame buffer devic=
e 128x48
Aug 11 14:42:10 localhost fb0: VESA VGA frame buffer device
Aug 11 14:42:10 localhost isapnp: Scanning for PnP cards...
Aug 11 14:42:10 localhost isapnp: No Plug & Play device found
Aug 11 14:42:10 localhost Serial: 8250/16550 driver, 4 ports, IRQ sharing=
 enabled
Aug 11 14:42:10 localhost serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a=
 16550A
Aug 11 14:42:10 localhost 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 1655=
0A
Aug 11 14:42:10 localhost brd: module loaded
Aug 11 14:42:10 localhost loop: module loaded
Aug 11 14:42:10 localhost input: Macintosh mouse button emulation as /cla=
ss/input/input0
Aug 11 14:42:10 localhost Uniform Multi-Platform E-IDE driver
Aug 11 14:42:10 localhost piix 0000:00:01.1: IDE controller (0x8086:0x701=
0 rev 0x00)
Aug 11 14:42:10 localhost piix 0000:00:01.1: not 100% native mode: will p=
robe irqs later
Aug 11 14:42:10 localhost pci 0000:00:01.1: setting latency timer to 64
Aug 11 14:42:10 localhost ide0: BM-DMA at 0xc000-0xc007
Aug 11 14:42:10 localhost ide1: BM-DMA at 0xc008-0xc00f
Aug 11 14:42:10 localhost Probing IDE interface ide0...
Aug 11 14:42:10 localhost Switched to high resolution mode on CPU 0
Aug 11 14:42:10 localhost hda: QEMU HARDDISK, ATA DISK drive
Aug 11 14:42:10 localhost hdb: QEMU HARDDISK, ATA DISK drive
Aug 11 14:42:10 localhost hda: host max PIO4 wanted PIO255(auto-tune) sel=
ected PIO2
Aug 11 14:42:10 localhost hda: MWDMA2 mode selected
Aug 11 14:42:10 localhost hdb: host max PIO4 wanted PIO255(auto-tune) sel=
ected PIO2
Aug 11 14:42:10 localhost hdb: MWDMA2 mode selected
Aug 11 14:42:10 localhost Probing IDE interface ide1...
Aug 11 14:42:10 localhost hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
Aug 11 14:42:10 localhost hdc: host max PIO4 wanted PIO255(auto-tune) sel=
ected PIO0
Aug 11 14:42:10 localhost hdc: MWDMA2 mode selected
Aug 11 14:42:10 localhost ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug 11 14:42:10 localhost ide1 at 0x170-0x177,0x376 on irq 15
Aug 11 14:42:10 localhost ide_generic: please use "probe_mask=3D0x3f" mod=
ule parameter for probing all legacy ISA IDE ports
Aug 11 14:42:10 localhost ide-gd driver 1.18
Aug 11 14:42:10 localhost hda: max request size: 512KiB
Aug 11 14:42:10 localhost hda: 20971520 sectors (10737 MB) w/256KiB Cache=
, CHS=3D16383/255/63
Aug 11 14:42:10 localhost hda: cache flushes supported
Aug 11 14:42:10 localhost hda: hda1
Aug 11 14:42:10 localhost hdb: max request size: 512KiB
Aug 11 14:42:10 localhost hdb: 6291456 sectors (3221 MB) w/256KiB Cache, =
CHS=3D6241/255/63
Aug 11 14:42:10 localhost hdb: cache flushes supported
Aug 11 14:42:10 localhost hdb: unknown partition table
Aug 11 14:42:10 localhost ide-cd driver 5.00
Aug 11 14:42:10 localhost ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache=

Aug 11 14:42:10 localhost Uniform CD-ROM driver Revision: 3.20
Aug 11 14:42:10 localhost Loading iSCSI transport class v2.0-870.
Aug 11 14:42:10 localhost iscsi: registered transport (tcp)
Aug 11 14:42:10 localhost Driver 'sd' needs updating - please use bus_typ=
e methods
Aug 11 14:42:10 localhost Driver 'sr' needs updating - please use bus_typ=
e methods
Aug 11 14:42:10 localhost PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] =
at 0x60,0x64 irq 1,12
Aug 11 14:42:10 localhost serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 11 14:42:10 localhost serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 11 14:42:10 localhost mice: PS/2 mouse device common for all mice
Aug 11 14:42:10 localhost input: AT Translated Set 2 keyboard as /class/i=
nput/input1
Aug 11 14:42:10 localhost md: raid0 personality registered for level 0
Aug 11 14:42:10 localhost md: raid1 personality registered for level 1
Aug 11 14:42:10 localhost md: raid6 personality registered for level 6
Aug 11 14:42:10 localhost md: raid5 personality registered for level 5
Aug 11 14:42:10 localhost md: raid4 personality registered for level 4
Aug 11 14:42:10 localhost cpuidle: using governor ladder
Aug 11 14:42:10 localhost TCP cubic registered
Aug 11 14:42:10 localhost NET: Registered protocol family 17
Aug 11 14:42:10 localhost RPC: Registered udp transport module.
Aug 11 14:42:10 localhost RPC: Registered tcp transport module.
Aug 11 14:42:10 localhost Using IPI No-Shortcut mode
Aug 11 14:42:10 localhost registered taskstats version 1
Aug 11 14:42:10 localhost Freeing unused kernel memory: 408k freed
Aug 11 14:42:10 localhost input: ImExPS/2 Generic Explorer Mouse as /clas=
s/input/input2
Aug 11 14:42:10 localhost NCR53c406a: no available ports found
Aug 11 14:42:10 localhost scsi: <fdomain> Detection failed (no card)
Aug 11 14:42:10 localhost GDT-HA: Storage RAID Controller Driver. Version=
: 3.05
Aug 11 14:42:10 localhost qlogicfas: no cards were found, please specify =
I/O address and IRQ using iobase=3D and irq=3D optionsFailed initializati=
on of WD-7000 SCSI card!
Aug 11 14:42:10 localhost NCR53c406a: no available ports found
Aug 11 14:42:10 localhost sym53c416.c: Version 1.0.0-ac
Aug 11 14:42:10 localhost Fusion MPT base driver 3.04.07
Aug 11 14:42:10 localhost Copyright (c) 1999-2008 LSI Corporation
Aug 11 14:42:10 localhost Fusion MPT SPI Host driver 3.04.07
Aug 11 14:42:10 localhost Fusion MPT FC Host driver 3.04.07
Aug 11 14:42:10 localhost Fusion MPT SAS Host driver 3.04.07
Aug 11 14:42:10 localhost 3ware Storage Controller device driver for Linu=
x v1.26.02.002.
Aug 11 14:42:10 localhost 3ware 9000 Storage Controller device driver for=
 Linux v2.26.02.012.
Aug 11 14:42:10 localhost Compaq SMART2 Driver (v 2.6.0)
Aug 11 14:42:10 localhost HP CISS Driver (v 3.6.20)
Aug 11 14:42:10 localhost Adaptec aacraid driver 1.1-5[2461]-ms
Aug 11 14:42:10 localhost megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 1=
6 00:01:03 EST 2006)
Aug 11 14:42:10 localhost megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15=
:32:35 EST 2006)
Aug 11 14:42:10 localhost megasas: 00.00.04.01 Thu July 24 11:41:51 PST 2=
008
Aug 11 14:42:10 localhost QLogic Fibre Channel HBA Driver: 8.03.01-k1
Aug 11 14:42:10 localhost Emulex LightPulse Fibre Channel SCSI driver 8.3=
=2E1
Aug 11 14:42:10 localhost Copyright(c) 2004-2009 Emulex.  All rights rese=
rved.
Aug 11 14:42:10 localhost usbcore: registered new interface driver usbfs
Aug 11 14:42:10 localhost usbcore: registered new interface driver hub
Aug 11 14:42:10 localhost usbcore: registered new device driver usb
Aug 11 14:42:10 localhost ehci_hcd: USB 2.0 'Enhanced' Host Controller (E=
HCI) Driver
Aug 11 14:42:10 localhost Initializing USB Mass Storage driver...
Aug 11 14:42:10 localhost usbcore: registered new interface driver usb-st=
orage
Aug 11 14:42:10 localhost USB Mass Storage support registered.
Aug 11 14:42:10 localhost uhci_hcd: USB Universal Host Controller Interfa=
ce driver
Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKD] enabled at IRQ =
11
Aug 11 14:42:10 localhost uhci_hcd 0000:00:01.2: PCI INT D -> Link[LNKD] =
-> GSI 11 (level, high) -> IRQ 11
Aug 11 14:42:10 localhost uhci_hcd 0000:00:01.2: setting latency timer to=
 64
Aug 11 14:42:10 localhost uhci_hcd 0000:00:01.2: UHCI Host Controller
Aug 11 14:42:10 localhost uhci_hcd 0000:00:01.2: new USB bus registered, =
assigned bus number 1
Aug 11 14:42:10 localhost uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c0=
20
Aug 11 14:42:10 localhost usb usb1: configuration #1 chosen from 1 choice=

Aug 11 14:42:10 localhost hub 1-0:1.0: USB hub found
Aug 11 14:42:10 localhost hub 1-0:1.0: 2 ports detected
Aug 11 14:42:10 localhost ohci_hcd: USB 1.1 'Open' Host Controller (OHCI)=
 Driver
Aug 11 14:42:10 localhost usb 1-2: new full speed USB device using uhci_h=
cd and address 2
Aug 11 14:42:10 localhost usbcore: registered new interface driver hiddev=

Aug 11 14:42:10 localhost usbcore: registered new interface driver usbhid=

Aug 11 14:42:10 localhost usbhid: v2.6:USB HID core driver
Aug 11 14:42:10 localhost sl811: driver sl811-hcd, 19 May 2005
Aug 11 14:42:10 localhost usb 1-2: configuration #1 chosen from 1 choice
Aug 11 14:42:10 localhost input: QEMU 0.10.50 QEMU USB Tablet as /class/i=
nput/input3
Aug 11 14:42:10 localhost generic-usb 0003:0627:0001.0001: input,hidraw0:=
 USB HID v0.01 Pointer [QEMU 0.10.50 QEMU USB Tablet] on usb-0000:00:01.2=
-2/input0
Aug 11 14:42:10 localhost device-mapper: uevent: version 1.0.3
Aug 11 14:42:10 localhost device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)=
 initialised: dm-devel@redhat.com
Aug 11 14:42:10 localhost md: raid10 personality registered for level 10
Aug 11 14:42:10 localhost fuse init (API version 7.11)
Aug 11 14:42:10 localhost Intel(R) PRO/1000 Network Driver - version 7.3.=
21-k3-NAPI
Aug 11 14:42:10 localhost Copyright (c) 1999-2006 Intel Corporation.
Aug 11 14:42:10 localhost UDF-fs: No partition found (1)
Aug 11 14:42:10 localhost XFS mounting filesystem hda1
Aug 11 14:42:10 localhost Ending clean XFS mount for filesystem: hda1
Aug 11 14:42:10 localhost input: PC Speaker as /class/input/input4
Aug 11 14:42:10 localhost virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD=
] -> GSI 11 (level, high) -> IRQ 11
Aug 11 14:42:10 localhost 8139too Fast Ethernet driver 0.9.28
Aug 11 14:42:10 localhost 8139too 0000:00:03.0: This (id 10ec:8139 rev 20=
) is an enhanced 8139C+ chip, use 8139cp
Aug 11 14:42:10 localhost 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22=
, 2004)
Aug 11 14:42:10 localhost ACPI: PCI Interrupt Link [LNKC] enabled at IRQ =
10
Aug 11 14:42:10 localhost 8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] ->=
 GSI 10 (level, high) -> IRQ 10
Aug 11 14:42:10 localhost eth0: RTL-8139C+ at 0xf8f38000, 52:54:00:12:34:=
56, IRQ 10
Aug 11 14:42:10 localhost 8139cp 0000:00:03.0: setting latency timer to 6=
4
Aug 11 14:42:10 localhost piix4_smbus 0000:00:01.3: SMBus Host Controller=
 at 0xb100, revision 0
Aug 11 14:42:10 localhost processor ACPI_CPU:00: registered as cooling_de=
vice0
Aug 11 14:42:10 localhost input: Power Button as /class/input/input5
Aug 11 14:42:10 localhost ACPI: Power Button [PWRF]
Aug 11 14:42:10 localhost parport_pc 00:05: reported by Plug and Play ACP=
I
Aug 11 14:42:10 localhost parport0: PC-style at 0x378, irq 7 [PCSPP,TRIST=
ATE]
Aug 11 14:42:10 localhost FDC 0 is a S82078B
Aug 11 14:42:10 localhost rtc_cmos 00:01: rtc core: registered rtc_cmos a=
s rtc0
Aug 11 14:42:10 localhost rtc0: alarms up to one day, 114 bytes nvram
Aug 11 14:42:10 localhost eth0: link up, 100Mbps, full-duplex, lpa 0x05E1=

Aug 11 14:42:12 localhost rpc.statd[11844]: Version 1.1.4 Starting
Aug 11 14:42:12 localhost rpc.statd[11844]: Flags:=20
Aug 11 14:42:13 localhost NET: Registered protocol family 10
Aug 11 14:42:13 localhost lo: Disabled Privacy Extensions
Aug 11 14:42:13 localhost svc: failed to register lockdv1 RPC service (er=
rno 97).
Aug 11 14:42:21 localhost login[11965]: pam_tally(login:auth): unknown op=
tion: no_magic_root
Aug 11 14:42:23 localhost login[11965]: pam_tally(login:account): option =
deny=3D0 allowed in auth phase only
Aug 11 14:42:23 localhost login[11965]: pam_tally(login:account): unknown=
 option: no_magic_root
Aug 11 14:42:23 localhost login[11965]: pam_tally(login:setcred): unknown=
 option: no_magic_root
Aug 11 14:42:23 localhost login[11965]: pam_unix(login:session): session =
opened for user root by LOGIN(uid=3D0)
Aug 11 14:42:23 localhost login[11971]: ROOT LOGIN  on 'tty1'
Aug 11 14:42:24 localhost eth0: no IPv6 routers present
Aug 11 14:42:31 localhost sshd[12027]: Server listening on :: port 22.
Aug 11 14:42:31 localhost sshd[12027]: error: Bind to port 22 on 0.0.0.0 =
failed: Address already in use.
Aug 11 14:42:52 localhost sshd[12036]: Accepted keyboard-interactive/pam =
for root from 192.168.2.10 port 33787 ssh2
Aug 11 14:42:52 localhost sshd[12039]: pam_unix(sshd:session): session op=
ened for user root by root(uid=3D0)
Aug 11 14:43:27 localhost hdb: hdb1
Aug 11 14:44:20 localhost Btrfs loaded
Aug 11 14:44:21 localhost device fsid 954c4d9c508a8479-c1ac2973ec1488c de=
vid 1 transid 7 /dev/hdb1
Aug 11 14:44:21 localhost btrfs: use compression
Aug 11 14:45:40 localhost Clocksource tsc unstable (delta =3D 4687575819 =
ns)
Aug 11 14:45:56 localhost no space left, need 4096, 62730240 delalloc byt=
es, 761450496 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_reado=
nly, 0 may use 824180736 total
Aug 11 14:53:30 localhost no space left, need 32768, 89686016 delalloc by=
tes, 734494720 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_read=
only, 0 may use 824180736 total
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:56:47 localhost space_info has 65536 free, is full
Aug 11 14:56:47 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:56:47 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:56:47 localhost block group has cluster?: no
Aug 11 14:56:47 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:56:47 localhost ------------[ cut here ]------------
Aug 11 14:56:47 localhost WARNING: at fs/btrfs/extent_io.c:3096 free_exte=
nt_buffer+0x21/0x23 [btrfs]()
Aug 11 14:56:47 localhost Hardware name:=20
Aug 11 14:56:47 localhost Modules linked in: btrfs zlib_deflate ipv6 virt=
io_balloon rtc_cmos rtc_core floppy parport_pc rtc_lib parport thermal bu=
tton processor thermal_sys i2c_piix4 8139cp 8139too mii i2c_core virtio_p=
ci virtio_ring pcspkr virtio joydev tg3 libphy e1000 fuse raid10 dm_bbr d=
m_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohc=
i1394 ieee1394 sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hc=
d usbcore lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aa=
craid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc sc=
si_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 d=
mx3191d sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7x=
xx aic79xx scsi_transport_spi sg videobuf_core pdc_adma sata_inic162x sat=
a_mv ata_piix ahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv=
 sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia pc=
mcia_core
Aug 11 14:56:47 localhost Pid: 12107, comm: rm Not tainted 2.6.30-gentoo-=
r4-btrfs-git-1 #1
Aug 11 14:56:47 localhost Call Trace:
Aug 11 14:56:47 localhost [<c0126a54>] warn_slowpath_common+0x60/0x77
Aug 11 14:56:47 localhost [<c0126a78>] warn_slowpath_null+0xd/0x10
Aug 11 14:56:47 localhost [<f92013dd>] free_extent_buffer+0x21/0x23 [btrf=
s]
Aug 11 14:56:47 localhost [<f91d6ee6>] btrfs_release_path+0x39/0x4b [btrf=
s]
Aug 11 14:56:47 localhost [<f91dc1af>] btrfs_search_slot+0x534/0x577 [btr=
fs]
Aug 11 14:56:47 localhost [<f91e134a>] lookup_inline_extent_backref+0xcc/=
0x3f1 [btrfs]
Aug 11 14:56:47 localhost [<f91dd691>] ? block_group_cache_tree_search+0x=
1c/0xca [btrfs]
Aug 11 14:56:47 localhost [<f91e1b17>] __btrfs_free_extent+0xa1/0x706 [bt=
rfs]
Aug 11 14:56:47 localhost [<f91e27d2>] run_one_delayed_ref+0x418/0x431 [b=
trfs]
Aug 11 14:56:47 localhost [<c02bbe7d>] ? memmove+0x11/0x26
Aug 11 14:56:47 localhost [<c02b9933>] ? rb_erase+0x117/0x23b
Aug 11 14:56:47 localhost [<f91e31c7>] run_clustered_refs+0x1e4/0x258 [bt=
rfs]
Aug 11 14:56:47 localhost [<f9216658>] ? btrfs_find_ref_cluster+0xdd/0x10=
f [btrfs]
Aug 11 14:56:47 localhost [<f91e32d3>] btrfs_run_delayed_refs+0x98/0x158 =
[btrfs]
Aug 11 14:56:47 localhost [<f91ec17d>] __btrfs_end_transaction+0x48/0xe1 =
[btrfs]
Aug 11 14:56:47 localhost [<f91ec22f>] btrfs_end_transaction+0xa/0xc [btr=
fs]
Aug 11 14:56:47 localhost [<f91f23a4>] btrfs_delete_inode+0xcc/0x107 [btr=
fs]
Aug 11 14:56:47 localhost [<f91f22d8>] ? btrfs_delete_inode+0x0/0x107 [bt=
rfs]
Aug 11 14:56:47 localhost [<c019c8ff>] generic_delete_inode+0xba/0x138
Aug 11 14:56:47 localhost [<c019c98f>] generic_drop_inode+0x12/0x176
Aug 11 14:56:47 localhost [<c019c3db>] iput+0x4b/0x4e
Aug 11 14:56:47 localhost [<c01969e9>] do_unlinkat+0xb0/0x119
Aug 11 14:56:47 localhost [<c0438bfd>] ? do_page_fault+0x269/0x27f
Aug 11 14:56:47 localhost [<c0196b46>] sys_unlinkat+0x2d/0x2f
Aug 11 14:56:47 localhost [<c0102a49>] syscall_call+0x7/0xb
Aug 11 14:56:47 localhost ---[ end trace 80d416b49be1f1f1 ]---
Aug 11 14:56:47 localhost BUG: unable to handle kernel NULL pointer deref=
erence at 0000001c
Aug 11 14:56:47 localhost IP: [<f91e47b7>] btrfs_print_leaf+0x14/0x913 [b=
trfs]
Aug 11 14:56:47 localhost *pde =3D 00000000=20
Aug 11 14:56:47 localhost Oops: 0000 [#1] SMP=20
Aug 11 14:56:47 localhost last sysfs file: /sys/block/hdb/removable
Aug 11 14:56:47 localhost Modules linked in: btrfs zlib_deflate ipv6 virt=
io_balloon rtc_cmos rtc_core floppy parport_pc rtc_lib parport thermal bu=
tton processor thermal_sys i2c_piix4 8139cp 8139too mii i2c_core virtio_p=
ci virtio_ring pcspkr virtio joydev tg3 libphy e1000 fuse raid10 dm_bbr d=
m_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohc=
i1394 ieee1394 sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hc=
d usbcore lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aa=
craid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc sc=
si_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 d=
mx3191d sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7x=
xx aic79xx scsi_transport_spi sg videobuf_core pdc_adma sata_inic162x sat=
a_mv ata_piix ahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv=
 sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia pc=
mcia_core
Aug 11 14:56:47 localhost=20
Aug 11 14:56:47 localhost Pid: 12107, comm: rm Tainted: G        W  (2.6.=
30-gentoo-r4-btrfs-git-1 #1)=20
Aug 11 14:56:47 localhost EIP: 0060:[<f91e47b7>] EFLAGS: 00010286 CPU: 0
Aug 11 14:56:47 localhost EIP is at btrfs_print_leaf+0x14/0x913 [btrfs]
Aug 11 14:56:47 localhost EAX: f66e9800 EBX: 00000005 ECX: 00000046 EDX: =
00000000
Aug 11 14:56:47 localhost ESI: f66e9800 EDI: 00000000 EBP: e9850d48 ESP: =
e9850c3c
Aug 11 14:56:47 localhost DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Aug 11 14:56:47 localhost Process rm (pid: 12107, ti=3De9850000 task=3Df7=
084140 task.ti=3De9850000)
Aug 11 14:56:47 localhost Stack:
Aug 11 14:56:47 localhost 00000000 c0126a78 00000000 e9850c50 f92013dd e9=
850c60 f91d6ee6 ffffffe4
Aug 11 14:56:47 localhost 00000000 e9850ca4 f91dc1af e9850cf3 f66e9800 eb=
806424 ffffffe4 00000000
Aug 11 14:56:47 localhost 00000002 00000000 00000000 f6faa558 ebb0176c 00=
000001 f6faa558 00000005
Aug 11 14:56:47 localhost Call Trace:
Aug 11 14:56:47 localhost [<c0126a78>] ? warn_slowpath_null+0xd/0x10
Aug 11 14:56:47 localhost [<f92013dd>] ? free_extent_buffer+0x21/0x23 [bt=
rfs]
Aug 11 14:56:47 localhost [<f91d6ee6>] ? btrfs_release_path+0x39/0x4b [bt=
rfs]
Aug 11 14:56:47 localhost [<f91dc1af>] ? btrfs_search_slot+0x534/0x577 [b=
trfs]
Aug 11 14:56:47 localhost [<f91e134a>] ? lookup_inline_extent_backref+0xc=
c/0x3f1 [btrfs]
Aug 11 14:56:47 localhost [<f91dd691>] ? block_group_cache_tree_search+0x=
1c/0xca [btrfs]
Aug 11 14:56:47 localhost [<f91e1b17>] ? __btrfs_free_extent+0xa1/0x706 [=
btrfs]
Aug 11 14:56:47 localhost [<f91e1cf8>] ? __btrfs_free_extent+0x282/0x706 =
[btrfs]
Aug 11 14:56:47 localhost [<f91e27d2>] ? run_one_delayed_ref+0x418/0x431 =
[btrfs]
Aug 11 14:56:47 localhost [<c02bbe7d>] ? memmove+0x11/0x26
Aug 11 14:56:47 localhost [<c02b9933>] ? rb_erase+0x117/0x23b
Aug 11 14:56:47 localhost [<f91e31c7>] ? run_clustered_refs+0x1e4/0x258 [=
btrfs]
Aug 11 14:56:47 localhost [<f9216658>] ? btrfs_find_ref_cluster+0xdd/0x10=
f [btrfs]
Aug 11 14:56:47 localhost [<f91e32d3>] ? btrfs_run_delayed_refs+0x98/0x15=
8 [btrfs]
Aug 11 14:56:47 localhost [<f91ec17d>] ? __btrfs_end_transaction+0x48/0xe=
1 [btrfs]
Aug 11 14:56:47 localhost [<f91ec22f>] ? btrfs_end_transaction+0xa/0xc [b=
trfs]
Aug 11 14:56:47 localhost [<f91f23a4>] ? btrfs_delete_inode+0xcc/0x107 [b=
trfs]
Aug 11 14:56:47 localhost [<f91f22d8>] ? btrfs_delete_inode+0x0/0x107 [bt=
rfs]
Aug 11 14:56:47 localhost [<c019c8ff>] ? generic_delete_inode+0xba/0x138
Aug 11 14:56:47 localhost [<c019c98f>] ? generic_drop_inode+0x12/0x176
Aug 11 14:56:47 localhost [<c019c3db>] ? iput+0x4b/0x4e
Aug 11 14:56:47 localhost [<c01969e9>] ? do_unlinkat+0xb0/0x119
Aug 11 14:56:47 localhost [<c0438bfd>] ? do_page_fault+0x269/0x27f
Aug 11 14:56:47 localhost [<c0196b46>] ? sys_unlinkat+0x2d/0x2f
Aug 11 14:56:47 localhost [<c0102a49>] ? syscall_call+0x7/0xb
Aug 11 14:56:47 localhost Code: 52 50 68 00 d0 21 f9 e8 bb 2d f4 c6 83 c4=
 20 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 81 ec 00 01 00 00 89 =
95 f4 fe ff ff <8b> 42 1c ba 03 00 00 00 e8 db 6e f3 c6 8b 50 60 89 95 40=
 ff ff=20
Aug 11 14:56:47 localhost EIP: [<f91e47b7>] btrfs_print_leaf+0x14/0x913 [=
btrfs] SS:ESP 0068:e9850c3c
Aug 11 14:56:47 localhost CR2: 000000000000001c
Aug 11 14:56:47 localhost ---[ end trace 80d416b49be1f1f2 ]---
Aug 11 14:57:12 localhost btrfs allocation failed flags 36, wanted 4096
Aug 11 14:57:12 localhost space_info has 65536 free, is full
Aug 11 14:57:12 localhost space_info total=3D50987008, pinned=3D16343040,=
 delalloc=3D0, may_use=3D0, used=3D34549760
Aug 11 14:57:12 localhost block group 29360128 has 50987008 bytes, 345497=
60 used 16343040 pinned 28672 reserved
Aug 11 14:57:12 localhost block group has cluster?: no
Aug 11 14:57:12 localhost 0 blocks of free space at or bigger than bytes =
is
Aug 11 14:57:12 localhost ------------[ cut here ]------------
Aug 11 14:57:12 localhost WARNING: at fs/btrfs/extent_io.c:3096 free_exte=
nt_buffer+0x21/0x23 [btrfs]()
Aug 11 14:57:12 localhost Hardware name:=20
Aug 11 14:57:12 localhost Modules linked in: btrfs zlib_deflate ipv6 virt=
io_balloon rtc_cmos rtc_core floppy parport_pc rtc_lib parport thermal bu=
tton processor thermal_sys i2c_piix4 8139cp 8139too mii i2c_core virtio_p=
ci virtio_ring pcspkr virtio joydev tg3 libphy e1000 fuse raid10 dm_bbr d=
m_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohc=
i1394 ieee1394 sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hc=
d usbcore lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aa=
craid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc sc=
si_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 d=
mx3191d sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7x=
xx aic79xx scsi_transport_spi sg videobuf_core pdc_adma sata_inic162x sat=
a_mv ata_piix ahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv=
 sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia pc=
mcia_core
Aug 11 14:57:12 localhost Pid: 12088, comm: btrfs-transacti Tainted: G   =
   D W  2.6.30-gentoo-r4-btrfs-git-1 #1
Aug 11 14:57:12 localhost Call Trace:
Aug 11 14:57:12 localhost [<c0126a54>] warn_slowpath_common+0x60/0x77
Aug 11 14:57:12 localhost [<c0126a78>] warn_slowpath_null+0xd/0x10
Aug 11 14:57:12 localhost [<f92013dd>] free_extent_buffer+0x21/0x23 [btrf=
s]
Aug 11 14:57:12 localhost [<f91dbe26>] btrfs_search_slot+0x1ab/0x577 [btr=
fs]
Aug 11 14:57:12 localhost [<f91e134a>] lookup_inline_extent_backref+0xcc/=
0x3f1 [btrfs]
Aug 11 14:57:12 localhost [<f91e1b17>] __btrfs_free_extent+0xa1/0x706 [bt=
rfs]
Aug 11 14:57:12 localhost [<c0101759>] ? __switch_to+0xde/0x168
Aug 11 14:57:12 localhost [<c013c7a9>] ? getnstimeofday+0x57/0xe1
Aug 11 14:57:12 localhost [<c013921b>] ? ktime_get_ts+0x4a/0x4e
Aug 11 14:57:12 localhost [<f91e27d2>] run_one_delayed_ref+0x418/0x431 [b=
trfs]
Aug 11 14:57:12 localhost [<f91e31c7>] run_clustered_refs+0x1e4/0x258 [bt=
rfs]
Aug 11 14:57:12 localhost [<f9216658>] ? btrfs_find_ref_cluster+0xdd/0x10=
f [btrfs]
Aug 11 14:57:12 localhost [<f91e32d3>] btrfs_run_delayed_refs+0x98/0x158 =
[btrfs]
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<f91ecc0c>] btrfs_commit_transaction+0x68/0x61=
c [btrfs]
Aug 11 14:57:12 localhost [<c0435a16>] ? mutex_unlock+0x8/0xa
Aug 11 14:57:12 localhost [<c01367cd>] ? autoremove_wake_function+0x0/0x3=
3
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<f91e9f45>] transaction_kthread+0x12f/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<c011cdd8>] ? complete+0x34/0x3e
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<c01366f8>] kthread+0x45/0x6d
Aug 11 14:57:12 localhost [<c01366b3>] ? kthread+0x0/0x6d
Aug 11 14:57:12 localhost [<c0103417>] kernel_thread_helper+0x7/0x10
Aug 11 14:57:12 localhost ---[ end trace 80d416b49be1f1f3 ]---
Aug 11 14:57:12 localhost BUG: unable to handle kernel NULL pointer deref=
erence at 0000001c
Aug 11 14:57:12 localhost IP: [<f91e47b7>] btrfs_print_leaf+0x14/0x913 [b=
trfs]
Aug 11 14:57:12 localhost *pde =3D 00000000=20
Aug 11 14:57:12 localhost Oops: 0000 [#2] SMP=20
Aug 11 14:57:12 localhost last sysfs file: /sys/block/hdb/removable
Aug 11 14:57:12 localhost Modules linked in: btrfs zlib_deflate ipv6 virt=
io_balloon rtc_cmos rtc_core floppy parport_pc rtc_lib parport thermal bu=
tton processor thermal_sys i2c_piix4 8139cp 8139too mii i2c_core virtio_p=
ci virtio_ring pcspkr virtio joydev tg3 libphy e1000 fuse raid10 dm_bbr d=
m_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohc=
i1394 ieee1394 sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hc=
d usbcore lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aa=
craid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc sc=
si_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x qla1280 d=
mx3191d sym53c8xx qlogicfas408 gdth advansys initio BusLogic arcmsr aic7x=
xx aic79xx scsi_transport_spi sg videobuf_core pdc_adma sata_inic162x sat=
a_mv ata_piix ahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv=
 sata_via sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia pc=
mcia_core
Aug 11 14:57:12 localhost=20
Aug 11 14:57:12 localhost Pid: 12088, comm: btrfs-transacti Tainted: G   =
   D W  (2.6.30-gentoo-r4-btrfs-git-1 #1)=20
Aug 11 14:57:12 localhost EIP: 0060:[<f91e47b7>] EFLAGS: 00010286 CPU: 0
Aug 11 14:57:12 localhost EIP is at btrfs_print_leaf+0x14/0x913 [btrfs]
Aug 11 14:57:12 localhost EAX: f66e9800 EBX: 00000005 ECX: 00000046 EDX: =
00000000
Aug 11 14:57:12 localhost ESI: f66e9800 EDI: 00000000 EBP: f5c5add8 ESP: =
f5c5accc
Aug 11 14:57:12 localhost DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Aug 11 14:57:12 localhost Process btrfs-transacti (pid: 12088, ti=3Df5c5a=
000 task=3Df70a9660 task.ti=3Df5c5a000)
Aug 11 14:57:12 localhost Stack:
Aug 11 14:57:12 localhost 00000000 ffffffe4 00000000 f6cfc91c f5c5ace8 f5=
c5acf0 f91d6ee6 ffffffe4
Aug 11 14:57:12 localhost 00000000 f5c5ad34 f91dc1af f5c5ad83 f66e9800 eb=
806c94 ffffffe4 00000000
Aug 11 14:57:12 localhost 00000002 000000d3 00000001 f6faa558 ebb0176c 00=
000001 f6faa558 00000005
Aug 11 14:57:12 localhost Call Trace:
Aug 11 14:57:12 localhost [<f91d6ee6>] ? btrfs_release_path+0x39/0x4b [bt=
rfs]
Aug 11 14:57:12 localhost [<f91dc1af>] ? btrfs_search_slot+0x534/0x577 [b=
trfs]
Aug 11 14:57:12 localhost [<f91e134a>] ? lookup_inline_extent_backref+0xc=
c/0x3f1 [btrfs]
Aug 11 14:57:12 localhost [<f91e1b17>] ? __btrfs_free_extent+0xa1/0x706 [=
btrfs]
Aug 11 14:57:12 localhost [<f91e1cf8>] ? __btrfs_free_extent+0x282/0x706 =
[btrfs]
Aug 11 14:57:12 localhost [<c0101759>] ? __switch_to+0xde/0x168
Aug 11 14:57:12 localhost [<c013c7a9>] ? getnstimeofday+0x57/0xe1
Aug 11 14:57:12 localhost [<c013921b>] ? ktime_get_ts+0x4a/0x4e
Aug 11 14:57:12 localhost [<f91e27d2>] ? run_one_delayed_ref+0x418/0x431 =
[btrfs]
Aug 11 14:57:12 localhost [<f91e31c7>] ? run_clustered_refs+0x1e4/0x258 [=
btrfs]
Aug 11 14:57:12 localhost [<f9216658>] ? btrfs_find_ref_cluster+0xdd/0x10=
f [btrfs]
Aug 11 14:57:12 localhost [<f91e32d3>] ? btrfs_run_delayed_refs+0x98/0x15=
8 [btrfs]
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<f91ecc0c>] ? btrfs_commit_transaction+0x68/0x=
61c [btrfs]
Aug 11 14:57:12 localhost [<c0435a16>] ? mutex_unlock+0x8/0xa
Aug 11 14:57:12 localhost [<c01367cd>] ? autoremove_wake_function+0x0/0x3=
3
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<f91e9f45>] ? transaction_kthread+0x12f/0x1a6 =
[btrfs]
Aug 11 14:57:12 localhost [<c011cdd8>] ? complete+0x34/0x3e
Aug 11 14:57:12 localhost [<f91e9e16>] ? transaction_kthread+0x0/0x1a6 [b=
trfs]
Aug 11 14:57:12 localhost [<c01366f8>] ? kthread+0x45/0x6d
Aug 11 14:57:12 localhost [<c01366b3>] ? kthread+0x0/0x6d
Aug 11 14:57:12 localhost [<c0103417>] ? kernel_thread_helper+0x7/0x10
Aug 11 14:57:12 localhost Code: 52 50 68 00 d0 21 f9 e8 bb 2d f4 c6 83 c4=
 20 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 81 ec 00 01 00 00 89 =
95 f4 fe ff ff <8b> 42 1c ba 03 00 00 00 e8 db 6e f3 c6 8b 50 60 89 95 40=
 ff ff=20
Aug 11 14:57:12 localhost EIP: [<f91e47b7>] btrfs_print_leaf+0x14/0x913 [=
btrfs] SS:ESP 0068:f5c5accc
Aug 11 14:57:12 localhost CR2: 000000000000001c
Aug 11 14:57:12 localhost ---[ end trace 80d416b49be1f1f4 ]---
Aug 11 15:00:45 localhost login[11966]: pam_tally(login:auth): unknown op=
tion: no_magic_root
Aug 11 15:00:47 localhost login[11966]: pam_unix(login:auth): authenticat=
ion failure; logname=3DLOGIN uid=3D0 euid=3D0 tty=3Dtty2 ruser=3D rhost=3D=
  user=3Droot
Aug 11 15:00:50 localhost login[11966]: FAILED LOGIN (1) on 'tty2' FOR `r=
oot', Authentication failure
Aug 11 15:00:53 localhost login[11966]: pam_tally(login:auth): unknown op=
tion: no_magic_root
Aug 11 15:00:55 localhost login[11966]: pam_tally(login:account): option =
deny=3D0 allowed in auth phase only
Aug 11 15:00:55 localhost login[11966]: pam_tally(login:account): unknown=
 option: no_magic_root
Aug 11 15:00:55 localhost login[11966]: pam_tally(login:setcred): unknown=
 option: no_magic_root
Aug 11 15:00:55 localhost login[11966]: pam_unix(login:session): session =
opened for user root by LOGIN(uid=3D0)
Aug 11 15:00:55 localhost login[12108]: ROOT LOGIN  on 'tty2'
Aug 11 15:02:36 localhost sshd[12116]: pam_unix(sshd:auth): authenticatio=
n failure; logname=3D uid=3D0 euid=3D0 tty=3Dssh ruser=3D rhost=3D192.168=
=2E2.10  user=3Droot
Aug 11 15:02:38 localhost sshd[12114]: error: PAM: Authentication failure=
 for root from 192.168.2.10
Aug 11 15:02:40 localhost sshd[12114]: Accepted keyboard-interactive/pam =
for root from 192.168.2.10 port 57578 ssh2
Aug 11 15:02:40 localhost sshd[12118]: pam_unix(sshd:session): session op=
ened for user root by (uid=3D0)


--------------030104030006030402000707
Content-Type: text/plain;
 name="btrfs.md5"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs.md5"

711ef7104af315234420a4921cf7ae4f  acl.c
b06eff3dc3e888338c43d90e825a1ce2  async-thread.c
85e467c97f680ad17945abcccd16be04  btrfs.mod.c
f73133b232fe8b8f854861105f1d5e68  compression.c
7c16a2fd84012e9603229d1303be2b1e  ctree.c
8534d20606e97389d69b47f42ff7842f  delayed-ref.c
821b3d3a40bd26c6ef2e848dc13058e1  dir-item.c
ab1e21067afa519dd2eb438fbe2a5d15  disk-io.c
05e5a1f6316026c9f17f00bfac9b0051  export.c
0a9af6c135dc60f52c0ec8280922b47d  extent-tree.c
52959d2f837cd0be30bc1bddb4bc6e2d  extent_io.c
03e03cdd336d6322acbb569ef67a9518  extent_map.c
21e0e1753bf8124887d5c7599909e59a  file-item.c
ac1e1d4cf092f38949bd3dc4e4fee442  file.c
abea2249ce82aa3126f5e3d83de5dd24  free-space-cache.c
ba578a220fe9cee78c0d1e60e6c823b2  inode-item.c
0e0d749aee8f613486a86a22c9fb9c59  inode-map.c
44882bbb02368d5966bef4ebe6b31916  inode.c
31a1cee709bffe5623f388ccc1211151  ioctl.c
d8313dbaa3b6b41697f30028239e5553  locking.c
ca5952f28b70dd066285af7a3a77c128  ordered-data.c
194d4628f115163397bad30dd88fe7ed  orphan.c
a454a23dc6763356d7de01ac1688ef4d  print-tree.c
a9f8d2c9d2af62ad79e45fc1b3ac5f80  ref-cache.c
8e32e54c4f34dc1f854cdc1fde6dc091  relocation.c
91144e9cb2e65f4cc82b96cc6dbc222d  root-tree.c
e36677f27adbb6f84970deaec337e456  struct-funcs.c
f639aa91f7a860f9756a8eca7be44260  super.c
f1bc3cfa69bbeace198dd09657b8766e  sysfs.c
835ba19272b4cbf6cdc8fd5414037634  transaction.c
7eff7df90e8e418180a63f660086476f  tree-defrag.c
9d8dd9dea3ecc1cd14a8ce8aa65b9998  tree-log.c
60c24928069276b0337a8d609f553866  volumes.c
c046dbb122d541e4970638cac87bd82c  xattr.c
d16d4e3f317c465bac93751970a2f8e8  zlib.c
76befefd010e4d9a2fb8b6de364876f3  async-thread.h
c9a48953e6548d565609bae2abae2e3b  btrfs_inode.h
18747a040143a90ddab53ccf130bbc43  compat.h
a2d0d7e6e11cf6ea46220de4d1c235e4  compression.h
580df41315834ee6dd16e59d09056206  crc32c.h
c3d7bd35baab101a655d3de0bbeffea3  ctree.h
745219241655c6a235a573c4ef6def40  delayed-ref.h
3f303902227368cde1b92ab58974c87c  disk-io.h
00262a4630ec8296585a6f8db325465f  export.h
d7170396fe28f2e3c9da3c8702014667  extent_io.h
a92bd0ab3b76d32b894460db759ce9a6  extent_map.h
ba0194baa320dbba3579a064be7bebcd  free-space-cache.h
65ae5082110a5201ae0e7a44f059070a  hash.h
a4c368b30f3e8edf1903fc43ad3754a7  ioctl.h
a57a3c99563491ee74d18ff83f7ae735  locking.h
1a672493c326e45caaeb802f18f4e5a7  ordered-data.h
24c5c7707bd590680974a87c56005e67  print-tree.h
10738d4e8632fd36162870f0ea510d65  ref-cache.h
8fbe1118fc2df1a5479fb9482e6671c4  transaction.h
3e6c19160e575bf1fc67230726ac45c3  tree-log.h
81bfc6c6b458f0a27322f05955eb0b79  version.h
43017bafd4fbc20f1feaa8b7132f545a  volumes.h
6770ba32a2993aae00406edb0860df1b  xattr.h


--------------030104030006030402000707--
