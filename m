Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B4AC67872
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D155221473
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 16:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p55tBDi9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D155221473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbeJLXju (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:39:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48104 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbeJLXjt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 19:39:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9CG4pLr070398;
        Fri, 12 Oct 2018 16:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Xoz00B0stVWLO2UYYHLKzd2WlkfcOw2dkus8eNVrSrM=;
 b=p55tBDi9+53SvMP8zpA829krOCJZHOnK+uQjaBgsNrmuA87NIDEXfIzSxGDcpufEMMWA
 IxH0OJGfSjIPR8NBxwlK+Zkyz+BRWYjXJYjLi977tE1yM6fTgR9M+cXbjpIWkvIea/df
 mLi/R1sxHTOsnT1KF+9pFeuSwnPVDHKVG24+lT3x76/OgODl25HA7szqRlK4XhSmdPwT
 zSa8l3F5zs+3Gz1K38laJbAgL3BonwO4Bas5eDSq1JFFhD8qeOk9ogjrvZxZ9pf0XgIm
 M4uiMnOutdk5qhf7Sr/7LbVB7INRoWh6BCuGVdv2EK8Yy6QLoZi1z1N7AbGvK9WMMgn5 bg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mxnprkcrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Oct 2018 16:06:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9CG6XgP019024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Oct 2018 16:06:33 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9CG6WVO030953;
        Fri, 12 Oct 2018 16:06:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Oct 2018 16:06:32 +0000
Date:   Fri, 12 Oct 2018 09:06:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 24/25] xfs: support returning partial reflink results
Message-ID: <20181012160630.GE28243@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923131946.5546.5209673711907751253.stgit@magnolia>
 <20181012012226.GT6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012012226.GT6311@dastard>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9043 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810120157
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 12:22:26PM +1100, Dave Chinner wrote:
> On Wed, Oct 10, 2018 at 09:15:19PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Back when the XFS reflink code only supported clone_file_range, we were
> > only able to return zero or negative error codes to userspace.  However,
> > now that copy_file_range (which returns bytes copied) can use XFS'
> > clone_file_range, we have the opportunity to return partial results.
> > For example, if userspace sends a 1GB clone request and we run out of
> > space halfway through, we at least can tell userspace that we completed
> > 512M of that request like a regular write.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_file.c    |    5 +----
> >  fs/xfs/xfs_reflink.c |   19 ++++++++++++++-----
> >  fs/xfs/xfs_reflink.h |    2 +-
> >  3 files changed, 16 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index bc9e94bcb7a3..b2b15b8dc4a1 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -928,14 +928,11 @@ xfs_file_remap_range(
> >  	loff_t		len,
> >  	unsigned int	remap_flags)
> >  {
> > -	int		ret;
> > -
> >  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> >  		return -EINVAL;
> >  
> > -	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > +	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> >  			len, remap_flags);
> > -	return ret < 0 ? ret : len;
> >  }
> >  
> >  STATIC int
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index e1592e751cc2..12a1fe92454e 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -1123,6 +1123,7 @@ xfs_reflink_remap_blocks(
> >  	struct xfs_inode	*dest,
> >  	xfs_fileoff_t		destoff,
> >  	xfs_filblks_t		len,
> > +	xfs_filblks_t		*remapped,
> >  	xfs_off_t		new_isize)
> >  {
> >  	struct xfs_bmbt_irec	imap;
> > @@ -1130,6 +1131,7 @@ xfs_reflink_remap_blocks(
> >  	int			error = 0;
> >  	xfs_filblks_t		range_len;
> >  
> > +	*remapped = 0;
> >  	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
> >  	while (len) {
> >  		uint		lock_mode;
> > @@ -1168,6 +1170,7 @@ xfs_reflink_remap_blocks(
> >  		srcoff += range_len;
> >  		destoff += range_len;
> >  		len -= range_len;
> > +		*remapped += range_len;
> >  	}
> 
> So "remapped" is a block count? Can we call this something like
> remap_len so it's obvious what it is tracking?

Ok.

> > @@ -1424,11 +1427,17 @@ xfs_reflink_remap_range(
> >  
> >  	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
> >  
> > +	if (len == 0) {
> > +		ret = 0;
> > +		goto out_unlock;
> > +	}
> > +
> >  	dfsbno = XFS_B_TO_FSBT(mp, pos_out);
> >  	sfsbno = XFS_B_TO_FSBT(mp, pos_in);
> >  	fsblen = XFS_B_TO_FSB(mp, len);
> >  	ret = xfs_reflink_remap_blocks(src, sfsbno, dest, dfsbno, fsblen,
> > -			pos_out + len);
> > +			&remapped, pos_out + len);
> > +	remapped = min_t(int64_t, len, XFS_FSB_TO_B(mp, remapped));
> 
> So remapped is returned as a block count, then immediately converted
> to a byte count? Can we return it as byte count so that we don't
> have this weird unit conversion?

But then we'd have a function whose inputs are in units of blocks but
whose return value is in units of bytes.

Maybe I'll just do this to make it more explicit:

xfs_filblks_t	remapped_blocks = 0;
loff_t		remapped_bytes = 0;

ret = xfs_reflink_remap_blocks(..., &remapped_blocks...);
remapped_bytes = min_t(int64_t, len, XFS_FSB_TO_B(mp, remapped_blocks));

...

return remapped_bytes > 0 ? remapped_bytes : ret;

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
