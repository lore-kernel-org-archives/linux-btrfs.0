Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45223 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752489AbeCVOQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 10:16:02 -0400
Date: Thu, 22 Mar 2018 15:13:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2] Btrfs: replace: cache rbio when rebuild data on
 missing device
Message-ID: <20180322141336.GC6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302231041.10442-2-bo.li.liu@oracle.com>
 <1521681611-108404-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521681611-108404-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 22, 2018 at 09:20:11AM +0800, Liu Bo wrote:
> Rebuild on missing device is as same as recover, after it's done, rbio
> has data which is consistent with on-disk data, so it can be cached to
> avoid further reads.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>

Added to next, thanks.
