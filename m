From: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 1/2] btrfs: Fix a bunch of printk() warnings.
Date: Tue, 21 Apr 2009 12:38:29 -0700
Message-ID: <1240342710-19009-2-git-send-email-joel.becker@oracle.com>
References: <1240342710-19009-1-git-send-email-joel.becker@oracle.com>
Cc: chris.mason@oracle.com, lmb@suse.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240342710-19009-1-git-send-email-joel.becker@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just happened to notice a bunch of %llu vs u64 warnings.  Here's a patch
to cast them all.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/btrfs/disk-io.c          |    9 +++++----
 fs/btrfs/extent-tree.c      |   21 ++++++++++++++-------
 fs/btrfs/free-space-cache.c |   15 ++++++++++-----
 fs/btrfs/ioctl.c            |    6 ++++--
 fs/btrfs/super.c            |   15 +++++++++------
 5 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 92caa80..72aa879 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -235,7 +235,8 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			printk(KERN_INFO "btrfs: %s checksum verify failed "
 			       "on %llu wanted %X found %X level %d\n",
 			       root->fs_info->sb->s_id,
-			       buf->start, val, found, btrfs_header_level(buf));
+			       (unsigned long long)buf->start, val, found,
+			       btrfs_header_level(buf));
 			if (result != (char *)&inline_result)
 				kfree(result);
 			return 1;
@@ -1689,7 +1690,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (features) {
 		printk(KERN_ERR "BTRFS: couldn't mount because of "
 		       "unsupported optional features (%Lx).\n",
-		       features);
+		       (unsigned long long)features);
 		err = -EINVAL;
 		goto fail_iput;
 	}
@@ -1699,7 +1700,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		printk(KERN_ERR "BTRFS: couldn't mount RDWR because of "
 		       "unsupported option features (%Lx).\n",
-		       features);
+		       (unsigned long long)features);
 		err = -EINVAL;
 		goto fail_iput;
 	}
@@ -2291,7 +2292,7 @@ int close_ctree(struct btrfs_root *root)
 
 	if (fs_info->delalloc_bytes) {
 		printk(KERN_INFO "btrfs: at unmount delalloc count %llu\n",
-		       fs_info->delalloc_bytes);
+		       (unsigned long long)fs_info->delalloc_bytes);
 	}
 	if (fs_info->total_ref_cache_size) {
 		printk(KERN_INFO "btrfs: at umount reference cache size %llu\n",
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 178df4c..81d42e8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1844,10 +1844,14 @@ again:
 		printk(KERN_ERR "no space left, need %llu, %llu delalloc bytes"
 		       ", %llu bytes_used, %llu bytes_reserved, "
 		       "%llu bytes_pinned, %llu bytes_readonly, %llu may use"
-		       "%llu total\n", bytes, data_sinfo->bytes_delalloc,
-		       data_sinfo->bytes_used, data_sinfo->bytes_reserved,
-		       data_sinfo->bytes_pinned, data_sinfo->bytes_readonly,
-		       data_sinfo->bytes_may_use, data_sinfo->total_bytes);
+		       "%llu total\n", (unsigned long long)bytes,
+		       (unsigned long long)data_sinfo->bytes_delalloc,
+		       (unsigned long long)data_sinfo->bytes_used,
+		       (unsigned long long)data_sinfo->bytes_reserved,
+		       (unsigned long long)data_sinfo->bytes_pinned,
+		       (unsigned long long)data_sinfo->bytes_readonly,
+		       (unsigned long long)data_sinfo->bytes_may_use,
+		       (unsigned long long)data_sinfo->total_bytes);
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
@@ -2798,9 +2802,12 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes)
 				    info->bytes_pinned - info->bytes_reserved),
 	       (info->full) ? "" : "not ");
 	printk(KERN_INFO "space_info total=%llu, pinned=%llu, delalloc=%llu,"
-	       " may_use=%llu, used=%llu\n", info->total_bytes,
-	       info->bytes_pinned, info->bytes_delalloc, info->bytes_may_use,
-	       info->bytes_used);
+	       " may_use=%llu, used=%llu\n",
+	       (unsigned long long)info->total_bytes,
+	       (unsigned long long)info->bytes_pinned,
+	       (unsigned long long)info->bytes_delalloc,
+	       (unsigned long long)info->bytes_may_use,
+	       (unsigned long long)info->bytes_used);
 
 	down_read(&info->groups_sem);
 	list_for_each_entry(cache, &info->block_groups, list) {
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 768b952..0bc9365 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -332,13 +332,17 @@ int btrfs_remove_free_space(struct btrfs_block_group_cache *block_group,
 			printk(KERN_ERR "couldn't find space %llu to free\n",
 			       (unsigned long long)offset);
 			printk(KERN_ERR "cached is %d, offset %llu bytes %llu\n",
-			       block_group->cached, block_group->key.objectid,
-			       block_group->key.offset);
+			       block_group->cached,
+			       (unsigned long long)block_group->key.objectid,
+			       (unsigned long long)block_group->key.offset);
 			btrfs_dump_free_space(block_group, bytes);
 		} else if (info) {
 			printk(KERN_ERR "hmm, found offset=%llu bytes=%llu, "
 			       "but wanted offset=%llu bytes=%llu\n",
-			       info->offset, info->bytes, offset, bytes);
+			       (unsigned long long)info->offset,
+			       (unsigned long long)info->bytes,
+			       (unsigned long long)offset,
+			       (unsigned long long)bytes);
 		}
 		WARN_ON(1);
 	}
