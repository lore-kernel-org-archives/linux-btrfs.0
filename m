Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44157 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752737AbdCINoV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Mar 2017 08:44:21 -0500
Date: Thu, 9 Mar 2017 14:43:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v2] btrfs: fix a bogus warning when converting only data
 or metadata
Message-ID: <20170309134327.GE14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170307203406.GC12408@lim.localdomain>
 <20170307223444.7526-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307223444.7526-1-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 11:34:44PM +0100, Adam Borowski wrote:
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

Printing human readable strings would be better, you can copy the
missing functions from progs as Lui pointed out.

> @@ -3750,6 +3750,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		  struct btrfs_ioctl_balance_args *bargs)
>  {
>  	struct btrfs_fs_info *fs_info = bctl->fs_info;
> +	__u64 meta_target, data_target;

Changed to u64, the __u64 is for kernel/userspace interfaces.

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

The patch does not apply to current master, there's

  3861         if (bctl->sys.flags & BTRFS_BALANCE_ARGS_CONVERT) {
  3862                 fs_info->num_tolerated_disk_barrier_failures = min(
  3863                         btrfs_calc_num_tolerated_disk_barrier_failures(fs_info),
  3864                         btrfs_get_num_tolerated_disk_barrier_failures(
  3865                                 bctl->sys.target));
  3866         }
  3867

followed by the line below, I'll merge that manually but slightly wonder
which branch you have used as a base. No big deal though, I'll add the
patch to the queue. Thanks.

>  	ret = insert_balance_item(fs_info, bctl);
