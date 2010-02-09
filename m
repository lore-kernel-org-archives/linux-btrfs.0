From: Chris Ball <cjb@laptop.org>
Subject: Re: [bug] Reclaim space.
Date: Tue, 09 Feb 2010 15:00:18 -0500
Message-ID: <m3iqa62n8t.fsf@pullcord.laptop.org>
References: <1265740911.5943.7.camel@pi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: pomac@vapor.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1265740911.5943.7.camel@pi> (Ian Kumlien's message of "Tue, 09
	Feb 2010 19:41:51 +0100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Hi, I assume this has something to do with using updated btrfs
   > and old btrfs utils, but it's only the presentation that is
   > wrong.

Yes, this wouldn't happen with latest btrfs-progs.

   > But df -h gives:
   > /dev/mapper/root    145G  -64Z -122G 100% /

Here's a patch to btrfsck from Josef that should fix this:


Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 btrfsck.c     |   30 ++++++++++++++++++++++++++++++
 ctree.h       |    1 +
 extent-tree.c |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 46a6eae..77db11a 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2805,6 +2805,34 @@ static int check_extents(struct btrfs_root *root)
 	return ret;
 }
 
+static void check_space_used(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *info = root->fs_info;
+	u64 total;
+	u64 super_total;
+
+	total = btrfs_total_used(root);
+	super_total = btrfs_super_bytes_used(&info->super_copy);
+
+	if (total != super_total) {
+		struct btrfs_trans_handle *trans;
+
+		trans = btrfs_start_transaction(root, 1);
+		if (!trans)
+			return;
+		printf("Super total bytes used (%llu) doesn't match actual "
+		       "bytes used (%llu).  Fixing.\n",
+		       (unsigned long long)super_total,
+		       (unsigned long long)total);
+		btrfs_set_super_bytes_used(&info->super_copy, total);
+		btrfs_commit_transaction(trans, root);
+	} else {
+		printf("Super total bytes used (%llu) matches actual (%llu)\n",
+		       (unsigned long long)super_total,
+		       (unsigned long long)total);
+	}
+}
+
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfsck dev\n");
@@ -2836,6 +2864,8 @@ int main(int ac, char **av)
 		goto out;
 
 	ret = check_root_refs(root, &root_cache);
+	if (!ret)
+		check_space_used(root);
 out:
 	free_root_recs(&root_cache);
 	close_ctree(root);
diff --git a/ctree.h b/ctree.h
index a9062ea..89eb0b9 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1699,6 +1699,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+u64 btrfs_total_used(struct btrfs_root *root);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff --git a/extent-tree.c b/extent-tree.c
index e1d7ffd..478807c 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3135,6 +3135,38 @@ error:
 	return ret;
 }
 
+u64 btrfs_total_used(struct btrfs_root *root)
+{
+	struct btrfs_block_group_cache *cache;
+	struct extent_io_tree *block_group_cache;
+	int ret;
+	u64 ptr;
+	u64 start;
+	u64 end;
+	u64 total = 0;
+
+	block_group_cache = &root->fs_info->block_group_cache;
+	start = BTRFS_SUPER_INFO_OFFSET + BTRFS_SUPER_INFO_SIZE;
+	while (1) {
+		ret = find_first_extent_bit(block_group_cache,
+					    start, &start, &end,
+					    BLOCK_GROUP_DATA |
+					    BLOCK_GROUP_METADATA |
+					    BLOCK_GROUP_SYSTEM);
+		if (ret)
+			break;
+		ret = get_state_private(block_group_cache, start, &ptr);
+		if (ret)
+			break;
+
+		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
+		total += btrfs_block_group_used(&cache->item);
+		start = end + 1;
+	}
+
+	return total;
+}
+
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-- 
1.5.4.3

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
