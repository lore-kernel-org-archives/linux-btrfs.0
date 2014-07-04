Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2435 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbaGDH0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 03:26:12 -0400
Message-ID: <53B65750.8050105@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 15:27:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] btrfs-progs: Add minimum device size check.
References: <1403572384-22541-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1403572384-22541-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm very sorry that even v3 version patch screws up the mkfs.btrfs.

The problem is that the variant 'file' is reused later in add device.
I'll send the v4 verion of the patch.

I'm very sorry for the problem and extra effort to merge it.
Qu.

-------- Original Message --------
Subject: [PATCH v3] btrfs-progs: Add minimum device size check.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年06月24日 09:13
> Btrfs has global block reservation, so even mkfs.btrfs can execute
> without problem, there is still a possibility that the filesystem can't
> be mounted.
> For example when mkfs.btrfs on a 8M file on x86_64 platform, kernel will
> refuse to mount due to ENOSPC, since system block group takes 4M and
> mixed block group takes 4M, and global block reservation will takes all
> the 4M from mixed block group, which makes btrfs unable to create uuid
> tree.
>
> This patch will add minimum device size check before actually mkfs.
> The minimum size calculation uses a simplified one:
> minimum_size_for_each_dev = 2 * (system block group + global block rsv)
> and global block rsv = leafsize << 10
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> changelog:
> v2: Use leafsize to get consistent with kernel global_block_rsv
> calculation.
> v3: Change words in error string.
>      Use separate inline function to calculate global block rsv size.
>      Rename the minimum device size calculation function.
> ---
>   mkfs.c  | 28 ++++++++++++++++++++++++++++
>   utils.c | 20 ++++++++++++++++++++
>   utils.h | 21 +++++++++++++++++++++
>   3 files changed, 69 insertions(+)
>
> diff --git a/mkfs.c b/mkfs.c
> index 16e9222..d384e91 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1431,6 +1431,34 @@ int main(int ac, char **av)
>   		}
>   	}
>   
> +	/* Check device/block_count after the leafsize is determined */
> +	if (block_count && block_count < btrfs_min_dev_size(leafsize)) {
> +		fprintf(stderr,
> +			"Size '%llu' is too small to make a usable btrfs\n",
> +			block_count);
> +		fprintf(stderr,
> +			"Minimum size for btrfs filesystem is %llu\n",
> +			btrfs_min_dev_size(leafsize));
> +		exit(1);
> +	}
> +	for (i = saved_optind; i < saved_optind + dev_cnt; i++) {
> +		file = av[i];
> +		ret = test_minimum_size(file, leafsize);
> +		if (ret < 0) {
> +			fprintf(stderr, "Failed to check size for '%s': %s\n",
> +				file, strerror(-ret));
> +			exit (1);
> +		}
> +		if (ret > 0) {
> +			fprintf(stderr,
> +				"'%s' is too small to make a usable btrfs.\n",
> +				file);
> +			fprintf(stderr,
> +				"Minimum size for each btrfs device is %llu.\n",
> +				btrfs_min_dev_size(leafsize));
> +			exit(1);
> +		}
> +	}
>   	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
>   			dev_cnt, mixed, estr);
>   	if (ret) {
> diff --git a/utils.c b/utils.c
> index e130849..b078c95 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -2206,3 +2206,23 @@ int find_mount_root(const char *path, char **mount_root)
>   	free(longest_match);
>   	return ret;
>   }
> +
> +int test_minimum_size(const char *file, u64 leafsize)
> +{
> +	int fd;
> +	struct stat statbuf;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +	if (stat(file, &statbuf) < 0) {
> +		close(fd);
> +		return -errno;
> +	}
> +	if (btrfs_device_size(fd, &statbuf) < btrfs_min_dev_size(leafsize)) {
> +		close(fd);
> +		return 1;
> +	}
> +	close(fd);
> +	return 0;
> +}
> diff --git a/utils.h b/utils.h
> index db8d63c..e1b6ff2 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -101,5 +101,26 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
>   int find_mount_root(const char *path, char **mount_root);
>   int get_device_info(int fd, u64 devid,
>   		struct btrfs_ioctl_dev_info_args *di_args);
> +int test_minimum_size(const char *file, u64 leafsize);
> +
> +/*
> + * Btrfs minimum size calculation is complicated, it should include at least:
> + * 1. system group size
> + * 2. minimum global block reserve
> + * 3. metadata used at mkfs
> + * 4. space reservation to create uuid for first mount.
> + * Also, raid factor should also be taken into consideration.
> + * To avoid the overkill calculation, (system group + global block rsv) * 2
> + * for *EACH* device should be good enough.
> + */
> +static inline u64 btrfs_min_global_blk_rsv_size(u32 leafsize)
> +{
> +	return leafsize << 10;
> +}
> +static inline u64 btrfs_min_dev_size(u32 leafsize)
> +{
> +	return 2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE +
> +		    btrfs_min_global_blk_rsv_size(leafsize));
> +}
>   
>   #endif

