From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor read performance on high-end server
Date: Fri, 6 Aug 2010 07:59:39 -0400
Message-ID: <20100806115939.GC29846@think>
References: <4C5AC52D.9030906@sara.nl>
 <20100805145138.GJ29846@think>
 <4C5BF829.3020200@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Freek Dijkstra <Freek.Dijkstra@sara.nl>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5BF829.3020200@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 06, 2010 at 01:55:21PM +0200, Jens Axboe wrote:
> On 2010-08-05 16:51, Chris Mason wrote:
> > And then we need to setup a fio job file that hammers on all the ssds at
> > once.  I'd have it use adio/dio and talk directly to the drives.  I'd do
> > something like this for the fio job file, but Jens Axboe is cc'd and he
> > might make another suggestion on the job file.  I'd do something like
> > this in a file named ssd.fio
> > 
> > [global]
> > size=32g
> > direct=1
> > iodepth=8
> 
> iodepth=8 will have no effect if you don't also set a different IO
> engine, otherwise you would be using read(2) to fetch the data. So add
> ioengine=libaio to take advantage of a higher queue depth as well.

Yeah, I just realized I messed up the suggested file, but it worked well
enough on the block devices, so I think just having 16 procs hitting the
array was enough.  libaio will only help with O_DIRECT though, so this
only applies to 2.6.35 as well.

> 
> Also, I didn't see Chris mention this, but if you have a newer intel box
> you can use hw accellerated crc32c instead. For some reason my test box
> always loads crc32c and not crc32c-intel, so I need to do that manually.
> That helps a lot with higher transfer rates. You can check support for
> hw crc32c by checking for the 'sse4_2' flag in /proc/cpuinfo.

Yeah, the HW assisted crc does make a huge difference.

-chris

