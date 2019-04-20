Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F232C282E3
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D13E32183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r4A56liD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfDTLtU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbfDTLtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnAxu057555
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Gom96yC4GG/uaSuw0KEX6LSdHQ+BVlJjH/HRDm78keM=;
 b=r4A56liDVKvcXNkbiejPLVWUBGS0LKBt+hmP9pyTrDQBPbuWP1J/CSM+qkDfKDCQTQmT
 nXO6nusDG6Z7ndEYM7SM+b98qqcbWaU/0UseZYDMv582izpD7k7PmC+8BKajIUkoPNYc
 Xjs10qsh2tCjG6jTax7fgpYvRM+YJcVJ5HiL1QN+Wp1pInp/MSz5JpPbTONu2qh1kkt4
 6Mxi5kPCFANCCHfkkv5H7ToxxGF6fxfBDqK+1/NsrzErjDVWDlZb1CHG02NwMJulzjER
 AirIp4TQxYcA3JmnjGB4KXZV4k08V6qs6Ni7+9lw4uLD6qLVhGCUE36hGN4uNXxRPzTK ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2ryv2prrk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn2CC155754
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2rytrh3m38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:18 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnH4J027920
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:17 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:16 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 06/10] btrfs: drop old_fsflags in btrfs_ioctl_setflags
Date:   Sat, 20 Apr 2019 19:48:56 +0800
Message-Id: <20190420114900.15472-7-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_inode_flags_to_fsflags() is copied into %old_fsflags and used only
once. Instead used it directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b87a249642f7..e83412d7363a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -187,7 +187,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	struct btrfs_inode *binode = BTRFS_I(inode);
 	struct btrfs_root *root = binode->root;
 	struct btrfs_trans_handle *trans;
-	unsigned int fsflags, old_fsflags;
+	unsigned int fsflags;
 	int ret;
 	umode_t mode;
 	const char *comp = NULL;
@@ -215,8 +215,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	mode = inode->i_mode;
 
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
-	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
-	if ((fsflags ^ old_fsflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+	if ((fsflags ^ btrfs_inode_flags_to_fsflags(binode->flags)) &
+	    (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
 		if (!capable(CAP_LINUX_IMMUTABLE)) {
 			ret = -EPERM;
 			goto out_unlock;
-- 
2.20.1 (Apple Git-117)

