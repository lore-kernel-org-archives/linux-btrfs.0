From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] Btrfs: implement our own ->llseek
Date: Thu, 21 Apr 2011 15:42:34 -0400
Message-ID: <1303414954-3315-2-git-send-email-josef@redhat.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

In order to handle SEEK_HOLE/SEEK_DATA we need to implement our own llseek.
Basically for the normal SEEK_*'s we will just defer to the generic helper, and
for SEEK_HOLE/SEEK_DATA we will use our fiemap helper to figure out the nearest
hole or data.  Currently this helper doesn't check for delalloc bytes for
prealloc space, so for now treat prealloc as data until that is fixed.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h |    3 ++
 fs/btrfs/file.c  |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 87 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d5f043e..d2991c8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2474,6 +2474,9 @@ int btrfs_csum_truncate(struct btrfs_trans_handle *trans,
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start,
 			     u64 end, struct list_head *list);
 /* inode.c */
+struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+					   size_t pg_offset, u64 start, u64 len,
+					   int create);
 
 /* RHEL and EL kernels have a patch that renames PG_checked to FsMisc */
 #if defined(ClearPageFsMisc) && !defined(ClearPageChecked)
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd5e82e..f0a7a33 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1406,8 +1406,91 @@ out:
 	return ret;
 }
 
+static int find_desired_extent(struct inode *inode, loff_t *offset, int origin)
+{
+	struct extent_map *em;
+	struct extent_state *cached_state = NULL;
+	u64 lockstart = *offset;
+	u64 lockend = i_size_read(inode);
+	u64 start = *offset;
+	u64 len = i_size_read(inode);
+	int ret = 0;
+
+	lockend = max_t(u64, BTRFS_I(inode)->root->sectorsize, lockend);
+	len = lockend;
+
+	lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend, 0,
+			 &cached_state, GFP_NOFS);
+	while (1) {
+		em = btrfs_get_extent_fiemap(inode, NULL, 0, start, len, 0);
+		if (IS_ERR(em)) {
+			ret = -ENXIO;
+			break;
+		}
+
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			if (origin == SEEK_HOLE) {
+				*offset = em->start;
+				free_extent_map(em);
+				break;
+			}
+		} else {
+			if (origin == SEEK_DATA) {
+				*offset = em->start;
+				free_extent_map(em);
+				break;
+			}
+		}
+		start = em->start + em->len;
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			free_extent_map(em);
+			ret = -ENXIO;
+			break;
+		}
+		free_extent_map(em);
+	}
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart, lockend,
+			     &cached_state, GFP_NOFS);
+	return ret;
+}
+
+static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	struct inode *inode = file->f_mapping->host;
+	int ret;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+	case SEEK_CUR:
+		offset = generic_file_llseek_unlocked(file, offset, origin);
+		goto out;
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		ret = find_desired_extent(inode, &offset, origin);
+		if (ret) {
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
+	}
+
+	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET))
+		return -EINVAL;
+	if (offset > inode->i_sb->s_maxbytes)
+		return -EINVAL;
+
+	/* Special lock needed here? */
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		file->f_version = 0;
+	}
+out:
+	mutex_unlock(&inode->i_mutex);
+	return offset;
+}
+
 const struct file_operations btrfs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= btrfs_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read       = generic_file_aio_read,
-- 
1.7.2.3
