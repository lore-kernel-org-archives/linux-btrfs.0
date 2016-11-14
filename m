Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27699 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750908AbcKNBoL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 20:44:11 -0500
Subject: Re: [PATCH 5/6] btrfs-progs: implement btrfs check
 --clear-space-cache v2
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1479064970.git.osandov@fb.com>
 <eb8a6a86e655b9d639b385ca6484cd6c5b932f08.1479064970.git.osandov@fb.com>
CC: <kernel-team@fb.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6a2fd685-bf22-8fdc-27c4-b61b557ba0d2@cn.fujitsu.com>
Date: Mon, 14 Nov 2016 09:44:04 +0800
MIME-Version: 1.0
In-Reply-To: <eb8a6a86e655b9d639b385ca6484cd6c5b932f08.1479064970.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/14/2016 03:35 AM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/btrfs-check.asciidoc | 14 +++++++++-----
>  cmds-check.c                       | 34 +++++++++++++++++++++++++---------
>  2 files changed, 34 insertions(+), 14 deletions(-)
>
> diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
> index 5ef414e..633cbbf 100644
> --- a/Documentation/btrfs-check.asciidoc
> +++ b/Documentation/btrfs-check.asciidoc
> @@ -80,12 +80,16 @@ superblock is damaged.
>
>  --clear-space-cache v1|v2::
>  completely wipe all free space cache of given type
> -
> -NOTE: Only v1 free space cache supported is implemented.
>  +
> -Kernel mount option 'clear_cache' is only designed to rebuild free space cache
> -which is modified during the lifetime of that mount option.  It doesn't rebuild
> -all free space cache, nor clear them out.
> +For free space cache 'v1', the 'clear_cache' kernel mount option only rebuilds
> +the free space cache for block groups that are modified while the filesystem is
> +mounted with that option. Thus, using this option with 'v1' makes it possible
> +to actually clear the entire free space cache.
> ++
> +For free space cache 'v2', the 'clear_cache' kernel mount option does destroy
> +the entire free space cache. This option with 'v2' provides an alternative
> +method of clearing the free space cache that doesn't require mounting the
> +filesystem.

This is quite helpful.

The behavior of clear_cache should be the correct one.

Thanks,
Qu

>
>
>  DANGEROUS OPTIONS
> diff --git a/cmds-check.c b/cmds-check.c
> index 57c4300..0eca102 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -11170,7 +11170,6 @@ const char * const cmd_check_usage[] = {
>  	"--chunk-root <bytenr>       use the given bytenr for the chunk tree root",
>  	"-p|--progress               indicate progress",
>  	"--clear-space-cache v1|v2   clear space cache for v1 or v2",
> -	"                            NOTE: v1 support implemented",
>  	NULL
>  };
>
> @@ -11292,13 +11291,16 @@ int cmd_check(int argc, char **argv)
>  				}
>  				break;
>  			case GETOPT_VAL_CLEAR_SPACE_CACHE:
> -				if (strcmp(optarg, "v1") != 0) {
> -					error(
> -			"only v1 support implmented, unrecognized value %s",
> -			optarg);
> +				if (strcmp(optarg, "v1") == 0) {
> +					clear_space_cache = 1;
> +				} else if (strcmp(optarg, "v2") == 0) {
> +					clear_space_cache = 2;
> +					ctree_flags |= OPEN_CTREE_INVALIDATE_FST;
> +				} else {
> +					error("invalid argument to --clear-space-cache; "
> +					      "must be v1 or v2");
>  					exit(1);
>  				}
> -				clear_space_cache = 1;
>  				ctree_flags |= OPEN_CTREE_WRITES;
>  				break;
>  		}
> @@ -11352,11 +11354,10 @@ int cmd_check(int argc, char **argv)
>
>  	global_info = info;
>  	root = info->fs_root;
> -	if (clear_space_cache) {
> +	if (clear_space_cache == 1) {
>  		if (btrfs_fs_compat_ro(info,
>  				BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
> -			error(
> -			"free space cache v2 detected, clearing not implemented");
> +			error("free space cache v2 detected; use --clear-space-cache v2");
>  			ret = 1;
>  			goto close_out;
>  		}
> @@ -11369,6 +11370,21 @@ int cmd_check(int argc, char **argv)
>  			printf("Free space cache cleared\n");
>  		}
>  		goto close_out;
> +	} else if (clear_space_cache == 2) {
> +		if (!btrfs_fs_compat_ro(info, BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE)) {
> +			printf("No free space cache v2 to clear\n");
> +			ret = 0;
> +			goto close_out;
> +		}
> +		printf("Clear free space cache v2\n");
> +		ret = btrfs_clear_free_space_tree(info);
> +		if (ret) {
> +			error("Failed to clear free space cache v2");
> +			ret = 1;
> +		} else {
> +			printf("Free space cache v2 cleared\n");
> +		}
> +		goto close_out;
>  	}
>
>  	/*
>


