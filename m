Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45675 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751024AbeCZTZc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 15:25:32 -0400
Subject: Re: [PATCH] btrfs-progs: wipe copies of the stale superblock beyond
 -b size
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <142e5830-3692-ddac-81d9-c29448969c63@suse.com>
Date: Mon, 26 Mar 2018 22:25:28 +0300
MIME-Version: 1.0
In-Reply-To: <20180326082742.9235-10-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180326082742.9235-10-anand.jain@oracle.com>



On 26.03.2018 11:27, Anand Jain wrote:
> During the mkfs.btrfs -b <blockcount> btrfs_prepare_device() zeros all
> the superblock bytenr locations only if the bytenr is below the
> blockcount. The problem with this is that if the BTRFS is recreated
> with a smaller size then we will leave the stale superblock in the disk
> which shall confuse the recovery. As shown in the test case below.
> 
>  mkfs.btrfs -qf /dev/mapper/vg-lv
>  mkfs.btrfs -qf -b1G /dev/mapper/vg-lv
>  btrfs in dump-super -a /dev/mapper/vg-lv | grep '.fsid|superblock:'
> 
>  superblock: bytenr=65536, device=/dev/mapper/vg-lv
>  dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
>  superblock: bytenr=67108864, device=/dev/mapper/vg-lv
>  dev_item.fsid		ebc67d01-7fc5-43f0-90b4-d1925002551e [match]
>  superblock: bytenr=274877906944, device=/dev/mapper/vg-lv
>  dev_item.fsid		b97a9206-593b-4933-a424-c6a6ee23fe7c [match]
> 
> So if we find a valid superblock zero it even if it's beyond the
> blockcount.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  utils.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/utils.c b/utils.c
> index e9cb3a82fda6..6a9408b06e73 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -365,6 +365,41 @@ int btrfs_prepare_device(int fd, const char *file, u64 *block_count_ret,
>  		return 1;
>  	}
>  
> +	/*
> +	 * Check for the BTRFS SB copies up until btrfs_device_size() and zero
> +	 * it. So that kernel (or user for the manual recovery) don't have to
> +	 * confuse with the stale SB copy during recovery.
> +	 */
> +	if (block_count != btrfs_device_size(fd, &st)) {
> +		for (i = 1; i < BTRFS_SUPER_MIRROR_MAX; i++) {
> +			struct btrfs_super_block *disk_super;
> +			char buf[BTRFS_SUPER_INFO_SIZE];
> +			disk_super = (struct btrfs_super_block *)buf;
> +
> +			/* Already zeroed above */
> +			if (btrfs_sb_offset(i) < block_count)
> +				continue;
> +
> +			/* Beyond actual disk size */
> +			if (btrfs_sb_offset(i) >= btrfs_device_size(fd, &st))
> +				continue;
> +
> +			/* Does not contain any stale SB */
> +			if (btrfs_read_dev_super(fd, disk_super,
> +						 btrfs_sb_offset(i), 0))
> +				continue;
> +
> +			ret = zero_dev_clamped(fd, btrfs_sb_offset(i),
> +						BTRFS_SUPER_INFO_SIZE,
> +						btrfs_device_size(fd, &st));
> +			if (ret < 0) {
> +				error("failed to zero device '%s' bytenr %llu: %s",
> +					file, btrfs_sb_offset(i), strerror(-ret));
> +				return 1;
> +			}
> +		}
> +	}
> +

I told you this code can be made a lot simpler, simply by modifying the
last argument passed to zero_dev_clamped. I even posted the resulting
diff which was just 3 lines changed.

I agree that it's a good idea to wipe all available superblock when we
use -b. However I don't agree with your approach - it adds a loop, it
adds a bunch of checks and makes the complexity orders of magnitude
higher than it could be. So I'm asking again - is there any inherent
benefit which I'm missing in your newly added 35 lines of code against
just passing the block device to zero_dev_clamped and letting the
existing logic take care of everything?

>  	*block_count_ret = block_count;
>  	return 0;
>  }
> 
