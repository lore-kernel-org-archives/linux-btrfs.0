Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8336 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758117AbbFQHtN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:49:13 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5H7lYUJ015779
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 15:47:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: map-logical: Rework map-logical logics.
Date: Wed, 17 Jun 2015 15:49:04 +0800
Message-ID: <1434527344-314-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434527344-314-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[[BUG]]
The original map-logical has the following problems:
1) Assert if we pass any tree root bytenr.
The problem is easy to trigger, here the number 29622272 is the bytenr of tree root:

 # btrfs-map-logical -l 29622272 /dev/sda6
 mirror 1 logical 29622272 physical 38010880 device /dev/sda6
 mirror 2 logical 29622272 physical 1111752704 device /dev/sda6
 extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
 btrfs-map-logical[0x41c464]
 btrfs-map-logical(free_extent_buffer+0xc0)[0x41cf10]
 btrfs-map-logical(btrfs_release_all_roots+0x59)[0x40e649]
 btrfs-map-logical(close_ctree+0x1aa)[0x40f51a]
 btrfs-map-logical(main+0x387)[0x4077c7]
 /usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f80a5562790]
 btrfs-map-logical(_start+0x29)[0x4078f9]

The problem is that, btrfs-map-logical always use sectorsize as default
block size to call alloc_extent_buffer.
And when it failes to find the block with the same size, it will free
the extent buffer in a incorrect method(Free and create a new one with
refs == 1).

2) Will return map result for non-exist extent.

 # btrfs-map-logical -l 1 -b 123456 /dev/sda6
 mirror 1 logical 1 physical 1 device /dev/sda6
 mirror 1 logical 4097 physical 4097 device /dev/sda6
 mirror 1 logical 8193 physical 8193 device /dev/sda6
 ...

Normally, before bytenr 12582912, there should be no extent as that's
the mkfs time temp metadata/system chunk.

But map-logical will still map them out.

Not to mention the 1 offset among all results.

[[FIX]]
This patch will rework the whole map logical by the following methods:
1) Always do things inside a extent
Even under the following case, map logical will only return covered
range in existing extents.

	|<------ range given ------->|
|<-Extent A->|	|<-Extent B->|	|<---Extent C->|
Result:
	|<-->|	|<---------->|	|<-->|

So with this patch, we will search extent tree to ensure all operation
are inside a extent before we do some stupid things.

2) No direct call on alloc_extent_buffer function.

That low-level function shouldn't be called at such high level.
It's only designed for low-level tree operation.

So in this patch we will only use safe high level functions avoid such
problem.

[[RESULT]]
With this patch, no assert will be triggered and better handle on
non-exist extents.

 # btrfs-map-logical -l 29622272 /dev/sda6
 mirror 1 logical 29622272 physical 38010880 device /dev/sda6
 mirror 2 logical 29622272 physical 1111752704 device /dev/sda6

 # btrfs-map-logical -l 1 -b 123456 /dev/sda6
 No extent found at range [1,123457)

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-map-logical.c | 148 ++++++++++++++++++++++++----------------------------
 1 file changed, 67 insertions(+), 81 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 1ee101c..a88e56e 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -190,69 +190,6 @@ static int write_extent_content(struct btrfs_fs_info *fs_info, int out_fd,
 	return ret;
 }
 
