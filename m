From: Gordan Bobic <gordan@bobich.net>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 13:20:23 +0000
Message-ID: <be59d9db8e9c4f9fa0dd856a95ed208b@localhost>
References: <4B97F7CE.4030405@bobich.net>	<4B9829B1.1020706@bobich.net>	<20100311073853.GA26129@attic.humilis.net>	<201003111159.58081.hka@qbs.com.pl>	<20100311123103.34246e95.skraw@ithnet.com>	<ce25fe08b6b07e1993f62f6e34670e52@localhost> <20100311135909.a7acc23e.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100311135909.a7acc23e.skraw@ithnet.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 13:59:09 +0100, Stephan von Krawczynski
<skraw@ithnet.com> wrote:

>> >> > > >On Wed, Mar 10, 2010 at 11:49 AM, Gordan Bobic
>> >> > > ><gordan@bobich.net>
>> >> > > >wrote:
>> >> > > >>Are there options available comparable to ext2/ext3 to help
>> reduce
>> >> > > >>wear and improve performance?
>> >> > 
>> >> > With SSDs you don't have to worry about wear.
>> >> 
>> >> Sorry, but you do have to worry about wear. I was able to destroy a
>> >> relatively
>> >> new SD card (2007 or early 2008) just by writing on the first 10MiB
>> over
>> >> and
>> >> over again for two or three days. The end of the card still works
>> >> without
>> >> problems but about 10 sectors on the beginning give write errors.
>> > 
>> > Sorry, the topic was SSD, not SD.
>> 
>> SD == SSD with an SD interface.
> 
> That really is quite a statement. You really talk of a few-bucks SD card
> (like the one in my android handy) as an SSD comparable with Intel XE
only with
> different interface? Come on, stay serious. The product is not only made
of
> SLCs and some raw logic.

I am saying that there is no reason for the firmware in an SD card to not
be as advanced. If the manufacturer has some advanced logic in their SATA
SSD, I cannot see any valid engineering reason to not apply the same logic
in a SD product.

>> > SSDs have controllers that contain heavy
>> > closed magic to circumvent all kinds of troubles you get when using
>> > classical flash and SD cards.
>> 
>> There is absolutely no basis for thinking that SD cards don't contain
>> wear
>> leveling logic. SD standard, and thus SD cards support a lot of fancy
>> copy
>> protection capabilities, which means there is a lot of firmware
>> involvement
>> on SD cards. It is unlikely that any reputable SD card manufacturer
>> wouldn't also build wear leveling logic into it.
> 
> I really don't guess about what is built into an SD or even CF card. But
we
> hopefully agree that there is a significant difference compared to a
> product that calls itself a _disk_.

Wo don't agree on that. Not at all. I don't see any reason why a CF card
and an IDE SSD made by the same manufacturer should have any difference
between them other than capacity and the physical package.

>> > Honestly I would just drop the idea of an SSD option simply because
the
>> > vendors implement all kinds of neat strategies in their devices. So
in
>> the
>> > end you cannot really tell if the option does something constructive
>> > and not destructive in combination with a SSD controller.
>> 
>> You can make an educated guess. For starters given that visible sector
>> sizes are not equal to FS block sizes, it means that FS block sizes can
>> straddle erase block boundaries without the flash controller, no matter
>> how
>> fancy, being able to determine this. Thus, at the very least, aligning
FS
>> structures so that they do not straddle erase block boundaries is
useful
>> in
>> ALL cases. Thinking otherwise is just sticking your head in the sand
>> because you cannot be bothered to think.
> 
> And your guess is that intel engineers had no glue when designing the XE
> including its controller? You think they did not know what you and me
know
> and
> therefore pray every day that some smart fs designer falls from heaven
and
> saves their product from dying in between? Really?

I am saying that there are problems that CANNOT be solved on the disk
firmware level. Some problems HAVE to be addressed higher up the stack.

>> > Of course you may well discuss about an option for passive flash
>> > devices
>> > like ide-CF/SD or the like. There is no controller involved so your
fs
>> > implementation may well work out.
>> 
>> I suggest you educate yourself on the nature of IDE and CF (which is
just
>> IDE with a different connector). There most certainly are controllers
>> involved. The days when disks (mechanical or solid state) didn't
>> integrate
>> controllers ended with MFM/RLL and ESDI disks some 20+ years ago.
> 
> I suggest you don't talk to someone administering some hundred boxes
based
> on
> CF and SSD mediums for _years_ about pro and con of the respective
> implementation and its long term usage.
> Sorry, the world is not built out of paper, sometimes you meet the hard
> facts.
> And one of it is that the ssd option in fs is very likely already
overrun
> by
> the ssd controller designers and mostly _superfluous_. The market has
> already decided to make SSDs compatible to standard fs layouts.

Seems to me that you haven't done any analysis of comparative long term
failure rates between SSDs used with default layouts (Default? Really? You
mean you don't apply any special partitioning on your hundreds of servers?)
and those with carefully aligned FS-es. Just because defaults may be good
enough for your use case, doesn't mean that somebody with a use case that's
harder on the flash will observe the same reliability, or deem the the
unoptimized performance figures good enough.

Gordan
