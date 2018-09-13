Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727403AbeIMROW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:14:22 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33D05AFED
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 12:05:11 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/3] btrfs-progs: check: lowmem: Refactor extent len test in check_file_extent_inline
Date: Thu, 13 Sep 2018 15:05:06 +0300
Message-Id: <20180913120507.18197-3-nborisov@suse.com>
In-Reply-To: <20180913120507.18197-1-nborisov@suse.com>
References: <20180913120507.18197-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of having another top-level if which checks for
'extent_num_bytes != item_inline_len' only if we are !compressed, just
move the 'if' inside the 'else' branch of the first top-level if, since
it has already checked for !compressed or not. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 48c1537e7440..3a6fbb33c858 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1860,19 +1860,20 @@ static int check_file_extent_inline(struct btrfs_root *root,
 				err |= FILE_EXTENT_ERROR;
 		}
 
-	}
-	if (!compressed && extent_num_bytes != item_inline_len) {
-		error(
+
+		if (extent_num_bytes != item_inline_len) {
+			error(
 "root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
 				root->objectid, fkey.objectid, fkey.offset,
 				extent_num_bytes, item_inline_len);
-		if (repair) {
-			ret = repair_inline_ram_bytes(root, path,
-						      &extent_num_bytes);
-			if (ret)
+			if (repair) {
+				ret = repair_inline_ram_bytes(root, path,
+							      &extent_num_bytes);
+				if (ret)
+					err |= FILE_EXTENT_ERROR;
+			} else {
 				err |= FILE_EXTENT_ERROR;
-		} else {
-			err |= FILE_EXTENT_ERROR;
+			}
 		}
 	}
 	*end += extent_num_bytes;
-- 
2.17.1
