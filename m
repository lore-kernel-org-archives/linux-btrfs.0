Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29243 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbbHGIsz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 04:48:55 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t778msqo011488
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 08:48:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t778ms5E012075
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 08:48:54 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t778msvF007839
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Aug 2015 08:48:54 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix defrag to merge tail file extent
Date: Fri,  7 Aug 2015 16:48:41 +0800
Message-Id: <1438937321-19042-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The file layout is

[extent 1]...[extent n][4k extent][HOLE][extent x]

extent 1~n and 4k extent can be merged during defrag, and the whole
defrag bytes is larger than our defrag thresh(256k), 4k extent as a
tail is left unmerged since we check if its next extent can be merged
(the next one is a hole, so the check will fail), the layout thus can
be

[new extent][4k extent][HOLE][extent x]
 (1~n)

To fix it, beside looking at the next one, this also looks at the
previous one by checking @defrag_end, which is set to 0 when we
decide to stop merging contiguous extents, otherwise, we can merge
the previous one with our extent.

Also, this makes btrfs behave consistent with how xfs and ext4 do.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0770c91..0691b2b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1030,6 +1030,7 @@ static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 	struct extent_map *em;
 	int ret = 1;
 	bool next_mergeable = true;
+	bool prev_mergeable = true;
 
 	/*
 	 * make sure that once we start defragging an extent, we keep on
@@ -1050,13 +1051,16 @@ static int should_defrag_range(struct inode *inode, u64 start, u32 thresh,
 		goto out;
 	}
 
+	if (!*defrag_end)
+		prev_mergeable = false;
+
 	next_mergeable = defrag_check_next_extent(inode, em);
 	/*
 	 * we hit a real extent, if it is big or the next extent is not a
 	 * real extent, don't bother defragging it
 	 */
 	if (!compress && (*last_len == 0 || *last_len >= thresh) &&
-	    (em->len >= thresh || !next_mergeable))
+	    (em->len >= thresh || (!next_mergeable && !prev_mergeable)))
 		ret = 0;
 out:
 	/*
-- 
2.1.0

