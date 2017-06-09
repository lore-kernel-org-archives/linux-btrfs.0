Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:37763 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdFIP2x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jun 2017 11:28:53 -0400
Received: by mail-it0-f52.google.com with SMTP id m47so33137507iti.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Jun 2017 08:28:53 -0700 (PDT)
Date: Fri, 9 Jun 2017 09:28:51 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer V3
Message-ID: <20170609152850.GA24734@kernel.dk>
References: <20170603073806.2046-1-hch@lst.de>
 <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
 <20170609151854.GA74154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170609151854.GA74154@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09 2017, Mike Snitzer wrote:
> On Thu, Jun 08 2017 at 11:42am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 06/03/2017 01:37 AM, Christoph Hellwig wrote:
> > > This series introduces a new blk_status_t error code type for the block
> > > layer so that we can have tigher control and explicit semantics for
> > > block layer errors.
> > > 
> > > All but the last three patches are cleanups that lead to the new type.
> > > 
> > > The series it mostly limited to the block layer and drivers, and touching
> > > file systems a little bit.  The only major exception is btrfs, which
> > > does funny things with bios and thus sees a larger amount of propagation
> > > of the new blk_status_t.
> > > 
> > > A git tree is also available at:
> > > 
> > >     git://git.infradead.org/users/hch/block.git block-errors
> > > 
> > > gitweb:
> > > 
> > >     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors
> > > 
> > > Note the the two biggest patches didn't make it to linux-block and
> > > linux-btrfs last time.  If you didn't get them they are available in
> > > the git tree above.  Unfortunately there is no easy way to split them
> > > up.
> > 
> > Mike, can you take a look at the dm bits in this series? I'd like to get
> > this queued up, but I'd also greatly prefer if the dm patches had sign
> > off from your end.
> 
> Hey Jens,
> 
> All looks to be done properly to me.
> 
> Though there are various weird partial indents, e.g.:
> 
> @@ -2820,7 +2821,8 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
>         return r;
>  }
> 
> -static int cache_end_io(struct dm_target *ti, struct bio *bio, int *error)
> +static int cache_end_io(struct dm_target *ti, struct bio *bio,
> +               blk_status_t *error)
>  {
>         struct cache *cache = ti->private;
>         unsigned long flags;
> 
> But I can let these go (will clean them up if/when I make changes to the
> various locations in the future)...

Christoph likes to do it that way, I too prefer proper indents. But
yeah, minor stuff.

> You can add my s-o-b tag to all commits in this series that touch DM:
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Thanks, will do.

> But I'd also like the DM minor version bumped to reflect all the error
> code churn, please include this patch, thanks!

Added this on top. Thanks for the review!

-- 
Jens Axboe

