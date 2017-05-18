Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43366 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932165AbdERDjW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:22 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 09/32] btrfs-progs: Refactor block sizes users in cmds-restore.c
Date: Thu, 18 May 2017 11:38:34 +0800
Message-ID: <20170518033857.15002-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-restore.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index c327cef0..09388b29 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -126,7 +126,7 @@ static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
 
 		inbuf += LZO_LEN;
 		tot_in += LZO_LEN;
-		new_len = lzo1x_worst_compress(root->sectorsize);
+		new_len = lzo1x_worst_compress(root->fs_info->sectorsize);
 		ret = lzo1x_decompress_safe((const unsigned char *)inbuf, in_len,
 					    (unsigned char *)outbuf,
 					    (void *)&new_len, NULL);
@@ -143,8 +143,8 @@ static int decompress_lzo(struct btrfs_root *root, unsigned char *inbuf,
 		 * If the 4 byte header does not fit to the rest of the page we
 		 * have to move to the next one, unless we read some garbage
 		 */
-		mod_page = tot_in % root->sectorsize;
-		rem_page = root->sectorsize - mod_page;
+		mod_page = tot_in % root->fs_info->sectorsize;
+		rem_page = root->fs_info->sectorsize - mod_page;
 		if (rem_page < LZO_LEN) {
 			inbuf += rem_page;
 			tot_in += rem_page;
@@ -1256,7 +1256,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 			root_location = btrfs_super_root(fs_info->super_copy);
 		generation = btrfs_super_generation(fs_info->super_copy);
 		root->node = read_tree_block(root, root_location,
-					     root->nodesize, generation);
+					     fs_info->nodesize, generation);
 		if (!extent_buffer_uptodate(root->node)) {
 			fprintf(stderr, "Error opening tree root\n");
 			close_ctree(root);
@@ -1502,7 +1502,8 @@ int cmd_restore(int argc, char **argv)
 
 	if (fs_location != 0) {
 		free_extent_buffer(root->node);
-		root->node = read_tree_block(root, fs_location, root->nodesize, 0);
+		root->node = read_tree_block(root, fs_location,
+				root->fs_info->nodesize, 0);
 		if (!extent_buffer_uptodate(root->node)) {
 			fprintf(stderr, "Failed to read fs location\n");
 			ret = 1;
-- 
2.13.0



