Return-Path: <SRS0=FZr9=CN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF34C433E2
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Sep 2020 09:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE5D206B8
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Sep 2020 09:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UY8XXGrt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgIDJ0b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 05:26:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729751AbgIDJ0b (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Sep 2020 05:26:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0849OI2W183042
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2020 09:26:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=zlJVWBlGeRJenRhj/w/JM3Ax8N3qVibwFhDK+cGgDa8=;
 b=UY8XXGrtjMdTnlYv3ScGRF4N38apRYFmM0WsoFnF0oECMq+dlVl7cC4mKrcfu2z366xu
 KgQQZqey7y6GPrOPj7ueW/JV6ulNeSoEcFHYoYLNEUumfm9A6VqQEMjCGlwwjoRWOKpT
 YUVVtE1SaqCmWsW790jQlqWb0Ri/jp0iswaOsveNnifsEVqKIui78R8keufbd51/zDgq
 9WD1UwlxVBc9P1e2hD4tf72txAOFNDD2A9Gag2bFvCD2UZLYA6gW5GjaQovHlZ6VqzGK
 fnRFC5KvaXBREzcmr2TfTt/IgWskOn5nW4bwF38559rbynPZIxg5KIThXWCSTz3NMsEk qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 337eymng8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2020 09:26:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08499nvf139986
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2020 09:24:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33b7v289mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Sep 2020 09:24:28 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0849ORtQ031849
        for <linux-btrfs@vger.kernel.org>; Fri, 4 Sep 2020 09:24:28 GMT
Received: from localhost.localdomain (/39.109.231.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Sep 2020 02:24:27 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 07/15] btrfs: handle fail path for btrfs_sysfs_add_fs_devices
Date:   Fri,  4 Sep 2020 17:24:20 +0800
Message-Id: <1bc0c094ab839218f3d6f02727f6536dbb7713b0.1599201200.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <32779bc42ae40eea707cc585624724ac91cd967e.1599091832.git.anand.jain@oracle.com>
References: <32779bc42ae40eea707cc585624724ac91cd967e.1599091832.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009040086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9733 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040087
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_sysfs_add_fs_devices() is called by btrfs_sysfs_add_mounted().
btrfs_sysfs_add_mounted() assumes that btrfs_sysfs_add_fs_devices() will
either add sysfs entries for all the devices or none. So this patch keeps up
to its caller expecatation and cleans up the created sysfs entries if it
has to fail at some device in the list.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v3: fix the goto fail
 fs/btrfs/sysfs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 56eca63360ad..be5b773225e8 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1182,10 +1182,12 @@ void btrfs_sysfs_remove_device(struct btrfs_device *device)
 		sysfs_remove_link(devices_kobj, disk_kobj->name);
 	}
 
-	kobject_del(&device->devid_kobj);
-	kobject_put(&device->devid_kobj);
+	if (device->devid_kobj.state_initialized) {
+		kobject_del(&device->devid_kobj);
+		kobject_put(&device->devid_kobj);
+		wait_for_completion(&device->kobj_unregister);
+	}
 
-	wait_for_completion(&device->kobj_unregister);
 }
 
 static ssize_t btrfs_devinfo_in_fs_metadata_show(struct kobject *kobj,
@@ -1325,18 +1327,22 @@ int btrfs_sysfs_add_fs_devices(struct btrfs_fs_devices *fs_devices)
 	list_for_each_entry(device, &fs_devices->devices, dev_list) {
 		ret = btrfs_sysfs_add_device(device);
 		if (ret)
-			return ret;
+			goto fail;
 	}
 
 	list_for_each_entry(seed, &fs_devices->seed_list, seed_list) {
 		list_for_each_entry(device, &seed->devices, dev_list) {
 			ret = btrfs_sysfs_add_device(device);
 			if (ret)
-				return ret;
+				goto fail;
 		}
 	}
 
 	return 0;
+
+fail:
+	btrfs_sysfs_remove_fs_devices(fs_devices);
+	return ret;
 }
 
 void btrfs_kobject_uevent(struct block_device *bdev, enum kobject_action action)
-- 
2.25.1

