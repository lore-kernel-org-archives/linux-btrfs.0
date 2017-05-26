Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45827 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946505AbdEZB1N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:13 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RC4h003041
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4Q1RCeP003286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1RCcK013228
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:12 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs: remove BUG() in btrfs_extent_inline_ref_size
Date: Thu, 25 May 2017 18:26:28 -0600
Message-Id: <20170526002631.8546-4-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
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
index 206ae8c..54bbac3 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1776,7 +1776,6 @@ static inline u32 btrfs_extent_inline_ref_size(int type)
 	if (type == BTRFS_EXTENT_DATA_REF_KEY)
 		return sizeof(struct btrfs_extent_data_ref) +
 		       offsetof(struct btrfs_extent_inline_ref, offset);
-	BUG();
 	return 0;
 }
 
-- 
2.9.4

