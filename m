Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18864 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932158AbdCTUY0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Mar 2017 16:24:26 -0400
Date: Mon, 20 Mar 2017 13:23:33 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] btrfs: raid56: Don't keep rbio for later steal
Message-ID: <20170320202333.GB5540@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170203082023.3577-1-quwenruo@cn.fujitsu.com>
 <20170203082023.3577-5-quwenruo@cn.fujitsu.com>
 <20170317044407.GA24387@lim.localdomain>
 <bfaf7a7e-2330-0419-9549-7c37f2b1f93d@cn.fujitsu.com>
 <20170318020304.GB7719@lim.localdomain>
 <c8fcddef-6bb6-57cc-2980-7a5b28018e2e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c8fcddef-6bb6-57cc-2980-7a5b28018e2e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 20, 2017 at 02:21:48PM +0800, Qu Wenruo wrote:
> 
> 
> At 03/18/2017 10:03 AM, Liu Bo wrote:
> > On Fri, Mar 17, 2017 at 01:28:45PM +0800, Qu Wenruo wrote:
> > > 
> > > 
> > > At 03/17/2017 12:44 PM, Liu Bo wrote:
> > > > On Fri, Feb 03, 2017 at 04:20:22PM +0800, Qu Wenruo wrote:
> > > > > Before this patch, btrfs raid56 will keep raid56 rbio even all its IO is
> > > > > done.
> > > > > This may save some time allocating rbio, but it can cause deadly
> > > > > use-after-free bug, for the following case:
> > > > > 
> > > > > Original fs: 4 devices RAID5
> > > > > 
> > > > >        Process A                 |          Process B
> > > > > --------------------------------------------------------------------------
> > > > >                                  |  Start device replace
> > > > >                                  |    Now the fs has 5 devices
> > > > >                                  |    devid 0: replace device
> > > > >                                  |    devid 1~4: old devices
> > > > > btrfs_map_bio()                  |
> > > > > |- __btrfs_map_block()           |
> > > > > |    bbio has 5 stripes          |
> > > > > |    including devid 0           |
> > > > > |- raid56_parity_write()         |
> > > > >                                  |
> > > > > raid_write_end_io()              |
> > > > > |- rbio_orig_end_io()            |
> > > > >    |- unlock_stripe()            |
> > > > >        Keeps the old rbio for    |
> > > > >        later steal, which has    |
> > > > >        stripe for devid 0        |
> > > > >                                  |  Cancel device replace
> > > > >                                  |    Now the fs has 4 devices
> > > > >                                  |    devid 0 is freed
> > > > > Some IO happens                  |
> > > > > raid_write_end_io()              |
> > > > > |- rbio_orig_end_io()            |
> > > > >    |- unlock_stripe()            |
> > > > >       |- steal_rbio()            |
> > > > >            Use old rbio, whose   |
> > > > >            bbio has freed devid 0|
> > > > >            stripe                |
> > > > > Any access to rbio->bbio will    |
> > > > > cause general protection or NULL |
> > > > > pointer dereference              |
> > > > > 
> > > > > Such bug can already be triggered by fstests btrfs/069 for RAID5/6
> > > > > profiles.
> > > > > 
> > > > > Fix it by not keeping old rbio in unlock_stripe(), so we just free the
> > > > > finished rbio and rbio->bbio, so above problem wont' happen.
> > > > > 
> > > > 
> > > > I don't think this is acceptable, keeping a cache is important for
> > > > raid56 write performance, could you please fix it by checking if the
> > > > device is missing?
> > > 
> > > Not possible, as it's keeping the btrfs_device pointer and never release it,
> > > the stolen rbio can be kept forever until umount.
> > > 
> > 
> > steal_rbio() only takes pages from rbio->stripe_pages, so the cached
> > rbio->bbio is not going to the next IO's rbio because the cached one
> > got freed immediately in steal_rbio(), where could we dereference
> > rbio->bbio?
> 
> Did you mean in unlock_stripe(), we still keep the rbio in cache, while
> release its bbio?
>

