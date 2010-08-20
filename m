From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor read performance on high-end server
Date: Fri, 20 Aug 2010 10:37:35 -0400
Message-ID: <20100820143735.GE5854@think>
References: <4C5AC52D.9030906@sara.nl>
 <20100805145138.GJ29846@think>
 <4C5BF829.3020200@kernel.dk>
 <20100806115939.GC29846@think>
 <20100820045344.GB28712@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>,
	Freek Dijkstra <Freek.Dijkstra@sara.nl>,
	linux-btrfs@vger.kernel.org
To: Sander <sander@humilis.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100820045344.GB28712@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 20, 2010 at 06:53:44AM +0200, Sander wrote:
> Chris Mason wrote (ao):
> > On Fri, Aug 06, 2010 at 01:55:21PM +0200, Jens Axboe wrote:
> > > Also, I didn't see Chris mention this, but if you have a newer intel box
> > > you can use hw accellerated crc32c instead. For some reason my test box
> > > always loads crc32c and not crc32c-intel, so I need to do that manually.
> > > That helps a lot with higher transfer rates. You can check support for
> > > hw crc32c by checking for the 'sse4_2' flag in /proc/cpuinfo.
> > 
> > Yeah, the HW assisted crc does make a huge difference.
> 
> The above says "newer intel box". I did some googling and it seems to
> mean really Intel CPUs only, not AMD, correct?
> 
> Is there a way to get hardware support for crc32c on ARM based systems?

So far I only know of the intel sse4.2 systems that support this.

-chris

