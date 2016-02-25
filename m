Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from teruel.switch.ch ([130.59.138.63]:43425 "EHLO teruel.switch.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933202AbcBYRzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Feb 2016 12:55:42 -0500
Received: from webmail.hsr.ch ([152.96.21.231])
	by teruel.switch.ch (8.14.4/8.14.4/Debian-4) with ESMTP id u1PHhqd1001688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Feb 2016 18:43:52 +0100
Subject: Re: btrfs raid1 filesystem on sdcard corrupted
To: <linux-btrfs@vger.kernel.org>
References: <nandur$4li$1@ger.gmane.org>
From: Hegner Robert <rhegner@hsr.ch>
Message-ID: <56CF3D78.90705@hsr.ch>
Date: Thu, 25 Feb 2016 18:44:24 +0100
MIME-Version: 1.0
In-Reply-To: <nandur$4li$1@ger.gmane.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 25.02.2016 um 18:34 schrieb Hegner Robert:
> Hi all!
>
> I'm working on a embedded system (ARM) running from a SDcard. Recently I
> switched to a btrfs-raid1 configuration, hoping to make my system more
> resistant against power failures and flash-memory specific problems.
>
> However today one of my devices wouldn't mount my root filesystem as rw
> anymore.
>
> The main reason I'm asking in this mailing list is not that I want to
> restory data. But I'd like to understand what happened and, even more
> importantly, find out what I have to do so that something like this will
> never happen again.
>
> Here is some info about my system:
>
> root@ObserverOne:~# uname -a
> Linux ObserverOne 3.16.0-4-armmp #1 SMP Debian 3.16.7-ckt11-1+deb8u6
> (2015-11-09) armv7l GNU/Linux
>
> root@ObserverOne:~# btrfs --version
> Btrfs v3.17
>
> root@ObserverOne:~# btrfs fi show
> Label: none  uuid: eef07fbf-77cb-427a-b118-bf5295f25b66
>          Total devices 2 FS bytes used 816.80MiB
>          devid    1 size 3.45GiB used 3.02GiB path /dev/mmcblk0p2
>          devid    2 size 3.45GiB used 3.02GiB path /dev/mmcblk0p3
>
> parent transid verify failed on 4173889536 wanted 804 found 218
> parent transid verify failed on 4173889536 wanted 804 found 218
> parent transid verify failed on 4173889536 wanted 804 found 218
> parent transid verify failed on 4173889536 wanted 804 found 218
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Btrfs v3.17
>
> root@ObserverOne:~# btrfs fi df /
> Data, RAID1: total=2.48GiB, used=788.41MiB
> System, RAID1: total=32.00MiB, used=16.00KiB
> Metadata, RAID1: total=512.00MiB, used=28.38MiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
>
> You can also find the output of dmesg in the attachment.
>
> How would you proceed in investigating this problem? Or do you already
> see a problem in the dmesg output? (I'm not a very experienced linux user).
>
> Best regards
> Robert
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Oh... looks like the attachment got lost... So I will post the output of 
dmesg below. The SDcard related errors seem to start from timestamp (or 
whatever that is in the brackets) [   12.021717].

root@ObserverOne:~# dmesg
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-4-armmp 
(debian-kernel@lists.debian.org) (gcc version 4.8.4 (Debian 4.8.4-1) ) 
#1 SMP Debian 3.16.7-ckt11-1+deb8u6 (2015-11-09)
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), 
cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing 
instruction cache
[    0.000000] Machine model: LinkSprite pcDuino
[    0.000000] Memory policy: Data cache writeback
[    0.000000] On node 0 totalpages: 262144
[    0.000000] free_area_init_node: node 0, pgdat c09de940, node_mem_map 
eeff9000
[    0.000000]   DMA zone: 1520 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 528 pages used for memmap
[    0.000000]   HighMem zone: 67584 pages, LIFO batch:15
[    0.000000] CPU: All CPU(s) started in SVC mode.
[    0.000000] PERCPU: Embedded 9 pages/cpu @eefdd000 s12608 r8192 
d16064 u36864
[    0.000000] pcpu-alloc: s12608 r8192 d16064 u36864 alloc=9*4096
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 260624
[    0.000000] Kernel command line: console=ttyS0,115200 quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000000] Memory: 1016180K/1048576K available (6412K kernel code, 
829K rwdata, 2204K rodata, 684K init, 393K bss, 32396K reserved, 270336K 
highmem)
[    0.000000] Virtual kernel memory layout:
     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
     fixmap  : 0xffc00000 - 0xffe00000   (2048 kB)
     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
       .text : 0xc0008000 - 0xc0872578   (8618 kB)
       .init : 0xc0873000 - 0xc091e140   ( 685 kB)
       .data : 0xc0920000 - 0xc09ef610   ( 830 kB)
        .bss : 0xc09ef610 - 0xc0a51af4   ( 394 kB)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000018] sched_clock: 32 bits at 24MHz, resolution 41ns, wraps 
