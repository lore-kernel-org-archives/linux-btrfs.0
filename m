Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755797AbdJJNSe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Oct 2017 09:18:34 -0400
Date: Tue, 10 Oct 2017 15:16:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, yoasif@gmail.com,
        rrauenza@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: fsck: Introduce --fix-dev-size option
Message-ID: <20171010131648.GM3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010075113.10718-1-quwenruo.btrfs@gmx.com>
 <20171010075113.10718-3-quwenruo.btrfs@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010075113.10718-3-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 07:51:11AM +0000, Qu Wenruo wrote:
> Introduce --fix-dev-size option to fix device related problems.

Please don't add it to 'check', this is not the right place for the
targeted fixes. -> 'btrfs rescue'

> This repairing  is also included in --repair, but considering the safety
> and potential affected users, it's better to provide a option to fix and
> only fix device size related problem to avoid full --repair.
> 
> Reported-by: Asif Youssuff <yoasif@gmail.com>
> Reported-by: Rich Rauenzahn <rrauenza@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> ---
>  Documentation/btrfs-check.asciidoc | 23 +++++++++++++++++++++++
>  cmds-check.c                       | 28 +++++++++++++++++++++++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
> index fbf48847ac25..e45c7a457bac 100644
> --- a/Documentation/btrfs-check.asciidoc
> +++ b/Documentation/btrfs-check.asciidoc
> @@ -93,6 +93,29 @@ the entire free space cache. This option with 'v2' provides an alternative
>  method of clearing the free space cache that doesn't require mounting the
>  filesystem.
>  
> +--fix-dev-size::
> +From v4.14-rc kernels, a more restrict device size checker is introduced, while
> +old kernel doesn't strictly align its device size, so it may cause noisy kernel
> +warning for newer kernel, like:
> ++
> +....
> +WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559 btrfs_update_device+0x1c5/0x1d0 [btrfs]
> +....
> ++
> +And for some case where super block total device size may mismatch with all
> +devices, and the filesystem will be unable to be mounted, with kernel message
> +like:
> ++
> +....
> +BTRFS error (device sdb): super_total_bytes 92017859088384 mismatch with fs_devices total_rw_bytes 92017859094528 
> +....
> ++
> +This option will fix both problems by aligning all size of devices, and
> +re-calculating superblock total bytes.
> ++
> +Although such repairing is included in *--repair* option, considering the
> +safety of *--repair*, this option is provided to suppress all other dangerous
> +repairing and only fix device sizes related problems.
>  
>  DANGEROUS OPTIONS
>  -----------------
> diff --git a/cmds-check.c b/cmds-check.c
> index 007781fa5d1b..fdb6d832eee1 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -11746,6 +11746,8 @@ out:
>  	return err;
>  }
>  
> +static int reset_devs_size(struct btrfs_fs_info *fs_info);
> +
>  static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>  {
>  	int ret;
> @@ -11756,6 +11758,12 @@ static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
>  		ret = check_chunks_and_extents_v2(fs_info);
>  	else
>  		ret = check_chunks_and_extents(fs_info);
> +	/* Also repair device sizes if needed */
> +	if (repair && !ret) {
> +		ret = reset_devs_size(fs_info);
> +		if (ret > 0)
> +			ret = 0;
> +	}
>  
>  	return ret;
>  }
> @@ -13088,6 +13096,8 @@ const char * const cmd_check_usage[] = {
>  	"-b|--backup                 use the first valid backup root copy",
>  	"--force                     skip mount checks, repair is not possible",
>  	"--repair                    try to repair the filesystem",
> +	"--fix-dev-size              repair device size related problem",
> +	"                            will not trigger other repair",
>  	"--readonly                  run in read-only mode (default)",
>  	"--init-csum-tree            create a new CRC tree",
>  	"--init-extent-tree          create a new extent tree",
> @@ -13128,6 +13138,7 @@ int cmd_check(int argc, char **argv)
>  	int qgroups_repaired = 0;
>  	unsigned ctree_flags = OPEN_CTREE_EXCLUSIVE;
>  	int force = 0;
> +	bool fix_dev_size = false;
>  
>  	while(1) {
>  		int c;
> @@ -13135,7 +13146,7 @@ int cmd_check(int argc, char **argv)
>  			GETOPT_VAL_INIT_EXTENT, GETOPT_VAL_CHECK_CSUM,
>  			GETOPT_VAL_READONLY, GETOPT_VAL_CHUNK_TREE,
>  			GETOPT_VAL_MODE, GETOPT_VAL_CLEAR_SPACE_CACHE,
> -			GETOPT_VAL_FORCE };
> +			GETOPT_VAL_FORCE, GETOPT_VAL_FIX_DEV_SIZE };
>  		static const struct option long_options[] = {
>  			{ "super", required_argument, NULL, 's' },
>  			{ "repair", no_argument, NULL, GETOPT_VAL_REPAIR },
> @@ -13158,6 +13169,8 @@ int cmd_check(int argc, char **argv)
>  			{ "clear-space-cache", required_argument, NULL,
>  				GETOPT_VAL_CLEAR_SPACE_CACHE},
>  			{ "force", no_argument, NULL, GETOPT_VAL_FORCE },
> +			{ "fix-dev-size", no_argument, NULL,
> +				GETOPT_VAL_FIX_DEV_SIZE },
>  			{ NULL, 0, NULL, 0}
>  		};
>  
> @@ -13245,6 +13258,11 @@ int cmd_check(int argc, char **argv)
>  			case GETOPT_VAL_FORCE:
>  				force = 1;
>  				break;
> +			case GETOPT_VAL_FIX_DEV_SIZE:
> +				fix_dev_size = true;
> +				repair = 1;
> +				ctree_flags |= OPEN_CTREE_WRITES;
> +				break;
>  		}
>  	}
>  
> @@ -13371,6 +13389,14 @@ int cmd_check(int argc, char **argv)
>  			report_qgroups(1);
>  		goto close_out;
>  	}
> +
> +	if (fix_dev_size) {
> +		ret = reset_devs_size(info);
> +		if (ret > 0)
> +			ret = 0;
> +		err |= !!ret;
> +		goto close_out;
> +	}
>  	if (subvolid) {
>  		printf("Print extent state for subvolume %llu on %s\nUUID: %s\n",
>  		       subvolid, argv[optind], uuidbuf);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
