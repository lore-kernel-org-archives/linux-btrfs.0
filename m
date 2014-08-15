Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56606 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaHOC7Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 22:59:16 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com, hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v3 1/2] fs/super.c: add new super block sub devices super_block_dev
Date: Thu, 14 Aug 2014 19:58:57 -0700
Message-Id: <1408071538-14354-2-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Modern filesystems are using the get_anon_bdev() for internal
notions of volumes, snapshots for a single super block but never
exposing them directly to the VFS layer. While this works its
leaves the VFS layer growing dumb over what filesystems are doing.
This creates a new super block subdevice which we can use to start
stuffing in information about the underlying bdev's and its
associated super block to start off with. This at least now lets
us implement proper support for ustat() once filesystems are
modified to use this data structure and respective helpers.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 fs/super.c         | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h | 10 ++++++++
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index d20d5b1..d871892 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -133,6 +133,68 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 	return total_objects;
 }
 
+static bool super_dev_match(struct super_block *sb, dev_t dev)
+{
+	struct super_block_dev *sbdev;
+
+	if (sb->s_dev == dev)
+		return true;
+
+	if (list_empty(&sb->s_sbdevs))
+		return false;
+
+	list_for_each_entry(sbdev, &sb->s_sbdevs, entry)
+		if (sbdev->anon_dev ==  dev)
+			return true;
+
+	return false;
+}
+
+int insert_anon_sbdev(struct super_block *sb, struct super_block_dev *sbdev)
+{
+	int ret;
+
+	ret = get_anon_bdev(&sbdev->anon_dev);
+	if (ret)
+		return ret;
+
+	sbdev->sb = sb;
+
+	spin_lock(&sb_lock);
+	list_add_tail(&sbdev->entry, &sb->s_sbdevs);
+	spin_unlock(&sb_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(insert_anon_sbdev);
+
+void remove_anon_sbdev(struct super_block_dev *sbdev)
+{
+	struct super_block *sb;
+	struct super_block_dev *sbdev_i, *tmp;
+
+	if (!sbdev)
+		return;
+
+	sb = sbdev->sb;
+
+	spin_lock(&sb_lock);
+
+	WARN_ON(list_empty(&sb->s_sbdevs));
+
+	list_for_each_entry_safe(sbdev_i, tmp, &sb->s_sbdevs, entry) {
+		if (sbdev == sbdev_i) {
+			list_del_init(&sbdev_i->entry);
+			break;
+		}
+	}
+
+	spin_unlock(&sb_lock);
+
+	free_anon_bdev(sbdev->anon_dev);
+}
+EXPORT_SYMBOL_GPL(remove_anon_sbdev);
+
 /**
  *	destroy_super	-	frees a superblock
  *	@s: superblock to free
@@ -148,6 +210,7 @@ static void destroy_super(struct super_block *s)
 		percpu_counter_destroy(&s->s_writers.counter[i]);
 	security_sb_free(s);
 	WARN_ON(!list_empty(&s->s_mounts));
+	WARN_ON(!list_empty(&s->s_sbdevs));
 	kfree(s->s_subtype);
 	kfree(s->s_options);
 	kfree_rcu(s, rcu);
@@ -188,6 +251,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	INIT_HLIST_NODE(&s->s_instances);
 	INIT_HLIST_BL_HEAD(&s->s_anon);
 	INIT_LIST_HEAD(&s->s_inodes);
+	INIT_LIST_HEAD(&s->s_sbdevs);
 
 	if (list_lru_init(&s->s_dentry_lru))
 		goto fail;
@@ -652,7 +716,7 @@ restart:
 	spin_unlock(&sb_lock);
 	return NULL;
 }
- 
+
 struct super_block *user_get_super(dev_t dev)
 {
 	struct super_block *sb;
@@ -662,7 +726,7 @@ rescan:
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		if (hlist_unhashed(&sb->s_instances))
 			continue;
-		if (sb->s_dev ==  dev) {
+		if (super_dev_match(sb, dev)) {
 			sb->s_count++;
 			spin_unlock(&sb_lock);
 			down_read(&sb->s_umount);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f0890e4..c9152ac 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1197,6 +1197,13 @@ struct sb_writers {
 #endif
 };
 
+/* we can expand this to help the VFS layer with modern filesystems */
+struct super_block_dev {
+	struct super_block	*sb;
+	struct list_head	entry;		/* For struct sb->s_sbdevs */
+	dev_t			anon_dev;
+};
+
 struct super_block {
 	struct list_head	s_list;		/* Keep this first */
 	dev_t			s_dev;		/* search index; _not_ kdev_t */
@@ -1221,6 +1228,7 @@ struct super_block {
 
 	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+	struct list_head	s_sbdevs;	/* internal fs dev_t */
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
@@ -1821,6 +1829,8 @@ void deactivate_locked_super(struct super_block *sb);
 int set_anon_super(struct super_block *s, void *data);
 int get_anon_bdev(dev_t *);
 void free_anon_bdev(dev_t);
+int insert_anon_sbdev(struct super_block *sb, struct super_block_dev *sbdev);
+void remove_anon_sbdev(struct super_block_dev *sbdev);
 struct super_block *sget(struct file_system_type *type,
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
-- 
2.0.3

