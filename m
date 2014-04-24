Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53136 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbaDXXHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 19:07:14 -0400
Date: Thu, 24 Apr 2014 16:07:04 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: "'Chris Murphy'" <lists@colorremedies.com>, linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Message-ID: <20140424230704.GK7884@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
 <20140423185413.GF26949@merlins.org>
 <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
 <20140423191546.GG26949@merlins.org>
 <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info>
 <20140424173317.GI7884@merlins.org>
 <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
 <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com>
 <000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 01:22:32AM +0300, Пламен Петров wrote:
> > -----Original Message-----
> > From: Chris Murphy [mailto:lists@colorremedies.com]
> > Sent: Friday, April 25, 2014 12:06 AM
> > To: Пламен Петров
> > Cc: 'Marc MERLIN'; linux-btrfs@vger.kernel.org
> > Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> > newer?
> > 
> > 
> > On Apr 24, 2014, at 12:51 PM, Пламен Петров <plamen@petrovi.no-ip.info>
> > wrote:
> > >
> > > I booted 3.14.1 using sda3 as root, and then tried mounting sda2. It went
> > OK, here is what dmesg said:
> > > [   12.412465] Btrfs loaded
> > 
> > For me, with Btrfs not compiled in the kernel, and with an initramfs, on SSD I
> > get Btrfs loaded at 2.4 seconds. On HDD, it still happens by 6-7 seconds.
> > 
> > So without an initrd and with btrfs compiled into the kernel I'd expect to see
> > Btrfs loaded before 12.4 seconds. Is this an SSD? Or HDD, or hardware raid?
> > 
> > I'd like to see the dmesg from the beginning, until "Btrfs Loaded", for both
> > 3.13.11 and 3.14.1 (via serial console output). I think the clue is in the part
> > before Btrfs loaded.
> > 
> > Also can you post a diff of the config file for the working 3.13.11 and not
> > working 3.14.1 kernels?
> > 
> 
> Attached to this mail find the requested kernel .config files, the result of "duff -u" between them,  as well as the output to serial console of both kernels 3.13.11 and 3.14.1 compiled with attached configs.

Thanks for the serial console logs.
I see that you didn't add rootwait to the command line of your 3.14 boot.

Please do that so that we can see that output.


I'm pasting a diff of them for the benefit of others.
The obvious things to me are:

In 3.13 the device appears after btrfs is loaded:
Btrfs loaded
(...)
scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
scsi target2:0:0: Beginning Domain Validation
scsi target2:0:0: Domain Validation skipping write tests
scsi target2:0:0: Ending Domain Validation
scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 2:0:0:0: [sda] 25165824 512-byte logical blocks: (12.8 GB/12.0 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: Attached scsi generic sg1 type 0
Fusion MPT FC Host driver 3.04.20
Fusion MPT SAS Host driver 3.04.20
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
 sda: sda1 sda2 sda3 sda4

In 3.14 the device shows up before btrfs is loaded:
sd 2:0:0:0: [sda] Cache data unavailable
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] Attached SCSI disk
(...)
Btrfs loaded



--- dmesg-3.13.11-mix64-serial.txt	2014-04-24 16:00:44.442491091 -0700
+++ dmesg-3.14.1-mix64-serial.txt	2014-04-24 16:00:50.394404267 -0700
@@ -1,7 +1,7 @@
 Initializing cgroup subsys cpuset
 Initializing cgroup subsys cpu
 Initializing cgroup subsys cpuacct
-Linux version 3.13.11-mix64 (root@crux) (gcc version 4.7.3 (CRUX-x86_64-multilib) ) #1 SMP Fri Apr 25 00:59:11 EEST 2014
+Linux version 3.14.1-mix64 (root@crux) (gcc version 4.7.3 (CRUX-x86_64-multilib) ) #1 SMP Fri Apr 25 00:31:28 EEST 2014
 Command line: rw root=/dev/sda2 vga=6 raid=noautodetect console=ttyS0,9600n8 console=tty0
 e820: BIOS-provided physical RAM map:
 BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
@@ -190,7 +190,7 @@
 e820: [mem 0x40000000-0xefffffff] available for PCI devices
 Booting paravirtualized kernel on bare hardware
 setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
-PERCPU: Embedded 25 pages/cpu @ffff88003fc00000 s80000 r0 d22400 u262144
+PERCPU: Embedded 25 pages/cpu @ffff88003fc00000 s80192 r0 d22208 u262144
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257897
 Kernel command line: rw root=/dev/sda2 vga=6 raid=noautodetect console=ttyS0,9600n8 console=tty0
 PID hash table entries: 4096 (order: 3, 32768 bytes)
