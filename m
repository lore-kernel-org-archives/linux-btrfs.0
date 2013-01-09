Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3AIDbe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 22:31:34 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id r093VX9I032441
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 03:31:34 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r093VXxV014652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Jan 2013 03:31:33 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r093VXXQ006479
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Jan 2013 21:31:33 -0600
Message-ID: <50ECE491.9010809@oracle.com>
Date: Wed, 09 Jan 2013 11:31:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove meanlingless owner as well as it related stuff
 in btrfs_new_inode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove the owner variable as well as it related stuff.

owner is meaningless in btrfs_new_inode() context, clean it out.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/btrfs/inode.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..f56eae1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4673,7 +4673,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	u32 sizes[2];
 	unsigned long ptr;
 	int ret;
-	int owner;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4719,11 +4718,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	 */
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 
-	if (S_ISDIR(mode))
-		owner = 0;
-	else
-		owner = 1;
-
 	key[0].objectid = objectid;
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
 	key[0].offset = 0;
-- 
1.7.9.5
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
