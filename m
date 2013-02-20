Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935133Ab3BTM7U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 07:59:20 -0500
Date: Wed, 20 Feb 2013 13:59:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130220125918.GC9521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -144,7 +144,7 @@ struct tree_block {
>  	unsigned int key_ready:1;
>  };
>  
> -#define MAX_EXTENTS 128
> +#define MAX_EXTENTS 512

I'm still not convinced this is needed and seeing
max_compressed_extent_kb used in the middle of relocation code makes me
wonder. There may be a bug related to the number but I have doubts that
it is related to compression.

> -		BUG_ON(cluster->nr >= MAX_EXTENTS);
> +		BUG_ON(cluster->nr >= fs_info->max_compressed_extent_kb);

...

> @@ -612,6 +613,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			ret = -EINVAL;
>  			goto out;
>  #endif
> +		case Opt_max_compr_extent_kb:
> +			intarg = 0;
> +			match_int(&args[0], &intarg);
> +			if ((intarg == 128) || (intarg == 512)) {
> +				info->max_compressed_extent_kb = intarg;
> +				printk(KERN_INFO "btrfs: "
> +				       "max compressed extent size %d KB\n",
> +				       info->max_compressed_extent_kb);

				btrfs_set_opt(fs_info->mount_opt,
					COMPR_EXTENT_SIZE);

otherwise the value of the options is not visible in /proc/mounts

> +			} else {
> +				printk(KERN_INFO "btrfs: "
> +				       "Invalid compressed extent size,"
> +				       " using default.\n");
> +			}
> +			break;
>  		case Opt_fatal_errors:
>  			if (strcmp(args[0].from, "panic") == 0)
>  				btrfs_set_opt(info->mount_opt,
