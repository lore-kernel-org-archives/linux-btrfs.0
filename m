Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E09C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 23:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355C2208E7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 23:42:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 355C2208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbeJFGng (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Oct 2018 02:43:36 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:59950 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbeJFGng (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Oct 2018 02:43:36 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 06 Oct 2018 09:12:34 +0930
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1g8Zjt-0004Lp-3Y; Sat, 06 Oct 2018 09:42:33 +1000
Date:   Sat, 6 Oct 2018 09:42:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        sandeen@redhat.com
Subject: Re: [PATCH 02/15] xfs: refactor clonerange preparation into a
 separate helper
Message-ID: <20181005234233.GK12041@dastard>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870028762.29072.5369530877410002226.stgit@magnolia>
 <20181005070228.GE12041@dastard>
 <20181005090242.GF12041@dastard>
 <20181005172159.GV19324@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005172159.GV19324@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 05, 2018 at 10:21:59AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 05, 2018 at 07:02:42PM +1000, Dave Chinner wrote:
> > On Fri, Oct 05, 2018 at 05:02:28PM +1000, Dave Chinner wrote:
> > > On Thu, Oct 04, 2018 at 05:44:47PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Refactor all the reflink preparation steps into a separate helper that
> > > > we'll use to land all the upcoming fixes for insufficient input checks.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > .....
> > > 
> > > > +xfs_reflink_remap_range(
> > > > +	struct file		*file_in,
> > > > +	loff_t			pos_in,
> > > > +	struct file		*file_out,
> > > > +	loff_t			pos_out,
> > > > +	u64			len,
> > > > +	bool			is_dedupe)
> > > > +{
> > > > +	struct inode		*inode_in = file_inode(file_in);
> > > > +	struct xfs_inode	*src = XFS_I(inode_in);
> > > > +	struct inode		*inode_out = file_inode(file_out);
> > > > +	struct xfs_inode	*dest = XFS_I(inode_out);
> > > > +	struct xfs_mount	*mp = src->i_mount;
> > > > +	xfs_fileoff_t		sfsbno, dfsbno;
> > > > +	xfs_filblks_t		fsblen;
> > > > +	xfs_extlen_t		cowextsize;
> > > > +	ssize_t			ret;
> > > > +
> > > > +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> > > > +		return -EOPNOTSUPP;
> > > > +
> > > > +	if (XFS_FORCED_SHUTDOWN(mp))
> > > > +		return -EIO;
> > > > +
> > > > +	/* Prepare and then clone file data. */
> > > > +	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
> > > > +			len, is_dedupe);
> > 
> > More than one bug. vfs_clone_file_prep_inodes() modifes the length
> > parameter in the case of whole file reflink by way of "len == 0"
> > on a non-zero length file. So I fixed this, too.
> 
> Did your patch look something like the attached?

Identical. I folded it back in once it tested ok, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
