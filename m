Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3AGRGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 12:06:43 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 994CFA39D2
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Jan 2013 18:06:41 +0100 (CET)
Date: Mon, 7 Jan 2013 18:06:40 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1 and rc2
Message-ID: <20130107170640.GN20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130104125059.GE20089@twin.jikos.cz>
 <20130107170351.GM20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130107170351.GM20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 06:03:51PM +0100, David Sterba wrote:
> with top commit 5f243b9b46a22e5790dbbc36f574c2417af49a41 (something post
> -rc2) I see more checksum errors
> 
> $ dmesg|grep csum|wc -l
> 100

more of dmesg:

[15303.739076] btrfs csum failed ino 63791 off 368640 csum 3994424334 private 783210346
[15303.748113] ------------[ cut here ]------------
[15303.752052] kernel BUG at mm/page-writeback.c:2164!
[15303.752052] invalid opcode: 0000 [#1] SMP 
[15303.752052] Modules linked in: dm_crypt loop btrfs
[15303.752052] CPU 0 
[15303.752052] Pid: 11355, comm: fsx Not tainted 3.8.0-rc2-default+ #228 Intel Corporation Santa Rosa platform/Matanzas
[15303.752052] RIP: 0010:[<ffffffff81118239>]  [<ffffffff81118239>] clear_page_dirty_for_io+0x119/0x130
[15303.752052] RSP: 0018:ffff88002024fb28  EFLAGS: 00010246
[15303.752052] RAX: 4000000000000802 RBX: ffffea00013c68f0 RCX: 0000000000000000
[15303.752052] RDX: 0000000000000011 RSI: ffffffff81151320 RDI: ffffea00013c68f0
[15303.752052] RBP: ffff88002024fb38 R08: 0000000000000000 R09: ffff88004fa65640
[15303.752052] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88006dd6e780
[15303.752052] R13: 0000000000000000 R14: ffff880063f4fac0 R15: 0000000000000001
[15303.752052] FS:  00007f7067547700(0000) GS:ffff88007d800000(0000) knlGS:0000000000000000
[15303.752052] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[15303.752052] CR2: 00007f7066d2cb10 CR3: 000000001dafe000 CR4: 00000000000007f0
[15303.752052] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15303.752052] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[15303.752052] Process fsx (pid: 11355, threadinfo ffff88002024e000, task ffff880058334440)
[15303.752052] Stack:
[15303.752052]  ffff880063f4fac0 0000000000000001 ffff88002024fc08 ffffffffa0044092
[15303.752052]  ffff88002024fbd0 ffff880000000050 0000000000022000 00001000819572cb
[15303.752052]  0000000000000000 000000000005b000 00000000797903b8 000000000005ae00
[15303.752052] Call Trace:
[15303.752052]  [<ffffffffa0044092>] prepare_pages+0x302/0x3a0 [btrfs]
[15303.752052]  [<ffffffffa00455ed>] __btrfs_buffered_write+0x1ad/0x370 [btrfs]
[15303.752052]  [<ffffffffa0045cab>] btrfs_file_aio_write+0x4fb/0x5e0 [btrfs]
[15303.752052]  [<ffffffff8115e04a>] do_sync_write+0xaa/0xf0
[15303.752052]  [<ffffffff8115e74e>] vfs_write+0xce/0x190
[15303.752052]  [<ffffffff8115eab2>] sys_write+0x62/0xb0
[15303.752052]  [<ffffffff8139a2de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[15303.752052]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15303.752052] Code: 00 00 48 89 df e8 38 fb ff ff e9 73 ff ff ff 0f 1f 00 48 89 df 57 9d 66 66 90 66 90 e8 51 e5 f8 ff b8 01 00 00 00 e9 3a ff ff ff <0f> 0b 49 c7 c4 20 7f e4 81 e9 07 ff ff ff 66 0f 1f 84 00 00 00 
[15303.752052] RIP  [<ffffffff81118239>] clear_page_dirty_for_io+0x119/0x130
[15303.752052]  RSP <ffff88002024fb28>
[15304.049369] ---[ end trace e69c5ab147a5d842 ]---
[15304.358163] ------------[ cut here ]------------
[15304.364297] WARNING: at fs/btrfs/inode.c:7123 btrfs_destroy_inode+0x23e/0x2e0 [btrfs]()
[15304.373804] Hardware name: Santa Rosa platform
[15304.373809] Modules linked in: dm_crypt loop btrfs
[15304.373813] Pid: 11387, comm: umount Tainted: G      D      3.8.0-rc2-default+ #228
[15304.373814] Call Trace:
[15304.373822]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.373831]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.373851]  [<ffffffffa00435be>] btrfs_destroy_inode+0x23e/0x2e0 [btrfs]
[15304.373857]  [<ffffffff81178a4c>] destroy_inode+0x3c/0x70
[15304.373862]  [<ffffffff81178ba6>] evict+0x126/0x1c0
[15304.373867]  [<ffffffff81178c8f>] dispose_list+0x4f/0x60
[15304.373873]  [<ffffffff811799f4>] evict_inodes+0x114/0x130
[15304.373879]  [<ffffffff81160903>] generic_shutdown_super+0x53/0xf0
[15304.373886]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.373898]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.373903]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.373909]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.373914]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.373920]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.373925]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.373931]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.373934] ---[ end trace e69c5ab147a5d843 ]---
[15304.373937] ------------[ cut here ]------------
[15304.373954] WARNING: at fs/btrfs/inode.c:7124 btrfs_destroy_inode+0x2c6/0x2e0 [btrfs]()
[15304.373955] Hardware name: Santa Rosa platform
[15304.373963] Modules linked in: dm_crypt loop btrfs
[15304.373968] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.373969] Call Trace:
[15304.373974]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.373979]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.373998]  [<ffffffffa0043646>] btrfs_destroy_inode+0x2c6/0x2e0 [btrfs]
[15304.374003]  [<ffffffff81178a4c>] destroy_inode+0x3c/0x70
[15304.374008]  [<ffffffff81178ba6>] evict+0x126/0x1c0
[15304.374012]  [<ffffffff81178c8f>] dispose_list+0x4f/0x60
[15304.374017]  [<ffffffff811799f4>] evict_inodes+0x114/0x130
[15304.374022]  [<ffffffff81160903>] generic_shutdown_super+0x53/0xf0
[15304.374027]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.374039]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.374044]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.374049]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.374054]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.374059]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.374064]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.374069]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.374072] ---[ end trace e69c5ab147a5d844 ]---
[15304.374075] ------------[ cut here ]------------
[15304.374092] WARNING: at fs/btrfs/inode.c:7126 btrfs_destroy_inode+0x29a/0x2e0 [btrfs]()
[15304.374095] Hardware name: Santa Rosa platform
[15304.374100] Modules linked in: dm_crypt loop btrfs
[15304.374104] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.374105] Call Trace:
[15304.374110]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.374115]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.374134]  [<ffffffffa004361a>] btrfs_destroy_inode+0x29a/0x2e0 [btrfs]
[15304.374139]  [<ffffffff81178a4c>] destroy_inode+0x3c/0x70
[15304.374144]  [<ffffffff81178ba6>] evict+0x126/0x1c0
[15304.374149]  [<ffffffff81178c8f>] dispose_list+0x4f/0x60
[15304.374153]  [<ffffffff811799f4>] evict_inodes+0x114/0x130
[15304.374159]  [<ffffffff81160903>] generic_shutdown_super+0x53/0xf0
[15304.374163]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.374177]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.374182]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.374187]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.374192]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.374197]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.374202]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.374207]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.374210] ---[ end trace e69c5ab147a5d845 ]---
[15304.829781] ------------[ cut here ]------------
[15304.835437] WARNING: at fs/btrfs/extent-tree.c:4366 btrfs_free_block_groups+0x2cc/0x370 [btrfs]()
[15304.845358] Hardware name: Santa Rosa platform
[15304.845362] Modules linked in: dm_crypt loop btrfs
[15304.845365] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.845366] Call Trace:
[15304.845373]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.845377]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.845389]  [<ffffffffa002261c>] btrfs_free_block_groups+0x2cc/0x370 [btrfs]
[15304.845402]  [<ffffffffa002fc5a>] close_ctree+0x1ca/0x340 [btrfs]
[15304.845409]  [<ffffffff81178c8f>] ? dispose_list+0x4f/0x60
[15304.845412]  [<ffffffff811799f4>] ? evict_inodes+0x114/0x130
[15304.845422]  [<ffffffffa0003c69>] btrfs_put_super+0x19/0x20 [btrfs]
[15304.845427]  [<ffffffff81160912>] generic_shutdown_super+0x62/0xf0
[15304.845431]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.845441]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.845445]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.845449]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.845453]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.845458]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.845462]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.845467]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.845469] ---[ end trace e69c5ab147a5d846 ]---
[15304.845471] ------------[ cut here ]------------
[15304.845481] WARNING: at fs/btrfs/extent-tree.c:4367 btrfs_free_block_groups+0x366/0x370 [btrfs]()
[15304.845482] Hardware name: Santa Rosa platform
[15304.845488] Modules linked in: dm_crypt loop btrfs
[15304.845490] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.845491] Call Trace:
[15304.845496]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.845499]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.845511]  [<ffffffffa00226b6>] btrfs_free_block_groups+0x366/0x370 [btrfs]
[15304.845524]  [<ffffffffa002fc5a>] close_ctree+0x1ca/0x340 [btrfs]
[15304.845528]  [<ffffffff81178c8f>] ? dispose_list+0x4f/0x60
[15304.845532]  [<ffffffff811799f4>] ? evict_inodes+0x114/0x130
[15304.845542]  [<ffffffffa0003c69>] btrfs_put_super+0x19/0x20 [btrfs]
[15304.845547]  [<ffffffff81160912>] generic_shutdown_super+0x62/0xf0
[15304.845551]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.845560]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.845564]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.845568]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.845572]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.845577]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.845580]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.845584]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.845587] ---[ end trace e69c5ab147a5d847 ]---
[15304.845589] ------------[ cut here ]------------
[15304.845599] WARNING: at fs/btrfs/extent-tree.c:7657 btrfs_free_block_groups+0x25b/0x370 [btrfs]()
[15304.845600] Hardware name: Santa Rosa platform
[15304.845603] Modules linked in: dm_crypt loop btrfs
[15304.845606] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.845607] Call Trace:
[15304.845611]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.845614]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.845625]  [<ffffffffa00225ab>] btrfs_free_block_groups+0x25b/0x370 [btrfs]
[15304.845639]  [<ffffffffa002fc5a>] close_ctree+0x1ca/0x340 [btrfs]
[15304.845643]  [<ffffffff81178c8f>] ? dispose_list+0x4f/0x60
[15304.845647]  [<ffffffff811799f4>] ? evict_inodes+0x114/0x130
[15304.845656]  [<ffffffffa0003c69>] btrfs_put_super+0x19/0x20 [btrfs]
[15304.845660]  [<ffffffff81160912>] generic_shutdown_super+0x62/0xf0
[15304.845664]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.845673]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.845677]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.845681]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.845685]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.845689]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.845693]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.845697]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.845700] ---[ end trace e69c5ab147a5d848 ]---
[15304.845703] space_info 1 has 4277313536 free, is not full
[15304.845705] space_info total=4303355904, used=25976832, pinned=0, reserved=0, may_use=4096, readonly=65536
[15304.845707] ------------[ cut here ]------------
[15304.845717] WARNING: at fs/btrfs/extent-tree.c:7657 btrfs_free_block_groups+0x25b/0x370 [btrfs]()
[15304.845718] Hardware name: Santa Rosa platform
[15304.845722] Modules linked in: dm_crypt loop btrfs
[15304.845725] Pid: 11387, comm: umount Tainted: G      D W    3.8.0-rc2-default+ #228
[15304.845725] Call Trace:
[15304.845728]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[15304.845731]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[15304.845741]  [<ffffffffa00225ab>] btrfs_free_block_groups+0x25b/0x370 [btrfs]
[15304.845753]  [<ffffffffa002fc5a>] close_ctree+0x1ca/0x340 [btrfs]
[15304.845755]  [<ffffffff81178c8f>] ? dispose_list+0x4f/0x60
[15304.845757]  [<ffffffff811799f4>] ? evict_inodes+0x114/0x130
[15304.845765]  [<ffffffffa0003c69>] btrfs_put_super+0x19/0x20 [btrfs]
[15304.845768]  [<ffffffff81160912>] generic_shutdown_super+0x62/0xf0
[15304.845770]  [<ffffffff81160a36>] kill_anon_super+0x16/0x30
[15304.845778]  [<ffffffffa0004d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[15304.845780]  [<ffffffff81161902>] ? deactivate_super+0x42/0x70
[15304.845782]  [<ffffffff81160c8d>] deactivate_locked_super+0x3d/0x90
[15304.845785]  [<ffffffff8116190a>] deactivate_super+0x4a/0x70
[15304.845787]  [<ffffffff8117dc90>] mntput_no_expire+0x100/0x160
[15304.845790]  [<ffffffff8117ecd1>] sys_umount+0x71/0x3c0
[15304.845792]  [<ffffffff81960699>] system_call_fastpath+0x16/0x1b
[15304.845793] ---[ end trace e69c5ab147a5d849 ]---
[15304.845795] space_info 4 has 1072345088 free, is not full
[15304.845797] space_info total=1082130432, used=1265664, pinned=0, reserved=0, may_use=294912, readonly=8519680
[15306.426312] btrfs: disk space caching is enabled
[15694.784899] btrfs csum failed ino 66356 off 8888320 csum 2171778039 private 2566472073
[15694.794201] btrfs csum failed ino 66356 off 8908800 csum 3905765731 private 2566472073
[15921.985270] btrfs: disk space caching is enabled
[15940.469676] btrfs csum failed ino 66350 off 589824 csum 2566472073 private 628520344
[15940.479220] btrfs csum failed ino 66350 off 786432 csum 2566472073 private 628520344
[15940.603713] btrfs csum failed ino 66350 off 11665408 csum 2566472073 private 628520344
[15940.613342] btrfs csum failed ino 66350 off 12058624 csum 2566472073 private 628520344
[15940.623017] btrfs csum failed ino 66350 off 12451840 csum 2566472073 private 628520344
[15940.643849] btrfs csum failed ino 66350 off 12845056 csum 2566472073 private 628520344
[15945.783819] btrfs csum failed ino 66350 off 536662016 csum 2566472073 private 628520344
[15970.955754] btrfs csum failed ino 66351 off 5767168 csum 108545150 private 628520344
[15973.188458] btrfs csum failed ino 66351 off 95813632 csum 2566472073 private 628520344
[15973.325945] btrfs csum failed ino 66351 off 96206848 csum 2566472073 private 628520344
[15973.335697] btrfs csum failed ino 66351 off 96600064 csum 2566472073 private 628520344
[15973.393742] btrfs csum failed ino 66351 off 101122048 csum 2566472073 private 628520344
[15973.836510] btrfs csum failed ino 66351 off 101515264 csum 2566472073 private 628520344
[15973.846280] btrfs csum failed ino 66351 off 101908480 csum 2566472073 private 628520344
[16016.241905] btrfs csum failed ino 66352 off 48234496 csum 2566472073 private 628520344
[16016.251038] btrfs csum failed ino 66352 off 48238592 csum 2566472073 private 628520344
[16016.251043] btrfs csum failed ino 66352 off 48242688 csum 2566472073 private 628520344
[16016.251049] btrfs csum failed ino 66352 off 48246784 csum 2566472073 private 628520344
[16016.251054] btrfs csum failed ino 66352 off 48250880 csum 2566472073 private 628520344
[16016.251059] btrfs csum failed ino 66352 off 48254976 csum 2566472073 private 628520344
[16016.251063] btrfs csum failed ino 66352 off 48259072 csum 2566472073 private 628520344
[16016.251068] btrfs csum failed ino 66352 off 48263168 csum 2566472073 private 628520344
[16016.251072] btrfs csum failed ino 66352 off 48267264 csum 2566472073 private 628520344
[16016.251077] btrfs csum failed ino 66352 off 48271360 csum 2566472073 private 628520344
[16016.251081] btrfs csum failed ino 66352 off 48275456 csum 2566472073 private 628520344
[16016.251086] btrfs csum failed ino 66352 off 48279552 csum 2566472073 private 628520344
[16016.251091] btrfs csum failed ino 66352 off 48283648 csum 2566472073 private 628520344
[16016.251095] btrfs csum failed ino 66352 off 48287744 csum 2566472073 private 628520344
[16016.251100] btrfs csum failed ino 66352 off 48291840 csum 2566472073 private 628520344
[16016.251104] btrfs csum failed ino 66352 off 48295936 csum 2566472073 private 628520344
[16365.034223] btrfs: disk space caching is enabled
[16365.660772] btrfs csum failed ino 66352 off 122880 csum 2962417916 private 1108896639
[16365.674192] btrfs csum failed ino 66352 off 57344 csum 2566472073 private 1108896639
[16366.378533] btrfs csum failed ino 66352 off 577536 csum 2272747479 private 1108896639
[16366.427623] btrfs csum failed ino 66352 off 970752 csum 2272747479 private 1108896639
[16366.636736] btrfs csum failed ino 66352 off 5062656 csum 2962417916 private 1108896639
[16366.656774] btrfs csum failed ino 66352 off 5652480 csum 2962417916 private 1108896639
[16366.666961] btrfs csum failed ino 66352 off 6045696 csum 2962417916 private 1108896639
[16366.805461] btrfs csum failed ino 66352 off 6504448 csum 2962417916 private 1108896639
[16366.815044] btrfs csum failed ino 66352 off 6701056 csum 2962417916 private 1108896639
[16366.954780] btrfs csum failed ino 66352 off 7032832 csum 2962417916 private 1108896639
[16370.863641] btrfs_readpage_end_io_hook: 57 callbacks suppressed
[16370.870674] btrfs csum failed ino 66352 off 671744 csum 628520344 private 4063643746
[16370.879802] btrfs csum failed ino 66352 off 868352 csum 628520344 private 4063643746
[16371.047197] btrfs csum failed ino 66352 off 1458176 csum 628520344 private 4063643746
[16371.067697] btrfs csum failed ino 66352 off 1851392 csum 628520344 private 4063643746
[16371.229767] btrfs csum failed ino 66352 off 2433024 csum 628520344 private 4063643746
[16371.262798] btrfs csum failed ino 66352 off 2572288 csum 2566472073 private 4063643746
[16371.320675] btrfs csum failed ino 66352 off 2834432 csum 628520344 private 4063643746
[16371.411517] btrfs csum failed ino 66352 off 2912256 csum 628520344 private 4063643746
[16371.433164] btrfs csum failed ino 66352 off 2965504 csum 628520344 private 4063643746
[16371.559819] btrfs csum failed ino 66352 off 3227648 csum 628520344 private 4063643746
[16375.949306] btrfs_readpage_end_io_hook: 67 callbacks suppressed
[16375.956367] btrfs csum failed ino 66352 off 278528 csum 628520344 private 665344948
[16376.052581] btrfs csum failed ino 66352 off 356352 csum 628520344 private 665344948
[16376.073033] btrfs csum failed ino 66352 off 409600 csum 2566472073 private 665344948
[16376.120465] btrfs csum failed ino 66352 off 606208 csum 628520344 private 665344948
[16376.155395] btrfs csum failed ino 66352 off 671744 csum 2566472073 private 665344948
[16376.372957] btrfs csum failed ino 66352 off 999424 csum 628520344 private 665344948
[16376.382185] btrfs csum failed ino 66352 off 1196032 csum 628520344 private 665344948
[16376.409080] btrfs csum failed ino 66352 off 1589248 csum 628520344 private 665344948
[16376.521638] btrfs csum failed ino 66352 off 1785856 csum 628520344 private 665344948
[16376.570192] btrfs csum failed ino 66352 off 1982464 csum 2566472073 private 665344948
[16381.059067] btrfs_readpage_end_io_hook: 71 callbacks suppressed
[16381.066104] btrfs csum failed ino 66352 off 5193728 csum 628520344 private 1298616927
[16381.153326] btrfs csum failed ino 66352 off 5390336 csum 2566472073 private 1298616927
[16381.166398] btrfs csum failed ino 66352 off 5455872 csum 628520344 private 1298616927
[16381.294876] btrfs csum failed ino 66352 off 5537792 csum 628520344 private 1298616927
[16381.314543] btrfs csum failed ino 66352 off 5586944 csum 628520344 private 1298616927
[16381.371511] btrfs csum failed ino 66352 off 5783552 csum 628520344 private 1298616927
[16381.388887] btrfs csum failed ino 66352 off 5849088 csum 628520344 private 1298616927
[16381.422504] btrfs csum failed ino 66352 off 5914624 csum 2566472073 private 1298616927
[16381.521612] btrfs csum failed ino 66352 off 6045696 csum 628520344 private 1298616927
[16381.540930] btrfs csum failed ino 66352 off 6111232 csum 628520344 private 1298616927
[16386.174164] btrfs_readpage_end_io_hook: 65 callbacks suppressed
[16386.181196] btrfs csum failed ino 66352 off 8019968 csum 2566472073 private 2542172329
[16386.193769] btrfs csum failed ino 66352 off 8077312 csum 628520344 private 2542172329
[16386.251784] btrfs csum failed ino 66352 off 8339456 csum 628520344 private 2542172329
[16386.260941] btrfs csum failed ino 66352 off 8273920 csum 2566472073 private 2542172329
[16386.385256] btrfs csum failed ino 66352 off 147456 csum 2566472073 private 1402544159
[16386.472192] btrfs csum failed ino 66352 off 278528 csum 628520344 private 1402544159
[16386.585245] btrfs csum failed ino 66352 off 409600 csum 2566472073 private 1402544159
[16386.622313] btrfs csum failed ino 66352 off 475136 csum 628520344 private 1402544159
[16386.666599] btrfs csum failed ino 66352 off 606208 csum 628520344 private 1402544159
[16386.780363] btrfs csum failed ino 66352 off 737280 csum 628520344 private 1402544159
[16391.201723] btrfs_readpage_end_io_hook: 64 callbacks suppressed
[16391.208744] btrfs csum failed ino 66352 off 2441216 csum 628520344 private 2306345705
[16391.217975] btrfs csum failed ino 66352 off 2506752 csum 2566472073 private 2306345705
[16391.399303] btrfs csum failed ino 66352 off 2834432 csum 628520344 private 2306345705
[16391.408707] btrfs csum failed ino 66352 off 3031040 csum 628520344 private 2306345705
[16391.591001] btrfs csum failed ino 66352 off 3649536 csum 628520344 private 2306345705
[16391.642713] btrfs csum failed ino 66352 off 4046848 csum 628520344 private 2306345705
[16391.754148] btrfs csum failed ino 66352 off 4571136 csum 628520344 private 2306345705
[16391.889749] btrfs csum failed ino 66352 off 4997120 csum 628520344 private 2306345705
[16391.932588] btrfs csum failed ino 66352 off 5062656 csum 628520344 private 2306345705
[16392.044805] btrfs csum failed ino 66352 off 5390336 csum 628520344 private 2306345705
[16398.159714] btrfs: disk space caching is enabled
[16524.354181] ------------[ cut here ]------------
[16524.360805] WARNING: at fs/btrfs/delayed-inode.c:703 btrfs_delayed_update_inode+0x675/0x6b0 [btrfs]()
[16524.372065] Hardware name: Santa Rosa platform
[16524.372072] Modules linked in: dm_crypt loop btrfs
[16524.372077] Pid: 27886, comm: btrfs-endio-wri Tainted: G      D W    3.8.0-rc2-default+ #228
[16524.372078] Call Trace:
[16524.372089]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[16524.372094]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[16524.372121]  [<ffffffffa00847d5>] btrfs_delayed_update_inode+0x675/0x6b0 [btrfs]
[16524.372148]  [<ffffffffa0025d65>] ? btrfs_update_root_times+0x75/0x90 [btrfs]
[16524.372173]  [<ffffffffa003a85a>] btrfs_update_inode+0x6a/0x100 [btrfs]
[16524.372198]  [<ffffffffa003d637>] btrfs_update_inode_fallback+0x27/0x60 [btrfs]
[16524.372223]  [<ffffffffa003d920>] btrfs_finish_ordered_io+0x2b0/0x400 [btrfs]
[16524.372231]  [<ffffffff81957320>] ? _raw_spin_unlock_irq+0x30/0x50
[16524.372258]  [<ffffffffa003da85>] finish_ordered_fn+0x15/0x20 [btrfs]
[16524.372284]  [<ffffffffa00603e4>] worker_loop+0xc4/0x5a0 [btrfs]
[16524.372312]  [<ffffffffa0060320>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[16524.372321]  [<ffffffff81073d4e>] kthread+0xde/0xf0
[16524.372330]  [<ffffffff8107fbe6>] ? finish_task_switch+0x46/0xf0
[16524.372338]  [<ffffffff81073c70>] ? flush_kthread_worker+0x1e0/0x1e0
[16524.372346]  [<ffffffff819605ec>] ret_from_fork+0x7c/0xb0
[16524.372352]  [<ffffffff81073c70>] ? flush_kthread_worker+0x1e0/0x1e0
[16524.372357] ---[ end trace e69c5ab147a5d84a ]---
[16524.695745] ------------[ cut here ]------------
[16524.702233] WARNING: at fs/btrfs/delayed-inode.c:703 btrfs_delayed_update_inode+0x675/0x6b0 [btrfs]()
[16524.713324] Hardware name: Santa Rosa platform
[16524.713331] Modules linked in: dm_crypt loop btrfs
[16524.713336] Pid: 27886, comm: btrfs-endio-wri Tainted: G      D W    3.8.0-rc2-default+ #228
[16524.713337] Call Trace:
[16524.713347]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[16524.713352]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[16524.713377]  [<ffffffffa00847d5>] btrfs_delayed_update_inode+0x675/0x6b0 [btrfs]
[16524.713401]  [<ffffffffa0025d65>] ? btrfs_update_root_times+0x75/0x90 [btrfs]
[16524.713427]  [<ffffffffa003a85a>] btrfs_update_inode+0x6a/0x100 [btrfs]
[16524.713452]  [<ffffffffa003d637>] btrfs_update_inode_fallback+0x27/0x60 [btrfs]
[16524.713477]  [<ffffffffa003d920>] btrfs_finish_ordered_io+0x2b0/0x400 [btrfs]
[16524.713486]  [<ffffffff81957320>] ? _raw_spin_unlock_irq+0x30/0x50
[16524.713511]  [<ffffffffa003da85>] finish_ordered_fn+0x15/0x20 [btrfs]
[16524.713539]  [<ffffffffa00603e4>] worker_loop+0xc4/0x5a0 [btrfs]
[16524.713566]  [<ffffffffa0060320>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[16524.713574]  [<ffffffff81073d4e>] kthread+0xde/0xf0
[16524.713583]  [<ffffffff8107fbe6>] ? finish_task_switch+0x46/0xf0
[16524.713590]  [<ffffffff81073c70>] ? flush_kthread_worker+0x1e0/0x1e0
[16524.713596]  [<ffffffff819605ec>] ret_from_fork+0x7c/0xb0
[16524.713602]  [<ffffffff81073c70>] ? flush_kthread_worker+0x1e0/0x1e0
[16524.713607] ---[ end trace e69c5ab147a5d84b ]---
[16589.879707] btrfs: disk space caching is enabled
[16642.502389] btrfs_readpage_end_io_hook: 54 callbacks suppressed
[16642.509559] btrfs csum failed ino 66363 off 32768 csum 2486649235 private 3323905731
[16642.520865] btrfs csum failed ino 66363 off 32768 csum 2486649235 private 3323905731
[16644.572295] btrfs: disk space caching is enabled
[16743.714911] btrfs csum failed ino 66372 off 113119232 csum 2279583572 private 2566472073
[16743.724717] btrfs csum failed ino 66372 off 113512448 csum 2279583572 private 2566472073
[16743.734544] btrfs csum failed ino 66372 off 113905664 csum 2279583572 private 2566472073
[16743.775876] btrfs csum failed ino 66372 off 113573888 csum 628520344 private 2566472073
[16750.940751] btrfs: disk space caching is enabled
[16890.628694] btrfs: disk space caching is enabled
[16892.647778] btrfs csum failed ino 66414 off 180224 csum 1270363740 private 2095194158
[17024.492935] btrfs: disk space caching is enabled
[17024.584137] btrfs: free space inode generation (0) did not match free space cache generation (33)
