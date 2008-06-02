From: Ric Wheeler <rwheeler@redhat.com>
Subject: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s! [fs_mark:4573]
Date: Mon, 02 Jun 2008 13:52:47 -0400
Message-ID: <4844336F.1010807@redhat.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050200060703030300050807"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050200060703030300050807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I can reliably get btrfs to panic by running my fs_mark code on a newly 
created file system with lots of threads on an 8-way box. If this is too 
aggressive, let me know ;-)

Here is a summary of the panic:

EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
device fsid 814e6131acbfcbec-7a2a40df880929bb devid 1 transid 495 /dev/sdb1
BUG: soft lockup - CPU#1 stuck for 61s! [fs_mark:4572]
CPU 1:
Modules linked in: btrfs libcrc32c ipt_MASQUERADE iptable_nat nf_nat 
bridge bnep rfcomm l2cap bluetooth ib_iser rdma_cm ib_cm iw_cm ib_sa 
ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi fuse 
sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT 
xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter 
ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod kvm_intel kvm 
snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
snd_seq_device snd_pcm_oss iTCO_wdt snd_mixer_oss iTCO_vendor_support 
nvidia(P) pata_acpi button ata_piix snd_pcm ppdev firewire_ohci i2c_i801 
ata_generic firewire_core pcspkr dcdbas snd_timer sr_mod cdrom 
snd_page_alloc snd_hwdep snd tg3 serio_raw i2c_core shpchp crc_itu_t sg 
parport_pc soundcore parport floppy ahci libata sd_mod scsi_mod ext3 jbd 
mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Pid: 4572, comm: fs_mark Tainted: P         2.6.25.3-18.fc9.x86_64 #1
RIP: 0010:[<ffffffff81132929>]  [<ffffffff81132929>] 
__write_lock_failed+0x9/0x20
RSP: 0018:ffff81000c529e60  EFLAGS: 00000206
RAX: ffff810015c0e000 RBX: ffff81000c529e68 RCX: 0000000000000016
RDX: ffff81003d019e00 RSI: 0000000000000001 RDI: ffff8100100e24f0
RBP: ffff8100189bef00 R08: 0000000000000000 R09: 0000000000000016
R10: 0000000012750e57 R11: 0000000000000246 R12: 0000000000000202
R13: ffff81000c529de8 R14: 00000000000011dc R15: ffff81000c529f58
FS:  000000000159b850(0063) GS:ffff81003f802680(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f55301940a8 CR3: 000000000c513000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff81292408>] ? _write_lock+0x12/0x14
 [<ffffffff88c27ff2>] ? :btrfs:btrfs_del_ordered_inode+0xc0/0x13f
 [<ffffffff88c1e67f>] ? :btrfs:btrfs_release_file+0x9/0xd
 [<ffffffff810a5eff>] ? __fput+0xca/0x189
 [<ffffffff810a5fd2>] ? fput+0x14/0x16
 [<ffffffff810a32c8>] ? filp_close+0x66/0x71
 [<ffffffff810a336c>] ? sys_close+0x99/0xd2
 [<ffffffff8100c052>] ? tracesys+0xd5/0xda


ric





--------------050200060703030300050807
Content-Type: text/plain;
 name="btrfs_panic.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrfs_panic.txt"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.25.3-18.fc9.x86_64 (mockbuild@) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Tue May 13 04:54:47 EDT 2008
Command line: ro root=UUID=1b44ce19-eab7-43ce-ba66-510fd2e3ef5b rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fe0ac00 (usable)
 BIOS-e820: 000000003fe0ac00 - 000000003fe5cc00 (ACPI NVS)
 BIOS-e820: 000000003fe5cc00 - 000000003fe5ec00 (ACPI data)
 BIOS-e820: 000000003fe5ec00 - 0000000040000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 00000000ff000000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 261642) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.5 present.
