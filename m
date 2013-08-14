Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36794 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759058Ab3HNCAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 22:00:39 -0400
Received: by mail-wi0-f179.google.com with SMTP id hr7so1367907wib.6
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 19:00:38 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/2] Btrfs: add missing error code to BTRFS_IOC_INO_LOOKUP handler
Date: Wed, 14 Aug 2013 03:00:20 +0100
Message-Id: <1376445621-18561-2-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1376445621-18561-1-git-send-email-fdmanana@gmail.com>
References: <1376445621-18561-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the path doesn't fit in the input buffer, return ENAMETOOLONG
instead of returning with a success code (0) and a partially
filled and right justified buffer.

Also removed useless buffer pointer check outside the while loop.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2312c0f..3f2a8c1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2015,8 +2015,10 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		len = btrfs_inode_ref_name_len(l, iref);
 		ptr -= len + 1;
 		total_len += len + 1;
-		if (ptr < name)
+		if (ptr < name) {
+			ret = -ENAMETOOLONG;
 			goto out;
+		}
 
 		*(ptr + len) = '/';
 		read_extent_buffer(l, ptr,(unsigned long)(iref + 1), len);
@@ -2029,8 +2031,6 @@ static noinline int btrfs_search_path_in_tree(struct btrfs_fs_info *info,
 		key.offset = (u64)-1;
 		dirid = key.objectid;
 	}
-	if (ptr < name)
-		goto out;
 	memmove(name, ptr, total_len);
 	name[total_len]='\0';
 	ret = 0;
-- 
1.7.9.5

