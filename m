Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36587 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762950AbcLTSBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 13:01:01 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C092FAAB9
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Dec 2016 18:00:59 +0000 (UTC)
Date: Tue, 20 Dec 2016 19:00:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix error handling when run_delayed_extent_op
 fails
Message-ID: <20161220180045.GR3620@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cbbf1064-dc95-b1e2-94d9-b3b2879913d8@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cbbf1064-dc95-b1e2-94d9-b3b2879913d8@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 13, 2016 at 02:33:33PM -0500, Jeff Mahoney wrote:
> In __btrfs_run_delayed_refs, the error path when run_delayed_extent_op
> fails sets locked_ref->processing = 0 but doesn't re-increment
> delayed_refs->num_heads_ready.  As a result, we can end up triggering
> the WARN_ON in btrfs_select_ref_head since the head remains in the tree
> with ->processing = 0 and the ready count is off.
> 
> Fixes: d7df2c796d7 (Btrfs: attach delayed ref updates to delayed ref heads)
> Reported-by: Jon Nelson <jnelson-suse@jamponi.net>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4607af3..73a8d31 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2588,6 +2588,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  					if (must_insert_reserved)
>  						locked_ref->must_insert_reserved = 1;
>  					locked_ref->processing = 0;
> +					delayed_refs->num_heads_ready++;

I think this requires spin lock/unlock around the increment, as do other
similar places that fixup num_heads_ready after previous error.
