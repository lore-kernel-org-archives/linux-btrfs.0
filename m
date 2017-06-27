Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26707 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752792AbdF0W0k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 18:26:40 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v5RMQcfS017230
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 22:26:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v5RMQcsc016674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 22:26:38 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v5RMQcoX003166
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 22:26:38 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: man: nodesize must be power of 2 now
Date: Tue, 27 Jun 2017 15:25:45 -0600
Message-Id: <20170627212545.25408-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updates mkfs.btrfs's man page with the new limitation that nodesize must
be a power of 2 as well.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Documentation/mkfs.btrfs.asciidoc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 46a4d2d..d53d9e2 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -76,8 +76,8 @@ Alias for --nodesize. Deprecated.
 *-n|--nodesize <size>*::
 Specify the nodesize, the tree block size in which btrfs stores metadata. The
 default value is 16KiB (16384) or the page size, whichever is bigger. Must be a
-multiple of the sectorsize, but not larger than 64KiB (65536).  Leafsize always
-equals nodesize and the options are aliases.
+multiple of the sectorsize and a power of 2, but not larger than 64KiB (65536).
+Leafsize always equals nodesize and the options are aliases.
 +
 Smaller node size increases fragmentation but lead to higher b-trees which in
 turn leads to lower locking contention. Higher node sizes give better packing
-- 
2.5.0

