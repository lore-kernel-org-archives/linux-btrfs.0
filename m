Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbdLEStX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:49:23 -0500
Date: Tue, 5 Dec 2017 19:47:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use struct completion in
 scrub_submit_raid56_bio_wait
Message-ID: <20171205184724.GS3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171201002639.32257-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171201002639.32257-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 30, 2017 at 05:26:39PM -0700, Liu Bo wrote:
> This changes to use struct completion directly and removes 'struct
> scrub_bio_ret' along with the code using it.
> 
> This struct is used to get the return value from bio, but the caller
> can access bio to get the return value directly and is holding a
> reference on bio so that it won't go away underneath us.  So it can be
> removed safely.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
