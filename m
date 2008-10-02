From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] Btrfs: avoid NULL deref after failed allocation
Date: Thu, 02 Oct 2008 16:39:07 +0200
Message-ID: <87abdnt62c.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I scanned through the sources looking mostly at kmalloc uses
to see if a NULL result pointer could be dereferenced.
There were a few.  Where it was easy, I adjusted the code
to return -ENOMEM.  However, in some places, the trend is
to BUG_ON(!ptr), so I've done that, too.

There were two cases where nonzero "ret" appears
to have been inadvertently ignored, so I added BUG_ON(ret)
there, too, but it's possible those failures were deliberately ignored.

The second hunk doesn't matter as much: it just adds comments noting:
 - a possible leak
 - an invalid (or at least misleading) return code
 - another possible leak

If you're interested, give a little guidance on what you want,
and I'll be happy to make this more presentable.

---
 fs/btrfs/file.c     |    6 +++++-
 fs/btrfs/super.c    |    6 ++++++
 fs/btrfs/tree-log.c |    6 ++++++
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3088a11..9c8a037 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -927,7 +927,11 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 		goto out_nolock;
 	file_update_time(file);
 
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	pages = kmalloc(nrptrs * sizeof(*pages), GFP_KERNEL);
+	if (!pages) {
+		err = -ENOMEM;
+		goto out_nolock;
+	}
 
 	mutex_lock(&inode->i_mutex);
 	first_index = pos >> PAGE_CACHE_SHIFT;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2e60398..a158890 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -261,11 +261,15 @@ static int btrfs_parse_early_options(const char *options, int flags,
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_subvol:
+			/* FIXME: multiple Opt_subvol options induce leak */
 			*subvol_name = match_strdup(&args[0]);
 			break;
 		case Opt_device:
 			error = btrfs_scan_one_device(match_strdup(&args[0]),
 					flags, holder, fs_devices);
+			/* FIXME: upon match_strdup failure, fail with
+			   -ENOMEM rather than lookup_bdev's -EINVAL.
+			   Does the match_strdup result need to be freed?  */
 			if (error)
 				goto out_free_opts;
 			break;
@@ -531,6 +535,8 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	int len;
 
 	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
+	if (!vol)
+		return -ENOMEM;
 	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
 		ret = -EFAULT;
 		goto out;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 88bbfd9..912c2ac 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -335,7 +335,9 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			return 0;
 		}
 		dst_copy = kmalloc(item_size, GFP_NOFS);
+		BUG_ON(!dst_copy);
 		src_copy = kmalloc(item_size, GFP_NOFS);
+		BUG_ON(!src_copy);
 
 		read_extent_buffer(eb, src_copy, src_ptr, item_size);
 
@@ -462,6 +464,7 @@ insert:
 						root->root_key.objectid,
 						trans->transid,
 						key->objectid, key->offset);
+				BUG_ON(ret);
 			} else {
 				/*
 				 * insert the extent pointer in the extent
@@ -633,6 +636,7 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	BUG_ON(!name);
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -2307,6 +2311,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 			ret = overwrite_item(trans, log, dst_path,
 					     path->nodes[0], path->slots[0],
 					     &tmp);
+			BUG_ON(ret);
 		}
 	}
 	btrfs_release_path(root, path);
@@ -2477,6 +2482,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 
 	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
 			   nr * sizeof(u32), GFP_NOFS);
+	BUG_ON(!ins_data);
 	ins_sizes = (u32 *)ins_data;
 	ins_keys = (struct btrfs_key *)(ins_data + nr * sizeof(u32));
 
-- 
1.6.0.2.27.gea240
