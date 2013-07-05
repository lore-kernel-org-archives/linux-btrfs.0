Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52195 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3GESM2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 14:12:28 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B81E47C067F
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 12:12:27 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id 34fidYNAAhXgabp3 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 05 Jul 2013 12:12:27 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not offset physical if we're compressed
Date: Fri, 5 Jul 2013 14:12:24 -0400
Message-ID: <1373047944-3705-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstest btrfs/276 was freaking out on slower boxes partly because fiemap was
offsetting the physical based on the extent offset.  This is perfectly fine with
uncompressed extents, however the extent offset is into the uncompressed area,
not the compressed.  So we can return a physical value that isn't at all within
the area we have allocated on disk.  Fix this by returning the start of the
extent if it is compressed no matter what the offset.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent_io.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f8586a9..b9244ce 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4049,7 +4049,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 
 	while (!end) {
-		u64 offset_in_extent;
+		u64 offset_in_extent = 0;
 
 		/* break if the extent we found is outside the range */
 		if (em->start >= max || extent_map_end(em) < off)
@@ -4065,9 +4065,12 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 		/*
 		 * record the offset from the start of the extent
-		 * for adjusting the disk offset below
+		 * for adjusting the disk offset below.  Only do this if the
+		 * extent isn't compressed since our in ram offset may be past
+		 * what we have actually allocated on disk.
 		 */
-		offset_in_extent = em_start - em->start;
+		if (!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
+			offset_in_extent = em_start - em->start;
 		em_end = extent_map_end(em);
 		em_len = em_end - em_start;
 		emflags = em->flags;
-- 
1.7.7.6

