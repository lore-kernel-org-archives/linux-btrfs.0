Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaE0QWw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 12:22:52 -0400
Date: Tue, 27 May 2014 18:22:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, t-itoh@jp.fujitsu.com
Subject: Re: [PATCH] Btrfs: clear compress-force when remounting with
 compress option
Message-ID: <20140527162249.GM5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400816212-2501-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400816212-2501-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 23, 2014 at 11:36:52AM +0800, Wang Shilong wrote:
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -513,6 +513,14 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>  					btrfs_info(root->fs_info,
>  						   "btrfs: use %s compression",
>  						   compress_type);
> +				/*
> +				 * If we remount from compress-force=xxx to
> +				 * compress=xxx, we need clear FORCE_COMPRESS
> +				 * flag, otherwise, there is no way for users
> +				 * to disable forcible compression separately.
> +				 */
> +				btrfs_clear_and_info(root, FORCE_COMPRESS,
> +						     "compress is not forced anymore");

This adds another message and does not make sense if it's not during
remount.

The message "btrfs: use %s compression" could be printed
unconditionally, we want to see that the compression is requested via
mount option.

Otherwise, the variable 'compress' does nothing useful and can be
removed as well.


>  			}
>  			break;
>  		case Opt_ssd:
