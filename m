Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36524 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774AbbESNwU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 09:52:20 -0400
Received: by pdfh10 with SMTP id h10so26369664pdf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 06:52:19 -0700 (PDT)
Received: from arch-nb.localdomain ([211.40.97.131])
        by mx.google.com with ESMTPSA id da3sm13249640pdb.8.2015.05.19.06.52.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 May 2015 06:52:18 -0700 (PDT)
From: Byongho Lee <bhlee.kernel@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove unused inode argument from uncompress_inline()
Date: Tue, 19 May 2015 22:51:54 +0900
Message-Id: <1432043514-2254-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The inode argument is never used from the beginning, so remove it.
---
 fs/btrfs/inode.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0020b56..6abd9ae 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6565,7 +6565,7 @@ static int merge_extent_mapping(struct extent_map_tree *em_tree,
 }
 
 static noinline int uncompress_inline(struct btrfs_path *path,
-				      struct inode *inode, struct page *page,
+				      struct page *page,
 				      size_t pg_offset, u64 extent_offset,
 				      struct btrfs_file_extent_item *item)
 {
@@ -6761,8 +6761,7 @@ next:
 		if (create == 0 && !PageUptodate(page)) {
 			if (btrfs_file_extent_compression(leaf, item) !=
 			    BTRFS_COMPRESS_NONE) {
-				ret = uncompress_inline(path, inode, page,
-							pg_offset,
+				ret = uncompress_inline(path, page, pg_offset,
 							extent_offset, item);
 				if (ret) {
 					err = ret;
-- 
2.4.1

