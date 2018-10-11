Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5D06C46462
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936672077C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 04:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aifj+4/I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 936672077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbeJKLjl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 07:39:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42460 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbeJKLjl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 07:39:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B4E2VE002940;
        Thu, 11 Oct 2018 04:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OdIc8YLsa80Ux9kQHDzThidqDdLKImkUmlD2xgowl3w=;
 b=Aifj+4/IfYPh0+MHesC1MXbBCLW1Bn2Ygjyn1PR9oG7TYXIBvcu0t4roXhXGQ4JkODUF
 FEh4eQSCLLjkuGI3L/VucmP2L9Y/Pw/wC1f1LrCwryCJcvK7fLQ09a/8spT7rg/cG0ip
 z36LqU5LTuZxfNzhHedCjSoHg7iFIENwmfyaRjEE90cwaqxdM4iPWHNPzJSVjBb61I1e
 9OpjkfzNeYTdFEx75TAJN2AOGCYPRvJS6MdqdiP13gTtAE0+vONKYoZWsW58P+qWIk65
 uHB+sM0AehRY84lh0l5mf/zHW3ErGPIJvJFNADX43N4ANvOJKOHAwcqCL80RjXj9wOJW Nw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2mxnpr9922-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:16 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B4EFI0018439
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 04:14:15 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9B4EEAm030112;
        Thu, 11 Oct 2018 04:14:14 GMT
Received: from localhost (/10.159.132.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 04:14:13 +0000
Subject: [PATCH 15/25] vfs: plumb RFR_* remap flags through the vfs dedupe
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Wed, 10 Oct 2018 21:14:11 -0700
Message-ID: <153923125177.5546.7735584725952507239.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=524
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110040
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Plumb a remap_flags argument through the vfs_dedupe_file_range_one
functions so that dedupe can take advantage of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c |    3 ++-
 fs/read_write.c     |    9 ++++++---
 include/linux/fs.h  |    2 +-
 3 files changed, 9 insertions(+), 5 deletions(-)


diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e5cc17281d0b..8f7a162768f2 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -467,7 +467,8 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 
 	case OVL_DEDUPE:
 		ret = vfs_dedupe_file_range_one(real_in.file, pos_in,
-						real_out.file, pos_out, len);
+						real_out.file, pos_out, len,
+						flags);
 		break;
 	}
 	revert_creds(old_cred);
diff --git a/fs/read_write.c b/fs/read_write.c
index b3f8b4a2bdfc..a360274b0cdc 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2004,10 +2004,12 @@ EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
 loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 				 struct file *dst_file, loff_t dst_pos,
-				 loff_t len)
+				 loff_t len, unsigned int remap_flags)
 {
 	loff_t ret;
 
+	WARN_ON_ONCE(remap_flags & ~(RFR_SAME_DATA));
+
 	ret = mnt_want_write_file(dst_file);
 	if (ret)
 		return ret;
@@ -2038,7 +2040,7 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	}
 
 	ret = dst_file->f_op->remap_file_range(src_file, src_pos, dst_file,
-			dst_pos, len, RFR_SAME_DATA);
+			dst_pos, len, remap_flags | RFR_SAME_DATA);
 out_drop_write:
 	mnt_drop_write_file(dst_file);
 
@@ -2106,7 +2108,8 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 		}
 
 		deduped = vfs_dedupe_file_range_one(file, off, dst_file,
-						    info->dest_offset, len);
+						    info->dest_offset, len,
+						    0);
 		if (deduped == -EBADE)
 			info->status = FILE_DEDUPE_RANGE_DIFFERS;
 		else if (deduped < 0)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4acda4809027..d77b8d90d65e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1863,7 +1863,7 @@ extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 extern loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 					struct file *dst_file, loff_t dst_pos,
-					loff_t len);
+					loff_t len, unsigned int remap_flags);
 
 
 struct super_operations {

