Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BEEC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D53A214FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:11:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="4ROg8HLc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D53A214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbeJJHaj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:30:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51008 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbeJJHai (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:30:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9A08q9u119807;
        Wed, 10 Oct 2018 00:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dLeY25XICiLWqckKMrtV3v59Uk72O343BuPWK8wy/8U=;
 b=4ROg8HLcuay622FiB2cbzs3fYCaZnJhJaTMZVRcW7v8/0zwxlOpwHytxs00L9lzLifjE
 OamRxAeyzCAxQhCkOCjqXuI7pq8n46HK/tch2QaJhDAHbvbYV+zUzwPpsAxc39jRuaEl
 6yodviYMrdbDVtv5EiShuPD9EgsoWsNV5kSxAydV4ahN6x4mbi8hx4aWizmNBynFt4Rd
 c4l26TMz4xNHg+4SLTwtNElTanXzNNWpATmX8H7Zm/SndmKvswecUPWNezWF2AprL+Wb
 Q7U77nyhAlJuridLWR6Z0PJTsSp+VTc9KauPB5vyP08G+K94/4kT7AlOnaXce/2aImqR Ig== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2mxmftrvg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:09 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0B88S031503
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 00:11:09 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9A0B8hu002889;
        Wed, 10 Oct 2018 00:11:08 GMT
Received: from localhost (/10.159.249.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 00:11:08 +0000
Subject: [PATCH 04/25] xfs: update ctime and remove suid before cloning files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Date:   Tue, 09 Oct 2018 17:11:06 -0700
Message-ID: <153913026644.32295.612141018276176517.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100000
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before cloning into a file, update the ctime and remove sensitive
attributes like suid, just like we'd do for a regular file write.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cbb359e68a72..d4feaeba8542 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1264,6 +1264,7 @@ xfs_reflink_zero_posteof(
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
  * will be truncated, and any leases on the out file will have been broken.
+ * This function borrows heavily from xfs_file_aio_write_checks.
  * Returns negative for error, 0 for nothing to do, and 1 for success.
  */
 STATIC int
@@ -1328,6 +1329,30 @@ xfs_reflink_remap_prep(
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + *len) - 1);
+
+	/* If we're altering the file contents... */
+	if (!is_dedupe) {
+		/*
+		 * ...update the timestamps (which will grab the ilock again
+		 * from xfs_fs_dirty_inode, so we have to call it before we
+		 * take the ilock).
+		 */
+		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+			ret = file_update_time(file_out);
+			if (ret)
+				goto out_unlock;
+		}
+
+		/*
+		 * ...clear the security bits if the process is not being run
+		 * by root.  This keeps people from modifying setuid and setgid
+		 * binaries.
+		 */
+		ret = file_remove_privs(file_out);
+		if (ret)
+			goto out_unlock;
+	}
+
 	return 1;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);

