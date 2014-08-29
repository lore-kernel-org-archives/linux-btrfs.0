Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:56483 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbaH2Szg (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Fri, 29 Aug 2014 14:55:36 -0400
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH v2] Btrfs: fix crash while doing a ranged fsync
Date: Fri, 29 Aug 2014 20:54:26 +0100
Message-Id: <1409342066-19847-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
References: <1409315868-29734-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While doing a ranged fsync, that is, one whose range doesn't cover the
whole possible file range (0 to LLONG_MAX), we can crash under certain
circumstances with a trace like the following:

[41074.641913] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
(...)
[41074.642692] CPU: 0 PID: 24580 Comm: fsx Not tainted 3.16.0-fdm-btrfs-next-45+ #1
(...)
[41074.643886] RIP: 0010:[<ffffffffa01ecc99>]  [<ffffffffa01ecc99>] btrfs_ordered_update_i_size+0x279/0x2b0 [btrfs]
(...)
[41074.644919] Stack:
(...)
[41074.644919] Call Trace:
[41074.644919]  [<ffffffffa01db531>] btrfs_truncate_inode_items+0x3f1/0xa10 [btrfs]
[41074.644919]  [<ffffffffa01eb54f>] ? btrfs_get_logged_extents+0x4f/0x80 [btrfs]
[41074.644919]  [<ffffffffa02137a9>] btrfs_log_inode+0x2f9/0x970 [btrfs]
[41074.644919]  [<ffffffff81090875>] ? sched_clock_local+0x25/0xa0
[41074.644919]  [<ffffffff8164a55e>] ? mutex_unlock+0xe/0x10
[41074.644919]  [<ffffffff810af51d>] ? trace_hardirqs_on+0xd/0x10
[41074.644919]  [<ffffffffa0214b4f>] btrfs_log_inode_parent+0x1ef/0x560 [btrfs]
[41074.644919]  [<ffffffff811d0c55>] ? dget_parent+0x5/0x180
[41074.644919]  [<ffffffffa0215d11>] btrfs_log_dentry_safe+0x51/0x80 [btrfs]
[41074.644919]  [<ffffffffa01e2d1a>] btrfs_sync_file+0x1ba/0x3e0 [btrfs]
[41074.644919]  [<ffffffff811eda6b>] vfs_fsync_range+0x1b/0x30
(...)

The necessary conditions that lead to such crash are:

* an incremental fsync (when the inode doesn't have the
  BTRFS_INODE_NEEDS_FULL_SYNC flag set) happened for our file and it logged
  a file extent item ending at offset X;

* the file got the flag BTRFS_INODE_NEEDS_FULL_SYNC set in its inode, due
  to a file truncate operation that reduces the file to a size smaller
  than X;

* a ranged fsync call happens (via an msync for example), with a range that
  doesn't cover the whole file and the end of this range, lets call it Y, is
  smaller than X;

* btrfs_log_inode, sees the flag BTRFS_INODE_NEEDS_FULL_SYNC set and
  calls btrfs_truncate_inode_items() to remove all items from the log
  tree that are associated with our file;

* btrfs_truncate_inode_items() removes all of the inode's items, and the lowest
  file extent item it removed is the one ending at offset X, where X > 0 and
  X > Y - before returning, it calls btrfs_ordered_update_i_size() with an offset
  parameter set to X;

* btrfs_ordered_update_i_size() sees that X is greater then the current ordered
  size (btrfs_inode's disk_i_size) and then it assumes there can't be any ongoing
  ordered operation with a range covering the offset X, calling a BUG_ON() if
  such ordered operation exists. This assumption is made because the disk_i_size
  is only increased after the corresponding file extent item is added to the
  btree (btrfs_finish_ordered_io);

* But because our fsync covers only a limited range, such an ordered extent might
  exist, and our fsync callback (btrfs_sync_file) doesn't wait for such ordered
  extent to finish when calling btrfs_wait_ordered_range();

And then by the time btrfs_ordered_update_i_size() is called, via:

   btrfs_sync_file() ->
       btrfs_log_dentry_safe() ->
           btrfs_log_inode_parent() ->
               btrfs_log_inode() ->
                   btrfs_truncate_inode_items() ->
                       btrfs_ordered_update_i_size()

We hit the BUG_ON(), which could never happen if the fsync range covered the whole
possible file range (0 to LLONG_MAX), as we would wait for all ordered extents to
finish before calling btrfs_truncate_inode_items().

So just don't call btrfs_ordered_update_i_size() if we're removing the inode's items
from a log tree, which isn't supposed to change the in memory inode's disk_i_size.

Issue found while running xfstests/generic/127 (happens very rarely for me), more
specifically via the fsx calls that use memory mapped IO (and issue msync calls).

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Updated commit message, such that it reflects the fact that ranged fsyncs are
    not used only by msync.

 fs/btrfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 16e8146..c5ef9eb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4296,7 +4296,8 @@ out:
 			btrfs_abort_transaction(trans, root, ret);
 	}
 error:
-	if (last_size != (u64)-1)
+	if (last_size != (u64)-1 &&
+	    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 		btrfs_ordered_update_i_size(inode, last_size, NULL);
 	btrfs_free_path(path);
 	return err;
-- 
1.9.1

