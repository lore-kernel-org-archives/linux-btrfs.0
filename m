From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: sanity mount option parsing and early mount code
Date: Tue, 10 Jun 2008 14:34:45 +0200
Message-ID: <20080610123445.GA31103@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 - split mount option parsing into two helpers, one for the early
   options (currentl only the subvol option) and one for the
   later per-superblock options.
 - deal with error from mount options parsing
 - use proper KERN_INFO prefixes for messages from mount option
   parsing
 - merge btrfs_get_sb_bdev into btrfs_get_sb.  It has diverged
   from get_sb_bdev enough to be quite btrfs-specific so there's
   no need to keep it separate.

Also adds lots of comments to describe what's going on here.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/super.c
===================================================================
--- btrfs-unstable.orig/super.c	2008-06-09 13:53:57.000000000 +0200
+++ btrfs-unstable/super.c	2008-06-10 10:40:18.000000000 +0200
@@ -108,15 +108,18 @@ u64 btrfs_parse_size(char *str)
 	return res;
 }
 
-int btrfs_parse_options(char *options, struct btrfs_root *root,
-			char **subvol_name)
+/*
+ * Regular mount options parser.  Everything that is needed only when
+ * reading in a new superblock is parsed here.
+ */
+int btrfs_parse_options(struct btrfs_root *root, char *options)
 {
-	char * p;
-	struct btrfs_fs_info *info = NULL;
+	struct btrfs_fs_info *info = root->fs_info;
 	substring_t args[MAX_OPT_ARGS];
+	char *p, *num;
 
 	if (!options)
-		return 1;
+		return 0;
 
 	/*
 	 * strsep changes the string, duplicate it because parse_options
@@ -126,10 +129,8 @@ int btrfs_parse_options(char *options, s
 	if (!options)
 		return -ENOMEM;
 
-	if (root)
-		info = root->fs_info;
 
-	while ((p = strsep (&options, ",")) != NULL) {
+	while ((p = strsep(&options, ",")) != NULL) {
 		int token;
 		if (!*p)
 			continue;
@@ -137,83 +138,64 @@ int btrfs_parse_options(char *options, s
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_degraded:
-			if (info) {
-				printk("btrfs: allowing degraded mounts\n");
-				btrfs_set_opt(info->mount_opt, DEGRADED);
-			}
+			printk(KERN_INFO "btrfs: allowing degraded mounts\n");
+			btrfs_set_opt(info->mount_opt, DEGRADED);
 			break;
 		case Opt_subvol:
-			if (subvol_name) {
-				*subvol_name = match_strdup(&args[0]);
-			}
+			/*
+			 * This one is parsed by btrfs_parse_early_options
+			 * and can be happily ignored here.
+			 */
 			break;
 		case Opt_nodatasum:
-			if (info) {
-				printk("btrfs: setting nodatacsum\n");
-				btrfs_set_opt(info->mount_opt, NODATASUM);
-			}
+			printk(KERN_INFO "btrfs: setting nodatacsum\n");
+			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_nodatacow:
-			if (info) {
-				printk("btrfs: setting nodatacow\n");
-				btrfs_set_opt(info->mount_opt, NODATACOW);
-				btrfs_set_opt(info->mount_opt, NODATASUM);
-			}
+			printk(KERN_INFO "btrfs: setting nodatacow\n");
+			btrfs_set_opt(info->mount_opt, NODATACOW);
+			btrfs_set_opt(info->mount_opt, NODATASUM);
 			break;
 		case Opt_ssd:
-			if (info) {
-				printk("btrfs: use ssd allocation scheme\n");
-				btrfs_set_opt(info->mount_opt, SSD);
-			}
+			printk(KERN_INFO "btrfs: use ssd allocation scheme\n");
+			btrfs_set_opt(info->mount_opt, SSD);
 			break;
 		case Opt_nobarrier:
-			if (info) {
-				printk("btrfs: turning off barriers\n");
-				btrfs_set_opt(info->mount_opt, NOBARRIER);
-			}
+			printk(KERN_INFO "btrfs: turning off barriers\n");
+			btrfs_set_opt(info->mount_opt, NOBARRIER);
 			break;
 		case Opt_max_extent:
-			if (info) {
-				char *num = match_strdup(&args[0]);
-				if (num) {
-					info->max_extent =
-						btrfs_parse_size(num);
-					kfree(num);
-
-					info->max_extent = max_t(u64,
-							 info->max_extent,
-							 root->sectorsize);
-					printk("btrfs: max_extent at %Lu\n",
-					       info->max_extent);
-				}
+			num = match_strdup(&args[0]);
+			if (num) {
+				info->max_extent = btrfs_parse_size(num);
+				kfree(num);
+
+				info->max_extent = max_t(u64,
+					info->max_extent, root->sectorsize);
+				printk(KERN_INFO "btrfs: max_extent at %llu\n",
+				       info->max_extent);
 			}
 			break;
 		case Opt_max_inline:
-			if (info) {
-				char *num = match_strdup(&args[0]);
-				if (num) {
-					info->max_inline =
-						btrfs_parse_size(num);
-					kfree(num);
-
-					info->max_inline = max_t(u64,
-							 info->max_inline,
-							 root->sectorsize);
-					printk("btrfs: max_inline at %Lu\n",
-					       info->max_inline);
-				}
+			num = match_strdup(&args[0]);
+			if (num) {
+				info->max_inline = btrfs_parse_size(num);
+				kfree(num);
+
+				info->max_inline = max_t(u64,
+					info->max_inline, root->sectorsize);
+				printk(KERN_INFO "btrfs: max_inline at %llu\n",
+					info->max_inline);
 			}
 			break;
 		case Opt_alloc_start:
-			if (info) {
-				char *num = match_strdup(&args[0]);
-				if (num) {
-					info->alloc_start =
-						btrfs_parse_size(num);
-					kfree(num);
-					printk("btrfs: allocations start at "
-					       "%Lu\n", info->alloc_start);
-				}
+			num = match_strdup(&args[0]);
+			if (num) {
+				info->alloc_start = btrfs_parse_size(num);
+				kfree(num);
+				printk(KERN_INFO
+					"btrfs: allocations start at %llu\n",
+					info->alloc_start);
 			}
 			break;
 		default:
@@ -221,7 +203,61 @@ int btrfs_parse_options(char *options, s
 		}
 	}
 	kfree(options);
-	return 1;
+	return 0;
+}
+
+/*
+ * Parse mount options that are required early in the mount process.
+ *
+ * All other options will be parsed on much later in the mount process and
+ * only when we need to allocate a new super block.
+ */
+static int btrfs_parse_early_options(const char *options,
+			char **subvol_name)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *opts, *p;
+	int error = 0;
+
+	if (!options)
+		goto out;
+
+	/*
+	 * strsep changes the string, duplicate it because parse_options
+	 * gets called twice
+	 */
+	opts = kstrdup(options, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+
+	while ((p = strsep(&opts, ",")) != NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_subvol:
+			*subvol_name = match_strdup(&args[0]);
+			break;
+		default:
+			break;
+		}
+	}
+
+	kfree(opts);
+ out:
+	/*
+	 * If no subvolume name is specified we use the default one.  Allocate
+	 * a copy of the string "default" here so that code later in the
+	 * mount path doesn't care if it's the default volume or another one.
+	 */
+	if (!*subvol_name) {
+		*subvol_name = kstrdup("default", GFP_KERNEL);
+		if (!*subvol_name)
+			return -ENOMEM;
+	}
+	return error;
 }
 
 static int btrfs_fill_super(struct super_block * sb,
@@ -328,23 +364,33 @@ static int btrfs_test_super(struct super
 	return root->fs_info->fs_devices == test_fs_devices;
 }
 
-int btrfs_get_sb_bdev(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data,
-	struct vfsmount *mnt, const char *subvol)
+/*
+ * Find a superblock for the given device / mount point.
+ *
+ * Note:  This is based on get_sb_bdev from fs/super.c with a few additions
+ *	  for multiple device setup.  Make sure to keep it in sync.
+ */
+static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
+		const char *dev_name, void *data, struct vfsmount *mnt)
 {
+	char *subvol_name = NULL;
 	struct block_device *bdev = NULL;
 	struct super_block *s;
 	struct dentry *root;
 	struct btrfs_fs_devices *fs_devices = NULL;
 	int error = 0;
 
+	error = btrfs_parse_early_options(data, &subvol_name);
+	if (error)
+		goto error;
+
 	error = btrfs_scan_one_device(dev_name, flags, fs_type, &fs_devices);
 	if (error)
-		return error;
+		goto error_free_subvol_name;
 
 	error = btrfs_open_devices(fs_devices, flags, fs_type);
 	if (error)
-		return error;
+		goto error_free_subvol_name;
 
 	bdev = fs_devices->latest_bdev;
 	btrfs_lock_volumes();
@@ -378,51 +424,36 @@ int btrfs_get_sb_bdev(struct file_system
 		s->s_flags |= MS_ACTIVE;
 	}
 
-	if (subvol) {
-		root = lookup_one_len(subvol, s->s_root, strlen(subvol));
-		if (IS_ERR(root)) {
-			up_write(&s->s_umount);
-			deactivate_super(s);
-			error = PTR_ERR(root);
-			goto error;
-		}
-		if (!root->d_inode) {
-			dput(root);
-			up_write(&s->s_umount);
-			deactivate_super(s);
-			error = -ENXIO;
-			goto error;
-		}
-	} else {
-		root = dget(s->s_root);
+	root = lookup_one_len(subvol_name, s->s_root, strlen(subvol_name));
+	if (IS_ERR(root)) {
+		up_write(&s->s_umount);
+		deactivate_super(s);
+		error = PTR_ERR(root);
+		goto error;
+	}
+	if (!root->d_inode) {
+		dput(root);
+		up_write(&s->s_umount);
+		deactivate_super(s);
+		error = -ENXIO;
+		goto error;
 	}
 
 	mnt->mnt_sb = s;
 	mnt->mnt_root = root;
+
+	kfree(subvol_name);
 	return 0;
 
 error_s:
 	error = PTR_ERR(s);
 error_bdev:
 	btrfs_close_devices(fs_devices);
+error_free_subvol_name:
+	kfree(subvol_name);
 error:
 	return error;
 }
-/* end copy & paste */
-
-static int btrfs_get_sb(struct file_system_type *fs_type,
-	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
-{
-	int ret;
-	char *subvol_name = NULL;
-
-	btrfs_parse_options((char *)data, NULL, &subvol_name);
-	ret = btrfs_get_sb_bdev(fs_type, flags, dev_name, data, mnt,
-			subvol_name ? subvol_name : "default");
-	if (subvol_name)
-		kfree(subvol_name);
-	return ret;
-}
 
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
Index: btrfs-unstable/ctree.h
===================================================================
--- btrfs-unstable.orig/ctree.h	2008-06-09 14:08:56.000000000 +0200
+++ btrfs-unstable/ctree.h	2008-06-10 10:40:38.000000000 +0200
@@ -1610,6 +1610,6 @@ int btrfs_delete_xattrs(struct btrfs_tra
 			struct btrfs_root *root, struct inode *inode);
 /* super.c */
 u64 btrfs_parse_size(char *str);
-int btrfs_parse_options(char *options, struct btrfs_root *root,
-			char **subvol_name);
+int btrfs_parse_options(struct btrfs_root *root, char *options);
+
 #endif
Index: btrfs-unstable/disk-io.c
===================================================================
--- btrfs-unstable.orig/disk-io.c	2008-06-09 13:58:03.000000000 +0200
+++ btrfs-unstable/disk-io.c	2008-06-10 10:41:31.000000000 +0200
@@ -1266,8 +1266,11 @@ struct btrfs_root *open_ctree(struct sup
 	if (!btrfs_super_root(disk_super))
 		goto fail_sb_buffer;
 
-	btrfs_parse_options(options, tree_root, NULL);
+	err = btrfs_parse_options(tree_root, options);
+	if (err)
+		goto fail_sb_buffer;
 
+	err = -EINVAL;
 	if (btrfs_super_num_devices(disk_super) > fs_devices->open_devices) {
 		printk("Btrfs: wanted %llu devices, but found %llu\n",
 		       (unsigned long long)btrfs_super_num_devices(disk_super),