@@ -198,7 +198,7 @@
 Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
 Checking aperture...
 No AGP bridge found
-Memory: 1012808K/1048056K available (7848K kernel code, 519K rwdata, 2604K rodata, 920K init, 2572K bss, 35248K reserved)
+Memory: 1012780K/1048056K available (7943K kernel code, 527K rwdata, 2628K rodata, 932K init, 2580K bss, 35276K reserved)
 SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
 Hierarchical RCU implementation.
 	CONFIG_RCU_FANOUT set to non-default value of 32
@@ -210,16 +210,16 @@
 tsc: Detected 3000.079 MHz processor
 Calibrating delay loop (skipped) preset value.. 6000.15 BogoMIPS (lpj=30000790)
 pid_max: default: 32768 minimum: 301
+ACPI: Core revision 20131218
+ACPI: All ACPI Tables successfully acquired
 Security Framework initialized
 Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
 Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
 Initializing cgroup subsys freezer
 mce: CPU supports 0 MCE banks
 Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
-Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
-tlb_flushall_shift: 4
-ACPI: Core revision 20131115
-ACPI: All ACPI Tables successfully acquired
+Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
+tlb_flushall_shift: 6
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 smpboot: CPU0: AMD Athlon(tm) II X4 640 Processor (fam: 10, model: 05, stepping: 03)
 Performance Events: AMD PMU driver.
@@ -236,22 +236,22 @@
 devtmpfs: initialized
 kworker/u16:0 (14) used greatest stack depth: 6248 bytes left
 xor: measuring software checksum speed
-   prefetch64-sse: 12214.400 MB/sec
-   generic_sse: 11586.000 MB/sec
-xor: using function: prefetch64-sse (12214.400 MB/sec)
+   prefetch64-sse: 12244.000 MB/sec
+   generic_sse: 11621.200 MB/sec
+xor: using function: prefetch64-sse (12244.000 MB/sec)
 NET: Registered protocol family 16
-kworker/u16:0 (24) used greatest stack depth: 5832 bytes left
 cpuidle: using governor ladder
 cpuidle: using governor menu
 ACPI: bus type PCI registered
 PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
 PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
 PCI: Using configuration type 1 for base access
+kworker/u16:0 (42) used greatest stack depth: 5832 bytes left
 bio: create slab <bio-0> at 0
-raid6: sse2x1    4044 MB/s
-raid6: sse2x2    7065 MB/s
-raid6: sse2x4    7603 MB/s
-raid6: using algorithm sse2x4 (7603 MB/s)
+raid6: sse2x1    3955 MB/s
+raid6: sse2x2    6623 MB/s
+raid6: sse2x4    7560 MB/s
+raid6: using algorithm sse2x4 (7560 MB/s)
 raid6: using intx1 recovery algorithm
 ACPI: Added _OSI(Module Device)
 ACPI: Added _OSI(Processor Device)
@@ -557,19 +557,18 @@
 PCLMULQDQ-NI instructions are not detected.
 sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
 sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
+futex hash table entries: 2048 (order: 5, 131072 bytes)
 HugeTLB registered 2 MB page size, pre-allocated 0 pages
 fuse init (API version 7.22)
 SGI XFS with security attributes, large block/inode numbers, no debug enabled
-bio: create slab <bio-1> at 1
-Btrfs loaded
 msgmni has been set to 1978
 Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
 io scheduler noop registered (default)
 io scheduler deadline registered
 crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
-crc32: self tests passed, processed 225944 bytes in 130914 nsec
+crc32: self tests passed, processed 225944 bytes in 131092 nsec
 crc32c: CRC_LE_BITS = 64
-crc32c: self tests passed, processed 225944 bytes in 86154 nsec
+crc32c: self tests passed, processed 225944 bytes in 65503 nsec
 crc32_combine: 8373 self tests passed
 crc32c_combine: 8373 self tests passed
 ACPI: AC Adapter [ACAD] (on-line)
@@ -609,13 +608,13 @@
 e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
 igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
 igb: Copyright (c) 2007-2013 Intel Corporation.
-VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
 ata2.00: configured for UDMA/33
+VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
 Fusion MPT base driver 3.04.20
 Copyright (c) 1999-2008 LSI Corporation
 Fusion MPT SPI Host driver 3.04.20
-mptbase: ioc0: Initiating bringup
 scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
