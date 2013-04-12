Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab3DLQX1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Apr 2013 12:23:27 -0400
Date: Fri, 12 Apr 2013 18:23:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 4/9 v2] btrfs-progs: check if btrfs kernel module is
 loaded
Message-ID: <20130412162325.GA18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365141303-10571-5-git-send-email-anand.jain@oracle.com>
 <1365582201-20835-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365582201-20835-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 10, 2013 at 04:23:21PM +0800, Anand Jain wrote:
> diff --git a/cmds-device.c b/cmds-device.c
> index a90fb67..0e1e6de 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -185,9 +185,10 @@ static const char * const cmd_scan_dev_usage[] = {
>  
>  static int cmd_scan_dev(int argc, char **argv)
>  {
> -	int	i, fd, e;
> +	int	i, fd = -1, e, ret = 0;
>  	int	checklist = 1;
>  	int	devstart = 1;
> +	u64	flag_reg = 0ull;

Do you need it to be u64? I see it's used only as a bool flag.

> +	if (is_btrfs_kernel_loaded())
> +		flag_reg = BTRFS_SCAN_REGISTER;

		flag_reg = 1;

would work the same, so it should be fine with int.

>  	}
>  
> +	printf("Scanning for Btrfs in\n");
...
> -		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);

Please keep the word 'filesystem' in the message

> @@ -261,6 +287,10 @@ static int cmd_ready_dev(int argc, char **argv)
>  	if (check_argc_min(argc, 2))
>  		usage(cmd_ready_dev_usage);
>  
> +	if (!is_btrfs_kernel_loaded()) {
> +		fprintf(stderr, "btrfs kernel module is not loaded\n");
> +		return 10;

return 1 or -1

> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1420,6 +1420,7 @@ int main(int ac, char **av)
>  	u64 flags;
>  	int dev_cnt=0;
>  	int saved_optind;
> +	int flag_reg=1;

ah, here it is an 'int'

> --- a/utils.c
> +++ b/utils.c
> @@ -1016,6 +1016,33 @@ struct pending_dir {
> +/*
> + * return 1 if btrfs kernel is present
> + * return 0 for not
> + */
> +int is_btrfs_kernel_loaded()
> +{
> +	FILE *pfs;
> +	char fsname[100];
> +	int ret = -1;
> +	char line[100];
> +
> +	pfs = fopen("/proc/filesystems", "r");
> +	if (pfs) {
> +		ret = 0;
> +		while (fgets(line, sizeof(line), pfs)) {
> +			if (sscanf(line, "nodev %[^#\n]\n", fsname) == 1) continue;

			if (!strncmp("nodev", line, 5))
				continue;

> +			if (sscanf(line, " %[^# \n]\n", fsname) != 1) continue;
> +			if (!strcmp(fsname, "btrfs")) {
> +				ret = 1;
> +				break;
> +			}
> +		}
> +		fclose(pfs);
> +	}
> +	return ret;
> +}
> +
>  void btrfs_register_one_device(char *fname)
>  {
>  	struct btrfs_ioctl_vol_args args;
> @@ -1023,6 +1050,11 @@ void btrfs_register_one_device(char *fname)
>  	int ret;
>  	int e;
>  
> +	if (!is_btrfs_kernel_loaded()) {
> +		fprintf(stderr, "btrfs kernel module is not loaded, "
> +			"skipping device registration\n");
> +		return;
> +	}
>  	fd = open("/dev/btrfs-control", O_RDONLY);
>  	if (fd < 0) {
>  		fprintf(stderr, "failed to open /dev/btrfs-control "

Otherwise ok.
david
