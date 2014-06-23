Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbaFWOgD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 10:36:03 -0400
Date: Mon, 23 Jun 2014 16:36:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Add minimum device size check.
Message-ID: <20140623143601.GH1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403148338-6584-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403148338-6584-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 11:25:38AM +0800, Qu Wenruo wrote:
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

So the global block reserve is set to 1024 * sectorsize. I know the
minimum size guesses are easy to get wrong with various option mixes,
some sane minimum is good. A filesystem in the scale of megabytes is not
recommended anyway.

> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1337,6 +1337,15 @@ int main(int ac, char **av)
>  					       "metadata/data groups\n");
>  					mixed = 1;
>  				}
> +				if (block_count < BTRFS_MIN_SIZE_EACH) {
> +					fprintf(stderr,
> +						"Size '%llu' is too small to make a usable btrfs\n",
> +						block_count);
> +					fprintf(stderr,
> +						"Recommended size for each device is %llu\n",
> +						BTRFS_MIN_SIZE_EACH);

I'd suggest to merge the messages into one and do not use "Recommended".
As described in the changelog it's the 'minimum' accepted size.

> @@ -1370,6 +1379,21 @@ int main(int ac, char **av)
>  	}
>  	while (dev_cnt-- > 0) {
>  		file = av[optind++];
> +		ret = test_minimum_size(file);
> +		if (ret < 0) {
> +			fprintf(stderr, "Failed to check size for '%s': %s\n",
> +				file, strerror(-ret));
> +			exit(1);
> +		}
> +		if (ret > 0) {
> +			fprintf(stderr,
> +				"'%s' is too small to make a usable btrfs\n",
> +				file);
> +			fprintf(stderr,
> +				"Recommended size for each device is %llu\n",
> +				BTRFS_MIN_SIZE_EACH);
> +			exit(1);

Same here.

> +		}
>  		if (is_block_device(file))
>  			if (test_dev_for_mkfs(file, force_overwrite, estr)) {
>  				fprintf(stderr, "Error: %s", estr);
> --- a/utils.h
> +++ b/utils.h
> @@ -101,5 +101,18 @@ int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
>  int find_mount_root(const char *path, char **mount_root);
>  int get_device_info(int fd, u64 devid,
>  		struct btrfs_ioctl_dev_info_args *di_args);
> +int test_minimum_size(const char *file);
>  
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
> +#define BTRFS_MIN_SIZE_EACH	(2 * (BTRFS_MKFS_SYSTEM_GROUP_SIZE + \
> +				      ((u64)sysconf(_SC_PAGESIZE) << 10)))

The use of PAGESIZE here is well hidden in the macro, although it should
be sectorsize of the currently created filesystem. Also,
BTRFS_MIN_SIZE_EACH should be rather denote it's related to a device, so
BTRFS_MIN_DEVICE_SIZE.

Separating the minimum global block reserve size into a macro would be
also cleaner.

Thanks.
