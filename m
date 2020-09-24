Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5112C4727D
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 10:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790AE23977
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 10:11:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Byo26NRC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgIXKLr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 06:11:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44456 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgIXKLq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 06:11:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OA9F6M068084;
        Thu, 24 Sep 2020 10:11:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ORhq14WuuHeTPra2lslf79yVs6l3DHj5SUgCTwYDusc=;
 b=Byo26NRCCdIUxMPGvasl6c/v8XeXzNneixM4gDWILCdk70dyAzx0CVRd/tfALyDhuP0Y
 3N8ROqka52du6A/XZGVgik/EkMXsXmTFDNb5VEMcyRCTU/c6VjXwZNXdrttWJEWo5Ub7
 i3H1zwQffDV66EnsMXKXF4am9Bc3a0kgKJl8HpzbmujffPQ8w7tsXDAn9beOn5lRoM/5
 eJN11D8m0tpuTXoHYkVbccqKAox14G4vGdbiIU5kuozwh7zD3dKYetecOZ3Bs6lXUbM5
 F+lyTB+QPGaJwEj02rNsUzCy9Xu4TtbfL8RiHRMoVRcbk2sOUa5ytKj6chuHvykx5q4Q KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgnmuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 10:11:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OAAASI135099;
        Thu, 24 Sep 2020 10:11:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33r28wt2dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 10:11:41 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OABfjZ011259;
        Thu, 24 Sep 2020 10:11:41 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 03:11:40 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     nborisov@suse.com, wqu@suse.com, dsterba@suse.com,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2] btrfs: drop never met condition of disk_total_bytes == 0
Date:   Thu, 24 Sep 2020 18:11:23 +0800
Message-Id: <4fea8a706aedf7407d6af7a545126511168e15f5.1600940809.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1600940809.git.anand.jain@oracle.com>
References: <cover.1600940809.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240077
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=1 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240077
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_device::disk_total_bytes is set even for a seed device (the
comment is wrong).

The function fill_device_from_item() does the job of reading it from the
item and updating btrfs_device::disk_total_bytes. So both the missing
device and the seed devices do have their disk_total_bytes updated.

So this patch removes the check dev->disk_total_bytes == 0 in the
function verify_one_dev_extent()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7f43ed88fffc..9be40eece8ed 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7578,21 +7578,6 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	/* It's possible this device is a dummy for seed device */
-	if (dev->disk_total_bytes == 0) {
-		struct btrfs_fs_devices *devs;
-
-		devs = list_first_entry(&fs_info->fs_devices->seed_list,
-					struct btrfs_fs_devices, seed_list);
-		dev = btrfs_find_device(devs, devid, NULL, NULL, false);
-		if (!dev) {
-			btrfs_err(fs_info, "failed to find seed devid %llu",
-				  devid);
-			ret = -EUCLEAN;
-			goto out;
-		}
-	}
-
 	if (physical_offset + physical_len > dev->disk_total_bytes) {
 		btrfs_err(fs_info,
 "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
-- 
2.25.1

