From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: scrub: Inappropriate ioctl for device
Date: Tue, 1 Nov 2011 22:08:32 +0200
Message-ID: <20111101200832.GA552@zambezi.lan>
References: <Bx1FpyLi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bx1FpyLi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 08:36:00PM +0100, Helmut Hullen wrote:
> Hallo,
> 
> I'm just playing with "btrfs scrub".
> 
> Kernel 3.1 (self made)
> btrfs integration-20111030 (Hugo Mills)
> 
> I have a bundle of 3 2-TByte-disks (data raid0, metadata raid1).
> 
> Since some (few) weeks one of the disks makes errors (I've reported the  
> problems in this mailing list).
> 
> The bundle uses the devices /dev/sdb1, /dev/sdc1 and /dev/sdg1, "btrfs  
> filesystem show" shows these informations.
> 
> Mounting doesn't work immediately; most times I have to run the "mount"  
> command three times - strange.

To be able to run mount only once you have to run 'btrfs dev scan' on
startup (after each reboot or just before mounting).  If that's not an
option you can use -o devices mount option.

> 
> When I run
> 
>        btrfs scrub start -r /dev/sdb1
> 
> (or another of the three disks) then I only get the error message
> 
>   ERROR: getting dev info for scrub failed: Inappropriate ioctl for
>     device

Scrubber runs on a mounted filesystem.

Thanks,

		Ilya
