Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38681 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754372AbeAKTmM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:42:12 -0500
Date: Thu, 11 Jan 2018 20:40:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: return 0 for success in
 btrfs_alloc_data_chunk_ondemand
Message-ID: <20180111194003.GW13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515603334-21423-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 10, 2018 at 11:55:34AM -0500, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> My delayed refs rsv patches uncovered a problem in
> btrfs_alloc_data_chunk_ondemand where we don't clear ret before
> returning, so we could have whatever left over value we had from trying
> to do a chunk allocation or whatever that may have failed.  Since we
> know we've succeeded at this point just unconditionally return 0.  This
> fixed the xfstests failures I was seeing with my delayed refs rsv
> patches.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index dbae25d882de..33c9efbfc9a7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4387,8 +4387,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
>  	trace_btrfs_space_reservation(fs_info, "space_info",
>  				      data_sinfo->flags, bytes, 1);
>  	spin_unlock(&data_sinfo->lock);
> -
> -	return ret;
> +	return 0;

I don't think this is the right way to fix it. The return code of
do_chunk_alloc depends on the force parameter, and in case it's
CHUNK_ALLOC_NO_FORCE the caller should handle all the possibilities, ie.
negative/0/positive. Other callers do that, so I'd rather see it fixed
right after do_chunk_alloc and not forcing 0.
