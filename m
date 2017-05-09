Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51287 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754700AbdEITQk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 15:16:40 -0400
Date: Tue, 9 May 2017 12:14:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Matt McKinnon <matt@techsquare.com>
Cc: pg@btrfs.list.sabi.co.UK, linux-btrfs@vger.kernel.org
Subject: Re: Struggling with file system slowness
Message-ID: <20170509191444.GE17312@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <22795.14626.978819.534566@tree.ty.sabi.co.uk>
 <f1bbe501-0897-c8e0-36ff-2f4cf005fa45@techsquare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f1bbe501-0897-c8e0-36ff-2f4cf005fa45@techsquare.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 09:24:32AM -0400, Matt McKinnon wrote:
> > Too little information. Is IO happening at the same time? Is
> > compression on? Deduplicated? Lots of subvolumes? SSD? What
> > kind of workload and file size/distribution profile?
> 
> Only write IO during the load spikes.  No compression, no deduplication.  12
> volumes (including snapshots).  Spinning disks.  Medium workload; file sizes
> are all over the map since this hold about 30 user home directories.
> 
> Interestingly enough, the problems which had persisted for many weeks went
> away when all snapshots were removed.  btrfs-transaction spikes disappeared.
> Memory usage went from 30G to under 2G.
>

Were those snapshots served as backup?

Could you please elaborate how you create snapshots?  We could
probably hammer out a testcase to improve the situation.

Thanks,

-liubo
