Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19196 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbcENAF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:27 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05QUD028141
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05Q4x000432
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:26 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05Naw022444
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:24 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/7] Btrfs: check if extent buffer is aligned to sectorsize
Date: Fri, 13 May 2016 17:06:58 -0700
Message-Id: <1463184422-13584-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to fuzz testing, we can pass an invalid bytenr to extent buffer
via alloc_extent_buffer().  An unaligned eb can have more pages than it
should have, which ends up extent buffer's leak or some corrupted content
in extent buffer.

This adds a warning to let us quickly know what was happening.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d247fc0..e601e0f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4868,6 +4868,10 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	int uptodate = 1;
 	int ret;
 
+	WARN_ONCE(!IS_ALIGNED(start, fs_info->tree_root->sectorsize),
+		  KERN_WARNING "eb->start(%llu) is not aligned to root->sectorsize(%u)\n",
+		  start, fs_info->tree_root->sectorsize);
+
 	eb = find_extent_buffer(fs_info, start);
 	if (eb)
 		return eb;
-- 
2.5.5

