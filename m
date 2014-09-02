Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60961 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaIBO5c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 10:57:32 -0400
Date: Tue, 2 Sep 2014 10:55:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Nikolai Grigoriev <ngrigoriev@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: ext4 vs btrfs performance on SSD array
Message-ID: <20140902145515.GD6232@thunk.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
 <20140902000822.GA20473@dastard>
 <20140902012222.GA21405@infradead.org>
 <20140902113104.GD5049@thunk.org>
 <20140902142024.GB19412@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140902142024.GB19412@quack.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:20:24PM +0200, Jan Kara wrote:
> On Tue 02-09-14 07:31:04, Ted Tso wrote:
> > >  - the very small max readahead size
> > 
> > For things like the readahead size, that's probably something that we
> > should autotune, based the time it takes to read N sectors.  i.e.,
> > start N relatively small, such as 128k, and then bump it up based on
> > how long it takes to do a sequential read of N sectors until it hits a
> > given tunable, which is specified in milliseconds instead of kilobytes.
>   Actually the amount of readahead we do is autotuned (based on hit rate).
> So I would keep the setting in sysfs as the maximum size adaptive readahead
> can ever read and we can bump it up. We can possibly add another feedback
> into the readahead code to tune actualy readahead size depending on device
> speed but we'd have to research exactly what algorithm would work best.

I do think we will need to add a time based cap when bump up the max
adaptive readahead; otherwise what could happen is that if we are
streaming off of a slow block device, the readhaead could easily grow
to the point where it starts affecting the latency of competing read
requests to the slow block device.

I suppose we could make the argument that it's not needed, because most of
situations where we might be using slow block devices, the streaming
reader will likely have exclusive use of the device, since no one
would be crazy enough to say, try to run a live CD-ROM image when USB
sticks are so cheap.  :-)

So maybe in practice it won't matter, but I think some kind of time
based cap would probably be a good idea.

						- Ted
