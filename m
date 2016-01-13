Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52721 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbcAMMdp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 07:33:45 -0500
Date: Wed, 13 Jan 2016 13:33:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH V2] Btrfs: fix output of compression message in
 btrfs_parse_options()
Message-ID: <20160113123343.GP4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201601060803.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201601060803.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 06, 2016 at 05:03:40PM +0900, Tsutomu Itoh wrote:
>  			} else if (strncmp(args[0].from, "no", 2) == 0) {
>  				compress_type = "no";
>  				btrfs_clear_opt(info->mount_opt, COMPRESS);
>  				btrfs_clear_opt(info->mount_opt, FORCE_COMPRESS);
>  				compress_force = false;
> +				no_compress++;
>  			} else {
...
> +			if ((btrfs_test_opt(root, COMPRESS) &&
> +			     (info->compress_type != saved_compress_type ||
> +			      compress_force != saved_compress_force)) ||
> +			    (!btrfs_test_opt(root, COMPRESS) &&
> +			     no_compress == 1)) {

If there are more than one 'compress=no' then the message won't be
printed. I don't see a reason for doing no_compress++ above.

> +				btrfs_info(root->fs_info,
> +					   "%s %s compression",
> +					   (compress_force) ? "force" : "use",
> +					   compress_type);
> +			}
> +			compress_force = false;
>  			break;
>  		case Opt_ssd:
>  			btrfs_set_and_info(root, SSD,
