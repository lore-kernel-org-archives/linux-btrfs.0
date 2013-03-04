Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab3CDQ1R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:17 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRGa1019133
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:16 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GRFuE011186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:16 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRFdY020919
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:15 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: check for NULL pointer in updating reloc roots
Date: Tue,  5 Mar 2013 00:25:36 +0800
Message-Id: <1362414341-17306-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
References: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a check for NULL pointer to avoid invalid reference.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 300e09a..d9be73b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1269,6 +1269,8 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 	}
 	spin_unlock(&rc->reloc_root_tree.lock);
 
+	if (!node)
+		return 0;
 	BUG_ON((struct btrfs_root *)node->data != root);
 
 	if (!del) {
-- 
1.7.7

