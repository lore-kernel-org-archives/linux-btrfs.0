Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1F6C65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3992B20834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 17:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="5l4jF6re"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3992B20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbeJFAGh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 20:06:37 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49778 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbeJFAGh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 20:06:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w95GsO8x107542;
        Fri, 5 Oct 2018 17:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=qJCavRDAVIOxVXoOQKLmASoIdfhTayUWHXQlwaHjs8g=;
 b=5l4jF6rexMaVgknwBnvyT1WwiRf5mti1fRvlq3pQy3pUc12HJ5oYTTh3BMM0ajwzKP1u
 NnIEH/5m694HfarubGRhnKojTeCUQHTSCukyki7KgAt05HNf/T2MI9pjsFnvdQz0Ymin
 oW8uAHwSKg6nZeHUVj5XwH3mY7EfNiaf1JN3Gpc0gBVdDXyYV0PprrnsNHk5Ke3J3yGk
 zQMWx7h3bry8Qs/nKmrwRwL7t6nSe108ZxUpEJu+3lpUTihtlzqCTh7YC1YRyiOHjv8J
 O07z82n7fA89eBmDLwcWPehsFI5uBrJ5gvVwGHIadLT9Zr+hoQ0mEctYL93FJMkdp6fL +w== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mt1bqkxfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Oct 2018 17:06:56 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w95H6t4a032316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Oct 2018 17:06:55 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w95H6sNH015705;
        Fri, 5 Oct 2018 17:06:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Oct 2018 17:06:54 +0000
Date:   Fri, 5 Oct 2018 10:06:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181005170652.GT19324@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
 <20181005052809.GB12041@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005052809.GB12041@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9037 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810050169
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 03:28:09PM +1000, Dave Chinner wrote:
> On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor all the reflink preparation steps into a separate helper that
> > we'll use to land all the upcoming fixes for insufficient input checks.
> 
> If I've read the patch right, this also changes the location of the
> page cache truncation, right?  i.e. it now happens in the
> xfs_reflink_remap_prep() function instead of after the remap?  I
> think the commit message needs to mention that because it's a fix to
> incorrect behaviour....

Right.  Sorry I forgot to put that in the changelog.

> I've added:
> 
> --
> This rework also moves the invalidation of the destination range to
> the prep function so that it is done before the range is remapped.
> This ensures that nobody can access the data in range being remapped
> until the remap is complete.
> --
> 
> Sound OK?

Yep.

--D


