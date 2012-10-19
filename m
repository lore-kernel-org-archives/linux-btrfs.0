Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:57274 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2JSG6h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 02:58:37 -0400
Received: from [IPv6:2a01:238:e100:320:7271:bcff:fe43:2d12]
	([2a01:238:e100:320:7271:bcff:fe43:2d12])
	by smtp.strato.de (josoe mo44) (RZmta 30.20 AUTH)
	with ESMTPA id j0332bo9J6ElRF for <linux-btrfs@vger.kernel.org>;
	Fri, 19 Oct 2012 08:58:34 +0200 (CEST)
Message-ID: <5080FA10.8040304@jan-o-sch.net>
Date: Fri, 19 Oct 2012 08:58:24 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: space info warnings in 3.7-rc1
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While originally debugging some tree mod log thing, I'm seeing space info
warnings along the way, running cmason/master (f46dbe3de). I just drop them off,
haven't looked into it any deeper than "most likely not tree mod log related".

-Jan

<6>[ 1131.563658] device label quota devid 1 transid 4 /dev/sdi
<6>[ 1131.565414] btrfs: disk space caching is enabled
<4>[ 1139.488296] ------------[ cut here ]------------
<4>[ 1139.488315] WARNING: at fs/btrfs/inode.c:7123
btrfs_destroy_inode+0x260/0x2e0 [btrfs]()
<4>[ 1139.488316] Hardware name: X8SIL
<4>[ 1139.488317] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[ 1139.488324] Pid: 23192, comm: rm Not tainted 3.6.0+ #2
<4>[ 1139.488325] Call Trace:
<4>[ 1139.488332]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
<4>[ 1139.488336]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
<4>[ 1139.488348]  [<ffffffffa0075eb0>] btrfs_destroy_inode+0x260/0x2e0 [btrfs]
<4>[ 1139.488352]  [<ffffffff811b4137>] destroy_inode+0x37/0x60
<4>[ 1139.488355]  [<ffffffff811b426c>] evict+0x10c/0x190
<4>[ 1139.488358]  [<ffffffff811b43fc>] iput+0x10c/0x200
<4>[ 1139.488361]  [<ffffffff811a9cd7>] do_unlinkat+0x177/0x1c0
<4>[ 1139.488364]  [<ffffffff810e324d>] ? trace_hardirqs_on_caller+0xfd/0x190
<4>[ 1139.488369]  [<ffffffff8143727e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
<4>[ 1139.488372]  [<ffffffff811a9e8d>] sys_unlinkat+0x1d/0x40
<4>[ 1139.488377]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
<4>[ 1139.488379] ---[ end trace 9b4fa8a702f2863b ]---
<4>[ 1141.218944] ------------[ cut here ]------------
<4>[ 1141.218974] WARNING: at fs/btrfs/extent-tree.c:4365
btrfs_free_block_groups+0x237/0x2e0 [btrfs]()
<4>[ 1141.218977] Hardware name: X8SIL
<4>[ 1141.218979] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[ 1141.218990] Pid: 23211, comm: umount Tainted: G        W    3.6.0+ #2
<4>[ 1141.218991] Call Trace:
<4>[ 1141.218999]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
<4>[ 1141.219002]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
<4>[ 1141.219012]  [<ffffffffa005f217>] btrfs_free_block_groups+0x237/0x2e0 [btrfs]
<4>[ 1141.219024]  [<ffffffffa006f792>] close_ctree+0x1c2/0x300 [btrfs]
<4>[ 1141.219028]  [<ffffffff811b4da4>] ? evict_inodes+0xf4/0x110
<4>[ 1141.219037]  [<ffffffffa0047dd4>] btrfs_put_super+0x14/0x20 [btrfs]
<4>[ 1141.219040]  [<ffffffff8119be3d>] generic_shutdown_super+0x5d/0xf0
<4>[ 1141.219042]  [<ffffffff8119bf61>] kill_anon_super+0x11/0x20
<4>[ 1141.219051]  [<ffffffffa004b5c5>] btrfs_kill_super+0x15/0x90 [btrfs]
<4>[ 1141.219054]  [<ffffffff8119d36d>] ? deactivate_super+0x3d/0x60
<4>[ 1141.219057]  [<ffffffff8119c455>] deactivate_locked_super+0x45/0x70
<4>[ 1141.219059]  [<ffffffff8119d375>] deactivate_super+0x45/0x60
<4>[ 1141.219062]  [<ffffffff811b7f5d>] mntput_no_expire+0xcd/0x130
<4>[ 1141.219065]  [<ffffffff811b8b99>] sys_umount+0x79/0x3b0
<4>[ 1141.219068]  [<ffffffff81938d8a>] ? retint_swapgs+0xe/0x13
<4>[ 1141.219072]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
<4>[ 1141.219074] ---[ end trace 9b4fa8a702f2863c ]---
<4>[ 1141.219075] ------------[ cut here ]------------
<4>[ 1141.219084] WARNING: at fs/btrfs/extent-tree.c:4366
btrfs_free_block_groups+0x2d1/0x2e0 [btrfs]()
<4>[ 1141.219085] Hardware name: X8SIL
<4>[ 1141.219086] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[ 1141.219090] Pid: 23211, comm: umount Tainted: G        W    3.6.0+ #2
<4>[ 1141.219092] Call Trace:
<4>[ 1141.219095]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
<4>[ 1141.219098]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
<4>[ 1141.219108]  [<ffffffffa005f2b1>] btrfs_free_block_groups+0x2d1/0x2e0 [btrfs]
<4>[ 1141.219119]  [<ffffffffa006f792>] close_ctree+0x1c2/0x300 [btrfs]
<4>[ 1141.219122]  [<ffffffff811b4da4>] ? evict_inodes+0xf4/0x110
<4>[ 1141.219131]  [<ffffffffa0047dd4>] btrfs_put_super+0x14/0x20 [btrfs]
<4>[ 1141.219134]  [<ffffffff8119be3d>] generic_shutdown_super+0x5d/0xf0
<4>[ 1141.219136]  [<ffffffff8119bf61>] kill_anon_super+0x11/0x20
<4>[ 1141.219145]  [<ffffffffa004b5c5>] btrfs_kill_super+0x15/0x90 [btrfs]
<4>[ 1141.219147]  [<ffffffff8119d36d>] ? deactivate_super+0x3d/0x60
<4>[ 1141.219150]  [<ffffffff8119c455>] deactivate_locked_super+0x45/0x70
<4>[ 1141.219153]  [<ffffffff8119d375>] deactivate_super+0x45/0x60
<4>[ 1141.219155]  [<ffffffff811b7f5d>] mntput_no_expire+0xcd/0x130
<4>[ 1141.219158]  [<ffffffff811b8b99>] sys_umount+0x79/0x3b0
<4>[ 1141.219161]  [<ffffffff81938d8a>] ? retint_swapgs+0xe/0x13
<4>[ 1141.219164]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
<4>[ 1141.219165] ---[ end trace 9b4fa8a702f2863d ]---
<4>[ 1141.219167] ------------[ cut here ]------------
<4>[ 1141.219175] WARNING: at fs/btrfs/extent-tree.c:7614
btrfs_free_block_groups+0x1eb/0x2e0 [btrfs]()
<4>[ 1141.219176] Hardware name: X8SIL
<4>[ 1141.219177] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[ 1141.219182] Pid: 23211, comm: umount Tainted: G        W    3.6.0+ #2
<4>[ 1141.219183] Call Trace:
<4>[ 1141.219186]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
<4>[ 1141.219189]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
<4>[ 1141.219199]  [<ffffffffa005f1cb>] btrfs_free_block_groups+0x1eb/0x2e0 [btrfs]
<4>[ 1141.219210]  [<ffffffffa006f792>] close_ctree+0x1c2/0x300 [btrfs]
<4>[ 1141.219213]  [<ffffffff811b4da4>] ? evict_inodes+0xf4/0x110
<4>[ 1141.219220]  [<ffffffffa0047dd4>] btrfs_put_super+0x14/0x20 [btrfs]
<4>[ 1141.219223]  [<ffffffff8119be3d>] generic_shutdown_super+0x5d/0xf0
<4>[ 1141.219226]  [<ffffffff8119bf61>] kill_anon_super+0x11/0x20
<4>[ 1141.219233]  [<ffffffffa004b5c5>] btrfs_kill_super+0x15/0x90 [btrfs]
<4>[ 1141.219236]  [<ffffffff8119d36d>] ? deactivate_super+0x3d/0x60
<4>[ 1141.219239]  [<ffffffff8119c455>] deactivate_locked_super+0x45/0x70
<4>[ 1141.219241]  [<ffffffff8119d375>] deactivate_super+0x45/0x60
<4>[ 1141.219244]  [<ffffffff811b7f5d>] mntput_no_expire+0xcd/0x130
<4>[ 1141.219246]  [<ffffffff811b8b99>] sys_umount+0x79/0x3b0
<4>[ 1141.219249]  [<ffffffff81938d8a>] ? retint_swapgs+0xe/0x13
<4>[ 1141.219252]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
<4>[ 1141.219254] ---[ end trace 9b4fa8a702f2863e ]---
<6>[ 1141.219256] space_info 1 has 1081606144 free, is not full
<6>[ 1141.219258] space_info total=1082130432, used=524288, pinned=0,
reserved=0, may_use=4096, readonly=0
<4>[ 1141.219260] ------------[ cut here ]------------
<4>[ 1141.219268] WARNING: at fs/btrfs/extent-tree.c:7614
btrfs_free_block_groups+0x1eb/0x2e0 [btrfs]()
<4>[ 1141.219269] Hardware name: X8SIL
<4>[ 1141.219270] Modules linked in: btrfs mpt2sas scsi_transport_sas raid_class
<4>[ 1141.219275] Pid: 23211, comm: umount Tainted: G        W    3.6.0+ #2
<4>[ 1141.219276] Call Trace:
<4>[ 1141.219279]  [<ffffffff8108743a>] warn_slowpath_common+0x7a/0xb0
<4>[ 1141.219282]  [<ffffffff81087485>] warn_slowpath_null+0x15/0x20
<4>[ 1141.219292]  [<ffffffffa005f1cb>] btrfs_free_block_groups+0x1eb/0x2e0 [btrfs]
<4>[ 1141.219304]  [<ffffffffa006f792>] close_ctree+0x1c2/0x300 [btrfs]
<4>[ 1141.219307]  [<ffffffff811b4da4>] ? evict_inodes+0xf4/0x110
<4>[ 1141.219314]  [<ffffffffa0047dd4>] btrfs_put_super+0x14/0x20 [btrfs]
<4>[ 1141.219316]  [<ffffffff8119be3d>] generic_shutdown_super+0x5d/0xf0
<4>[ 1141.219319]  [<ffffffff8119bf61>] kill_anon_super+0x11/0x20
<4>[ 1141.219327]  [<ffffffffa004b5c5>] btrfs_kill_super+0x15/0x90 [btrfs]
<4>[ 1141.219329]  [<ffffffff8119d36d>] ? deactivate_super+0x3d/0x60
<4>[ 1141.219332]  [<ffffffff8119c455>] deactivate_locked_super+0x45/0x70
<4>[ 1141.219334]  [<ffffffff8119d375>] deactivate_super+0x45/0x60
<4>[ 1141.219337]  [<ffffffff811b7f5d>] mntput_no_expire+0xcd/0x130
<4>[ 1141.219340]  [<ffffffff811b8b99>] sys_umount+0x79/0x3b0
<4>[ 1141.219343]  [<ffffffff81938d8a>] ? retint_swapgs+0xe/0x13
<4>[ 1141.219346]  [<ffffffff8193f5a2>] system_call_fastpath+0x16/0x1b
<4>[ 1141.219347] ---[ end trace 9b4fa8a702f2863f ]---
<6>[ 1141.219349] space_info 4 has 1073631232 free, is not full
<6>[ 1141.219351] space_info total=1082130432, used=45056, pinned=0, reserved=0,
may_use=98304, readonly=8454144
