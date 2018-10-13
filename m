Return-Path: <SRS0=QL7B=MZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900F6C6787C
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5409320868
	for <linux-btrfs@archiver.kernel.org>; Sat, 13 Oct 2018 00:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GyqOWL0c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5409320868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbeJMHlo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 13 Oct 2018 03:41:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbeJMHlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 13 Oct 2018 03:41:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9D04QNx104849;
        Sat, 13 Oct 2018 00:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Kfx6b01y0nD5NBow+aLHaMRvX2Vt7rtxPOY+lM34dJ0=;
 b=GyqOWL0cUdSzX/9zPjcH1a8PqRvhjb5Ux0q7TVuExawynupsH4bc7CSoWwrfcTfahe/5
 K2L85IoiIY06b2hSYdm2H6s95lYZPSzrP0zhALOxFJmS+5wj6EUllj/9I+rb2A4KOFr/
 Z3pT0qao0kidwTiAaxA2C4hEVvdMrbX1X4KS1CbkFf9Kc84qvIEI9IuCDve0uLio3bY7
 rIM+X+gkz7/g/UlLXIMbcTPtsnDAAwfE/cF6k4pDL5lftkAxP47Bnp31m6l6M+yUkJr7
 MpZz1fvDjqJuhmwse/wmy3/hobn5X1h48mE43b3gLZJOB99a5LxBfZQAcjDQUev0dGBl kw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mxnprnfhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:06:48 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9D06lF1018185
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Oct 2018 00:06:47 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9D06kV9018800;
        Sat, 13 Oct 2018 00:06:47 GMT
Received: from localhost (/10.159.251.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Oct 2018 00:06:46 +0000
Subject: [PATCH 09/25] vfs: rename clone_verify_area to remap_verify_area
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Fri, 12 Oct 2018 17:06:45 -0700
Message-ID: <153938920501.8361.2713830760292171099.stgit@magnolia>
In-Reply-To: <153938912912.8361.13446310416406388958.stgit@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9044 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=708
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810130000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we use clone_verify_area for both clone and dedupe range checks,
rename the function to make it clear that it's for both.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 65285524e4c3..ff6fcb3b99dd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1686,7 +1686,7 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 	return ret;
 }
 
-static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
+static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 {
 	struct inode *inode = file_inode(file);
 
@@ -1834,11 +1834,11 @@ int do_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (!file_in->f_op->remap_file_range)
 		return -EOPNOTSUPP;
 
-	ret = clone_verify_area(file_in, pos_in, len, false);
+	ret = remap_verify_area(file_in, pos_in, len, false);
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(file_out, pos_out, len, true);
+	ret = remap_verify_area(file_out, pos_out, len, true);
 	if (ret)
 		return ret;
 
@@ -1971,7 +1971,7 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(dst_file, dst_pos, len, true);
+	ret = remap_verify_area(dst_file, dst_pos, len, true);
 	if (ret < 0)
 		goto out_drop_write;
 
@@ -2033,7 +2033,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	if (!S_ISREG(src->i_mode))
 		goto out;
 
-	ret = clone_verify_area(file, off, len, false);
+	ret = remap_verify_area(file, off, len, false);
 	if (ret < 0)
 		goto out;
 	ret = 0;

