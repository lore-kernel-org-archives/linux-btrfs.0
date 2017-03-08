Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21704 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933558AbdCHB3c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 20:29:32 -0500
Date: Tue, 7 Mar 2017 17:27:50 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix a bogus warning when converting only data
 or metadata
Message-ID: <20170308012750.GL12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170307203406.GC12408@lim.localdomain>
 <20170307223444.7526-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307223444.7526-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 11:34:44PM +0100, Adam Borowski wrote:
> If your filesystem has, eg, data:raid0 metadata:raid1, and you run "btrfs
> balance -dconvert=raid1", the meta.target field will be uninitialized.
> That's otherwise ok, as it's unused except for this warning.
> 
> Thus, let's use the existing set of raid levels for the comparison.
> 
> As a side effect, non-convert balances will now nag about data>metadata.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> To reproduce:
> dd if=/dev/zero bs=1048576 count=1 seek=4095 of=ra
> dd if=/dev/zero bs=1048576 count=1 seek=4095 of=rb
> mkfs.btrfs ra rb     # defaults to -draid0 -mraid1
> losetup -f ra
> losetup -f rb
> mount /dev/loop0 /mnt/vol1
> btrfs balance start -dconvert=raid1 /mnt/vol1
> 
> 
> On Tue, Mar 07, 2017 at 12:34:07PM -0800, Liu Bo wrote:
> > This looks good, but this also brings another side effect, @bctl would
> > also be kept in balance_item which will be used to resume balance in
> > case of crash, so it may see a different bctl->meta.target.
> >
> > So would you please use local varibles for meta.target and data.target?
> 
> Okay.
> 
> I'm not sure why storing a bogus value that came from userspace and was
> uninitialized there (0 in normal use) would be better, but here we go:
> v2 doesn't overwrite what we got anymore.
> 
> Unrelated: I wonder if the profiles in the warning message shouldn't be
> printk'ed as words (akin to ebce0e01), but we don't have a function to do
> that, have we?
>

We don't have it in kernel, but in progs I believe.

For this patch,

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo


> 
> Meow!
> 
>  fs/btrfs/volumes.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3645af2749f8..987f395ddec5 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3750,6 +3750,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		  struct btrfs_ioctl_balance_args *bargs)
>  {
>  	struct btrfs_fs_info *fs_info = bctl->fs_info;
> +	__u64 meta_target, data_target;
>  	u64 allowed;
>  	int mixed = 0;
>  	int ret;
> @@ -3846,11 +3847,16 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		}
>  	} while (read_seqretry(&fs_info->profiles_lock, seq));
>  
> -	if (btrfs_get_num_tolerated_disk_barrier_failures(bctl->meta.target) <
> -		btrfs_get_num_tolerated_disk_barrier_failures(bctl->data.target)) {
> +	/* if we're not converting, the target field is uninitialized */
> +	meta_target = (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
> +		bctl->meta.target : fs_info->avail_metadata_alloc_bits;
> +	data_target = (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
> +		bctl->data.target : fs_info->avail_data_alloc_bits;
> +	if (btrfs_get_num_tolerated_disk_barrier_failures(meta_target) <
> +		btrfs_get_num_tolerated_disk_barrier_failures(data_target)) {
>  		btrfs_warn(fs_info,
>  			   "metadata profile 0x%llx has lower redundancy than data profile 0x%llx",
> -			   bctl->meta.target, bctl->data.target);
> +			   meta_target, data_target);
>  	}
>  
>  	ret = insert_balance_item(fs_info, bctl);
> -- 
> 2.11.0
> 
