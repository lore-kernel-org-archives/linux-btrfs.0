Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35254 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3JYPh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Oct 2013 11:37:57 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B76A29A0695
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 09:37:56 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id XpfRLr6OuTIMFiYi (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 25 Oct 2013 09:37:55 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop using vfs_read in send
Date: Fri, 25 Oct 2013 11:37:53 -0400
Message-ID: <1382715473-3949-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apparently we don't actually close the files until we return to userspace, so
stop using vfs_read in send.  This is actually better for us since we can avoid
all the extra logic of holding the file we're sending open and making sure to
clean it up.  This will fix people who have been hitting too many files open
errors when trying to send.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/send.c | 181 +++++++++++++++++++++++---------------------------------
 1 file changed, 73 insertions(+), 108 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eb4b458..2f43623 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -122,7 +122,6 @@ struct send_ctx {
 	struct list_head name_cache_list;
 	int name_cache_size;
 
-	struct file *cur_inode_filp;
 	char *read_buf;
 };
 
@@ -2128,77 +2127,6 @@ out:
 }
 
 /*
- * Called for regular files when sending extents data. Opens a struct file
- * to read from the file.
- */
-static int open_cur_inode_file(struct send_ctx *sctx)
-{
-	int ret = 0;
-	struct btrfs_key key;
-	struct path path;
-	struct inode *inode;
-	struct dentry *dentry;
-	struct file *filp;
-	int new = 0;
-
-	if (sctx->cur_inode_filp)
-		goto out;
-
-	key.objectid = sctx->cur_ino;
-	key.type = BTRFS_INODE_ITEM_KEY;
-	key.offset = 0;
-
-	inode = btrfs_iget(sctx->send_root->fs_info->sb, &key, sctx->send_root,
-			&new);
-	if (IS_ERR(inode)) {
-		ret = PTR_ERR(inode);
-		goto out;
-	}
-
-	dentry = d_obtain_alias(inode);
-	inode = NULL;
-	if (IS_ERR(dentry)) {
-		ret = PTR_ERR(dentry);
-		goto out;
-	}
-
-	path.mnt = sctx->mnt;
-	path.dentry = dentry;
-	filp = dentry_open(&path, O_RDONLY | O_LARGEFILE, current_cred());
-	dput(dentry);
-	dentry = NULL;
-	if (IS_ERR(filp)) {
-		ret = PTR_ERR(filp);
-		goto out;
-	}
-	sctx->cur_inode_filp = filp;
-
-out:
-	/*
-	 * no xxxput required here as every vfs op
-	 * does it by itself on failure
-	 */
-	return ret;
-}
-
-/*
- * Closes the struct file that was created in open_cur_inode_file
- */
-static int close_cur_inode_file(struct send_ctx *sctx)
-{
-	int ret = 0;
-
-	if (!sctx->cur_inode_filp)
-		goto out;
-
-	ret = filp_close(sctx->cur_inode_filp, NULL);
-	sctx->cur_inode_filp = NULL;
-
-out:
-	return ret;
-}
-
-/*
  * Sends a BTRFS_SEND_C_SUBVOL command/item to userspace
  */
 static int send_subvol_begin(struct send_ctx *sctx)
@@ -3630,6 +3558,72 @@ out:
 	return ret;
 }
 
