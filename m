Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52352 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034316AbdEYKjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 06:39:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] btrfs: btrfs_wait_tree_block_writeback can be void return
Date: Thu, 25 May 2017 06:39:52 -0400
Message-Id: <20170525103952.7173-1-jlayton@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nothing checks its return value.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/disk-io.c | 6 +++---
 fs/btrfs/disk-io.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8685d67185d0..17acb72fed0f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1222,10 +1222,10 @@ int btrfs_write_tree_block(struct extent_buffer *buf)
 					buf->start + buf->len - 1);
 }
 
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
+void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
 {
-	return filemap_fdatawait_range(buf->pages[0]->mapping,
-				       buf->start, buf->start + buf->len - 1);
+	filemap_fdatawait_range(buf->pages[0]->mapping,
+			        buf->start, buf->start + buf->len - 1);
 }
 
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 21f1ceb85b76..f92f3e177d70 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -127,7 +127,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 			extent_submit_bio_hook_t *submit_bio_done);
 unsigned long btrfs_async_submit_limit(struct btrfs_fs_info *info);
 int btrfs_write_tree_block(struct extent_buffer *buf);
-int btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
+void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
-- 
2.9.4

