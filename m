Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:56817 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932393AbdJJPzG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 11:55:06 -0400
From: Tejun Heo <tj@kernel.org>
To: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup, buffer_head: implement submit_bh_blkcg_css()
Date: Tue, 10 Oct 2017 08:54:40 -0700
Message-Id: <20171010155441.753966-5-tj@kernel.org>
In-Reply-To: <20171010155441.753966-1-tj@kernel.org>
References: <20171010155441.753966-1-tj@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Implement submit_bh_blkcg_css() which will be used to override cgroup
membership on specific buffer_heads.

v2: Reimplemented using create_bh_bio() as suggested by Jan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/buffer.c                 | 12 ++++++++++++
 include/linux/buffer_head.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index b4b2169..ed0e473 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3147,6 +3147,18 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 	return 0;
 }
 
+int submit_bh_blkcg_css(int op, int op_flags, struct buffer_head *bh,
+			struct cgroup_subsys_state *blkcg_css)
+{
+	struct bio *bio;
+
+	bio = create_bh_bio(op, op_flags, bh, 0);
+	bio_associate_blkcg(bio, blkcg_css);
+	submit_bio(bio);
+	return 0;
+}
+EXPORT_SYMBOL(submit_bh_blkcg_css);
+
 int submit_bh(int op, int op_flags, struct buffer_head *bh)
 {
 	struct bio *bio;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index c8dae55..dca5b3b 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/cgroup.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -197,6 +198,8 @@ void ll_rw_block(int, int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int op_flags);
 void write_dirty_buffer(struct buffer_head *bh, int op_flags);
+int submit_bh_blkcg_css(int op, int op_flags, struct buffer_head *bh,
+			struct cgroup_subsys_state *blkcg_css);
 int submit_bh(int, int, struct buffer_head *);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
-- 
2.9.5