+static ssize_t fill_read_buf(struct send_ctx *sctx, u64 offset, u32 len)
+{
+	struct btrfs_root *root = sctx->send_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct inode *inode;
+	struct page *page;
+	char *addr;
+	struct btrfs_key key;
+	pgoff_t index = offset >> PAGE_CACHE_SHIFT;
+	pgoff_t last_index;
+	unsigned pg_offset = offset & (PAGE_CACHE_SIZE - 1);
+	ssize_t ret = 0;
+
+	key.objectid = sctx->cur_ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	inode = btrfs_iget(fs_info->sb, &key, root, NULL);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	if (offset + len > i_size_read(inode)) {
+		if (offset > i_size_read(inode))
+			len = 0;
+		else
+			len = offset - i_size_read(inode);
+	}
+	if (len == 0)
+		goto out;
+
+	last_index = (offset + len - 1) >> PAGE_CACHE_SHIFT;
+	while (index <= last_index) {
+		unsigned cur_len = min_t(unsigned, len, PAGE_CACHE_SIZE);
+
+		page = find_or_create_page(inode->i_mapping, index, GFP_NOFS);
+		if (!page) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		if (!PageUptodate(page)) {
+			btrfs_readpage(NULL, page);
+			lock_page(page);
+			if (!PageUptodate(page)) {
+				unlock_page(page);
+				page_cache_release(page);
+				ret = -EIO;
+				break;
+			}
+		}
+
+		addr = kmap(page);
+		memcpy(sctx->read_buf + ret, addr + pg_offset, cur_len);
+		kunmap(page);
+		unlock_page(page);
+		page_cache_release(page);
+		index++;
+		pg_offset = 0;
+		len -= cur_len;
+		ret += cur_len;
+	}
+out:
+	iput(inode);
+	return ret;
+}
+
 /*
  * Read some bytes from the current inode/file and send a write command to
  * user space.
@@ -3638,35 +3632,20 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 {
 	int ret = 0;
 	struct fs_path *p;
-	loff_t pos = offset;
-	int num_read = 0;
-	mm_segment_t old_fs;
+	ssize_t num_read = 0;
 
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
-	/*
-	 * vfs normally only accepts user space buffers for security reasons.
-	 * we only read from the file and also only provide the read_buf buffer
-	 * to vfs. As this buffer does not come from a user space call, it's
-	 * ok to temporary allow kernel space buffers.
-	 */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
 verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);
 
-	ret = open_cur_inode_file(sctx);
-	if (ret < 0)
-		goto out;
-
-	ret = vfs_read(sctx->cur_inode_filp, sctx->read_buf, len, &pos);
-	if (ret < 0)
-		goto out;
-	num_read = ret;
-	if (!num_read)
+	num_read = fill_read_buf(sctx, offset, len);
+	if (num_read <= 0) {
+		if (num_read < 0)
+			ret = num_read;
 		goto out;
+	}
 
 	ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
 	if (ret < 0)
@@ -3685,7 +3664,6 @@ verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);
 tlv_put_failure:
 out:
 	fs_path_free(p);
-	set_fs(old_fs);
 	if (ret < 0)
 		return ret;
 	return num_read;
@@ -3789,14 +3767,11 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 	struct fs_path *p = NULL;
 	u64 offset = sctx->cur_inode_last_extent;
 	u64 len;
-	int ret;
+	int ret = 0;
 
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
-	ret = open_cur_inode_file(sctx);
-	if (ret < 0)
-		goto out;
 	memset(sctx->read_buf, 0, BTRFS_SEND_READ_SIZE);
 	while (offset < end) {
 		len = min_t(u64, end - offset, BTRFS_SEND_READ_SIZE);
@@ -3816,7 +3791,6 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 		offset += len;
 	}
 tlv_put_failure:
-out:
 	fs_path_free(p);
 	return ret;
 }
@@ -4281,10 +4255,6 @@ static int changed_inode(struct send_ctx *sctx,
 	u64 left_gen = 0;
 	u64 right_gen = 0;
 
-	ret = close_cur_inode_file(sctx);
-	if (ret < 0)
-		goto out;
-
 	sctx->cur_ino = key->objectid;
 	sctx->cur_inode_new_gen = 0;
 	sctx->cur_inode_last_extent = 0;
@@ -4769,11 +4739,6 @@ static int send_subvol(struct send_ctx *sctx)
 	}
 
 out:
-	if (!ret)
-		ret = close_cur_inode_file(sctx);
-	else
-		close_cur_inode_file(sctx);
-
 	free_recorded_refs(sctx);
 	return ret;
 }
-- 
1.8.3.1

