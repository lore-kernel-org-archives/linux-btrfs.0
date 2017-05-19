Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39200 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdESAFB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:05:01 -0400
Date: Thu, 18 May 2017 17:02:33 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: remove root usage from can_overcommit
Message-ID: <20170519000233.GF23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
 <1495035516-3217-3-git-send-email-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495035516-3217-3-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 11:38:36AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> can_overcommit using the root to determine the allocation profile
> is the only use of a root in the call graph below reserve_metadata_bytes.
> 
> It turns out that we only need to know whether the allocation is for
> the chunk root or not -- and we can pass that around as a bool instead.
> 
> This allows us to pull root usage out of the reservation path all the
> way up to reserve_metadata_bytes itself, which uses it only to compare
> against fs_info->chunk_root to set the bool.  In turn, this eliminates
> a bunch of races where we use a particular root too early in the mount
> process.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
