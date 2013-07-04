Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:57515 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab3GDMU7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 08:20:59 -0400
Message-ID: <51D568A9.8030709@giantdisaster.de>
Date: Thu, 04 Jul 2013 14:20:57 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix wrong write offset when replacing a device
References: <1372934241-421-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372934241-421-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 4 Jul 2013 18:37:21 +0800, Miao Xie wrote:
> The filesystem was corrupted after we did a device replace.
> 
> Steps to reproduce:
>  # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
>  # mount <device0> <mnt>
>  # btrfs replace start -rfB 1 <device4> <mnt>
>  # umount <mnt>
>  # btrfsck <device4>
> 
> The reason is that we changed the write offset by mistake. When we
> replace the a device, we read the data from the source device at first,
> and then write the data into the corresponding place of the new device.
> But when we read the data, we will try to spread the read request among
> the mirrors. It is a good idea that can speed up the read request, but
> should not change the write offset because it is corresponding to the source
> device, not the mirror device, if we change it by the offset of the mirror
> device, we would get the wrong offset. Fix it.

The main reason for the remapping is not to try to spread the read request, it is done in order to implement the "-r" option ("-r  only read from srcdev if no other zero-defect mirror exists", this handles the case where the srcdev is very slow due to lots of read errors).

Commit 625f1c8dc changed the write address. It was the right address before, the unmapped one.

The physical disk address that is used to read from disk needs to be the mapped one (refer to scrub_add_page_to_rd_bio()), the address to write to disk needs to be the unmapped one. With the current patch, you use the right one for writing but the wrong one for reading.

The following code should fix the wrong write address, it reverts the change to the write address from the aforementioned commit. I'll prepare and send a proper commit (after testing all RAID/single/dup cases).

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2495,7 +2495,8 @@ again:
        ret = scrub_extent(sctx, extent_logical, extent_len,
                           extent_physical, extent_dev, flags,
                           generation, extent_mirror_num,
-                          extent_physical);
+                          extent_logical - logical +
+                           physical);
        if (ret)
                goto out;

> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/scrub.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 929093d..092bec4 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -228,7 +228,6 @@ static void scrub_bio_end_io_worker(struct btrfs_work *work);
>  static void scrub_block_complete(struct scrub_block *sblock);
>  static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
>  			       u64 extent_logical, u64 extent_len,
> -			       u64 *extent_physical,
>  			       struct btrfs_device **extent_dev,
>  			       int *extent_mirror_num);
>  static int scrub_setup_wr_ctx(struct scrub_ctx *sctx,
> @@ -2482,8 +2481,7 @@ again:
>  			extent_mirror_num = mirror_num;
>  			if (is_dev_replace)
>  				scrub_remap_extent(fs_info, extent_logical,
> -						   extent_len, &extent_physical,
> -						   &extent_dev,
> +						   extent_len, &extent_dev,
>  						   &extent_mirror_num);
>  
>  			ret = btrfs_lookup_csums_range(csum_root, logical,
> @@ -3057,7 +3055,6 @@ int btrfs_scrub_progress(struct btrfs_root *root, u64 devid,
>  
>  static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
>  			       u64 extent_logical, u64 extent_len,
> -			       u64 *extent_physical,
>  			       struct btrfs_device **extent_dev,
>  			       int *extent_mirror_num)
>  {
> @@ -3074,7 +3071,6 @@ static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
>  		return;
>  	}
>  
> -	*extent_physical = bbio->stripes[0].physical;
>  	*extent_mirror_num = bbio->mirror_num;
>  	*extent_dev = bbio->stripes[0].dev;
>  	kfree(bbio);
> 

