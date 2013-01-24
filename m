Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18369 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab3AXBAE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 20:00:04 -0500
Date: Thu, 24 Jan 2013 08:57:32 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: "F. Frederich" <F.Frederich@unicomp-berlin.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: unmountable filesystem with kernel 3.7.3
Message-ID: <20130124005731.GB28406@liubo>
Reply-To: bo.li.liu@oracle.com
References: <510036A4.9050202@unicomp-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510036A4.9050202@unicomp-berlin.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 08:14:44PM +0100, F. Frederich wrote:
> Hi,
> 
> os: Gentoo
> kernel: 3.7.3 from kernel.org
> 2 harddisks with btrfs and Raid1, lzo compression
> 
> trying to start a virtual machine (qemu-kvm) the system crashed
> giving following messages:
> 
> kernel: [177417.378526] ------------[ cut here ]------------
> kernel: [177417.378562] kernel BUG at fs/btrfs/ctree.c:2950!
> kernel: [177417.378579] invalid opcode: 0000 [#1] SMP
> kernel: [177417.378599] Modules linked in: it87 hwmon_vid k10temp i2c_piix4
> kernel: [177417.378630] CPU 2
> kernel: [177417.378645] Pid: 13388, comm: qemu-system-x86 Not
> tainted 3.7.3-system #2 Gigabyte Technology Co., Ltd.
> GA-MA790XT-UD4P/GA-MA790XT-UD4P
> kernel: [177417.378673] RIP: 0010:[<ffffffff8137e278>]
> [<ffffffff8137e278>] btrfs_set_item_key_safe+0x168/0x170
> kernel: [177417.378708] RSP: 0018:ffff88011149d8a8  EFLAGS: 00010286
> kernel: [177417.378723] RAX: 00000000ffffffff RBX: 000000000000000c
> RCX: 000000003e999000
> kernel: [177417.378744] RDX: 00000000ffffffff RSI: ffff88011149d9d6
> RDI: ffff88011149d887
> kernel: [177417.378761] RBP: ffff88011149d908 R08: 0000000000000d3d
> R09: ffff88011149d8c8
> kernel: [177417.378778] R10: 0000000000000000 R11: 0000000000000000
> R12: ffff8802026aaec8
> kernel: [177417.378795] R13: ffff88011149d9d6 R14: ffff88011149d8c7
> R15: ffff880426c37b40
> kernel: [177417.378813] FS:  00007f3e7abdb700(0000)
> GS:ffff880437d00000(0000) knlGS:0000000000000000
> kernel: [177417.378831] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: [177417.378846] CR2: 00007f3e3801e138 CR3: 00000001cc7dc000
> CR4: 00000000000007e0
> kernel: [177417.378863] DR0: 0000000000000045 DR1: 0000000000000000
> DR2: 0000000000000000
> kernel: [177417.378880] DR3: 0000000000000005 DR6: 00000000ffff0ff0
> DR7: 0000000000000400
> kernel: [177417.378898] Process qemu-system-x86 (pid: 13388,
> threadinfo ffff88011149c000, task ffff8801a3053600)
> kernel: [177417.378916] Stack:
> kernel: [177417.378925]  ffff88011149d908 ffff8804064c1800
> ffff88002cbb4000 3000000000000000
> kernel: [177417.378953]  6c00000000000aef 000000003e998000
> ffff88011149d908 ffff880426c37b40
> kernel: [177417.378981]  ffff8802026aaec8 000000003e998000
> 0000000000000001 0000000000000000
> kernel: [177417.379007] Call Trace:
> kernel: [177417.379025]  [<ffffffff813b17fb>]
> __btrfs_drop_extents+0x58b/0xb20
> kernel: [177417.379046]  [<ffffffff813d25c5>]
> btrfs_log_changed_extents+0x625/0x690
> kernel: [177417.379066]  [<ffffffff813bc2b2>] ? free_extent_buffer+0x32/0x90
> kernel: [177417.379085]  [<ffffffff813d45d3>] btrfs_log_inode+0x513/0x5b0
> kernel: [177417.379104]  [<ffffffff819f1c84>] ? __schedule+0x2a4/0x6a0
> kernel: [177417.379123]  [<ffffffff813d6198>]
> btrfs_log_inode_parent+0x188/0x470
> kernel: [177417.379142]  [<ffffffff813d64bf>]
> btrfs_log_dentry_safe+0x3f/0x60
> kernel: [177417.379160]  [<ffffffff813af2c2>] btrfs_sync_file+0x122/0x230
> kernel: [177417.379181]  [<ffffffff81191d70>] generic_write_sync+0x50/0x70
> kernel: [177417.379198]  [<ffffffff813b0886>]
> btrfs_file_aio_write+0x2c6/0x490
> kernel: [177417.379217]  [<ffffffff810c3c4e>] ? get_futex_key+0x7e/0x250
> kernel: [177417.379237]  [<ffffffff8116526b>] do_sync_write+0x9b/0xe0
> kernel: [177417.379255]  [<ffffffff811658de>] vfs_write+0xae/0x170
> kernel: [177417.379272]  [<ffffffff81165d6a>] sys_pwrite64+0x9a/0xa0
> kernel: [177417.379290]  [<ffffffff819f3a92>] system_call_fastpath+0x16/0x1b
> kernel: [177417.379305] Code: 89 d0 48 c1 e0 05 48 29 c8 b9 11 00 00
> 00 48 8d 54 02 65 e8 eb f0 03 00 4c 89 ee 4c 89 f7 e8 70 f2 ff ff 85
> c0 0f 8f 41 ff ff ff <0f> 0b 0f 0b 0f 1f 40 00 55 48 b8 00 00 00 00
> 00 16 00 00 48 89
> kernel: [177417.379526] RIP  [<ffffffff8137e278>]
> btrfs_set_item_key_safe+0x168/0x170
> kernel: [177417.379547]  RSP <ffff88011149d8a8>
> kernel: [177417.407514] ---[ end trace 9e7b00faf79e316d ]---
> 
> trying to mount the filesystem after a restart failed with following
> messages:
> 
> kernel: [   56.481202] device label BTRFS devid 3 transid 78332 /dev/sdc
> kernel: [   56.482323] btrfs: use lzo compression
> kernel: [   56.482330] btrfs: disk space caching is enabled
> kernel: [   61.926886] btrfs: corrupt leaf, bad key order:
> block=2177786388480,root=1, slot=12
> kernel: [   61.926925] ------------[ cut here ]------------
> kernel: [   61.927356] kernel BUG at fs/btrfs/tree-log.c:3832!
> kernel: [   61.927780] invalid opcode: 0000 [#1] SMP
> kernel: [   61.927787] Modules linked in: it87 hwmon_vid k10temp i2c_piix4
> kernel: [   61.927797] CPU 1
> kernel: [   61.927797] Pid: 3816, comm: mount Not tainted
> 3.7.3-system #2 Gigabyte Technology Co., Ltd.
> GA-MA790XT-UD4P/GA-MA790XT-UD4P
> kernel: [   61.927811] RIP: 0010:[<ffffffff813d685a>]
> [<ffffffff813d685a>] btrfs_recover_log_trees+0x37a/0x3e0
> kernel: [   61.927814] RSP: 0018:ffff880417625958  EFLAGS: 00010282
> kernel: [   61.927824] RAX: 00000000fffffffb RBX: ffff880426c58900
> RCX: 0000000000002c6f
> kernel: [   61.927827] RDX: 0000000000002c6e RSI: ffff880426c58990
> RDI: ffffea00109b1600
> kernel: [   61.927829] RBP: ffff880417625a18 R08: 0000000000017970
> R09: ffffffff8137b295
> kernel: [   61.927831] R10: 0000000000000000 R11: 0000000000000001
> R12: 0000000000000001
> kernel: [   61.927833] R13: ffff88041d8bd130 R14: ffff88041b98d800
> R15: ffff88041b98c000
> kernel: [   61.927837] FS:  00007f0500ff3740(0000)
> GS:ffff880437c80000(0000) knlGS:0000000000000000
> kernel: [   61.927839] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: [   61.927841] CR2: 00007ffffe1ad5f0 CR3: 0000000419c9a000
> CR4: 00000000000007e0
> kernel: [   61.927843] DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> kernel: [   61.927846] DR3: 0000000000000000 DR6: 00000000ffff0ff0
> DR7: 0000000000000400
> kernel: [   61.927849] Process mount (pid: 3816, threadinfo
> ffff880417624000, task ffff88041a78ca40)
> kernel: [   61.927850] Stack:
> kernel: [   61.927855]  ffff880415989d90 ffff88041fe2e000
> 0000000000000000 0000000000000000
> kernel: [   61.927858]  0000000000000000 0000000000000001
> ffff88041b98a800 ffff88041d8bd130
> kernel: [   61.927862]  ffffffff813d51a0 fffffffa000131fd
> ffffff84ffffffff fffffaffffffffff
> kernel: [   61.927863] Call Trace:
> kernel: [   61.927871]  [<ffffffff813d51a0>] ?
> fixup_inode_link_counts+0x160/0x160
> kernel: [   61.927879]  [<ffffffff8139e04b>] open_ctree+0x151b/0x1bd0
> kernel: [   61.927886]  [<ffffffff814631b6>] ? ida_get_new_above+0x236/0x2f0
> kernel: [   61.927892]  [<ffffffff81377d5d>] btrfs_mount+0x5bd/0x690
> kernel: [   61.927897]  [<ffffffff8111e7d7>] ? __free_pages+0x47/0x70
> kernel: [   61.927904]  [<ffffffff8141178c>] ?
> selinux_sb_copy_data+0x17c/0x230
> kernel: [   61.927910]  [<ffffffff8116904e>] mount_fs+0x3e/0x1b0
> kernel: [   61.927917]  [<ffffffff81181a3b>] vfs_kern_mount+0x5b/0xf0
> kernel: [   61.927921]  [<ffffffff81377900>] btrfs_mount+0x160/0x690
> kernel: [   61.927925]  [<ffffffff8111e7d7>] ? __free_pages+0x47/0x70
> kernel: [   61.927930]  [<ffffffff8141178c>] ?
> selinux_sb_copy_data+0x17c/0x230
> kernel: [   61.927936]  [<ffffffff8116904e>] mount_fs+0x3e/0x1b0
> kernel: [   61.927942]  [<ffffffff81181a3b>] vfs_kern_mount+0x5b/0xf0
> kernel: [   61.927947]  [<ffffffff8118223f>] do_kern_mount+0x4f/0x100
> kernel: [   61.927953]  [<ffffffff81183b9c>] do_mount+0x19c/0x880
> kernel: [   61.927958]  [<ffffffff81183885>] ? copy_mount_options+0x35/0x170
> kernel: [   61.927964]  [<ffffffff8118430b>] sys_mount+0x8b/0xe0
> kernel: [   61.927970]  [<ffffffff819f3a92>] system_call_fastpath+0x16/0x1b
> kernel: [   61.928006] Code: 4c 89 ef 48 8b 72 28 c7 82 10 0e 00 00
> 00 00 00 00 e8 1b 96 fc ff 4c 89 ff e8 53 21 d8 ff eb 84 41 bc f4 ff
> ff ff e9 79 ff ff ff <0f> 0b 48 8b bd 48 ff ff ff 41 89 c4 89 c1 49
> c7 c0 38 82 c0 81
> kernel: [   61.928012] RIP  [<ffffffff813d685a>]
> btrfs_recover_log_trees+0x37a/0x3e0
> kernel: [   61.928013]  RSP <ffff880417625958>
> kernel: [   61.928033] ---[ end trace bf74eeb72ea83677 ]---
> 
> right now I copy the data with "restore" from
> git://github.com/josefbacik/btrfs-progs (master)
> but sometimes I get "failed to inflate: -6" and the system is idle
> for several minutes.
> 
> What are your suggestions regarding the next steps in mounting the
> filesystem, especially do you
> suggest to keep the raid devices together or to take off one and try
> to mount in degraded mode ?
> 
> Is there anything you are interested in to analyse, do you want me
> to try patches?

Hi,

btrfs-zero-log can be helpful for you on mounting the FS again.

thanks,
liubo