+mptbase: ioc0: Initiating bringup
 sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
 cdrom: Uniform CD-ROM driver Revision: 3.20
 sr 1:0:0:0: Attached scsi generic sg0 type 5
@@ -639,15 +638,15 @@
 ehci-pci: EHCI PCI platform driver
 ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
 ohci-pci: OHCI PCI platform driver
- sda: sda1 sda2 sda3 sda4
 uhci_hcd: USB Universal Host Controller Interface driver
 i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUS] at 0x60,0x64 irq 1,12
+ sda: sda1 sda2 sda3 sda4
 serio: i8042 KBD port at 0x60,0x64 irq 1
 serio: i8042 AUX port at 0x60,0x64 irq 12
+mousedev: PS/2 mouse device common for all mice
 sd 2:0:0:0: [sda] Cache data unavailable
 sd 2:0:0:0: [sda] Assuming drive cache: write through
 sd 2:0:0:0: [sda] Attached SCSI disk
-mousedev: PS/2 mouse device common for all mice
 rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
 rtc_cmos 00:03: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
 md: linear personality registered for level -1
@@ -673,27 +672,35 @@
 Initializing XFRM netlink socket
 NET: Registered protocol family 17
 Key type dns_resolver registered
-rtc_cmos 00:03: setting system clock to 2014-04-25 01:12:53 UTC (1398388373)
+bio: create slab <bio-1> at 1
+Btrfs loaded
+rtc_cmos 00:03: setting system clock to 2014-04-25 00:51:01 UTC (1398387061)
 input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input3
 md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
-btrfs: device fsid 2ba08fbc-4b95-46cc-b638-299f16462620 devid 1 transid 74 /dev/root
-btrfs: disk space caching is enabled
-VFS: Mounted root (btrfs filesystem) on device 0:14.
-devtmpfs: mounted
-Freeing unused kernel memory: 920K (ffffffff81c83000 - ffffffff81d69000)
-Write protecting the kernel read-only data: 12288k
-Freeing unused kernel memory: 332K (ffff8800017ad000 - ffff880001800000)
-Freeing unused kernel memory: 1492K (ffff880001a8b000 - ffff880001c00000)
-mount (1108) used greatest stack depth: 4416 bytes left
-udevd (1115) used greatest stack depth: 4400 bytes left
-udevd[1116]: starting version 182
-udevadm (1117) used greatest stack depth: 4328 bytes left
-btrfs: device fsid 2ba08fbc-4b95-46cc-b638-299f16462620 devid 1 transid 74 /dev/sda2
-btrfs (1175) used greatest stack depth: 4320 bytes left
-btrfs: use zlib compression
-btrfs: disk space caching is enabled
-mount (1176) used greatest stack depth: 4144 bytes left
-btrfs: use zlib compression
-btrfs: disk space caching is enabled
-EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
-rc (1107) used greatest stack depth: 4096 bytes left
+VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
+Please append a correct "root=" boot option; here are the available partitions:
+0b00         1048575 sr0  driver: sr
+0800        12582912 sda  driver: sd
+  0801          204800 sda1 00061e1d-01
+  0802         4703232 sda2 00061e1d-02
+  0803         4726784 sda3 00061e1d-03
+  0804         2947072 sda4 00061e1d-04
+Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,2)
+CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.1-mix64 #1
+Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
+ 0000000000008000 ffff88003f8e1dc8 ffffffff817b4c00 0000000000000001
+ ffffffff819e9650 ffff88003f8e1e48 ffffffff817b05f3 ffffffff81c37d40
+ ffff880000000010 ffff88003f8e1e58 ffff88003f8e1df8 0000000034616473
+Call Trace:
+ [<ffffffff817b4c00>] dump_stack+0x46/0x58
+ [<ffffffff817b05f3>] panic+0xbc/0x1ba
+ [<ffffffff81c9a3e5>] mount_block_root+0x1f4/0x292
+ [<ffffffff81c9a5f9>] mount_root+0x57/0x5b
+ [<ffffffff81c9a75f>] prepare_namespace+0x162/0x19b
+ [<ffffffff81c9a117>] kernel_init_freeable+0x1df/0x1ef
+ [<ffffffff81c99894>] ? do_early_param+0x8c/0x8c
+ [<ffffffff817ab480>] ? rest_init+0x70/0x70
+ [<ffffffff817ab489>] kernel_init+0x9/0xf0
+ [<ffffffff817bda8c>] ret_from_fork+0x7c/0xb0
+ [<ffffffff817ab480>] ? rest_init+0x70/0x70
+Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
