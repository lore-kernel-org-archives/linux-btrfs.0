Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:64365 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2JKNNG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 09:13:06 -0400
Message-ID: <5076C5EA.3020602@giantdisaster.de>
Date: Thu, 11 Oct 2012 15:13:14 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix page leakage
References: <1349470500-7328-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1349470500-7328-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 5 Oct 2012 16:55:00 -0400, Josef Bacik wrote:
> Alloc_dummy_extent_buffer will not free the first page in the eb array if we
> fail to allocate a page, fix this.  Thanks,
> 
> Reported-by: David Sterba <dave@jikos.cz>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/extent_io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 7dc69b3..64dc93f 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4104,7 +4104,7 @@ struct extent_buffer *alloc_dummy_extent_buffer(u64 start, unsigned long len)
>  
>  	return eb;
>  err:
> -	for (i--; i > 0; i--)
> +	for (i--; i >= 0; i--)
>  		__free_page(eb->pages[i]);
>  	__free_extent_buffer(eb);
>  	return NULL;
> 

gcc says "warning: comparison of unsigned expression >= 0 is always
true" because i is an unsigned long. And gcc is right this time.

Reviewed-And-Rejected-By: gcc
