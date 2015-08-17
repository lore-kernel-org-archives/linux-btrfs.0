Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:42135 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751334AbbHQHJE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Aug 2015 03:09:04 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 2/2] btrfs-progs: device delete to accept devid
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <55D1869A.8080802@inwind.it>
Date: Mon, 17 Aug 2015 09:00:42 +0200
MIME-Version: 1.0
In-Reply-To: <1439548611-29730-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1439548611-29730-1-git-send-email-anand.jain@oracle.com>
 <1439548611-29730-3-git-send-email-anand.jain@oracle.com>

On 2015-08-14 12:36, Anand Jain wrote:
> This patch introduces new option <devid> for the command
> 
>   btrfs device delete <device_path|devid>[..]  <mnt>
> 
> In a user reported issue on a 3-disk-RAID1, one disk failed with its
> SB unreadable. Now with this patch user will have a choice to delete
> the device using devid.
> 
> The other method we could do, is to match the input device_path
> to the available device_paths with in the kernel. But that won't
> work in all the cases, like what if user provided mapper path
> when the path within the kernel is a non-mapper path.
> 
> This patch depends on the below kernel patch for the new feature to work,
> however it will fail-back to the old interface for the kernel without the
> patch
> 
>   Btrfs: device delete by devid
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  Documentation/btrfs-device.asciidoc |  2 +-
>  cmds-device.c                       | 45 ++++++++++++++++++++++++++++---------
>  ioctl.h                             |  8 +++++++
>  3 files changed, 44 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
> index 2827598..61ede6e 100644
> --- a/Documentation/btrfs-device.asciidoc
> +++ b/Documentation/btrfs-device.asciidoc
> @@ -74,7 +74,7 @@ do not perform discard by default
>  -f|--force::::
>  force overwrite of existing filesystem on the given disk(s)
>  
> -*remove* <dev> [<dev>...] <path>::
> +*remove* <dev>|<devid> [<dev>|<devid>...] <path>::
>  Remove device(s) from a filesystem identified by <path>.
>  
>  *delete* <dev> [<dev>...] <path>::
also here is missing <devid> (below you added)

> diff --git a/cmds-device.c b/cmds-device.c
> index 0e60500..eb4358d 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -164,16 +164,34 @@ static int _cmd_rm_dev(int argc, char **argv, const char * const *usagestr)
>  		struct	btrfs_ioctl_vol_args arg;
>  		int	res;
>  
> -		if (!is_block_device(argv[i])) {
> +		struct  btrfs_ioctl_vol_args_v3 argv3 = {0};
> +		int     its_num = false;
> +
> +		if (is_numerical(argv[i])) {
> +			argv3.devid = arg_strtou64(argv[i]);
> +			its_num = true;
> +		} else if (is_block_device(argv[i])) {
> +			strncpy_null(argv3.name, argv[i]);
> +		} else {
>  			fprintf(stderr,
> -				"ERROR: %s is not a block device\n", argv[i]);
> +				"ERROR: %s is not a block device or devid\n", argv[i]);
>  			ret++;
>  			continue;
>  		}
> -		memset(&arg, 0, sizeof(arg));
> -		strncpy_null(arg.name, argv[i]);
> -		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
> +		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV_V2, &argv3);
>  		e = errno;
> +		if (res && e == ENOTTY) {
> +			if (its_num) {
> +				fprintf(stderr,
> +				"Error: Kernel does not support delete by devid\n");
> +				ret = 1;
> +				continue;
> +			}
> +			memset(&arg, 0, sizeof(arg));
> +			strncpy_null(arg.name, argv[i]);
> +			res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
> +			e = errno;
> +		}
>  		if (res) {
>  			const char *msg;
>  
> @@ -181,9 +199,16 @@ static int _cmd_rm_dev(int argc, char **argv, const char * const *usagestr)
>  				msg = btrfs_err_str(res);
>  			else
>  				msg = strerror(e);
> -			fprintf(stderr,
> -				"ERROR: error removing the device '%s' - %s\n",
> -				argv[i], msg);
> +
> +			if (its_num)
> +				fprintf(stderr,
> +					"ERROR: error removing the devid '%llu' - %s\n",
> +					argv3.devid, msg);
> +			else
> +				fprintf(stderr,
> +					"ERROR: error removing the device '%s' - %s\n",
> +					argv[i], msg);
> +
>  			ret++;
>  		}
>  	}
> @@ -193,7 +218,7 @@ static int _cmd_rm_dev(int argc, char **argv, const char * const *usagestr)
>  }
>  
>  static const char * const cmd_rm_dev_usage[] = {
> -	"btrfs device remove <device> [<device>...] <path>",
> +	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
>  	"Remove a device from a filesystem",
>  	NULL
>  };
> @@ -204,7 +229,7 @@ static int cmd_rm_dev(int argc, char **argv)
>  }
>  
>  static const char * const cmd_del_dev_usage[] = {
> -	"btrfs device delete <device> [<device>...] <path>",
> +	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
>  	"Remove a device from a filesystem",
>  	NULL
>  };
> diff --git a/ioctl.h b/ioctl.h
> index dff015a..6870931 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -40,6 +40,12 @@ struct btrfs_ioctl_vol_args {
>  	char name[BTRFS_PATH_NAME_MAX + 1];
>  };
>  
> +struct btrfs_ioctl_vol_args_v3 {
> +	__s64 fd;
> +	char name[BTRFS_PATH_NAME_MAX + 1];
> +	__u64 devid;
> +};
> +
>  #define BTRFS_DEVICE_PATH_NAME_MAX 1024
>  
>  #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
> @@ -683,6 +689,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>                                    struct btrfs_ioctl_feature_flags[2])
>  #define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
>                                    struct btrfs_ioctl_feature_flags[3])
> +#define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
> +				   struct btrfs_ioctl_vol_args_v3)
>  #ifdef __cplusplus
>  }
>  #endif
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