every 178956969942ns
[    0.000574] Console: colour dummy device 80x30
[    0.000605] Calibrating delay loop... 1001.47 BogoMIPS (lpj=2002944)
[    0.048088] pid_max: default: 32768 minimum: 301
[    0.048204] Security Framework initialized
[    0.048266] AppArmor: AppArmor disabled by boot time parameter
[    0.048274] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.048345] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.048357] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 
bytes)
[    0.049247] Initializing cgroup subsys memory
[    0.049275] Initializing cgroup subsys devices
[    0.049310] Initializing cgroup subsys freezer
[    0.049330] Initializing cgroup subsys net_cls
[    0.049360] Initializing cgroup subsys blkio
[    0.049384] Initializing cgroup subsys perf_event
[    0.049398] Initializing cgroup subsys net_prio
[    0.049466] CPU: Testing write buffer coherency: ok
[    0.049504] ftrace: allocating 23075 entries in 68 pages
[    0.083668] CPU0: thread -1, cpu 0, socket -1, mpidr 0
[    0.083886] Setting up static identity map for 0x405c2298 - 0x405c22f0
[    0.091297] Brought up 1 CPUs
[    0.091317] SMP: Total of 1 processors activated (1001.47 BogoMIPS).
[    0.091325] CPU: All CPU(s) started in SVC mode.
[    0.091926] devtmpfs: initialized
[    0.092761] VFP support v0.3: implementor 41 architecture 3 part 30 
variant c rev 3
[    0.097852] pinctrl core: initialized pinctrl subsystem
[    0.098323] regulator-dummy: no parameters
[    0.103293] NET: Registered protocol family 16
[    0.103785] DMA: preallocated 256 KiB pool for atomic coherent 
allocations
[    0.109097] No ATAGs?
[    0.109120] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.109242] EXYNOS: PMU not supported
[    0.109860] Serial: AMBA PL011 UART driver
[    0.118659] edma-dma-engine edma-dma-engine.0: Can't allocate PaRAM 
dummy slot
[    0.118687] edma-dma-engine: probe of edma-dma-engine.0 failed with 
error -5
[    0.119047] reg-fixed-voltage usb1-vbus: could not find pctldev for 
node /soc@01c00000/pinctrl@01c20800/usb1_vbus_pin@0, deferring probe
[    0.119064] platform usb1-vbus: Driver reg-fixed-voltage requests 
probe deferral
[    0.119088] reg-fixed-voltage usb2-vbus: could not find pctldev for 
node /soc@01c00000/pinctrl@01c20800/usb2_vbus_pin@0, deferring probe
[    0.119101] platform usb2-vbus: Driver reg-fixed-voltage requests 
probe deferral
[    0.119316] vcc3v0: 3000 mV
[    0.119584] vcc3v3: 3300 mV
[    0.120630] vgaarb: loaded
[    0.121194] usbcore: registered new interface driver usbfs
[    0.121271] usbcore: registered new interface driver hub
[    0.121468] usbcore: registered new device driver usb
[    0.121979] media: Linux media interface: v0.10
[    0.122038] Linux video capture interface: v2.00
[    0.122138] pps_core: LinuxPPS API ver. 1 registered
[    0.122146] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    0.122174] PTP clock support registered
[    0.123428] Switched to clocksource timer
[    0.177451] NET: Registered protocol family 2
[    0.178458] TCP established hash table entries: 8192 (order: 3, 32768 
bytes)
[    0.178536] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.178646] TCP: Hash tables configured (established 8192 bind 8192)
[    0.178733] TCP: reno registered
[    0.178746] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.178776] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.178967] NET: Registered protocol family 1
[    0.179016] PCI: CLS 0 bytes, default 64
[    0.179567] Unpacking initramfs...
[    1.049614] Freeing initrd memory: 12708K (ce396000 - cefff000)
[    1.051532] futex hash table entries: 256 (order: 2, 16384 bytes)
[    1.051612] audit: initializing netlink subsys (disabled)
[    1.051695] audit: type=2000 audit(1.040:1): initialized
[    1.053102] zbud: loaded
[    1.053398] VFS: Disk quotas dquot_6.5.2
[    1.053470] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.053616] msgmni has been set to 1481
[    1.055212] alg: No test for stdrng (krng)
[    1.055329] bounce: pool size: 64 pages
[    1.055404] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 249)
[    1.055756] io scheduler noop registered
[    1.055772] io scheduler deadline registered
[    1.055908] io scheduler cfq registered (default)
[    1.058351] sun4i-pinctrl 1c20800.pinctrl: initialized sunXi PIO driver
[    1.060635] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.062666] console [ttyS0] disabled
[    1.082790] 1c28000.serial: ttyS0 at MMIO 0x1c28000 (irq = 26, 
base_baud = 1500000) is a U6_16550A
[    1.090417] console [ttyS0] enabled
[    1.090853] Serial: AMBA driver
[    1.091084] Serial: IMX driver
[    1.093421] 1c0b080.mdio supply phy not found, using dummy regulator
[    1.093604] libphy: sun4i_mii_bus: probed
[    1.114995] mousedev: PS/2 mouse device common for all mice
[    1.116516] sunxi-rtc 1c20d00.rtc: rtc core: registered rtc-sunxi as rtc0
[    1.116531] sunxi-rtc 1c20d00.rtc: RTC enabled
[    1.117420] ledtrig-cpu: registered to indicate activity on CPUs
[    1.117522] hidraw: raw HID events driver (C) Jiri Kosina
[    1.118133] usbcore: registered new interface driver usbhid
[    1.118142] usbhid: USB HID core driver
[    1.118789] TCP: cubic registered
[    1.118866] NET: Registered protocol family 10
[    1.119925] mip6: Mobile IPv6
[    1.119953] NET: Registered protocol family 17
[    1.119982] mpls_gso: MPLS GSO support
[    1.120058] ThumbEE CPU extension supported.
[    1.120088] Registering SWP/SWPB emulation handler
[    1.120847] registered taskstats version 1
[    1.121704] usb1-vbus: 5000 mV
[    1.122158] usb2-vbus: 5000 mV
[    1.122477] sunxi-rtc 1c20d00.rtc: setting system clock to 2010-01-01 
00:00:13 UTC (1262304013)
[    1.127634] PM: Hibernation image not present or could not be loaded.
[    1.127665] usb2-vbus: disabling
[    1.127673] usb1-vbus: disabling
[    1.127680] vcc3v3: disabling
[    1.127687] vcc3v0: disabling
[    1.128865] Freeing unused kernel memory: 684K (c0873000 - c091e000)
[    1.200051] systemd-udevd[55]: starting version 215
[    1.201832] random: systemd-udevd urandom read with 1 bits of entropy 
available
[    1.270396] sun4i-emac 1c0b000.ethernet: eth0: at f00ac000, IRQ 17 
MAC: 02:58:07:41:7d:ed
[    1.285133] sunxi-mmc 1c0f000.mmc: No vqmmc regulator found
[    1.292280] sunxi-mmc 1c0f000.mmc: Got CD GPIO #225.
[    1.327680] sunxi-mmc 1c0f000.mmc: base:0xf00c0000 irq:18
[    1.371303] mmc0: host does not support reading read-only switch. 
assuming write-enable.
[    1.373357] mmc0: new high speed SDHC card at address 1234
[    1.379039] mmcblk0: mmc0:1234 SA08G 7.28 GiB
[    1.381455]  mmcblk0: p1 p2 p3
[    1.851745] raid6: int32x1    193 MB/s
[    1.919502] raid6: int32x2    254 MB/s
[    1.987608] raid6: int32x4    300 MB/s
[    2.055493] raid6: int32x8    280 MB/s
[    2.055501] raid6: using algorithm int32x4 (300 MB/s)
[    2.055508] raid6: using intx1 recovery algorithm
[    2.059238] xor: measuring software checksum speed
[    2.095424]    arm4regs  :  1252.000 MB/sec
[    2.135422]    8regs     :  1080.000 MB/sec
[    2.175423]    32regs    :   870.000 MB/sec
[    2.175432] xor: using function: arm4regs (1252.000 MB/sec)
[    2.216388] Btrfs loaded
[    2.518586] BTRFS: device fsid eef07fbf-77cb-427a-b118-bf5295f25b66 
devid 1 transid 803 /dev/mmcblk0p2
[    2.521615] BTRFS: device fsid eef07fbf-77cb-427a-b118-bf5295f25b66 
devid 2 transid 803 /dev/mmcblk0p3
[    2.683945] BTRFS info (device mmcblk0p3): disk space caching is enabled
[    2.705822] BTRFS: detected SSD devices, enabling SSD mode
[    3.706082] systemd[1]: Cannot add dependency job for unit 
display-manager.service, ignoring: Unit display-manager.service failed 
to load: No such file or directory.
[    3.942268] BTRFS info (device mmcblk0p3): force lzo compression
[    3.942305] BTRFS info (device mmcblk0p3): using default commit 
interval 30s
[    3.942318] BTRFS info (device mmcblk0p3): use spread ssd allocation 
scheme
[    3.942333] BTRFS info (device mmcblk0p3): enabling auto defrag
[    3.942340] BTRFS info (device mmcblk0p3): disk space caching is enabled
[    3.942349] BTRFS info (device mmcblk0p3): resize thread pool 3 -> 4
[    4.313556] systemd-udevd[170]: starting version 215
[    4.895326] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.900043] ehci-platform: EHCI generic platform driver
[    4.900336] ehci-platform 1c14000.usb: EHCI Host Controller
[    4.910891] ehci-platform 1c14000.usb: new USB bus registered, 
assigned bus number 1
[    4.911071] ehci-platform 1c14000.usb: irq 19, io mem 0x01c14000
[    4.911528] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.921619] ohci-platform: OHCI generic platform driver
[    4.922898] ehci-platform 1c14000.usb: USB 2.0 started, EHCI 1.00
[    4.923210] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.923224] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.923233] usb usb1: Product: EHCI Host Controller
[    4.923242] usb usb1: Manufacturer: Linux 3.16.0-4-armmp ehci_hcd
[    4.923251] usb usb1: SerialNumber: 1c14000.usb
[    4.935940] hub 1-0:1.0: USB hub found
[    4.940981] hub 1-0:1.0: 1 port detected
[    4.941868] ohci-platform 1c14400.usb: Generic Platform OHCI controller
[    4.942234] ohci-platform 1c14400.usb: new USB bus registered, 
assigned bus number 2
[    4.942365] ohci-platform 1c14400.usb: irq 20, io mem 0x01c14400
[    5.000254] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.000276] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    5.000285] usb usb2: Product: Generic Platform OHCI controller
[    5.000295] usb usb2: Manufacturer: Linux 3.16.0-4-armmp ohci_hcd
[    5.000304] usb usb2: SerialNumber: 1c14400.usb
[    5.001195] hub 2-0:1.0: USB hub found
[    5.001244] hub 2-0:1.0: 1 port detected
[    5.002364] sunxi-wdt 1c20c90.watchdog: Watchdog enabled (timeout=16 
sec, nowayout=0)
[    5.003236] ehci-platform 1c1c000.usb: EHCI Host Controller
[    5.003733] ehci-platform 1c1c000.usb: new USB bus registered, 
assigned bus number 3
[    5.003898] ehci-platform 1c1c000.usb: irq 21, io mem 0x01c1c000
[    5.015676] ehci-platform 1c1c000.usb: USB 2.0 started, EHCI 1.00
[    5.016022] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    5.016036] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    5.016045] usb usb3: Product: EHCI Host Controller
[    5.016054] usb usb3: Manufacturer: Linux 3.16.0-4-armmp ehci_hcd
[    5.016063] usb usb3: SerialNumber: 1c1c000.usb
[    5.016931] hub 3-0:1.0: USB hub found
[    5.016984] hub 3-0:1.0: 1 port detected
[    5.019890] ohci-platform 1c1c400.usb: Generic Platform OHCI controller
[    5.020239] ohci-platform 1c1c400.usb: new USB bus registered, 
assigned bus number 4
[    5.020364] ohci-platform 1c1c400.usb: irq 22, io mem 0x01c1c400
[    5.092700] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.092722] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    5.092732] usb usb4: Product: Generic Platform OHCI controller
[    5.092741] usb usb4: Manufacturer: Linux 3.16.0-4-armmp ohci_hcd
[    5.092750] usb usb4: SerialNumber: 1c1c400.usb
[    5.098871] hub 4-0:1.0: USB hub found
[    5.101258] hub 4-0:1.0: 1 port detected
[    5.280927] Adding alias for supply acin,(null) -> acin,0-0034
[    5.280947] Adding alias for supply vin2,(null) -> vin2,0-0034
[    5.280955] Adding alias for supply vin3,(null) -> vin3,0-0034
[    5.280963] Adding alias for supply ldo24in,(null) -> ldo24in,0-0034
[    5.280970] Adding alias for supply ldo3in,(null) -> ldo3in,0-0034
[    5.280977] Adding alias for supply ldo5in,(null) -> ldo5in,0-0034
[    5.281172] axp20x 0-0034: AXP20X driver loaded
[    5.327631] usb 3-1: new high-speed USB device number 2 using 
ehci-platform
[    6.045863] random: nonblocking pool is initialized
[    6.152702] usb 3-1: New USB device found, idVendor=1d27, idProduct=0601
[    6.152723] usb 3-1: New USB device strings: Mfr=5, Product=4, 
SerialNumber=0
[    6.152732] usb 3-1: Product: PrimeSense Device
[    6.152741] usb 3-1: Manufacturer: PrimeSense
[    6.697772] EXT4-fs (mmcblk0p1): recovery complete
[    6.697804] EXT4-fs (mmcblk0p1): mounted filesystem with ordered data 
mode. Opts: (null)
[    6.772863] systemd-journald[166]: Received request to flush runtime 
journal from PID 1
[    6.800548] usb 3-1: Warning! Unlikely big volume range (=4181), 
cval->res is probably wrong.
[    6.800571] usb 3-1: [3] FU [Mic Capture Volume] ch = 2, val = 0/12544/3
[    6.805748] usb 3-1: Warning! Unlikely big volume range (=4181), 
cval->res is probably wrong.
[    6.805770] usb 3-1: [3] FU [Mic Capture Volume] ch = 1, val = 0/12544/3
[    6.807160] usbcore: registered new interface driver snd-usb-audio
[    7.263523] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.940751] RPC: Registered named UNIX socket transport module.
[    7.940773] RPC: Registered udp transport module.
[    7.940780] RPC: Registered tcp transport module.
[    7.940787] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.961992] FS-Cache: Loaded
[    8.012509] FS-Cache: Netfs 'nfs' registered for caching
[    8.071996] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.327482] sun4i-emac 1c0b000.ethernet eth0: Link is Up - 
100Mbps/Full - flow control off
[    9.327531] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   12.021717] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   12.027695] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   12.035780] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   12.042640] end_request: I/O error, dev mmcblk0, sector 12386304
[   12.048680] end_request: I/O error, dev mmcblk0, sector 12386312
[   12.054708] end_request: I/O error, dev mmcblk0, sector 12386320
[   12.060725] end_request: I/O error, dev mmcblk0, sector 12386328
[   12.066744] BTRFS: bdev /dev/mmcblk0p3 errs: wr 1, rd 0, flush 0, 
corrupt 0, gen 0
[   12.074324] end_request: I/O error, dev mmcblk0, sector 12386336
[   12.080339] end_request: I/O error, dev mmcblk0, sector 12386344
[   12.086353] end_request: I/O error, dev mmcblk0, sector 12386352
[   12.092378] end_request: I/O error, dev mmcblk0, sector 12386360
[   12.098393] BTRFS: bdev /dev/mmcblk0p3 errs: wr 2, rd 0, flush 0, 
corrupt 0, gen 0
[   12.688370] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   12.694342] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   12.702553] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   12.709448] end_request: I/O error, dev mmcblk0, sector 2019328
[   12.715393] end_request: I/O error, dev mmcblk0, sector 2019336
[   12.721333] BTRFS: bdev /dev/mmcblk0p2 errs: wr 1, rd 0, flush 0, 
corrupt 0, gen 0
[   12.728943] BTRFS: bdev /dev/mmcblk0p2 errs: wr 2, rd 0, flush 0, 
corrupt 0, gen 0
[   14.122771] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   14.128747] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   14.137079] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   14.143995] BTRFS: bdev /dev/mmcblk0p2 errs: wr 3, rd 0, flush 0, 
corrupt 0, gen 0
[   14.151596] BTRFS: bdev /dev/mmcblk0p2 errs: wr 4, rd 0, flush 0, 
corrupt 0, gen 0
[   14.741576] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   14.747548] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   14.755714] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   14.762597] BTRFS: bdev /dev/mmcblk0p3 errs: wr 3, rd 0, flush 0, 
corrupt 0, gen 0
[   14.770222] BTRFS: bdev /dev/mmcblk0p3 errs: wr 4, rd 0, flush 0, 
corrupt 0, gen 0
[   16.153360] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   16.159323] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   16.167680] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   16.174560] BTRFS: bdev /dev/mmcblk0p3 errs: wr 5, rd 0, flush 0, 
corrupt 0, gen 0
[   16.182164] BTRFS: bdev /dev/mmcblk0p3 errs: wr 6, rd 0, flush 0, 
corrupt 0, gen 0
[   16.771779] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   16.777748] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   16.785988] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   18.188562] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   18.194549] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   18.202885] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   18.209767] blk_update_request: 38 callbacks suppressed
[   18.209778] end_request: I/O error, dev mmcblk0, sector 12386496
[   18.215817] end_request: I/O error, dev mmcblk0, sector 12386504
[   18.221838] end_request: I/O error, dev mmcblk0, sector 12386512
[   18.227857] end_request: I/O error, dev mmcblk0, sector 12386520
[   18.233874] btrfs_dev_stat_print_on_error: 2 callbacks suppressed
[   18.233884] BTRFS: bdev /dev/mmcblk0p3 errs: wr 7, rd 0, flush 0, 
corrupt 0, gen 0
[   18.241465] end_request: I/O error, dev mmcblk0, sector 12386528
[   18.247483] end_request: I/O error, dev mmcblk0, sector 12386536
[   18.253498] end_request: I/O error, dev mmcblk0, sector 12386544
[   18.259514] end_request: I/O error, dev mmcblk0, sector 12386552
[   18.265529] BTRFS: bdev /dev/mmcblk0p3 errs: wr 8, rd 0, flush 0, 
corrupt 0, gen 0
[   18.854988] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   18.860956] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   18.868776] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   18.875648] end_request: I/O error, dev mmcblk0, sector 2019520
[   18.881594] end_request: I/O error, dev mmcblk0, sector 2019528
[   18.887535] BTRFS: bdev /dev/mmcblk0p2 errs: wr 7, rd 0, flush 0, 
corrupt 0, gen 0
[   18.895152] BTRFS: bdev /dev/mmcblk0p2 errs: wr 8, rd 0, flush 0, 
corrupt 0, gen 0
[   22.116872] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   22.122850] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   22.131411] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   22.138283] BTRFS: bdev /dev/mmcblk0p3 errs: wr 9, rd 0, flush 0, 
corrupt 0, gen 0
[   22.145878] BTRFS: bdev /dev/mmcblk0p3 errs: wr 10, rd 0, flush 0, 
corrupt 0, gen 0
[   22.735299] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   22.741272] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   22.749560] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   22.756470] BTRFS: bdev /dev/mmcblk0p2 errs: wr 9, rd 0, flush 0, 
corrupt 0, gen 0
[   22.764109] BTRFS: bdev /dev/mmcblk0p2 errs: wr 10, rd 0, flush 0, 
corrupt 0, gen 0
[   24.130919] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   24.136887] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   24.145088] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   24.151976] blk_update_request: 22 callbacks suppressed
[   24.151987] end_request: I/O error, dev mmcblk0, sector 2019712
[   24.157929] end_request: I/O error, dev mmcblk0, sector 2019720
[   24.163862] end_request: I/O error, dev mmcblk0, sector 2019728
[   24.169790] end_request: I/O error, dev mmcblk0, sector 2019736
[   24.175732] BTRFS: bdev /dev/mmcblk0p2 errs: wr 11, rd 0, flush 0, 
corrupt 0, gen 0
[   24.183412] end_request: I/O error, dev mmcblk0, sector 2019744
[   24.189343] end_request: I/O error, dev mmcblk0, sector 2019752
[   24.195271] end_request: I/O error, dev mmcblk0, sector 2019760
[   24.201199] end_request: I/O error, dev mmcblk0, sector 2019768
[   24.207129] BTRFS: bdev /dev/mmcblk0p2 errs: wr 12, rd 0, flush 0, 
corrupt 0, gen 0
[   24.796765] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   24.802816] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   24.811031] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   24.817936] end_request: I/O error, dev mmcblk0, sector 12386688
[   24.823970] end_request: I/O error, dev mmcblk0, sector 12386696
[   24.829996] BTRFS: bdev /dev/mmcblk0p3 errs: wr 11, rd 0, flush 0, 
corrupt 0, gen 0
[   24.837708] BTRFS: bdev /dev/mmcblk0p3 errs: wr 12, rd 0, flush 0, 
corrupt 0, gen 0
[   26.212734] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   26.218709] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   26.227031] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   26.233936] BTRFS: bdev /dev/mmcblk0p3 errs: wr 13, rd 0, flush 0, 
corrupt 0, gen 0
[   26.241619] BTRFS: bdev /dev/mmcblk0p3 errs: wr 14, rd 0, flush 0, 
corrupt 0, gen 0
[   26.831265] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   26.837232] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   26.845052] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   26.851943] BTRFS: bdev /dev/mmcblk0p2 errs: wr 13, rd 0, flush 0, 
corrupt 0, gen 0
[   26.859654] BTRFS: bdev /dev/mmcblk0p2 errs: wr 14, rd 0, flush 0, 
corrupt 0, gen 0
[   28.248901] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   28.254873] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   28.263241] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   28.270118] BTRFS: bdev /dev/mmcblk0p3 errs: wr 15, rd 0, flush 0, 
corrupt 0, gen 0
[   28.277801] BTRFS: bdev /dev/mmcblk0p3 errs: wr 16, rd 0, flush 0, 
corrupt 0, gen 0
[   28.867214] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   28.873179] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   28.880975] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   30.264689] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   30.270664] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   30.278963] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   30.285846] blk_update_request: 38 callbacks suppressed
[   30.285857] end_request: I/O error, dev mmcblk0, sector 12386944
[   30.291895] end_request: I/O error, dev mmcblk0, sector 12386952
[   30.297916] end_request: I/O error, dev mmcblk0, sector 12386960
[   30.303935] end_request: I/O error, dev mmcblk0, sector 12386968
[   30.309952] btrfs_dev_stat_print_on_error: 2 callbacks suppressed
[   30.309963] BTRFS: bdev /dev/mmcblk0p3 errs: wr 17, rd 0, flush 0, 
corrupt 0, gen 0
[   30.317630] end_request: I/O error, dev mmcblk0, sector 12386976
[   30.323647] end_request: I/O error, dev mmcblk0, sector 12386984
[   30.329663] end_request: I/O error, dev mmcblk0, sector 12386992
[   30.335678] end_request: I/O error, dev mmcblk0, sector 12387000
[   30.341695] BTRFS: bdev /dev/mmcblk0p3 errs: wr 18, rd 0, flush 0, 
corrupt 0, gen 0
[   30.931436] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   30.937406] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   30.945241] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   30.952128] end_request: I/O error, dev mmcblk0, sector 2019968
[   30.958076] end_request: I/O error, dev mmcblk0, sector 2019976
[   30.964007] BTRFS: bdev /dev/mmcblk0p2 errs: wr 17, rd 0, flush 0, 
corrupt 0, gen 0
[   30.971710] BTRFS: bdev /dev/mmcblk0p2 errs: wr 18, rd 0, flush 0, 
corrupt 0, gen 0
[   32.356379] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   32.362344] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   32.370678] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   32.377585] BTRFS: bdev /dev/mmcblk0p3 errs: wr 19, rd 0, flush 0, 
corrupt 0, gen 0
[   32.385276] BTRFS: bdev /dev/mmcblk0p3 errs: wr 20, rd 0, flush 0, 
corrupt 0, gen 0
[   32.974456] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   32.980444] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   32.988336] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   32.995230] BTRFS: bdev /dev/mmcblk0p2 errs: wr 19, rd 0, flush 0, 
corrupt 0, gen 0
[   33.002961] BTRFS: bdev /dev/mmcblk0p2 errs: wr 20, rd 0, flush 0, 
corrupt 0, gen 0
[   34.400649] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   34.406628] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   34.413231] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   34.420092] BTRFS: bdev /dev/mmcblk0p3 errs: wr 21, rd 0, flush 0, 
corrupt 0, gen 0
[   34.427769] BTRFS: bdev /dev/mmcblk0p3 errs: wr 22, rd 0, flush 0, 
corrupt 0, gen 0
[   35.017273] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   35.023244] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   35.031086] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   36.419341] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   36.425307] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   36.433444] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   36.440334] blk_update_request: 38 callbacks suppressed
[   36.440344] end_request: I/O error, dev mmcblk0, sector 9216136
[   36.446288] end_request: I/O error, dev mmcblk0, sector 9216144
[   36.452214] end_request: I/O error, dev mmcblk0, sector 9216152
[   36.458143] end_request: I/O error, dev mmcblk0, sector 9216160
[   36.464074] end_request: I/O error, dev mmcblk0, sector 9216168
[   36.470003] end_request: I/O error, dev mmcblk0, sector 9216176
[   36.475932] end_request: I/O error, dev mmcblk0, sector 9216184
[   36.481861] end_request: I/O error, dev mmcblk0, sector 9216192
[   36.487790] end_request: I/O error, dev mmcblk0, sector 9216200
[   36.493720] end_request: I/O error, dev mmcblk0, sector 9216208
[   36.499665] btrfs_dev_stat_print_on_error: 2 callbacks suppressed
[   36.499676] BTRFS: bdev /dev/mmcblk0p3 errs: wr 23, rd 0, flush 0, 
corrupt 0, gen 0
[   37.088618] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   37.094618] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   37.102453] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   37.109367] BTRFS: bdev /dev/mmcblk0p3 errs: wr 24, rd 0, flush 0, 
corrupt 0, gen 0
[   37.117046] BTRFS: bdev /dev/mmcblk0p3 errs: wr 25, rd 0, flush 0, 
corrupt 0, gen 0
[   37.706318] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   37.712283] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   37.720292] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   37.727229] BTRFS: bdev /dev/mmcblk0p2 errs: wr 23, rd 0, flush 0, 
corrupt 0, gen 0
[   37.734988] BTRFS: bdev /dev/mmcblk0p2 errs: wr 24, rd 0, flush 0, 
corrupt 0, gen 0
[   37.742695] BTRFS: bdev /dev/mmcblk0p2 errs: wr 25, rd 0, flush 0, 
corrupt 0, gen 0
[   38.378443] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   38.384416] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   38.392586] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   38.399504] BTRFS: bdev /dev/mmcblk0p3 errs: wr 26, rd 0, flush 0, 
corrupt 0, gen 0
[   38.988818] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   38.994830] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   39.002751] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   39.009654] BTRFS: bdev /dev/mmcblk0p2 errs: wr 26, rd 0, flush 0, 
corrupt 0, gen 0
[   40.383263] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   40.389232] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   40.397358] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   40.404280] BTRFS: bdev /dev/mmcblk0p2 errs: wr 27, rd 0, flush 0, 
corrupt 0, gen 0
[   40.411959] BTRFS: bdev /dev/mmcblk0p2 errs: wr 28, rd 0, flush 0, 
corrupt 0, gen 0
[   41.000742] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   41.006708] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   41.014510] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   42.204503] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   42.210481] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   42.218818] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   42.225653] blk_update_request: 116 callbacks suppressed
[   42.225663] end_request: I/O error, dev mmcblk0, sector 2020160
[   42.231610] end_request: I/O error, dev mmcblk0, sector 2020168
[   42.237547] end_request: I/O error, dev mmcblk0, sector 2020176
[   42.243483] end_request: I/O error, dev mmcblk0, sector 2020184
[   42.249416] end_request: I/O error, dev mmcblk0, sector 2020192
[   42.255364] end_request: I/O error, dev mmcblk0, sector 2020200
[   42.261301] end_request: I/O error, dev mmcblk0, sector 2020208
[   42.267246] end_request: I/O error, dev mmcblk0, sector 2020216
[   42.273183] btrfs_dev_stat_print_on_error: 2 callbacks suppressed
[   42.273193] BTRFS: bdev /dev/mmcblk0p2 errs: wr 29, rd 0, flush 0, 
corrupt 0, gen 0
[   42.280863] end_request: I/O error, dev mmcblk0, sector 2020224
[   42.286797] end_request: I/O error, dev mmcblk0, sector 2020232
[   42.292788] BTRFS: bdev /dev/mmcblk0p2 errs: wr 30, rd 0, flush 0, 
corrupt 0, gen 0
[   42.300496] BTRFS: bdev /dev/mmcblk0p2 errs: wr 31, rd 0, flush 0, 
corrupt 0, gen 0
[   42.308176] BTRFS: bdev /dev/mmcblk0p2 errs: wr 32, rd 0, flush 0, 
corrupt 0, gen 0
[   43.478852] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   43.484833] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   43.492673] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   43.499659] BTRFS: bdev /dev/mmcblk0p3 errs: wr 29, rd 0, flush 0, 
corrupt 0, gen 0
[   43.507417] BTRFS: bdev /dev/mmcblk0p3 errs: wr 30, rd 0, flush 0, 
corrupt 0, gen 0
[   43.515137] BTRFS: bdev /dev/mmcblk0p3 errs: wr 31, rd 0, flush 0, 
corrupt 0, gen 0
[   43.522838] BTRFS: bdev /dev/mmcblk0p3 errs: wr 32, rd 0, flush 0, 
corrupt 0, gen 0
[   44.112063] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   44.118023] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   44.126224] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   44.133139] BTRFS: bdev /dev/mmcblk0p3 errs: wr 33, rd 0, flush 0, 
corrupt 0, gen 0
[   45.310573] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   45.316552] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   45.324741] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   45.331677] BTRFS: bdev /dev/mmcblk0p3 errs: wr 34, rd 0, flush 0, 
corrupt 0, gen 0
[   45.925800] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   45.931802] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   45.938375] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   46.526949] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   46.532920] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   46.540716] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   47.129367] BTRFS: error (device mmcblk0p3) in 
btrfs_commit_transaction:1921: errno=-5 IO failure (Error while writing 
out transaction)
[   47.141583] BTRFS info (device mmcblk0p3): forced readonly
[   47.141601] BTRFS warning (device mmcblk0p3): Skipping commit of 
aborted transaction.
[   47.141611] ------------[ cut here ]------------
[   47.141784] WARNING: CPU: 0 PID: 115 at 
/build/linux-mErx14/linux-3.16.7-ckt11/fs/btrfs/super.c:259 
__btrfs_abort_transaction+0xb8/0x124 [btrfs]()
[   47.141792] BTRFS: Transaction aborted (error -5)
[   47.141799] Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl 
nfs lockd fscache sunrpc snd_usb_audio ext4 crc16 snd_usbmidi_lib 
snd_hwdep mbcache snd_rawmidi snd_seq_device jbd2 snd_pcm snd_timer snd 
soundcore i2c_mv64xxx sun4i_ts sunxi_wdt ohci_platform ohci_hcd 
ehci_platform ehci_hcd autofs4 crc32c_generic btrfs xor zlib_deflate 
raid6_pq sunxi_mmc phy_sun4i_usb sun4i_emac icplus
[   47.141908] CPU: 0 PID: 115 Comm: btrfs-transacti Not tainted 
3.16.0-4-armmp #1 Debian 3.16.7-ckt11-1+deb8u6
[   47.141945] [<c001a230>] (unwind_backtrace) from [<c0014980>] 
(show_stack+0x20/0x24)
[   47.141962] [<c0014980>] (show_stack) from [<c05b9b5c>] 
(dump_stack+0x8c/0x9c)
[   47.141985] [<c05b9b5c>] (dump_stack) from [<c005312c>] 
(warn_slowpath_common+0x80/0x9c)
[   47.142001] [<c005312c>] (warn_slowpath_common) from [<c0053188>] 
(warn_slowpath_fmt+0x40/0x48)
[   47.142067] [<c0053188>] (warn_slowpath_fmt) from [<bf042e14>] 
(__btrfs_abort_transaction+0xb8/0x124 [btrfs])
[   47.142197] [<bf042e14>] (__btrfs_abort_transaction [btrfs]) from 
[<bf071500>] (btrfs_commit_transaction+0x304/0xc38 [btrfs])
[   47.142322] [<bf071500>] (btrfs_commit_transaction [btrfs]) from 
[<bf06d4c4>] (transaction_kthread+0x1b0/0x21c [btrfs])
[   47.142399] [<bf06d4c4>] (transaction_kthread [btrfs]) from 
[<c00742b8>] (kthread+0xe8/0x100)
[   47.142420] [<c00742b8>] (kthread) from [<c0010638>] 
(ret_from_fork+0x14/0x20)
[   47.142429] ---[ end trace bbee7d14b2737876 ]---
[   47.142439] BTRFS: error (device mmcblk0p3) in 
cleanup_transaction:1585: errno=-5 IO failure
[   47.150924] BTRFS info (device mmcblk0p3): delayed_refs has NO entry
[   47.736992] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   47.742961] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   47.750758] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   47.757604] blk_update_request: 238 callbacks suppressed
[   47.757614] end_request: I/O error, dev mmcblk0, sector 9216648
[   47.763558] end_request: I/O error, dev mmcblk0, sector 9216656
[   47.769488] end_request: I/O error, dev mmcblk0, sector 9216664
[   47.775419] end_request: I/O error, dev mmcblk0, sector 9216672
[   47.781346] end_request: I/O error, dev mmcblk0, sector 9216680
[   47.787275] end_request: I/O error, dev mmcblk0, sector 9216688
[   47.793204] btrfs_dev_stat_print_on_error: 8 callbacks suppressed
[   47.793214] BTRFS: bdev /dev/mmcblk0p3 errs: wr 38, rd 0, flush 0, 
corrupt 0, gen 0
[   47.800881] end_request: I/O error, dev mmcblk0, sector 9216696
[   47.806812] end_request: I/O error, dev mmcblk0, sector 9216704
[   47.812739] end_request: I/O error, dev mmcblk0, sector 9216712
[   47.818666] BTRFS: bdev /dev/mmcblk0p3 errs: wr 39, rd 0, flush 0, 
corrupt 0, gen 0
[   47.826328] end_request: I/O error, dev mmcblk0, sector 9216720
[   47.832288] BTRFS: bdev /dev/mmcblk0p3 errs: wr 40, rd 0, flush 0, 
corrupt 0, gen 0
[   47.839957] BTRFS: bdev /dev/mmcblk0p3 errs: wr 41, rd 0, flush 0, 
corrupt 0, gen 0
[   47.847626] BTRFS: bdev /dev/mmcblk0p3 errs: wr 42, rd 0, flush 0, 
corrupt 0, gen 0
[   47.855291] BTRFS: bdev /dev/mmcblk0p3 errs: wr 43, rd 0, flush 0, 
corrupt 0, gen 0
[   47.862954] BTRFS: bdev /dev/mmcblk0p3 errs: wr 44, rd 0, flush 0, 
corrupt 0, gen 0
[   47.870618] BTRFS: bdev /dev/mmcblk0p3 errs: wr 45, rd 0, flush 0, 
corrupt 0, gen 0
[   48.492831] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   48.498797] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   48.506759] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   48.513615] BTRFS: bdev /dev/mmcblk0p2 errs: wr 38, rd 0, flush 0, 
corrupt 0, gen 0
[   48.521291] BTRFS: bdev /dev/mmcblk0p2 errs: wr 39, rd 0, flush 0, 
corrupt 0, gen 0
[   49.110169] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   49.116135] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   49.123964] mmcblk0: timed out sending r/w cmd command, card status 0x900
[   49.712912] sunxi-mmc 1c0f000.mmc: smc 0 err, cmd 25, WR EBE !!
[   49.718877] sunxi-mmc 1c0f000.mmc: data error, sending stop command
[   49.726827] mmcblk0: timed out sending r/w cmd command, card status 0x900
