Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab3ILQgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 12:36:32 -0400
Date: Thu, 12 Sep 2013 18:36:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
Message-ID: <20130912163629.GD6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-1-git-send-email-anand.jain@oracle.com>
 <1378460273-20647-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378460273-20647-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 06, 2013 at 05:37:53PM +0800, Anand Jain wrote:
> Further, to scan for the disks this patch will use
> lblkid, so that we don't have to manually scan the
> /dev or /dev/mapper which means we don't need the
> all-devices options.

Thanks for implementing it! I found a few things to fix, comments below.

I wonder if we should keep --all-devices as a last resort fallback eg.
when blkid cache is not available.

> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> -static int uuid_search(struct btrfs_fs_devices *fs_devices, char *search)
> -{
> -	char uuidbuf[37];
> -	struct list_head *cur;
> -	struct btrfs_device *device;
> -	int search_len = strlen(search);
> -
> -	search_len = min(search_len, 37);
> -	uuid_unparse(fs_devices->fsid, uuidbuf);
> -	if (!strncmp(uuidbuf, search, search_len))
> -		return 1;
> -
> -	list_for_each(cur, &fs_devices->devices) {
> -		device = list_entry(cur, struct btrfs_device, dev_list);
> -		if ((device->label && strcmp(device->label, search) == 0) ||
> -		    strcmp(device->name, search) == 0)
> -			return 1;
> -	}
> -	return 0;
> -}

This is removing functionality and I don't understand why. It's used for

$ btrfs fi show 9f135b48-cc15-424b-8730-a6432c67dc34
[prints only the given filesystem]

and with your patch does not work as such. Can it be implemented on top
of the code you're adding in this patch? If yes, please make a separate
patch for that.

> @@ -232,8 +214,108 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
>  	printf("\n");
>  }
>  
> +/* adds up all the used spaces as reported by the space info ioctl
> + */
> +static u64 cal_used_bytes(struct btrfs_ioctl_space_args *si)

calc_used_bytes

> +static int btrfs_scan_kernel(void *input, int type)
> +{
> +	int ret = 0, fd;
> +	FILE *f;
> +	struct mntent *mnt;
> +	struct btrfs_ioctl_fs_info_args fi;
> +	struct btrfs_ioctl_dev_info_args *di = NULL;
> +	struct btrfs_ioctl_space_args *si;

the variable names are not very descriptive

> +	char label[BTRFS_LABEL_SIZE];
> +
> +	f = setmntent("/proc/mounts", "r");

should be /proc/self/mounts

> +	if (f == NULL)
> +		return -errno;

man says that setmntent does not set errno 

> +
> +	while ((mnt = getmntent(f)) != NULL) {
> +		if (strcmp(mnt->mnt_type, "btrfs"))
> +			continue;
> +		ret = get_fs_info(mnt->mnt_dir, &fi, &di);
> +		if (ret)
> +			return ret;
> +
> +		switch (type) {

Please add defines instead of the integers representing 'type'.

> +		case 0:
> +			break;
> +		case 1:
> +			if (uuid_compare(fi.fsid, (u8 *)input))
> +				continue;
> +			break;
> +		case 2:
> +			if (strcmp(input, mnt->mnt_dir))
> +				continue;
> +			break;

I haven't seen 1 and 2 used anywhere

> +		default:
> +			break;
> +		}
> +
> +		fd = open(mnt->mnt_dir, O_RDONLY);
> +		if (fd > 0 && !get_df(fd, &si)) {
> +			get_label_mounted(mnt->mnt_dir, label);
> +			print_one_fs(&fi, di, si, label, mnt->mnt_dir);
> +			free(si);
> +		}
> +		if (fd > 0)
> +			close(fd);
> +		free(di);
> +	}
> +	return ret;
> +}
> @@ -244,36 +326,42 @@ static int cmd_show(int argc, char **argv)
> +	/* show only mounted btrfs disks */
> +	if (argc > 1 && !strcmp(argv[1], "--mounted"))
> +		where = BTRFS_SCAN_MOUNTED;
>  
> -	all_uuids = btrfs_scanned_uuids();
> -	list_for_each(cur_uuid, all_uuids) {
> -		fs_devices = list_entry(cur_uuid, struct btrfs_fs_devices,
> +	switch (where) {
> +	case 0:
> +		/* no option : show both mounted and unmounted
> +		 */
> +		/* mounted */
> +		ret = btrfs_scan_kernel(NULL, 0);
> +		if (ret)
> +			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
> +				ret);

I see this warning and there are no mounted filesystems listed in the
output:

$ ./btrfs fi show
ERROR: scan kernel failed, -1


> +
> +		/* unmounted */
> +		scan_for_btrfs_v2(!BTRFS_UPDATE_KERNEL);
> +		all_uuids = btrfs_scanned_uuids();
> +		list_for_each(cur_uuid, all_uuids) {
> +			fs_devices = list_entry(cur_uuid,
> +					struct btrfs_fs_devices,
>  					list);
> -		if (search && uuid_search(fs_devices, search) == 0)
> -			continue;
> -		print_one_uuid(fs_devices);
> +			print_one_uuid(fs_devices);
> +		}
> +		break;
> +	case BTRFS_SCAN_MOUNTED:
> +		ret = btrfs_scan_kernel(NULL, 0);
> +		if (ret)
> +			fprintf(stderr, "ERROR: scan kernel failed, %d\n",
> +				ret);
> +		break;
>  	}
>  	printf("%s\n", BTRFS_BUILD_VERSION);
>  	return 0;
