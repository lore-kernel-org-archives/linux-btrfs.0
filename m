Return-Path: <SRS0=7Enz=7Q=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87B7CC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 10:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67AA8206A2
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Jun 2020 10:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a4av9FXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgFCKKk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 06:10:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726935AbgFCKKe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2020 06:10:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053A6wtI156632
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2020 10:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BNMpI8zAdG7p/Ux1BsXW8txaixkLmmqCmrjNTkdGQ9k=;
 b=a4av9FXuf0b/zn2V3dSTa8gXL1p7I1OLCyzqf+bvbn7TMBogCjzHbamYT3Ho9xC9H591
 gNCN5Kq8eoKTdjuMfIlA8nSqKLAIMm2cep7JUmMEVTTXvfnljYkTGdLRStd1CDVrMy5Y
 Fp1sxjoYM/VAtQs/Jb/FlKy6JOvuE3tSL5y9jXmZlfhdgb7xty/IK6syL3WjEfbpNAOb
 eSRB6bhhYAgOZlqMDLGe+Nf55TIWllTUF1QcPifwKhA6DvC6Pk1u+IqCNOw21hO6GYjC
 DsV4Prs7oQKOz1I8aq6IEfD4YpSXgVfvUInrUjxyyECm3uWi7mm/JIAe8UAj9nJ8nXWh 0g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31bfem8dad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2020 10:10:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 053A80E2034791
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2020 10:10:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25rpnmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jun 2020 10:10:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 053AAWYc003600
        for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2020 10:10:32 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jun 2020 03:10:31 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: fix btrfs_return_cluster_to_free_space() return
Date:   Wed,  3 Jun 2020 18:10:18 +0800
Message-Id: <20200603101020.143372-2-anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200603101020.143372-1-anand.jain@oracle.com>
References: <20200603101020.143372-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006030079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 mlxlogscore=999 priorityscore=1501 bulkscore=0 phishscore=0 clxscore=1015
 impostorscore=0 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006030079
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

__btrfs_return_cluster_to_free_space() returns only 0. And all its parent
functions don't need the return value either so make this a void function.

Further, as none of the callers of btrfs_return_cluster_to_free_space() is
actually using the return from this function, make this function also
return void.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/free-space-cache.c | 13 +++++--------
 fs/btrfs/free-space-cache.h |  2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 55955bd424d7..1bf08c855edb 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2703,7 +2703,7 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group)
  * pointed to by the cluster, someone else raced in and freed the
  * cluster already.  In that case, we just return without changing anything
  */
-static int
+static void
 __btrfs_return_cluster_to_free_space(
 			     struct btrfs_block_group *block_group,
 			     struct btrfs_free_cluster *cluster)
@@ -2756,7 +2756,6 @@ __btrfs_return_cluster_to_free_space(
 out:
 	spin_unlock(&cluster->lock);
 	btrfs_put_block_group(block_group);
-	return 0;
 }
 
 static void __btrfs_remove_free_space_cache_locked(
@@ -2907,12 +2906,11 @@ u64 btrfs_find_space_for_alloc(struct btrfs_block_group *block_group,
  * Otherwise, it'll get a reference on the block group pointed to by the
  * cluster and remove the cluster from it.
  */
-int btrfs_return_cluster_to_free_space(
+void btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group *block_group,
 			       struct btrfs_free_cluster *cluster)
 {
 	struct btrfs_free_space_ctl *ctl;
-	int ret;
 
 	/* first, get a safe pointer to the block group */
 	spin_lock(&cluster->lock);
@@ -2920,12 +2918,12 @@ int btrfs_return_cluster_to_free_space(
 		block_group = cluster->block_group;
 		if (!block_group) {
 			spin_unlock(&cluster->lock);
-			return 0;
+			return;
 		}
 	} else if (cluster->block_group != block_group) {
 		/* someone else has already freed it don't redo their work */
 		spin_unlock(&cluster->lock);
-		return 0;
+		return;
 	}
 	atomic_inc(&block_group->count);
 	spin_unlock(&cluster->lock);
@@ -2934,14 +2932,13 @@ int btrfs_return_cluster_to_free_space(
 
 	/* now return any extents the cluster had on it */
 	spin_lock(&ctl->tree_lock);
-	ret = __btrfs_return_cluster_to_free_space(block_group, cluster);
+	__btrfs_return_cluster_to_free_space(block_group, cluster);
 	spin_unlock(&ctl->tree_lock);
 
 	btrfs_discard_queue_work(&block_group->fs_info->discard_ctl, block_group);
 
 	/* finally drop our ref */
 	btrfs_put_block_group(block_group);
-	return ret;
 }
 
 static u64 btrfs_alloc_from_bitmap(struct btrfs_block_group *block_group,
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index 2e0a8077aa74..e3d5e0ad8f8e 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -136,7 +136,7 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster);
 u64 btrfs_alloc_from_cluster(struct btrfs_block_group *block_group,
 			     struct btrfs_free_cluster *cluster, u64 bytes,
 			     u64 min_start, u64 *max_extent_size);
-int btrfs_return_cluster_to_free_space(
+void btrfs_return_cluster_to_free_space(
 			       struct btrfs_block_group *block_group,
 			       struct btrfs_free_cluster *cluster);
 int btrfs_trim_block_group(struct btrfs_block_group *block_group,
-- 
2.25.1

