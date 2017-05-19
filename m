Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43064 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754777AbdESAVu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:21:50 -0400
Date: Thu, 18 May 2017 17:20:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org, "# v3 . 14+" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix memory leak in update_space_info failure path
Message-ID: <20170519002006.GI23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170517134937.30774-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517134937.30774-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 09:49:37AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> If we fail to add the space_info kobject, we'll leak the memory
> for the percpu counter.
> 
> Fixes: 6ab0a2029c (btrfs: publish allocation data in sysfs)
> Cc: <stable@vger.kernel.org> # v3.14+
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
