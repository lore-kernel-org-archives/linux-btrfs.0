From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH] btrfs: Remove unused sysfs code
Date: Thu, 16 Jun 2011 11:04:57 +0200
Message-ID: <4DF9C739.9010301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Hugo Mills <hugo@carfax.org.uk>
To: Chris Robinson <chris.kcat@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Removes code no longer used. The sysfs file itself is kept, because the
btrfs developers expressed interest in putting new entries to sysfs.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 378b5b4..81f4083 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1181,7 +1181,6 @@ struct btrfs_root {
 	struct btrfs_key defrag_max;
 	int defrag_running;
 	char *name;
-	int in_sysfs;
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9f68c68..5df6d8f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1044,7 +1044,6 @@ static int __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	root->last_trans = 0;
 	root->highest_objectid = 0;
 	root->name = NULL;
-	root->in_sysfs = 0;
 	root->inode_tree = RB_ROOT;
 	INIT_RADIX_TREE(&root->delayed_nodes_tree, GFP_ATOMIC);
 	root->block_rsv = NULL;
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index c3c223a..daac9ae 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -28,152 +28,6 @@
 #include "disk-io.h"
 #include "transaction.h"
 
-static ssize_t root_blocks_used_show(struct btrfs_root *root, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_root_used(&root->root_item));
-}
-
-static ssize_t root_block_limit_show(struct btrfs_root *root, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_root_limit(&root->root_item));
-}
-
-static ssize_t super_blocks_used_show(struct btrfs_fs_info *fs, char *buf)
-{
-
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_bytes_used(&fs->super_copy));
-}
-
-static ssize_t super_total_blocks_show(struct btrfs_fs_info *fs, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_total_bytes(&fs->super_copy));
-}
-
-static ssize_t super_blocksize_show(struct btrfs_fs_info *fs, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%llu\n",
-		(unsigned long long)btrfs_super_sectorsize(&fs->super_copy));
-}
-
-/* this is for root attrs (subvols/snapshots) */
-struct btrfs_root_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct btrfs_root *, char *);
-	ssize_t (*store)(struct btrfs_root *, const char *, size_t);
-};
-
-#define ROOT_ATTR(name, mode, show, store) \
-static struct btrfs_root_attr btrfs_root_attr_##name = __ATTR(name, mode, \
-							      show, store)
-
-ROOT_ATTR(blocks_used,	0444,	root_blocks_used_show,	NULL);
-ROOT_ATTR(block_limit,	0644,	root_block_limit_show,	NULL);
-
-static struct attribute *btrfs_root_attrs[] = {
-	&btrfs_root_attr_blocks_used.attr,
-	&btrfs_root_attr_block_limit.attr,
-	NULL,
-};
-
-/* this is for super attrs (actual full fs) */
-struct btrfs_super_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct btrfs_fs_info *, char *);
-	ssize_t (*store)(struct btrfs_fs_info *, const char *, size_t);
-};
-
-#define SUPER_ATTR(name, mode, show, store) \
-static struct btrfs_super_attr btrfs_super_attr_##name = __ATTR(name, mode, \
-								show, store)
-
-SUPER_ATTR(blocks_used,		0444,	super_blocks_used_show,		NULL);
-SUPER_ATTR(total_blocks,	0444,	super_total_blocks_show,	NULL);
-SUPER_ATTR(blocksize,		0444,	super_blocksize_show,		NULL);
-
-static struct attribute *btrfs_super_attrs[] = {
-	&btrfs_super_attr_blocks_used.attr,
-	&btrfs_super_attr_total_blocks.attr,
-	&btrfs_super_attr_blocksize.attr,
-	NULL,
-};
-
-static ssize_t btrfs_super_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *buf)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	struct btrfs_super_attr *a = container_of(attr,
-						  struct btrfs_super_attr,
-						  attr);
-
-	return a->show ? a->show(fs, buf) : 0;
-}
-
-static ssize_t btrfs_super_attr_store(struct kobject *kobj,
-				     struct attribute *attr,
-				     const char *buf, size_t len)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	struct btrfs_super_attr *a = container_of(attr,
-						  struct btrfs_super_attr,
-						  attr);
-
-	return a->store ? a->store(fs, buf, len) : 0;
-}
-
-static ssize_t btrfs_root_attr_show(struct kobject *kobj,
-				    struct attribute *attr, char *buf)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	struct btrfs_root_attr *a = container_of(attr,
-						 struct btrfs_root_attr,
-						 attr);
-
-	return a->show ? a->show(root, buf) : 0;
-}
-
-static ssize_t btrfs_root_attr_store(struct kobject *kobj,
-				     struct attribute *attr,
-				     const char *buf, size_t len)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	struct btrfs_root_attr *a = container_of(attr,
-						 struct btrfs_root_attr,
-						 attr);
-	return a->store ? a->store(root, buf, len) : 0;
-}
-
-static void btrfs_super_release(struct kobject *kobj)
-{
-	struct btrfs_fs_info *fs = container_of(kobj, struct btrfs_fs_info,
-						super_kobj);
-	complete(&fs->kobj_unregister);
-}
-
-static void btrfs_root_release(struct kobject *kobj)
-{
-	struct btrfs_root *root = container_of(kobj, struct btrfs_root,
-						root_kobj);
-	complete(&root->kobj_unregister);
-}
-
-static const struct sysfs_ops btrfs_super_attr_ops = {
-	.show	= btrfs_super_attr_show,
-	.store	= btrfs_super_attr_store,
-};
-
-static const struct sysfs_ops btrfs_root_attr_ops = {
-	.show	= btrfs_root_attr_show,
-	.store	= btrfs_root_attr_store,
-};
-
 /* /sys/fs/btrfs/ entry */
 static struct kset *btrfs_kset;
 
