Return-Path: <SRS0=nucE=SW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16316C282E2
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D773A2183F
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Apr 2019 11:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XTdTqZMk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfDTLtR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Apr 2019 07:49:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40332 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbfDTLtQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Apr 2019 07:49:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn39v057534
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=W8i+l7hsY21hE/yjxGeXW8Jb94nnEWUtYIXW3GMiAFw=;
 b=XTdTqZMk+3RglWPfYdZjZ8pRFdbhpAVPTYLq4oo35XDhiDDkKRZ+UzPeUSA0edeEy8xh
 QjXnrpwf/lYrqePa7sQu243YTntJv1ZAKbFB+zB45hIAuwMzpRSIwYpgSjGs5WnS2zfn
 gCh5JmAVxf0jL970OhW6CB4jZPbM9zv5TB+F/wDdZ/S/TtIQsFuxY+KkQ3h+XrnOuuEc
 EURSGyO9uSgzmWz36v/6PoEhG8Duk+Yq/oaI6PP6bV4aN5v+2fd5zIZz+mAoheRaDPQx
 N78LJo6/VqZurtrb+BElctUliYtLmfIWov+qBTFtB3L04nRZU4NTH2sLFVyfigzuxSTS sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ryv2prrjv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3KBn8PX002540
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ryrhqxf59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3KBnE32022342
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2019 11:49:14 GMT
Received: from localhost.localdomain (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 20 Apr 2019 04:49:14 -0700
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 04/10] btrfs: drop useless inode i_flags copy and restore
Date:   Sat, 20 Apr 2019 19:48:54 +0800
Message-Id: <20190420114900.15472-5-anand.jain@oracle.com>
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

The patch (btrfs: start transaction in btrfs_ioctl_setflags())
used btrfs_set_prop() instead of btrfs_set_prop_trans() by which now
the inode::i_flags update functions such as
btrfs_sync_inode_flags_to_i_flags() and btrfs_update_inode() is called
in btrfs_ioctl_setflags() instead of
btrfs_set_prop_trans()->btrfs_setxattr() as earlier. So the inode::i_flags
remains unmodified until the thread has checked all the conditions. So drop
the saved inode::i_flags in out_i_flags.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fc3f75c9a210..1834b576d1cb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -190,7 +190,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	u64 old_flags;
-	unsigned int old_i_flags;
 	umode_t mode;
 	const char *comp = NULL;
 
@@ -214,7 +213,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	inode_lock(inode);
 
 	old_flags = binode->flags;
-	old_i_flags = inode->i_flags;
 	mode = inode->i_mode;
 
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
@@ -335,7 +333,6 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
  out_drop:
 	if (ret) {
 		binode->flags = old_flags;
-		inode->i_flags = old_i_flags;
 	}
 
  out_unlock:
-- 
2.20.1 (Apple Git-117)

