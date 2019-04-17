Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE748C282DC
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A2E20674
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 15:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GUiPjZTd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfDQPhX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 11:37:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40156 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731743AbfDQPhX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 11:37:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFJ1DT167740;
        Wed, 17 Apr 2019 15:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=3bZKcxDkKSEkztL0ON861p2PoXlKMkn93IY9QbuYhZc=;
 b=GUiPjZTdGfg/kEmdJAfF4bsSIjr3TT+KB9r40ZyFdX8aSTVngQz8sAB7HCEu7Duotcr2
 TwxSKHFbZm08uKkOIL8H2c9O9liMHRL+Ez/wmTB6j8+fSNwBnwHHi9mmfTVTmnTHgnU2
 UbJeK6zXHOzWbsBv8AMFy10bI6E2Ett36hvapZ4dL09vg8yH3KKWSSvveom7WPXBb54n
 AiCDg3o8q4YHWNc1JzKvYQg9W50oX/OX/+WdGmhCvsRHmJTSMTbpiWFDEQKCsgdEHAzq
 ZMEzGa7aEOeLIpqWBjD8v2EJ5RMOgU5WvFWhMoxtKpkS8xmSEjxUywG4cFgOrnZx+SJD pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rvwk3uv3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3HFaRen164815;
        Wed, 17 Apr 2019 15:37:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2rubq70s2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Apr 2019 15:37:19 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3HFbIAj002604;
        Wed, 17 Apr 2019 15:37:19 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Apr 2019 08:37:17 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
Subject: [PATCH 2/2 RFC] btrfs: start transaction in btrfs_ioctl_setflags()
Date:   Wed, 17 Apr 2019 23:37:06 +0800
Message-Id: <20190417153706.29942-3-anand.jain@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190417153706.29942-1-anand.jain@oracle.com>
References: <20190417153706.29942-1-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904170104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9230 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904170104
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When inode attribute flags is set through FS_IOC_SETFLAGS ioctl, there is
a bit of duplicate codes, the following things happens twice -
start/end_transaction, inode_inc_iversion(), current_time update to
inode->i_ctime, and btrfs_update_inode(). These are updated both at
btrfs_ioctl_setflags() and btrfs_set_props() as well. (RFC: So inode
version and the generation number should have increased by +2, but I
don't see that in the test case below ran without this patch)

This patch merges these two duplicate codes at btrfs_ioctl_setflags().

$ cat a
mkfs.btrfs -fq /dev/sdb || exit
mount /dev/sdb /btrfs
touch /btrfs/file1
sync
echo before:
btrfs in dump-super /dev/sdb | grep ^generation
btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"
echo
echo "chattr +Ac /btrfs/file1"
chattr +Ac /btrfs/file1
sync
echo after:
btrfs in dump-super /dev/sdb | grep ^generation
btrfs in dump-tree /dev/sdb | grep -A4 "257 XATTR_ITEM"
btrfs in dump-tree /dev/sdb | grep -A4 "257 INODE_ITEM 0) item"

$ umount /btrfs; ./a
before:
generation		6
	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
		generation 6 transid 6 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 19 flags 0x0(none)

chattr +Ac /btrfs/file1
after:
generation		7
	item 6 key (257 XATTR_ITEM 550297449) itemoff 15815 itemsize 51
		location key (0 UNKNOWN.0 0) type XATTR
		transid 7 data_len 4 name_len 17
		name: btrfs.compression
		data zlib
	item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
		generation 6 transid 7 size 0 nbytes 0
		block group 0 mode 100644 links 1 uid 0 gid 0 rdev 0
		sequence 21 flags 0xa00(NOATIME|COMPRESS)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 38 ++++++++++++++++++--------------------
 fs/btrfs/props.c |  6 +++---
 fs/btrfs/props.h |  3 +++
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 63e6e2f5b659..82772523bb87 100644
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
@@ -300,36 +294,40 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
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
+		if (ret)
+			goto out_abort;
+		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+	} else {
+		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL,
+				     0, 0);
+		if (ret && ret != -ENODATA)
+			goto out_abort;
+	}
+
 	btrfs_sync_inode_flags_to_i_flags(inode);
 	inode_inc_iversion(inode);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, inode);
 
+ out_abort:
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 	btrfs_end_transaction(trans);
  out_drop:
 	if (ret) {
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index e356dd2a0f73..aedf5a7d69c9 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -72,9 +72,9 @@ int btrfs_validate_prop(const char *name, const char *value, size_t value_len)
 	return handler->validate(value, value_len);
 }
 
-static int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
-			  const char *name, const char *value, size_t value_len,
-			  int flags)
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
+		   int flags)
 {
 	const struct prop_handler *handler;
 	int ret;
diff --git a/fs/btrfs/props.h b/fs/btrfs/props.h
index 01d2c1899bc7..30b99348977d 100644
--- a/fs/btrfs/props.h
+++ b/fs/btrfs/props.h
@@ -12,6 +12,9 @@ void __init btrfs_props_init(void);
 
 int btrfs_set_prop_trans(struct inode *inode, const char *name,
 			 const char *value, size_t value_len, int flags);
+int btrfs_set_prop(struct btrfs_trans_handle *trans, struct inode *inode,
+		   const char *name, const char *value, size_t value_len,
+		   int flags);
 int btrfs_validate_prop(const char *name, const char *value, size_t value_len);
 
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path);
-- 
2.17.1

