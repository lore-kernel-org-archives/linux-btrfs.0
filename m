Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48127 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271AbbAPBif (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 20:38:35 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, "'Miao Xie'" <miaox@cn.fujitsu.com>
References: <1421152488-30548-1-git-send-email-zhaolei@cn.fujitsu.com> <1421152488-30548-5-git-send-email-zhaolei@cn.fujitsu.com> <20150115125230.GG3685@twin.jikos.cz>
In-Reply-To: <20150115125230.GG3685@twin.jikos.cz>
Subject: RE: [PATCH 04/15] Btrfs: add ref_count and free function for btrfs_bio
Date: Fri, 16 Jan 2015 09:38:20 +0800
Message-ID: <021d01d0312d$1c8482c0$558d8840$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

* From: David Sterba [mailto:dsterba@suse.cz]
> The cleanups look good in general, some minor nitpicks below.
> 
> On Tue, Jan 13, 2015 at 08:34:37PM +0800, Zhaolei wrote:
> > -		kfree(bbio);
> > +		put_btrfs_bio(bbio);
> 
> Please rename it to btrfs_put_bbio, this is more consistent with other
> *_put_* helpers and 'bbio' distinguishes btrfs_bio from regular 'bio'.
> 
Good suggestion, I like these unified-format name.

> >
> >  static void btrfs_end_bio(struct bio *bio, int err)
> > diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> > index fb0e8c3..db195f0 100644
> > --- a/fs/btrfs/volumes.h
> > +++ b/fs/btrfs/volumes.h
> > @@ -295,6 +295,7 @@ typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
> >  #define BTRFS_BIO_ORIG_BIO_SUBMITTED	(1 << 0)
> >
> >  struct btrfs_bio {
> > +	atomic_t ref_count;
> 
> 	atomic_t refs;
> 
Ok.

> >  	atomic_t stripes_pending;
> >  	struct btrfs_fs_info *fs_info;
> >  	bio_end_io_t *end_io;
> > @@ -394,13 +395,8 @@ struct btrfs_balance_control {
> >
> >  int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
> >  				   u64 end, u64 *length);
> > -
> > -#define btrfs_bio_size(total_stripes, real_stripes)		\
> > -	(sizeof(struct btrfs_bio) +				\
> > -	 (sizeof(struct btrfs_bio_stripe) * (total_stripes)) +	\
> > -	 (sizeof(int) * (real_stripes)) +			\
> > -	 (sizeof(u64) * (real_stripes)))
> > -
> > +void get_btrfs_bio(struct btrfs_bio *bbio);
> 
> 	btrfs_get_bbio
> 
Thanks for your suggestion, I'll include above changes in v2.

Thanks
Zhaolei

> > +void put_btrfs_bio(struct btrfs_bio *bbio);
> >  int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
> >  		    u64 logical, u64 *length,
> >  		    struct btrfs_bio **bbio_ret, int mirror_num);


