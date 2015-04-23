Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966153AbbDWQ0z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 12:26:55 -0400
Date: Thu, 23 Apr 2015 18:26:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH] btrfs: Add extra check for sub_stripes to avoid hostile
 0 division attack.
Message-ID: <20150423162653.GM4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 11:00:45AM +0800, Qu Wenruo wrote:
> Although only RAID10 use sub_stripes, a hostile attack can modify chunk
> tree and just add RAID10 bit to a single chunk.
> Then btrfs_map_block will trigger a 0 division in kernel and destroy
> everything.
> 
> Just add extra check when reading chunk from disk.
> 
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8222f6f..a764726 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6061,6 +6061,14 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>  	map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>  	map->type = btrfs_chunk_type(leaf, chunk);
>  	map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> +
> +	/* Add extra check to avoid hostile 0 division attack */
> +	if (map->type & BTRFS_BLOCK_GROUP_RAID10 &&
> +	    map->sub_stripes == 0) {
> +		free_extent_map(em);

That would deserve an error message, we get a lot of
> +		return -EINVAL;

-EIO to be consistent with the other errors during mount. EINVAL is for
user-specified arguments, while EIO is for "read from device".

Otherwise looks good, thanks.
