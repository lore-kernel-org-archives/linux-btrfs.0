From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/2] Btrfs: cache ordered extent when completing io
Date: Tue, 2 Feb 2010 15:51:14 -0500
Message-ID: <20100202205113.GC15957@localhost.localdomain>
References: <20100202205010.GB15957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100202205010.GB15957@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

When finishing io we run btrfs_dec_test_ordered_pending, and then immediately
run btrfs_lookup_ordered_extent, but btrfs_dec_test_ordered_pending does that
already, so we're searching twice when we don't have to.  This patch lets us
pass a btrfs_ordered_extent in to btrfs_dec_test_ordered_pending so if we do
complete io on that ordered extent we can just use the one we found then instead
of having to do another btrfs_lookup_ordered_extent.  This made my fio job with
the other patch go from 24 mb/s to 29 mb/s.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c        |    5 ++---
 fs/btrfs/ordered-data.c |    7 ++++++-
 fs/btrfs/ordered-data.h |    3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9a1c746..26574d8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1692,11 +1692,10 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	int compressed = 0;
 	int ret;
 
-	ret = btrfs_dec_test_ordered_pending(inode, start, end - start + 1);
+	ret = btrfs_dec_test_ordered_pending(inode, &ordered_extent, start,
+					     end - start + 1);
 	if (!ret)
 		return 0;
-
-	ordered_extent = btrfs_lookup_ordered_extent(inode, start);
 	BUG_ON(!ordered_extent);
 
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags)) {
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5c2a9e7..c44054b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -232,11 +232,12 @@ int btrfs_add_ordered_sum(struct inode *inode,
  * to make sure this function only returns 1 once for a given ordered extent.
  */
 int btrfs_dec_test_ordered_pending(struct inode *inode,
+				   struct btrfs_ordered_extent **cached,
 				   u64 file_offset, u64 io_size)
 {
 	struct btrfs_ordered_inode_tree *tree;
 	struct rb_node *node;
-	struct btrfs_ordered_extent *entry;
+	struct btrfs_ordered_extent *entry = NULL;
 	int ret;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
@@ -264,6 +265,10 @@ int btrfs_dec_test_ordered_pending(struct inode *inode,
 	else
 		ret = 1;
 out:
+	if (!ret && cached && entry) {
+		*cached = entry;
+		atomic_inc(&entry->refs);
+	}
 	mutex_unlock(&tree->mutex);
 	return ret == 0;
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 1fe1282..398bfc6 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -137,7 +137,8 @@ int btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry);
 int btrfs_remove_ordered_extent(struct inode *inode,
 				struct btrfs_ordered_extent *entry);
 int btrfs_dec_test_ordered_pending(struct inode *inode,
-				       u64 file_offset, u64 io_size);
+				   struct btrfs_ordered_extent **cached,
+				   u64 file_offset, u64 io_size);
 int btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 			     u64 start, u64 len, u64 disk_len, int tyep);
 int btrfs_add_ordered_sum(struct inode *inode,
-- 
1.6.6

