Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:39442 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab3AVUiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 15:38:55 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id lrmMsXIPXnZQqISs (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 13:38:54 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: put csums on the right ordered extent
Date: Tue, 22 Jan 2013 15:45:35 -0500
Message-ID: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a WARN_ON going off when adding csums because we were going over
the amount of csum bytes that should have been allowed for an ordered
extent.  This is a leftover from when we used to hold the csums privately
for direct io, but now we use the normal ordered sum stuff so we need to
make sure and check if we've moved on to another extent so that the csums
are added to the right extent.  Without this we could end up with csums for
bytenrs that don't have extents to cover them yet.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/file-item.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 93ddc2e..f21b490 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -460,8 +460,8 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 		if (!contig)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
 
-		if (!contig && (offset >= ordered->file_offset + ordered->len ||
-		    offset < ordered->file_offset)) {
+		if (offset >= ordered->file_offset + ordered->len ||
+		    offset < ordered->file_offset) {
 			unsigned long bytes_left;
 			sums->len = this_sum_bytes;
 			this_sum_bytes = 0;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
