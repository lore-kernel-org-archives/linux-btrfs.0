Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:56050 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3EQIwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 04:52:16 -0400
Message-ID: <5195EFC0.7000209@giantdisaster.de>
Date: Fri, 17 May 2013 10:52:16 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak in replace_path
References: <1368780344-7157-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1368780344-7157-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 May 2013 16:45:44 +0800, Liu Bo wrote:
> We need to unlock and free extent buffer before the return.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/relocation.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 704a1b8..5c5b8bb 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -1773,7 +1773,7 @@ again:
>  			if (!eb || !extent_buffer_uptodate(eb)) {
>  				ret = (!eb) ? -ENOMEM : -EIO;
>  				free_extent_buffer(eb);
> -				return ret;
> +				break;
>  			}
>  			btrfs_tree_lock(eb);
>  			if (cow) {
> 

ELATE

5887f17 Btrfs: fix possible memory leak in replace_path()

