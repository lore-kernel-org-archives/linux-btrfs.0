From: Chris Ball <cjb@laptop.org>
Subject: Re: [bug] Reclaim space.
Date: Tue, 09 Feb 2010 16:02:12 -0500
Message-ID: <m3d40e2kdn.fsf@pullcord.laptop.org>
References: <1265740911.5943.7.camel@pi> <m3iqa62n8t.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: pomac@vapor.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3iqa62n8t.fsf@pullcord.laptop.org> (Chris Ball's message of
	"Tue, 09 Feb 2010 15:00:18 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Here's a patch to btrfsck from Josef that should fix this:

Sorry, that was an older patch.  This is the working one:


From: Josef Bacik <jbacik@redhat.com>
Date: Wed, 14 Oct 2009 14:39:26 -0400
Subject: [PATCH] patch fix-space-accounting.patch


Signed-off-by: Josef Bacik <jbacik@redhat.com>
---
 btrfsck.c     |   32 +++++++++++++++++++++++++++++
 ctree.h       |    2 +
 disk-io.c     |   47 +++++++++++++++++++++++++++++++++++++++++++
 disk-io.h     |    2 +
 extent-tree.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/btrfsck.c b/btrfsck.c
index 46a6eae..1aaf022 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -2805,6 +2805,36 @@ static int check_extents(struct btrfs_root *root)
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
+		btrfs_make_readwrite(info);
+		trans = btrfs_start_transaction(root, 1);
+		if (!trans)
+			return;
+		printf("Super total bytes used (%llu) doesn't match actual "
+		       "bytes used (%llu).  Fixing.\n",
+		       (unsigned long long)super_total,
+		       (unsigned long long)total);
+		btrfs_set_super_bytes_used(&info->super_copy, total);
+		btrfs_commit_transaction(trans, root);
+		btrfs_make_readonly(info);
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
@@ -2836,6 +2866,8 @@ int main(int ac, char **av)
 		goto out;
 
 	ret = check_root_refs(root, &root_cache);
+	if (!ret)
+		check_space_used(root);
 out:
 	free_root_recs(&root_cache);
 	close_ctree(root);
diff --git a/ctree.h b/ctree.h
index a9062ea..0681017 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1699,6 +1699,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
 			   u64 size);
+u64 btrfs_total_used(struct btrfs_root *root);
+void btrfs_update_block_groups_readonly(struct btrfs_fs_info *info);
 int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
diff --git a/disk-io.c b/disk-io.c
index 4d4e902..ecea152 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -946,6 +946,53 @@ static int close_all_devices(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+int btrfs_make_readwrite(struct btrfs_fs_info *fs_info)
+{
+	struct list_head *list;
+	struct list_head *next;
+	struct list_head *tmp;
+	struct btrfs_device *device;
+	int fd;
+
+	list = &fs_info->fs_devices->devices;
+	list_for_each_safe(next, tmp, list) {
+		device = list_entry(next, struct btrfs_device, dev_list);
+		close(device->fd);
+		fd = open(device->name, O_RDWR);
+		if (fd < 0)
+			return -errno;
+		device->fd = fd;
+		device->writeable = 1;
+	}
+	fs_info->readonly = 0;
+	btrfs_update_block_groups_readonly(fs_info);
+	return 0;
+}
+
+int btrfs_make_readonly(struct btrfs_fs_info *fs_info)
+{
+	struct list_head *list;
+	struct list_head *next;
+	struct list_head *tmp;
+	struct btrfs_device *device;
+	int fd;
+
+	list = &fs_info->fs_devices->devices;
+	list_for_each_safe(next, tmp, list) {
+		device = list_entry(next, struct btrfs_device, dev_list);
+		close(device->fd);
+		fd = open(device->name, O_RDONLY);
+		if (fd < 0)
+			return -errno;
+		device->fd = fd;
+		device->writeable = 0;
+	}
+	fs_info->readonly = 1;
+	btrfs_update_block_groups_readonly(fs_info);
+	return 0;
+
+}
+
 int close_ctree(struct btrfs_root *root)
 {
 	int ret;
diff --git a/disk-io.h b/disk-io.h
index 49e5692..646586e 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -75,4 +75,6 @@ int csum_tree_block_size(struct extent_buffer *buf, u16 csum_sectorsize,
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 		    int verify);
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
+int btrfs_make_readwrite(struct btrfs_fs_info *fs_info);
+int btrfs_make_readonly(struct btrfs_fs_info *fs_info);
 #endif
diff --git a/extent-tree.c b/extent-tree.c
index e1d7ffd..49bffe7 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3135,6 +3135,68 @@ error:
 	return ret;
 }
 
+void btrfs_update_block_groups_readonly(struct btrfs_fs_info *info)
+{
+	struct btrfs_block_group_cache *cache;
+	struct extent_io_tree *block_group_cache;
+	int ret;
+	u64 ptr;
+	u64 start;
+	u64 end;
+
+	block_group_cache = &info->block_group_cache;
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
+		cache->ro = btrfs_chunk_readonly(info->extent_root,
+						 cache->key.objectid);
+		start = end + 1;
+	}
+}
+
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
