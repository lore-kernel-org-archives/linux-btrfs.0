Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbcFWB3K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 21:29:10 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u5N1T8oU013105
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:29:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1T86U011030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:29:08 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u5N1T6Lb023456
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 01:29:07 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: error out if generic_bin_search get invalid arguments
Date: Wed, 22 Jun 2016 18:32:19 -0700
Message-Id: <1466645539-27296-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With btrfs-corrupt-block, one can set btree node/leaf's field, if
we assign a negative value to node/leaf, we can get various hangs,
eg. if extent_root's nritems is -2ULL, then we get stuck in
 btrfs_read_block_groups() because it has a while loop and
btrfs_search_slot() on extent_root will always return the first
 child.

This lets us know what's happening and returns a EINVAL to callers
instead of returning the first item.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index c49a500..915d224 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1770,6 +1770,14 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 	unsigned long map_len = 0;
 	int err;
 
+	if (low > high) {
+		btrfs_err(eb->fs_info,
+		 "%s: low (%d) < high (%d) eb %llu owner %llu level %d",
+			  __func__, low, high, eb->start,
+			  btrfs_header_owner(eb), btrfs_header_level(eb));
+		return -EINVAL;
+	}
+
 	while (low < high) {
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
-- 
2.5.5

