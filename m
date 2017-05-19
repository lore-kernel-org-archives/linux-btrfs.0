Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30335 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932232AbdESA2G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 20:28:06 -0400
Date: Thu, 18 May 2017 17:25:53 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/10] btrfs: scrub: simplify cleanup of wr_ctx in
 scrub_free_ctx
Message-ID: <20170519002552.GJ23822@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1494954480.git.dsterba@suse.com>
 <d14a9943b4c755604d3021c8af1377723667b6ad.1494954480.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d14a9943b4c755604d3021c8af1377723667b6ad.1494954480.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 16, 2017 at 07:10:29PM +0200, David Sterba wrote:
> We don't need to take the mutex and zero out wr_cur_bio, as this is
> called after the scrub finished.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
