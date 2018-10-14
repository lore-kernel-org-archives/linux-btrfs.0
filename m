Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51407C71122
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 23:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2042D2086A
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 23:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2042D2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbeJOGsQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 02:48:16 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3991 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726347AbeJOGsQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 02:48:16 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail07.adl2.internode.on.net with ESMTP; 15 Oct 2018 09:35:37 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gBpS4-0000XM-3h; Mon, 15 Oct 2018 10:05:36 +1100
Date:   Mon, 15 Oct 2018 10:05:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 24/25] xfs: support returning partial reflink results
Message-ID: <20181014230536.GY6311@dastard>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938931226.8361.7365948775364411156.stgit@magnolia>
 <20181014173546.GI30673@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014173546.GI30673@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 14, 2018 at 10:35:46AM -0700, Christoph Hellwig wrote:
> On Fri, Oct 12, 2018 at 05:08:32PM -0700, Darrick J. Wong wrote:
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
> >  fs/xfs/xfs_reflink.c |   20 +++++++++++++++-----
> >  fs/xfs/xfs_reflink.h |    2 +-
> >  3 files changed, 17 insertions(+), 10 deletions(-)
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
> 
> Is there any reason not to merge xfs_file_remap_range and
> xfs_reflink_remap_range at this point?

Yeah, that seems like a good idea to me - pulling all the
vfs/generic code interactions back up into xfs_file.c would match
how the rest of the file operations are layered w.r.t. external and
internal XFS code...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
