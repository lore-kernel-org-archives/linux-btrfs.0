Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34734 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755110AbcHSIDG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 04:03:06 -0400
Received: by mail-pf0-f182.google.com with SMTP id p64so7182632pfb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 01:03:06 -0700 (PDT)
Date: Thu, 18 Aug 2016 13:33:27 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
Message-ID: <20160818203327.GA7696@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com>
 <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
 <20160718223104.GA6681@vader.DHCP.thefacebook.com>
 <2544227.upOtQjWuiQ@localhost.localdomain>
 <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <83e50f77-ae10-4c8d-4a03-3c9af298d9c7@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 19, 2016 at 03:25:16PM -0400, Chris Mason wrote:
> On 07/19/2016 12:06 PM, Chandan Rajendra wrote:
> > On Monday, July 18, 2016 03:31:04 PM Omar Sandoval wrote:
> > > Yeah, this should definitely not work. It's possible that things are
> > > just silently failing and getting corrupted if the module isn't built
> > > with CONFIG_BTRFS_ASSERT, but btrfsck v4.6.1 + my patch should catch
> > > that.
> > > 
> > > Chandan, is fsx creating enough fragmentation to trigger the switch to
> > > bitmaps? You can check with `btrfs inspect dump-tree`; there should be
> > > FREE_SPACE_BITMAP items. If there are only FREE_SPACE_EXTENT items, then
> > > it's not testing the right code path.
> > > 
> > > I have a script here [1] that I've been using to test the free space
> > > tree. When I ran it with `--check` on MIPS, it failed on the old kernel
> > > and passed with this series. If you stick a return after the call to
> > > `unlink_every_other_file()`, you'll get a nice, fragmented filesystem to
> > > feed to xfstests, as well.
> > 
> > You are right, There were only FREE_SPACE_EXTENT items in the filesystem that
> > was operated on by fsx. I executed fragment_free_space_tree.py to create a
> > filesystem with FREE_SPACE_BITMAP items. When such a filesystem is created
> > with the unpatched kernel, later mounted on a patched kernel and fsx executed
> > on it, I see that we fail assertion statements in free-space-tree.c. For e.g.
> > 
> > BTRFS error (device loop0): incorrect extent count for 289406976; counted 8186, expected 8192
> > BTRFS: assertion failed: 0, file: /root/repos/linux/fs/btrfs/free-space-tree.c, line: 1485
> > 
> 
> Omar, looks like we need to make the patched kernel refuse to mount free
> space trees without a new incompat bit set.  That way there won't be any
> surprises for the people that have managed to get a free space tree saved.
> Can it please printk a message about clearing the tree and mounting again?
> 
> -chris

Sorry it took me a month to get around to this, I tried to implement
this a couple of ways but I really don't like it. Basically, when we see
that we're missing the compat bit, we have to assume that the free space
tree was created with the same endianness that we're running on now.
That could lead to a false positive if, say, we created the filesystem
on a little-endian machine with an old kernel but are using it on a
big-endian system, or a false negative if it was created on a big-endian
machine with an old kernel but we're using it on a little-endian
machine.

There's also the question of making it a compat bit vs an incompat bit.
An incompat bit makes sure that we don't break the filesystem by
mounting it on an old big-endian kernel, but needlessly breaks
backwards-compatibility for little-endian.

I'd be much happier if we could just pretend this never happened. Here's
the patch, anyways, for the sake of completeness. Chris, what do you
think?

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2fe8f89..f50b3e0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -246,7 +246,8 @@ struct btrfs_super_block {
  * Compat flags that we support.  If any incompat flags are set other than the
  * ones specified below then we will fail to mount
  */
-#define BTRFS_FEATURE_COMPAT_SUPP		0ULL
+#define BTRFS_FEATURE_COMPAT_SUPP			\
+	(BTRFS_FEATURE_COMPAT_FREE_SPACE_TREE_LE)
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR		0ULL
 
@@ -3538,6 +3539,62 @@ static inline int __btrfs_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag)
 	return !!(btrfs_super_compat_ro_flags(disk_super) & flag);
 }
 
