Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout.artfiles.de ([80.252.97.80]:51639 "EHLO
	mailout.artfiles.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbaBSUFQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 15:05:16 -0500
Received: from [178.13.121.52] (helo=fuckup.localnet)
	auth=Wolfgang_Mader@brain-frog.de
	by mailout.artfiles.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80.1)
	id 1WGDOK-000622-UF
	for linux-btrfs@vger.kernel.org; Wed, 19 Feb 2014 21:05:13 +0100
From: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Read i/o errs and disk replacement
Date: Wed, 19 Feb 2014 21:05:11 +0100
Message-ID: <58035612.oaCE4E0fQb@fuckup>
In-Reply-To: <6B9DC823-92CF-4ECC-979F-C512072DF883@colorremedies.com>
References: <8051054.BLVnDBVVi7@fuckup> <116064537.O3CH7laqNI@fuckup> <6B9DC823-92CF-4ECC-979F-C512072DF883@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4582311.jlVu5n4DM9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart4582311.jlVu5n4DM9
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 18 February 2014 15:02:51 Chris Murphy wrote:
> On Feb 18, 2014, at 2:33 PM, Wolfgang Mader <Wolfgang_Mader@brain-frog.de> 
wrote:
> > Feb 18 13:14:09 deck kernel: ata2.00: failed command: READ DMA
> > Feb 18 13:14:09 deck kernel: ata2.00: cmd
> > c8/00:08:60:f2:30/00:00:00:00:00/e0 tag 0 dma 4096 in
> > 
> >                                      res
> >                                      51/04:08:60:f2:30/00:00:00:00:00/e0
> > 
> > Emask 0x1 (device error)
> > Feb 18 13:14:09 deck kernel: ata2.00: status: { DRDY ERR }
> > Feb 18 13:14:09 deck kernel: ata2.00: error: { ABRT }
> > Feb 18 13:14:09 deck kernel: ata2.15: hard resetting link
> > Feb 18 13:14:14 deck kernel: ata2.15: link is slow to respond, please be
> > patient (ready=0)
> > Feb 18 13:14:19 deck kernel: ata2.15: SRST failed (errno=-16)
> > Feb 18 13:14:19 deck kernel: ata2.15: hard resetting link
> > Feb 18 13:14:24 deck kernel: ata2.15: link is slow to respond, please be
> > patient (ready=0)
> > Feb 18 13:14:29 deck kernel: ata2.15: SATA link up 3.0 Gbps (SStatus 123
> > SControl F300)
> > Feb 18 13:14:29 deck kernel:
> > Feb 18 13:14:30 deck kernel: ata2.01: hard resetting link
> > Feb 18 13:14:31 deck kernel: ata2.02: hard resetting link
> > Feb 18 13:14:31 deck kernel: ata2.03: hard resetting link
> > Feb 18 13:14:32 deck kernel: ata2.04: hard resetting link
> > Feb 18 13:14:32 deck kernel: ata2.05: hard resetting link
> > Feb 18 13:14:33 deck kernel: ata2.06: hard resetting link
> > Feb 18 13:14:34 deck kernel: ata2.07: hard resetting link
> > Feb 18 13:14:34 deck kernel: ata2.00: configured for UDMA/133
> > Feb 18 13:14:34 deck kernel: ata2.01: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.02: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.03: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.04: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.05: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.06: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2.07: configured for UDMA/133
> > Feb 18 13:14:35 deck kernel: ata2: EH complete
> 
> Two things. The full dmesg includes useful information separate from the
> error messages, including the model drive to ata device mapping, and why
> there's a failed read to ATA2.00 yet there's a reset in sequence for
> ata2.01, 2.02, 2.03 and so on. So the entire dmesg would be useful.

You want it, you get it. I attache the full output to this mail, and hope that 
the list allows for attachements. Here is a short summary.

The hd enclosure is a Sharkoon 8-Bay which is connected via e-sata. The hds 
are mostly Segate Barracude ES.2 (ST31000NSSUN1.0T) and one from Hitachi 
(HUA7210SASUN1.0T). All of them are server grade hds and have a device time 
out of 30. The hds are sata 1.0 such that they do not feature native command 
queuing. I have generally a low read/write performance, around 10MB/sec. I 
test the enclosure with a sata 2 disk and got a way better performance, around 
70MB/sec. This is why I sticked with the Skarkoon. If the bad performance is 
due to bad configuration, I would be happy to fix it. :-)

Now to the dmesg output.
The SRST error you spotted in the logs points to wrong jumper setting 
concerning master, slave, cable select. My hds do not have a jumper for this 
setting.

The order of the hds is ata2.00->sda ata2.01->sdc etc. The port multiplier 
through which all those devices are accessed is ata2.15.

I rebooted the system two times to see if the read error count goes up. Didn't 
happen, it sits still at 2.




