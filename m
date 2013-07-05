Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52848 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3GEU1U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jul 2013 16:27:20 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 72DFB7C069C
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2013 14:27:20 -0600 (MDT)
Date: Fri, 5 Jul 2013 16:27:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: remove incorrect slot decrement
Message-ID: <20130705202718.GE2260@localhost.localdomain>
References: <1373031307-22590-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1373031307-22590-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 05, 2013 at 02:35:07PM +0100, Filipe David Borba Manana wrote:
> In btrfs_set_block_flags() we want to check if the slot
> in the leaf points to the first item in the leaf - if it
> doesn't check if the previous item in the leaf is an extent
> item. By removing this extra slot decrement we are indeed
> checking the item right before the slot, and not the second
> item before.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  extent-tree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index 381572d..5b6c7aa 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1609,7 +1609,7 @@ again:
>  
>  	if (ret > 0 && skinny_metadata) {
>  		skinny_metadata = 0;
> -		if (path->slots[0]--) {
> +		if (path->slots[0]) {
>  			path->slots[0]--;
>  			btrfs_item_key_to_cpu(path->nodes[0], &key,
>  					      path->slots[0]);

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
