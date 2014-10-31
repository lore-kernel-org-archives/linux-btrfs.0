Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14526 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003AbaJaSCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 14:02:39 -0400
From: Josef Bacik <jbacik@fb.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/11] Btrfs-progs: fix missing inode items
Date: Fri, 31 Oct 2014 14:01:27 -0400
Message-ID: <1414778489-4049-10-git-send-email-jbacik@fb.com>
In-Reply-To: <1414778489-4049-1-git-send-email-jbacik@fb.com>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we have all the other items but no inode item we can recreate it for the most
part, with the exception of the permissions and ownership.  Add this ability to
btrfsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index be75dcb..a30db8d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1727,6 +1727,61 @@ static int delete_dir_index(struct btrfs_root *root,
 	return ret;
 }
 
+static int create_inode_item(struct btrfs_root *root,
+			     struct inode_record *rec,
+			     struct inode_backref *backref, int root_dir)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_inode_item inode_item;
+	time_t now = time(NULL);
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		return ret;
+	}
+
+	fprintf(stderr, "root %llu inode %llu recreating inode item, this may "
+		"be incomplete, please check permissions and content after "
+		"the fsck completes.\n", (unsigned long long)root->objectid,
+		(unsigned long long)rec->ino);
+
+	memset(&inode_item, 0, sizeof(inode_item));
+	btrfs_set_stack_inode_generation(&inode_item, trans->transid);
+	if (root_dir)
+		btrfs_set_stack_inode_nlink(&inode_item, 1);
+	else
+		btrfs_set_stack_inode_nlink(&inode_item, rec->found_link);
+	btrfs_set_stack_inode_nbytes(&inode_item, rec->found_size);
+	if (rec->found_dir_item) {
+		if (rec->found_file_extent)
+			fprintf(stderr, "root %llu inode %llu has both a dir "
+				"item and extents, unsure if it is a dir or a "
+				"regular file so setting it as a directory\n",
+				(unsigned long long)root->objectid,
+				(unsigned long long)rec->ino);
+		btrfs_set_stack_inode_mode(&inode_item, S_IFDIR | 0755);
+		btrfs_set_stack_inode_size(&inode_item, rec->found_size);
+	} else if (!rec->found_dir_item) {
+		btrfs_set_stack_inode_size(&inode_item, rec->extent_end);
+		btrfs_set_stack_inode_mode(&inode_item, S_IFREG | 0755);
+	}
+	btrfs_set_stack_timespec_sec(&inode_item.atime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.atime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.ctime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.ctime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.mtime, now);
+	btrfs_set_stack_timespec_nsec(&inode_item.mtime, 0);
+	btrfs_set_stack_timespec_sec(&inode_item.otime, 0);
+	btrfs_set_stack_timespec_nsec(&inode_item.otime, 0);
+
+	ret = btrfs_insert_inode(trans, root, rec->ino, &inode_item);
+	BUG_ON(ret);
+	btrfs_commit_transaction(trans, root);
+	return 0;
+}
+
 static int repair_inode_backrefs(struct btrfs_root *root,
 				 struct inode_record *rec,
 				 struct cache_tree *inode_cache,
@@ -1738,6 +1793,15 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 	int repaired = 0;
 
 	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
+		if (!delete && rec->ino == root_dirid) {
+			if (!rec->found_inode_item) {
+				ret = create_inode_item(root, rec, backref, 1);
+				if (ret)
+					break;
+				repaired++;
+			}
+		}
+
 		/* Index 0 for root dir's are special, don't mess with it */
 		if (rec->ino == root_dirid && backref->index == 0)
 			continue;
@@ -1799,6 +1863,18 @@ static int repair_inode_backrefs(struct btrfs_root *root,
 			btrfs_commit_transaction(trans, root);
 			repaired++;
 		}
+
+		if (!delete && (backref->found_inode_ref &&
+				backref->found_dir_index &&
+				backref->found_dir_item &&
+				!(backref->errors & REF_ERR_INDEX_UNMATCH) &&
+				!rec->found_inode_item)) {
+			ret = create_inode_item(root, rec, backref, 0);
+			if (ret)
+				break;
+			repaired++;
+		}
+
 	}
 	return ret ? ret : repaired;
 }
-- 
1.8.3.1

