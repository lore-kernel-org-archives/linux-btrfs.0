Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAB7C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5312084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3Uje2M/4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E5312084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbeJFAVq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:21:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47512 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbeJFAVq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 20:21:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w95HDux6078853;
        Fri, 5 Oct 2018 17:22:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gylwUS/oJEjD1H19Yb/7y7OYmHH+05yEJYmpW1grGXc=;
 b=3Uje2M/4q5DwL/lKHsWUmBdOC8O8Qktu8QcPgPIR83ejSDw5/NarxsOJlqvSBQqVqxdb
 xoeaD04yuqN9WGnw2dyvn7xWfetHkkdEj2wVaQfhOU0Fg7tR/Te5KhTW527pIQWeQo/K
 VO2ipOo67zJQ5wwc/fKMuxbjg4czmdqxP2b9oQOi/ES/LtRTZHyyDMLmEV7zPQF6hpgA
 HEkNopfcYNdYd8tiBtTCt4Qzb1w4kxntvuVB2TsuM3sLTc6axmFU8KB5uA74eVGGPSI4
 ZOQDQomSsoeJU/pAILucpkhFS1qiCB9undD6t6whs3O6A68ddJNJMVdyA/UT+FMmox3L iQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mt21rkyjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 17:22:02 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w95HM1tx017986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 17:22:01 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w95HM0KX003033;
        Fri, 5 Oct 2018 17:22:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 17:22:00 +0000
Date:   Fri, 5 Oct 2018 10:21:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181005172159.GV19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
 <20181005070228.GE12041@dastard>
 <20181005090242.GF12041@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005090242.GF12041@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9037 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050171
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 07:02:42PM +1000, Dave Chinner wrote:
> On Fri, Oct 05, 2018 at 05:02:28PM +1000, Dave Chinner wrote:
> > On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Refactor all the reflink preparation steps into a separate helper that
> > > we'll use to land all the upcoming fixes for insufficient input checks.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > .....
> > 
> > > +xfs_reflink_remap_range(
> > > +	struct file		*file_in,
> > > +	loff_t			pos_in,
> > > +	struct file		*file_out,
> > > +	loff_t			pos_out,
> > > +	u64			len,
> > > +	bool			is_dedupe)
> > > +{
> > > +	struct inode		*inode_in = file_inode(file_in);
> > > +	struct xfs_inode	*src = XFS_I(inode_in);
> > > +	struct inode		*inode_out = file_inode(file_out);
> > > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > > +	struct xfs_mount	*mp = src->i_mount;
> > > +	xfs_fileoff_t		sfsbno, dfsbno;
> > > +	xfs_filblks_t		fsblen;
> > > +	xfs_extlen_t		cowextsize;
> > > +	ssize_t			ret;
> > > +
> > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (XFS_FORCED_SHUTDOWN(mp))
> > > +		return -EIO;
> > > +
> > > +	/* Prepare and then clone file data. */
> > > +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> > > +			len, is_dedupe);
> 
> More than one bug. vfs_clone_file_prep_inodes() modifes the length
> parameter in the case of whole file reflink by way of "len == 0"
> on a non-zero length file. So I fixed this, too.

Did your patch look something like the attached?

--D

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 80ca9b6793cd..53158bdb1105 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1219,6 +1219,7 @@ xfs_reflink_remap_unlock(
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file
  * will be truncated, and any leases on the out file will have been broken.
+ * Returns negative for error, 0 for nothing to do, and 1 for success.
  */
 STATIC int
 xfs_reflink_remap_prep(
@@ -1226,7 +1227,7 @@ xfs_reflink_remap_prep(
 	loff_t			pos_in,
 	struct file		*file_out,
 	loff_t			pos_out,
-	u64			len,
+	u64			*len,
 	bool			is_dedupe)
 {
 	struct inode		*inode_in = file_inode(file_in);
@@ -1257,7 +1258,7 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep_inodes(inode_in, pos_in, inode_out, pos_out,
-			&len, is_dedupe);
+			len, is_dedupe);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -1284,8 +1285,8 @@ xfs_reflink_remap_prep(
 
 	/* Zap any page cache for the destination file's range. */
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + len) - 1);
-	return 0;
+				   PAGE_ALIGN(pos_out + *len) - 1);
+	return 1;
 out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	return ret;
@@ -1321,8 +1322,8 @@ xfs_reflink_remap_range(
 
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
-			len, is_dedupe);
-	if (ret)
+			&len, is_dedupe);
+	if (ret <= 0)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
