From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warnings (was: Re: new integration-danger branch pushed out
 (kernel))
Date: Tue, 1 Nov 2011 20:56:15 -0400
Message-ID: <20111102005615.GF15027@shiny>
References: <20111101024957.GH4468@shiny>
 <20111101101110.GB12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101101110.GB12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:11:10AM +0100, David Sterba wrote:
> Hi,
> 
> On Mon, Oct 31, 2011 at 10:49:57PM -0400, Chris Mason wrote:
> > I've pushed out a new integration branch, but it is not for general use.
> 
> Thank you!
> 
> xfstests/083 and 089 cause the following warnings. I've seen them before when
> testing josef/for-chris and josef/master branches (reported on irc).

Ok, just a status update on my end.  Josef and I have the block group
warnings fixed.  The tree log crash is also explained, the eexist oops
comes when you're using the inode_cache code (hopefully you are?).

I have one test fix for this but it still has a few wrinkles that I'll
have to sort out in the morning.

-chris

> 
> [ 1149.108088] ------------[ cut here ]------------
> [ 1149.114384] WARNING: at fs/btrfs/extent-tree.c:3932 btrfs_free_block_groups+0x304/0x320 [btrfs]()
> [ 1149.124928] Hardware name: Santa Rosa platform
> [ 1149.124931] Modules linked in: loop btrfs aoe
> [ 1149.124938] Pid: 23991, comm: umount Not tainted 3.1.0-default+ #64
> [ 1149.124941] Call Trace:
> [ 1149.124950]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
> [ 1149.124953]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
> [ 1149.124973]  [<ffffffffa002bba4>] btrfs_free_block_groups+0x304/0x320 [btrfs]
> [ 1149.124985]  [<ffffffffa0036ab9>] close_ctree+0x1e9/0x390 [btrfs]
> [ 1149.124991]  [<ffffffff8115e2df>] ? dispose_list+0x4f/0x60
> [ 1149.124999]  [<ffffffffa00108dd>] btrfs_put_super+0x1d/0x30 [btrfs]
> [ 1149.125003]  [<ffffffff81145202>] generic_shutdown_super+0x62/0xe0
> [ 1149.125006]  [<ffffffff81145316>] kill_anon_super+0x16/0x30
> [ 1149.125009]  [<ffffffff811461a2>] ? deactivate_super+0x42/0x70
> [ 1149.125012]  [<ffffffff811456dd>] deactivate_locked_super+0x3d/0xa0
> [ 1149.125015]  [<ffffffff811461aa>] deactivate_super+0x4a/0x70
> [ 1149.125019]  [<ffffffff81162972>] mntput_no_expire+0xa2/0xf0
> [ 1149.125022]  [<ffffffff811636df>] sys_umount+0x6f/0x390
> [ 1149.125027]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
> [ 1149.125030] ---[ end trace 81d2bc6c70d7ca56 ]---
> [ 1149.125032] ------------[ cut here ]------------
> [ 1149.125041] WARNING: at fs/btrfs/extent-tree.c:3933 btrfs_free_block_groups+0x2ee/0x320 [btrfs]()
> [ 1149.125044] Hardware name: Santa Rosa platform
> [ 1149.125045] Modules linked in: loop btrfs aoe
> [ 1149.125049] Pid: 23991, comm: umount Tainted: G        W   3.1.0-default+ #64
> [ 1149.125051] Call Trace:
> [ 1149.125054]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
> [ 1149.125057]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
> [ 1149.125067]  [<ffffffffa002bb8e>] btrfs_free_block_groups+0x2ee/0x320 [btrfs]
> [ 1149.125078]  [<ffffffffa0036ab9>] close_ctree+0x1e9/0x390 [btrfs]
> [ 1149.125081]  [<ffffffff8115e2df>] ? dispose_list+0x4f/0x60
> [ 1149.125089]  [<ffffffffa00108dd>] btrfs_put_super+0x1d/0x30 [btrfs]
> [ 1149.125092]  [<ffffffff81145202>] generic_shutdown_super+0x62/0xe0
> [ 1149.125096]  [<ffffffff81145316>] kill_anon_super+0x16/0x30
> [ 1149.125099]  [<ffffffff811461a2>] ? deactivate_super+0x42/0x70
> [ 1149.125102]  [<ffffffff811456dd>] deactivate_locked_super+0x3d/0xa0
> [ 1149.125105]  [<ffffffff811461aa>] deactivate_super+0x4a/0x70
> [ 1149.125108]  [<ffffffff81162972>] mntput_no_expire+0xa2/0xf0
> [ 1149.125111]  [<ffffffff811636df>] sys_umount+0x6f/0x390
> [ 1149.125115]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
> [ 1149.125117] ---[ end trace 81d2bc6c70d7ca57 ]---
> 
> The code in question:
> 
> 3927 static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
> 3928 {
> 3929         block_rsv_release_bytes(&fs_info->global_block_rsv, NULL, (u64)-1);
> 3930         WARN_ON(fs_info->delalloc_block_rsv.size > 0);
> 3931         WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
> 
> 3932         WARN_ON(fs_info->trans_block_rsv.size > 0);
> 3933         WARN_ON(fs_info->trans_block_rsv.reserved > 0);
> 
> 3934         WARN_ON(fs_info->chunk_block_rsv.size > 0);
> 3935         WARN_ON(fs_info->chunk_block_rsv.reserved > 0);
> 3936 }
> 
> 
> [ 1149.125119] ------------[ cut here ]------------
> [ 1149.125128] WARNING: at fs/btrfs/extent-tree.c:7090 btrfs_free_block_groups+0x23b/0x320 [btrfs]()
> [ 1149.125130] Hardware name: Santa Rosa platform
> [ 1149.125131] Modules linked in: loop btrfs aoe
> [ 1149.125135] Pid: 23991, comm: umount Tainted: G        W   3.1.0-default+ #64
> [ 1149.125137] Call Trace:
> [ 1149.125140]  [<ffffffff81057fdf>] warn_slowpath_common+0x7f/0xc0
> [ 1149.125143]  [<ffffffff8105803a>] warn_slowpath_null+0x1a/0x20
> [ 1149.125153]  [<ffffffffa002badb>] btrfs_free_block_groups+0x23b/0x320 [btrfs]
> [ 1149.125164]  [<ffffffffa0036ab9>] close_ctree+0x1e9/0x390 [btrfs]
> [ 1149.125167]  [<ffffffff8115e2df>] ? dispose_list+0x4f/0x60
> [ 1149.125175]  [<ffffffffa00108dd>] btrfs_put_super+0x1d/0x30 [btrfs]
> [ 1149.125178]  [<ffffffff81145202>] generic_shutdown_super+0x62/0xe0
> [ 1149.125181]  [<ffffffff81145316>] kill_anon_super+0x16/0x30
> [ 1149.125184]  [<ffffffff811461a2>] ? deactivate_super+0x42/0x70
> [ 1149.125187]  [<ffffffff811456dd>] deactivate_locked_super+0x3d/0xa0
> [ 1149.125191]  [<ffffffff811461aa>] deactivate_super+0x4a/0x70
> [ 1149.125194]  [<ffffffff81162972>] mntput_no_expire+0xa2/0xf0
> [ 1149.125197]  [<ffffffff811636df>] sys_umount+0x6f/0x390
> [ 1149.125200]  [<ffffffff81a1d782>] system_call_fastpath+0x16/0x1b
> [ 1149.125202] ---[ end trace 81d2bc6c70d7ca58 ]---
> [ 1149.125206] space_info 5 has 4931584 free, is full
> [ 1149.125208] space_info total=48234496, used=43302912, pinned=0, reserved=0, may_use=294912, readonly=0
> 
> 
> 7028 int btrfs_free_block_groups(struct btrfs_fs_info *info)
> ...
> 7083         while(!list_empty(&info->space_info)) {
> 7084                 space_info = list_entry(info->space_info.next,
> 7085                                         struct btrfs_space_info,
> 7086                                         list);
> 7087                 if (space_info->bytes_pinned > 0 ||
> 7088                     space_info->bytes_reserved > 0 ||
> 7089                     space_info->bytes_may_use > 0) {
> 
> 7090                         WARN_ON(1);
> 
> 7091                         dump_space_info(space_info, 0, 0);
> 7092                 }
> 7093                 list_del(&space_info->list);
> 7094                 kfree(space_info);
> 7095         }
> 7096         return 0;
> 7097 }
> 
> 
> david
