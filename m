Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbeCIGmp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 01:42:45 -0500
Date: Thu, 8 Mar 2018 22:40:01 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: replace: cache rbio when rebuild data on missing
 device
Message-ID: <20180309054001.GF26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20180302231041.10442-2-bo.li.liu@oracle.com>
 <20180306112818.GN5942@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180306112818.GN5942@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 12:28:18PM +0100, David Sterba wrote:
> On Fri, Mar 02, 2018 at 04:10:38PM -0700, Liu Bo wrote:
> > Rebuild on missing device is as same as recover, after it's done, rbio
> > has data which is consistent with on-disk data, so it can be cached to
> > avoid further reads.
> 
> Please add a comment that describes why the READ and REBUILD can be
> merged together, it's not obvious from the code.

Will update it.

Thanks,

-liubo
