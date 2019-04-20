Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33FC0C282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 013672183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d5mKlOl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfDTLtW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36894 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbfDTLtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn6xb043495
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=JMg0oIpzJqA10zVwdAn5yw6HsZtrSixPJyp+iQsgesI=;
 b=d5mKlOl7XZ+QHmdPLr336hpTNdiZOm07bgK2tRt4gzrXUx6vQC3o/EYl1ULrXDDBRCVm
 0JariL2QP2yyb9IbllwFo1FjibIbWtcXsq4JEZqzsa50SzFUsho5zIsRYrrwB5A2WiJ6
 YOBNAh1Tc00kmh91qQGCj4n8SGAsDg6xEBZO18TctLwIlCivwelN8nCVREUuUeW+y2yI
 pn9JGnidelLNGPG/zuXtWB5kTxkM8nktfv1otASpjI5YvYvOZWhClknsMTcOnfVtCYjM
 05ulGQMZzUrvqYj8uHTG31za4cVlV1o5ONSzEglClr6F69LcLShC0Iz1pKiymNzdN6T9 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2rytusgw4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmqJm003694
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:19 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2rysf8vqj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:19 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnJgB027923
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:19 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:18 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 07/10] btrfs: drop local copy of inode i_mode
Date:   Sat, 20 Apr 2019 19:48:57 +0800
Message-Id: <20190420114900.15472-8-anand.jain@oracle.com>
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

There isn't real use of making struct inode::i_mode a local copy, it saves
a dereference one time, not much. Just use it directly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e83412d7363a..142fcdaf6a93 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -189,7 +189,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	struct btrfs_trans_handle *trans;
 	unsigned int fsflags;
 	int ret;
-	umode_t mode;
 	const char *comp = NULL;
 	u32 binode_flags = binode->flags;
 
@@ -212,8 +211,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	inode_lock(inode);
 
-	mode = inode->i_mode;
-
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
 	if ((fsflags ^ btrfs_inode_flags_to_fsflags(binode->flags)) &
 	    (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
@@ -248,7 +245,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	else
 		binode_flags &= ~BTRFS_INODE_DIRSYNC;
 	if (fsflags & FS_NOCOW_FL) {
-		if (S_ISREG(mode)) {
+		if (S_ISREG(inode->i_mode)) {
 			/*
 			 * It's safe to turn csums off here, no extents exist.
 			 * Otherwise we want the flag to reflect the real COW
@@ -264,7 +261,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		/*
 		 * Revert back under same assumptions as above
 		 */
-		if (S_ISREG(mode)) {
+		if (S_ISREG(inode->i_mode)) {
 			if (inode->i_size == 0)
 				binode_flags &= ~(BTRFS_INODE_NODATACOW |
 						  BTRFS_INODE_NODATASUM);
-- 
2.20.1 (Apple Git-117)

