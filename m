Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbeCIPj5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 10:39:57 -0500
Date: Fri, 9 Mar 2018 16:37:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: scrub: batch rebuild for raid56
Message-ID: <20180309153735.GT23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180302231041.10442-1-bo.li.liu@oracle.com>
 <20180307190809.28401-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180307190809.28401-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 07, 2018 at 12:08:09PM -0700, Liu Bo wrote:
> In case of raid56, writes and rebuilds always take BTRFS_STRIPE_LEN(64K)
> as unit, however, scrub_extent() sets blocksize as unit, so rebuild
> process may be triggered on every block on a same stripe.
> 
> A typical example would be that when we're replacing a disappeared disk,
> all reads on the disks get -EIO, every block (size is 4K if blocksize is
> 4K) would go thru these,
> 
> scrub_handle_errored_block
>   scrub_recheck_block # re-read pages one by one
>   scrub_recheck_block # rebuild by calling raid56_parity_recover()
>                         page by page
> 
> Although with raid56 stripe cache most of reads during rebuild can be
> avoided, the parity recover calculation(xor or raid6 algorithms) needs to
> be done $(BTRFS_STRIPE_LEN / blocksize) times.
> 
> This makes it smarter by doing raid56 scrub/replace on stripe length.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: - Place bio allocation in code statement.
>     - Get rid of bio_set_op_attrs.
>     - Add SOB.

Added to next, thanks.
