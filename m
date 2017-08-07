Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41953 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751829AbdHGUkP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 16:40:15 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77KeEug032335
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 20:40:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77KeDgk003983
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 20:40:14 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v77KeDTL032187
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 20:40:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix out of bounds array access while reading extent buffer
Date: Mon,  7 Aug 2017 13:39:03 -0600
Message-Id: <20170807193903.9093-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a cornel case that slip through the checkers in functions
reading extent buffer, ie.

if (start < eb->len) and (start + len > eb->len),
then

a) map_private_extent_buffer() returns immediately because
it's thinking the range spans across two pages,

b) and the checkers in read_extent_buffer(), WARN_ON(start > eb->len)
and WARN_ON(start + len > eb->start + eb->len), both are OK in this
corner case, but it'd actually try to access the eb->pages out of
bounds because of (start + len > eb->len).

The case is found by switching extent inline ref type from shared data
ref to non-shared data ref.

This is adding proper checks in order to avoid invalid memory access,
ie. 'general protection', before it's too late.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0aff9b2..d198e87 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5416,13 +5416,19 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	char *dst = (char *)dstv;
 	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
+	unsigned long num_pages = num_extent_pages(eb->start, eb->len);
 
-	WARN_ON(start > eb->len);
-	WARN_ON(start + len > eb->start + eb->len);
+	if (start + len > eb->len) {
+		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
+		     eb->start, eb->len, start, len);
+		memset(dst, 0, len);
+		return;
+	}
 
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
 	while (len > 0) {
+		ASSERT(i < num_pages);
 		page = eb->pages[i];
 
 		cur = min(len, (PAGE_SIZE - offset));
@@ -5491,6 +5497,12 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	unsigned long end_i = (start_offset + start + min_len - 1) >>
 		PAGE_SHIFT;
 
+	if (start + min_len > eb->len) {
+		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
+		       eb->start, eb->len, start, min_len);
+		return -EINVAL;
+	}
+
 	if (i != end_i)
 		return 1;
 
@@ -5502,12 +5514,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 		*map_start = ((u64)i << PAGE_SHIFT) - start_offset;
 	}
 
-	if (start + min_len > eb->len) {
-		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
-		       eb->start, eb->len, start, min_len);
-		return -EINVAL;
-	}
-
 	p = eb->pages[i];
 	kaddr = page_address(p);
 	*map = kaddr + offset;
-- 
2.9.4

