Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43534 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751389AbdBUIe5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 03:34:57 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 7840547C4E95
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2017 16:34:43 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 04/12] btrfs-progs: lowmem check: Fix extent item size false alert
Date: Tue, 21 Feb 2017 16:34:30 +0800
Message-ID: <20170221083438.25719-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If one extent item has no inline ref, btrfs lowmem mode check can give
false alert without outputting any error message.

The problem is lowmem mode always assume that extent item has inline
refs, and when it encounters such case it flags the extent item has
wrong size, but doesn't output the error message.

Although we already have such image submitted, at the commit time due to
another bug in cmds-check return value, it doesn't detect it until that
bug is fixed.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e99e3c36..eb146432 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10761,13 +10761,20 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	}
 	end = (unsigned long)ei + item_size;
 
-	if (ptr >= end) {
+next:
+	/* Reached extent item end normally */
+	if (ptr == end)
+		goto out;
+
+	/* Beyond extent item end, wrong item size */
+	if (ptr > end) {
 		err |= ITEM_SIZE_MISMATCH;
+		error("extent item at bytenr %llu slot %d has wrong size",
+			eb->start, slot);
 		goto out;
 	}
 
 	/* Now check every backref in this extent item */
-next:
 	iref = (struct btrfs_extent_inline_ref *)ptr;
 	type = btrfs_extent_inline_ref_type(eb, iref);
 	offset = btrfs_extent_inline_ref_offset(eb, iref);
@@ -10804,8 +10811,7 @@ next:
 	}
 
 	ptr += btrfs_extent_inline_ref_size(type);
-	if (ptr < end)
-		goto next;
+	goto next;
 
 out:
 	return err;
-- 
2.11.1



