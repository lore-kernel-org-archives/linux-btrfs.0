Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59407 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756490AbcHWKnp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Aug 2016 06:43:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EA302ADB4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Aug 2016 10:26:26 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/13] btrfs-progs: document all btrfs_open_ctree_flags
Date: Tue, 23 Aug 2016 12:25:13 +0200
Message-Id: <1471947917-5324-10-git-send-email-dsterba@suse.com>
In-Reply-To: <1471947917-5324-1-git-send-email-dsterba@suse.com>
References: <1471947917-5324-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Document and add unsigned type to the values.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 disk-io.h | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/disk-io.h b/disk-io.h
index a73dede1e8d0..c404d3f4fdfe 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -29,21 +29,29 @@
 #define BTRFS_SUPER_MIRROR_SHIFT 12
 
 enum btrfs_open_ctree_flags {
-	OPEN_CTREE_WRITES		= (1 << 0),
-	OPEN_CTREE_PARTIAL		= (1 << 1),
-	OPEN_CTREE_BACKUP_ROOT		= (1 << 2),
-	OPEN_CTREE_RECOVER_SUPER	= (1 << 3),
-	OPEN_CTREE_RESTORE		= (1 << 4),
-	OPEN_CTREE_NO_BLOCK_GROUPS	= (1 << 5),
-	OPEN_CTREE_EXCLUSIVE		= (1 << 6),
-	OPEN_CTREE_NO_DEVICES		= (1 << 7),
+	/* Open filesystem for writes */
+	OPEN_CTREE_WRITES		= (1U << 0),
+	/* Allow to open filesystem with some broken tree roots (eg log root) */
+	OPEN_CTREE_PARTIAL		= (1U << 1),
+	/* If primary root pinters are invalid, try backup copies */
+	OPEN_CTREE_BACKUP_ROOT		= (1U << 2),
+	/* Allow reading all superblock sopies if the primary is damaged */
+	OPEN_CTREE_RECOVER_SUPER	= (1U << 3),
+	/* Restoring filesystem image */
+	OPEN_CTREE_RESTORE		= (1U << 4),
+	/* Do not read block groups (extent tree) */
+	OPEN_CTREE_NO_BLOCK_GROUPS	= (1U << 5),
+	/* Open all devices in O_EXCL mode */
+	OPEN_CTREE_EXCLUSIVE		= (1U << 6),
+	/* Do not scan devices */
+	OPEN_CTREE_NO_DEVICES		= (1U << 7),
 	/*
 	 * Don't print error messages if bytenr or checksums do not match in
 	 * tree block headers. Turn on by OPEN_CTREE_SUPPRESS_ERROR
 	 */
-	OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS	= (1 << 8),
-	/* Return chunk root */
-	__OPEN_CTREE_RETURN_CHUNK_ROOT	= (1 << 9),
+	OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS	= (1U << 8),
+	/* Return the chunk root */
+	__OPEN_CTREE_RETURN_CHUNK_ROOT	= (1U << 9),
 	OPEN_CTREE_CHUNK_ROOT_ONLY	= OPEN_CTREE_PARTIAL +
 					  OPEN_CTREE_SUPPRESS_CHECK_BLOCK_ERRORS +
 					  __OPEN_CTREE_RETURN_CHUNK_ROOT,
@@ -53,18 +61,19 @@ enum btrfs_open_ctree_flags {
 	 * Like split PARTIAL into SKIP_CSUM/SKIP_EXTENT
 	 */
 
-	OPEN_CTREE_IGNORE_FSID_MISMATCH	= (1 << 10),
+	/* Ignore UUID mismatches */
+	OPEN_CTREE_IGNORE_FSID_MISMATCH	= (1U << 10),
 
 	/*
-	 * Allow open_ctree_fs_info() to return a incomplete fs_info with
+	 * Allow open_ctree_fs_info() to return an incomplete fs_info with
 	 * system chunks from super block only.
-	 * It's useful for chunk corruption case.
+	 * It's useful when chunks are corrupted.
 	 * Makes no sense for open_ctree variants returning btrfs_root.
 	 */
-	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1 << 11),
+	OPEN_CTREE_IGNORE_CHUNK_TREE_ERROR = (1U << 11),
 
 	/* Allow to open a partially created filesystem */
-	OPEN_CTREE_FS_PARTIAL = (1 << 12),
+	OPEN_CTREE_FS_PARTIAL = (1U << 12),
 };
 
 /*
-- 
2.7.1

