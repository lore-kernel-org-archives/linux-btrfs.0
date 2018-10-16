Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCDBC04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C95EA208D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K76nLdhT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C95EA208D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbeJPK7i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 06:59:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbeJPK7h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 06:59:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G38gOw194183;
        Tue, 16 Oct 2018 03:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3p9QiOkfa8h9mw3zC6wMgXppY9cjHOCTYbdPvwFdVO8=;
 b=K76nLdhT6z9//J9WzFChKCPByxZCJ3bcnKeQCRf7+O3k8IYOKZC23DpxdiJrv+Bk5xXQ
 xa1Nvo5eEQJMrMX15uCsVKr1pQV98+F+iZlkV7KaPHC/7FYkFKQmR+Tifepl9n/Ggx+B
 lHJ+ft5aXUUCXWDmlkwcMZ2vpeW/PKb3JxGpgjZygVNltJJXUp8JEfevSY1LyVnaW/5v
 7hlLCmyTT6urnozlcbkCG0H2eKFUh9QLA/O/VoUvUZBhcCf3VbHSF2MHIpJbu5xRVw1k
 hKNnk7U2qw2NgyALk9dlvHm4ufqEHatYvfxg8G6JaIuIeI7YQTBVh9wdJHfmROQbOaPH 2w== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2n39br5rj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:11:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3BLJR030688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:11:21 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9G3BKo0004163;
        Tue, 16 Oct 2018 03:11:20 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:11:20 -0700
Subject: [PATCH 12/26] vfs: pass remap flags to generic_remap_checks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:11:19 -0700
Message-ID: <153965947897.1256.9976516083702922569.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=470
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160026
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Pass the same remap flags to generic_remap_checks for consistency.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c    |    2 +-
 include/linux/fs.h |    2 +-
 mm/filemap.c       |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 201381689284..ebcbfc4f2907 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1782,7 +1782,7 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 
 	/* Check that we don't violate system file offset limits. */
 	ret = generic_remap_checks(file_in, pos_in, file_out, pos_out, len,
-			(remap_flags & REMAP_FILE_DEDUP));
+			remap_flags);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c2800953937a..1aa3bc1bb092 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2981,7 +2981,7 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern ssize_t generic_write_checks(struct kiocb *, struct iov_iter *);
 extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
 				struct file *file_out, loff_t pos_out,
-				uint64_t *count, bool is_dedupe);
+				uint64_t *count, unsigned int remap_flags);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
 extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 08ad210fee49..b0f1f6d93d9c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3001,7 +3001,7 @@ EXPORT_SYMBOL(generic_write_checks);
  */
 int generic_remap_checks(struct file *file_in, loff_t pos_in,
 			 struct file *file_out, loff_t pos_out,
-			 uint64_t *req_count, bool is_dedupe)
+			 uint64_t *req_count, unsigned int remap_flags)
 {
 	struct inode *inode_in = file_in->f_mapping->host;
 	struct inode *inode_out = file_out->f_mapping->host;
@@ -3023,7 +3023,7 @@ int generic_remap_checks(struct file *file_in, loff_t pos_in,
 	size_out = i_size_read(inode_out);
 
 	/* Dedupe requires both ranges to be within EOF. */
-	if (is_dedupe &&
+	if ((remap_flags & REMAP_FILE_DEDUP) &&
 	    (pos_in >= size_in || pos_in + count > size_in ||
 	     pos_out >= size_out || pos_out + count > size_out))
 		return -EINVAL;

