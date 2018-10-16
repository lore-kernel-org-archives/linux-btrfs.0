Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E15C04EB9
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A05C208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iBSICVn4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A05C208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbeJPLIs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:08:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeJPLIr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:08:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3JosY051805;
        Tue, 16 Oct 2018 03:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=HOYBOBGpflqwSaMT4PmSGK8TNSkXTGNQVQO8YcwuUKs=;
 b=iBSICVn4f9CkaRFFiOxk2xB6Y4NFF+6yJTm0g85Ac8gHYjxhbKJs7hWy8xzvr7mKImeN
 V8N/wYDDl1S13EN4709ZB0nQAF8wsAYGdoekttm+crepR3b6VUelYUjwEkVk+2M2dmkE
 /NrZoJh7gZznmDo77tU5l+ACD1JK6isq55m/9n1bZIL2yfrzyllpmvz+a9kSwvHjAprS
 xnCZpHestWVzu6VTXPrnQ9Vx/Gvt87rXQCnZvXJKNng5vnVDpq5Xb0r7b4lKU3p1w4ou
 LKNboZS0vnvnnvsb33r/PNcDLrVmTu+Vm4nYEN+hh1Qw9oIzM0Z+g3ghIe5EwM1584l8 Cw== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2n384tx29t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:31 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KUJf029604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:30 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KTFY012664;
        Tue, 16 Oct 2018 03:20:30 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:20:29 -0700
Subject: [PATCH 21/26] ocfs2: fix pagecache truncation prior to reflink
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:20:28 -0700
Message-ID: <153966002809.3607.17959416355714610983.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prior to remapping blocks, it is necessary to remove pages from the
destination file's page cache.  Unfortunately, the truncation is not
aggressive enough -- if page size > block size, we'll end up zeroing
subpage blocks instead of removing them.  So, round the start offset
down and the end offset up to page boundaries.  We already wrote all
the dirty data so the larger range should be fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 2a5c96bc9677..7c709229e108 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4862,8 +4862,9 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 				  SINGLE_DEPTH_NESTING);
 
 	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data,
+				   round_down(pos_out, PAGE_SIZE),
+				   round_up(pos_out + len, PAGE_SIZE) - 1);
 
 	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
 					 out_bh, pos_out, len);

