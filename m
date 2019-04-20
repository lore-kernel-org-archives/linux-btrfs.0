Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF8C282E2
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1AA72183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5D2oeZjH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfDTLtT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbfDTLtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBmko2049340
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=QQperI/KhzcfdiYnZczmmaTeAyFkuesC+nwqSI894b4=;
 b=5D2oeZjHG7hIN2klICYUi7QQ514axk2wRGD4s7TqAaD6+MDjTD0Vxs0GwK6STB2nf04W
 eoSXGjLOjO6y2aUsxA4Q6LGr5ftLFI07d9Cz/FVTo1WjXNZxuZrF+/Urbea3eKKx5sjF
 W7EOXd7L+8KRO91BecNZNFm3XNiEGwNQqgG1Q0DB2+2UdvGF58nfhWZtlCl/26QMQgp6
 bz01oTm+e+EahTLbW2NDNOxLyyoHPfeIQ5bYqFbn538bq+zfu/eYC0JPTkhkcmnKNCWJ
 hIurgIaSJKS4TUOQE0iZk8idqSjF1+0JuQGey7aiCLXolqnz+n/w182+0rzAn9N31XVy Mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2ryrxch2sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBnGiU002790
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ryrhqxf5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3KBnFHA027914
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:15 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:15 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 05/10] btrfs: make a local copy of btrfs_inode flags before update
Date:   Sat, 20 Apr 2019 19:48:55 +0800
Message-Id: <20190420114900.15472-6-anand.jain@oracle.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190420114900.15472-1-anand.jain@oracle.com>
References: <20190420114900.15472-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=923
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904200090
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9232 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=950 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904200090
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of updating the binode::flags directly, update a local copy,
and then at the point of no error-return copy it to the binode::flags.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 57 ++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1834b576d1cb..b87a249642f7 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -189,9 +189,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	struct btrfs_trans_handle *trans;
 	unsigned int fsflags, old_fsflags;
 	int ret;
-	u64 old_flags;
 	umode_t mode;
 	const char *comp = NULL;
+	u32 binode_flags = binode->flags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -212,7 +212,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
 	inode_lock(inode);
 
-	old_flags = binode->flags;
 	mode = inode->i_mode;
 
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
@@ -225,29 +224,29 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	}
 
 	if (fsflags & FS_SYNC_FL)
-		binode->flags |= BTRFS_INODE_SYNC;
+		binode_flags |= BTRFS_INODE_SYNC;
 	else
-		binode->flags &= ~BTRFS_INODE_SYNC;
+		binode_flags &= ~BTRFS_INODE_SYNC;
 	if (fsflags & FS_IMMUTABLE_FL)
-		binode->flags |= BTRFS_INODE_IMMUTABLE;
+		binode_flags |= BTRFS_INODE_IMMUTABLE;
 	else
-		binode->flags &= ~BTRFS_INODE_IMMUTABLE;
+		binode_flags &= ~BTRFS_INODE_IMMUTABLE;
 	if (fsflags & FS_APPEND_FL)
-		binode->flags |= BTRFS_INODE_APPEND;
+		binode_flags |= BTRFS_INODE_APPEND;
 	else
-		binode->flags &= ~BTRFS_INODE_APPEND;
+		binode_flags &= ~BTRFS_INODE_APPEND;
 	if (fsflags & FS_NODUMP_FL)
-		binode->flags |= BTRFS_INODE_NODUMP;
+		binode_flags |= BTRFS_INODE_NODUMP;
 	else
-		binode->flags &= ~BTRFS_INODE_NODUMP;
+		binode_flags &= ~BTRFS_INODE_NODUMP;
 	if (fsflags & FS_NOATIME_FL)
-		binode->flags |= BTRFS_INODE_NOATIME;
+		binode_flags |= BTRFS_INODE_NOATIME;
 	else
-		binode->flags &= ~BTRFS_INODE_NOATIME;
+		binode_flags &= ~BTRFS_INODE_NOATIME;
 	if (fsflags & FS_DIRSYNC_FL)
-		binode->flags |= BTRFS_INODE_DIRSYNC;
+		binode_flags |= BTRFS_INODE_DIRSYNC;
 	else
-		binode->flags &= ~BTRFS_INODE_DIRSYNC;
+		binode_flags &= ~BTRFS_INODE_DIRSYNC;
 	if (fsflags & FS_NOCOW_FL) {
 		if (S_ISREG(mode)) {
 			/*
@@ -256,10 +255,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			 * status of the file and will not set it.
 			 */
 			if (inode->i_size == 0)
-				binode->flags |= BTRFS_INODE_NODATACOW
-					      | BTRFS_INODE_NODATASUM;
+				binode_flags |= BTRFS_INODE_NODATACOW |
+						BTRFS_INODE_NODATASUM;
 		} else {
-			binode->flags |= BTRFS_INODE_NODATACOW;
+			binode_flags |= BTRFS_INODE_NODATACOW;
 		}
 	} else {
 		/*
@@ -267,10 +266,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		 */
 		if (S_ISREG(mode)) {
 			if (inode->i_size == 0)
-				binode->flags &= ~(BTRFS_INODE_NODATACOW
-				             | BTRFS_INODE_NODATASUM);
+				binode_flags &= ~(BTRFS_INODE_NODATACOW |
+						  BTRFS_INODE_NODATASUM);
 		} else {
-			binode->flags &= ~BTRFS_INODE_NODATACOW;
+			binode_flags &= ~BTRFS_INODE_NODATACOW;
 		}
 	}
 
@@ -280,8 +279,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	 * things smaller.
 	 */
 	if (fsflags & FS_NOCOMP_FL) {
-		binode->flags &= ~BTRFS_INODE_COMPRESS;
-		binode->flags |= BTRFS_INODE_NOCOMPRESS;
+		binode_flags &= ~BTRFS_INODE_COMPRESS;
+		binode_flags |= BTRFS_INODE_NOCOMPRESS;
 	} else if (fsflags & FS_COMPR_FL) {
 
 		if (IS_SWAPFILE(inode)) {
@@ -289,20 +288,20 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 			goto out_unlock;
 		}
 
-		binode->flags |= BTRFS_INODE_COMPRESS;
-		binode->flags &= ~BTRFS_INODE_NOCOMPRESS;
+		binode_flags |= BTRFS_INODE_COMPRESS;
+		binode_flags &= ~BTRFS_INODE_NOCOMPRESS;
 
 		comp = btrfs_compress_type2str(fs_info->compress_type);
 		if (!comp || comp[0] == 0)
 			comp = btrfs_compress_type2str(BTRFS_COMPRESS_ZLIB);
 	} else {
-		binode->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
+		binode_flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
 	trans = btrfs_start_transaction(root, 3);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
-		goto out_drop;
+		goto out_unlock;
 	}
 
 	if (comp) {
@@ -323,6 +322,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		}
 	}
 
+	binode->flags = binode_flags;
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
@@ -330,11 +330,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 
  out_end_trans:
 	btrfs_end_transaction(trans);
- out_drop:
-	if (ret) {
-		binode->flags = old_flags;
-	}
-
  out_unlock:
 	inode_unlock(inode);
 	mnt_drop_write_file(file);
-- 
2.20.1 (Apple Git-117)

