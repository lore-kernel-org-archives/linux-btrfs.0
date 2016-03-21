Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40089 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbcCUV5n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 17:57:43 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2LLvgBO008988
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 21:57:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u2LLvfGL027103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 21:57:42 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u2LLvf5g021495
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 21:57:41 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] Btrfs: fix invalid reference in replace_path
Date: Mon, 21 Mar 2016 14:59:53 -0700
Message-Id: <1458597593-29699-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Carpenter's static checker has found this error, it's introduced by
commit 64c043de466d
("Btrfs: fix up read_tree_block to return proper error")

It's really supposed to 'break' the loop on error like others.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com> 
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 2bd0011..5c806f0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1850,6 +1850,7 @@ again:
 			eb = read_tree_block(dest, old_bytenr, old_ptr_gen);
 			if (IS_ERR(eb)) {
 				ret = PTR_ERR(eb);
+				break;
 			} else if (!extent_buffer_uptodate(eb)) {
 				ret = -EIO;
 				free_extent_buffer(eb);
-- 
2.5.0

