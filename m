Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41280 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbcAOUwf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 15:52:35 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u0FKqXGF009131
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 20:52:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u0FKqXJQ009967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 20:52:33 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by userv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u0FKqXMv028395
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 20:52:33 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: copy the certain type of item if min_type equals to max_type
Date: Fri, 15 Jan 2016 12:52:28 -0800
Message-Id: <1452891148-7738-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some tools in btrfs-progs utilize ioctl 'BTRFS_IOC_TREE_SEARCH' and
ioctl 'BTRFS_IOC_TREE_SEARCH_V2' to look up metadata btree for what
they want, and several tools in fact only look for one certain type,
where they set a certain value for both 'sk->min_type' and 'sk->max_type'.

For example,
if we want to get the information of block groups, the current btrfs
searches extent_tree and returns not only block groups's items, but also
EXTENT_ITEM's items which could cost a large amount of user's buffer,
and tools then needs to read the buffer and spends several loops to
pick up what they want.

This lets the above two ioctl only return the certain type of items
that tools wants.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index da94138..f795423 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1911,6 +1911,10 @@ static noinline int key_in_sk(struct btrfs_key *key,
 	struct btrfs_key test;
 	int ret;
 
+	/* All we want is this type of key. */
+	if (sk->min_type == sk->max_type && key->type != sk->min_type)
+		return 0;
+
 	test.objectid = sk->min_objectid;
 	test.type = sk->min_type;
 	test.offset = sk->min_offset;
-- 
2.5.0

