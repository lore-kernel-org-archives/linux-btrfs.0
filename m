Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbdLETNL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 14:13:11 -0500
Date: Tue, 5 Dec 2017 20:11:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs-progs: add 'btrfs device ignore' cli
Message-ID: <20171205191111.GV3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171205085258.4038-1-anand.jain@oracle.com>
 <20171205085258.4038-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171205085258.4038-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 04:52:57PM +0800, Anand Jain wrote:
> This patch adds
>   btrfs device ignode <dev>
> so that a device can be ignored/missed during mount if the device is
> already been scanned. Basically, this command will undo the effect
> of the command
>   btrfs device scan <dev>

As it logicall belongs to scan, I'd rather make it an option, like

  $ btrfs scan --unregister

or

  $ btrfs scan --forget

The meaning of 'ignore' in this context is not clear to me, we can
ignore errors on the device.

> This change is compatible with older kernel without the ioctl
> BTRFS_IOC_IGNORE_DEV which is added here. At which it shall
> report 'Inappropriate ioctl for device'. And will report
> 'Operation not permitted' on mounted device.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v1-4: No change.
> 
>  cmds-device.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  ioctl.h       |  2 ++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index f4cdb39f64ac..31b1945d3339 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -329,6 +329,59 @@ out:
>  	return !!ret;
>  }
>  
> +static const char * const cmd_device_ignore_usage[] = {
> +	"btrfs device ignore [<device>]",
> +	"Ignore a device in the btrfs kernel module.",
> +	NULL
> +};
> +
> +static int btrfs_ignore_one_device(char *path)
> +{
> +	struct btrfs_ioctl_vol_args args;
> +	int fd;
> +	int ret;
> +
> +	fd = open("/dev/btrfs-control", O_RDWR);
> +	if (fd < 0)
> +		return -errno;
> +
> +	memset(&args, 0, sizeof(args));
> +	strncpy_null(args.name, path);
> +	ret = ioctl(fd, BTRFS_IOC_IGNORE_DEV, &args);
> +	if (ret)
> +		ret = -errno;
> +	close(fd);
> +	return ret;
> +}
> +
> +static int cmd_device_ignore(int argc, char **argv)
> +{
> +	int ret = 0;
> +	char *path;
> +
> +	if (check_argc_max(argc - optind, 1))
> +		usage(cmd_device_ignore_usage);
> +
> +	if (is_block_device(argv[1]) != 1) {
> +		error("Not a block device: %s", argv[1]);
> +		return -ENOENT;
> +	}
> +
> +	path = canonicalize_path(argv[1]);
> +	if (!path) {
> +		error("Could not canonicalize path '%s': %s",
> +					argv[1], strerror(errno));
> +		return -ENOENT;
> +	}
> +
> +	ret  = btrfs_ignore_one_device(path);
> +	if (ret)
> +		error("Can't ignore %s: %s", path, strerror(-ret));
> +
> +	free(path);
> +	return ret;
> +}
> +
>  static const char * const cmd_device_ready_usage[] = {
>  	"btrfs device ready <device>",
>  	"Check device to see if it has all of its devices in cache for mounting",
> @@ -604,6 +657,7 @@ const struct cmd_group device_cmd_group = {
>  			CMD_ALIAS },
>  		{ "remove", cmd_device_remove, cmd_device_remove_usage, NULL, 0 },
>  		{ "scan", cmd_device_scan, cmd_device_scan_usage, NULL, 0 },
> +		{ "ignore", cmd_device_ignore, cmd_device_ignore_usage, NULL, 0 },
>  		{ "ready", cmd_device_ready, cmd_device_ready_usage, NULL, 0 },
>  		{ "stats", cmd_device_stats, cmd_device_stats_usage, NULL, 0 },
>  		{ "usage", cmd_device_usage,
> diff --git a/ioctl.h b/ioctl.h
> index 709e996f401c..bef8508119aa 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -721,6 +721,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  				   struct btrfs_ioctl_vol_args)
>  #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>  				   struct btrfs_ioctl_vol_args)
> +#define BTRFS_IOC_IGNORE_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
> +				   struct btrfs_ioctl_vol_args)
>  /* trans start and trans end are dangerous, and only for
>   * use by applications that know how to avoid the
>   * resulting deadlocks
> -- 
> 2.7.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
