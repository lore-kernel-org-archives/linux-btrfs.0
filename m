Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752759AbeDLC1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Q1U8041828
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:46 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2h6pn4srre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:46 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rjua004157
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:45 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w3C2RjOv024798
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:45 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 09/15] btrfs: uuid_mutex in read_chunk_tree, add a comment
Date: Thu, 12 Apr 2018 10:29:32 +0800
Message-Id: <20180412022938.8257-10-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

read_chunk_tree() calls read_one_dev(), but for seed device we have
to search the fs_uuids list, so we need the uuid_mutex. Add a comment
comment, so that we can improve this part.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 29799d39554a..8996a1df9a21 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6889,6 +6889,10 @@ int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info)
 	if (!path)
 		return -ENOMEM;
 
+	/*
+	 * uuid_mutex is needed only if we are mounting a sprout FS
+	 * otherwise we don't need it.
+	 */
 	mutex_lock(&uuid_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
 
-- 
2.7.0

