Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06304C04EBD
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49692083E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 03:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3/ATnRlF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C49692083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbeJPLIk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 07:08:40 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbeJPLIk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 07:08:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9G3J3t4051349;
        Tue, 16 Oct 2018 03:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PyBPAavOIq55658ZH1Sj+FtMrq4d/FyfXvZlBhg5/0I=;
 b=3/ATnRlF0+K3juooAcYQQkcfgKZy7Qsol0XStB+WNT/h/ZmfR4RSs36kpd1rMHfXPMWB
 4VCmI+OdxEDK+1aQkwjR5/Ioya8Z31FwYwM/qYojKk5EYJgGU1DyGjHvgLgMgal3N5rp
 zrSuPDKQGNoQHe3OwrYIrob24OWMl8lm7OsQAMLC/0l7jcNJU+nDIud2NrfRqB6nE2PE
 hqB2AX0V9LMmv/mZ5dwu1ZotvA36FWhcgQiPR0S16djsNiQo1FwlixIKGFJcnfLwKWpG
 r9WsUMC3CbdNNYpg3zKPMeCFMnQ/pbbCcunRZeRYsMtk3QrByoaTmMEwoobJmZq5ko/x RQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2n384tx29q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:24 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9G3KNdc032476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Oct 2018 03:20:23 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9G3KNGr007142;
        Tue, 16 Oct 2018 03:20:23 GMT
Received: from localhost (/10.159.227.150)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Oct 2018 20:20:22 -0700
Subject: [PATCH 20/26] ocfs2: truncate page cache for clone destination file
 before remapping
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Date:   Mon, 15 Oct 2018 20:20:21 -0700
Message-ID: <153966002134.3607.2095885321354295269.stgit@magnolia>
In-Reply-To: <153965939489.1256.7400115244528045860.stgit@magnolia>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9047 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=801
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810160028
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When cloning blocks into another file, truncate the page cache before we
start remapping blocks so that concurrent reads wait for us to finish.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 46bbd315c39f..2a5c96bc9677 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4861,14 +4861,12 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
 				  SINGLE_DEPTH_NESTING);
 
-	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
-					 out_bh, pos_out, len);
-
 	/* Zap any page cache for the destination file's range. */
-	if (!ret)
-		truncate_inode_pages_range(&inode_out->i_data, pos_out,
-					   PAGE_ALIGN(pos_out + len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
 
+	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
+					 out_bh, pos_out, len);
 	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
 		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);

