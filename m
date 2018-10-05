Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657D8C64EB8
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2644A20854
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 00:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i6aosBwS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2644A20854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbeJEHlf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 03:41:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbeJEHlf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 03:41:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w950iVEM029876;
        Fri, 5 Oct 2018 00:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=x6ivzaw8mbMiuZConVGRUTSdhq9SHZfIoaCE5s+1BsQ=;
 b=i6aosBwSSSmQH6kXDBH5GBvhdhhJoqeSb09xmyyHydPAwsk33RmzBiJJPWg2+DtI5bty
 faVWQapUxLOPXUM6dHm9dwiVEenGC20rIhMi34WZIYIMxBgKw0Z8TY/4u7rjJ53cIT44
 7G6l2ERvCDA7hIijAj1Wj2C5QKENd0WJe6HmJD/OkDU/7irU0U9LNy/Lz293DmfqoyR0
 1FRP7I0ZQ/v3yxwT/MPOPgcReB+mXfGQsDDZZ43CknfWoG9Yzt9EFIqDIv2c3xcYDurX
 DG3kG8q2ICrPn7fE8bSpOPy/rC24YXBn6a2uvi44XPus9Kc2oMqytJatGQmctBlxmAPw oA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2mt0tu7nfr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 00:45:23 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w950jHeS004944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 00:45:17 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w950jG76019480;
        Fri, 5 Oct 2018 00:45:16 GMT
Received: from localhost (/10.159.229.198)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 00:45:16 +0000
Subject: [PATCH 06/15] vfs: strengthen checking of file range inputs to
 clone/dedupe range
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     david@fromorbit.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Date:   Thu, 04 Oct 2018 17:45:15 -0700
Message-ID: <153870031519.29072.18289185889660082318.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9036 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050006
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Clone range is an optimization on a regular file write.  File writes
that extend the file length are subject to various constraints which are
not checked by clonerange.  This is a correctness problem, because we're
never allowed to touch ranges that the page cache can't support
(s_maxbytes); we're not supposed to deal with large offsets
(MAX_NON_LFS) if O_LARGEFILE isn't set; and we must obey resource limits
(RLIMIT_FSIZE).

Therefore, add these checks to the new generic_clone_checks function so
that we curtail unexpected behavior.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mm/filemap.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)


diff --git a/mm/filemap.c b/mm/filemap.c
index 68ec91d05c7b..f74391721234 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3015,6 +3015,37 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
 		return -EINVAL;
 	count = min(count, size_in - (uint64_t)pos_in);
 
+	/* Don't exceed RLMIT_FSIZE in the file we're writing into. */
+	if (limit != RLIM_INFINITY) {
+		if (pos_out >= limit) {
+			send_sig(SIGXFSZ, current, 0);
+			return -EFBIG;
+		}
+		count = min(count, limit - (uint64_t)pos_out);
+	}
+
+	/* Don't exceed the LFS limits. */
+	if (unlikely(pos_out + count > MAX_NON_LFS &&
+				!(file_out->f_flags & O_LARGEFILE))) {
+		if (pos_out >= MAX_NON_LFS)
+			return -EFBIG;
+		count = min(count, MAX_NON_LFS - (uint64_t)pos_out);
+	}
+	if (unlikely(pos_in + count > MAX_NON_LFS &&
+				!(file_in->f_flags & O_LARGEFILE))) {
+		if (pos_in >= MAX_NON_LFS)
+			return -EFBIG;
+		count = min(count, MAX_NON_LFS - (uint64_t)pos_in);
+	}
+
+	/* Don't operate on ranges the page cache doesn't support. */
+	if (unlikely(pos_out >= inode_out->i_sb->s_maxbytes ||
+		     pos_in >= inode_in->i_sb->s_maxbytes))
+		return -EFBIG;
+
+	count = min(count, inode_out->i_sb->s_maxbytes - (uint64_t)pos_out);
+	count = min(count, inode_in->i_sb->s_maxbytes - (uint64_t)pos_in);
+
 	/*
 	 * If the user wanted us to link to the infile's EOF, round up to the
 	 * next block boundary for this check.

