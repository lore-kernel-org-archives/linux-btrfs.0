Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57336 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdLKUPr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 15:15:47 -0500
Date: Mon, 11 Dec 2017 12:09:46 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: raid56: fix race between merge_bio and
 rbio_orig_end_io
Message-ID: <20171211200945.GA10249@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20171208230235.30636-1-bo.li.liu@oracle.com>
 <233e3f98-5f56-c2b8-1aa3-32ea360fe577@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <233e3f98-5f56-c2b8-1aa3-32ea360fe577@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 09, 2017 at 03:32:18PM +0200, Nikolay Borisov wrote:
> 
> 
> On  9.12.2017 01:02, Liu Bo wrote:
> > We're not allowed to take any new bios to rbio->bio_list in
> > rbio_orig_end_io(), otherwise we may get merged with more bios and
> > rbio->bio_list is not empty.
> > 
> > This should only happens in error-out cases, the normal path of
> > recover and full stripe write have already set RBIO_RMW_LOCKED_BIT to
> > disable merge before doing IO.
> > 
> > Reported-by: Jérôme Carretero <cJ-ko@zougloub.eu>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/raid56.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index 5aa9d22..127c782 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -859,12 +859,23 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
> >   */
> >  static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t err)
> >  {
> > -	struct bio *cur = bio_list_get(&rbio->bio_list);
> > +	struct bio *cur;
> >  	struct bio *next;
> >  
> > +	/*
> > +	 * We're not allowed to take any new bios to rbio->bio_list
> > +	 * from now on, otherwise we may get merged with more bios and
> > +	 * rbio->bio_list is not empty.
> > +	 */
> > +	spin_lock(&rbio->bio_list_lock);
> > +	set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
> > +	spin_unlock(&rbio->bio_list_lock);
> 
> do we really need the spinlock, bit operations are atomic?
> 

Thanks for the question.

Atomicity doesn't really matter here, set_bit() needs to be done in
the critical section so that merge_rbio() can do right things if
merge_rbio() comes after rbio_orig_end_io().

thanks,
-liubo

> > +
> >  	if (rbio->generic_bio_cnt)
> >  		btrfs_bio_counter_sub(rbio->fs_info, rbio->generic_bio_cnt);
> >  
> > +	cur = bio_list_get(&rbio->bio_list);
> > +
> >  	free_raid_bio(rbio);
> >  
> >  	while (cur) {
> > 
