Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E8EBC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6B621568
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 00:36:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD6B621568
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeJJH4Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 03:56:24 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17632 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725766AbeJJH4Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 03:56:24 -0400
Received: from ppp59-167-129-252.static.internode.on.net (HELO dastard) ([59.167.129.252])
  by ipmail06.adl6.internode.on.net with ESMTP; 10 Oct 2018 11:06:53 +1030
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gA2Ud-0001sf-Ux; Wed, 10 Oct 2018 11:36:52 +1100
Date:   Wed, 10 Oct 2018 11:36:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 01/25] xfs: add a per-xfs trace_printk macro
Message-ID: <20181010003651.GH6311@dastard>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913024554.32295.8692450593333636905.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153913024554.32295.8692450593333636905.stgit@magnolia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 05:10:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a "xfs_tprintk" macro so that developers can use trace_printk to
> print out arbitrary debugging information with the XFS device name
> attached to the trace output.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_error.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 246d3e989c6c..c3d9546b138c 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -99,4 +99,9 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
>  #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
>  
> +/* trace printk version of xfs_err and friends */
> +#define xfs_tprintk(mp, fmt, args...) \
> +	trace_printk("dev %d:%d " fmt, MAJOR((mp)->m_super->s_dev), \
> +			MINOR((mp)->m_super->s_dev), ##args)
> +
>  #endif	/* __XFS_ERROR_H__ */

Not convinced this is a good idea.  How are you going to ensure code
calling this trace point is not committed?

If we decide to add this, it needs to be a CONFIG_XFS_DEBUG=y only
definition because trace_printk() is only for temporary debugging
code and has substantial performance overheads even when these trace
points are not being traced.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