+#define btrfs_set_fs_compat(__fs_info, opt) \
+	__btrfs_set_fs_compat((__fs_info), BTRFS_FEATURE_COMPAT_##opt)
+
+static inline void __btrfs_set_fs_compat(struct btrfs_fs_info *fs_info,
+					 u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_compat_flags(disk_super);
+	if (!(features & flag)) {
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_compat_flags(disk_super);
+		if (!(features & flag)) {
+			features |= flag;
+			btrfs_set_super_compat_flags(disk_super, features);
+			btrfs_info(fs_info, "setting %llu feature flag", flag);
+		}
+		spin_unlock(&fs_info->super_lock);
+	}
+}
+
+#define btrfs_clear_fs_compat(__fs_info, opt) \
+	__btrfs_clear_fs_compat((__fs_info), BTRFS_FEATURE_COMPAT_##opt)
+
+static inline void __btrfs_clear_fs_compat(struct btrfs_fs_info *fs_info,
+					      u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	u64 features;
+
+	disk_super = fs_info->super_copy;
+	features = btrfs_super_compat_flags(disk_super);
+	if (features & flag) {
+		spin_lock(&fs_info->super_lock);
+		features = btrfs_super_compat_flags(disk_super);
+		if (features & flag) {
+			features &= ~flag;
+			btrfs_set_super_compat_flags(disk_super, features);
+			btrfs_info(fs_info, "clearing %llu feature flag", flag);
+		}
+		spin_unlock(&fs_info->super_lock);
+	}
+}
+
+#define btrfs_fs_compat(fs_info, opt) \
+	__btrfs_fs_compat((fs_info), BTRFS_FEATURE_COMPAT_##opt)
+
+static inline int __btrfs_fs_compat(struct btrfs_fs_info *fs_info, u64 flag)
+{
+	struct btrfs_super_block *disk_super;
+	disk_super = fs_info->super_copy;
+	return !!(btrfs_super_compat_flags(disk_super) & flag);
+}
+
 /* acl.c */
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 struct posix_acl *btrfs_get_acl(struct inode *inode, int type);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 59febfb..467c364 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3090,6 +3090,15 @@ retry_root_backup:
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
+	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE) &&
+	    !btrfs_test_opt(fs_info, CLEAR_CACHE)) {
+		ret = btrfs_check_free_space_tree_le(fs_info);
+		if (ret) {
+			close_ctree(tree_root);
+			return ret;
+		}
+	}
+
 	if (btrfs_test_opt(tree_root->fs_info, FREE_SPACE_TREE) &&
 	    !btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
 		btrfs_info(fs_info, "creating free space tree");
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 8fd85bf..ef84c1d 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1182,6 +1182,7 @@ int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info)
 	}
 
 	btrfs_set_fs_compat_ro(fs_info, FREE_SPACE_TREE);
+	btrfs_set_fs_compat(fs_info, FREE_SPACE_TREE_LE);
 	fs_info->creating_free_space_tree = 0;
 
 	ret = btrfs_commit_transaction(trans, tree_root);
@@ -1250,6 +1251,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 		return PTR_ERR(trans);
 
 	btrfs_clear_fs_compat_ro(fs_info, FREE_SPACE_TREE);
+	btrfs_clear_fs_compat(fs_info, FREE_SPACE_TREE_LE);
 	fs_info->free_space_root = NULL;
 
 	ret = clear_free_space_tree(trans, free_space_root);
@@ -1284,6 +1286,40 @@ abort:
 	return ret;
 }
 
+#ifdef __LITTLE_ENDIAN
+static int __btrfs_set_free_space_tree_le(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+
+	trans = btrfs_start_transaction(tree_root, 0);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+	btrfs_set_fs_compat(fs_info, FREE_SPACE_TREE_LE);
+	return btrfs_commit_transaction(trans, tree_root);
+}
+#endif
+
+/*
+ * The free space tree was broken on big-endian systems when it was introduced.
+ * This attempts to catch that with the FREE_SPACE_TREE_LE compat bit. If it's
+ * not set, then we assume that the filesystem being mounted was created/used on
+ * the same endianness, which kind of sucks.
+ */
+int btrfs_check_free_space_tree_le(struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_fs_compat(fs_info, FREE_SPACE_TREE_LE))
+		return 0;
+
+#ifdef __LITTLE_ENDIAN
+	return __btrfs_set_free_space_tree_le(fs_info);
+#else
+	btrfs_err(fs_info, "free space tree created with broken big-endian kernel");
+	btrfs_err(fs_info, "please remount once with nospace_cache,clear_cache and then remount with space_cache=v2");
+	return -EINVAL;
+#endif
+}
+
 static int __add_block_group_free_space(struct btrfs_trans_handle *trans,
 					struct btrfs_fs_info *fs_info,
 					struct btrfs_block_group_cache *block_group,
diff --git a/fs/btrfs/free-space-tree.h b/fs/btrfs/free-space-tree.h
index 54ffced..505b13e 100644
--- a/fs/btrfs/free-space-tree.h
+++ b/fs/btrfs/free-space-tree.h
@@ -30,6 +30,7 @@
 void set_free_space_tree_thresholds(struct btrfs_block_group_cache *block_group);
 int btrfs_create_free_space_tree(struct btrfs_fs_info *fs_info);
 int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info);
+int btrfs_check_free_space_tree_le(struct btrfs_fs_info *fs_info);
 int load_free_space_tree(struct btrfs_caching_control *caching_ctl);
 int add_block_group_free_space(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info,
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index ac5eacd..2695b3d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -239,6 +239,8 @@ struct btrfs_ioctl_fs_info_args {
  * Used by:
  * struct btrfs_ioctl_feature_flags
  */
+#define BTRFS_FEATURE_COMPAT_FREE_SPACE_TREE_LE	(1ULL << 0)
+
 #define BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE	(1ULL << 0)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)

-- 
Omar
