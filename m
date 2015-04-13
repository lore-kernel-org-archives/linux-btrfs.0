Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58522 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbbDMTzh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:55:37 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3DJkAge009010
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:55:36 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1trj5hrkky-8
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:55:36 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.236.89) with ESMTP	id
 aa1dad10e21611e4a0980002c95209d8-183ea2c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:52:50 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] Btrfs: don't use highmem for free space cache pages
Date: Mon, 13 Apr 2015 12:52:38 -0700
Message-ID: <1428954759-1304912-4-git-send-email-clm@fb.com>
In-Reply-To: <1428954759-1304912-1-git-send-email-clm@fb.com>
References: <1428954759-1304912-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to create the free space cache concurrently with FS modifications,
we need to take a few block group locks.

The cache code also does kmap, which would schedule with the locks held.
Instead of going through kmap_atomic, lets just use lowmem for the cache
pages.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/free-space-cache.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 6886ae0..83532a2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -85,7 +85,8 @@ static struct inode *__lookup_free_space_inode(struct btrfs_root *root,
 	}
 
 	mapping_set_gfp_mask(inode->i_mapping,
-			mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+			mapping_gfp_mask(inode->i_mapping) &
+			~(GFP_NOFS & ~__GFP_HIGHMEM));
 
 	return inode;
 }
@@ -310,7 +311,6 @@ static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
 static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
 {
 	if (io_ctl->cur) {
-		kunmap(io_ctl->page);
 		io_ctl->cur = NULL;
 		io_ctl->orig = NULL;
 	}
@@ -320,7 +320,7 @@ static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
 {
 	ASSERT(io_ctl->index < io_ctl->num_pages);
 	io_ctl->page = io_ctl->pages[io_ctl->index++];
-	io_ctl->cur = kmap(io_ctl->page);
+	io_ctl->cur = page_address(io_ctl->page);
 	io_ctl->orig = io_ctl->cur;
 	io_ctl->size = PAGE_CACHE_SIZE;
 	if (clear)
@@ -446,10 +446,9 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_ctl, int index)
 			      PAGE_CACHE_SIZE - offset);
 	btrfs_csum_final(crc, (char *)&crc);
 	io_ctl_unmap_page(io_ctl);
-	tmp = kmap(io_ctl->pages[0]);
+	tmp = page_address(io_ctl->pages[0]);
 	tmp += index;
 	*tmp = crc;
-	kunmap(io_ctl->pages[0]);
 }
 
 static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
@@ -466,10 +465,9 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *io_ctl, int index)
 	if (index == 0)
 		offset = sizeof(u32) * io_ctl->num_pages;
 
-	tmp = kmap(io_ctl->pages[0]);
+	tmp = page_address(io_ctl->pages[0]);
 	tmp += index;
 	val = *tmp;
-	kunmap(io_ctl->pages[0]);
 
 	io_ctl_map_page(io_ctl, 0);
 	crc = btrfs_csum_data(io_ctl->orig + offset, crc,
-- 
1.8.1

