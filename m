Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3EZNv2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 09:51:28 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4QDpQaM017098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:27 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpP77012250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:26 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4QDpPkR006733
	for <linux-btrfs@vger.kernel.org>; Sun, 26 May 2013 13:51:25 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: kill replicate code in replay_one_buffer
Date: Sun, 26 May 2013 21:50:29 +0800
Message-Id: <1369576231-17836-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
References: <1369576231-17836-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

EXTREF is treated same as REF, so we can make the code tidy.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c276ac9..3f30053 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2016,13 +2016,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 					     eb, i, &key);
 			if (ret)
 				break;
-		} else if (key.type == BTRFS_INODE_REF_KEY) {
-			ret = add_inode_ref(wc->trans, root, log, path,
-					    eb, i, &key);
-			if (ret && ret != -ENOENT)
-				break;
-			ret = 0;
-		} else if (key.type == BTRFS_INODE_EXTREF_KEY) {
+		} else if (key.type == BTRFS_INODE_REF_KEY ||
+			   key.type == BTRFS_INODE_EXTREF_KEY) {
 			ret = add_inode_ref(wc->trans, root, log, path,
 					    eb, i, &key);
 			if (ret && ret != -ENOENT)
-- 
1.7.7

