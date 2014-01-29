Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35249 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaA2VFh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 16:05:37 -0500
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s0TL2l8H007278
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 13:05:36 -0800
Received: from mail.thefacebook.com (prn1-cmdf-dc01-fw1-nat.corp.tfbnw.net [173.252.71.129] (may be forged))
	by mx0b-00082601.pphosted.com with ESMTP id 1hq5t08t69-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 13:05:36 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: disable snapshot aware defrag for now
Date: Wed, 29 Jan 2014 16:05:30 -0500
Message-ID: <1391029530-17686-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's just broken and it's taking a lot of effort to fix it, so for now just
disable it so people can defrag in peace.  Thanks,

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3b65987..8c0bc31 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2628,7 +2628,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			EXTENT_DEFRAG, 1, cached_state);
 	if (ret) {
 		u64 last_snapshot = btrfs_root_last_snapshot(&root->root_item);
-		if (last_snapshot >= BTRFS_I(inode)->generation)
+		if (0 && last_snapshot >= BTRFS_I(inode)->generation)
 			/* the inode is shared */
 			new = record_old_file_extents(inode, ordered_extent);
 
-- 
1.8.3.1

