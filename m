Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35549 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdJKRJK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:09:10 -0400
Date: Wed, 11 Oct 2017 19:07:23 +0200
From: David Sterba <dsterba@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/5] btrfs: ensure that metadata and flush are issued
 from the root cgroup
Message-ID: <20171011170723.GX3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171010155441.753966-1-tj@kernel.org>
 <20171010155441.753966-6-tj@kernel.org>
 <20171010164325.GN3301751@devbig577.frc2.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171010164325.GN3301751@devbig577.frc2.facebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 10, 2017 at 09:43:26AM -0700, Tejun Heo wrote:
> >From 3bbed8c7747739cda48f592f165e8839da076a3a Mon Sep 17 00:00:00 2001
> 
> Issuing metdata or otherwise shared IOs from !root cgroup can lead to
> priority inversion.  This patch ensures that those IOs are always
> issued from the root cgroup.
> 
> This patch updates btrfs_update_iflags() to not set S_CGROUPWB on
> btree_inodes.

The 'btree_inode' is only one, with inode number 1, and represents all
the metadata, so I don't understand what it means in plural.

> This isn't strictly necessary as those inodes don't
> call the function during init; however, this serves as documentation
> and prevents possible future mistakes.  If this isn't desirable,
> please feel free to drop the section.
> 
> v2: Fixed missing @bh in submit_bh_blkcg_css() call.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/check-integrity.c | 2 +-
>  fs/btrfs/disk-io.c         | 4 ++++
>  fs/btrfs/ioctl.c           | 4 +++-
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 7d5a9b5..d66774e 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2741,7 +2741,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
>  	struct btrfsic_dev_state *dev_state;
>  
>  	if (!btrfsic_is_initialized)
> -		return submit_bh(op, op_flags, bh);
> +		return submit_bh_blkcg_css(op, op_flags, bh, blkcg_root_css);
>  
>  	mutex_lock(&btrfsic_mutex);
>  	/* since btrfsic_submit_bh() might also be called before
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index dfdab84..fe8bbe1 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1025,6 +1025,8 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
>  	int async = check_async_write(bio_flags);
>  	blk_status_t ret;
>  
> +	bio_associate_blkcg(bio, blkcg_root_css);
> +
>  	if (bio_op(bio) != REQ_OP_WRITE) {
>  		/*
>  		 * called for a read, do the setup so that checksum validation
> @@ -3512,6 +3514,8 @@ static void write_dev_flush(struct btrfs_device *device)
>  		return;
>  
>  	bio_reset(bio);
> +	bio_associate_blkcg(bio, blkcg_root_css);
> +
>  	bio->bi_end_io = btrfs_end_empty_barrier;
>  	bio_set_dev(bio, device->bdev);
>  	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 117cc63..8a7db6c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -150,7 +150,9 @@ void btrfs_update_iflags(struct inode *inode)
>  		new_fl |= S_NOATIME;
>  	if (ip->flags & BTRFS_INODE_DIRSYNC)
>  		new_fl |= S_DIRSYNC;
> -	new_fl |= S_CGROUPWB;
> +	/* btree_inodes are always in the root cgroup */
> +	if (btrfs_ino(ip) != BTRFS_BTREE_INODE_OBJECTID)
> +		new_fl |= S_CGROUPWB;

The comment is useful, but the condition will be always true, so I don't
see the point.

	/*
	 * The btree_inode will be always in the root cgroup. The cgroup
	 * writeback can be enabled on regular inodes selectively.
	 */
	new_fl |= S_CGROUPWB;

is IMHO enough, based on my reading of patch 2/5 changelog.

>  
>  	set_mask_bits(&inode->i_flags,
>  		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
