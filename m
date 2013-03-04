Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20912 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3CDQ1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:23 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRMIH027874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:23 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRLpl004625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:22 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRL08019228
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:21 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs: do not BUG_ON in prepare_to_reloc
Date: Tue,  5 Mar 2013 00:25:39 +0800
Message-Id: <1362414341-17306-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can bail out from here gracefully instead of a cold BUG_ON.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8cae3d7..c45c833 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3731,7 +3731,15 @@ int prepare_to_relocate(struct reloc_control *rc)
 	set_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root);
-	BUG_ON(IS_ERR(trans));
+	if (IS_ERR(trans)) {
+		unset_reloc_control(rc);
+		/*
+		 * extent tree is not a ref_cow tree and has no reloc_root to
+		 * cleanup.  And callers are responsible to free the above
+		 * block rsv.
+		 */
+		return PTR_ERR(trans);
+	}
 	btrfs_commit_transaction(trans, rc->extent_root);
 	return 0;
 }
-- 
1.7.7

