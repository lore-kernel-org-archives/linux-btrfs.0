From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: allow mount -o remount,compress=no
Date: Fri, 6 Apr 2012 12:22:32 +0200
Message-ID: <20120406102232.GH14256@twin.jikos.cz>
References: <1333568777-16986-1-git-send-email-arnd@arndnet.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1333568777-16986-1-git-send-email-arnd@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 04, 2012 at 09:46:17PM +0200, Arnd Hannemann wrote:
> Btrfs allows to turn on compression on a mounted and used filesystem
> by issuing mount -o remount,compress=lzo.
> This patch allows to turn compression off again
> while the filesystem is mounted.

I agree it makes sense to allow for turning off the compression via
remount. Currently the mount flag FORCE_COMPRESS implies COMPRESS and
your code may lead to FORCE_COMPRESS without COMPRESS. To fix that
clear the force option as well.

For completeness, there should be also possibility of

  -o remount,compress-force=no

doing exactly the same, just a different syntax. Proposed fix below.

> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -394,15 +394,20 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  			    strcmp(args[0].from, "zlib") == 0) {
>  				compress_type = "zlib";
>  				info->compress_type = BTRFS_COMPRESS_ZLIB;
> +				btrfs_set_opt(info->mount_opt, COMPRESS);
>  			} else if (strcmp(args[0].from, "lzo") == 0) {
>  				compress_type = "lzo";
>  				info->compress_type = BTRFS_COMPRESS_LZO;
> +				btrfs_set_opt(info->mount_opt, COMPRESS);
> +			} else if (strncmp(args[0].from, "no", 2) == 0) {
> +				compress_type = "no";
> +				info->compress_type = BTRFS_COMPRESS_NONE;
> +				btrfs_clear_opt(info->mount_opt, COMPRESS);

				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
				compress_force = false;

>  			} else {
>  				ret = -EINVAL;
>  				goto out;
>  			}
>  
> -			btrfs_set_opt(info->mount_opt, COMPRESS);
>  			if (compress_force) {
>  				btrfs_set_opt(info->mount_opt, FORCE_COMPRESS);
>  				pr_info("btrfs: force %s compression\n",
