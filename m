Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:55824 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755152AbdJIV3Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Oct 2017 17:29:25 -0400
From: Tejun Heo <tj@kernel.org>
To: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] cgroup, writeback: implement submit_bh_blkcg_css()
Date: Mon,  9 Oct 2017 14:29:10 -0700
Message-Id: <20171009212911.473208-3-tj@kernel.org>
In-Reply-To: <20171009212911.473208-1-tj@kernel.org>
References: <20171009212911.473208-1-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add wbc->blkcg_css so that the blkcg_css association can be specified
independently and implement submit_bh_blkcg_css() using it.  This will
be used to override cgroup membership on specific buffer_heads.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/buffer.c                 | 12 ++++++++++++
 fs/fs-writeback.c           |  1 +
 include/linux/buffer_head.h | 11 +++++++++++
 include/linux/writeback.h   |  6 ++++--
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 170df85..fac4f9a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3143,6 +3143,18 @@ int submit_bh(int op, int op_flags, struct buffer_head *bh)
 }
 EXPORT_SYMBOL(submit_bh);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+int submit_bh_blkcg_css(int op, int op_flags,  struct buffer_head *bh,
+			struct cgroup_subsys_state *blkcg_css)
+{
+	struct writeback_control wbc = { .blkcg_css = blkcg_css };
+
+	/* @wbc is used just to override the bio's blkcg_css */
+	return submit_bh_wbc(op, op_flags, bh, 0, &wbc);
+}
+EXPORT_SYMBOL(submit_bh_blkcg_css);
+#endif
+
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
  * @op: whether to %READ or %WRITE
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 245c430..cd882e6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -538,6 +538,7 @@ void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 	}
 
 	wbc->wb = inode_to_wb(inode);
+	wbc->blkcg_css = wbc->wb->blkcg_css;
 	wbc->inode = inode;
 
 	wbc->wb_id = wbc->wb->memcg_css->id;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c8dae55..abb4dd4 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/cgroup.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -205,6 +206,16 @@ int bh_submit_read(struct buffer_head *bh);
 loff_t page_cache_seek_hole_data(struct inode *inode, loff_t offset,
 				 loff_t length, int whence);
 
+#ifdef CONFIG_CGROUP_WRITEBACK
+int submit_bh_blkcg(int op, int op_flags, struct buffer_head *bh,
+		    struct cgroup_subsys_state *blkcg_css);
+#else
+static inline int submit_bh_blkcg(int op, int op_flags, struct buffer_head *bh,
+				  struct cgroup_subsys_state *blkcg_css)
+{
+	return submit_bh(op, op_flags, bh);
+}
+#endif
 extern int buffer_heads_over_limit;
 
 /*
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d581579..81e5946 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -91,6 +91,8 @@ struct writeback_control {
 	unsigned for_sync:1;		/* sync(2) WB_SYNC_ALL writeback */
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct bdi_writeback *wb;	/* wb this writeback is issued under */
+	struct cgroup_subsys_state *blkcg_css; /* usually wb->blkcg_css but
+						  may be overridden */
 	struct inode *inode;		/* inode being written out */
 
 	/* foreign inode detection, see wbc_detach_inode() */
@@ -277,8 +279,8 @@ static inline void wbc_init_bio(struct writeback_control *wbc, struct bio *bio)
 	 * behind a slow cgroup.  Ultimately, we want pageout() to kick off
 	 * regular writeback instead of writing things out itself.
 	 */
-	if (wbc->wb)
-		bio_associate_blkcg(bio, wbc->wb->blkcg_css);
+	if (wbc->blkcg_css)
+		bio_associate_blkcg(bio, wbc->blkcg_css);
 }
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
-- 
2.9.5

