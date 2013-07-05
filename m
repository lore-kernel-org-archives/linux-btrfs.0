Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34453 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab3GEU3V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 16:29:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 623D39A0695
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 14:29:21 -0600 (MDT)
Date: Fri, 5 Jul 2013 16:29:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs-progs: fix optimization in
 btrfs_lookup_extent_info
Message-ID: <20130705202918.GF2260@localhost.localdomain>
References: <1372952919-21010-1-git-send-email-fdmanana@gmail.com>
 <1372955049-5051-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1372955049-5051-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 04, 2013 at 05:24:09PM +0100, Filipe David Borba Manana wrote:
> If we did a tree search with the goal to find a metadata item
> but the search failed with return value 1, we attempt to see
> if in the same leaf there's a corresponding extent item, and if
> there's one, just use it instead of doing another tree search
> for this extent item. The check in the leaf was wrong because
> it was seeking for a metadata item instead of an extent item.
> 
> This optimization was also being triggered incorrectly, as it
> was evaluating path->slots which always evaluates to true. The
> goal was to see if the leaf level slot was greater than zero
> (i.e. not the first item in the leaf).
> 
> V2: If previous leaf item is for a different object, ensure the
> search key has the target object id.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  extent-tree.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index b0cfe0a..875dea9 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1515,17 +1515,19 @@ again:
>  	 * to make sure.
>  	 */
>  	if (ret > 0 && metadata) {
> -		if (path->slots) {
> +		if (path->slots[0]) {
>  			path->slots[0]--;
>  			btrfs_item_key_to_cpu(path->nodes[0], &key,
>  					      path->slots[0]);
>  			if (key.objectid == bytenr &&
> -			    key.type == BTRFS_METADATA_ITEM_KEY)
> +			    key.type == BTRFS_EXTENT_ITEM_KEY &&
> +			    key.offset == root->leafsize)
>  				ret = 0;
>  		}
>  
>  		if (ret) {
>  			btrfs_release_path(root, path);
> +			key.objectid = bytenr;
>  			key.type = BTRFS_EXTENT_ITEM_KEY;
>  			key.offset = root->leafsize;
>  			metadata = 0;

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