> Otherwise this looks fine.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -Dave.
> 
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_reflink.c |   96 +++++++++++++++++++++++++++++++++++++-------------
> >  1 file changed, 71 insertions(+), 25 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 38f405415b88..80ca9b6793cd 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1195,11 +1195,33 @@ xfs_iolock_two_inodes_and_break_layout(
> >  	return 0;
> >  }
> >  
> > +/* Unlock both inodes after they've been prepped for a range clone. */
> > +STATIC void
> > +xfs_reflink_remap_unlock(
> > +	struct file		*file_in,
> > +	struct file		*file_out)
> > +{
> > +	struct inode		*inode_in = file_inode(file_in);
> > +	struct xfs_inode	*src = XFS_I(inode_in);
> > +	struct inode		*inode_out = file_inode(file_out);
> > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > +	bool			same_inode = (inode_in == inode_out);
> > +
> > +	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> > +	if (!same_inode)
> > +		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
> > +	inode_unlock(inode_out);
> > +	if (!same_inode)
> > +		inode_unlock_shared(inode_in);
> > +}
> > +
> >  /*
> > - * Link a range of blocks from one file to another.
> > + * Prepare two files for range cloning.  Upon a successful return both inodes
> > + * will have the iolock and mmaplock held, the page cache of the out file
> > + * will be truncated, and any leases on the out file will have been broken.
> >   */
> > -int
> > -xfs_reflink_remap_range(
> > +STATIC int
> > +xfs_reflink_remap_prep(
> >  	struct file		*file_in,
> >  	loff_t			pos_in,
> >  	struct file		*file_out,
> > @@ -1211,19 +1233,9 @@ xfs_reflink_remap_range(
> >  	struct xfs_inode	*src = XFS_I(inode_in);
> >  	struct inode		*inode_out = file_inode(file_out);
> >  	struct xfs_inode	*dest = XFS_I(inode_out);
> > -	struct xfs_mount	*mp = src->i_mount;
> >  	bool			same_inode = (inode_in == inode_out);
> > -	xfs_fileoff_t		sfsbno, dfsbno;
> > -	xfs_filblks_t		fsblen;
> > -	xfs_extlen_t		cowextsize;
> >  	ssize_t			ret;
> >  
> > -	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > -		return -EOPNOTSUPP;
> > -
> > -	if (XFS_FORCED_SHUTDOWN(mp))
> > -		return -EIO;
> > -
> >  	/* Lock both files against IO */
> >  	ret = xfs_iolock_two_inodes_and_break_layout(inode_in, inode_out);
> >  	if (ret)
> > @@ -1254,8 +1266,6 @@ xfs_reflink_remap_range(
> >  	if (ret)
> >  		goto out_unlock;
> >  
> > -	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> > -
> >  	/*
> >  	 * Clear out post-eof preallocations because we don't have page cache
> >  	 * backing the delayed allocations and they'll never get freed on
> > @@ -1272,6 +1282,51 @@ xfs_reflink_remap_range(
> >  	if (ret)
> >  		goto out_unlock;
> >  
> > +	/* Zap any page cache for the destination file's range. */
> > +	truncate_inode_pages_range(&inode_out->i_data, pos_out,
> > +				   PAGE_ALIGN(pos_out + len) - 1);
> > +	return 0;
> > +out_unlock:
> > +	xfs_reflink_remap_unlock(file_in, file_out);
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Link a range of blocks from one file to another.
> > + */
> > +int
> > +xfs_reflink_remap_range(
> > +	struct file		*file_in,
> > +	loff_t			pos_in,
> > +	struct file		*file_out,
> > +	loff_t			pos_out,
> > +	u64			len,
> > +	bool			is_dedupe)
> > +{
> > +	struct inode		*inode_in = file_inode(file_in);
> > +	struct xfs_inode	*src = XFS_I(inode_in);
> > +	struct inode		*inode_out = file_inode(file_out);
> > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > +	struct xfs_mount	*mp = src->i_mount;
> > +	xfs_fileoff_t		sfsbno, dfsbno;
> > +	xfs_filblks_t		fsblen;
> > +	xfs_extlen_t		cowextsize;
> > +	ssize_t			ret;
> > +
> > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (XFS_FORCED_SHUTDOWN(mp))
> > +		return -EIO;
> > +
> > +	/* Prepare and then clone file data. */
> > +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> > +			len, is_dedupe);
> > +	if (ret)
> > +		return ret;
> > +
> > +	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> > +
> >  	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
> >  	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
> >  	fsblen = XFS_B_TO_FSB(mp, len);
> > @@ -1280,10 +1335,6 @@ xfs_reflink_remap_range(
> >  	if (ret)
> >  		goto out_unlock;
> >  
> > -	/* Zap any page cache for the destination file's range. */
> > -	truncate_inode_pages_range(&inode_out->i_data, pos_out,
> > -				   PAGE_ALIGN(pos_out + len) - 1);
> > -
> >  	/*
> >  	 * Carry the cowextsize hint from src to dest if we're sharing the
> >  	 * entire source file to the entire destination file, the source file
> > @@ -1300,12 +1351,7 @@ xfs_reflink_remap_range(
> >  			is_dedupe);
> >  
> >  out_unlock:
> > -	xfs_iunlock(dest, XFS_MMAPLOCK_EXCL);
> > -	if (!same_inode)
> > -		xfs_iunlock(src, XFS_MMAPLOCK_SHARED);
> > -	inode_unlock(inode_out);
> > -	if (!same_inode)
> > -		inode_unlock_shared(inode_in);
> > +	xfs_reflink_remap_unlock(file_in, file_out);
> >  	if (ret)
> >  		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
> >  	return ret;
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