@@ -357,8 +361,9 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
 		if (info->bytes >= bytes)
 			count++;
-		printk(KERN_ERR "entry offset %llu, bytes %llu\n", info->offset,
-		       info->bytes);
+		printk(KERN_ERR "entry offset %llu, bytes %llu\n",
+		       (unsigned long long)info->offset,
+		       (unsigned long long)info->bytes);
 	}
 	printk(KERN_INFO "%d blocks of free space at or bigger than bytes is"
 	       "\n", count);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7594bec..5858fc2 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -483,11 +483,13 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 		*devstr = '\0';
 		devstr = vol_args->name;
 		devid = simple_strtoull(devstr, &end, 10);
-		printk(KERN_INFO "resizing devid %llu\n", devid);
+		printk(KERN_INFO "resizing devid %llu\n",
+		       (unsigned long long)devid);
 	}
 	device = btrfs_find_device(root, devid, NULL, NULL);
 	if (!device) {
-		printk(KERN_INFO "resizer unable to find device %llu\n", devid);
+		printk(KERN_INFO "resizer unable to find device %llu\n",
+		       (unsigned long long)devid);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9744af9..64cf440 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -195,7 +195,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				info->max_extent = max_t(u64,
 					info->max_extent, root->sectorsize);
 				printk(KERN_INFO "btrfs: max_extent at %llu\n",
-				       info->max_extent);
+				       (unsigned long long)info->max_extent);
 			}
 			break;
 		case Opt_max_inline:
@@ -210,7 +210,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 						root->sectorsize);
 				}
 				printk(KERN_INFO "btrfs: max_inline at %llu\n",
-					info->max_inline);
+					(unsigned long long)info->max_inline);
 			}
 			break;
 		case Opt_alloc_start:
@@ -220,7 +220,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 				kfree(num);
 				printk(KERN_INFO
 					"btrfs: allocations start at %llu\n",
-					info->alloc_start);
+					(unsigned long long)info->alloc_start);
 			}
 			break;
 		case Opt_noacl:
@@ -410,11 +410,14 @@ static int btrfs_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (btrfs_test_opt(root, NOBARRIER))
 		seq_puts(seq, ",nobarrier");
 	if (info->max_extent != (u64)-1)
-		seq_printf(seq, ",max_extent=%llu", info->max_extent);
+		seq_printf(seq, ",max_extent=%llu",
+			   (unsigned long long)info->max_extent);
 	if (info->max_inline != 8192 * 1024)
-		seq_printf(seq, ",max_inline=%llu", info->max_inline);
+		seq_printf(seq, ",max_inline=%llu",
+			   (unsigned long long)info->max_inline);
 	if (info->alloc_start != 0)
-		seq_printf(seq, ",alloc_start=%llu", info->alloc_start);
+		seq_printf(seq, ",alloc_start=%llu",
+			   (unsigned long long)info->alloc_start);
 	if (info->thread_pool_size !=  min_t(unsigned long,
 					     num_online_cpus() + 2, 8))
 		seq_printf(seq, ",thread_pool=%d", info->thread_pool_size);
-- 
1.5.6.5

