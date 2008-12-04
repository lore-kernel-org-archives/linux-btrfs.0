From: Eric Whitney <eric.whitney@hp.com>
Subject: PROBLEM:  oops when running fsstress against compressed btrfs filesystem
Date: Thu, 04 Dec 2008 17:59:04 -0500
Message-ID: <493860B8.4040309@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris:

I'm consistently getting oopses when running fsstress against both 
single and multiple device compressed btrfs filesystems using kernels 
built from the current btrfs-unstable.

In this report, I'm describing an incident with a single device 
filesystem.  Once the oops occurs, all I/O appears to stop though iowait 
is still reported, and fsstress does not make apparent forward progress. 
  The system otherwise remains responsive.

The system is a dual socket, quad core Intel machine with an attached 
hardware RAID controller.  The latter supplies a six disk RAID0 volume 
used for the filesystem.

Particulars follow - please let me know if you'd like more information, etc.

Thanks,
Eric


Commit:
c99e905c945c462085c6d64646dc5af0c0a16815


uname -a:
Linux bl460ca 2.6.28-rc5-btrfs #1 SMP Wed Dec 3 10:58:25 EST 2008 x86_64 
GNU/Linux


mounted as:
/dev/cciss/c1d0p1 on /mnt type btrfs (rw,compress)


btrfs-show:
Label: none  uuid: f5131dbb-77a0-4a73-b94e-7b80406f9409
	Total devices 1 FS bytes used 1.01GB
	devid    1 size 410.01GB used 4.04GB path /dev/cciss/c1d0p1

Btrfs v0.16-25-gd45ee76


oops as taken from the console:

[12812.257559] stack segment: 0000 [#1] SMP
[12812.264366] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:01:04.6/class
[12812.265344] CPU 6
[12812.265344] Modules linked in: iptable_filter ip_tables x_tables 
parport_pc lp parport loop ipmi_devintf ipmi_si psmouse serio_raw ipv6 
iTCO_wdt i5000_edac ipmi_msghandler iTCO_vendor_support shpchp pcspkr 
button edac_core container pci_hotplug evdev ext3 jbd mbcache usbhid hid 
ehci_hcd uhci_hcd bnx2 usbcore cciss scsi_mod dm_mirror dm_region_hash 
dm_log dm_snapshot dm_mod thermal processor fan thermal_sys fuse
[12812.265344] Pid: 8175, comm: btrfs-delalloc- Not tainted 
2.6.28-rc5-btrfs #1
[12812.265344] RIP: 0010:[<ffffffff803ba943>]  [<ffffffff803ba943>] 
fill_window+0x143/0x480
[12812.265344] RSP: 0018:ffff8807b44dfc80  EFLAGS: 00010212
[12812.265344] RAX: 0000000000001000 RBX: 0000000000001000 RCX: 
b6e3880000000000
[12812.265344] RDX: 0000000000000001 RSI: 0000000000001000 RDI: 
0000000000000000
[12812.265344] RBP: b6e3880000000000 R08: 0000000000000000 R09: 
0000000000000000
[12812.265344] R10: 0000000000000010 R11: ffffc200145954bc R12: 
0000000000000003
[12812.265344] R13: 0000000000000001 R14: 0000000000000003 R15: 
000000000000fe12
[12812.265344] FS:  0000000000000000(0000) GS:ffff88082c863000(0000) 
knlGS:0000000000000000
[12812.265344] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[12812.265344] CR2: 00007f75e001e068 CR3: 000000028309e000 CR4: 
00000000000006e0
[12812.265344] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[12812.265344] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[12812.265344] Process btrfs-delalloc- (pid: 8175, threadinfo 
ffff8807b44de000, task ffff88081f44b840)
[12812.265344] Stack:
[12812.265344]  0000000200000000 0000000000008000 b6e3880000000000 
0000000000000017
[12812.265344]  ffffc20014595b04 ffffc20014595000 ffff8808290c7e60 
00008000803bc25c
[12812.333446]  00000000000065d1 ffffffff8052ba60 0000000000000011 
ffffc200145959b0
[12812.333446] Call Trace:
[12812.333446]  [<ffffffff803bb36e>] ? deflate_fast+0x24e/0x2e0
[12812.333446]  [<ffffffff803bb6a2>] ? zlib_deflate+0x112/0x330
[12812.333446]  [<ffffffff80365078>] ? btrfs_zlib_compress_pages+0x158/0x3b0
[12812.333446]  [<ffffffff802b6d42>] ? __slab_free+0x212/0x360
[12812.333446]  [<ffffffff80341445>] ? compress_file_range+0x405/0x500
[12812.333446]  [<ffffffff80252a79>] ? autoremove_wake_function+0x9/0x30
[12812.333446]  [<ffffffff8034156e>] ? async_cow_start+0x2e/0x50
[12812.333446]  [<ffffffff8035b9f1>] ? worker_loop+0x61/0x160
[12812.333446]  [<ffffffff8035b990>] ? worker_loop+0x0/0x160
[12812.333446]  [<ffffffff8025263b>] ? kthread+0x4b/0x80
[12812.333446]  [<ffffffff8020d149>] ? child_rip+0xa/0x11
[12812.333446]  [<ffffffff80375770>] ? cap_inode_permission+0x0/0x10
[12812.333446]  [<ffffffff802525f0>] ? kthread+0x0/0x80
[12812.333446]  [<ffffffff8020d13f>] ? child_rip+0x0/0x11
[12812.333446] Code: 8b 5c 24 78 89 5c 24 7c 81 7c 24 7c b0 15 00 00 b8 
b0 15 00 00 0f 46 44 24 7c 29 44 24 7c 83 f8 0f 89 44 24 74 0f 8e ec 00 
00 00 <0f> b6 45 00 0f b6 55 01 49 8d 04 07 48 8d 14 10 48 03 44 24 40
[12812.333446] RIP  [<ffffffff803ba943>] fill_window+0x143/0x480
[12812.333446]  RSP <ffff8807b44dfc80>
[12812.390091] ---[ end trace bd4a99fac175a076 ]---
[12812.394041] note: btrfs-delalloc-[8175] exited with preempt_count 1