I thought it was lock_stripe_add(), OK, so unlock_stripe() just caches
the current rbio and doens't free it.  But the point about
steal_rbio() still stands, steal_rbio() is supposed to take uptodate
pages from the cached old rbio to the current processing rbio, but it
doesn't touch the cached old rbio's bbio, nor uses the cached old rbio
afterwards, instead it is the current processing rbio that would use
its bbio for writing into target devices, but it has increased its own
bio_counter.

> This sounds quite good but I'm afraid it may cause more problems.
> 
> Quite a lot of places are accessing rbio->bbio either for their btrfs
> logical address or stripes or even stripe->dev.
>

I'm confused, could you please specify the call trace of general
protection you got in the commit log?

I wonder if patch 4 and 5 are fixing the same use-after-free problem?

Thanks,

-liubo

> Thanks,
> Qu
> 
> 
> > 
> > Thanks,
> > 
> > -liubo
> > 
> > > And I think the logical is very strange, if RAID5/6 is unstable, there is no
> > > meaning to keep it fast.
> > > 
> > > Keep it stable first, and then consider the performance.
> > > 
> > > Thanks,
> > > Qu
> > > 
> > > > 
> > > > Thanks,
> > > > 
> > > > -liubo
> > > > 
> > > > > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > > > > ---
> > > > >  fs/btrfs/raid56.c | 18 +-----------------
> > > > >  1 file changed, 1 insertion(+), 17 deletions(-)
> > > > > 
> > > > > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > > > > index 453eefdcb591..aba82b95ec73 100644
> > > > > --- a/fs/btrfs/raid56.c
> > > > > +++ b/fs/btrfs/raid56.c
> > > > > @@ -776,7 +776,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
> > > > >  	int bucket;
> > > > >  	struct btrfs_stripe_hash *h;
> > > > >  	unsigned long flags;
> > > > > -	int keep_cache = 0;
> > > > > 
> > > > >  	bucket = rbio_bucket(rbio);
> > > > >  	h = rbio->fs_info->stripe_hash_table->table + bucket;
> > > > > @@ -788,19 +787,6 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
> > > > >  	spin_lock(&rbio->bio_list_lock);
> > > > > 
> > > > >  	if (!list_empty(&rbio->hash_list)) {
> > > > > -		/*
> > > > > -		 * if we're still cached and there is no other IO
> > > > > -		 * to perform, just leave this rbio here for others
> > > > > -		 * to steal from later
> > > > > -		 */
> > > > > -		if (list_empty(&rbio->plug_list) &&
> > > > > -		    test_bit(RBIO_CACHE_BIT, &rbio->flags)) {
> > > > > -			keep_cache = 1;
> > > > > -			clear_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
> > > > > -			BUG_ON(!bio_list_empty(&rbio->bio_list));
> > > > > -			goto done;
> > > > > -		}
> > > > > -
> > > > >  		list_del_init(&rbio->hash_list);
> > > > >  		atomic_dec(&rbio->refs);
> > > > > 
> > > > > @@ -848,13 +834,11 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
> > > > >  			goto done_nolock;
> > > > >  		}
> > > > >  	}
> > > > > -done:
> > > > >  	spin_unlock(&rbio->bio_list_lock);
> > > > >  	spin_unlock_irqrestore(&h->lock, flags);
> > > > > 
> > > > >  done_nolock:
> > > > > -	if (!keep_cache)
> > > > > -		remove_rbio_from_cache(rbio);
> > > > > +	remove_rbio_from_cache(rbio);
> > > > >  }
> > > > > 
> > > > >  static void __free_raid_bio(struct btrfs_raid_bio *rbio)
> > > > > --
> > > > > 2.11.0
> > > > > 
> > > > > 
> > > > > 
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > 
> > > > 
> > > 
> > > 
> > 
> > 
> 
> 
