Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:34360 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbeCMB42 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 12 Mar 2018 21:56:28 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/7] btrfs-progs: convert/reiserfs: Fix inline file extent creation check
Date: Tue, 13 Mar 2018 09:56:11 +0800
Message-Id: <20180313015616.6574-3-wqu@suse.com>
In-Reply-To: <20180313015616.6574-1-wqu@suse.com>
References: <20180313015616.6574-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 convert/source-reiserfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/convert/source-reiserfs.c b/convert/source-reiserfs.c
index 39d6f0728bd3..eeb68d962c5d 100644
--- a/convert/source-reiserfs.c
+++ b/convert/source-reiserfs.c
@@ -376,7 +376,8 @@ static int reiserfs_convert_tail(struct btrfs_trans_handle *trans,
 	u64 isize;
 	int ret;
 
-	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info))
+	if (length >= BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info) ||
+	    length >= root->fs_info->sectorsize)
 		return convert_direct(trans, root, objectid, inode, body,
 				      length, offset, convert_flags);
 
-- 
2.16.2

