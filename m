From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: looking for non existent devices
Date: Wed, 21 Mar 2012 20:52:15 +0200
Message-ID: <20120321185215.GB1973@zambezi.lan>
References: <20120321181202.GA1973@zambezi.lan>
 <C5J2uwYuCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C5J2uwYuCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 21, 2012 at 07:24:00PM +0100, Helmut Hullen wrote:
> Hallo, Ilya,
> 
> Du meintest am 21.03.12:
> 
> >> When I run
> >>
> >>         btrfs filesystem label
> >>
> >> or
> >>
> >>         btrfs scrub status /dev/sdxn
> >>
> >> then I get a lot of error messages with (p.e.)
> >>
> >>   failed to read /dev/hda6: No such device or address
> >>   failed to read /dev/sdm7: No such device or address
> >>   failed to read /dev/sr3: No such device or address
> 
> > I think this has been fixed in recent btrfs-progs, commit 32eff711.
> 
> It is fixed in some (or many) places, it is not fixed everywhere. I had  
> used kernel 3.2.9

32eff711 is supposed to fix it in more places, filesystem label and
scrub status included.  This is purely a userspace issue, commit and
repo I pointed you to are for btrfs-progs, not the kernel.  You are
probably on branch master, it doesn't have that commit yet, only
dangerdonteveruse branch does.

Thanks,

		Ilya
