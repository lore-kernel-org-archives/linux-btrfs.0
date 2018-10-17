Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6C6ECDE3B
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3A2213A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 22:45:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a0WQ4eNp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D3A2213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbeJRGnI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 02:43:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbeJRGnI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 02:43:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9HMiGVa040211;
        Wed, 17 Oct 2018 22:45:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lbgR3wOuOLZGLL8/c8R4UCc54EWHiKBjm/iFOf5M+sk=;
 b=a0WQ4eNpPV039yem0kQR1DYG4bktBk8YqILWNlveUzMisQBxCkkf1s6909UG3Tzg2eyp
 p0mbi1m9GTiLsGNIU4265KRt3hPIFlmIdLvnATM/SiIM5MFh9mka1YYCKxjXWrYnziUg
 ONHRSYh8OUvyHRgOzPqczLCZ1Y8lMqroEzF6fUsTP+spSBFGksjm+v/FWuQf2RAFeXuT
 VySIebyEKSwIaxCCa59W/Bk2k0GPyrLF9wTAB/wAfPOVC7ZtzvwfBj8Fc4MvAVwpzFsn
 YpIserfWD9WaOvEjIs8Zddosprp8qnXsZv0KpYTBBdOfn+Z0dP9BO3zJ9Zk1xBOOEcqq 0w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2n384u9yx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:45:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMjCBa012260
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Oct 2018 22:45:12 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9HMjClM014843;
        Wed, 17 Oct 2018 22:45:12 GMT
Received: from localhost (/10.159.132.177)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Oct 2018 15:45:11 -0700
Subject: [PATCH 08/29] vfs: rename clone_verify_area to remap_verify_area
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 17 Oct 2018 15:45:10 -0700
Message-ID: <153981631026.5568.8290637209446807642.stgit@magnolia>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9049 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=710
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810170188
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
index aca75a97a695..734c5661fb69 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1686,7 +1686,7 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 	return ret;
 }
 
-static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
+static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 {
 	struct inode *inode = file_inode(file);
 
@@ -1852,11 +1852,11 @@ int do_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (!file_in->f_op->clone_file_range)
 		return -EOPNOTSUPP;
 
-	ret = clone_verify_area(file_in, pos_in, len, false);
+	ret = remap_verify_area(file_in, pos_in, len, false);
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(file_out, pos_out, len, true);
+	ret = remap_verify_area(file_out, pos_out, len, true);
 	if (ret)
 		return ret;
 
@@ -1989,7 +1989,7 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(dst_file, dst_pos, len, true);
+	ret = remap_verify_area(dst_file, dst_pos, len, true);
 	if (ret < 0)
 		goto out_drop_write;
 
@@ -2051,7 +2051,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	if (!S_ISREG(src->i_mode))
 		goto out;
 
-	ret = clone_verify_area(file, off, len, false);
+	ret = remap_verify_area(file, off, len, false);
 	if (ret < 0)
 		goto out;
 	ret = 0;

