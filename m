Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39563 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdIMRql (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 13:46:41 -0400
Date: Wed, 13 Sep 2017 10:45:11 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] Btrfs: make plug in writing meta blocks
 really work
Message-ID: <20170913164510.GB22943@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20170821215000.2987-1-bo.li.liu@oracle.com>
 <20170913155155.GP29043@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170913155155.GP29043@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 05:51:55PM +0200, David Sterba wrote:
> On Mon, Aug 21, 2017 at 03:49:59PM -0600, Liu Bo wrote:
> > We have started plug in btrfs_write_and_wait_marked_extents() but the
> > generated IOs actually go to device's schedule IO list where the work
> > is doing in another task, thus the started plug doesn't make any
> > sense.
> > 
> > And since we wait for IOs immediately after writing meta blocks, it's
> > the same case as writing log tree, doing sync submit can merge more
> > IOs.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
> The original patch c6adc9cc082e3 adds too many randomly scattered
> blg_plugs that, we could use some high-level comments about the purpose.

The commit log of that patch wasn't explaining well why the old way is
not efficient, in most cases, cow'd metadata blocks in the log tree
and the log root tree are contiguous on disk, so putting a blk_plug
pair can merge writes on those meta blocks so that we could get better
performance out of it.

And yes, adding comments mentioning the reason will be helpful.

Thanks,

-liubo
