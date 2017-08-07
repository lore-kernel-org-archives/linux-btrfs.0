Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31847 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77MumKa019804
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77Mumml002222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v77MumXI000371
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/7] Btrfs: remove BUG() in add_data_reference
Date: Mon,  7 Aug 2017 15:55:29 -0600
Message-Id: <20170807215531.12423-6-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that we have a helper to report invalid value of extent inline ref
type, we need to quit gracefully instead of throwing out a kernel panic.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index f0bef3c..4806e78 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3774,7 +3774,10 @@ int add_data_references(struct reloc_control *rc,
 			ret = find_data_references(rc, extent_key,
 						   eb, dref, blocks);
 		} else {
-			BUG();
+			ret = -EINVAL;
+			WARN(1,
+		     "extent %llu slot %d has an invalid inline ref type\n",
+			     eb->start, path->slots[0]);
 		}
 		if (ret) {
 			err = ret;
-- 
2.9.4

