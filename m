Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2F7C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCBEC208A3
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iYYhfdpt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCBEC208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbeKLALL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:11:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbeKLALL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:11:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wABEJ1jO007513
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=KeZNB2gdygjLyB1fiWvOhyCavtEK7YdwhKoO2sZCMj8=;
 b=iYYhfdptdlwKshyZDdY5FqMqxb7mnrI1B0nLev51fFXihYd4rIVyIRu3plFqH1z68fnX
 pIi6NgzZHcCdbBocIrPhUDuzrgydGxan/9Xfl1OvGeotLHuBE8eKi1HQYyCVTtLkPgVw
 sF0Mul2Fo3GMhoY0U8mi7T14p/INUW0eXdf9yzBFcUCJ3+WvJ9kxq6nfCXpMPgFJ5mLT
 YOG3qDK80MEUvPcZnekZzWhJ2NSUZ7Pc5S5sM5QZ99DESv1l/P/XJQe0EwL8QJKghxHZ
 4BGFt9gc9D3MG01xcpFkX0KzgZE1ErXJ5iHTWv0fY4bIOgtiWA+fV3NaNtftIMFqAxJk 8g== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2nnwg121nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:28 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMRLd031085
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:27 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wABEMRrC010321
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Nov 2018 14:22:27 GMT
Received: from tpasj.localdomain (/183.90.37.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 11 Nov 2018 06:22:26 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: replace go back to suspended if target missing
Date:   Sun, 11 Nov 2018 22:22:17 +0800
Message-Id: <1541946144-8174-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9073 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=733
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811110137
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

At the time of forced unmount we place the running replace to
BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state, so when the system comes
back and suppose the target device is missing, then let the replace
state continue to be in BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED state
instead of BTRFS_IOCTL_DEV_REPLACE_STATE_STARTED as there isn't any
matching scrub running as part of replace.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 59991165e126..3c29b0976087 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -884,6 +884,8 @@ int btrfs_resume_dev_replace_async(struct btrfs_fs_info *fs_info)
 			   "cannot continue dev_replace, tgtdev is missing");
 		btrfs_info(fs_info,
 			   "you may cancel the operation after 'mount -o degraded'");
+		dev_replace->replace_state =
+					BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED;
 		btrfs_dev_replace_write_unlock(dev_replace);
 		return 0;
 	}
-- 
1.8.3.1

