From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 13:59:09 +0100
Message-ID: <20100311135909.a7acc23e.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<4B9829B1.1020706@bobich.net>
	<20100311073853.GA26129@attic.humilis.net>
	<201003111159.58081.hka@qbs.com.pl>
	<20100311123103.34246e95.skraw@ithnet.com>
	<ce25fe08b6b07e1993f62f6e34670e52@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: <linux-btrfs@vger.kernel.org>
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ce25fe08b6b07e1993f62f6e34670e52@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 12:17:30 +0000
Gordan Bobic <gordan@bobich.net> wrote:

> On Thu, 11 Mar 2010 12:31:03 +0100, Stephan von Krawczynski
> <skraw@ithnet.com> wrote:
> >> > > >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic <gordan@bobich.net>
> >> > > >wrote:
> >> > > >>Are there options available comparable to ext2/ext3 to help
> reduce
> >> > > >>wear and improve performance?
> >> > 
> >> > With SSDs you don't have to worry about wear.
> >> 
> >> Sorry, but you do have to worry about wear. I was able to destroy a
> >> relatively
> >> new SD card (2007 or early 2008) just by writing on the first 10MiB
> over
> >> and
> >> over again for two or three days. The end of the card still works
> >> without
> >> problems but about 10 sectors on the beginning give write errors.
> > 
> > Sorry, the topic was SSD, not SD.
> 
> SD == SSD with an SD interface.

That really is quite a statement. You really talk of a few-bucks SD card (like
the one in my android handy) as an SSD comparable with Intel XE only with
different interface? Come on, stay serious. The product is not only made of
SLCs and some raw logic.
 
> > SSDs have controllers that contain heavy
> > closed magic to circumvent all kinds of troubles you get when using
> > classical flash and SD cards.
> 
> There is absolutely no basis for thinking that SD cards don't contain wear
> leveling logic. SD standard, and thus SD cards support a lot of fancy copy
> protection capabilities, which means there is a lot of firmware involvement
> on SD cards. It is unlikely that any reputable SD card manufacturer
> wouldn't also build wear leveling logic into it.

I really don't guess about what is built into an SD or even CF card. But we
hopefully agree that there is a significant difference compared to a product
that calls itself a _disk_.
 
> > Honestly I would just drop the idea of an SSD option simply because the
> > vendors implement all kinds of neat strategies in their devices. So in
> the
> > end you cannot really tell if the option does something constructive and
> not
> > destructive in combination with a SSD controller.
> 
> You can make an educated guess. For starters given that visible sector
> sizes are not equal to FS block sizes, it means that FS block sizes can
> straddle erase block boundaries without the flash controller, no matter how
> fancy, being able to determine this. Thus, at the very least, aligning FS
> structures so that they do not straddle erase block boundaries is useful in
> ALL cases. Thinking otherwise is just sticking your head in the sand
> because you cannot be bothered to think.

And your guess is that intel engineers had no glue when designing the XE
including its controller? You think they did not know what you and me know and
therefore pray every day that some smart fs designer falls from heaven and
saves their product from dying in between? Really?
 
> > Of course you may well discuss about an option for passive flash devices
> > like ide-CF/SD or the like. There is no controller involved so your fs
> > implementation may well work out.
> 
> I suggest you educate yourself on the nature of IDE and CF (which is just
> IDE with a different connector). There most certainly are controllers
> involved. The days when disks (mechanical or solid state) didn't integrate
> controllers ended with MFM/RLL and ESDI disks some 20+ years ago.

I suggest you don't talk to someone administering some hundred boxes based on
CF and SSD mediums for _years_ about pro and con of the respective
implementation and its long term usage.
Sorry, the world is not built out of paper, sometimes you meet the hard facts.
And one of it is that the ssd option in fs is very likely already overrun by
the ssd controller designers and mostly _superfluous_. The market has already
decided to make SSDs compatible to standard fs layouts.

-- 
Regards,
Stephan

