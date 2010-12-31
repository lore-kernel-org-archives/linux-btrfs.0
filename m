From: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Subject: Re: [GIT PULL] [RFC PATCH 0/4] btrfs: Implement delayed directory
 name index insertion and deletion
Date: Sat, 1 Jan 2011 00:43:41 +0900
Message-ID: <20110101004341.667de4c4.kitayama@cl.bb4u.ne.jp>
References: <4CF602AD.8020205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF602AD.8020205@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

The HEAD of the perf-improve fails to boot on my virtual machine.

The system calls btrfs_delete_delayed_dir_index() with trans block_rsv set to NULL,
thus selects, in get_block_rsv(), empty_block_rsv whose reserve is 0 (and size is also 0), 
which leads to ENOSPC. I wonder below patch is enough reserve metadata to finish 
btrfs_recover_log_trees() without going to ENOSPC. I appreciate your review. 

Singed-Off-by: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 054744a..f26326b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3079,7 +3079,7 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
        path = btrfs_alloc_path();
        BUG_ON(!path);
 
-       trans = btrfs_start_transaction(fs_info->tree_root, 0);
+       trans = btrfs_start_transaction(fs_info->tree_root, 4);
 
        wc.trans = trans;
        wc.pin = 1;

Here's the log:

kernel BUG at fs/btrfs/tree-log.c:678!
invalid opcode: 0000 [#1] SMP 
last sysfs file: /sys/devices/virtual/bdi/btrfs-1/uevent
CPU 1 
Modules linked in: floppy mptspi mptscsih mptbase scsi_transport_spi [last unloaded: scsi_wait_scan]

Pid: 308, comm: mount Not tainted 2.6.36-perf-improve+ #1 440BX Desktop Reference Platform/VMware Virtual Platform
RIP: 0010:[<ffffffff811eb161>]  [<ffffffff811eb161>] drop_one_dir_item+0xd6/0xfb
RSP: 0018:ffff88007a5a5858  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: ffff88007d2b7800 RCX: ffff880037e8b240
RDX: 0000000000000000 RSI: ffffea0000c3ae68 RDI: 0000000000000206
RBP: ffff88007a5a58c8 R08: 00000000005e6760 R09: ffff88007a5a55e8
R10: ffff88007a5a55e0 R11: ffff88007a5a5648 R12: ffff880037e8b120
R13: ffff880037e98cc0 R14: ffff88007b371c90 R15: 0000000000000005
FS:  00007f37b63c4800(0000) GS:ffff880002040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f37b55f0190 CR3: 000000007a4d9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 308, threadinfo ffff88007a5a4000, task ffff88007a5c9720)
Stack:
 0000000000000005 0000000000000d75 ffff880037e98550 ffff880037dcf000
<0> 000000000016e730 0000000000000001 0000000000000100 00000000005e7b60
<0> ffff88007a46d000 ffff880037e8b120 ffff88007d2b7800 ffff880037e98550
Call Trace:
 [<ffffffff811ec339>] add_inode_ref+0x32a/0x403
 [<ffffffff811ec59a>] replay_one_buffer+0x188/0x209
 [<ffffffff811bafef>] ? verify_parent_transid+0x36/0xf9
 [<ffffffff811e8eb9>] walk_up_log_tree+0x109/0x1d1
 [<ffffffff811ec412>] ? replay_one_buffer+0x0/0x209
 [<ffffffff811e930f>] walk_log_tree+0x9b/0x187
 [<ffffffff811eaf73>] btrfs_recover_log_trees+0x18a/0x2a2
 [<ffffffff811ec412>] ? replay_one_buffer+0x0/0x209
 [<ffffffff811bb123>] ? btree_read_extent_buffer_pages+0x71/0xaf
 [<ffffffff811becfe>] open_ctree+0xf8f/0x12c6
 [<ffffffff811a69b4>] btrfs_get_sb+0x225/0x459
 [<ffffffff810fe143>] ? __kmalloc_track_caller+0x13a/0x14c
 [<ffffffff8110d458>] vfs_kern_mount+0xbd/0x1a7
 [<ffffffff8110d5aa>] do_kern_mount+0x4d/0xed
 [<ffffffff8112318e>] do_mount+0x754/0x7cb
 [<ffffffff810dae6d>] ? memdup_user+0x60/0x80
 [<ffffffff810daecb>] ? strndup_user+0x3e/0x54
 [<ffffffff8112328d>] sys_mount+0x88/0xc2
 [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
Code: de e8 8f e5 ff ff 85 c0 74 04 0f 0b eb fe 48 8b 55 a0 48 8b 7d a8 45 89 f9 4d 89 f0 4c 89 e9 48 89 de e8 65 bf fd ff 85 c0 74 04 <0f> 0b eb fe 4 
RIP  [<ffffffff811eb161>] drop_one_dir_item+0xd6/0xfb
 RSP <ffff88007a5a5858>
---[ end trace 2ec638d9e30d6102 ]---


On Wed, 01 Dec 2010 16:09:17 +0800
Miao Xie <miaox@cn.fujitsu.com> wrote:

> Compare with Ext3/4, the performance of file creation and deletion on btrfs is
> very poor. the reason is that btrfs must do a lot of b+ tree insertions, such as
> inode item, directory name item, directory name index and so on.
> 
> If we can do some delayed b+ tree insertion or deletion, we can improve the
> performance, so we made this patch which implemented delayed directory name
> index insertion and deletion.
> 
> Beside that, we found we must map the page every time we want to set a member
> variable of the inode item, it is inefficient. We just do it at first to reduce
> the times of mmap(). By this way, we can also improve the performance of file
> creation and deletion.
> 
> I did a quick test by the benchmark tool[1] and found we can improve the
> performance of file creation by ~11%, and file deletion by ~14%.
> 
> Before applying this patch:
> Create files:
> 	Total files: 50000
> 	Total time: 1.188547
> 	Average time: 0.000024
> Delete files:
> 	Total files: 50000
> 	Total time: 1.662012
> 	Average time: 0.000033
> 
> After applying this patch:
> Create files:
> 	Total files: 50000
> 	Total time: 1.057432
> 	Average time: 0.000021
> Delete files:
> 	Total files: 50000
> 	Total time: 1.422851
> 	Average time: 0.000028
> 
> You can also try out the patchset by pulling:
> 	git://repo.or.cz/linux-btrfs-devel.git perf-improve
> 
> [1] http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3
> 
> ---
>  fs/btrfs/Makefile            |    2 +-
>  fs/btrfs/btrfs_inode.h       |    2 +
>  fs/btrfs/ctree.c             |   13 +-
>  fs/btrfs/ctree.h             |   21 +-
>  fs/btrfs/delayed-dir-index.c |  790 ++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/delayed-dir-index.h |   92 +++++
>  fs/btrfs/dir-item.c          |   61 +++-
>  fs/btrfs/extent-tree.c       |   21 ++
>  fs/btrfs/inode.c             |  189 +++++++---
>  fs/btrfs/transaction.c       |    9 +
>  fs/btrfs/transaction.h       |    2 +
>  11 files changed, 1117 insertions(+), 85 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Itaru Kitayama <kitayama@cl.bb4.ne.jp>
