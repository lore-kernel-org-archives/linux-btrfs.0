Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40397 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932096AbeB0Pr4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 10:47:56 -0500
Date: Tue, 27 Feb 2018 16:45:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: verify max_inline mount parameter
Message-ID: <20180227154538.GB27791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180215164338.GC10193@twin.jikos.cz>
 <20180226024704.15567-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180226024704.15567-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 26, 2018 at 10:47:04AM +0800, Anand Jain wrote:
> We aren't verifying the parameter passed to the max_inline mount option.
> So we won't fail the mount if a junk value is specified, for example,
> -o max_inline=abc. This patch checks if input is valid.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2->v3: Handle parameter with unit, such as 4K. Use memparse() 2nd arg.
> v1->v2: use match_int ret value if error
>         use %u instead of %d for parser
> 
>  fs/btrfs/super.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 77e0537e1db5..76b58da8d56d 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -605,7 +605,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  		case Opt_max_inline:
>  			num = match_strdup(&args[0]);
>  			if (num) {
> -				info->max_inline = memparse(num, NULL);
> +				char *retptr;
> +
> +				info->max_inline = memparse(num, &retptr);

I missed it in the patch that changed max_inline to u32, memparse
returns unsigned long long, so this is not entrely correct and requires
a temporary variable.

We should also report if the user-specified value is larger than
BTRFS_MAX_METADATA_BLOCKSIZE .

This is not a trivial fix the existing patches so I'll remove "btrfs:
declare max_inline as u32".

To sum it up:

1. add check and return EINVAL with a message if max_inline is larger
   than the metadata block size
2. switch max_inline to u32 and add a temporary value to read from
   memparse
3. add change from this patch that catches the junk

> +				if (*retptr != '\0') {
> +					ret = -EINVAL;
> +					kfree(num);

The kfree can be moved before the check, we don't need 'num'.

> +					goto out;
> +				}
>  				kfree(num);
>  
>  				if (info->max_inline) {
> -- 
> 2.15.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
