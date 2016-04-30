Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33598 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbcEDWWD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 May 2016 18:22:03 -0400
Received: by mail-wm0-f68.google.com with SMTP id r12so13441520wme.0
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 15:22:01 -0700 (PDT)
Date: Sat, 30 Apr 2016 12:33:57 -0400
From: Sanidhya Solanki <lkml.page@gmail.com> (by way of Sanidhya Solanki
	<lkml.page@gmail.com>)
To: Ashish Samant <ashish.samant@oracle.com>
Cc: linux-btrfs-owner@vger.kernel.org
Message-ID: <20160430123357.060e5db1@jpage>
In-Reply-To: <1461980039-25200-1-git-send-email-ashish.samant@oracle.com>
References: <1461980039-25200-1-git-send-email-ashish.samant@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [PATCH] btrfs: Fix BUG_ON condition in
 scrub_setup_recheck_block()
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Apr 2016 18:33:59 -0700
Ashish Samant <ashish.samant@oracle.com> wrote:

> pagev array in scrub_block{} is of size SCRUB_MAX_PAGES_PER_BLOCK.
> page_index should be checked with the same to trigger BUG_ON().
> 
> Signed-off-by: Ashish Samant <ashish.samant@oracle.com>
> ---
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 4678f03..376a6dd 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1350,7 +1350,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
>  		recover->bbio = bbio;
>  		recover->map_length = mapped_length;
>  
> -		BUG_ON(page_index >= SCRUB_PAGES_PER_RD_BIO);
> +		BUG_ON(page_index >= SCRUB_MAX_PAGES_PER_BLOCK);
>  
>  		nmirrors = min(scrub_nr_raid_mirrors(bbio), BTRFS_MAX_MIRRORS);
>  

Hello

I am trying to implement a user-space IOCTL option to change the RAID Stripe Size.
I have run into an issue in the code included here, specifically in line 64 of scrub.c. 

#define SCRUB_MAX_PAGES_PER_BLOCK      16      /* 64k per node/leaf/sector */

This line should become a user-space variable if SCRUB_MAX_PAGES_PER_BLOCK is
related in any way to the definition of BTrFS Stripe Length (defined in
volume.h)  being equal to a product of Super_blk and RAID Stripe Length, as it was
before mid-December before the patch
"http://article.gmane.org/gmane.comp.file-systems.btrfs/51221/" modified it. If 
SCRUB_MAX_PAGES_PER_BLOCK is related to Super_blk, then it too will need to be
changed from a macro to something that is runtime configurable.

Could those more familiar with the code base let me know.

Thanks
