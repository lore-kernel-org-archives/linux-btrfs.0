Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51643 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbcJKOZr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 10:25:47 -0400
Date: Tue, 11 Oct 2016 16:25:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2] Btrfs: kill BUG_ON in do_relocation
Message-ID: <20161011142525.GO11398@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1473870467-18721-1-git-send-email-bo.li.liu@oracle.com>
 <1474664704-2612-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474664704-2612-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2016 at 02:05:04PM -0700, Liu Bo wrote:
> While updating btree, we try to push items between sibling
> nodes/leaves in order to keep height as low as possible.
> But we don't memset the original places with zero when
> pushing items so that we could end up leaving stale content
> in nodes/leaves.  One may read the above stale content by
> increasing btree blocks' @nritems.
> 
> One case I've come across is that in fs tree, a leaf has two
> parent nodes, hence running balance ends up with processing
> this leaf with two parent nodes, but it can only reach the
> valid parent node through btrfs_search_slot, so it'd be like,
> 
> do_relocation
>     for P in all parent nodes of block A:
>         if !P->eb:
>             btrfs_search_slot(key);   --> get path from P to A.
>         if lowest:
>             BUG_ON(A->bytenr != bytenr of A recorded in P);
>         btrfs_cow_block(P, A);   --> change A's bytenr in P.
> 
> After btrfs_cow_block, P has the new bytenr of A, but with the
> same @key, we get the same path again, and get panic by BUG_ON.
> 
> Note that this is only happening in a corrupted fs, for a
> regular fs in which we have correct @nritems so that we won't
> read stale content in any case.
> 
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> v2: - use new internal error EFSCORRUPTED as "Filesystem is corrupted",
>       suggested by David Sterba.

Sorry I steered it to EFSCORRUPTED, we should introduce the error code
separately and audit the call chains. I'll drop the parts and change it
back to EIO.
