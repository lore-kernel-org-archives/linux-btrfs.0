Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12912 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbaFEUIt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 16:08:49 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s55K5XQq013590
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Jun 2014 13:08:49 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1madf22tbp-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 13:08:49 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't check nodes for extent items
Date: Thu, 5 Jun 2014 16:08:45 -0400
Message-ID: <1401998925-6179-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The backref code was looking at nodes as well as leaves when we tried to
populate extent item entries.  This is not good, and although we go away with it
for the most part because we'd skip where disk_bytenr != random_memory,
sometimes random_memory would match and suddenly boom.  This fixes that problem.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/backref.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f09aa18..84d0912 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -988,11 +988,12 @@ again:
 				goto out;
 		}
 		if (ref->count && ref->parent) {
-			if (extent_item_pos && !ref->inode_list) {
+			if (extent_item_pos && !ref->inode_list &&
+			    ref->level == 0) {
 				u32 bsz;
 				struct extent_buffer *eb;
 				bsz = btrfs_level_size(fs_info->extent_root,
-							info_level);
+							ref->level);
 				eb = read_tree_block(fs_info->extent_root,
 							   ref->parent, bsz, 0);
 				if (!eb || !extent_buffer_uptodate(eb)) {
-- 
1.8.3.1

