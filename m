From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Poor read performance on high-end server
Date: Fri, 06 Aug 2010 13:55:21 +0200
Message-ID: <4C5BF829.3020200@kernel.dk>
References: <4C5AC52D.9030906@sara.nl> <20100805145138.GJ29846@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Freek Dijkstra <Freek.Dijkstra@sara.nl>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100805145138.GJ29846@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-08-05 16:51, Chris Mason wrote:
> And then we need to setup a fio job file that hammers on all the ssds at
> once.  I'd have it use adio/dio and talk directly to the drives.  I'd do
> something like this for the fio job file, but Jens Axboe is cc'd and he
> might make another suggestion on the job file.  I'd do something like
> this in a file named ssd.fio
> 
> [global]
> size=32g
> direct=1
> iodepth=8

iodepth=8 will have no effect if you don't also set a different IO
engine, otherwise you would be using read(2) to fetch the data. So add
ioengine=libaio to take advantage of a higher queue depth as well.

Also, I didn't see Chris mention this, but if you have a newer intel box
you can use hw accellerated crc32c instead. For some reason my test box
always loads crc32c and not crc32c-intel, so I need to do that manually.
That helps a lot with higher transfer rates. You can check support for
hw crc32c by checking for the 'sse4_2' flag in /proc/cpuinfo.

-- 
Jens Axboe

