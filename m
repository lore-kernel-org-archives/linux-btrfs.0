Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41525 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751887AbdBMJd6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Feb 2017 04:33:58 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DCFDABD3
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Feb 2017 09:33:56 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/29] btrfs: remove unused parameter from check_async_write
Date: Mon, 13 Feb 2017 10:33:27 +0100
Message-Id: <fd86bfb5b6f0b3191df78582a778ec7f58b2b386.1486977711.git.dsterba@suse.com>
In-Reply-To: <cover.1486977711.git.dsterba@suse.com>
References: <cover.1486977711.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Added but never used.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 18004169552c..89cd597883fd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1005,7 +1005,7 @@ static int __btree_submit_bio_done(struct inode *inode, struct bio *bio,
 	return ret;
 }
 
-static int check_async_write(struct inode *inode, unsigned long bio_flags)
+static int check_async_write(unsigned long bio_flags)
 {
 	if (bio_flags & EXTENT_BIO_TREE_LOG)
 		return 0;
@@ -1021,7 +1021,7 @@ static int btree_submit_bio_hook(struct inode *inode, struct bio *bio,
 				 u64 bio_offset)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	int async = check_async_write(inode, bio_flags);
+	int async = check_async_write(bio_flags);
 	int ret;
 
 	if (bio_op(bio) != REQ_OP_WRITE) {
-- 
2.10.1

