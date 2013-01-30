Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58486 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab3A3U24 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 15:28:56 -0500
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id i1VqxVzwqktjLGIE (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 13:28:55 -0700 (MST)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix possible stale data exposure
Date: Wed, 30 Jan 2013 15:35:44 -0500
Message-ID: <1359578144-2329-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We specifically do not update the disk i_size if there are ordered extents
outstanding for any area between the current disk_i_size and our ordered
extent so that we do not expose stale data.  The problem is the check we
have only checks if the ordered extent starts at or after the current
disk_i_size, which doesn't take into account an ordered extent that starts
before the current disk_i_size and ends past the disk_i_size.  Fix this by
checking if the extent ends past the disk_i_size.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ordered-data.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f8b13e8..cd8f6e9 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -936,7 +936,7 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 			break;
 		if (test->file_offset >= i_size)
 			break;
-		if (test->file_offset >= disk_i_size) {
+		if (entry_end(test) > disk_i_size) {
 			/*
 			 * we don't update disk_i_size now, so record this
 			 * undealt i_size. Or we will not know the real
-- 
1.7.7.6

