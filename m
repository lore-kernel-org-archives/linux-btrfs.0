Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:32906 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdHWTSV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 15:18:21 -0400
Received: by mail-pg0-f45.google.com with SMTP id t3so3990440pgt.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 12:18:21 -0700 (PDT)
Date: Wed, 23 Aug 2017 12:18:19 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 1/7] Btrfs: fix blk_status_t/errno confusion
Message-ID: <20170823191819.GB15578@vader>
References: <cover.1503470354.git.osandov@fb.com>
 <f67c635fab2edc4212f0a30cdb0dfe709f1583f0.1503470354.git.osandov@fb.com>
 <20170823161340.GA1522@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823161340.GA1522@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 10:13:40AM -0600, Liu Bo wrote:
> On Tue, Aug 22, 2017 at 11:45:59PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > This fixes several instances of blk_status_t and bare errno ints being
> > mixed up, some of which are real bugs.
> > 
> > Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
> > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > ---
> >  fs/btrfs/disk-io.c |  4 ++--
> >  fs/btrfs/inode.c   | 70 +++++++++++++++++++++++++++++-------------------------
> >  fs/btrfs/raid56.c  | 34 +++++++++++++-------------
> >  fs/btrfs/volumes.c | 10 ++++----
> >  fs/btrfs/volumes.h |  6 ++---
> >  5 files changed, 64 insertions(+), 60 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 080e2ebb8aa0..f45b61fe9a9a 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3516,7 +3516,7 @@ static blk_status_t wait_dev_flush(struct btrfs_device *device)
> >  	struct bio *bio = device->flush_bio;
> >  
> >  	if (!device->flush_bio_sent)
> > -		return 0;
> > +		return BLK_STS_OK;
> >  
> >  	device->flush_bio_sent = 0;
> >  	wait_for_completion_io(&device->flush_wait);
> > @@ -3563,7 +3563,7 @@ static int barrier_all_devices(struct btrfs_fs_info *info)
> >  			continue;
> >  
> >  		write_dev_flush(dev);
> > -		dev->last_flush_error = 0;
> > +		dev->last_flush_error = BLK_STS_OK;
> >  	}
> >  
> >  	/* wait for all the barriers */
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 95c212037095..24bcd5cd9cf2 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7924,11 +7924,12 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
> >  	return ret;
> >  }
> >  
> > -static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
> > -					int mirror_num)
> > +static inline blk_status_t submit_dio_repair_bio(struct inode *inode,
> > +						 struct bio *bio,
> > +						 int mirror_num)
> >  {
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> > -	int ret;
> > +	blk_status_t ret;
> >  
> >  	BUG_ON(bio_op(bio) == REQ_OP_WRITE);
> >
> 
> In this function, there is btrfs_map_bio() who returns 0 or error
> code, errno_to_blk_status() is also needed for that conversion.

See below, btrfs_map_bio() returns blk_status_t now.

> With that,
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks!

> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index e8b9a269fdde..bd679bc7a1a9 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6212,8 +6212,8 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
> >  	}
> >  }
> >  
> > -int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> > -		  int mirror_num, int async_submit)
> > +blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
> > +			   int mirror_num, int async_submit)
