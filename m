From: "Yehuda Sadeh Weinraub" <yehudasa@gmail.com>
Subject: [PATCH 1/1] btrfs fiemap support
Date: Fri, 19 Dec 2008 12:57:12 -0800
Message-ID: <a37615150812191257r716db8dl10553f7556a0964@mail.gmail.com>
References: <a37615150812191240h45bbf0fbwf091ae644ae1b162@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a37615150812191240h45bbf0fbwf091ae644ae1b162@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Following is our take on fiemap support for btrfs.


Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/btrfs/extent_io.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |    2 +
 fs/btrfs/inode.c     |    7 ++++
 3 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 25ce2d1..a27bb39 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2900,6 +2900,89 @@ out:
 	return sector;
 }

+int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len, get_extent_t *get_extent)
+{
+	int ret;
+	u64 off = start;
+	u64 max = start + len;
+	u32 flags = 0;
+	u64 disko = 0;
+	struct extent_map *em = NULL;
+	int end = 0;
+	u64 em_start = 0, em_len = 0;
+	ret = 0;
+
+	lock_extent(&BTRFS_I(inode)->io_tree, start, start + len,
+		GFP_NOFS);
+	em = get_extent(inode, NULL, 0, off, max - off, 0);
+	if (!em)
+		goto out;
+	if (IS_ERR(em)) {
+		ret = PTR_ERR(em);
+		goto out;
+	}
+	while (!end) {
+		off = em->start + em->len;
+
+		em_start = em->start;
+		em_len = em->len;
+
+		disko = 0;
+		flags = 0;
+
+		switch (em->block_start) {
+		case EXTENT_MAP_LAST_BYTE:
+			end = 1;
+			flags |= FIEMAP_EXTENT_LAST;
+			break;
+		case EXTENT_MAP_HOLE:
+			flags |= FIEMAP_EXTENT_UNWRITTEN;
+			break;
+		case EXTENT_MAP_INLINE:
+			flags |= (FIEMAP_EXTENT_DATA_INLINE |
+				  FIEMAP_EXTENT_NOT_ALIGNED);
+			break;
+		case EXTENT_MAP_DELALLOC:
+			flags |= (FIEMAP_EXTENT_DELALLOC |
+				  FIEMAP_EXTENT_UNKNOWN);
+			break;
+		default:
+			disko = em->block_start;
+			break;
+		}
+		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+			flags |= FIEMAP_EXTENT_ENCODED;
+
+		free_extent_map(em);
+
+		if (!end) {
+			em = get_extent(inode, NULL, 0, off, max - off, 0);
+			if (!em)
+				goto out;
+			if (IS_ERR(em)) {
+				ret = PTR_ERR(em);
+				goto out;
+			}
+		}
+		if (test_bit(EXTENT_FLAG_VACANCY, &em->flags)) {
+			flags |= FIEMAP_EXTENT_LAST;
+			end = 1;
+		}
+
+		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
+					em_len, flags);
+		if (ret)
+			goto out_free;
+	}
+out_free:
+	free_extent_map(em);
+out:
+	unlock_extent(&BTRFS_I(inode)->io_tree, start, start + len,
+			GFP_NOFS);
+	return ret;
+}
+
 static inline struct page *extent_buffer_page(struct extent_buffer *eb,
 					      unsigned long i)
 {
@@ -3786,3 +3869,4 @@ out:
 	return ret;
 }
 EXPORT_SYMBOL(try_release_extent_buffer);
+
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c5b483a..e80c6d9 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -193,6 +193,8 @@ int extent_commit_write(struct extent_io_tree *tree,
 			unsigned from, unsigned to);
 sector_t extent_bmap(struct address_space *mapping, sector_t iblock,
 		get_extent_t *get_extent);
+int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len, get_extent_t *get_extent);
 int set_range_dirty(struct extent_io_tree *tree, u64 start, u64 end);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 068bad4..ff182be 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4171,6 +4171,12 @@ static sector_t btrfs_bmap(struct address_space
*mapping, sector_t iblock)
 	return extent_bmap(mapping, iblock, btrfs_get_extent);
 }

+static int btrfs_fiemap(struct inode *inode, struct
fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len)
+{
+	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent);
+}
+
 int btrfs_readpage(struct file *file, struct page *page)
 {
 	struct extent_io_tree *tree;
@@ -5023,6 +5029,7 @@ static struct inode_operations
btrfs_file_inode_operations = {
 	.removexattr	= btrfs_removexattr,
 	.permission	= btrfs_permission,
 	.fallocate	= btrfs_fallocate,
+	.fiemap		= btrfs_fiemap,
 };
 static struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
-- 
1.5.6.5


Thanks,
Yehuda

PS, please let me know is there's any patch formatting issue.
