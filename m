From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] Invalidate dcache entry after creating snapshot and
 subvolume
Date: Sat, 31 May 2008 21:29:25 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805312117070.4246@titan.stealer.net>
References: <alpine.LNX.1.10.0805280011160.5461@titan.stealer.net> <20080528050853.GA23213@infradead.org> <200805280941.05046.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805280941.05046.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

We need to invalidate an existing dcache entry after creating a new 
snapshot or subvolume, because a negative dache entry will stop us from 
accessing the new snapshot or subvolume.

---
  ctree.h       |   23 +++++++++++++++++++++++
  inode.c       |    4 ++++
  transaction.c |    4 ++++
  3 files changed, 31 insertions(+)

diff -r 4b7e2b315a32 ctree.h
--- a/ctree.h	Thu May 29 10:31:43 2008 -0400
+++ b/ctree.h	Sat May 31 19:10:37 2008 +0000
@@ -1326,6 +1326,29 @@
  #endif
  }

+/*
+ * Invalidate a single dcache entry at the root of the filesystem.
+ * Needed after creation of snapshot or subvolume.
+ */
+
+static inline void invalidate_dcache_root(struct btrfs_root *root, char *name) {
+	struct dentry *alias, *entry;
+	struct qstr qstr;
+
+	alias = d_find_alias(root->fs_info->sb->s_root->d_inode);
+	if (alias) {
+		qstr.name = name;
+		qstr.len = strlen(qstr.name);
+		qstr.hash = full_name_hash(qstr.name, qstr.len);
+		entry = d_lookup(alias, &qstr);
+		dput(alias);
+		if (entry) {
+			d_invalidate(entry);
+			dput(entry);
+		}
+	}
+}
+
  /* extent-tree.c */
  u32 btrfs_count_snapshots_in_path(struct btrfs_root *root,
  				  struct btrfs_path *count_path,
diff -r 4b7e2b315a32 inode.c
--- a/inode.c	Thu May 29 10:31:43 2008 -0400
+++ b/inode.c	Sat May 31 19:10:37 2008 +0000
@@ -2761,6 +2761,10 @@
  	ret = btrfs_update_inode(trans, new_root, inode);
  	if (ret)
  		goto fail;
+
+	/* Invalidate existing dcache entry for new subvolume. */
+	invalidate_dcache_root(root, name);
+
  fail:
  	nr = trans->blocks_used;
  	err = btrfs_commit_transaction(trans, new_root);
diff -r 4b7e2b315a32 transaction.c
--- a/transaction.c	Thu May 29 10:31:43 2008 -0400
+++ b/transaction.c	Sat May 31 19:10:37 2008 +0000
@@ -604,6 +604,10 @@
  	ret = btrfs_insert_inode_ref(trans, root->fs_info->tree_root,
  			     pending->name, strlen(pending->name), objectid,
  			     root->fs_info->sb->s_root->d_inode->i_ino);
+
+	/* Invalidate existing dcache entry for new snapshot. */
+	invalidate_dcache_root(root, pending->name);
+
  fail:
  	kfree(new_root_item);
  	return ret;
