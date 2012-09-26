Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45336 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab2IZPDN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 11:03:13 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id qroezBoPw9X9YDBM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 09:03:12 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't lookup csums for prealloc extents
Date: Wed, 26 Sep 2012 11:08:43 -0400
Message-ID: <1348672123-3232-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The tree logging stuff was looking up csums to copy over for prealloc
extents which is just work we don't need to be doing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/tree-log.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 09d7f15..806a8ff 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3023,8 +3023,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 				continue;
 
 			found_type = btrfs_file_extent_type(src, extent);
-			if (found_type == BTRFS_FILE_EXTENT_REG ||
-			    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+			if (found_type == BTRFS_FILE_EXTENT_REG) {
 				u64 ds, dl, cs, cl;
 				ds = btrfs_file_extent_disk_bytenr(src,
 								extent);
-- 
1.7.7.6

