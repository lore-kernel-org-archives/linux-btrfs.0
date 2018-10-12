Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B8AC67837
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A38472086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 01:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A38472086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbeJLIpt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 04:45:49 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44572 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726108AbeJLIpt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 04:45:49 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl2.internode.on.net with ESMTP; 12 Oct 2018 11:45:54 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gAm3V-0004yK-HL; Fri, 12 Oct 2018 12:15:53 +1100
Date:   Fri, 12 Oct 2018 12:15:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 23/25] xfs: fix pagecache truncation prior to reflink
Message-ID: <20181012011553.GS6311@dastard>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
 <153923131273.5546.6811645962559576222.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153923131273.5546.6811645962559576222.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 09:15:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Prior to remapping blocks, it is necessary to remove pages from the
> destination file's page cache.  Unfortunately, the truncation is not
> aggressive enough -- if page size > block size, we'll end up zeroing
> subpage blocks instead of removing them.  So, round the start offset
> down and the end offset up to page boundaries.  We already wrote all
> the dirty data so the larger range shouldn't be a problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index b24a2a1c4db1..e1592e751cc2 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1370,8 +1370,9 @@ xfs_reflink_remap_prep(
>  		goto out_unlock;
>  
>  	/* Zap any page cache for the destination file's range. */
> -	truncate_inode_pages_range(&inode_out->i_data, pos_out,
> -				   PAGE_ALIGN(pos_out + *len) - 1);
> +	truncate_inode_pages_range(&inode_out->i_data,
> +			round_down(pos_out, PAGE_SIZE),
> +			round_up(pos_out + *len, PAGE_SIZE) - 1);

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
