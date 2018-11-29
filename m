Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38232C43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB592081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 09:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xXOdFIrs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEB592081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbeK2UaO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 15:30:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50390 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeK2UaN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 15:30:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAT9OPTX180758
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ltmVZJfeqrhQSVtXWMZF444AER0C629qtUiDSeulXLc=;
 b=xXOdFIrsXfJwl5m7j328kjyDEuSFArl+j/X/NUN6E8VqLzF+apqh5bxL9vFxLrQVkxx+
 UlrEZ/ZTjyodKO9ChA675nzHOcV4G7xroG0a8I5UBrTwxOLzwRJXNgsVLZlCXsrluy/6
 ggfhP4xxYOLt3JYYO/97xPAybPxnb0oeAQw87GYLFPM1j6uyed44u1GwfiARvz4qWsm/
 C5NR3RZS2HNjNLazGaPxUoNVT5yGi60ENDTkCnQWYA0dQthg0YrbERV4GV4fup1DVX9t
 BmCp1M7ylP14YDLMvKFFxsUYaec3tshjQdh1HRPP9/yq96j1/mvX3o9MWdz8L2x5yTuO BA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nxxkqq0bs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:29 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAT9PMVF007722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:23 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAT9PMEK026325
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 09:25:22 GMT
Received: from tpasj.sg.oracle.com (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 01:25:22 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: scrub: maintain the unlock order in scrub thread
Date:   Thu, 29 Nov 2018 17:25:11 +0800
Message-Id: <1543483513-16724-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
References: <1543483513-16724-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9091 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=876
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811290082
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The device_list_mutex and scrub_lock creates a nested locks in
btrfs_scrub_dev().

During lock the order is device_list_mutex and then scrub_lock, and during
unlock, the order is device_list_mutex and then scrub_lock.
Fix this to the lock order of scrub_lock and then device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: change the order of lock acquire first scrub_lock and then
	device_list_mutex, which matches with the order of unlock.
	The extra line which are now in the scrub_lock are ok to be
	under the scrub_lock.
 fs/btrfs/scrub.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 902819d3cf41..a9d6fc3b01d4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3813,28 +3813,29 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EINVAL;
 	}
 
-
+	mutex_lock(&fs_info->scrub_lock);
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		return -ENODEV;
 	}
 
 	if (!is_dev_replace && !readonly &&
 	    !test_bit(BTRFS_DEV_STATE_WRITEABLE, &dev->dev_state)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
 				rcu_str_deref(dev->name));
 		return -EROFS;
 	}
 
-	mutex_lock(&fs_info->scrub_lock);
 	if (!test_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &dev->dev_state) ||
 	    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
-		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		return -EIO;
 	}
 
@@ -3843,23 +3844,23 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	    (!is_dev_replace &&
 	     btrfs_dev_replace_is_ongoing(&fs_info->dev_replace))) {
 		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
-		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		return -EINPROGRESS;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
 	ret = scrub_workers_get(fs_info, is_dev_replace);
 	if (ret) {
-		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		return ret;
 	}
 
 	sctx = scrub_setup_ctx(dev, is_dev_replace);
 	if (IS_ERR(sctx)) {
-		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+		mutex_unlock(&fs_info->scrub_lock);
 		scrub_workers_put(fs_info);
 		return PTR_ERR(sctx);
 	}
-- 
1.8.3.1
