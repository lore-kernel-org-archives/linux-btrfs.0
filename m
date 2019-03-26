Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED25C4360F
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7214B20823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbfCZTDp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:37066 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732707AbfCZTDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17E1AADF2;
        Tue, 26 Mar 2019 19:03:40 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 11/15] fs: dedup file range to use a compare function
Date:   Tue, 26 Mar 2019 14:02:57 -0500
Message-Id: <20190326190301.32365-12-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

With dax we cannot deal with readpage() etc. So, we create a
funciton callback to perform the file data comparison and pass
it to generic_remap_file_range_prep() so it can use iomap-based
functions.

This may not be the best way to solve this. Suggestions welcome.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h     |  3 +++
 fs/btrfs/dax.c       |  7 +++++++
 fs/btrfs/ioctl.c     | 13 +++++++++++-
 fs/dax.c             | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ocfs2/file.c      |  2 +-
 fs/read_write.c      |  9 +++++---
 fs/xfs/xfs_reflink.c |  2 +-
 include/linux/dax.h  |  2 ++
 include/linux/fs.h   |  4 +++-
 9 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0e5060933bde..750f9c70fabe 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3803,6 +3803,9 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
 ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
 ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
 vm_fault_t btrfs_dax_fault(struct vm_fault *vmf);
+int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len,
+		bool *is_same);
 #else
 static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
 {
diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
index 927f962d1e88..9488cae0f8b4 100644
--- a/fs/btrfs/dax.c
+++ b/fs/btrfs/dax.c
@@ -168,4 +168,11 @@ vm_fault_t btrfs_dax_fault(struct vm_fault *vmf)
 
 	return ret;
 }
+
+int btrfs_dax_file_range_compare(struct inode *src, loff_t srcoff,
+		struct inode *dest, loff_t destoff, loff_t len,
+		bool *is_same)
+{
+	return dax_file_range_compare(src, srcoff, dest, destoff, len, is_same, &btrfs_iomap_ops);
+}
 #endif /* CONFIG_FS_DAX */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e66426e7692d..2e5137b01561 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3990,8 +3990,19 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret < 0)
 		goto out_unlock;
 
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(file_inode(file_in)) && IS_DAX(file_inode(file_out)))
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags,
+				btrfs_dax_file_range_compare);
+	else
+		ret = generic_remap_file_range_prep(file_in, pos_in, file_out,
+				pos_out, len, remap_flags, NULL);
+#else
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-					    len, remap_flags);
+						    len, remap_flags, NULL);
+#endif
+
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
diff --git a/fs/dax.c b/fs/dax.c
index 41061da42771..18998c5ee27a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1775,3 +1775,61 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 	return dax_insert_pfn_mkwrite(vmf, pfn, order);
 }
 EXPORT_SYMBOL_GPL(dax_finish_sync_fault);
+
+
+int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
+		loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops)
+{
+	void *saddr, *daddr;
+	struct iomap s_iomap = {0};
+	struct iomap d_iomap = {0};
+	loff_t dstart, sstart;
+	bool same = true;
+	loff_t cmp_len, l;
+	int id, ret = 0;
+
+	id = dax_read_lock();
+	while (len) {
+		ret = ops->iomap_begin(src, srcoff, len, 0, &s_iomap);
+		if (ret < 0) {
+			if (ops->iomap_end)
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+			return ret;
+		}
+		cmp_len = len;
+		if (cmp_len > s_iomap.offset + s_iomap.length - srcoff)
+			cmp_len = s_iomap.offset + s_iomap.length - srcoff;
+
+		ret = ops->iomap_begin(dest, destoff, cmp_len, 0, &d_iomap);
+		if (ret < 0) {
+			if (ops->iomap_end) {
+				ops->iomap_end(src, srcoff, len, ret, 0, &s_iomap);
+				ops->iomap_end(dest, destoff, len, ret, 0, &d_iomap);
+			}
+			return ret;
+		}
+		if (cmp_len > d_iomap.offset + d_iomap.length - destoff)
+			cmp_len = d_iomap.offset + d_iomap.length - destoff;
+
+
+		sstart = (get_start_sect(s_iomap.bdev) << 9) + s_iomap.addr + (srcoff - s_iomap.offset);
+		l = dax_direct_access(s_iomap.dax_dev, PHYS_PFN(sstart), PHYS_PFN(cmp_len), &saddr, NULL);
+		dstart = (get_start_sect(d_iomap.bdev) << 9) + d_iomap.addr + (destoff - d_iomap.offset);
+		l = dax_direct_access(d_iomap.dax_dev, PHYS_PFN(dstart), PHYS_PFN(cmp_len), &daddr, NULL);
+		same = !memcmp(saddr, daddr, cmp_len);
+		if (!same)
+			break;
+		len -= cmp_len;
+		srcoff += cmp_len;
+		destoff += cmp_len;
+
+		if (ops->iomap_end) {
+			ret = ops->iomap_end(src, srcoff, len, 0, 0, &s_iomap);
+			ret = ops->iomap_end(dest, destoff, len, 0, 0, &d_iomap);
+		}
+	}
+	dax_read_unlock(id);
+	*is_same = same;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dax_file_range_compare);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index d640c5f8a85d..6bf3e8fbb016 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2558,7 +2558,7 @@ static loff_t ocfs2_remap_file_range(struct file *file_in, loff_t pos_in,
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			&len, remap_flags);
+			&len, remap_flags, NULL);
 	if (ret < 0 || len == 0)
 		goto out_unlock;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 177ccc3d405a..da521a221213 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1855,7 +1855,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
-				  loff_t *len, unsigned int remap_flags)
+				  loff_t *len, unsigned int remap_flags, compare_range_t compare)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1914,8 +1914,11 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	 */
 	if (remap_flags & REMAP_FILE_DEDUP) {
 		bool		is_same = false;
-
-		ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
+		if (compare)
+			ret = compare(inode_in, pos_in,
+				inode_out, pos_out, *len, &is_same);
+		else
+			ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
 				inode_out, pos_out, *len, &is_same);
 		if (ret)
 			return ret;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 680ae7662a78..8907c7aa3f19 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1350,7 +1350,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
-			len, remap_flags);
+			len, remap_flags, NULL);
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 0dd316a74a29..a11bc7b1f526 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -157,6 +157,8 @@ vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
+int dax_file_range_compare(struct inode *src, loff_t srcoff, struct inode *dest,
+                loff_t destoff, loff_t len, bool *is_same, const struct iomap_ops *ops);
 
 #ifdef CONFIG_FS_DAX
 int __dax_zero_page_range(struct block_device *bdev,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b42df09b04c..22fe4324b22e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1880,10 +1880,12 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
+typedef int (compare_range_t)(struct inode *src, loff_t srcpos, struct inode *dest,
+		loff_t destpos, loff_t len, bool *is_same);
 extern int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 					 struct file *file_out, loff_t pos_out,
 					 loff_t *count,
-					 unsigned int remap_flags);
+					 unsigned int remap_flags, compare_range_t cmp);
 extern loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
 				  loff_t len, unsigned int remap_flags);
-- 
2.16.4

