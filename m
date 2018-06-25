Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35900 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751957AbeFYPYt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 11:24:49 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 01B56AC4A
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jun 2018 15:24:48 +0000 (UTC)
Date: Mon, 25 Jun 2018 17:21:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Add graceful handling of V0 extents
Message-ID: <20180625152156.GF27958@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1529915090-11095-1-git-send-email-nborisov@suse.com>
 <1529915090-11095-3-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1529915090-11095-3-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2018 at 11:24:50AM +0300, Nikolay Borisov wrote:
> Following the removal of the v0 handling code let's be courteous and
> print an error message when such extents are handled. In the cases
> where we have a transaction just abort it, otherwise just call
> btrfs_handle_fs_error. Both cases result in the FS being re-mounted RO.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 44 ++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/print-tree.c  | 11 ++++++++---
>  fs/btrfs/relocation.c  | 36 +++++++++++++++++++++++++++++++-----
>  3 files changed, 79 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 4129831523a2..131773528683 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -870,8 +870,17 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
>  			num_refs = btrfs_extent_refs(leaf, ei);
>  			extent_flags = btrfs_extent_flags(leaf, ei);
>  		} else {
> -			BUG();
> +			ret = -EINVAL;
> +			btrfs_err(fs_info,
> +		"Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");

Can you please add a helper that prints the message so there aren't
several different copies of that? Also btrfs_err will add the last '\n',
so it's not needed.
