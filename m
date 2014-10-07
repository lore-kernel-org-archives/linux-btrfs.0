Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30882 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830AbaJGIvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 04:51:14 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s978pD3u006369
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Oct 2014 16:51:13 +0800
Message-ID: <5433A97F.8050509@cn.fujitsu.com>
Date: Tue, 7 Oct 2014 16:51:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Fwd: Re: [PATCH] btrfs: add more superblock checks
References: <5433A7D7.4080401@cn.fujitsu.com>
In-Reply-To: <5433A7D7.4080401@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previous reply seems failed to be delivered.

Resend.

-------- 转发的消息 --------
主题: 	Re: [PATCH] btrfs: add more superblock checks
日期: 	Tue, 07 Oct 2014 16:44:07 +0800
发件人: 	Qu Wenruo <quwenruo@cn.fujitsu.com>
收件人: 	David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org



Thanks a lot for the patch to deal with the broken image.

Also this seems more extendable.

Small comment inlined below.

-------- Original Message --------
Subject: [PATCH] btrfs: add more superblock checks
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年10月01日 01:16
> Populate btrfs_check_super_valid() with checks that try to verify
> consistency of superblock by additional conditions that may arise from
> corrupted devices or bitflips. Some of tests are only hints and issue
> warnings instead of failing the mount, basically when the checks are
> derived from the data found in the superblock.
>
> Tested on a broken image provided by Qu.
>
> Reported-by: Qu Wenruo<quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba<dsterba@suse.cz>
> ---
>   fs/btrfs/disk-io.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 65 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a1d36e62179c..bfb00cb1c84c 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3814,10 +3814,73 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
>   static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info,
>   			      int read_only)
>   {
> +	struct btrfs_super_block *sb = fs_info->super_copy;
> +	int ret = 0;
> +
> +	if (sb->root_level > BTRFS_MAX_LEVEL) {
> +		printk(KERN_ERR "BTRFS: tree_root level too big: %d > %d\n",
> +				sb->root_level, BTRFS_MAX_LEVEL);
> +		ret = -EINVAL;
> +	}
> +	if (sb->chunk_root_level > BTRFS_MAX_LEVEL) {
> +		printk(KERN_ERR "BTRFS: chunk_root level too big: %d > %d\n",
> +				sb->chunk_root_level, BTRFS_MAX_LEVEL);
> +		ret = -EINVAL;
> +	}
> +	if (sb->log_root_level > BTRFS_MAX_LEVEL) {
> +		printk(KERN_ERR "BTRFS: log_root level too big: %d > %d\n",
> +				sb->log_root_level, BTRFS_MAX_LEVEL);
> +		ret = -EINVAL;
> +	}
> +
>   	/*
> -	 * Placeholder for checks
> +	 * The common minimum, we don't know if we can trust the nodesize/sectorsize
> +	 * items yet, they'll be verified later. Issue just a warning.
>   	 */
> -	return 0;
> +	if (!IS_ALIGNED(sb->root, 4096))
> +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> +				sb->root);
> +	if (!IS_ALIGNED(sb->chunk_root, 4096))
> +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> +				sb->chunk_root);
> +	if (!IS_ALIGNED(sb->log_root, 4096))
> +		printk(KERN_WARNING "BTRFS: tree_root block unaligned: %llu\n",
> +				sb->log_root);
1) it is better not to call IS_ALIGNED to immediate value//.
Although current btrfs implement ensures that all sectorsize is larger 
equal than page_size,
but Chandan Rajendra is trying to support subpage-sized blocksize,
which may cause false alert later.

It would be much better using btrfs_super_sectorsize() instead to 
improve extendability.

2) missing endian convert.
On big endian system it would be a disaster....
btrfs_super_* marco should be used.

> +
> +	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
> +		printk(KERN_ERR "BTRFS: dev_item UUID does not match fsid: %pU != %pU\n",
> +				fs_info->fsid, sb->dev_item.fsid);
> +		ret = -EINVAL;
> +	}
> +
> +	/*
> +	 * Hint to catch really bogus numbers, bitflips or so, more exact checks are
> +	 * done later
> +	 */
> +	if (sb->num_devices > (1UL << 31))
> +		printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
> +				sb->num_devices);
What about also check the devid with sb->num_devices too?
Every valid devid should be less equal than sb->num_devices if I am right.
Although iterate dev_item here may be overkilled...
> +
> +	if (sb->bytenr != BTRFS_SUPER_INFO_OFFSET) {
> +		printk(KERN_ERR "BTRFS: super offset mismatch %llu != %u\n",
> +				sb->bytenr, BTRFS_SUPER_INFO_OFFSET);
> +		ret = -EINVAL;
> +	}
> +
> +	/*
> +	 * The generation is a global counter, we'll trust it more than the others
> +	 * but it's still possible that it's the one that's wrong.
> +	 */
> +	if (sb->generation < sb->chunk_root_generation)
> +		printk(KERN_WARNING
> +			"BTRFS: suspicious: generation < chunk_root_generation: %llu < %llu\n",
> +			sb->generation, sb->chunk_root_generation);
> +	if (sb->generation < sb->cache_generation && sb->cache_generation != (u64)-1)
> +		printk(KERN_WARNING
> +			"BTRFS: suspicious: generation < cache_generation: %llu < %llu\n",
> +			sb->generation, sb->cache_generation);
> +
> +	return ret;
>   }
>   
Still the endian problem.

Thanks,
Qu
>   static void btrfs_error_commit_super(struct btrfs_root *root)



