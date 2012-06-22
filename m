Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:46687 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab2FVRTq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 13:19:46 -0400
Message-ID: <4FE4A941.1060103@libero.it>
Date: Fri, 22 Jun 2012 19:20:01 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, harald@redhat.com
Subject: Re: [PATCH] Btrfs-progs: add btrfs device ready command
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com> <1340309431-9972-3-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1340309431-9972-3-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/2012 10:10 PM, Josef Bacik wrote:
> This command will be used by things like dracut that wish to know very
> simply if all of the devices have been added to the kernel cache yet for the
> device to be fully mounted.  This keeps initrd's from constantly having to
> try to mount the file system until it succeeds every time a device is added
> to the system.  Thanks,
> 

Please Josef, when you submit a patch to btrfs-progs that adds a new
command pay attention to update the man page too.

Se below my other syggestions:

Thanks
G.Baroncelli

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  cmds-device.c |   35 +++++++++++++++++++++++++++++++++++
>  ioctl.h       |    2 ++
>  2 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index db625a6..fccf870 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -246,11 +246,46 @@ static int cmd_scan_dev(int argc, char **argv)
>  	return 0;
>  }
>  
> +static const char * const cmd_ready_dev_usage[] = {
> +	"btrfs device ready <device>",
What about
         btrfs device check-volume <device>


> +	"Check device to see if it has all of it's devices in cache for mounting",

I suggest:
	Check if all the devices of the volume which owns <device> are registered.


> +	NULL
> +};
> +
> +static int cmd_ready_dev(int argc, char **argv)
> +{
> +	struct	btrfs_ioctl_vol_args args;
> +	int	fd;
> +	int	ret;
> +
> +	if (check_argc_min(argc, 2))
> +		usage(cmd_ready_dev_usage);
> +
> +	fd = open("/dev/btrfs-control", O_RDWR);
> +	if (fd < 0) {
> +		perror("failed to open /dev/btrfs-control");
> +		return 10;
> +	}
> +
> +	strncpy(args.name, argv[argc - 1], BTRFS_PATH_NAME_MAX);
> +	ret = ioctl(fd, BTRFS_IOC_DEVICES_READY, &args);
> +	if (ret < 0) {
> +		fprintf(stderr, "ERROR: unable to determine if the device '%s'"
> +			" is ready for mounting - %s\n", argv[argc - 1],
> +			strerror(errno));
> +		ret = 1;
> +	}
> +
> +	close(fd);
> +	return ret;
> +}
> +
>  const struct cmd_group device_cmd_group = {
>  	device_cmd_group_usage, NULL, {
>  		{ "add", cmd_add_dev, cmd_add_dev_usage, NULL, 0 },
>  		{ "delete", cmd_rm_dev, cmd_rm_dev_usage, NULL, 0 },
>  		{ "scan", cmd_scan_dev, cmd_scan_dev_usage, NULL, 0 },
> +		{ "ready", cmd_ready_dev, cmd_ready_dev_usage, NULL, 0 },
>  		{ 0, 0, 0, 0, 0 }
>  	}
>  };
> diff --git a/ioctl.h b/ioctl.h
> index f2e5d8d..e5f8a94 100644
> --- a/ioctl.h
> +++ b/ioctl.h
> @@ -330,5 +330,7 @@ struct btrfs_ioctl_logical_ino_args {
>  					struct btrfs_ioctl_ino_path_args)
>  #define BTRFS_IOC_LOGICAL_INO _IOWR(BTRFS_IOCTL_MAGIC, 36, \
>  					struct btrfs_ioctl_ino_path_args)
> +#define BTRFS_IOC_DEVICES_READY _IOW(BTRFS_IOCTL_MAGIC, 54, \
> +				     struct btrfs_ioctl_vol_args)
>  
>  #endif

