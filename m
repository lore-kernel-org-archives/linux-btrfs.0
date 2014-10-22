Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40346 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbaJVLKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 07:10:20 -0400
Message-ID: <54479095.8040803@oracle.com>
Date: Wed, 22 Oct 2014 19:10:13 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs_scan_block_devices is unused function
 delete it
References: <1410571282-3482-4-git-send-email-anand.jain@oracle.com> <1412640511-21840-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1412640511-21840-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



   This is just a clean up patch which looks like you have missed
   it in 3.17. sorry if it confused you.


On 10/07/14 08:08, Anand Jain wrote:
> After Patch:
>   remove BTRFS_SCAN_PROC scan method
> There isn't any consumer for btrfs_scan_block_devices() so delete it.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>   utils.c | 83 -----------------------------------------------------------------
>   utils.h |  1 -
>   2 files changed, 84 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index 48d2d9a..b23f332 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1542,89 +1542,6 @@ int set_label(const char *btrfs_dev, const char *label)
>   	return ret;
>   }
>
> -int btrfs_scan_block_devices(int run_ioctl)
> -{
> -
> -	struct stat st;
> -	int ret;
> -	int fd;
> -	struct btrfs_fs_devices *tmp_devices;
> -	u64 num_devices;
> -	FILE *proc_partitions;
> -	int i;
> -	char buf[1024];
> -	char fullpath[110];
> -	int scans = 0;
> -	int special;
> -
> -scan_again:
> -	proc_partitions = fopen("/proc/partitions","r");
> -	if (!proc_partitions) {
> -		fprintf(stderr, "Unable to open '/proc/partitions' for scanning\n");
> -		return -ENOENT;
> -	}
> -	/* skip the header */
> -	for (i = 0; i < 2; i++)
> -		if (!fgets(buf, 1023, proc_partitions)) {
> -			fprintf(stderr,
> -				"Unable to read '/proc/partitions' for scanning\n");
> -			fclose(proc_partitions);
> -			return -ENOENT;
> -		}
> -
> -	strcpy(fullpath,"/dev/");
> -	while(fgets(buf, 1023, proc_partitions)) {
> -		i = sscanf(buf," %*d %*d %*d %99s", fullpath+5);
> -
> -		/*
> -		 * multipath and MD devices may register as a btrfs filesystem
> -		 * both through the original block device and through
> -		 * the special (/dev/mapper or /dev/mdX) entry.
> -		 * This scans the special entries last
> -		 */
> -		special = strncmp(fullpath, "/dev/dm-", strlen("/dev/dm-")) == 0;
> -		if (!special)
> -			special = strncmp(fullpath, "/dev/md", strlen("/dev/md")) == 0;
> -
> -		if (scans == 0 && special)
> -			continue;
> -		if (scans > 0 && !special)
> -			continue;
> -
> -		ret = lstat(fullpath, &st);
> -		if (ret < 0) {
> -			fprintf(stderr, "failed to stat %s\n", fullpath);
> -			continue;
> -		}
> -		if (!S_ISBLK(st.st_mode)) {
> -			continue;
> -		}
> -
> -		fd = open(fullpath, O_RDONLY);
> -		if (fd < 0) {
> -			if (errno != ENOMEDIUM)
> -				fprintf(stderr, "failed to open %s: %s\n",
> -					fullpath, strerror(errno));
> -			continue;
> -		}
> -		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
> -					    &num_devices,
> -					    BTRFS_SUPER_INFO_OFFSET, 0);
> -		if (ret == 0 && run_ioctl > 0) {
> -			btrfs_register_one_device(fullpath);
> -		}
> -		close(fd);
> -	}
> -
> -	fclose(proc_partitions);
> -
> -	if (scans == 0) {
> -		scans++;
> -		goto scan_again;
> -	}
> -	return 0;
> -}
> -
>   /*
>    * A not-so-good version fls64. No fascinating optimization since
>    * no one except parse_size use it
> diff --git a/utils.h b/utils.h
> index 1536469..e332fd1 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -100,7 +100,6 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes, unsigned unit_mo
>   	})
>
>   int get_mountpt(char *dev, char *mntpt, size_t size);
> -int btrfs_scan_block_devices(int run_ioctl);
>   u64 parse_size(char *s);
>   u64 arg_strtou64(const char *str);
>   int open_file_or_dir(const char *fname, DIR **dirstream);
>
