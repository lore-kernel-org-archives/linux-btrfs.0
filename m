Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37223 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbaJJU50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:26 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKu4rV028553
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:25 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxprq81mf-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:25 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 01/12] Btrfs-progs: repair missing dir index
Date: Fri, 10 Oct 2014 16:57:06 -0400
Message-ID: <1412974637-31334-2-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have an inode backref entry then we know enough to add back a missing dir
index.  When messing with the inode backrefs we need to do all of that first
before we process the inode recs themselves as we may clear errors on the inode
recs as we fix the directory indexes.  This adds the framework for fixing
backref errors and fixes missing dir index issues.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c                          | 121 +++++++++++++++++++++++++++++++++-
 tests/fsck-tests/004-no-dir-index.img | Bin 0 -> 4096 bytes
 2 files changed, 119 insertions(+), 2 deletions(-)
 create mode 100644 tests/fsck-tests/004-no-dir-index.img

diff --git a/cmds-check.c b/cmds-check.c
index 76df5ae..a7e0840 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1516,15 +1516,111 @@ static int repair_inode_orphan_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int add_missing_dir_index(struct btrfs_root *root,
+				 struct cache_tree *inode_cache,
+				 struct inode_record *rec,
+				 struct inode_backref *backref)
+{
+	struct btrfs_path *path;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_dir_item *dir_item;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	struct inode_record *dir_rec;
+	unsigned long name_ptr;
+	u32 data_size = sizeof(*dir_item) + backref->namelen;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		btrfs_free_path(path);
+		return PTR_ERR(trans);
+	}
+
+	fprintf(stderr, "repairing missing dir index item for inode %llu\n",
+		(unsigned long long)rec->ino);
+	key.objectid = backref->dir;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	key.offset = backref->index;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, data_size);
+	BUG_ON(ret);
+
+	leaf = path->nodes[0];
+	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
+
+	disk_key.objectid = cpu_to_le64(rec->ino);
+	disk_key.type = BTRFS_INODE_ITEM_KEY;
+	disk_key.offset = 0;
+
+	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	btrfs_set_dir_type(leaf, dir_item, imode_to_type(rec->imode));
+	btrfs_set_dir_data_len(leaf, dir_item, 0);
+	btrfs_set_dir_name_len(leaf, dir_item, backref->namelen);
+	name_ptr = (unsigned long)(dir_item + 1);
+	write_extent_buffer(leaf, backref->name, name_ptr, backref->namelen);
+	btrfs_mark_buffer_dirty(leaf);
+	btrfs_free_path(path);
+	btrfs_commit_transaction(trans, root);
+
+	backref->found_dir_index = 1;
+	dir_rec = get_inode_rec(inode_cache, backref->dir, 0);
+	if (!dir_rec)
+		return 0;
+	dir_rec->found_size += backref->namelen;
+	if (dir_rec->found_size == dir_rec->isize &&
+	    (dir_rec->errors & I_ERR_DIR_ISIZE_WRONG))
+		dir_rec->errors &= ~I_ERR_DIR_ISIZE_WRONG;
+	if (dir_rec->found_size != dir_rec->isize)
+		dir_rec->errors |= I_ERR_DIR_ISIZE_WRONG;
+
+	return 0;
+}
+
+static int repair_inode_backrefs(struct btrfs_root *root,
+				 struct inode_record *rec,
+				 struct cache_tree *inode_cache)
+{
+	struct inode_backref *tmp, *backref;
+	u64 root_dirid = btrfs_root_dirid(&root->root_item);
+	int ret = 0;
+
+	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
+		/* Index 0 for root dir's are special, don't mess with it */
+		if (rec->ino == root_dirid && backref->index == 0)
+			continue;
+
+		if (!backref->found_dir_index && backref->found_inode_ref) {
+			ret = add_missing_dir_index(root, inode_cache, rec,
+						    backref);
+			if (ret)
+				break;
+		}
+
+		if (backref->found_dir_item && backref->found_dir_index) {
+			if (!backref->errors && backref->found_inode_ref) {
+				list_del(&backref->list);
+				free(backref);
+			}
+		}
+	}
+
+	return ret;
+}
+
 static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	int ret = 0;
 
-	/* So far we just fix dir isize wrong */
 	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG | I_ERR_NO_ORPHAN_ITEM)))
-		return 1;
+		return rec->errors;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1562,6 +1658,27 @@ static int check_inode_recs(struct btrfs_root *root,
 		return 0;
 	}
 
+	/*
+	 * We need to repair backrefs first because we could change some of the
+	 * errors in the inode recs.
+	 *
+	 * For example, if we were missing a dir index then the directories
+	 * isize would be wrong, so if we fixed the isize to what we thought it
+	 * would be and then fixed the backref we'd still have a invalid fs, so
+	 * we need to add back the dir index and then check to see if the isize
+	 * is still wrong.
+	 */
+	cache = search_cache_extent(inode_cache, 0);
+	while (repair && cache) {
+		node = container_of(cache, struct ptr_node, cache);
+		rec = node->data;
+		cache = next_cache_extent(cache);
+
+		if (list_empty(&rec->backrefs))
+			continue;
+		repair_inode_backrefs(root, rec, inode_cache);
+	}
+
 	rec = get_inode_rec(inode_cache, root_dirid, 0);
 	if (rec) {
 		ret = check_root_dir(rec);
diff --git a/tests/fsck-tests/004-no-dir-index.img b/tests/fsck-tests/004-no-dir-index.img
new file mode 100644
index 0000000000000000000000000000000000000000..6f2483e6e4285e6703096b67c5153b3da3309b7b
GIT binary patch
literal 4096
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
Vz`wTS|0Ig(1o-l2+5Wd|{|(AQMP&d0

literal 0
HcmV?d00001

-- 
1.8.3.1

