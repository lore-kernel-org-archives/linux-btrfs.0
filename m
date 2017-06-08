Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbdFHQAf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Jun 2017 12:00:35 -0400
Date: Thu, 8 Jun 2017 12:00:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-btrfs@vger.kernel.org
Subject: Re: dedicated error codes for the block layer V3
Message-ID: <20170608160024.GA5518@redhat.com>
References: <20170603073806.2046-1-hch@lst.de>
 <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 08 2017 at 11:42am -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 06/03/2017 01:37 AM, Christoph Hellwig wrote:
> > This series introduces a new blk_status_t error code type for the block
> > layer so that we can have tigher control and explicit semantics for
> > block layer errors.
> > 
> > All but the last three patches are cleanups that lead to the new type.
> > 
> > The series it mostly limited to the block layer and drivers, and touching
> > file systems a little bit.  The only major exception is btrfs, which
> > does funny things with bios and thus sees a larger amount of propagation
> > of the new blk_status_t.
> > 
> > A git tree is also available at:
> > 
> >     git://git.infradead.org/users/hch/block.git block-errors
> > 
> > gitweb:
> > 
> >     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors
> > 
> > Note the the two biggest patches didn't make it to linux-block and
> > linux-btrfs last time.  If you didn't get them they are available in
> > the git tree above.  Unfortunately there is no easy way to split them
> > up.
> 
> Mike, can you take a look at the dm bits in this series? I'd like to get
> this queued up, but I'd also greatly prefer if the dm patches had sign
> off from your end.

Will do.  I'll have a look by the end of the week.
