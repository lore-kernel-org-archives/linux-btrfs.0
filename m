Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34361 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbCTPg2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Mar 2015 11:36:28 -0400
Received: by wggv3 with SMTP id v3so92531599wgg.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 08:36:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Mar 2015 15:19:22 +0000
Message-ID: <CAPmwjs9EVi-vY7FEfm+U-CYuxMms2iB-0i6mMLShdJMO6pGYjQ@mail.gmail.com>
Subject: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction (error -17)
From: Sophie Dexter <just4pleisure@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm given to understand that this is the right place to report a btrfs
problem, I apologise if not :-(

I have been using my router as a simple NFS NAS for around 2 years
with an ext3 formatted 2 TB Western Digital 2.5" USB Passport disk. I
have been slowly moving to BTRFS and thought it about time to convert
this disk too but unfortunately BTRFS is unreliable on my router :-(.
It doesn't take long for an error to happen causing a 'ro' remount.
However the disk is unreadable after the remount, both for NFS and
locally. Rebooting the router seems to be the only way to access the
disk again.

I also have a 1 GB swap partition on the disk although swap doesn't
appear to be a factor as the problem occurs whether or not swap is
enabled (this report is without swap).

I used my laptop to convert the fs to btrfs, not my router. My laptop
has Fedora 21 with 3.18 kernel and tools. No problems are found when I
use my laptop to check and scrub the disk (i.e. with the disk
connected directly to my laptop).

Thank you :-)
Sophie x

# uname -a
Linux OpenWrt 3.18.9 #1 Thu Mar 19 18:35:47 UTC 2015 mips GNU/Linux
# btrfs --version
Btrfs v3.17.3
# btrfs fi show
Label: '###########' uuid: ########-####-####-####-############
Total devices 1 FS bytes used 1.15TiB
devid 1 size 1.82TiB used 1.15TiB path /dev/sda1

Btrfs v3.17.3
# btrfs fi df /mnt/usb/
Data, single: total=1.15TiB, used=1.15TiB
System, single: total=32.00MiB, used=136.00KiB
Metadata, single: total=2.00GiB, used=1.36GiB
GlobalReserve, single: total=464.00MiB, used=0.00B

# dmesg
[ 0.000000] Linux version 3.18.9 (openwrt@gb-12) (gcc version 4.8.3
(OpenWrt/Linaro GCC 4.8-2014.04 r44879) ) #1 Thu Mar 19 18:35:47 UTC
2015
[ 0.000000] MyLoader: sysp=fff6fffc, boardp=7effffab, parts=dfffffff
[ 0.000000] bootconsole [early0] enabled
[ 0.000000] CPU0 revision is: 00019374 (MIPS 24Kc)
[ 0.000000] SoC: Atheros AR7241 rev 1
[ 0.000000] Determined physical RAM map:
[ 0.000000] memory: 04000000 @ 00000000 (usable)
[ 0.000000] Initrd not found or empty - disabling initrd
[ 0.000000] Zone ranges:
[ 0.000000] Normal [mem 0x00000000-0x03ffffff]
[ 0.000000] Movable zone start for each node
[ 0.000000] Early memory node ranges
[ 0.000000] node 0: [mem 0x00000000-0x03ffffff]
[ 0.000000] Initmem setup node 0 [mem 0x00000000-0x03ffffff]
[ 0.000000] On node 0 totalpages: 16384
[ 0.000000] free_area_init_node: node 0, pgdat 803822b0, node_mem_map 81000000
[ 0.000000] Normal zone: 128 pages used for memmap
[ 0.000000] Normal zone: 0 pages reserved
[ 0.000000] Normal zone: 16384 pages, LIFO batch:3
[ 0.000000] Primary instruction cache 64kB, VIPT, 4-way, linesize 32 bytes.
[ 0.000000] Primary data cache 32kB, 4-way, VIPT, cache aliases,
linesize 32 bytes
[ 0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[ 0.000000] pcpu-alloc: [0] 0
[ 0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 16256
[ 0.000000] Kernel command line: board=TL-MR3420 console=ttyS0,115200
rootfstype=squashfs,jffs2 noinitrd
[ 0.000000] PID hash table entries: 256 (order: -2, 1024 bytes)
[ 0.000000] Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
[ 0.000000] Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
[ 0.000000] Writing ErrCtl register=00000000
[ 0.000000] Readback ErrCtl register=00000000
[ 0.000000] Memory: 60812K/65536K available (2631K kernel code, 127K
rwdata, 544K rodata, 208K init, 193K bss, 4724K reserved)
[ 0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[ 0.000000] NR_IRQS:51
[ 0.000000] Clocks: CPU:400.000MHz, DDR:400.000MHz, AHB:200.000MHz, Ref:5.000MHz
[ 0.000000] Calibrating delay loop... 265.42 BogoMIPS (lpj=1327104)
[ 0.080000] pid_max: default: 32768 minimum: 301
[ 0.080000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.090000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.100000] NET: Registered protocol family 16
[ 0.100000] MIPS: machine is TP-LINK TL-MR3420
[ 0.550000] registering PCI controller with io_map_base unset
[ 0.590000] PCI host bridge to bus 0000:00
[ 0.600000] pci_bus 0000:00: root bus resource [mem 0x10000000-0x13ffffff]
[ 0.600000] pci_bus 0000:00: root bus resource [io 0x0000]
[ 0.610000] pci_bus 0000:00: No busn resource found for root bus, will
use [bus 00-ff]
[ 0.610000] pci 0000:00:00.0: [168c:ff1c] type 00 class 0x020000
[ 0.610000] pci 0000:00:00.0: fixup device configuration
[ 0.620000] pci 0000:00:00.0: reg 0x10: [mem 0x00000000-0x0000ffff 64bit]
[ 0.620000] pci 0000:00:00.0: supports D1
[ 0.620000] pci 0000:00:00.0: PME# supported from D0 D1 D3hot
[ 0.620000] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[ 0.620000] pci 0000:00:00.0: BAR 0: assigned [mem 0x10000000-0x1000ffff 64bit]
[ 0.620000] pci 0000:00:00.0: using irq 40 for pin 1
[ 0.630000] Switched to clocksource MIPS
[ 0.630000] NET: Registered protocol family 2
[ 0.640000] TCP established hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.640000] TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
[ 0.650000] TCP: Hash tables configured (established 1024 bind 1024)
[ 0.660000] TCP: reno registered
[ 0.660000] UDP hash table entries: 256 (order: 0, 4096 bytes)
[ 0.670000] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[ 0.670000] NET: Registered protocol family 1
[ 0.680000] PCI: CLS 0 bytes, default 32
[ 0.680000] futex hash table entries: 256 (order: -1, 3072 bytes)
[ 0.690000] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[ 0.700000] jffs2: version 2.2 (NAND) (SUMMARY) (LZMA) (RTIME)
(CMODE_PRIORITY) (c) 2001-2006 Red Hat, Inc.
[ 0.710000] msgmni has been set to 118
[ 0.720000] io scheduler noop registered
[ 0.720000] io scheduler deadline registered (default)
[ 0.720000] Serial: 8250/16550 driver, 16 ports, IRQ sharing enabled
[ 0.740000] console [ttyS0] disabled
[ 0.760000] serial8250.0: ttyS0 at MMIO 0x18020000 (irq = 11,
base_baud = 12500000) is a 16550A
[ 0.770000] console [ttyS0] enabled
[ 0.770000] bootconsole [early0] disabled
[ 0.780000] m25p80 spi0.0: found s25fl129p1, expected m25p80
[ 0.790000] m25p80 spi0.0: s25fl129p1 (16384 Kbytes)
[ 0.800000] 5 tp-link partitions found on MTD device spi0.0
[ 0.800000] Creating 5 MTD partitions on "spi0.0":
[ 0.810000] 0x000000000000-0x000000020000 : "u-boot"
[ 0.810000] 0x000000020000-0x000000149000 : "kernel"
[ 0.820000] mtd: partition "kernel" must either start or end on erase
block boundary or be smaller than an erase block -- forcing read-only
[ 0.830000] 0x000000149000-0x000000ff0000 : "rootfs"
[ 0.840000] mtd: partition "rootfs" must either start or end on erase
block boundary or be smaller than an erase block -- forcing read-only
[ 0.850000] mtd: device 2 (rootfs) set to be root filesystem
[ 0.860000] 1 squashfs-split partitions found on MTD device rootfs
[ 0.860000] 0x000000330000-0x000000ff0000 : "rootfs_data"
[ 0.870000] 0x000000ff0000-0x000001000000 : "art"
[ 0.870000] 0x000000020000-0x000000ff0000 : "firmware"
[ 0.920000] libphy: ag71xx_mdio: probed
[ 1.510000] ag71xx-mdio.1: Found an AR7240/AR9330 built-in switch
[ 1.550000] eth0: Atheros AG71xx at 0xba000000, irq 5, mode:GMII
[ 2.140000] ag71xx ag71xx.0: connected to PHY at ag71xx-mdio.1:04
[uid=004dd041, driver=Generic PHY]
[ 2.150000] eth1: Atheros AG71xx at 0xb9000000, irq 4, mode:MII
[ 2.150000] TCP: cubic registered
[ 2.160000] NET: Registered protocol family 17
[ 2.160000] bridge: automatic filtering via arp/ip/ip6tables has been
deprecated. Update your scripts to load br_netfilter if you need this.
[ 2.180000] Bridge firewalling registered
[ 2.180000] 8021q: 802.1Q VLAN Support v1.8
[ 2.190000] VFS: Mounted root (squashfs filesystem) readonly on device 31:2.
[ 2.200000] Freeing unused kernel memory: 208K (8039c000 - 803d0000)
[ 3.460000] init: Console is alive
[ 3.460000] init: - watchdog -
[ 5.020000] usbcore: registered new interface driver usbfs
[ 5.030000] usbcore: registered new interface driver hub
[ 5.030000] usbcore: registered new device driver usb
[ 5.040000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[ 5.050000] ehci-platform: EHCI generic platform driver
[ 5.060000] ehci-platform ehci-platform: EHCI Host Controller
[ 5.060000] ehci-platform ehci-platform: new USB bus registered,
assigned bus number 1
[ 5.070000] ehci-platform ehci-platform: irq 3, io mem 0x1b000000
[ 5.100000] ehci-platform ehci-platform: USB 2.0 started, EHCI 1.00
[ 5.100000] hub 1-0:1.0: USB hub found
[ 5.110000] hub 1-0:1.0: 1 port detected
[ 5.110000] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[ 5.120000] ohci-platform: OHCI generic platform driver
[ 5.430000] usb 1-1: new high-speed USB device number 2 using ehci-platform
[ 5.550000] init: - preinit -
[ 6.360000] random: procd urandom read with 10 bits of entropy available
[ 8.440000] eth0: link up (1000Mbps/Full duplex)
[ 9.740000] jffs2: notice: (360) jffs2_build_xattr_subsystem: complete
building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of
xref (0 dead, 0 orphan) found.
[ 9.770000] mount_root: loading kmods from internal overlay
[ 11.540000] raid6: int32x1 17 MB/s
[ 11.710000] raid6: int32x2 34 MB/s
[ 11.880000] raid6: int32x4 60 MB/s
[ 12.050000] raid6: int32x8 56 MB/s
[ 12.050000] raid6: using algorithm int32x4 (60 MB/s)
[ 12.050000] raid6: using intx1 recovery algorithm
[ 12.060000] xor: measuring software checksum speed
[ 12.170000] 8regs : 295.600 MB/sec
[ 12.270000] 8regs_prefetch: 281.600 MB/sec
[ 12.370000] 32regs : 326.800 MB/sec
[ 12.470000] 32regs_prefetch: 309.600 MB/sec
[ 12.470000] xor: using function: 32regs (326.800 MB/sec)
[ 13.070000] Btrfs loaded
[ 13.240000] SCSI subsystem initialized
[ 13.250000] usb-storage 1-1:1.0: USB Mass Storage device detected
[ 13.260000] scsi host0: usb-storage 1-1:1.0
[ 13.260000] usbcore: registered new interface driver usb-storage
[ 13.540000] block: attempting to load /tmp/jffs_cfg/upper/etc/config/fstab
[ 13.550000] block: extroot: not configured
[ 13.550000] mount_root: switching to jffs2 overlay
[ 13.610000] eth0: link down
[ 13.650000] procd: - early -
[ 13.650000] procd: - watchdog -
[ 14.260000] scsi 0:0:0:0: Direct-Access WD My Passport 0748 1015 PQ: 0 ANSI: 6
[ 14.270000] sd 0:0:0:0: [sda] 3906963456 512-byte logical blocks:
(2.00 TB/1.81 TiB)
[ 14.290000] scsi 0:0:0:1: Enclosure WD SES Device 1015 PQ: 0 ANSI: 6
[ 14.290000] sd 0:0:0:0: [sda] Write Protect is off
[ 14.300000] sd 0:0:0:0: [sda] Mode Sense: 47 00 10 08
[ 14.300000] sd 0:0:0:0: [sda] No Caching mode page found
[ 14.310000] sd 0:0:0:0: [sda] Assuming drive cache: write through
[ 14.370000] sda: sda1 sda2
[ 14.390000] sd 0:0:0:0: [sda] Attached SCSI disk
[ 14.890000] procd: - ubus -
[ 15.040000] BTRFS: device label Media Share devid 1 transid 13977 /dev/sda1
[ 15.050000] BTRFS info (device sda1): disk space caching is enabled
[ 15.900000] procd: - init -
[ 17.190000] NET: Registered protocol family 10
[ 17.200000] Key type dns_resolver registered
[ 17.270000] RPC: Registered named UNIX socket transport module.
[ 17.280000] RPC: Registered udp transport module.
[ 17.280000] RPC: Registered tcp transport module.
[ 17.290000] RPC: Registered tcp NFSv4.1 backchannel transport module.
[ 17.350000] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[ 17.360000] ip6_tables: (C) 2000-2006 Netfilter Core Team
[ 17.390000] Loading modules backported from Linux version
master-2015-03-09-0-g141f155
[ 17.400000] Backport generated by backports.git backports-20150129-0-gdd4a670
[ 17.410000] ip_tables: (C) 2000-2006 Netfilter Core Team
[ 17.430000] nf_conntrack version 0.5.0 (953 buckets, 3812 max)
[ 17.510000] xt_time: kernel timezone is -0000
[ 17.550000] cfg80211: Calling CRDA to update world regulatory domain
[ 17.580000] cfg80211: World regulatory domain updated:
[ 17.580000] cfg80211: DFS Master region: unset
[ 17.580000] cfg80211: (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[ 17.590000] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A,
2000 mBm), (N/A)
[ 17.600000] cfg80211: (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A,
2000 mBm), (N/A)
[ 17.610000] cfg80211: (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A,
2000 mBm), (N/A)
[ 17.620000] cfg80211: (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A,
2000 mBm), (N/A)
[ 17.630000] cfg80211: (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000
KHz AUTO), (N/A, 2000 mBm), (0 s)
[ 17.640000] cfg80211: (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A,
2000 mBm), (0 s)
[ 17.640000] cfg80211: (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A,
2000 mBm), (N/A)
[ 17.650000] cfg80211: (57240000 KHz - 63720000 KHz @ 2160000 KHz),
(N/A, 0 mBm), (N/A)
[ 17.710000] PPP generic driver version 2.4.2
[ 17.720000] NET: Registered protocol family 24
[ 17.780000] PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
[ 17.800000] ath: EEPROM regdomain: 0x0
[ 17.800000] ath: EEPROM indicates default country code should be used
[ 17.800000] ath: doing EEPROM country->regdmn map search
[ 17.800000] ath: country maps to regdmn code: 0x3a
[ 17.800000] ath: Country alpha2 being used: US
[ 17.800000] ath: Regpair used: 0x3a
[ 17.810000] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[ 17.820000] ieee80211 phy0: Atheros AR9287 Rev:2 mem=0xb0000000, irq=40
[ 17.830000] cfg80211: Calling CRDA for country: US
[ 17.830000] cfg80211: Regulatory domain changed to country: US
[ 17.840000] cfg80211: DFS Master region: FCC
[ 17.840000] cfg80211: (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[ 17.850000] cfg80211: (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A,
3000 mBm), (N/A)
[ 17.860000] cfg80211: (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000
KHz AUTO), (N/A, 1700 mBm), (N/A)
[ 17.870000] cfg80211: (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000
KHz AUTO), (N/A, 2300 mBm), (0 s)
[ 17.880000] cfg80211: (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A,
3000 mBm), (N/A)
[ 17.890000] cfg80211: (57240000 KHz - 63720000 KHz @ 2160000 KHz),
(N/A, 4000 mBm), (N/A)
[ 18.250000] random: nonblocking pool is initialized
[ 33.130000] device eth0 entered promiscuous mode
[ 33.130000] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
[ 33.190000] device eth1 entered promiscuous mode
[ 33.190000] br-lan: port 2(eth1) entered forwarding state
[ 33.200000] br-lan: port 2(eth1) entered forwarding state
[ 33.200000] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
[ 34.170000] br-lan: port 2(eth1) entered disabled state
[ 34.770000] eth0: link up (1000Mbps/Full duplex)
[ 34.770000] br-lan: port 1(eth0) entered forwarding state
[ 34.780000] br-lan: port 1(eth0) entered forwarding state
[ 35.730000] eth1: link up (100Mbps/Full duplex)
[ 35.730000] br-lan: port 2(eth1) entered forwarding state
[ 35.740000] br-lan: port 2(eth1) entered forwarding state
[ 35.960000] svc: failed to register lockdv1 RPC service (errno 124).
[ 36.780000] br-lan: port 1(eth0) entered forwarding state
[ 37.740000] br-lan: port 2(eth1) entered forwarding state
[ 265.110000] ------------[ cut here ]------------
[ 265.110000] WARNING: CPU: 0 PID: 831 at fs/btrfs/super.c:260
__btrfs_abort_transaction+0x74/0x150 [btrfs]()
[ 265.120000] BTRFS: Transaction aborted (error -17)
[ 265.130000] Modules linked in: ath9k ath9k_common pppoe ppp_async
iptable_nat ath9k_hw ath pppox ppp_generic nf_nat_ipv4
nf_conntrack_ipv6 nf_conntrack_ipv4 mac80211 ipt_REJECT ipt_MASQUERADE
cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac
xt_limit xt_id xt_conntrack xt_comment xt_TCPMSS xt_REDIRECT xt_LOG
xt_CT slhc nf_reject_ipv4 nf_nat_masquerade_ipv4 nf_nat_irc nf_nat_ftp
nf_nat nf_log_ipv4 nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache
nf_conntrack_irc nf_conntrack_ftp nf_conntrack libcrc32c iptable_raw
iptable_mangle iptable_filter ip_tables crc_ccitt compat
ledtrig_usbdev ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
ip6table_raw ip6table_mangle ip6table_filter ip6_tables x_tables nfsd
nfsv3 nfs lockd sunrpc grace dns_resolver ipv6 arc4 crypto_blkcipher
usb_storage sd_mod scsi_mod ext4 crc16 jbd2 mbcache btrfs zlib_inflate
zlib_deflate xor raid6_pq lzo_decompress lzo_compress exportfs
crc32c_generic crypto_hash ohci_platform ohci_hcd ehci_platform
ehci_hcd gpio_button_hotplug usbcore nls_base usb_common
[ 265.220000] CPU: 0 PID: 831 Comm: btrfs-transacti Not tainted 3.18.9 #1
[ 265.230000] Stack : 00000000 00000000 00000000 00000000 803fe10a
0000003b 00000000 832012e0
[ 265.230000] 00000001 8359fed8 8033fd38 8038df63 0000033f 803f3b80
83a195a8 8359fed8
[ 265.230000] 832b6dfc 00000000 832c0000 802cf89c 00000003 8022ae14
00000104 8359fed8
[ 265.230000] 80342e54 825bdc6c 00000000 00000000 00000000 00000000
00000000 00000000
[ 265.230000] 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
[ 265.230000] ...
[ 265.260000] Call Trace:
[ 265.270000] [<802718d8>] show_stack+0x48/0x70
[ 265.270000] [<802e0c48>] warn_slowpath_common+0x84/0xb4
[ 265.280000] [<802e0ca4>] warn_slowpath_fmt+0x2c/0x38
[ 265.280000] [<832012e0>] __btrfs_abort_transaction+0x74/0x150 [btrfs]
[ 265.290000] [<832206e4>] btrfs_run_delayed_refs+0xa0/0x318 [btrfs]
[ 265.290000] [<83220bb8>] btrfs_write_dirty_block_groups+0x25c/0x650 [btrfs]
[ 265.300000] [<832b3df4>] btrfs_crc32c+0x514/0x1418 [btrfs]
[ 265.310000]
[ 265.310000] ---[ end trace e1e1a04204a7499b ]---
[ 265.310000] BTRFS: error (device sda1) in
btrfs_run_delayed_refs:2792: errno=-17 Object already exists
[ 265.320000] BTRFS info (device sda1): forced readonly
[ 265.350000] BTRFS warning (device sda1): Skipping commit of aborted
transaction.
[ 265.360000] BTRFS: error (device sda1) in cleanup_transaction:1607:
errno=-17 Object already exists

# cat /proc/meminfo
MemTotal: 61020 kB
MemFree: 2784 kB
MemAvailable: 40044 kB
Buffers: 1736 kB
Cached: 35768 kB
SwapCached: 0 kB
Active: 20292 kB
Inactive: 19244 kB
Active(anon): 2952 kB
Inactive(anon): 32 kB
Active(file): 17340 kB
Inactive(file): 19212 kB
Unevictable: 0 kB
Mlocked: 0 kB
SwapTotal: 0 kB
SwapFree: 0 kB
Dirty: 0 kB
Writeback: 0 kB
AnonPages: 2064 kB
Mapped: 1428 kB
Shmem: 920 kB
Slab: 11460 kB
SReclaimable: 4392 kB
SUnreclaim: 7068 kB
KernelStack: 592 kB
PageTables: 284 kB
NFS_Unstable: 0 kB
Bounce: 0 kB
WritebackTmp: 0 kB
CommitLimit: 30508 kB
Committed_AS: 5848 kB
VmallocTotal: 1048372 kB
VmallocUsed: 1612 kB
VmallocChunk: 1026496 kB
