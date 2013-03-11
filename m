Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab3CKW1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:27:10 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2BMRANe010130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 18:27:10 -0400
Message-ID: <513E5A3C.4080309@redhat.com>
Date: Mon, 11 Mar 2013 17:27:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs-progs: rework get_fs_info to remove side effects
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com> <1363043581-15812-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363043581-15812-5-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/11/13 6:13 PM, Eric Sandeen wrote:
> get_fs_info() has been silently switching from a device to a mounted
> path as needed; the caller's filehandle was unexpectedly closed &
> reopened outside the caller's scope.  Not so great.
> 
> The callers do want "fdmnt" to be the filehandle for the mount point
> in all cases, though - the various ioctls act on this (not on an fd
> for the device).  But switching it in the local scope of get_fs_info
> is incorrect; it just so happens that *usually* the fd number is
> unchanged.
> 
> So - use the new helpers to detect when an argument is a block
> device, and open the the mounted path more obviously / explicitly
> for ioctl use, storing the filehandle in fdmnt.
> 
> Then, in get_fs_info, ignore the fd completely, and use the path on
> the argument to determine if the caller wanted to act on just that
> device, or on all devices for the filesystem.
> 
> Affects those commands which are documented to accept either
> a block device or a path:

Following my tradition I'll (immediately) self-nak this one for now.

After I sent this I thought to test:

# mkfs.btrfs /dev/sdb1 /dev/sdb2; mount /dev/sdb1 /mnt/test; btrfs stats /dev/sdb2

after I tested it, and that fails where it used to work.  So

a) we could use a test for this, and 
b) I broke something

If the overall idea of the change seems decent, I'll get it fixed up after I sort
out what I broke.  :/

-Eric

