Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51149 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdHISL2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 14:11:28 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v79IBRrS021674
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 9 Aug 2017 18:11:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v79IBR7P008077
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 9 Aug 2017 18:11:27 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v79IBRoc000531
        for <linux-btrfs@vger.kernel.org>; Wed, 9 Aug 2017 18:11:27 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: fix out of bounds array access while reading extent buffer
Date: Wed,  9 Aug 2017 11:10:16 -0600
Message-Id: <20170809171016.7501-1-bo.li.liu@oracle.com>
In-Reply-To: <20170807193903.9093-1-bo.li.liu@oracle.com>
References: <20170807193903.9093-1-bo.li.liu@oracle.com>
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
ref to non-shared data ref, which is a kind of metadata corruption.

It'd use the wrong helper to access the eb,
eg. btrfs_extent_data_ref_root(eb, ref) is used but the %ref passing
here is "struct btrfs_shared_data_ref".  And if the extent item
happens to be the first item in the eb, then offset/length will get
over eb->len which ends up an invalid memory access.

This is adding proper checks in order to avoid invalid memory access,
ie. 'general protection fault', before it's too late.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---

v3: Remove the unnecessary ASSERT and num_pages.

v2: Improve the commit log to clarify that this can only happen if
metadata is corrupted.

 fs/btrfs/extent_io.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0aff9b2..e6c6853 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5417,8 +5417,12 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 	size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
 	unsigned long i = (start_offset + start) >> PAGE_SHIFT;
 
-	WARN_ON(start > eb->len);
-	WARN_ON(start + len > eb->start + eb->len);
+	if (start + len > eb->len) {
+		WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
+		     eb->start, eb->len, start, len);
+		memset(dst, 0, len);
+		return;
+	}
 
 	offset = (start_offset + start) & (PAGE_SIZE - 1);
 
@@ -5491,6 +5495,12 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
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
 
@@ -5502,12 +5512,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
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

