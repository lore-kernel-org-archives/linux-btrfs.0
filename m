Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab3AIMtF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 07:49:05 -0500
Date: Wed, 9 Jan 2013 13:49:03 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130109124901.GS20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
 <20130108172627.GP20089@twin.jikos.cz>
 <20130109043443.GA4527@liubo>
 <20130109115025.GQ20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130109115025.GQ20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 09, 2013 at 12:50:25PM +0100, David Sterba wrote:
> I've added only the 2 fixes from you, no other change. I'll do another test
> based on current btrfs-next.

reproduced on linus/master + btrfs-next + debugging patch + your fixes
with test 068

[ 1285.152973] ------------[ cut here ]------------
[ 1285.158880] WARNING: at fs/btrfs/extent-tree.c:7696 btrfs_free_block_groups+0x25b/0x370 [btrfs]()
[ 1285.169400] Hardware name: Santa Rosa platform
[ 1285.169410] Modules linked in: btrfs aoe dm_crypt loop [last unloaded: btrfs]
[ 1285.169414] Pid: 28160, comm: umount Not tainted 3.8.0-rc2-default+ #230
[ 1285.169420] Call Trace:
[ 1285.169431]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[ 1285.169438]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[ 1285.169462]  [<ffffffffa02108eb>] btrfs_free_block_groups+0x25b/0x370 [btrfs]
[ 1285.169487]  [<ffffffffa021e1aa>] close_ctree+0x1ca/0x340 [btrfs]
[ 1285.169495]  [<ffffffff81178c6f>] ? dispose_list+0x4f/0x60
[ 1285.169502]  [<ffffffff811799d4>] ? evict_inodes+0x114/0x130
[ 1285.169519]  [<ffffffffa01f1c69>] btrfs_put_super+0x19/0x20 [btrfs]
[ 1285.169527]  [<ffffffff811608f2>] generic_shutdown_super+0x62/0xf0
[ 1285.169536]  [<ffffffff81160a16>] kill_anon_super+0x16/0x30
[ 1285.169552]  [<ffffffffa01f2d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[ 1285.169559]  [<ffffffff811618e2>] ? deactivate_super+0x42/0x70
[ 1285.169566]  [<ffffffff81160c6d>] deactivate_locked_super+0x3d/0x90
[ 1285.169573]  [<ffffffff811618ea>] deactivate_super+0x4a/0x70
[ 1285.169582]  [<ffffffff8117dc70>] mntput_no_expire+0x100/0x160
[ 1285.169587]  [<ffffffff8117ecb1>] sys_umount+0x71/0x3c0
[ 1285.169593]  [<ffffffff81960cd9>] system_call_fastpath+0x16/0x1b
[ 1285.169595] ---[ end trace 32a766aa6196f679 ]---
[ 1285.169598] space_info 4 has 1073651712 free, is not full
[ 1285.169601] space_info total=1082130432, used=24576, pinned=0, reserved=0, may_use=98304, readonly=8454144
[ 1285.169618] ------------[ cut here ]------------
[ 1285.169638] WARNING: at fs/btrfs/disk-io.c:3211 free_fs_root+0x8b/0x90 [btrfs]()
[ 1285.169639] Hardware name: Santa Rosa platform
[ 1285.169646] Modules linked in: btrfs aoe dm_crypt loop [last unloaded: btrfs]
[ 1285.169650] Pid: 28160, comm: umount Tainted: G        W 3.8.0-rc2-default+ #230
[ 1285.169651] Call Trace:
[ 1285.169656]  [<ffffffff8104c6bf>] warn_slowpath_common+0x7f/0xc0
[ 1285.169661]  [<ffffffff8104c71a>] warn_slowpath_null+0x1a/0x20
[ 1285.169681]  [<ffffffffa0218f6b>] free_fs_root+0x8b/0x90 [btrfs]
[ 1285.169703]  [<ffffffffa021c78e>] btrfs_free_fs_root+0x7e/0x90 [btrfs]
[ 1285.169726]  [<ffffffffa021c87b>] del_fs_roots+0xdb/0x120 [btrfs]
[ 1285.169747]  [<ffffffffa021092e>] ?  btrfs_free_block_groups+0x29e/0x370 [btrfs]
[ 1285.169771]  [<ffffffffa021e1b2>] close_ctree+0x1d2/0x340 [btrfs]
[ 1285.169778]  [<ffffffff81178c6f>] ? dispose_list+0x4f/0x60
[ 1285.169784]  [<ffffffff811799d4>] ? evict_inodes+0x114/0x130
[ 1285.169801]  [<ffffffffa01f1c69>] btrfs_put_super+0x19/0x20 [btrfs]
[ 1285.169808]  [<ffffffff811608f2>] generic_shutdown_super+0x62/0xf0
[ 1285.169815]  [<ffffffff81160a16>] kill_anon_super+0x16/0x30
[ 1285.169831]  [<ffffffffa01f2d9a>] btrfs_kill_super+0x1a/0x90 [btrfs]
[ 1285.169838]  [<ffffffff811618e2>] ? deactivate_super+0x42/0x70
[ 1285.169845]  [<ffffffff81160c6d>] deactivate_locked_super+0x3d/0x90
[ 1285.169854]  [<ffffffff811618ea>] deactivate_super+0x4a/0x70
[ 1285.169861]  [<ffffffff8117dc70>] mntput_no_expire+0x100/0x160
[ 1285.169868]  [<ffffffff8117ecb1>] sys_umount+0x71/0x3c0
[ 1285.169877]  [<ffffffff81960cd9>] system_call_fastpath+0x16/0x1b
[ 1285.169881] ---[ end trace 32a766aa6196f67a ]---
[ 1285.550715] VFS: Busy inodes after unmount of sda9. Self-destruct in
5 seconds.  Have a nice day...

david
