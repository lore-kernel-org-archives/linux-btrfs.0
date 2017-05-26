Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27538 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946470AbdEZB1P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:15 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RDXh010336
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4Q1RDBl003295
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RCwC007139
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] Btrfs: remove BUG() in add_data_reference
Date: Thu, 25 May 2017 18:26:30 -0600
Message-Id: <20170526002631.8546-6-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have a helper to report invalid value of extent inline ref
type, we need to quit gracefully instead of throwing out a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b043e200..8b984bd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3774,7 +3774,10 @@ int add_data_references(struct reloc_control *rc,
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
 		} else {
-			BUG();
+			ret = -EINVAL;
+			WARN(1,
+			     "extent %llu has an invalid inline ref type\n",
+			     eb->start);
 		}
 		if (ret) {
 			err = ret;
-- 
2.9.4

