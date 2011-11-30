From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: fix submit_worker congestion
Date: Wed, 30 Nov 2011 09:13:45 -0500
Message-ID: <20111130141345.GZ24338@shiny>
References: <1322599256-15621-1-git-send-email-sensille@gmx.net>
 <20111129214707.GT24338@shiny>
 <4ED605A9.9070707@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED605A9.9070707@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 30, 2011 at 11:30:01AM +0100, Arne Jansen wrote:
> On 29.11.2011 22:47, Chris Mason wrote:
> > On Tue, Nov 29, 2011 at 09:40:56PM +0100, Arne Jansen wrote:
> >> Write bios are submitted from the submit_worker. The worker pumps down
> >> bios into the block layer until it signals a congestion. At least this
> >> is the theory. In pratice submit_bio just blocks before any signalling
> >> happens. As the bios are queued per device, this can lead to a situation
> >> where only one device is served until all bios are submitted, and only
> >> then the next device is served. This is obviously suboptimal.
> >> This patch just throws out the congestion detection and reschedules the
> >> worker every 8 requests. This way, all devices can be kept busy.
> >> This is only a temporary fix until the block layer provides a non-blocking
> >> submit_bio. Then the whole submit_worker mechanism can be killed.
> > 
> > The problem with the every 8 requests logic is that we've still got a
> > pretty good chance of getting stuck behind get_request_wait.  The way
> > the elevator batching works is that it should give us a batch of
> > requests, and once that batch is done we wait.
> > 
> > If we jump around every 8 requests, we've turned this:
> > 
> > [ dev A bio 1-8, dev A bio 8-16, dev A bio 16-32, dev B bio 1-8, dev B ... ]
> 
> currently, it's more like
> [ dev A bio 1 - 5000, dev B bio 1-5000 ]
> 
> > 
> > into:
> > 
> > [ dev A bio 1-8, dev B bio 1-8, dev A bio 8-16, dev B bio 8-16 ]
> 
> so this is a great improvement :)

;)

> 
> > 
> > They look like the same IO, but if we wait for a request when we do
> > (dev B bio 1-8) then our dev A bio 1-8 bio is likely to dispatch without
> > all the other dev A bios we had queued.
> > 
> > As you said in IRC, we'd be better off with one thread per device or (my
> > preference) with a real non-blocking submit_bio.  What kind of results
> > did you get with your test from bumping the nr_requests?
> 
> what nr_requests do you mean? btrfs_async_submit_limit?

/sys/block/xxx/queue/nr_requests

-chris