ACPI: RSDP 000FEBF0, 0024 (r2 DELL  )
ACPI: XSDT 000FCD54, 0074 (r1 DELL    B9K           15 ASL        61)
ACPI: FACP 000FCE84, 00F4 (r3 DELL    B9K           15 ASL        61)
ACPI: DSDT FFF62D72, 3A12 (r1   DELL    dt_ex     1000 INTL 20050624)
ACPI: FACS 3FE0AC00, 0040
ACPI: SSDT FFF668A5, 00AC (r1   DELL    st_ex     1000 INTL 20050624)
ACPI: APIC 000FCF78, 00AA (r1 DELL    B9K           15 ASL        61)
ACPI: BOOT 000FD022, 0028 (r1 DELL    B9K           15 ASL        61)
ACPI: ASF! 000FD04A, 0096 (r32 DELL    B9K           15 ASL        61)
ACPI: MCFG 000FD0E0, 003E (r1 DELL    B9K           15 ASL        61)
ACPI: HPET 000FD11E, 0038 (r1 DELL    B9K           15 ASL        61)
ACPI: TCPA 000FD37A, 0032 (r1 DELL    B9K           15 ASL        61)
ACPI: ____ 000FD3AC, 0030 (r1 DELL    B9K           15 ASL        61)
ACPI: SLIC 000FD156, 00C0 (r1 DELL    B9K           15 ASL        61)
No NUMA configuration found
Faking a node at 0000000000000000-000000003fe0a000
Entering add_active_range(0, 0, 158) 0 entries of 3200 used
Entering add_active_range(0, 256, 261642) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003fe0a000
  NODE_DATA [000000000000b000 - 0000000000012fff]
  bootmap [0000000000013000 -  000000000001afc7] pages 8
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-75db3b] TEXT DATA BSS
early res: 3 [37d19000-37fef182] RAMDISK
early res: 4 [9ec00-a0bff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      158
    0:      256 ->   261642
On node 0 totalpages: 261544
  DMA zone: 56 pages used for memmap
  DMA zone: 1383 pages reserved
  DMA zone: 2559 pages, LIFO batch:0
  DMA32 zone: 3521 pages used for memmap
  DMA32 zone: 254025 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
Processor #4
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
Processor #5
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x02] enabled)
Processor #2
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
Processor #3
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
IOAPIC[1]: apic_id 9, address 0xfec88000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
IOAPIC[2]: apic_id 10, address 0xfec89000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009e000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 45232 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256584
Policy zone: DMA32
Kernel command line: ro root=UUID=1b44ce19-eab7-43ce-ba66-510fd2e3ef5b rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 1994.998 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 1022808k/1046568k available (2657k kernel code, 23368k reserved, 1395k data, 356k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-1, MinObjects=4, CPUs=8, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3992.49 BogoMIPS (lpj=1996246)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 20781220
Detected 20.781 MHz APIC timer.
Booting processor 1/8 APIC 0x4
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS (lpj=1995018)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 1/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/8 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS (lpj=1995015)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/8 APIC 0x5
Initializing CPU#3
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS (lpj=1995016)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 3/5 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4/8 APIC 0x2
Initializing CPU#4
Calibrating delay using timer specific routine.. 4069.81 BogoMIPS (lpj=2034905)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 4/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU4: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5/8 APIC 0x6
Initializing CPU#5
Calibrating delay using timer specific routine.. 3990.04 BogoMIPS (lpj=1995023)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 5/6 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU5: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6/8 APIC 0x3
Initializing CPU#6
Calibrating delay using timer specific routine.. 3990.02 BogoMIPS (lpj=1995013)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 6/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU6: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7/8 APIC 0x7
Initializing CPU#7
Calibrating delay using timer specific routine.. 3990.03 BogoMIPS (lpj=1995018)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU 7/7 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=224 bytes
sizeof(task_struct)=6272 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000005
  groups: 00000000,00000001 00000000,00000004
  domain 1: span 00000000,000000ff
   groups: 00000000,00000005 00000000,0000000a 00000000,00000050 00000000,000000a0
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU1 attaching sched-domain:
 domain 0: span 00000000,0000000a
  groups: 00000000,00000002 00000000,00000008
  domain 1: span 00000000,000000ff
   groups: 00000000,0000000a 00000000,00000050 00000000,000000a0 00000000,00000005
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU2 attaching sched-domain:
 domain 0: span 00000000,00000005
  groups: 00000000,00000004 00000000,00000001
  domain 1: span 00000000,000000ff
   groups: 00000000,00000005 00000000,0000000a 00000000,00000050 00000000,000000a0
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU3 attaching sched-domain:
 domain 0: span 00000000,0000000a
  groups: 00000000,00000008 00000000,00000002
  domain 1: span 00000000,000000ff
   groups: 00000000,0000000a 00000000,00000050 00000000,000000a0 00000000,00000005
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU4 attaching sched-domain:
 domain 0: span 00000000,00000050
  groups: 00000000,00000010 00000000,00000040
  domain 1: span 00000000,000000ff
   groups: 00000000,00000050 00000000,000000a0 00000000,00000005 00000000,0000000a
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU5 attaching sched-domain:
 domain 0: span 00000000,000000a0
  groups: 00000000,00000020 00000000,00000080
  domain 1: span 00000000,000000ff
   groups: 00000000,000000a0 00000000,00000005 00000000,0000000a 00000000,00000050
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU6 attaching sched-domain:
 domain 0: span 00000000,00000050
  groups: 00000000,00000040 00000000,00000010
  domain 1: span 00000000,000000ff
   groups: 00000000,00000050 00000000,000000a0 00000000,00000005 00000000,0000000a
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
CPU7 attaching sched-domain:
 domain 0: span 00000000,000000a0
  groups: 00000000,00000080 00000000,00000020
  domain 1: span 00000000,000000ff
   groups: 00000000,000000a0 00000000,00000005 00000000,0000000a 00000000,00000050
   domain 2: span 00000000,000000ff
    groups: 00000000,000000ff
net_namespace: 1016 bytes
Time: 16:35:03  Date: 06/02/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored
ACPI: DMI System Vendor: Dell Inc.
ACPI: DMI Product Name: Precision WorkStation T5400  
ACPI: DMI Product Version: 
ACPI: DMI Board Name: 0RW203
ACPI: DMI BIOS Vendor: Dell Inc.
ACPI: DMI BIOS Date: 03/22/2008
ACPI: Please send DMI info above to linux-acpi@vger.kernel.org
ACPI: If "acpi_osi=Linux" works better, please notify linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4.PCI5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4.PCI6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [TCPA] -  00, should be 87 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:parse DMAR table failure.
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 7
system 00:01: ioport range 0x800-0x85f has been reserved
system 00:01: ioport range 0xc00-0xc7f has been reserved
system 00:01: ioport range 0x860-0x8ff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xfbe00000-0xfbefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: d000-dfff
  MEM window: 0xf8000000-0xfbdfffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Bridge: 0000:04:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:04:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: disabled.
  MEM window: 0xf7f00000-0xf7ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xf7e00000-0xf7efffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xf7d00000-0xf7dfffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 48 (level, low) -> IRQ 48
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 52 (level, low) -> IRQ 52
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 56 (level, low) -> IRQ 56
PCI: Setting latency timer of device 0000:00:09.0 to 64
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 56 (level, low) -> IRQ 56
PCI: Setting latency timer of device 0000:03:00.0 to 64
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 56 (level, low) -> IRQ 56
PCI: Setting latency timer of device 0000:04:00.0 to 64
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 56 (level, low) -> IRQ 56
PCI: Setting latency timer of device 0000:04:01.0 to 64
PCI: Setting latency timer of device 0000:03:00.3 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2904k freed
Simple Boot Flag at 0x7a set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1212424504.621:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:02:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
Allocate Port Service[0000:00:09.0:pcie01]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:03:00.0 to 64
Allocate Port Service[0000:03:00.0:pcie11]
PCI: Setting latency timer of device 0000:04:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:04:00.0:pcie21]
PCI: Setting latency timer of device 0000:04:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:04:01.0:pcie21]
AER service couldn't init device 0000:00:01.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:05.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:09.0:pcie01 - no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: ACPI0007:04 is registered as cooling_device4
ACPI: ACPI0007:05 is registered as cooling_device5
ACPI: ACPI0007:06 is registered as cooling_device6
ACPI: ACPI0007:07 is registered as cooling_device7
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 12:873:589
Freeing unused kernel memory: 356k freed
Write protecting the kernel read-only data: 1120k
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xff980800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25.3-18.fc9.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.3-18.fc9.x86_64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 1
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25.3-18.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25.3-18.fc9.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 2
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25.3-18.fc9.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 20
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input1
input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.0-1
usb 2-1: New USB device found, idVendor=413c, idProduct=2003
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: Dell USB Keyboard
usb 2-1: Manufacturer: Dell
usb 2-2: new low speed USB device using uhci_hcd and address 3
usb 2-2: configuration #1 chosen from 1 choice
input: Dell Dell USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input2
input,hidraw1: USB HID v1.11 Mouse [Dell Dell USB Optical Mouse] on usb-0000:00:1d.0-2
usb 2-2: New USB device found, idVendor=413c, idProduct=3012
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Dell USB Optical Mouse
usb 2-2: Manufacturer: Dell
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x1f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xff970000 port 0xff970100 irq 20
ata2: SATA max UDMA/133 abar m1024@0xff970000 port 0xff970180 irq 20
ata3: SATA max UDMA/133 abar m1024@0xff970000 port 0xff970200 irq 20
ata4: SATA max UDMA/133 abar m1024@0xff970000 port 0xff970280 irq 20
ata5: SATA max UDMA/133 abar m1024@0xff970000 port 0xff970300 irq 20
ata6: DUMMY
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST380815AS, 4.ADA, max UDMA/133
ata1.00: 156250000 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-8: ST31000340AS, SD15, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI: PBDS CD-RW/DVD-ROM DH-48C2S, ND11, max UDMA/100
ata3.00: configured for UDMA/100
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 4 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST380815AS       4.AD PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST31000340AS     SD15 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 2:0:0:0: CD-ROM            PBDS     CDRWDVD DH-48C2S ND11 PQ: 0 ANSI: 5
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1212424513.930:2): selinux=0 auid=4294967295 ses=4294967295
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Attached scsi generic sg2 type 5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
tg3.c:v3.91 (April 18, 2008)
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:08:00.0 to 64
eth0: Tigon3 [partno(BCM95754) rev b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:1e:4f:c7:ed:c3
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 0x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
input: PC Speaker as /devices/platform/pcspkr/input/input3
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI Interrupt 0000:09:02.0[A] -> GSI 18 (level, low) -> IRQ 18
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
ppdev: user-space parallel port driver
firewire_ohci: Added fw-ohci device 0000:09:02.0, OHCI version 1.0
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi6 : ata_piix
scsi7 : ata_piix
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata7: port disabled. ignoring.
ata8: port disabled. ignoring.
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
firewire_core: created device fw0: GUID 0000d1008026a5d0, S400
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 52 (level, low) -> IRQ 52
PCI: Setting latency timer of device 0000:02:00.0 to 64
iTCO_vendor_support: vendor-support=0
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.08  Wed Apr  2 07:55:48 PST 2008
ACPI: Power Button (CM) [VBTN]
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
iTCO_wdt: No card detected
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA sound/pci/hda/hda_intel.c:1810: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:749: codec_mask = 0x1
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Internal Mic Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Docking Mic Playback VolumeBeep Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Surround Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Center Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave LFE Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Side Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1073: Cannot find slave Speaker Playback Switch, skipped
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 8385888k swap on /dev/sda5.  Priority:-1 extents:1 across:8385888k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
fuse init (API version 7.9)
Loading iSCSI transport class v2.0-869.
iscsi: registered transport (tcp)
iscsi: registered transport (iser)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
virbr0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
virbr0: starting userspace STP failed, starting kernel STP
ADDRCONF(NETDEV_UP): eth0: link is not ready
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
virbr0: no IPv6 routers present
eth0: no IPv6 routers present
mtrr: base(0xd0000000) is not aligned on a size(0xff00000) boundary
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
device fsid 814e6131acbfcbec-7a2a40df880929bb devid 1 transid 495 /dev/sdb1
BUG: soft lockup - CPU#1 stuck for 61s! [fs_mark:4572]
CPU 1:
Modules linked in: btrfs libcrc32c ipt_MASQUERADE iptable_nat nf_nat bridge bnep rfcomm l2cap bluetooth ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod kvm_intel kvm snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss iTCO_wdt snd_mixer_oss iTCO_vendor_support nvidia(P) pata_acpi button ata_piix snd_pcm ppdev firewire_ohci i2c_i801 ata_generic firewire_core pcspkr dcdbas snd_timer sr_mod cdrom snd_page_alloc snd_hwdep snd tg3 serio_raw i2c_core shpchp crc_itu_t sg parport_pc soundcore parport floppy ahci 
 libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Pid: 4572, comm: fs_mark Tainted: P         2.6.25.3-18.fc9.x86_64 #1
RIP: 0010:[<ffffffff81132929>]  [<ffffffff81132929>] __write_lock_failed+0x9/0x20
RSP: 0018:ffff81000c529e60  EFLAGS: 00000206
RAX: ffff810015c0e000 RBX: ffff81000c529e68 RCX: 0000000000000016
RDX: ffff81003d019e00 RSI: 0000000000000001 RDI: ffff8100100e24f0
RBP: ffff8100189bef00 R08: 0000000000000000 R09: 0000000000000016
R10: 0000000012750e57 R11: 0000000000000246 R12: 0000000000000202
R13: ffff81000c529de8 R14: 00000000000011dc R15: ffff81000c529f58
FS:  000000000159b850(0063) GS:ffff81003f802680(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f55301940a8 CR3: 000000000c513000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff81292408>] ? _write_lock+0x12/0x14
 [<ffffffff88c27ff2>] ? :btrfs:btrfs_del_ordered_inode+0xc0/0x13f
 [<ffffffff88c1e67f>] ? :btrfs:btrfs_release_file+0x9/0xd
 [<ffffffff810a5eff>] ? __fput+0xca/0x189
 [<ffffffff810a5fd2>] ? fput+0x14/0x16
 [<ffffffff810a32c8>] ? filp_close+0x66/0x71
 [<ffffffff810a336c>] ? sys_close+0x99/0xd2
 [<ffffffff8100c052>] ? tracesys+0xd5/0xda

BUG: soft lockup - CPU#0 stuck for 61s! [fs_mark:4573]
CPU 0:
Modules linked in: btrfs libcrc32c ipt_MASQUERADE iptable_nat nf_nat bridge bnep rfcomm l2cap bluetooth ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod kvm_intel kvm snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss iTCO_wdt snd_mixer_oss iTCO_vendor_support nvidia(P) pata_acpi button ata_piix snd_pcm ppdev firewire_ohci i2c_i801 ata_generic firewire_core pcspkr dcdbas snd_timer sr_mod cdrom snd_page_alloc snd_hwdep snd tg3 serio_raw i2c_core shpchp crc_itu_t sg parport_pc soundcore parport floppy ahci 
 libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Pid: 4573, comm: fs_mark Tainted: P         2.6.25.3-18.fc9.x86_64 #1
RIP: 0010:[<ffffffff812923f0>]  [<ffffffff812923f0>] _spin_lock+0x14/0x1a
RSP: 0018:ffff81000c52de68  EFLAGS: 00000297
RAX: 0000000000001f1e RBX: ffff81000c52de68 RCX: 0000000000000016
RDX: ffff81003cd78680 RSI: 0000000000000001 RDI: ffff810015c0f8bc
RBP: ffff8100341d8f00 R08: 0000000000000000 R09: 0000000000000016
R10: 0000000012750e57 R11: 0000000000000246 R12: 0000000000000202
R13: ffff81000c52dde8 R14: 00000000000011dd R15: ffff81000c52df58
FS:  000000000159b850(0063) GS:ffffffff813f6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f593cae5000 CR3: 000000000c51f000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff8107efe4>] ? mapping_tagged+0xd/0xf
 [<ffffffff88c27fbf>] ? :btrfs:btrfs_del_ordered_inode+0x8d/0x13f
 [<ffffffff88c1e67f>] ? :btrfs:btrfs_release_file+0x9/0xd
 [<ffffffff810a5eff>] ? __fput+0xca/0x189
 [<ffffffff810a5fd2>] ? fput+0x14/0x16
 [<ffffffff810a32c8>] ? filp_close+0x66/0x71
 [<ffffffff810a336c>] ? sys_close+0x99/0xd2
 [<ffffffff8100c052>] ? tracesys+0xd5/0xda

