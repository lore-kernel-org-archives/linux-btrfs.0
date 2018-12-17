Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 803E2C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE89206BA
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 03:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bl0gK4cK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbeLQDOh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 16 Dec 2018 22:14:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44540 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbeLQDOg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Dec 2018 22:14:36 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH3E1Pc006036
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2018-07-02;
 bh=YVRA8UZgg87doUJmZ4SuWvRGxHFntVnszk1/Rtd5/h8=;
 b=bl0gK4cK52dhVQF8Yeg1XkEAmOCLGOOscuj4QrF7ylfKgeejqs4sYdYK4b9Y8zCYlRZ8
 2Isna7HNTQwuhCPdLGTZYXim+TFg3XK4mYwHmlC7HXo5GziZ/c+cHiDj1BCSRRR9qMOD
 MtviFsrXdZ7YfSinS0iv2qMAOnGptWc6rGZnAxhARtdmwK0z+Rp4JQV9i1mmgen5PFh1
 eEH+8UFuhFWX7Gh8VIpSbczzMMY807kxDItxwea4Qo8TFHKPST//ORJ2i6ZiJI5DYCe3
 eqqK2j2BEXOxEMGoAHHgcy3oHURR5UH7ci1p8o+qAjk4WJcx8hMuc6DNvFhT/TorGYhT Uw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pcs1tbknb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:14:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH3EUFi029479
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:14:30 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wBH3ETLQ022045
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 03:14:29 GMT
Received: from tpasj.localdomain (/157.49.189.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 19:14:29 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: declare btrfs_dev_replace_start as static function
Date:   Mon, 17 Dec 2018 11:14:30 +0800
Message-Id: <1545016470-4236-1-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=796
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170029
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_dev_replace_start parent is in the same file dev-replace.c.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/dev-replace.h | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 2aa48aecc52b..59991165e126 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -390,7 +390,7 @@ static char* btrfs_dev_name(struct btrfs_device *device)
 		return rcu_str_deref(device->name);
 }
 
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
+static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
 		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
 		int read_src)
 {
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 795c551f5b5e..27e3bb0cca11 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -13,9 +13,6 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 			  struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 			    struct btrfs_ioctl_dev_replace_args *args);
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
-		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
-		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info);
-- 
1.8.3.1

