From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 1/2] vfs: make writeback_in_progress() inline
Date: Tue, 06 Dec 2011 13:35:45 +0800
Message-ID: <4EDDA9B1.5050000@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>
To: viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Ito <t-itoh@jp.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

writeback_in_progress() is very simple, and we will use writeback_in_progress()
in the module, so make it inline.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/fs-writeback.c           |   12 ------------
 include/linux/backing-dev.h |   12 +++++++++++-
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 04cf3b9..341448c 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -59,18 +59,6 @@ struct wb_writeback_work {
  */
 int nr_pdflush_threads;
 
-/**
- * writeback_in_progress - determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback waiting to be handled against a
- * backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return test_bit(BDI_writeback_running, &bdi->state);
-}
-
 static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3b2f9cb..ae4d7c0 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -258,7 +258,17 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 extern struct backing_dev_info default_backing_dev_info;
 extern struct backing_dev_info noop_backing_dev_info;
 
-int writeback_in_progress(struct backing_dev_info *bdi);
+/**
+ * writeback_in_progress - determine whether there is writeback in progress
+ * @bdi: the device's backing_dev_info structure.
+ *
+ * Determine whether there is writeback waiting to be handled against a
+ * backing device.
+ */
+static inline int writeback_in_progress(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_writeback_running, &bdi->state);
+}
 
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
-- 
1.7.6.4