BUG: soft lockup - CPU#3 stuck for 61s! [fs_mark:4569]
CPU 3:
Modules linked in: btrfs libcrc32c ipt_MASQUERADE iptable_nat nf_nat bridge bnep rfcomm l2cap bluetooth ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi fuse sunrpc ipt_REJECT nf_conntrack_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_multipath dm_mod kvm_intel kvm snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss iTCO_wdt snd_mixer_oss iTCO_vendor_support nvidia(P) pata_acpi button ata_piix snd_pcm ppdev firewire_ohci i2c_i801 ata_generic firewire_core pcspkr dcdbas snd_timer sr_mod cdrom snd_page_alloc snd_hwdep snd tg3 serio_raw i2c_core shpchp crc_itu_t sg parport_pc soundcore parport floppy ahci 
 libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Pid: 4569, comm: fs_mark Tainted: P         2.6.25.3-18.fc9.x86_64 #1
RIP: 0010:[<ffffffff81132929>]  [<ffffffff81132929>] __write_lock_failed+0x9/0x20
RSP: 0018:ffff81000c4fdcb0  EFLAGS: 00000206
RAX: 00000000fffffff4 RBX: ffff81000c4fdcb8 RCX: ffffffff88c282b2
RDX: 0000000000000004 RSI: 0000000000000050 RDI: ffff8100100e24f0
RBP: ffff81000c4fdc58 R08: 0000000000000021 R09: ffffffff88c1c504
R10: ffff81000c4fdcb8 R11: 00000000fffffffa R12: ffffffff88c1c58d
R13: ffff81000c4fdc48 R14: 0000000000000086 R15: ffff8100160ce420
FS:  000000000159b850(0063) GS:ffff81003f802c80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f55301940a8 CR3: 000000000c4e5000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 [<ffffffff81292408>] ? _write_lock+0x12/0x14
 [<ffffffff88c282cc>] ? :btrfs:btrfs_add_ordered_inode+0xcb/0x18f
 [<ffffffff88c1fa1f>] ? :btrfs:dirty_and_release_pages+0x21d/0x312
 [<ffffffff81079831>] ? find_or_create_page+0x51/0x79
 [<ffffffff88c2018e>] ? :btrfs:btrfs_file_write+0x67a/0x8c4
 [<ffffffff810a55bd>] ? vfs_write+0xae/0x157
 [<ffffffff810a572a>] ? sys_write+0x47/0x6f
 [<ffffffff8100c052>] ? tracesys+0xd5/0xda


--------------050200060703030300050807--
