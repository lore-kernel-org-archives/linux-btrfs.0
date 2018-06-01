Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:52538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753053AbeFAPik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2018 11:38:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w51FZf3j172852
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:38:39 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2janje5cdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jun 2018 15:38:39 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w51Fccjr008117
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:38:38 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w51Fcbmm009257
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2018 15:38:37 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs: prefix balance for recover and resume
Date: Fri,  1 Jun 2018 23:41:15 +0800
Message-Id: <20180601154115.19850-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
Hi David,
 Can you please fixup this with
   btrfs: balance: prefix kernel logs
 there were two more places where we could make balance logging
 consistent but it was missed before. Thanks.
 
 fs/btrfs/disk-io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e93f3e3a76c9..002d20b3ed61 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3078,7 +3078,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_recover_balance(fs_info);
 	if (ret) {
-		btrfs_err(fs_info, "failed to recover balance: %d", ret);
+		btrfs_err(fs_info, "balance: failed to recover: %d", ret);
 		goto fail_block_groups;
 	}
 
@@ -3263,7 +3263,7 @@ int open_ctree(struct super_block *sb,
 
 	ret = btrfs_resume_balance_async(fs_info);
 	if (ret) {
-		btrfs_warn(fs_info, "failed to resume balance: %d", ret);
+		btrfs_warn(fs_info, "balance: failed to resume: %d", ret);
 		close_ctree(fs_info);
 		return ret;
 	}
-- 
2.7.0