> 
> In any case the actual problem might not be discoverable due to the hard
> resetting. I'm not finding any useful translation, in 5 minute search, for
> SRST. But it makes me suspicious of a configuration problem, like maybe an
> unnecessary jumper setting on a drive or with the enclosure itself. So I'd
> check for that. Also, what model drives are being used? If they are
> consumer drives, they almost certainly have long error recoveries over 30
> minutes. And if the drive is trying to honor the read request for more than
> 30 seconds, the default SCSI block layer will time out and produce messages
> like what we see here. So you probably need to change the SCSI block layer
> timeout. To set the command timer to something else use:
> 
> echo <value> /sys/block/<device>/device/timeout
> 
> Where value is e.g. 121 since many consumer drives time out at 120 seconds
> this means the kernel will wait 121 seconds before starting its error
> handling (which includes resetting the drive and then the bus).
> > -------end-------
> > 
> > This output it repeated several times and than end in this read error
> > 
> > [Tue Feb 18 13:15:48 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush 0,
> > corrupt 0, gen 0
> > [Tue Feb 18 13:15:48 2014] ata2: EH complete
> > [Tue Feb 18 13:15:48 2014] btrfs read error corrected: ino 1 off
> > 29184540672 (dev /dev/sdb sector 3207776)
> 
> Well that reads like Btrfs knows what sector had a read problem, without
> corruption being the cause, and corrected it. So the question then is
> whether /dev/sdb is the same as ata2.00. If ata2.00 isn't a drive but is
> the drive enclosure then you've got a different (or additional) problem.
> 
> 
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--nextPart4582311.jlVu5n4DM9
Content-Disposition: attachment; filename="dmsgForSdb"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="dmsgForSdb"

[Tue Feb 18 12:48:13 2014] Booting Linux on physical CPU 0x0
[Tue Feb 18 12:48:13 2014] Initializing cgroup subsys cpuset
[Tue Feb 18 12:48:13 2014] Initializing cgroup subsys cpu
[Tue Feb 18 12:48:13 2014] Initializing cgroup subsys cpuacct
[Tue Feb 18 12:48:13 2014] Linux version 3.13.3-1-ARCH (nobody@root-arm=
v5-copy) (gcc version 4.8.2 20131219 (prerelease) (GCC) ) #1 PREEMPT Fr=
i Feb 14 07:05:06 MST 2014
[Tue Feb 18 12:48:13 2014] CPU: Feroceon 88FR131 [56251311] revision 1 =
(ARMv5TE), cr=3D00053977
[Tue Feb 18 12:48:13 2014] CPU: VIVT data cache, VIVT instruction cache=

[Tue Feb 18 12:48:13 2014] Machine: BUBBA3 Kirkwood based miniserver
[Tue Feb 18 12:48:13 2014] Memory policy: Data cache writeback
[Tue Feb 18 12:48:13 2014] On node 0 totalpages: 131072
[Tue Feb 18 12:48:13 2014] free_area_init_node: node 0, pgdat c0790088,=
 node_mem_map c0867000
[Tue Feb 18 12:48:13 2014]   Normal zone: 1024 pages used for memmap
[Tue Feb 18 12:48:13 2014]   Normal zone: 0 pages reserved
[Tue Feb 18 12:48:13 2014]   Normal zone: 131072 pages, LIFO batch:31
[Tue Feb 18 12:48:13 2014] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32=
768
[Tue Feb 18 12:48:13 2014] pcpu-alloc: [0] 0=20
[Tue Feb 18 12:48:13 2014] Built 1 zonelists in Zone order, mobility gr=
ouping on.  Total pages: 130048
[Tue Feb 18 12:48:13 2014] Kernel command line: root=3D/dev/sda1 consol=
e=3DttyS0,115200 serial=3D4773 key=3DMY9lUnZnipL/8TwjF/qU/X3Gzoc=3D but=
ton=3D0
[Tue Feb 18 12:48:13 2014] PID hash table entries: 2048 (order: 1, 8192=
 bytes)
[Tue Feb 18 12:48:13 2014] Dentry cache hash table entries: 65536 (orde=
r: 6, 262144 bytes)
[Tue Feb 18 12:48:13 2014] Inode-cache hash table entries: 32768 (order=
: 5, 131072 bytes)
[Tue Feb 18 12:48:13 2014] Memory: 511144K/524288K available (5487K ker=
nel code, 333K rwdata, 1660K rodata, 259K init, 828K bss, 13144K reserv=
ed)
[Tue Feb 18 12:48:13 2014] Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc0702e14   (7148 kB)
      .init : 0xc0703000 - 0xc0743c64   ( 260 kB)
      .data : 0xc0744000 - 0xc079760c   ( 334 kB)
       .bss : 0xc079760c - 0xc0866834   ( 829 kB)
[Tue Feb 18 12:48:13 2014] SLUB: HWalign=3D32, Order=3D0-3, MinObjects=3D=
0, CPUs=3D1, Nodes=3D1
[Tue Feb 18 12:48:13 2014] Preemptible hierarchical RCU implementation.=

[Tue Feb 18 12:48:13 2014] NR_IRQS:114
[Tue Feb 18 12:48:13 2014] sched_clock: 32 bits at 166MHz, resolution 6=
ns, wraps every 25769803770ns
[Tue Feb 18 12:48:13 2014] Console: colour dummy device 80x30
[Tue Feb 18 12:48:33 2014] Calibrating delay loop... 1196.85 BogoMIPS (=
lpj=3D5984256)
[Tue Feb 18 12:48:33 2014] pid_max: default: 32768 minimum: 301
[Tue Feb 18 12:48:33 2014] Security Framework initialized
[Tue Feb 18 12:48:33 2014] AppArmor: AppArmor disabled by boot time par=
ameter
[Tue Feb 18 12:48:33 2014] Mount-cache hash table entries: 512
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys devices
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys freezer
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys net_cls
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys blkio
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys bfqio
[Tue Feb 18 12:48:33 2014] Initializing cgroup subsys perf_event
[Tue Feb 18 12:48:33 2014] CPU: Testing write buffer coherency: ok
[Tue Feb 18 12:48:33 2014] Setting up static identity map for 0x538dd8 =
- 0x538e30
[Tue Feb 18 12:48:33 2014] devtmpfs: initialized
[Tue Feb 18 12:48:33 2014] pinctrl core: initialized pinctrl subsystem
[Tue Feb 18 12:48:33 2014] NET: Registered protocol family 16
[Tue Feb 18 12:48:33 2014] DMA: preallocated 256 KiB pool for atomic co=
herent allocations
[Tue Feb 18 12:48:33 2014] cpuidle: using governor ladder
[Tue Feb 18 12:48:33 2014] cpuidle: using governor menu
[Tue Feb 18 12:48:33 2014] Kirkwood: MV88F6281-A1, TCLK=3D166666667.
[Tue Feb 18 12:48:33 2014] Feroceon L2: Enabling L2
[Tue Feb 18 12:48:33 2014] Feroceon L2: Cache support initialised.
[Tue Feb 18 12:48:33 2014] initial MPP regs: 01112222 43303311 33330044=
 33003333 00000033 00000000 00000000
[Tue Feb 18 12:48:33 2014]   final MPP regs: 11112222 43303311 33330044=
 33003333 00000033 00000000 00000000
[Tue Feb 18 12:48:33 2014] Kirkwood PCIe port 0: link up
[Tue Feb 18 12:48:33 2014] Kirkwood PCIe port 1: link up
[Tue Feb 18 12:48:33 2014] PCI: bus0 uses PCIe port 0
[Tue Feb 18 12:48:33 2014] PCI host bridge to bus 0000:00
[Tue Feb 18 12:48:33 2014] pci_bus 0000:00: root bus resource [mem 0xe0=
000000-0xe7ffffff]
[Tue Feb 18 12:48:33 2014] pci_bus 0000:00: root bus resource [io  0x10=
00-0xffff]
[Tue Feb 18 12:48:33 2014] pci_bus 0000:00: No busn resource found for =
root bus, will use [bus 00-ff]
[Tue Feb 18 12:48:33 2014] pci 0000:00:00.0: [11ab:6281] type 00 class =
0x058000
[Tue Feb 18 12:48:33 2014] pci 0000:00:00.0: reg 0x10: [mem 0xd0000000-=
0xd00fffff 64bit pref]
[Tue Feb 18 12:48:33 2014] pci 0000:00:00.0: reg 0x18: [mem 0x00000000-=
0x1fffffff]
[Tue Feb 18 12:48:33 2014] pci 0000:00:00.0: supports D1 D2
[Tue Feb 18 12:48:33 2014] pci 0000:00:01.0: [168c:002a] type 00 class =
0x028000
[Tue Feb 18 12:48:33 2014] pci 0000:00:01.0: reg 0x10: [mem 0x00000000-=
0x0000ffff 64bit]
[Tue Feb 18 12:48:33 2014] pci 0000:00:01.0: supports D1
[Tue Feb 18 12:48:33 2014] pci 0000:00:01.0: PME# supported from D0 D1 =
D3hot
[Tue Feb 18 12:48:33 2014] PCI: bus0: Fast back to back transfers disab=
led
[Tue Feb 18 12:48:33 2014] pci_bus 0000:00: busn_res: [bus 00-ff] end i=
s updated to 00
[Tue Feb 18 12:48:33 2014] PCI: bus1 uses PCIe port 1
[Tue Feb 18 12:48:33 2014] PCI host bridge to bus 0000:01
[Tue Feb 18 12:48:33 2014] pci_bus 0000:01: root bus resource [mem 0xe8=
000000-0xefffffff]
[Tue Feb 18 12:48:33 2014] pci_bus 0000:01: root bus resource [io  0x10=
000-0x1ffff]
[Tue Feb 18 12:48:33 2014] pci_bus 0000:01: No busn resource found for =
root bus, will use [bus 01-ff]
[Tue Feb 18 12:48:33 2014] PCI: bus1: Fast back to back transfers enabl=
ed
[Tue Feb 18 12:48:33 2014] pci_bus 0000:01: busn_res: [bus 01-ff] end i=
s updated to 01
[Tue Feb 18 12:48:33 2014] pci 0000:00:01.0: BAR 0: assigned [mem 0xe00=
00000-0xe000ffff 64bit]
[Tue Feb 18 12:48:33 2014] bio: create slab <bio-0> at 0
[Tue Feb 18 12:48:33 2014] vgaarb: loaded
[Tue Feb 18 12:48:33 2014] SCSI subsystem initialized
[Tue Feb 18 12:48:33 2014] libata version 3.00 loaded.
[Tue Feb 18 12:48:33 2014] usbcore: registered new interface driver usb=
fs
[Tue Feb 18 12:48:33 2014] usbcore: registered new interface driver hub=

[Tue Feb 18 12:48:33 2014] usbcore: registered new device driver usb
[Tue Feb 18 12:48:33 2014] pps_core: LinuxPPS API ver. 1 registered
[Tue Feb 18 12:48:33 2014] pps_core: Software ver. 5.3.6 - Copyright 20=
05-2007 Rodolfo Giometti <giometti@linux.it>
[Tue Feb 18 12:48:33 2014] PTP clock support registered
[Tue Feb 18 12:48:33 2014] Switched to clocksource orion_clocksource
[Tue Feb 18 12:48:33 2014] FS-Cache: Loaded
[Tue Feb 18 12:48:33 2014] NET: Registered protocol family 2
[Tue Feb 18 12:48:33 2014] TCP established hash table entries: 4096 (or=
der: 2, 16384 bytes)
[Tue Feb 18 12:48:33 2014] TCP bind hash table entries: 4096 (order: 2,=
 16384 bytes)
[Tue Feb 18 12:48:33 2014] TCP: Hash tables configured (established 409=
6 bind 4096)
[Tue Feb 18 12:48:33 2014] TCP: reno registered
[Tue Feb 18 12:48:33 2014] UDP hash table entries: 256 (order: 0, 4096 =
bytes)
[Tue Feb 18 12:48:33 2014] UDP-Lite hash table entries: 256 (order: 0, =
4096 bytes)
[Tue Feb 18 12:48:33 2014] NET: Registered protocol family 1
[Tue Feb 18 12:48:33 2014] PCI: CLS 32 bytes, default 32
[Tue Feb 18 12:48:33 2014] BUBBA3: driver ver 0.1 (build Feb 14 2014 06=
:49:19) loaded
[Tue Feb 18 12:48:33 2014] audit: initializing netlink socket (disabled=
)
[Tue Feb 18 12:48:33 2014] type=3D2000 audit(0.120:1): initialized
[Tue Feb 18 12:48:34 2014] VFS: Disk quotas dquot_6.5.2
[Tue Feb 18 12:48:34 2014] Dquot-cache hash table entries: 1024 (order =
0, 4096 bytes)
[Tue Feb 18 12:48:34 2014] jffs2: version 2.2. (NAND) =C2=A9 2001-2006 =
Red Hat, Inc.
[Tue Feb 18 12:48:34 2014] aufs 3.13-20140127
[Tue Feb 18 12:48:34 2014] msgmni has been set to 998
[Tue Feb 18 12:48:34 2014] Block layer SCSI generic (bsg) driver versio=
n 0.4 loaded (major 250)
[Tue Feb 18 12:48:34 2014] io scheduler noop registered
[Tue Feb 18 12:48:34 2014] io scheduler deadline registered
[Tue Feb 18 12:48:34 2014] io scheduler cfq registered
[Tue Feb 18 12:48:34 2014] io scheduler bfq registered (default)
[Tue Feb 18 12:48:34 2014] BFQ I/O-scheduler version: v7r1
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.0: Marvell shared XOR driver
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.1: Marvell shared XOR driver
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.1: Marvell XOR: ( xor cpy )
[Tue Feb 18 12:48:34 2014] mv_xor mv_xor.1: Marvell XOR: ( xor cpy )
[Tue Feb 18 12:48:34 2014] Serial: 8250/16550 driver, 2 ports, IRQ shar=
ing disabled
[Tue Feb 18 12:48:34 2014] serial8250.0: ttyS0 at MMIO 0xf1012000 (irq =
=3D 33, base_baud =3D 10416666) is a 16550A
[Tue Feb 18 12:48:34 2014] console [ttyS0] enabled
[Tue Feb 18 12:48:34 2014] brd: module loaded
[Tue Feb 18 12:48:34 2014] loop: module loaded
[Tue Feb 18 12:48:34 2014] sata_mv sata_mv.0: version 1.28
[Tue Feb 18 12:48:34 2014] sata_mv sata_mv.0: cannot get optional clkde=
v
[Tue Feb 18 12:48:34 2014] sata_mv sata_mv.0: slots 32 ports 2
[Tue Feb 18 12:48:34 2014] scsi0 : sata_mv
[Tue Feb 18 12:48:34 2014] scsi1 : sata_mv
[Tue Feb 18 12:48:34 2014] ata1: SATA max UDMA/133 irq 21
[Tue Feb 18 12:48:34 2014] ata2: SATA max UDMA/133 irq 21
[Tue Feb 18 12:48:34 2014] m25p80 spi0.0: m25p16 (2048 Kbytes)
[Tue Feb 18 12:48:34 2014] Creating 3 MTD partitions on "spi_flash":
[Tue Feb 18 12:48:34 2014] 0x000000000000-0x0000000c0000 : "u-boot"
[Tue Feb 18 12:48:34 2014] 0x0000000c0000-0x0000000e0000 : "env"
[Tue Feb 18 12:48:34 2014] 0x0000000e0000-0x000000200000 : "data"
[Tue Feb 18 12:48:34 2014] libphy: orion_mdio_bus: probed
[Tue Feb 18 12:48:34 2014] mv643xx_eth: MV-643xx 10/100/1000 ethernet d=
river version 1.4
[Tue Feb 18 12:48:35 2014] ata1: SATA link up 3.0 Gbps (SStatus 123 SCo=
ntrol F300)
[Tue Feb 18 12:48:35 2014] ata1.00: ATA-8: SEAGATE ST31000NSSUN1.0T 093=
454YYGN,     SU0D, max UDMA/133
[Tue Feb 18 12:48:35 2014] ata1.00: 1953525168 sectors, multi 0: LBA48 =
NCQ (depth 31/32)
[Tue Feb 18 12:48:35 2014] ata1.00: configured for UDMA/133
[Tue Feb 18 12:48:35 2014] scsi 0:0:0:0: Direct-Access     ATA      SEA=
GATE ST31000N n/a  PQ: 0 ANSI: 5
[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: [sda] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: [sda] Write Protect is off
[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: Attached scsi generic sg0 type 0=

[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: [sda] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:35 2014]  sda: sda1 sda2 sda3
[Tue Feb 18 12:48:35 2014] sd 0:0:0:0: [sda] Attached SCSI disk
[Tue Feb 18 12:48:35 2014] mv643xx_eth_port mv643xx_eth_port.0 eth0: po=
rt 0 with MAC address 00:00:00:00:00:00
[Tue Feb 18 12:48:36 2014] ata2: SATA link up 3.0 Gbps (SStatus 123 SCo=
ntrol F300)
[Tue Feb 18 12:48:36 2014] ata2.15: Port Multiplier 1.2, 0x197b:0x321f =
r0, 8 ports, feat 0x5/0xf
[Tue Feb 18 12:48:36 2014] ata2.00: hard resetting link
[Tue Feb 18 12:48:37 2014] mv643xx_eth_port mv643xx_eth_port.1 eth1: po=
rt 0 with MAC address 00:00:00:00:00:00
[Tue Feb 18 12:48:37 2014] ehci_hcd: USB 2.0 'Enhanced' Host Controller=
 (EHCI) Driver
[Tue Feb 18 12:48:37 2014] ehci-pci: EHCI PCI platform driver
[Tue Feb 18 12:48:37 2014] ehci-orion: EHCI orion driver
[Tue Feb 18 12:48:37 2014] orion-ehci orion-ehci.0: EHCI Host Controlle=
r
[Tue Feb 18 12:48:37 2014] orion-ehci orion-ehci.0: new USB bus registe=
red, assigned bus number 1
[Tue Feb 18 12:48:37 2014] orion-ehci orion-ehci.0: irq 19, io mem 0xf1=
050000
[Tue Feb 18 12:48:37 2014] orion-ehci orion-ehci.0: USB 2.0 started, EH=
CI 1.00
[Tue Feb 18 12:48:37 2014] hub 1-0:1.0: USB hub found
[Tue Feb 18 12:48:37 2014] hub 1-0:1.0: 1 port detected
[Tue Feb 18 12:48:37 2014] usbcore: registered new interface driver usb=
-storage
[Tue Feb 18 12:48:37 2014] mousedev: PS/2 mouse device common for all m=
ice
[Tue Feb 18 12:48:37 2014] rtc-mv rtc-mv: rtc core: registered rtc-mv a=
s rtc0
[Tue Feb 18 12:48:37 2014] i2c /dev entries driver
[Tue Feb 18 12:48:37 2014] orion_wdt: Initial timeout 25 sec
[Tue Feb 18 12:48:37 2014] sdhci: Secure Digital Host Controller Interf=
ace driver
[Tue Feb 18 12:48:37 2014] sdhci: Copyright(c) Pierre Ossman
[Tue Feb 18 12:48:37 2014] sdhci-pltfm: SDHCI platform and OF driver he=
lper
[Tue Feb 18 12:48:37 2014] ledtrig-cpu: registered to indicate activity=
 on CPUs
[Tue Feb 18 12:48:37 2014] usbcore: registered new interface driver r87=
12u
[Tue Feb 18 12:48:37 2014] gre: GRE over IPv4 demultiplexor driver
[Tue Feb 18 12:48:37 2014] TCP: cubic registered
[Tue Feb 18 12:48:37 2014] NET: Registered protocol family 17
[Tue Feb 18 12:48:37 2014] Key type dns_resolver registered
[Tue Feb 18 12:48:37 2014] registered taskstats version 1
[Tue Feb 18 12:48:37 2014] usb 1-1: new high-speed USB device number 2 =
using orion-ehci
[Tue Feb 18 12:48:37 2014] ata2.01: hard resetting link
[Tue Feb 18 12:48:37 2014] hub 1-1:1.0: USB hub found
[Tue Feb 18 12:48:37 2014] hub 1-1:1.0: 4 ports detected
[Tue Feb 18 12:48:38 2014] ata2.02: hard resetting link
[Tue Feb 18 12:48:38 2014] ata2.03: hard resetting link
[Tue Feb 18 12:48:39 2014] ata2.04: hard resetting link
[Tue Feb 18 12:48:40 2014] ata2.05: hard resetting link
[Tue Feb 18 12:48:40 2014] UKSM: relative memcmp_cost =3D 2467 hash=3D2=
34621611 cmp_ret=3D0.
[Tue Feb 18 12:48:40 2014] console [netcon0] enabled
[Tue Feb 18 12:48:40 2014] netconsole: network logging started
[Tue Feb 18 12:48:40 2014] input: gpio-keys as /devices/platform/gpio-k=
eys/input/input0
[Tue Feb 18 12:48:40 2014] rtc-mv rtc-mv: setting system clock to 2014-=
02-18 11:48:27 UTC (1392724107)
[Tue Feb 18 12:48:40 2014] ata2.06: hard resetting link
[Tue Feb 18 12:48:41 2014] ata2.07: hard resetting link
[Tue Feb 18 12:48:42 2014] ata2.00: ATA-7: SEAGATE ST31000NSSUN1.0T 093=
454YY4D, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.00: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.01: ATA-7: SEAGATE ST31000NSSUN1.0T 093=
454YY7W, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.01: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.02: ATA-7: SEAGATE ST31000NSSUN1.0T 093=
454YZPT, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.02: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.03: ATA-7: HITACHI HUA7210SASUN1.0T 090=
2GB0XRE, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.03: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.04: ATA-7: SEAGATE ST31000NSSUN1.0T 093=
454Z0BT, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.04: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.05: ATA-7: SEAGATE ST31000NSSUN1.0T 091=
653MEY4, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.05: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.06: ATA-7: SEAGATE ST31000NSSUN1.0T 093=
354SA5R, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.06: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.07: ATA-7: SEAGATE ST31000NSSUN1.0T 090=
9536218, 0958, max UDMA/133
[Tue Feb 18 12:48:42 2014] ata2.07: 1953525168 sectors, multi 1: LBA48=20=

[Tue Feb 18 12:48:42 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 12:48:42 2014] ata2: EH complete
[Tue Feb 18 12:48:42 2014] scsi 1:0:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: [sdb] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: Attached scsi generic sg1 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: [sdb] Write Protect is off
[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:42 2014] scsi 1:1:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: [sdb] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: [sdc] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: Attached scsi generic sg2 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: [sdc] Write Protect is off
[Tue Feb 18 12:48:42 2014] scsi 1:2:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014]  sdb: unknown partition table
[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: [sdc] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: [sdc] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:42 2014] sd 1:0:0:0: [sdb] Attached SCSI disk
[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: [sdd] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: Attached scsi generic sg3 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: [sdd] Write Protect is off
[Tue Feb 18 12:48:42 2014] scsi 1:3:0:0: Direct-Access     ATA      HIT=
ACHI HUA7210S 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: [sdd] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: [sdd] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:42 2014] sd 1:3:0:0: [sde] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014]  sdc: unknown partition table
[Tue Feb 18 12:48:42 2014] sd 1:3:0:0: Attached scsi generic sg4 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:1:0:0: [sdc] Attached SCSI disk
[Tue Feb 18 12:48:42 2014] sd 1:3:0:0: [sde] Write Protect is off
[Tue Feb 18 12:48:42 2014] sd 1:3:0:0: [sde] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:42 2014] scsi 1:4:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014]  sdd: unknown partition table
[Tue Feb 18 12:48:42 2014] sd 1:3:0:0: [sde] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:42 2014] sd 1:2:0:0: [sdd] Attached SCSI disk
[Tue Feb 18 12:48:42 2014] sd 1:4:0:0: [sdf] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014] sd 1:4:0:0: Attached scsi generic sg5 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:4:0:0: [sdf] Write Protect is off
[Tue Feb 18 12:48:42 2014] sd 1:4:0:0: [sdf] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:42 2014] scsi 1:5:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:42 2014] sd 1:4:0:0: [sdf] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:42 2014] sd 1:5:0:0: [sdg] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:42 2014] sd 1:5:0:0: Attached scsi generic sg6 type 0=

