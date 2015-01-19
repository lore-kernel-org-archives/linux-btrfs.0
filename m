Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751518AbbASGrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 01:47:24 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0J6kjIC022584
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 14:46:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 08/10] btrfs-progs: Cleanup unneeded btrfs-find-root codes.
Date: Mon, 19 Jan 2015 14:45:10 +0800
Message-ID: <1421649912-14539-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we switched to new open_ctree flag and new find-root facility,
there is no need to keep the old find-root codes.

Clean it up.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-find-root.c | 237 ------------------------------------------------------
 1 file changed, 237 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index c451c7b..31fe0ae 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -37,249 +37,12 @@
 #include "extent-cache.h"
 #include "find-root.h"
 
-static u16 csum_size = 0;
-static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
-static u64 search_generation = 0;
-static unsigned long search_level = 0;
-
 static void usage(void)
 {
 	fprintf(stderr, "Usage: find-roots [-o search_objectid] "
 		"[ -g search_generation ] [ -l search_level ] <device>\n");
 }
 
-static int csum_block(void *buf, u32 len)
-{
-	char *result;
-	u32 crc = ~(u32)0;
-	int ret = 0;
-
-	result = malloc(csum_size * sizeof(char));
-	if (!result) {
-		fprintf(stderr, "No memory\n");
-		return 1;
-	}
-
-	len -= BTRFS_CSUM_SIZE;
-	crc = crc32c(crc, buf + BTRFS_CSUM_SIZE, len);
-	btrfs_csum_final(crc, result);
-
-	if (memcmp(buf, result, csum_size))
-		ret = 1;
-	free(result);
-	return ret;
-}
-
-static struct btrfs_root *open_ctree_broken(int fd, const char *device)
-{
-	struct btrfs_fs_info *fs_info;
-	struct btrfs_super_block *disk_super;
-	struct btrfs_fs_devices *fs_devices = NULL;
-	struct extent_buffer *eb;
-	int ret;
-
-	fs_info = btrfs_new_fs_info(0, BTRFS_SUPER_INFO_OFFSET);
-	if (!fs_info) {
-		fprintf(stderr, "Failed to allocate memory for fs_info\n");
-		return NULL;
-	}
-
-	ret = btrfs_scan_fs_devices(fd, device, &fs_devices, 0, 1);
-	if (ret)
-		goto out;
-
-	fs_info->fs_devices = fs_devices;
-
-	ret = btrfs_open_devices(fs_devices, O_RDONLY);
-	if (ret)
-		goto out_devices;
-
-	disk_super = fs_info->super_copy;
-	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
-				   disk_super, fs_info->super_bytenr, 1);
-	if (ret) {
-		printk("No valid btrfs found\n");
-		goto out_devices;
-	}
-
-	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
-
-	ret = btrfs_check_fs_compatibility(disk_super, 0);
-	if (ret)
-		goto out_devices;
-
-	ret = btrfs_setup_chunk_tree_and_device_map(fs_info);
-	if (ret)
-		goto out_chunk;
-
-	eb = fs_info->chunk_root->node;
-	read_extent_buffer(eb, fs_info->chunk_tree_uuid,
-			   btrfs_header_chunk_tree_uuid(eb), BTRFS_UUID_SIZE);
-
-	return fs_info->chunk_root;
-out_chunk:
-	free_extent_buffer(fs_info->chunk_root->node);
-	btrfs_cleanup_all_caches(fs_info);
-out_devices:
-	btrfs_close_devices(fs_info->fs_devices);
-out:
-	btrfs_free_fs_info(fs_info);
-	return NULL;
-}
-
-static int search_iobuf(struct btrfs_root *root, void *iobuf,
-			size_t iobuf_size, off_t offset)
-{
-	u64 gen = search_generation;
-	u64 objectid = search_objectid;
-	u32 size = btrfs_super_nodesize(root->fs_info->super_copy);
-	u8 level = search_level;
-	size_t block_off = 0;
-
-	while (block_off < iobuf_size) {
-		void *block = iobuf + block_off;
-		struct btrfs_header *header = block;
-		u64 h_byte, h_level, h_gen, h_owner;
-
-//		printf("searching %Lu\n", offset + block_off);
-		h_byte = btrfs_stack_header_bytenr(header);
-		h_owner = btrfs_stack_header_owner(header);
-		h_level = header->level;
-		h_gen = btrfs_stack_header_generation(header);
-
-		if (h_owner != objectid)
-			goto next;
-		if (h_byte != (offset + block_off))
-			goto next;
-		if (h_level < level)
-			goto next;
-		level = h_level;
-		if (csum_block(block, size)) {
-			fprintf(stderr, "Well block %Lu seems good, "
-				"but the csum doesn't match\n",
-				h_byte);
-			goto next;
-		}
-		if (h_gen != gen) {
-			fprintf(stderr, "Well block %Lu seems great, "
-				"but generation doesn't match, "
-				"have=%Lu, want=%Lu level %Lu\n", h_byte,
-				h_gen, gen, h_level);
-			goto next;
-		}
-		printf("Found tree root at %Lu gen %Lu level %Lu\n", h_byte,
-		       h_gen, h_level);
-		return 0;
-next:
-		block_off += size;
-	}
-
-	return 1;
-}
-
-static int read_physical(struct btrfs_root *root, int fd, u64 offset,
-			 u64 bytenr, u64 len)
-{
-	char *iobuf = malloc(len);
-	ssize_t done;
-	size_t total_read = 0;
-	int ret = 1;
-
-	if (!iobuf) {
-		fprintf(stderr, "No memory\n");
-		return -1;
-	}
-
-	while (total_read < len) {
-		done = pread64(fd, iobuf + total_read, len - total_read,
-			       bytenr + total_read);
-		if (done < 0) {
-			fprintf(stderr, "Failed to read: %s\n",
-				strerror(errno));
-			ret = -1;
-			goto out;
-		}
-		total_read += done;
-	}
-
-	ret = search_iobuf(root, iobuf, total_read, offset);
-out:
-	free(iobuf);
-	return ret;
-}
-
-static int find_root(struct btrfs_root *root)
-{
-	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_device *device;
-	u64 metadata_offset = 0, metadata_size = 0;
-	off_t offset = 0;
-	off_t bytenr;
-	int fd;
-	int err;
-	int ret = 1;
-
-	printf("Super think's the tree root is at %Lu, chunk root %Lu\n",
-	       btrfs_super_root(root->fs_info->super_copy),
-	       btrfs_super_chunk_root(root->fs_info->super_copy));
-
-	err = btrfs_next_metadata(&root->fs_info->mapping_tree,
-				  &metadata_offset, &metadata_size);
-	if (err)
-		return ret;
-
-	offset = metadata_offset;
-	while (1) {
-		u64 map_length = 4096;
-		u64 type;
-
-		if (offset >
-		    btrfs_super_total_bytes(root->fs_info->super_copy)) {
-			printf("Went past the fs size, exiting");
-			break;
-		}
-		if (offset >= (metadata_offset + metadata_size)) {
-			err = btrfs_next_metadata(&root->fs_info->mapping_tree,
-						  &metadata_offset,
-						  &metadata_size);
-			if (err) {
-				printf("No more metdata to scan, exiting\n");
-				break;
-			}
-			offset = metadata_offset;
-		}
-		err = __btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      offset, &map_length, &type,
-				      &multi, 0, NULL);
-		if (err) {
-			offset += map_length;
-			continue;
-		}
-
-		if (!(type & BTRFS_BLOCK_GROUP_METADATA)) {
-			offset += map_length;
-			kfree(multi);
-			continue;
-		}
-
-		device = multi->stripes[0].dev;
-		fd = device->fd;
-		bytenr = multi->stripes[0].physical;
-		kfree(multi);
-
-		err = read_physical(root, fd, offset, bytenr, map_length);
-		if (!err) {
-			ret = 0;
-			break;
-		} else if (err < 0) {
-			ret = err;
-			break;
-		}
-		offset += map_length;
-	}
-	return ret;
-}
-
 /*
  * Get reliable generation and level for given root.
  *
-- 
2.2.2

