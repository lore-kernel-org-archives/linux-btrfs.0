Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56257 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbaIZNCy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 09:02:54 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s8QD11n0013627
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 06:02:53 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pmgfrm80w-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 06:02:53 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: let btrfs-image actually work on a balanced fs V2
Date: Fri, 26 Sep 2014 09:02:49 -0400
Message-ID: <1411736569-20068-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use the read extent buffer infrastructure to read the super block when we are
creating a btrfs-image.  This works out fine most of the time except when the fs
has been balanced, then it fails to map the super block.  So we could fix
btrfs-image to read in the super in a special way, but thats more code.  So
instead just check in the eb reading code if we are reading the super and then
don't bother mapping the block, just read the actual offset.  This fixed some
poor guy who was trying to btrfs-image his fs that had been balanced.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: Remove the debugging stuff that was left accidentally.

 disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index 26a532e..34c0a97 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -201,7 +201,8 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 		read_len = bytes_left;
 		device = NULL;
 
-		if (!info->on_restoring) {
+		if (!info->on_restoring &&
+		    eb->start != BTRFS_SUPER_INFO_OFFSET) {
 			ret = btrfs_map_block(&info->mapping_tree, READ,
 					      eb->start + offset, &read_len, &multi,
 					      mirror, NULL);
-- 
1.9.3