[Tue Feb 18 12:48:42 2014] sd 1:5:0:0: [sdg] Write Protect is off
[Tue Feb 18 12:48:42 2014] sd 1:5:0:0: [sdg] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:43 2014]  sdf: unknown partition table
[Tue Feb 18 12:48:43 2014] scsi 1:6:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:43 2014] sd 1:5:0:0: [sdg] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:43 2014]  sde: sde1
[Tue Feb 18 12:48:43 2014] sd 1:4:0:0: [sdf] Attached SCSI disk
[Tue Feb 18 12:48:43 2014] sd 1:3:0:0: [sde] Attached SCSI disk
[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: [sdh] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: Attached scsi generic sg7 type 0=

[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: [sdh] Write Protect is off
[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: [sdh] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:43 2014] scsi 1:7:0:0: Direct-Access     ATA      SEA=
GATE ST31000N 0958 PQ: 0 ANSI: 5
[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: [sdh] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: [sdi] 1953525168 512-byte logica=
l blocks: (1.00 TB/931 GiB)
[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: Attached scsi generic sg8 type 0=

[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: [sdi] Write Protect is off
[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: [sdi] Mode Sense: 00 3a 00 00
[Tue Feb 18 12:48:43 2014]  sdg: unknown partition table
[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: [sdi] Write cache: disabled, rea=
d cache: enabled, doesn't support DPO or FUA
[Tue Feb 18 12:48:43 2014] sd 1:5:0:0: [sdg] Attached SCSI disk
[Tue Feb 18 12:48:43 2014]  sdh: sdh1
[Tue Feb 18 12:48:43 2014] sd 1:6:0:0: [sdh] Attached SCSI disk
[Tue Feb 18 12:48:43 2014]  sdi: sdi1
[Tue Feb 18 12:48:43 2014] sd 1:7:0:0: [sdi] Attached SCSI disk
[Tue Feb 18 12:48:43 2014] kjournald starting.  Commit interval 5 secon=
ds
[Tue Feb 18 12:48:43 2014] EXT3-fs (sda1): using internal journal
[Tue Feb 18 12:48:43 2014] EXT3-fs (sda1): mounted filesystem with writ=
eback data mode
[Tue Feb 18 12:48:43 2014] VFS: Mounted root (ext3 filesystem) on devic=
e 8:1.
[Tue Feb 18 12:48:43 2014] devtmpfs: mounted
[Tue Feb 18 12:48:43 2014] Freeing unused kernel memory: 256K (c0703000=
 - c0743000)
[Tue Feb 18 12:48:43 2014] systemd[1]: systemd 208 running in system mo=
de. (+PAM -LIBWRAP -AUDIT -SELINUX -IMA -SYSVINIT +LIBCRYPTSETUP +GCRYP=
T +ACL +XZ)
[Tue Feb 18 12:48:44 2014] systemd[1]: Inserted module 'autofs4'
[Tue Feb 18 12:48:44 2014] NET: Registered protocol family 10
[Tue Feb 18 12:48:44 2014] systemd[1]: Inserted module 'ipv6'
[Tue Feb 18 12:48:44 2014] systemd[1]: Set hostname to <deck>.
[Tue Feb 18 12:48:44 2014] random: systemd urandom read with 121 bits o=
f entropy available
[Tue Feb 18 12:48:44 2014] random: nonblocking pool is initialized
[Tue Feb 18 12:48:44 2014] systemd[1]: Cannot add dependency job for un=
it cups.socket, ignoring: Unit cups.socket failed to load: No such file=
 or directory.
[Tue Feb 18 12:48:44 2014] systemd[1]: Cannot add dependency job for un=
it cups.path, ignoring: Unit cups.path failed to load: No such file or =
directory.
[Tue Feb 18 12:48:44 2014] systemd[1]: Cannot add dependency job for un=
it display-manager.service, ignoring: Unit display-manager.service fail=
ed to load: No such file or directory.
[Tue Feb 18 12:48:44 2014] systemd[1]: Starting Forward Password Reques=
ts to Wall Directory Watch.
[Tue Feb 18 12:48:44 2014] systemd[1]: Started Forward Password Request=
s to Wall Directory Watch.
[Tue Feb 18 12:48:44 2014] systemd[1]: Expecting device dev-ttyS0.devic=
e...
[Tue Feb 18 12:48:44 2014] systemd[1]: Expecting device sys-subsystem-n=
et-devices-eth0.device...
[Tue Feb 18 12:48:44 2014] systemd[1]: Starting Remote File Systems.
[Tue Feb 18 12:48:44 2014] systemd[1]: Reached target Remote File Syste=
ms.
[Tue Feb 18 12:48:44 2014] systemd[1]: Starting Delayed Shutdown Socket=
.
[Tue Feb 18 12:48:44 2014] systemd[1]: Listening on Delayed Shutdown So=
cket.
[Tue Feb 18 12:48:44 2014] systemd[1]: Starting Device-mapper event dae=
mon FIFOs.
[Tue Feb 18 12:48:44 2014] systemd[1]: Listening on Device-mapper event=
 daemon FIFOs.
[Tue Feb 18 12:48:44 2014] systemd[1]: Starting /dev/initctl Compatibil=
ity Named Pipe.
[Tue Feb 18 12:48:44 2014] systemd[1]: Listening on /dev/initctl Compat=
ibility Named Pipe.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Encrypted Volumes.
[Tue Feb 18 12:48:45 2014] systemd[1]: Reached target Encrypted Volumes=
.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Arbitrary Executable Fi=
le Formats File System Automount Point.
[Tue Feb 18 12:48:45 2014] systemd[1]: Set up automount Arbitrary Execu=
table File Formats File System Automount Point.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting udev Kernel Socket.
[Tue Feb 18 12:48:45 2014] systemd[1]: Listening on udev Kernel Socket.=

[Tue Feb 18 12:48:45 2014] systemd[1]: Starting udev Control Socket.
[Tue Feb 18 12:48:45 2014] systemd[1]: Listening on udev Control Socket=
.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Dispatch Password Reque=
sts to Console Directory Watch.
[Tue Feb 18 12:48:45 2014] systemd[1]: Started Dispatch Password Reques=
ts to Console Directory Watch.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Paths.
[Tue Feb 18 12:48:45 2014] systemd[1]: Reached target Paths.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Journal Socket.
[Tue Feb 18 12:48:45 2014] systemd[1]: Listening on Journal Socket.
[Tue Feb 18 12:48:45 2014] systemd[1]: Mounted Huge Pages File System.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Load Kernel Modules...
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting udev Coldplug all Devic=
es...
[Tue Feb 18 12:48:45 2014] systemd[1]: Mounting POSIX Message Queue Fil=
e System...
[Tue Feb 18 12:48:45 2014] RPC: Registered named UNIX socket transport =
module.
[Tue Feb 18 12:48:45 2014] RPC: Registered udp transport module.
[Tue Feb 18 12:48:45 2014] RPC: Registered tcp transport module.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Apply Kernel Variables.=
..
[Tue Feb 18 12:48:45 2014] RPC: Registered tcp NFSv4.1 backchannel tran=
sport module.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Create list of required=
 static device nodes for the current kernel...
[Tue Feb 18 12:48:45 2014] systemd[1]: Mounting Debug File System...
[Tue Feb 18 12:48:45 2014] systemd[1]: Started Set Up Additional Binary=
 Formats.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Setup Virtual Console..=
.
[Tue Feb 18 12:48:45 2014] systemd[1]: Starting Journal Service...
[Tue Feb 18 12:48:45 2014] systemd[1]: Started Journal Service.
[Tue Feb 18 12:48:45 2014] FS-Cache: Netfs 'nfs' registered for caching=

[Tue Feb 18 12:48:45 2014] systemd-journald[70]: Vacuuming done, freed =
0 bytes
[Tue Feb 18 12:48:46 2014] systemd-udevd[94]: starting version 208
[Tue Feb 18 12:48:47 2014] cfg80211: Calling CRDA to update world regul=
atory domain
[Tue Feb 18 12:48:47 2014] PCI: enabling device 0000:00:01.0 (0140 -> 0=
142)
[Tue Feb 18 12:48:48 2014] raid6: int32x1     87 MB/s
[Tue Feb 18 12:48:48 2014] raid6: int32x2    133 MB/s
[Tue Feb 18 12:48:48 2014] raid6: int32x4    161 MB/s
[Tue Feb 18 12:48:49 2014] raid6: int32x8    169 MB/s
[Tue Feb 18 12:48:49 2014] raid6: using algorithm int32x8 (169 MB/s)
[Tue Feb 18 12:48:49 2014] raid6: using intx1 recovery algorithm
[Tue Feb 18 12:48:49 2014] xor: measuring software checksum speed
[Tue Feb 18 12:48:49 2014] systemd-journald[70]: Received request to fl=
ush runtime journal from PID 1
[Tue Feb 18 12:48:49 2014]    arm4regs  :  1090.400 MB/sec
[Tue Feb 18 12:48:49 2014]    8regs     :   774.800 MB/sec
[Tue Feb 18 12:48:49 2014]    32regs    :   825.600 MB/sec
[Tue Feb 18 12:48:49 2014] xor: using function: arm4regs (1090.400 MB/s=
ec)
[Tue Feb 18 12:48:49 2014] ath: EEPROM regdomain: 0x60
[Tue Feb 18 12:48:49 2014] ath: EEPROM indicates we should expect a dir=
ect regpair map
[Tue Feb 18 12:48:49 2014] ath: Country alpha2 being used: 00
[Tue Feb 18 12:48:49 2014] ath: Regpair used: 0x60
[Tue Feb 18 12:48:49 2014] ieee80211 phy0: Selected rate control algori=
thm 'minstrel_ht'
[Tue Feb 18 12:48:49 2014] ieee80211 phy0: Atheros AR9280 Rev:2 mem=3D0=
xe0da0000, irq=3D9
[Tue Feb 18 12:48:55 2014] bio: create slab <bio-1> at 1
[Tue Feb 18 12:48:56 2014] Btrfs loaded
[Tue Feb 18 12:48:56 2014] btrfs: device label storage devid 1 transid =
2053 /dev/sda3
[Tue Feb 18 12:48:56 2014] btrfs: device label dataPool devid 2 transid=
 9099 /dev/sdc
[Tue Feb 18 12:48:56 2014] btrfs: device label dataPool devid 5 transid=
 9099 /dev/sdg
[Tue Feb 18 12:48:56 2014] btrfs: device label dataPool devid 4 transid=
 9099 /dev/sdf
[Tue Feb 18 12:48:56 2014] btrfs: device label dataPool devid 1 transid=
 9099 /dev/sdb
[Tue Feb 18 12:48:56 2014] btrfs: device label home devid 1 transid 888=
 /dev/sda2
[Tue Feb 18 12:48:56 2014] btrfs: device label dataPool devid 3 transid=
 9099 /dev/sdd
[Tue Feb 18 12:48:56 2014] md: bind<sde1>
[Tue Feb 18 12:48:56 2014] md: bind<sdh1>
[Tue Feb 18 12:48:56 2014] md: bind<sdi1>
[Tue Feb 18 12:48:57 2014] async_tx: api initialized (async)
[Tue Feb 18 12:48:57 2014] md: raid6 personality registered for level 6=

[Tue Feb 18 12:48:57 2014] md: raid5 personality registered for level 5=

[Tue Feb 18 12:48:57 2014] md: raid4 personality registered for level 4=

[Tue Feb 18 12:48:57 2014] md/raid:md0: device sdi1 operational as raid=
 disk 2
[Tue Feb 18 12:48:57 2014] md/raid:md0: device sdh1 operational as raid=
 disk 1
[Tue Feb 18 12:48:57 2014] md/raid:md0: device sde1 operational as raid=
 disk 0
[Tue Feb 18 12:48:57 2014] md/raid:md0: allocated 0kB
[Tue Feb 18 12:48:57 2014] md/raid:md0: raid level 5 active with 3 out =
of 3 devices, algorithm 2
[Tue Feb 18 12:48:57 2014] RAID conf printout:
[Tue Feb 18 12:48:57 2014]  --- level:5 rd:3 wd:3
[Tue Feb 18 12:48:57 2014]  disk 0, o:1, dev:sde1
[Tue Feb 18 12:48:57 2014]  disk 1, o:1, dev:sdh1
[Tue Feb 18 12:48:57 2014]  disk 2, o:1, dev:sdi1
[Tue Feb 18 12:48:57 2014] created bitmap (8 pages) for device md0
[Tue Feb 18 12:48:57 2014] md0: bitmap initialized from disk: read 1 pa=
ges, set 0 of 14901 bits
[Tue Feb 18 12:48:57 2014] md0: detected capacity change from 0 to 1999=
929081856
[Tue Feb 18 12:48:57 2014]  md0: unknown partition table
[Tue Feb 18 12:48:57 2014] systemd-udevd[103]: renamed network interfac=
e wlan0 to wlp0s1
[Tue Feb 18 12:49:43 2014] mv643xx_eth_port mv643xx_eth_port.0 eth0: li=
nk down
[Tue Feb 18 12:49:43 2014] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not=
 ready
[Tue Feb 18 12:49:45 2014] mv643xx_eth_port mv643xx_eth_port.0 eth0: li=
nk up, 100 Mb/s, full duplex, flow control disabled
[Tue Feb 18 12:49:45 2014] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link be=
comes ready
[Tue Feb 18 13:01:31 2014] btrfs: device label dataPool devid 3 transid=
 9099 /dev/sdd
[Tue Feb 18 13:02:08 2014] btrfs: use lzo compression
[Tue Feb 18 13:02:08 2014] btrfs: disk space caching is enabled
[Tue Feb 18 13:02:09 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 1, flush=
 0, corrupt 0, gen 0
[Tue Feb 18 13:13:37 2014] btrfs: device label dataPool devid 3 transid=
 9103 /dev/sdd
[Tue Feb 18 13:14:29 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:14:29 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:14:29 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:14:29 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:14:29 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:14:29 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:14:29 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:14:29 2014] ata2.15: hard resetting link
[Tue Feb 18 13:14:34 2014] ata2.15: link is slow to respond, please be =
patient (ready=3D0)
[Tue Feb 18 13:14:39 2014] ata2.15: SRST failed (errno=3D-16)
[Tue Feb 18 13:14:39 2014] ata2.15: hard resetting link
[Tue Feb 18 13:14:44 2014] ata2.15: link is slow to respond, please be =
patient (ready=3D0)
[Tue Feb 18 13:14:49 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:14:49 2014] ata2.00: hard resetting link
[Tue Feb 18 13:14:50 2014] ata2.01: hard resetting link
[Tue Feb 18 13:14:50 2014] ata2.02: hard resetting link
[Tue Feb 18 13:14:51 2014] ata2.03: hard resetting link
[Tue Feb 18 13:14:52 2014] ata2.04: hard resetting link
[Tue Feb 18 13:14:52 2014] ata2.05: hard resetting link
[Tue Feb 18 13:14:53 2014] ata2.06: hard resetting link
[Tue Feb 18 13:14:54 2014] ata2.07: hard resetting link
[Tue Feb 18 13:14:54 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:14:54 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:14:54 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:14:54 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:14:54 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:14:55 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:14:55 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:14:55 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:14:55 2014] ata2: EH complete
[Tue Feb 18 13:14:58 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:14:58 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:14:58 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:14:58 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:14:58 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:14:58 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:14:58 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:14:58 2014] ata2.15: hard resetting link
[Tue Feb 18 13:14:59 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:14:59 2014] ata2.00: hard resetting link
[Tue Feb 18 13:15:00 2014] ata2.01: hard resetting link
[Tue Feb 18 13:15:01 2014] ata2.02: hard resetting link
[Tue Feb 18 13:15:01 2014] ata2.03: hard resetting link
[Tue Feb 18 13:15:02 2014] ata2.04: hard resetting link
[Tue Feb 18 13:15:02 2014] ata2.05: hard resetting link
[Tue Feb 18 13:15:03 2014] ata2.06: hard resetting link
[Tue Feb 18 13:15:04 2014] ata2.07: hard resetting link
[Tue Feb 18 13:15:05 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:15:05 2014] ata2: EH complete
[Tue Feb 18 13:15:09 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:15:09 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:15:09 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:15:09 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:15:09 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:15:09 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:15:09 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:15:09 2014] ata2.15: hard resetting link
[Tue Feb 18 13:15:10 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:15:10 2014] ata2.00: hard resetting link
[Tue Feb 18 13:15:11 2014] ata2.01: hard resetting link
[Tue Feb 18 13:15:11 2014] ata2.02: hard resetting link
[Tue Feb 18 13:15:12 2014] ata2.03: hard resetting link
[Tue Feb 18 13:15:12 2014] ata2.04: hard resetting link
[Tue Feb 18 13:15:13 2014] ata2.05: hard resetting link
[Tue Feb 18 13:15:14 2014] ata2.06: hard resetting link
[Tue Feb 18 13:15:15 2014] ata2.07: hard resetting link
[Tue Feb 18 13:15:16 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:15:16 2014] ata2: EH complete
[Tue Feb 18 13:15:19 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:15:19 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:15:19 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:15:19 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:15:19 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:15:19 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:15:19 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:15:19 2014] ata2.15: hard resetting link
[Tue Feb 18 13:15:20 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:15:20 2014] ata2.00: hard resetting link
[Tue Feb 18 13:15:21 2014] ata2.01: hard resetting link
[Tue Feb 18 13:15:22 2014] ata2.02: hard resetting link
[Tue Feb 18 13:15:23 2014] ata2.03: hard resetting link
[Tue Feb 18 13:15:23 2014] ata2.04: hard resetting link
[Tue Feb 18 13:15:24 2014] ata2.05: hard resetting link
[Tue Feb 18 13:15:25 2014] ata2.06: hard resetting link
[Tue Feb 18 13:15:25 2014] ata2.07: hard resetting link
[Tue Feb 18 13:15:26 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:15:26 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:15:26 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:15:26 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:15:27 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:15:27 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:15:27 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:15:27 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:15:27 2014] ata2: EH complete
[Tue Feb 18 13:15:30 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:15:30 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:15:30 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:15:30 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:15:30 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:15:30 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:15:30 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:15:30 2014] ata2.15: hard resetting link
[Tue Feb 18 13:15:31 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:15:31 2014] ata2.00: hard resetting link
[Tue Feb 18 13:15:32 2014] ata2.01: hard resetting link
[Tue Feb 18 13:15:33 2014] ata2.02: hard resetting link
[Tue Feb 18 13:15:33 2014] ata2.03: hard resetting link
[Tue Feb 18 13:15:34 2014] ata2.04: hard resetting link
[Tue Feb 18 13:15:34 2014] ata2.05: hard resetting link
[Tue Feb 18 13:15:35 2014] ata2.06: hard resetting link
[Tue Feb 18 13:15:36 2014] ata2.07: hard resetting link
[Tue Feb 18 13:15:37 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:15:37 2014] ata2: EH complete
[Tue Feb 18 13:15:40 2014] ata2.15: exception Emask 0x1 SAct 0x0 SErr 0=
x0 action 0x6
[Tue Feb 18 13:15:40 2014] ata2.15: edma_err_cause=3D00000084 pp_flags=3D=
00000001, dev error, EDMA self-disable
[Tue Feb 18 13:15:40 2014] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0=
x0 action 0x0
[Tue Feb 18 13:15:40 2014] ata2.00: failed command: READ DMA
[Tue Feb 18 13:15:40 2014] ata2.00: cmd c8/00:08:60:f2:30/00:00:00:00:0=
0/e0 tag 0 dma 4096 in
         res 51/04:08:60:f2:30/00:00:00:00:00/e0 Emask 0x1 (device erro=
r)
[Tue Feb 18 13:15:41 2014] ata2.00: status: { DRDY ERR }
[Tue Feb 18 13:15:41 2014] ata2.00: error: { ABRT }
[Tue Feb 18 13:15:41 2014] ata2.15: hard resetting link
[Tue Feb 18 13:15:42 2014] ata2.15: SATA link up 3.0 Gbps (SStatus 123 =
SControl F300)
[Tue Feb 18 13:15:42 2014] ata2.00: hard resetting link
[Tue Feb 18 13:15:42 2014] ata2.01: hard resetting link
[Tue Feb 18 13:15:43 2014] ata2.02: hard resetting link
[Tue Feb 18 13:15:44 2014] ata2.03: hard resetting link
[Tue Feb 18 13:15:44 2014] ata2.04: hard resetting link
[Tue Feb 18 13:15:45 2014] ata2.05: hard resetting link
[Tue Feb 18 13:15:46 2014] ata2.06: hard resetting link
[Tue Feb 18 13:15:47 2014] ata2.07: hard resetting link
[Tue Feb 18 13:15:48 2014] ata2.00: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.01: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.02: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.03: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.04: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.05: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.06: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] ata2.07: configured for UDMA/133
[Tue Feb 18 13:15:48 2014] sd 1:0:0:0: [sdb] =20
[Tue Feb 18 13:15:48 2014] Result: hostbyte=3D0x00 driverbyte=3D0x08
[Tue Feb 18 13:15:48 2014] sd 1:0:0:0: [sdb] =20
[Tue Feb 18 13:15:48 2014] Sense Key : 0xb [current] [descriptor]
[Tue Feb 18 13:15:48 2014] Descriptor sense data with sense descriptors=
 (in hex):
[Tue Feb 18 13:15:48 2014]         72 0b 00 00 00 00 00 0c 00 0a 80 00 =
00 00 00 00=20
[Tue Feb 18 13:15:48 2014]         00 30 f2 60=20
[Tue Feb 18 13:15:48 2014] sd 1:0:0:0: [sdb] =20
[Tue Feb 18 13:15:48 2014] ASC=3D0x0 ASCQ=3D0x0
[Tue Feb 18 13:15:48 2014] sd 1:0:0:0: [sdb] CDB:=20
[Tue Feb 18 13:15:48 2014] cdb[0]=3D0x28: 28 00 00 30 f2 60 00 00 08 00=

[Tue Feb 18 13:15:48 2014] end_request: I/O error, dev sdb, sector 3207=
776
[Tue Feb 18 13:15:48 2014] btrfs: bdev /dev/sdb errs: wr 0, rd 2, flush=
 0, corrupt 0, gen 0
[Tue Feb 18 13:15:48 2014] ata2: EH complete
[Tue Feb 18 13:15:48 2014] btrfs read error corrected: ino 1 off 291845=
40672 (dev /dev/sdb sector 3207776)
[Tue Feb 18 13:29:31 2014] btrfs: device label dataPool devid 3 transid=
 9104 /dev/sdd
[Tue Feb 18 13:36:16 2014] btrfs: device label dataPool devid 3 transid=
 9112 /dev/sdd

--nextPart4582311.jlVu5n4DM9--

