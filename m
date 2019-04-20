Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6F7C282DD
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C042183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJc1ZtWZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfDTLtQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40314 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfDTLtP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnE61057583
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=Gsx3jealNn/J5p9TasixiI0nCoc+H6cPf9Fw6lx+pPs=;
 b=jJc1ZtWZIOwkTYsEc7jvjcguLjHMxwn5hlNiCQQGiPpTRjIY1qmuDaHjykC9AXy82Fxk
 d26DSIBWtgHrTIEcXLkyMTDBmm5FYgZd1np82JFPJuyJ1hCBAhii2Z/i/oB/ot4ZZAVG
 rqEfGH9btyhqNyB33Lvic6d0R+EJi9qw0Dyk1I3SGxgMSR6piBv5DqURXBmJ8oJ9bM8n
 64jPxbeVxV4sO1ltN2iAVkIbctR66Xmk8m0w+1LnNPAKQGldyeamqxcoWYkzrqe9VI6w
 J4bOpCNDOlS3A1q+QLInTVI0yNKTyZfEbp4tDwk3OdNUwwHFEEoAQ5sGncIXoCppUmL/ Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2ryv2prrjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmTfM037012
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ryu803awx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:13 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnDt2027904
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:13 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:12 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 03/10] btrfs: start transaction in btrfs_ioctl_setflags()
Date:   Sat, 20 Apr 2019 19:48:53 +0800
Message-Id: <20190420114900.15472-4-anand.jain@oracle.com>
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

Inode attribute can be set through the FS_IOC_SETFLAGS ioctl.
This flags also includes compression attribute for which we would
set/reset the compression extended attribute. While doing this there
is a bit of duplicate code, the following things happens twice-
start/end_transaction, inode_inc_iversion(), current_time update to
inode->i_ctime, and btrfs_update_inode(). These are updated both at
btrfs_ioctl_setflags() and btrfs_set_props() as well.

This patch merges these two duplicate codes at btrfs_ioctl_setflags().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
RFC->v1: call btrfs_transaction_abort() at the place of error return
 
 fs/btrfs/ioctl.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63e6e2f5b659..fc3f75c9a210 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -192,6 +192,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	u64 old_flags;
 	unsigned int old_i_flags;
 	umode_t mode;
+	const char *comp = NULL;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -283,14 +284,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (fsflags & FS_NOCOMP_FL) {
 		binode->flags &= ~BTRFS_INODE_COMPRESS;
 		binode->flags |= BTRFS_INODE_NOCOMPRESS;
-
-		/* set no-compression no need to validate prop here */
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
-					   0, 0);
-		if (ret && ret != -ENODATA)
-			goto out_drop;
 	} else if (fsflags & FS_COMPR_FL) {
-		const char *comp;
 
 		if (IS_SWAPFILE(inode)) {
 			ret = -ETXTBSY;
@@ -300,36 +294,43 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		binode->flags |= BTRFS_INODE_COMPRESS;
 		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
 
-		/* compress_type is already validated during mount options */
 		comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
-
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", comp,
-					   strlen(comp), 0);
-		if (ret)
-			goto out_drop;
-
 	} else {
-		/* reset prop, no need of validate prop here */
-		ret = btrfs_set_prop_trans(inode, "btrfs.compression", NULL,
-					   0, 0);
-		if (ret && ret != -ENODATA)
-			goto out_drop;
 		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
-	trans = btrfs_start_transaction(root, 1);
+	trans = btrfs_start_transaction(root, 3);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_drop;
 	}
 
+	if (comp) {
+		ret = btrfs_set_prop(trans, inode, "btrfs.compression", comp,
+				     strlen(comp), 0);
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto out_end_trans;
+		}
+		set_bit(BTRFS_INODE_COPY_EVERYTHING,
+			&BTRFS_I(inode)->runtime_flags);
+	} else {
+		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL,
+				     0, 0);
+		if (ret && ret != -ENODATA) {
+			btrfs_abort_transaction(trans, ret);
+			goto out_end_trans;
+		}
+	}
+
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, inode);
 
+ out_end_trans:
 	btrfs_end_transaction(trans);
  out_drop:
 	if (ret) {
-- 
2.20.1 (Apple Git-117)

