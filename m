Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30306 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750959AbdFXF32 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Jun 2017 01:29:28 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5O5TR3I010087
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Jun 2017 05:29:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v5O5TRUF013031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Jun 2017 05:29:27 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <boliu@localhost.localdomain>
Subject: [PATCH] Btrfs-progs: fix infinite loop in find_free_extent
Date: Fri, 23 Jun 2017 22:28:31 -0600
Message-Id: <20170624042831.8068-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <boliu@localhost.localdomain>

%search_start is calculated in a wrong way, and if %ins is a cross-stripe
 one, it'll search the same block group forever.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 extent-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index b12ee29..5e09274 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2614,8 +2614,9 @@ check_failed:
 				goto no_bg_cache;
 			bg_offset = ins->objectid - bg_cache->key.objectid;
 
-			search_start = round_up(bg_offset + num_bytes,
-						BTRFS_STRIPE_LEN) + bg_offset;
+			search_start = round_up(
+				bg_offset + num_bytes, BTRFS_STRIPE_LEN) +
+				bg_cache->key.object;
 			goto new_group;
 		}
 no_bg_cache:
-- 
2.9.4

