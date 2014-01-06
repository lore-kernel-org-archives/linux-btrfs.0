Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50975 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbaAFWKl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 17:10:41 -0500
Received: by mail-pb0-f48.google.com with SMTP id md12so19063729pbc.35
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jan 2014 14:10:40 -0800 (PST)
Date: Mon, 6 Jan 2014 14:10:36 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Muthu Kumar <muthu.lkml@gmail.com>, Chris Mason <clm@fb.com>
Cc: fengguang.wu@intel.com, Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140106221036.GE9037@kmo>
References: <20140102053101.GA29352@localhost>
 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris, the patch below seems to be incorrect - with it we get hangs, so
bi_remaining (probably) isn't getting decremented when it should be. You sent
Jens fixes for btrfs which I somehow lost when I rebased, do you remember how
this is supposed to work? Looking at the code I'm not quite sure what's going on
here.

On Fri, Jan 03, 2014 at 11:51:31AM -0800, Muthu Kumar wrote:
> Looks like Kent missed the btrfs endio in the original commit. How
> about this patch:
> 
> ---------
> 
> In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
> bi_remaining is accounted for correctly.
> 
> Reported-by: fengguang.wu@intel.com
> Cc: Kent Overstreet <kmo@daterainc.com>
> CC: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> --------
> 
>  fs/btrfs/volumes.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f2130de..edfed52 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
>                 }
>                 kfree(bbio);
> 
> -               bio_endio(bio, err);
> +                /*
> +                 * Call endio_nodec on the restored bio so the bi_remaining is
> +                 * accounted for correctly
> +                 */
> +               bio_endio_nodec(bio, err);
>         } else if (!is_orig_bio) {
>                 bio_put(bio);
>         }
