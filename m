Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45332 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751302AbdFZOLD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 10:11:03 -0400
Date: Mon, 26 Jun 2017 16:09:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <boliu@localhost.localdomain>
Subject: Re: [PATCH] Btrfs-progs: fix infinite loop in find_free_extent
Message-ID: <20170626140953.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170624042831.8068-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170624042831.8068-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 23, 2017 at 10:28:31PM -0600, Liu Bo wrote:
> From: Liu Bo <boliu@localhost.localdomain>
> 
> %search_start is calculated in a wrong way, and if %ins is a cross-stripe
>  one, it'll search the same block group forever.

That's a bit terse description, so please check if my understanding is right:
search_start advances by at least one stripe len, but the math would be wrong
as using bg_offset would not move us to the next stripe. bg_cache->key.objectid
is the full length so this will reach the next stripe and will not loop forever.

Do you happen to have a test for that?

> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  extent-tree.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/extent-tree.c b/extent-tree.c
> index b12ee29..5e09274 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -2614,8 +2614,9 @@ check_failed:
>  				goto no_bg_cache;
>  			bg_offset = ins->objectid - bg_cache->key.objectid;
>  
> -			search_start = round_up(bg_offset + num_bytes,
> -						BTRFS_STRIPE_LEN) + bg_offset;
> +			search_start = round_up(
> +				bg_offset + num_bytes, BTRFS_STRIPE_LEN) +
> +				bg_cache->key.object;

extent-tree.c: In function ‘find_free_extent’:
extent-tree.c:2617:18: error: ‘struct btrfs_key’ has no member named ‘object’; did you mean ‘objectid’?
     bg_cache->key.object;
                  ^
