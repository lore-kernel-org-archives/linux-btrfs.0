Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10065 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935147AbaH0Svr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 14:51:47 -0400
Received: from pps.filterd (m0044008 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s7RIouHA028808
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 11:51:47 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1p0499mtms-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 11:51:47 -0700
Message-ID: <53FE28C0.4010603@fb.com>
Date: Wed, 27 Aug 2014 14:51:44 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix autodefrag with compression
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


The autodefrag code skips defrag when two extents are adjacent.  But one
big advantage for autodefrag is cutting down on the number of small
extents, even when they are adjacent.  This commit changes it to defrag
all small extents.

This is especially useful when trying to use compression on slowly
growing log files.  We usually end up writing 4K or less at a time, so
the compression code isn't able to compress across multiple pages.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/ioctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fce6fd0e..a018ea4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1019,8 +1019,10 @@ static bool defrag_check_next_extent(struct inode *inode, struct extent_map *em)
 		return false;
 
 	next = defrag_lookup_extent(inode, em->start + em->len);
-	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE ||
-	    (em->block_start + em->block_len == next->block_start))
+	if (!next || next->block_start >= EXTENT_MAP_LAST_BYTE)
+		ret = false;
+	else if ((em->block_start + em->block_len == next->block_start) &&
+		 (em->block_len > 128 * 1024 && next->block_len > 128 * 1024))
 		ret = false;
 
 	free_extent_map(next);
