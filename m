Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38068 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754387AbdGUR3N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 13:29:13 -0400
Received: by mail-qt0-f194.google.com with SMTP id 14so59517qtn.5
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 10:29:13 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 2/3] btrfs: fix readdir deadlock with pagefault
Date: Fri, 21 Jul 2017 13:29:08 -0400
Message-Id: <1500658149-20410-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1500658149-20410-1-git-send-email-jbacik@fb.com>
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Readdir does dir_emit while under the btree lock.  dir_emit can trigger
the page fault which means we can deadlock.  Fix this by allocating a
buffer on opening a directory and copying the readdir into this buffer
and doing dir_emit from outside of the tree lock.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 110 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 83 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a4413a..61396e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5877,6 +5877,56 @@ unsigned char btrfs_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
+/*
+ * All this infrastructure exists because dir_emit can fault, and we are holding
+ * the tree lock when doing readdir.  For now just allocate a buffer and copy
+ * our information into that, and then dir_emit from the buffer.  This is
+ * similar to what NFS does, only we don't keep the buffer around in pagecache
+ * because I'm afraid I'll fuck that up.  Long term we need to make filldir do
+ * copy_to_user_inatomic so we don't have to worry about page faulting under the
+ * tree lock.
+ */
+static int btrfs_opendir(struct inode *inode, struct file *file)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+	file->private_data = page;
+	return 0;
+}
+
+static int btrfs_closedir(struct inode *inode, struct file *file)
+{
+	if (file->private_data) {
+		__free_page((struct page *)file->private_data);
+		file->private_data = NULL;
+	}
+	return 0;
+}
+
+struct dir_entry {
+	u64 ino;
+	u64 offset;
+	unsigned type;
+	int name_len;
+};
+
+static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
+{
+	while (entries--) {
+		struct dir_entry *entry = addr;
+		char *name = (char *)(entry + 1);
+		ctx->pos = entry->offset;
+		if (!dir_emit(ctx, name, entry->name_len, entry->ino,
+			      entry->type))
+			return 1;
+		ctx->pos++;
+	}
+	return 0;
+}
+
 static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
@@ -5886,16 +5936,17 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct btrfs_path *path;
+	struct page *page = file->private_data;
+	void *addr, *start_addr;
 	struct list_head ins_list;
 	struct list_head del_list;
 	int ret;
 	struct extent_buffer *leaf;
 	int slot;
-	unsigned char d_type;
-	int over = 0;
-	char tmp_name[32];
 	char *name_ptr;
 	int name_len;
+	int entries = 0;
+	int total_len = 0;
 	bool put = false;
 	struct btrfs_key location;
 
@@ -5906,6 +5957,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (!path)
 		return -ENOMEM;
 
+	start_addr = addr = kmap(page);
 	path->reada = READA_FORWARD;
 
 	INIT_LIST_HEAD(&ins_list);
@@ -5921,6 +5973,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 		goto err;
 
 	while (1) {
+		struct dir_entry *entry;
 		leaf = path->nodes[0];
 		slot = path->slots[0];
 		if (slot >= btrfs_header_nritems(leaf)) {
@@ -5942,41 +5995,42 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			goto next;
 		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
 			goto next;
-
-		ctx->pos = found_key.offset;
-
 		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
 		if (verify_dir_item(fs_info, leaf, slot, di))
 			goto next;
 
 		name_len = btrfs_dir_name_len(leaf, di);
-		if (name_len <= sizeof(tmp_name)) {
-			name_ptr = tmp_name;
-		} else {
-			name_ptr = kmalloc(name_len, GFP_KERNEL);
-			if (!name_ptr) {
-				ret = -ENOMEM;
-				goto err;
-			}
+		if ((total_len + sizeof(struct dir_entry) + name_len) >=
+		    PAGE_SIZE) {
+			btrfs_release_path(path);
+			ret = btrfs_filldir(start_addr, entries, ctx);
+			if (ret)
+				goto nopos;
+			addr = start_addr;
+			entries = 0;
+			total_len = 0;
 		}
+
+		entry = addr;
+		entry->name_len = name_len;
+		name_ptr = (char *)(entry + 1);
 		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
 				   name_len);
-
-		d_type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
+		entry->type = btrfs_filetype_table[btrfs_dir_type(leaf, di)];
 		btrfs_dir_item_key_to_cpu(leaf, di, &location);
-
-		over = !dir_emit(ctx, name_ptr, name_len, location.objectid,
-				 d_type);
-
-		if (name_ptr != tmp_name)
-			kfree(name_ptr);
-
-		if (over)
-			goto nopos;
-		ctx->pos++;
+		entry->ino = location.objectid;
+		entry->offset = found_key.offset;
+		entries++;
+		addr += sizeof(struct dir_entry) + name_len;
+		total_len += sizeof(struct dir_entry) + name_len;
 next:
 		path->slots[0]++;
 	}
+	btrfs_release_path(path);
+
+	ret = btrfs_filldir(start_addr, entries, ctx);
+	if (ret)
+		goto nopos;
 
 	ret = btrfs_readdir_delayed_dir_index(ctx, &ins_list);
 	if (ret)
@@ -6006,6 +6060,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 nopos:
 	ret = 0;
 err:
+	kunmap(page);
 	if (put)
 		btrfs_readdir_put_delayed_items(inode, &ins_list, &del_list);
 	btrfs_free_path(path);
@@ -10777,11 +10832,12 @@ static const struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= btrfs_real_readdir,
+	.open		= btrfs_opendir,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= btrfs_compat_ioctl,
 #endif
-	.release        = btrfs_release_file,
+	.release        = btrfs_closedir,
 	.fsync		= btrfs_sync_file,
 };
 
-- 
2.7.4

