Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45478 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbaAGCwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 21:52:16 -0500
Received: by mail-pa0-f54.google.com with SMTP id rd3so19598290pab.27
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jan 2014 18:52:16 -0800 (PST)
Date: Mon, 6 Jan 2014 18:52:10 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Chris Mason <clm@fb.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140107025210.GJ9037@kmo>
References: <20140102053101.GA29352@localhost>
 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
 <20140106221036.GE9037@kmo>
 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 06, 2014 at 04:47:38PM -0800, Muthu Kumar wrote:
> OK, after a bit more staring I believe the correct fix is the following.

This code still confuses me but I think you're correct, the fix certainly
matches the evidence we have.

> Fengguang, Please try this one?
> 
> Regards,
> Muthu
> 
> ------------
> In btrfs_end_bio(), we increment bi_remaining if is_orig_bio. If not,
> we restore the orig_bio but failed to increment bi_remaining for
> orig_bio, which triggers a BUG_ON later when bio_endio is called. Fix
> is to increment bi_remaining when we restore the orig bio as well.
> 
> Reported-by: fengguang.wu@intel.com
> CC: Kent Overstreet <kmo@daterainc.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Chris Mason <clm@fv
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> ----------------
>  fs/btrfs/volumes.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 37972d5..2011cc0 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5297,9 +5297,9 @@ static void btrfs_end_bio(struct bio *bio, int err)
>                 if (!is_orig_bio) {
>                         bio_put(bio);
>                         bio = bbio->orig_bio;
> -               } else {
> -                       atomic_inc(&bio->bi_remaining);
>                 }
> +               atomic_inc(&bio->bi_remaining);
> +
>                 bio->bi_private = bbio->private;
>                 bio->bi_end_io = bbio->end_io;
>                 btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
> 
> --------------------------
> 
> 
> 
> On Mon, Jan 6, 2014 at 2:10 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> > Chris, the patch below seems to be incorrect - with it we get hangs, so
> > bi_remaining (probably) isn't getting decremented when it should be. You sent
> > Jens fixes for btrfs which I somehow lost when I rebased, do you remember how
> > this is supposed to work? Looking at the code I'm not quite sure what's going on
> > here.
> >
> > On Fri, Jan 03, 2014 at 11:51:31AM -0800, Muthu Kumar wrote:
> >> Looks like Kent missed the btrfs endio in the original commit. How
> >> about this patch:
> >>
> >> ---------
> >>
> >> In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
> >> bi_remaining is accounted for correctly.
> >>
> >> Reported-by: fengguang.wu@intel.com
> >> Cc: Kent Overstreet <kmo@daterainc.com>
> >> CC: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> >> --------
> >>
> >>  fs/btrfs/volumes.c |    6 +++++-
> >>  1 files changed, 5 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index f2130de..edfed52 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
> >>                 }
> >>                 kfree(bbio);
> >>
> >> -               bio_endio(bio, err);
> >> +                /*
> >> +                 * Call endio_nodec on the restored bio so the bi_remaining is
> >> +                 * accounted for correctly
> >> +                 */
> >> +               bio_endio_nodec(bio, err);
> >>         } else if (!is_orig_bio) {
> >>                 bio_put(bio);
> >>         }
