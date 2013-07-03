Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18160 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3GCGkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 02:40:55 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r636esNn024793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 06:40:54 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r636erJW016887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 06:40:54 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r636eqNa022646
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 06:40:53 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix extent buffer leak after backref walking
Date: Wed,  3 Jul 2013 14:40:44 +0800
Message-Id: <1372833644-30061-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit 47fb091fb787420cd195e66f162737401cce023f(Btrfs: fix unlock after free on rewinded tree blocks)
takes an extra increment on the reference of allocated dummy extent buffer, so now we
cannot free this dummy one, and end up with extent buffer leak.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 02fae7f..3d790b4 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1268,12 +1268,12 @@ tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 		BUG_ON(!eb_rewin);
 	}
 
-	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_unlock(eb);
 	free_extent_buffer(eb);
 
 	extent_buffer_get(eb_rewin);
 	btrfs_tree_read_lock(eb_rewin);
+
 	__tree_mod_log_rewind(eb_rewin, time_seq, tm);
 	WARN_ON(btrfs_header_nritems(eb_rewin) >
 		BTRFS_NODEPTRS_PER_BLOCK(fs_info->tree_root));
-- 
1.7.7

