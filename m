From: Eric Whitney <eric.whitney@hp.com>
Subject: PROBLEM:  oops on attempt to mount badly formed filesystem
Date: Fri, 05 Dec 2008 11:51:11 -0500
Message-ID: <49395BFF.8070800@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris:

I can consistently generate oopses (null pointer dereferenced) when 
attempting to mount a badly formed multi-device filesystem using kernels 
built from the current btrfs-unstable.  "Badly formed" means that mkfs 
was given six legitimate device names and one non-existent device name 
as arguments.  mkfs reported an error for the non-existent device, but 
apparently left a damaged btrfs filesystem behind.  This bug is easily 
reproduced - simply attempt to mkfs with a non-existent device name, and 
then attempt to mount (example below with the oops).

Once the oops occurs, the system remains responsive, but must be reset 
to reboot.  I've also noted that btrfs-show reports four devices for the 
badly formed filesystem in this example and then proceeds to list 
details for six devices.

The system is a dual socket, quad core Intel machine with an attached 
hardware RAID controller.  The latter supplies six single disk volumes 
used for the filesystem in this test.

Particulars follow - please let me know if you'd like more information, etc.

Thanks,
Eric


Commit:
c99e905c945c462085c6d64646dc5af0c0a16815

uname -a:
Linux bl460cb 2.6.28-rc5-btrfs-unstable #1 SMP Wed Dec 3 11:08:13 EST 
2008 x86_64 GNU/Linux

oops as taken from the console, including mkfs and mount commands preceding:

