Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51085 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753495AbdGNQcs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 12:32:48 -0400
Date: Fri, 14 Jul 2017 09:30:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix unexpected return value of bio_readpage_error
Message-ID: <20170714163007.GA10708@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170713220050.22720-1-bo.li.liu@oracle.com>
 <20170714123209.GG2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170714123209.GG2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 14, 2017 at 02:32:09PM +0200, David Sterba wrote:
> On Thu, Jul 13, 2017 at 03:00:50PM -0700, Liu Bo wrote:
> > With blk_status_t, in bio_readpage_error() may return 1 as now
> > ->submit_bio_hook() may not set %ret if it runs without problem.
> 
> Huh, that is pretty subtle, good catch. Also it's good the patch can be
> applied independent of the blk_status_t changes, so I don't need to do 2
> branches and pull requests.
>

Thanks to the ASSERT(ret == -EIO) in end_bio_extent_readpage() ;)

thanks,
-liubo

> > This fixes that unexpected return value by changing
> > btrfs_check_repairable() to return a bool instead of updating %ret.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
