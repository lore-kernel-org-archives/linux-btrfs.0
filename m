Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAA6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B49F20857
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 10:00:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="If1sYzLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfCSKAU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:00:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfCSKAT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 06:00:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2J9wwiQ186164
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=63Itet+jxuSBdBetsVOTDkgoIEq4oAqphov+mw44S0I=;
 b=If1sYzLtTMglQx+PIsIq/0JfMh81gEi5DcSX3TCmyWY5bkltOeBEG/2aG182ns4Hg9iW
 ZsFj6DS4LsQNJIIZ959nqIALrdXUTDLbPK8sxZkkCqVhoAUBYeFDUqqoOybaPYGH3rdC
 UmRiKyrOKvJZ4WDm3XSlEiGm6Rvn7dvTzM75/IlBOEwQZ0hA4IWqwDhUz8dkK2MK6FxE
 mlsiyxekSr0wd+cUTgCO92IjcAiEKgp1cRYFBHHFWQpUNxcqbIlSOT68AjuKgB1nzFka
 PH0xL/QG8jy86fTSwxGuYmlYTLsxn7BKj6ckR4xAzokTup/qYvYzhDPlNavoE2Uamqe3 iw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2r8rjukmsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2JA0Hwg028513
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:17 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2JA0HC6018949
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Mar 2019 10:00:17 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 03:00:16 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 5/5] btrfs: add readmirror devid mount option
Date:   Tue, 19 Mar 2019 18:00:24 +0800
Message-Id: <1552989624-29577-6-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
References: <1552989624-29577-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9199 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch provides the readmirror=devid<n> feature configurable through
the mount option which is transient and can be applied during readonly
mount as well.

For example:
mount -o readmirror=devid<n>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c   | 19 +++++++++++++++++++
 fs/btrfs/volumes.c |  2 ++
 fs/btrfs/volumes.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9d25a01bcecb..5aa1a4d14cd7 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -857,6 +857,25 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 				info->fs_devices->readmirror_policy =
 							BTRFS_READMIRROR_PID;
 				break;
+			} else if (strncmp(args[0].from, "devid", 5) == 0) {
+				u64 devid;
+				struct btrfs_device *device;
+
+				if (kstrtoull(args[0].from + 5, 10, &devid)) {
+					ret = -EINVAL;
+					goto out;
+				}
+				info->fs_devices->readmirror_policy =
+							BTRFS_READMIRROR_DEVID;
+				device = btrfs_find_device(info->fs_devices,
+							   devid, NULL, NULL,
+							   false);
+				if (!device) {
+					ret = -ENODEV;
+					goto out;
+				}
+		                device->type_in_ram = BTRFS_DEVICE_TYPE_READ_OPTIMIZED;
+				break;
 			}
 			ret = -EINVAL;
 			goto out;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d3b7427d6d96..637617087c83 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5569,6 +5569,8 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 		if (map->type & BTRFS_BLOCK_GROUP_RAID1) {
 			for (i = first; i < first + num_stripes; i++) {
 				if (map->stripes[i].dev->type ==
+				    BTRFS_DEVICE_TYPE_READ_OPTIMIZED ||
+				    map->stripes[i].dev->type_in_ram ==
 				    BTRFS_DEVICE_TYPE_READ_OPTIMIZED) {
 					preferred_mirror = i;
 					found = true;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 9c2e64548a11..3e534bcaf43e 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -91,6 +91,7 @@ struct btrfs_device {
 	u32 io_width;
 	/* type and info about this device */
 	u64 type;
+	u64 type_in_ram;
 
 	/* minimal io size for this device */
 	u32 sector_size;
-- 
1.8.3.1

