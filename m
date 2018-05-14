Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932167AbeENHDO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 03:03:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ACF0AE6C
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 07:03:13 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: check/lowmem: Add checks for compressed extent without csum
Date: Mon, 14 May 2018 15:03:08 +0800
Message-Id: <20180514070310.27197-2-wqu@suse.com>
In-Reply-To: <20180514070310.27197-1-wqu@suse.com>
References: <20180514070310.27197-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is one report of compressed extent happens in btrfs, but has no
csum and then leads to possible decompress error screwing up kernel
memory.

Although it's a kernel bug, and won't cause problem until compressed
data get corrupted, let's catch such problem in advance.

This patch will catch any unexpected compressed extent with:

1) 0 or less than expected csum

2) nodatasum flag set in the inode item

This is for lowmem mode.

Reported-by: James Harvey <jamespharvey20@gmail.com>
Issue: #134
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index dac3201b7d99..8e6d5e8de12a 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1543,6 +1543,24 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
 			      csum_found);
 		}
 	}
+	/*
+	 * Extra check for compressed extents.
+	 * Btrfs doesn't allow NODATASUM and compressed extent co-exist, thus
+	 * all compressed extent should have csum.
+	 */
+	if (compressed && csum_found < search_len) {
+		error(
+"root %llu EXTENT_DATA[%llu %llu] compressed extent must have csum, but only %llu bytes has csum, expect %llu",
+		      root->objectid, fkey->objectid, fkey->offset, csum_found,
+		      search_len);
+		err |= CSUM_ITEM_MISSING;
+	}
+	if (compressed && nodatasum) {
+		error(
+"root %llu EXTENT_DATA[%llu %llu] is compressed, but inode flag doesn't allow it",
+		      root->objectid, fkey->objectid, fkey->offset);
+		err |= FILE_EXTENT_ERROR;
+	}
 
 	/* Check EXTENT_DATA hole */
 	if (!no_holes && *end != fkey->offset) {
-- 
2.17.0

