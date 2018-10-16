Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4469FC04EBE
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8442083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4F3Pha7h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E8442083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbeJPLIf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:08:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeJPLIf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:08:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3J3t3051349;
        Tue, 16 Oct 2018 03:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=abN8AwQSn2h//7+1QLn+2XgmD6/XEIQ+bkobomWt214=;
 b=4F3Pha7hMa3VhAthE5Z860g/br/Gi8WnzbTAtKS1wN0FITMrzGjzdkvXtkHntann4wrH
 qxpzeXa8cgweJ4IcmcGSTb+HNaUYUiNgqgC0+QI5wF0bZAE7aq0AcS82Fz6x/Uktpr+n
 oVJ2CmvQbJIkGTm007MCGEQ2XaM81n+pOPcpjRYfXjxSHQCTJIBamYzTtn8ybbnCtFEI
 m9zfkQ8JyBQ5penywEO/CdbnM5iWuzCWSDYTOaeciwPvoU9T1KnAO2aXj7e5JWXuc0cw
 j4+92AP3J77xDHpjsCIXyACVLuQKfWqsYSPntcZs0+1yN32BrU8RiSN66aXS11Ylssbo hA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2n384tx29c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:17 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KGQF004814
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:16 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KGAa010715;
        Tue, 16 Oct 2018 03:20:16 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:20:16 -0700
Subject: [PATCH 19/26] vfs: clean up generic_remap_file_range_prep return
 value
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:20:14 -0700
Message-ID: <153966001458.3607.5940191707393894977.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=851
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the remap prep function can update the length of the remap
request, we can change this function to return the usual return status
instead of the odd behavior it has now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    2 +-
 fs/read_write.c         |    6 +++---
 fs/xfs/xfs_reflink.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6a42c04ac0ab..46bbd315c39f 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4852,7 +4852,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			&len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || len == 0)
 		goto out_unlock;
 
 	/* Lock out changes to the allocation maps and remap. */
diff --git a/fs/read_write.c b/fs/read_write.c
index 450e038e8617..37a7d3fe35d8 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1872,8 +1872,8 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  * sense, and then flush all dirty data.  Caller must ensure that the
  * inodes have been locked against any other modifications.
  *
- * Returns: 0 for "nothing to clone", 1 for "something to clone", or
- * the usual negative error code.
+ * If there's an error, then the usual negative error code is returned.
+ * Otherwise returns 0 with *len set to the request length.
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
@@ -1954,7 +1954,7 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3dbe5fb7e9c0..9b1ea42c81d1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1329,7 +1329,7 @@ xfs_reflink_remap_prep(
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
 	/*
@@ -1409,7 +1409,7 @@ xfs_reflink_remap_range(
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
 			&len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || len == 0)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);

