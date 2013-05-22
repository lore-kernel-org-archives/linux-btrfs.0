Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46914 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3EVMHg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 08:07:36 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4MC7YkW014788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:34 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4MC7YwD026218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:35 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4MC7YCI017944
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 12:07:34 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs: check if leaf's parent exists before pushing items around
Date: Wed, 22 May 2013 20:07:06 +0800
Message-Id: <1369224426-4538-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

During splitting a leaf, pushing items around to hopefully get some space only
works when we have a parent, ie. we have at least one sibling leaf.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c07b6ea..f4654f8 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3986,7 +3986,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		return -EOVERFLOW;
 
 	/* first try to make some room by pushing left and right */
-	if (data_size) {
+	if (data_size && path->nodes[1]) {
 		wret = push_leaf_right(trans, root, path, data_size,
 				       data_size, 0, 0);
 		if (wret < 0)
-- 
1.7.7.6

