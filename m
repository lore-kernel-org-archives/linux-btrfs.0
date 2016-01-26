Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39218 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966116AbcAZOfq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 09:35:46 -0500
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0QEY12M007713
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 06:35:45 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 20p57v93by-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 06:35:45 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH] Btrfs: check reserved when deciding to background flush
Date: Tue, 26 Jan 2016 09:35:38 -0500
Message-ID: <1453818938-14795-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We will sometimes start background flushing the various enospc related things
(delayed nodes, delalloc, etc) if we are getting close to reserving all of our
available space.  We don't want to do this however when we are actually using
this space as it causes unneeded thrashing.  We currently try to do this by
checking bytes_used >= thresh, but bytes_used is only part of the equation, we
need to use bytes_reserved as well as this represents space that is very likely
to become bytes_used in the future.

My tracing tool will keep count of the number of times we kick off the async
flusher, the following are counts for the entire run of generic/027

		No Patch	Patch
avg: 		5385		5009
median:		5500		4916

We skewed lower than the average with my patch and higher than the average with
the patch, overall it cuts the flushing from anywhere from 5-10%, which in the
case of actual ENOSPC is quite helpful.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e9ec337..63188c0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4849,7 +4849,7 @@ static inline int need_do_async_reclaim(struct btrfs_space_info *space_info,
 	u64 thresh = div_factor_fine(space_info->total_bytes, 98);
 
 	/* If we're just plain full then async reclaim just slows us down. */
-	if (space_info->bytes_used >= thresh)
+	if ((space_info->bytes_used + space_info->bytes_reserved) >= thresh)
 		return 0;
 
 	return (used >= thresh && !btrfs_fs_closing(fs_info) &&
-- 
1.8.3.1

