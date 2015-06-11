Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41461 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbbFKIFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 04:05:51 -0400
Date: Thu, 11 Jun 2015 16:05:30 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [RFC] add a bi_error field
Message-ID: <20150611080528.GD9634@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <20150611075921.GC9634@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150611075921.GC9634@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 11, 2015 at 03:59:22PM +0800, Liu Bo wrote:
> On Wed, Jun 03, 2015 at 03:42:38PM +0200, Christoph Hellwig wrote:
> > Bio error reporting has been a mess for a while, and the increasing
> > use of chained bios makes it worse.
> > 
> > This series attempts to add a proper error field to struct bio
> > to sort this out.  It's working fine for me, but MD and btrfs were
> > doing pretty nasty things with the BIO_UPTODATE flag, so I would
> > appreciate some detailed review there.
> 
> Somehow the patch is missing from my mailbox, but this cover letter
> remains, I have to review it from online archive.
> 
> Anyway, I went through btrfs part and it looks good.
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com> (btrfs part)

Also there're some conflicts in btrfs_end_empty_barrier():

...
static void btrfs_end_empty_barrier(struct bio *bio, int err)
{
	if (err) {
		if (err == -EOPNOTSUPP)
			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		clear_bit(BIO_UPTODATE, &bio->bi_flags);
	}
	if (bio->bi_private)
		complete(bio->bi_private);
	bio_put(bio);
}

Thanks,

-liubo
