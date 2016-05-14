Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19200 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbcENAF2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 20:05:28 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u4E05R8G028145
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05QXo028828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:27 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u4E05O5X022447
	for <linux-btrfs@vger.kernel.org>; Sat, 14 May 2016 00:05:25 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] Btrfs: fix memory leak due to invalid btree height
Date: Fri, 13 May 2016 17:07:02 -0700
Message-Id: <1463184422-13584-7-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks to fuzz testing, we can have invalid btree root node height.
Btrfs limits btree height to 7 and if the given height is 9, then btrfs
will have problems in both releasing root node's lock and freeing the node.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index ec7928a..3fccbcc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2756,6 +2756,13 @@ again:
 			}
 		}
 	}
+	if (level > BTRFS_MAX_LEVEL - 1 || level < 0) {
+		WARN_ONCE(1, KERN_WARNING "Invalid btree height %d\n", level);
+		if (!p->skip_locking)
+			btrfs_tree_unlock_rw(b, root_lock);
+		free_extent_buffer(b);
+		return -EINVAL;
+	}
 	p->nodes[level] = b;
 	if (!p->skip_locking)
 		p->locks[level] = root_lock;
-- 
2.5.5

