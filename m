From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Poor read performance on high-end server
Date: Mon, 9 Aug 2010 20:55:39 -0400
Message-ID: <20100810005539.GI10525@think>
References: <4C5AC52D.9030906@sara.nl>
 <20100805145138.GJ29846@think>
 <4C5BF829.3020200@kernel.dk>
 <87r5i98tdf.fsf@basil.nowhere.org>
 <4C5E8F46.5010706@kernel.dk>
 <4C601499.5040402@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, Andi Kleen <andi@firstfloor.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Freek Dijkstra <Freek.Dijkstra@sara.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C601499.5040402@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 09, 2010 at 04:45:45PM +0200, Freek Dijkstra wrote:
> Hi all,
> 
> Thanks a lot for the great feedback from before the weekend. Since one
> of my colleagues needed the machine, I could only do the tests today.
> 
> In short: just installing 2.6.35 did make some difference, but I was
> mostly impressed with the speedup gained by the hardware acceleration of
> the crc32c_intel module.
> 
> Here is some quick data.
> 
> Reference figures:
> 16* single disk (theoretical limit):     4092 MiByte/s
> fio data layer tests (achievable limit): 3250 MiByte/s
> ZFS performance:                         2505 MiByte/s
> 
> BtrFS figures:
> IOzone on 2.6.32:                         919 MiByte/s
> fio btrfs tests on 2.6.35:               1460 MiByte/s

Was this one with O_DIRECT?

> IOzone on 2.6.35 with crc32c:            1250 MiByte/s
> IOzone on 2.6.35 with crc32c_intel:      1629 MiByte/s
> IOzone on 2.6.35, using -o nodatasum:    1955 MiByte/s
> 
> For those finding this message and want a howto: the easiest way to use
> crc32c_intel is to add the module name to /etc/modules:
>  # echo "crc32c_intel" >> /etc/modules
>  # reboot
> 
> Now the next step for us is to tune the block sizes. We only did that
> preliminary, but now that we have a good knowledge of what software to
> use, we can start tuning that in more detail.
> 
> If there is interest on this list, I'll gladly post our results here.

Definitely, please do.

-chris