-static struct extent_buffer * debug_read_block(struct btrfs_root *root,
-		u64 bytenr, u32 blocksize, u64 copy)
-{
-	int ret;
-	struct extent_buffer *eb;
-	u64 length;
-	struct btrfs_multi_bio *multi = NULL;
-	struct btrfs_device *device;
-	int num_copies;
-	int mirror_num = 1;
-
-	eb = btrfs_find_create_tree_block(root, bytenr, blocksize);
-	if (!eb)
-		return NULL;
-
-	length = blocksize;
-	while (1) {
-		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
-				      eb->start, &length, &multi,
-				      mirror_num, NULL);
-		if (ret) {
-			fprintf(info_file,
-				"Error: fails to map mirror%d logical %llu: %s\n",
-				mirror_num, (unsigned long long)eb->start,
-				strerror(-ret));
-			free_extent_buffer(eb);
-			return NULL;
-		}
-		device = multi->stripes[0].dev;
-		eb->fd = device->fd;
-		device->total_ios++;
-		eb->dev_bytenr = multi->stripes[0].physical;
-
-		fprintf(info_file, "mirror %d logical %Lu physical %Lu "
-			"device %s\n", mirror_num, (unsigned long long)bytenr,
-			(unsigned long long)eb->dev_bytenr, device->name);
-		kfree(multi);
-
-		if (!copy || mirror_num == copy) {
-			ret = read_extent_from_disk(eb, 0, eb->len);
-			if (ret) {
-				fprintf(info_file,
-					"Error: failed to read extent: mirror %d logical %llu: %s\n",
-					mirror_num, (unsigned long long)eb->start,
-					strerror(-ret));
-				free_extent_buffer(eb);
-				eb = NULL;
-				break;
-			}
-		}
-
-		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
-					      eb->start, eb->len);
-		if (num_copies == 1)
-			break;
-
-		mirror_num++;
-		if (mirror_num > num_copies)
-			break;
-	}
-	return eb;
-}
-
 static void print_usage(void) __attribute__((noreturn));
 static void print_usage(void)
 {
@@ -268,14 +205,16 @@ int main(int ac, char **av)
 {
 	struct cache_tree root_cache;
 	struct btrfs_root *root;
-	struct extent_buffer *eb;
 	char *dev;
 	char *output_file = NULL;
-	u64 logical = 0;
-	int ret = 0;
 	u64 copy = 0;
+	u64 logical = 0;
 	u64 bytes = 0;
-	int out_fd = 0;
+	u64 cur_logical = 0;
+	u64 cur_len = 0;
+	int out_fd = -1;
+	int found = 0;
+	int ret = 0;
 
 	while(1) {
 		int c;
@@ -346,30 +285,77 @@ int main(int ac, char **av)
 	}
 
 	if (bytes == 0)
-		bytes = root->sectorsize;
+		bytes = root->nodesize;
+	cur_logical = logical;
+	cur_len = bytes;
+
+	/* First find the nearest extent */
+	ret = map_one_extent(root->fs_info, &cur_logical, &cur_len, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to find extent at [%llu,%llu): %s\n",
+			cur_logical, cur_logical + cur_len, strerror(-ret));
+		goto out_close_fd;
+	}
+	/*
+	 * Normally, search backward should be OK, but for special case like
+	 * given logical is quite small where no extents are before it,
+	 * we need to search forward.
+	 */
+	if (ret > 0) {
+		ret = map_one_extent(root->fs_info, &cur_logical, &cur_len, 1);
+		if (ret < 0) {
+			fprintf(stderr,
+				"Failed to find extent at [%llu,%llu): %s\n",
+				cur_logical, cur_logical + cur_len,
+				strerror(-ret));
+			goto out_close_fd;
+		}
+		if (ret > 0) {
+			fprintf(stderr,
+				"Failed to find any extent at [%llu,%llu)\n",
+				cur_logical, cur_logical + cur_len);
+			goto out_close_fd;
+		}
+	}
 
-	bytes = (bytes + root->sectorsize - 1) / root->sectorsize;
-	bytes *= root->sectorsize;
+	while (cur_logical + cur_len >= logical && cur_logical < logical +
+	       bytes) {
+		u64 real_logical;
+		u64 real_len;
 
-	while (bytes > 0) {
-		eb = debug_read_block(root, logical, root->sectorsize, copy);
-		if (eb && output_file) {
-			ret = write(out_fd, eb->data, eb->len);
-			if (ret < 0 || ret != eb->len) {
-				ret = 1;
-				fprintf(stderr, "output file write failed\n");
+		found = 1;
+		ret = map_one_extent(root->fs_info, &cur_logical, &cur_len, 1);
+		if (ret < 0)
+			goto out_close_fd;
+		if (ret > 0)
+			break;
+		real_logical = max(logical, cur_logical);
+		real_len = min(logical + bytes, cur_logical + cur_len) -
+			   real_logical;
+
+		ret = print_mapping_info(root->fs_info, real_logical, real_len);
+		if (ret < 0)
+			goto out_close_fd;
+		if (output_file && out_fd != -1) {
+			ret = write_extent_content(root->fs_info, out_fd,
+					real_logical, real_len, copy);
+			if (ret < 0)
 				goto out_close_fd;
-			}
 		}
-		free_extent_buffer(eb);
-		logical += root->sectorsize;
-		bytes -= root->sectorsize;
+
+		cur_logical += cur_len;
 	}
 
+	if (!found) {
+		fprintf(stderr, "No extent found at range [%llu,%llu)\n",
+			logical, logical + bytes);
+	}
 out_close_fd:
 	if (output_file && out_fd != 1)
 		close(out_fd);
 close:
 	close_ctree(root);
+	if (ret < 0)
+		ret = 1;
 	return ret;
 }
-- 
2.4.3