root@bl460cb:~# mkfs.btrfs /dev/cciss/c1d0 /dev/cciss/c1d1 
/dev/cciss/c1d2 /dev/cciss/c1d3 /dev/cciss/c1d4 /dev/cciss/c1d5 
/dev/cciss/c1d6
adding device /dev/cciss/c1d1 id 2
adding device /dev/cciss/c1d2 id 3
adding device /dev/cciss/c1d3 id 4
adding device /dev/cciss/c1d4 id 5
adding device /dev/cciss/c1d5 id 6
error checking /dev/cciss/c1d6 mount status
root@bl460cb:~# mount /dev/cciss/c1d5 /mnt
[  158.264455] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000300
[  158.268996] IP: [<ffffffff802e34a7>] bio_get_nr_vecs+0x7/0x40
[  158.274050] PGD 8215de067 PUD 827dfb067 PMD 0
[  158.274206] Oops: 0000 [#1] SMP
[  158.274206] last sysfs file: /sys/block/loop7/removable
[  158.274206] CPU 4
[  158.274206] Modules linked in: iptable_filter ip_tables x_tables 
parport_pc lp parport loop ipmi_devintf ipmi_si iTCO_wdt 
iTCO_vendor_support ipv6 ipmi_msghandler pcspkr serio_raw i5000_edac 
edac_core psmouse container shpchp button pci_hotplug evdev ext3 jbd 
mbcache usbhid hid ehci_hcd uhci_hcd bnx2 usbcore cciss scsi_mod thermal 
processor fan thermal_sys fuse
[  158.274206] Pid: 5188, comm: mount Not tainted 
2.6.28-rc5-btrfs-unstable #1
[  158.274206] RIP: 0010:[<ffffffff802e34a7>]  [<ffffffff802e34a7>] 
bio_get_nr_vecs+0x7/0x40
[  158.274206] RSP: 0018:ffff880823d5ba10  EFLAGS: 00010246
[  158.274206] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000002028
[  158.274206] RDX: ffffffff80354620 RSI: ffff88082a448038 RDI: 
ffff88082c797000
[  158.274206] RBP: 0000000000000000 R08: 0000000000001000 R09: 
0000000000000000
[  158.274206] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff880823d5bbd8
[  158.274206] R13: 0000000000000100 R14: 0000000000000000 R15: 
0000000000002028
[  158.274206] FS:  00007f701db2a780(0000) GS:ffff88082c862900(0000) 
knlGS:0000000000000000
[  158.274206] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  158.274206] CR2: 0000000000000300 CR3: 0000000827ddf000 CR4: 
00000000000006e0
[  158.274206] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  158.274206] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  158.274206] Process mount (pid: 5188, threadinfo ffff880823d5a000, 
task ffff88081f95be80)
[  158.274206] Stack:
[  158.274206]  ffffffff80350cf2 0000000000405000 0000000000405fff 
ffffffff80354620
[  158.274206]  ffff88082c797000 0000000000000000 ffffe2001c88eac0 
ffff88082a448038
[  158.274206]  0000000000000000 0000000000001000 ffff88082a417058 
0000000000405000
[  158.274206] Call Trace:
[  158.274206]  [<ffffffff80350cf2>] submit_extent_page+0x222/0x2c0
[  158.274206]  [<ffffffff80354620>] end_bio_extent_readpage+0x0/0x1d0
[  158.274206]  [<ffffffff80351e37>] __extent_read_full_page+0x2e7/0x6a0
[  158.274206]  [<ffffffff80354620>] end_bio_extent_readpage+0x0/0x1d0
[  158.274206]  [<ffffffff803356f0>] btree_get_extent+0x0/0x1f0
[  158.274206]  [<ffffffff8035384e>] read_extent_buffer_pages+0x1be/0x3e0
[  158.274206]  [<ffffffff803356f0>] btree_get_extent+0x0/0x1f0
[  158.274206]  [<ffffffff803337e0>] 
btree_read_extent_buffer_pages+0x50/0xc0
[  158.274206]  [<ffffffff80333b15>] read_tree_block+0x35/0x70
[  158.274206]  [<ffffffff8033711b>] open_ctree+0xb9b/0xed0
[  158.274206]  [<ffffffff802bf306>] sget+0x396/0x3f0
[  158.274206]  [<ffffffff802bfdf0>] set_anon_super+0x0/0xc0
[  158.274206]  [<ffffffff8031aedc>] btrfs_get_sb+0x35c/0x4a0
[  158.274206]  [<ffffffff80295794>] kstrdup+0x54/0x120
[  158.274206]  [<ffffffff802bf8c8>] vfs_kern_mount+0x78/0x160
[  158.274206]  [<ffffffff802bfa13>] do_kern_mount+0x53/0x110
[  158.274206]  [<ffffffff802d53b2>] do_mount+0x542/0x810
[  158.274206]  [<ffffffff802d571b>] sys_mount+0x9b/0x100
[  158.274206]  [<ffffffff8020c1eb>] system_call_fastpath+0x16/0x1b
[  158.274206] Code: 83 c4 18 4c 89 f7 5b 5d 41 5c 41 5d 41 5e 41 5f e9 
af e9 ff ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 98 00 
00 00 <48> 8b 88 00 03 00 00 8b 81 cc 02 00 00 0f b7 91 d6 02 00 00 0f
[  158.274206] RIP  [<ffffffff802e34a7>] bio_get_nr_vecs+0x7/0x40
[  158.274206]  RSP <ffff880823d5ba10>
[  158.274206] CR2: 0000000000000300
[  158.430189] ---[ end trace dcfa48815a956024 ]---
Killed
root@bl460cb:~#


btrfs-show taken after the oops:

Label: none  uuid: 3a0bde17-9d1f-46f8-9657-34f37016e707
	Total devices 4 FS bytes used 20.00KB
	devid    4 size 68.33GB used 0.00 path /dev/cciss/c1d3
	devid    2 size 68.33GB used 0.00 path /dev/cciss/c1d1
	devid    5 size 68.33GB used 0.00 path /dev/cciss/c1d4
	devid    1 size 68.33GB used 20.00MB path /dev/cciss/c1d0
	devid    6 size 68.33GB used 0.00 path /dev/cciss/c1d5
	devid    3 size 68.33GB used 0.00 path /dev/cciss/c1d2

Btrfs v0.16-25-gd45ee76

