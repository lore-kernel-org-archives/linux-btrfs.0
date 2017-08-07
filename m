Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29464 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77Mumr9006226
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v77Mum1i012512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumNu009715
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/7] Btrfs: remove BUG() in btrfs_extent_inline_ref_size
Date: Mon,  7 Aug 2017 15:55:27 -0600
Message-Id: <20170807215531.12423-4-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that btrfs_get_extent_inline_ref_type() can report if type is a
valid one and all callers can gracefully deal with that, we don't need
to crash here.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 9866420..c915f33 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1799,7 +1799,6 @@ static inline u32 btrfs_extent_inline_ref_size(int type)
 	if (type == BTRFS_EXTENT_DATA_REF_KEY)
 		return sizeof(struct btrfs_extent_data_ref) +
 		       offsetof(struct btrfs_extent_inline_ref, offset);
-	BUG();
 	return 0;
 }
 
-- 
2.9.4

