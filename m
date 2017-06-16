Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35195 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752566AbdFPNST (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 09:18:19 -0400
Date: Fri, 16 Jun 2017 15:17:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] btrfs: preallocate device flush bio
Message-ID: <20170616131713.GH25451@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1497544265.git.dsterba@suse.com>
 <3d57b2def025d49df83e6e62fd153f40e91a87e4.1497544265.git.dsterba@suse.com>
 <ec8c7522-2038-2e69-8834-5313b087ae01@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ec8c7522-2038-2e69-8834-5313b087ae01@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 16, 2017 at 05:53:12AM +0800, Anand Jain wrote:
> On 06/16/2017 12:49 AM, David Sterba wrote:
> > For devices that support flushing, we allocate a bio, submit, wait for
> > it and then free it. The bio allocation does not fail so ENOMEM is not a
> > problem but we still may unnecessarily stress the allocation subsystem.
> > 
> > Instead, we can allocate the device at the same time we allocate the
> > device and reuse it each time we need to flush the barriers. The bio is
> > reset before each use. Reference counting is simplified to just device
> > allocation (get) and freeing (put).
> > 
> > Note for write_dev_flush: we check the queue flush status again as we
> > can't use the existence of bio as before.
> 
>   Looks good few items as below..
> 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/disk-io.c | 24 ++++++------------------
> >   fs/btrfs/volumes.c | 12 ++++++++++++
> >   2 files changed, 18 insertions(+), 18 deletions(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 2b00ebff13f8..27d44d6ab775 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3482,9 +3482,7 @@ static int write_dev_supers(struct btrfs_device *device,
> >    */
> >   static void btrfs_end_empty_barrier(struct bio *bio)
> >   {
> > -	if (bio->bi_private)
> > -		complete(bio->bi_private);
> > -	bio_put(bio);
> > +	complete(bio->bi_private);
> >   }
> >   
> >   /*
> > @@ -3494,26 +3492,19 @@ static void btrfs_end_empty_barrier(struct bio *bio)
> >   static void write_dev_flush(struct btrfs_device *device)
> >   {
> >   	struct request_queue *q = bdev_get_queue(device->bdev);
> > -	struct bio *bio;
> > +	struct bio *bio = device->flush_bio;
> >   
> >   	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> >   		return;
> >   
> > -	/*
> > -	 * one reference for us, and we leave it for the
> > -	 * caller
> > -	 */
> > -	device->flush_bio = NULL;
> > -	bio = btrfs_io_bio_alloc(0);
> > +	bio_reset(bio);
> >   	bio->bi_end_io = btrfs_end_empty_barrier;
> >   	bio->bi_bdev = device->bdev;
> >   	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
> >   	init_completion(&device->flush_wait);
> >   	bio->bi_private = &device->flush_wait;
> > -	device->flush_bio = bio;
> >   
> > -	bio_get(bio);
> > -	btrfsic_submit_bio(bio);
> > +	submit_bio(bio);
> 
>   Originally it went through the btrfsic. There is no mention
>   of this change if its not an oversight.

Right, avoiding is intentional I just forgot to mention it in the
changelog. The bio has no data attached so integrity checker will skip
it.

> >   /*
> > @@ -3522,9 +3513,10 @@ static void write_dev_flush(struct btrfs_device *device)
> >   static int wait_dev_flush(struct btrfs_device *device)
> >   {
> >   	int ret = 0;
> > +	struct request_queue *q = bdev_get_queue(device->bdev);
> >   	struct bio *bio = device->flush_bio;
> >   
> > -	if (!bio)
> > +	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags))
> >   		return 0;
> 
>   It returns here if its write through. Which can be toggled
>   after write_dev_flush() has been called such as..
> 
>    echo "write back" > /sys/block/sdd/queue/write_cache
>    write_dev_flush(sdd)
>    echo "write through" > /sys/block/sdd/queue/write_cache
>    wait_dev_flush(sdd)
> 
>   So it would fails to check error.

Yeah, the bio would stay in flight. I had to read more about the flushes
but I apparently mixed it up with FUA. Toggling write cache needs to be
handled properly which needs to pull the relevant bits from patch 4/5
and the force_dev_flush sysfs knob does not make sense, as you noted.
Thanks.
