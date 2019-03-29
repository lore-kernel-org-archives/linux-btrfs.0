Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736B9C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ADF120811
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 06:03:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m8E0PIQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfC2GD2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 02:03:28 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42952 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfC2GD2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 02:03:28 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2T63RcD189328
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 06:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=Ne7taurxFf8CyN4Hi+XmJMrkTsbhscik66nfRg02ci0=;
 b=m8E0PIQcDwnEnXIzzo7rTf3yGQ08Hp0SLYrMJeA/6nUIDjMqY9jcoHbf7Ke6vtOLbtXE
 otiPU6Gzk9pDo4QkhGHhf1odf34y+jVTyJGNHA3u9UV2EQYPVBQIri6133qtPvvkK8Og
 X2tZFDzXl+2SDtlTk3VEcl822Y/J6lP+10BuRJK5faL3OkCKYlv1VqG+y3LKYuR4iC1p
 DeVq7UlYLy7jkj1g68+C7XaglSJBhcvTfc3qAucwygSFEyvRVrJqd2sPNRig2oK4ncG1
 5iBlelrjZ4HKzbr4Xv0hYdfzNjET5SUlnmutCMNepMMUzKJ/h98jSPqvWQWHxr7Z2G+r RA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2re6g1af7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 06:03:23 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2T63Ml9017222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 06:03:22 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2T63LTP016955
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Mar 2019 06:03:22 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 23:03:21 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: drop unused arg in mount_subvol
Date:   Fri, 29 Mar 2019 14:03:17 +0800
Message-Id: <1553839397-26941-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9210 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903290045
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

@device_name in mount_subvol() is not used, drop it.
Also see:
5bedc48a8f9e1d62fb693c4171ffddb990d034f6
btrfs: drop unused parameters from mount_subvol

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5aa1a4d14cd7..6e34a4494af4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1429,7 +1429,7 @@ static inline int is_subvolume_inode(struct inode *inode)
 }
 
 static struct dentry *mount_subvol(const char *subvol_name, u64 subvol_objectid,
-				   const char *device_name, struct vfsmount *mnt)
+				   struct vfsmount *mnt)
 {
 	struct dentry *root;
 	int ret;
@@ -1678,7 +1678,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	}
 
 	/* mount_subvol() will free subvol_name and mnt_root */
-	root = mount_subvol(subvol_name, subvol_objectid, device_name, mnt_root);
+	root = mount_subvol(subvol_name, subvol_objectid, mnt_root);
 
 out:
 	return root;
-- 
1.8.3.1

