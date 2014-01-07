Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:65149 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaAGVXF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 16:23:05 -0500
MIME-Version: 1.0
In-Reply-To: <1389126617.23310.19.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	<CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	<20140106221036.GE9037@kmo>
	<CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	<20140107055318.GA19016@localhost>
	<CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	<1389126617.23310.19.camel@ret.masoncoding.com>
Date: Tue, 7 Jan 2014 13:23:04 -0800
Message-ID: <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,
This is based off of Jens block tree, for-3.14/core branch...

Regards,
Muthu

On Tue, Jan 7, 2014 at 12:29 PM, Chris Mason <clm@fb.com> wrote:
> On Tue, 2014-01-07 at 12:15 -0800, Muthu Kumar wrote:
>> Thanks Fengguang. Final patch with added comment. BTW, fengguang
>> mentioned that git-am has trouble with the inline patch and "quilt
>> import" worked fine for him...
>>
>> ------------
>> In btrfs_end_bio(), we increment bi_remaining if is_orig_bio. If not,
>> we restore the orig_bio but failed to increment bi_remaining for
>> orig_bio, which triggers a BUG_ON later when bio_endio is called. Fix
>> is to increment bi_remaining when we restore the orig bio as well.
>>
>
> Hi everyone,
>
> Which git tree is this against?  Just Jens or some extra code too?
>
> I'll run some tests here.  My original patch is below (it's slightly
> different from Muthu's).
>
> Btrfs is sometimes calling bio_endio twice on the same bio while
> we chain things.  This makes sure we don't trip over new assertions in
> fs/bio.c
>
> Signed-off-by: Chris Mason <clm@fb.com>
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 7fcac70..5b30360 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2289,6 +2289,10 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
>                 block = next_block;
>         } while (NULL != block);
>
> +       /*
> +        * since we're not using bio_endio here, we don't need to worry about
> +        * the remaining count
> +        */
>         bp->bi_end_io(bp, bio_error_status);
>  }
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 62176ad..786ddac 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1684,7 +1684,7 @@ static void end_workqueue_fn(struct btrfs_work *work)
>         bio->bi_private = end_io_wq->private;
>         bio->bi_end_io = end_io_wq->end_io;
>         kfree(end_io_wq);
> -       bio_endio(bio, error);
> +       bio_endio_nodec(bio, error);
>  }
>
>  static int cleaner_kthread(void *arg)
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index ef48947..a31448f 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5284,9 +5284,17 @@ static void btrfs_end_bio(struct bio *bio, int err)
>                 }
>         }
>
> -       if (bio == bbio->orig_bio)
> +       if (bio == bbio->orig_bio) {
>                 is_orig_bio = 1;
>
> +               /*
> +                * eventually we will call the bi_endio for the original bio,
> +                * make sure that we've properly bumped bi_remaining to reflect
> +                * our chain of endios here
> +                */
> +               atomic_inc(&bio->bi_remaining);
> +       }
> +
>         if (atomic_dec_and_test(&bbio->stripes_pending)) {
>                 if (!is_orig_bio) {
>                         bio_put(bio);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
