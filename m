Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38388 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752265AbeCVNPo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 09:15:44 -0400
Subject: Re: [PATCH v2] btrfs-progs: wipe stale sb copy beyond -b size
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <e4abd1b3-ec4e-ca3c-675e-66b2066757c9@suse.com>
Date: Thu, 22 Mar 2018 15:15:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180322130141.19894-3-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180322130141.19894-3-anand.jain@oracle.com>



On 22.03.2018 15:01, Anand Jain wrote:
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
> So, if we find a valid superblock, zero it even if its beyond the
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

I continue asserting that all this code is unnecessary, just wipe every
sb between 0, dev_size and be done with it.


>  	*block_count_ret = block_count;
>  	return 0;
>  }
> 
