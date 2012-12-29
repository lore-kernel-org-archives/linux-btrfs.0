Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:45672 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972Ab2L2TyX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 14:54:23 -0500
From: Henri Valta <henri.valta@kemi.fi>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG during log recovery
Date: Sat, 29 Dec 2012 21:54:16 +0200
Message-ID: <15777623.FW7ALV9xFc@lap2arch>
In-Reply-To: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
References: <CAMQ-g0fNocHwEvbeDAf-HK+Nh4XcQDDD7Mi_ZxDSqv-moFKn5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 14 December 2012 23:04:08 Jan Steffens wrote:
> After a lockup requiring a hard reset, the btrfs could not be mounted,
> throwing the following error:
> 

> Bug affected at least 3.6.10, 3.7.0, i686 and x86_64.
> 
> btrfs-zero-log made the FS mountable again.

I've just encountered the same problem after a hard reset on kernel 3.7.1. Had 
to use btrfs-zero-log to get the fs mounted again.
I dont know if the following traces provide any new information, but in my 
case the BUG was preceded by two warnings in fs/inode.c

[    3.626537] ------------[ cut here ]------------
[    3.626544] WARNING: at fs/inode.c:336 inc_nlink+0x36/0x50()
[    3.626546] Hardware name: 2768WZP
[    3.626547] Modules linked in: btrfs crc32c libcrc32c zlib_deflate sr_mod 
cdrom sd_mod ata_generic uhci_hcd pata_acpi ata_piix libata firewire_ohci 
scsi_mod firewire_core crc_itu_t ehci_hcd usbcore usb_common
[    3.626561] Pid: 101, comm: mount Not tainted 3.7.1-2-ARCH #1
[    3.626562] Call Trace:
[    3.626567]  [<ffffffff8105742f>] warn_slowpath_common+0x7f/0xc0
[    3.626569]  [<ffffffff8105748a>] warn_slowpath_null+0x1a/0x20
[    3.626572]  [<ffffffff8119c5c6>] inc_nlink+0x36/0x50
[    3.626588]  [<ffffffffa01b5af0>] link_to_fixup_dir+0xc0/0xf0 [btrfs]
[    3.626597]  [<ffffffffa01b87cf>] replay_one_buffer+0x1df/0x3a0 [btrfs]
[    3.626606]  [<ffffffffa01b5292>] walk_down_log_tree+0x212/0x400 [btrfs]
[    3.626615]  [<ffffffffa01b551d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[    3.626624]  [<ffffffffa01bb89b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[    3.626633]  [<ffffffffa01b85f0>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[    3.626643]  [<ffffffffa01819d7>] open_ctree+0x1587/0x1ba0 [btrfs]
[    3.626646]  [<ffffffff8124f3a1>] ? disk_name+0x61/0xc0
[    3.626653]  [<ffffffffa015aae3>] btrfs_mount+0x633/0x770 [btrfs]
[    3.626657]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    3.626659]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    3.626662]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    3.626669]  [<ffffffffa015a63a>] btrfs_mount+0x18a/0x770 [btrfs]
[    3.626679]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    3.626681]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    3.626683]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    3.626686]  [<ffffffff811a2054>] do_kern_mount+0x54/0x110
[    3.626688]  [<ffffffff811a3cd5>] do_mount+0x315/0x8e0
[    3.626691]  [<ffffffff81124ade>] ? __get_free_pages+0xe/0x50
[    3.626693]  [<ffffffff811a382a>] ? copy_mount_options+0x3a/0x180
[    3.626696]  [<ffffffff811a432e>] sys_mount+0x8e/0xe0
[    3.626699]  [<ffffffff814aa49d>] system_call_fastpath+0x1a/0x1f
[    3.626701] ---[ end trace de80422f3d9139a8 ]---
[    3.635863] ------------[ cut here ]------------
[    3.635866] WARNING: at fs/inode.c:336 inc_nlink+0x36/0x50()
[    3.635867] Hardware name: 2768WZP
[    3.635868] Modules linked in: btrfs crc32c libcrc32c zlib_deflate sr_mod 
cdrom sd_mod ata_generic uhci_hcd pata_acpi ata_piix libata firewire_ohci 
scsi_mod firewire_core crc_itu_t ehci_hcd usbcore usb_common
[    3.635878] Pid: 101, comm: mount Tainted: G        W    3.7.1-2-ARCH #1
[    3.635879] Call Trace:
[    3.635882]  [<ffffffff8105742f>] warn_slowpath_common+0x7f/0xc0
[    3.635884]  [<ffffffff8105748a>] warn_slowpath_null+0x1a/0x20
[    3.635886]  [<ffffffff8119c5c6>] inc_nlink+0x36/0x50
[    3.635895]  [<ffffffffa01b5af0>] link_to_fixup_dir+0xc0/0xf0 [btrfs]
[    3.635903]  [<ffffffffa01b87cf>] replay_one_buffer+0x1df/0x3a0 [btrfs]
[    3.635912]  [<ffffffffa01b5292>] walk_down_log_tree+0x212/0x400 [btrfs]
[    3.635921]  [<ffffffffa01b551d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[    3.635930]  [<ffffffffa01bb89b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[    3.635939]  [<ffffffffa01b85f0>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[    3.635948]  [<ffffffffa01819d7>] open_ctree+0x1587/0x1ba0 [btrfs]
[    3.635950]  [<ffffffff8124f3a1>] ? disk_name+0x61/0xc0
[    3.635958]  [<ffffffffa015aae3>] btrfs_mount+0x633/0x770 [btrfs]
[    3.635960]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    3.635963]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    3.635965]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    3.635972]  [<ffffffffa015a63a>] btrfs_mount+0x18a/0x770 [btrfs]
[    3.635974]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    3.635977]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    3.635979]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    3.635981]  [<ffffffff811a2054>] do_kern_mount+0x54/0x110
[    3.635983]  [<ffffffff811a3cd5>] do_mount+0x315/0x8e0
[    3.635986]  [<ffffffff81124ade>] ? __get_free_pages+0xe/0x50
[    3.635988]  [<ffffffff811a382a>] ? copy_mount_options+0x3a/0x180
[    3.635990]  [<ffffffff811a432e>] sys_mount+0x8e/0xe0
[    3.635993]  [<ffffffff814aa49d>] system_call_fastpath+0x1a/0x1f
[    3.635994] ---[ end trace de80422f3d9139a9 ]---
[    3.720010] usb 6-2: new low-speed USB device number 2 using uhci_hcd
[    3.904094] usbcore: registered new interface driver usbhid
[    3.904097] usbhid: USB HID core driver
[    3.904696] input: Logitech USB-PS/2 Optical Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input1
[    3.905020] hid-generic 0003:046D:C03E.0001: input,hidraw0: USB HID v1.10 
Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-2/input0
[    5.233306] ------------[ cut here ]------------
[    5.233365] kernel BUG at fs/btrfs/extent-tree.c:6185!
[    5.233417] invalid opcode: 0000 [#1] PREEMPT SMP 
[    5.233607] Modules linked in: hid_generic usbhid hid btrfs crc32c 
libcrc32c zlib_deflate sr_mod cdrom sd_mod ata_generic uhci_hcd pata_acpi 
ata_piix libata firewire_ohci scsi_mod firewire_core crc_itu_t ehci_hcd usbcore 
usb_common
[    5.234738] CPU 1 
[    5.234789] Pid: 101, comm: mount Tainted: G        W    3.7.1-2-ARCH #1 
LENOVO 2768WZP/2768WZP
[    5.234890] RIP: 0010:[<ffffffffa01720a7>]  [<ffffffffa01720a7>] 
btrfs_alloc_logged_file_extent+0x1c7/0x1e0 [btrfs]
[    5.235009] RSP: 0018:ffff88013141d5e8  EFLAGS: 00010286
[    5.235061] RAX: 00000000fffffff5 RBX: ffff8801348b1200 RCX: 0000000180400033
[    5.235115] RDX: 0000000180400034 RSI: 0000000080400033 RDI: ffff8801348c69c0
[    5.235168] RBP: ffff88013141d668 R08: ffff88013141dfd8 R09: ffff880135b4fb00
[    5.235221] R10: ffffffffa01be91c R11: ffff88013141dfd8 R12: ffff88013141d733
[    5.235280] R13: 0000000000000000 R14: 0000000048f65000 R15: ffff880131481000
[    5.235339] FS:  00007f23b536f780(0000) GS:ffff88013bc80000(0000) 
knlGS:0000000000000000
[    5.235403] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.235460] CR2: 00007fe808929000 CR3: 0000000134a71000 CR4: 
00000000000407e0
[    5.235518] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    5.235577] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.235636] Process mount (pid: 101, threadinfo ffff88013141c000, task 
ffff880134b0a8a0)
[    5.235699] Stack:
[    5.235753]  0000000000000001 0000000000002000 ffff88013141d618 ffffffffa015e1ea
[    5.236001]  000000000003c000 00000000000003ff 0000000000000101 
ffff880131db3000
[    5.236249]  0000000000002000 00ff880131dfcac0 a80000000048f650 
ffff880131481000
[    5.236497] Call Trace:
[    5.236559]  [<ffffffffa015e1ea>] ? btrfs_free_path+0x2a/0x40 [btrfs]
[    5.236615]  [<ffffffffa01b7840>] replay_one_extent+0x620/0x690 [btrfs]
[    5.236615]  [<ffffffffa01b6e78>] ? add_inode_ref+0x638/0x9e0 [btrfs]
[    5.236615]  [<ffffffffa0192940>] ? btrfs_destroy_inode+0x1c0/0x2e0 [btrfs]
[    5.236615]  [<ffffffffa01a1f73>] ? read_extent_buffer+0xc3/0x120 [btrfs]
[    5.236615]  [<ffffffffa01b88cb>] replay_one_buffer+0x2db/0x3a0 [btrfs]
[    5.236615]  [<ffffffffa01a086d>] ? alloc_extent_buffer+0x9d/0x490 [btrfs]
[    5.236615]  [<ffffffffa01b5292>] walk_down_log_tree+0x212/0x400 [btrfs]
[    5.236615]  [<ffffffffa01b551d>] walk_log_tree+0x9d/0x1f0 [btrfs]
[    5.236615]  [<ffffffffa01bb89b>] btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
[    5.236615]  [<ffffffffa01b85f0>] ? replay_one_dir_item+0xf0/0xf0 [btrfs]
[    5.236615]  [<ffffffffa01819d7>] open_ctree+0x1587/0x1ba0 [btrfs]
[    5.236615]  [<ffffffff8124f3a1>] ? disk_name+0x61/0xc0
[    5.236615]  [<ffffffffa015aae3>] btrfs_mount+0x633/0x770 [btrfs]
[    5.236615]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    5.236615]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    5.236615]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    5.236615]  [<ffffffffa015a63a>] btrfs_mount+0x18a/0x770 [btrfs]
[    5.236615]  [<ffffffff81165280>] ? alloc_pages_current+0xb0/0x120
[    5.236615]  [<ffffffff81187353>] mount_fs+0x43/0x1b0
[    5.236615]  [<ffffffff811a1af4>] vfs_kern_mount+0x74/0x110
[    5.236615]  [<ffffffff811a2054>] do_kern_mount+0x54/0x110
[    5.236615]  [<ffffffff811a3cd5>] do_mount+0x315/0x8e0
[    5.236615]  [<ffffffff81124ade>] ? __get_free_pages+0xe/0x50
[    5.236615]  [<ffffffff811a382a>] ? copy_mount_options+0x3a/0x180
[    5.236615]  [<ffffffff811a432e>] sys_mount+0x8e/0xe0
[    5.236615]  [<ffffffff814aa49d>] system_call_fastpath+0x1a/0x1f
[    5.236615] Code: 0b 0f 1f 00 48 8d bb 80 00 00 00 e8 c4 68 ff ff 85 c0 74 1d 
48 8b 55 c0 4c 89 f6 48 89 df e8 b1 c6 04 00 85 c0 0f 84 29 ff ff ff <0f> 0b 0f 
0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 66 2e 0f 1f 84 00 
[    5.236615] RIP  [<ffffffffa01720a7>] btrfs_alloc_logged_file_extent+0x1c7/0x1e0 
[btrfs]
[    5.236615]  RSP <ffff88013141d5e8>
[    5.241501] ---[ end trace de80422f3d9139aa ]---