> * btrfs device stats
> * btrfs replace start
> * btrfs scrub start
> * btrfs scrub status
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  cmds-device.c  |    5 ++-
>  cmds-replace.c |    6 +++-
>  cmds-scrub.c   |   10 ++++---
>  utils.c        |   73 +++++++++++++++++++++++++++++++++++++++----------------
>  utils.h        |    2 +-
>  5 files changed, 66 insertions(+), 30 deletions(-)
> 
> diff --git a/cmds-device.c b/cmds-device.c
> index 58df6da..41e79d3 100644
> --- a/cmds-device.c
> +++ b/cmds-device.c
> @@ -321,13 +321,14 @@ static int cmd_dev_stats(int argc, char **argv)
>  
>  	path = argv[optind];
>  
> -	fdmnt = open_file_or_dir(path);
> +	fdmnt = open_path_or_dev_mnt(path);
> +
>  	if (fdmnt < 0) {
>  		fprintf(stderr, "ERROR: can't access '%s'\n", path);
>  		return 12;
>  	}
>  
> -	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
> +	ret = get_fs_info(path, &fi_args, &di_args);
>  	if (ret) {
>  		fprintf(stderr, "ERROR: getting dev info for devstats failed: "
>  				"%s\n", strerror(-ret));
> diff --git a/cmds-replace.c b/cmds-replace.c
> index 10030f6..6397bb5 100644
> --- a/cmds-replace.c
> +++ b/cmds-replace.c
> @@ -168,7 +168,9 @@ static int cmd_start_replace(int argc, char **argv)
>  	if (check_argc_exact(argc - optind, 3))
>  		usage(cmd_start_replace_usage);
>  	path = argv[optind + 2];
> -	fdmnt = open_file_or_dir(path);
> +
> +	fdmnt = open_path_or_dev_mnt(path);
> +
>  	if (fdmnt < 0) {
>  		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
>  			path, strerror(errno));
> @@ -215,7 +217,7 @@ static int cmd_start_replace(int argc, char **argv)
>  		}
>  		start_args.start.srcdevid = (__u64)atoi(srcdev);
>  
> -		ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
> +		ret = get_fs_info(path, &fi_args, &di_args);
>  		if (ret) {
>  			fprintf(stderr, "ERROR: getting dev info for devstats failed: "
>  					"%s\n", strerror(-ret));
> diff --git a/cmds-scrub.c b/cmds-scrub.c
> index e5fccc7..52264f1 100644
> --- a/cmds-scrub.c
> +++ b/cmds-scrub.c
> @@ -1101,13 +1101,14 @@ static int scrub_start(int argc, char **argv, int resume)
>  
>  	path = argv[optind];
>  
> -	fdmnt = open_file_or_dir(path);
> +	fdmnt = open_path_or_dev_mnt(path);
> +
>  	if (fdmnt < 0) {
>  		ERR(!do_quiet, "ERROR: can't access '%s'\n", path);
>  		return 12;
>  	}
>  
> -	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
> +	ret = get_fs_info(path, &fi_args, &di_args);
>  	if (ret) {
>  		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
>  		    "%s\n", strerror(-ret));
> @@ -1558,13 +1559,14 @@ static int cmd_scrub_status(int argc, char **argv)
>  
>  	path = argv[optind];
>  
> -	fdmnt = open_file_or_dir(path);
> +	fdmnt = open_path_or_dev_mnt(path);
> +
>  	if (fdmnt < 0) {
>  		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
>  		return 12;
>  	}
>  
> -	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
> +	ret = get_fs_info(path, &fi_args, &di_args);
>  	if (ret) {
>  		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
>  				"%s\n", strerror(-ret));
> diff --git a/utils.c b/utils.c
> index 4bf457f..27cec56 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -717,7 +717,7 @@ int open_path_or_dev_mnt(const char *path)
>  			errno = EINVAL;
>  			return -1;
>  		}
> -		fdmnt = open(mp, O_RDWR);
> +		fdmnt = open_file_or_dir(mp);
>  	} else
>  		fdmnt = open_file_or_dir(path);
>  
> @@ -1544,9 +1544,20 @@ int get_device_info(int fd, u64 devid,
>  	return ret ? -errno : 0;
>  }
>  
> -int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
> +/*
> + * For a given path, fill in the ioctl fs_ and info_ args.
> + * If the path is a btrfs mountpoint, fill info for all devices.
> + * If the path is a btrfs device, fill in only that device.
> + *
> + * The path provided must be either on a mounted btrfs fs,
> + * or be a mounted btrfs device.
> + *
> + * Returns 0 on success, or a negative errno.
> + */
> +int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		struct btrfs_ioctl_dev_info_args **di_ret)
>  {
> +	int fd = -1;
>  	int ret = 0;
>  	int ndevs = 0;
>  	int i = 1;
> @@ -1556,33 +1567,50 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  
>  	memset(fi_args, 0, sizeof(*fi_args));
>  
> -	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
> -	if (ret && (errno == EINVAL || errno == ENOTTY)) {
> -		/* path is not a mounted btrfs. Try if it's a device */
> +	if (is_block_device(path)) {
> +		/* Ensure it's mounted, then set path to the mountpoint */
> +		fd = open(path, O_RDONLY);
> +		if (fd < 0) {
> +			ret = -errno;
> +			fprintf(stderr, "Couldn't open %s: %s\n",
> +				path, strerror(errno));
> +			goto out;
> +		}
>  		ret = check_mounted_where(fd, path, mp, sizeof(mp),
>  					  &fs_devices_mnt);
> -		if (!ret)
> -			return -EINVAL;
> -		if (ret < 0)
> -			return ret;
> +		if (ret < 0) {
> +			fprintf(stderr, "Couldn't get mountpoint for %s: %s\n",
> +				path, strerror(-ret));
> +			goto out;
> +		}
> +		path = mp;
> +		/* Only fill in this one device */
>  		fi_args->num_devices = 1;
>  		fi_args->max_id = fs_devices_mnt->latest_devid;
>  		i = fs_devices_mnt->latest_devid;
>  		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
> -		close(fd);
> -		fd = open_file_or_dir(mp);
> -		if (fd < 0)
> -			return -errno;
> -	} else if (ret) {
> -		return -errno;
> +	}
> +
> +	fd = open_file_or_dir(path);
> +	if (fd < 0) {
> +		ret = -errno;
> +		goto out;
> +	}
> +		
> +	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
> +	if (ret < 0) {
> +		ret = -errno;
> +		goto out;
>  	}
>  
>  	if (!fi_args->num_devices)
> -		return 0;
> +		goto out;
>  
>  	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
> -	if (!di_args)
> -		return -errno;
> +	if (!di_args) {
> +		ret = -errno;
> +		goto out;
> +	}
>  
>  	for (; i <= fi_args->max_id; ++i) {
>  		BUG_ON(ndevs >= fi_args->num_devices);
> @@ -1590,13 +1618,16 @@ int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		if (ret == -ENODEV)
>  			continue;
>  		if (ret)
> -			return ret;
> +			goto out;
>  		ndevs++;
>  	}
>  
>  	BUG_ON(ndevs == 0);
> -
> -	return 0;
> +	ret = 0;
> +out:
> +	if (fd != -1)
> +		close(fd);
> +	return ret;
>  }
>  
>  #define isoctal(c)	(((c) & ~7) == '0')
> diff --git a/utils.h b/utils.h
> index 8e0252b..885b9c5 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -50,7 +50,7 @@ u64 parse_size(char *s);
>  int open_file_or_dir(const char *fname);
>  int get_device_info(int fd, u64 devid,
>  		    struct btrfs_ioctl_dev_info_args *di_args);
> -int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
> +int get_fs_info(char *path, struct btrfs_ioctl_fs_info_args *fi_args,
>  		struct btrfs_ioctl_dev_info_args **di_ret);
>  int get_label(const char *btrfs_dev);
>  int set_label(const char *btrfs_dev, const char *label);
> 

