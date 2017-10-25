Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750876AbdJYNZC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Oct 2017 09:25:02 -0400
Date: Wed, 25 Oct 2017 15:23:11 +0200
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid misleading talk about "compression level 0"
Message-ID: <20171025132311.GY3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171021164901.11529-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171021164901.11529-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 21, 2017 at 06:49:01PM +0200, Adam Borowski wrote:
> Many compressors do assign a meaning to level 0: either null compression or
> the lowest possible level.  This differs from our "unset thus default".
> Thus, let's not unnecessarily confuse users.

I agree 'level 0' confusing, however I'd like to keep the level
mentioned in the message.

We could add

#define	BTRFS_COMPRESSION_ZLIB_DEFAULT		3

and use it in btrfs_compress_str2level.

> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
>  fs/btrfs/super.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index f9d4522336db..144fabfbd246 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -551,7 +551,9 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			      compress_force != saved_compress_force)) ||
>  			    (!btrfs_test_opt(info, COMPRESS) &&
>  			     no_compress == 1)) {
> -				btrfs_info(info, "%s %s compression, level %d",
> +				btrfs_printk(info, info->compress_level ?
> +					   KERN_INFO"%s %s compression, level %d" :
> +					   KERN_INFO"%s %s compression",

Please keep using btrfs_info, the KERN_INFO prefix would not work here.
btrfs_printk prepends the filesystem description and the message level
must be at the beginning.

>  					   (compress_force) ? "force" : "use",
>  					   compress_type, info->compress_level);
>  			}
