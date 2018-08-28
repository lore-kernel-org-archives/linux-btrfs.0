Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51578 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbeH1RMp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 13:12:45 -0400
From: Colin King <colin.king@canonical.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: remove unused pointer 'tree'
Date: Tue, 28 Aug 2018 14:21:01 +0100
Message-Id: <20180828132101.9559-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer 'tree' is being assigned but is never used hence it is
redundant and can be removed.

Cleans up clang warning:
warning: variable 'tree' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/btrfs/compression.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 9bfa66592aa7..8703ce68fe9d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -528,7 +528,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	struct extent_io_tree *tree;
 	struct extent_map_tree *em_tree;
 	struct compressed_bio *cb;
 	unsigned long compressed_len;
@@ -545,7 +544,6 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	int faili = 0;
 	u32 *sums;
 
-	tree = &BTRFS_I(inode)->io_tree;
 	em_tree = &BTRFS_I(inode)->extent_tree;
 
 	/* we need the actual starting offset of this extent in the file */
-- 
2.17.1
