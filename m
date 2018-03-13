Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:38247 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932242AbeCMB43 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:29 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/7] btrfs-progs: mkfs/rootdir: Fix inline extent creation check
Date: Tue, 13 Mar 2018 09:56:12 +0800
Message-Id: <20180313015616.6574-4-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just like convert, we need extra check against sector size for creating
inline extent.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 mkfs/rootdir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mkfs/rootdir.c b/mkfs/rootdir.c
index e06b65ac13e4..a1d223a2408a 100644
--- a/mkfs/rootdir.c
+++ b/mkfs/rootdir.c
@@ -139,7 +139,8 @@ static int fill_inode_item(struct btrfs_trans_handle *trans,
 	}
 	if (S_ISREG(src->st_mode)) {
 		btrfs_set_stack_inode_size(dst, (u64)src->st_size);
-		if (src->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
+		if (src->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info) &&
+		    src->st_size < sectorsize)
 			btrfs_set_stack_inode_nbytes(dst, src->st_size);
 		else {
 			blocks = src->st_size / sectorsize;
@@ -327,7 +328,8 @@ static int add_file_items(struct btrfs_trans_handle *trans,
 	if (st->st_size % sectorsize)
 		blocks += 1;
 
-	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info)) {
+	if (st->st_size <= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info) &&
+	    st->st_size < sectorsize) {
 		char *buffer = malloc(st->st_size);
 
 		if (!buffer) {
-- 
2.16.2

