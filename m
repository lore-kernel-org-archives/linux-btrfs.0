Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34661 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab3LFN7U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Dec 2013 08:59:20 -0500
Date: Fri, 6 Dec 2013 21:58:37 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Pedro Fonseca <pfonseca@mpi-sws.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Null pointer oops when deleting item in btrfs_find_all_root()
Message-ID: <20131206135836.GD20595@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <52A1CAA5.8090302@mpi-sws.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52A1CAA5.8090302@mpi-sws.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 06, 2013 at 02:01:25PM +0100, Pedro Fonseca wrote:
> Hi,
> 
> I've encountered another null pointer bug in btrfs_find_all_root().
> 
> It may be releated to a bug I previously reported to the mailing
> list ("Null pointer dereference bug in btrfs_find_all_root"). But
> this test ran on kernel version 3.12.2 and the oops was triggered
> when deleting an item from the list. The actual workload (i.e. FS
> operations) is similar though.

Not sure if the following commit[1] has been merged in this 3.12.2,
any chance to check it?

-liubo


[1]:
commit 48ec47364b6d493f0a9cdc116977bf3f34e5c3ec
Author: Liu Bo <bo.li.liu@oracle.com>
Date:   Wed Oct 30 13:25:24 2013 +0800

    Btrfs: fix a crash when running balance and defrag concurrently
    
    Running balance and defrag concurrently can end up with a crash:
    
    kernel BUG at fs/btrfs/relocation.c:4528!
    RIP: 0010:[<ffffffffa01ac33b>]  [<ffffffffa01ac33b>] btrfs_reloc_cow_block+ 0x1eb/0x230 [btrfs]
    Call Trace:
      [<ffffffffa01398c1>] ? update_ref_for_cow+0x241/0x380 [btrfs]
      [<ffffffffa0180bad>] ? copy_extent_buffer+0xad/0x110 [btrfs]
      [<ffffffffa0139da1>] __btrfs_cow_block+0x3a1/0x520 [btrfs]
      [<ffffffffa013a0b6>] btrfs_cow_block+0x116/0x1b0 [btrfs]
      [<ffffffffa013ddad>] btrfs_search_slot+0x43d/0x970 [btrfs]
      [<ffffffffa0153c57>] btrfs_lookup_file_extent+0x37/0x40 [btrfs]
      [<ffffffffa0172a5e>] __btrfs_drop_extents+0x11e/0xae0 [btrfs]
      [<ffffffffa013b3fd>] ? generic_bin_search.constprop.39+0x8d/0x1a0 [btrfs]
      [<ffffffff8117d14a>] ? kmem_cache_alloc+0x1da/0x200
      [<ffffffffa0138e7a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
      [<ffffffffa0173ef0>] btrfs_drop_extents+0x60/0x90 [btrfs]
      [<ffffffffa016b24d>] relink_extent_backref+0x2ed/0x780 [btrfs]
      [<ffffffffa0162fe0>] ? btrfs_submit_bio_hook+0x1e0/0x1e0 [btrfs]
      [<ffffffffa01b8ed7>] ? iterate_inodes_from_logical+0x87/0xa0 [btrfs]
      [<ffffffffa016b909>] btrfs_finish_ordered_io+0x229/0xac0 [btrfs]
      [<ffffffffa016c3b5>] finish_ordered_fn+0x15/0x20 [btrfs]
      [<ffffffffa018cbe5>] worker_loop+0x125/0x4e0 [btrfs]
      [<ffffffffa018cac0>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
      [<ffffffff81075ea0>] kthread+0xc0/0xd0
      [<ffffffff81075de0>] ? insert_kthread_work+0x40/0x40
      [<ffffffff8164796c>] ret_from_fork+0x7c/0xb0
      [<ffffffff81075de0>] ? insert_kthread_work+0x40/0x40
    ----------------------------------------------------------------------
    
    It turns out to be that balance operation will bump root's @last_snapshot,
    which enables snapshot-aware defrag path, and backref walking stuff will
    find data reloc tree as refs' parent, and hit the BUG_ON() during COW.
    
    As data reloc tree's data is just for relocation purpose, and will be deleted right
    after relocation is done, it's unnecessary to walk those refs belonged to data reloc
    tree, it'd be better to skip them.
    
    Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
    Signed-off-by: Josef Bacik <jbacik@fusionio.com>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 721936a..30d24cf 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -185,6 +185,9 @@ static int __add_prelim_ref(struct list_head *head, u64 root_id,
 {
 	struct __prelim_ref *ref;
 
+	if (root_id == BTRFS_DATA_RELOC_TREE_OBJECTID)
+		return 0;
+
 	ref = kmem_cache_alloc(btrfs_prelim_ref_cache, gfp_mask);
 	if (!ref)
 		return -ENOMEM;
