Return-Path: <SRS0=p7dB=RE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA288C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A1CB20851
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Mar 2019 04:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gI8xHCng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfCAEfM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 23:35:12 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58546 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbfCAEfL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 23:35:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x214Z9rB005077
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=Ousc8j6RRjG46p1cBTJUf7xL4Qikucx9cJ0JGISwyY8=;
 b=gI8xHCngdT8O0TRefc9BGGgW5hbyq5zYMig1ErzBlH5IrF3urvJykeL7vOvOeOjFciyR
 xOKRe7so+/hwkocrVgcZIE+Ku2Onb7cxifbGMsZUnBmM5zfT/8ag4ou2SQhW1DWhb5Ho
 FsVf0ibVg/+0CrTja5MUZu75lQH8Rxw33w0uoZEf7nVh6lvmfUbtJcYd/69BrOs/keJ+
 9UE/uzj5cbbZH19rOXpl1j4MWup6wC2cZfi0LnlMmcGQ0FKQ4oKzwXmdmzF0Xd98A5XS
 RXf7WxW+FkpA8D/u1fnbXXsJe/E2kCkNZc+lbF87cE0WotF5Z16WtCTBHSK2EriItUmk zQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qtupencv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 04:35:09 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x214Z86G007286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:09 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x214Z8KA021519
        for <linux-btrfs@vger.kernel.org>; Fri, 1 Mar 2019 04:35:08 GMT
Received: from tpasj.wifi.oracle.com (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 20:35:08 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 7/9] btrfs: start transaction in btrfs_xattr_handler_set
Date:   Fri,  1 Mar 2019 12:34:53 +0800
Message-Id: <1551414895-22925-8-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9181 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903010029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Generic extended attributes on the inode are set using
btrfs_xattr_handler_set(), and the required transaction for this update
is started by btrfs_setxattr(). For better granulation of the
transaction start and end, do this in btrfs_xattr_handler_set().
For which this patch copied code of btrfs_setxattr() as it is in the
original, which needs a fix later.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v5: Use BUG_ON instead of ASSERT. Changelog update.
v4: born
 fs/btrfs/xattr.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 69126d5b4d62..e96b0096eaca 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -369,8 +369,29 @@ static int btrfs_xattr_handler_set(const struct xattr_handler *handler,
 				   const char *name, const void *buffer,
 				   size_t size, int flags)
 {
+	int ret;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
 	name = xattr_full_name(handler, name);
-	return btrfs_setxattr(NULL, inode, name, buffer, size, flags);
+
+	trans = btrfs_start_transaction(root, 2);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+	ret = btrfs_setxattr(trans, inode, name, buffer, size, flags);
+
+	if (!ret) {
+		inode_inc_iversion(inode);
+		inode->i_ctime = current_time(inode);
+		set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
+		ret = btrfs_update_inode(trans, root, inode);
+		BUG_ON(ret);
+	}
+
+	btrfs_end_transaction(trans);
+
+	return ret;
 }
 
 static int btrfs_xattr_handler_set_prop(const struct xattr_handler *handler,
-- 
1.8.3.1

