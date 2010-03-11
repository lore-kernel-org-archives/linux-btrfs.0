From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Thu, 11 Mar 2010 16:35:33 +0100
Message-ID: <20100311163533.0ea09173.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<20100311135909.a7acc23e.skraw@ithnet.com>
	<be59d9db8e9c4f9fa0dd856a95ed208b@localhost>
	<201003111501.55663.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003111501.55663.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 11 Mar 2010 15:01:55 +0100
Hubert Kario <hka@qbs.com.pl> wrote:

> [...]
> The _SD_standard_ states that the media has to implement wear-leveling.
> So any card with an SD logo implements it.
> 
> As I stated previously, the algorithms used in SD cards may not be as advanced 
> as those in top-of-the-line Intel SSDs, but I bet they don't differ by much to 
> the ones used in cheapest SSD drives.

Well, we are all pretty sure about that. And that is exactly the reason why
these are not surviving the market pressure. Why should one care about bad
products that are possibly already extincted because of their bad performance
when the fs is production ready some day?
 
> Besides, why shouldn't we help the drive firmware by 
> - writing the data only in erase-block sizes
> - trying to write blocks that are smaller than the erase-block in a way that 
> won't cross the erase-block boundary

Because if the designing engineer of a good SSD controller wasn't able to cope
with that he will have no chance to design a second one.

> - using TRIM on deallocated parts of the drive

Another story. That is a designed part of a software interface between fs and
drive bios on which both agreed in its usage pattern. Whereas the above points
are pure guess based on dumb and old hardware and its behaviour.
 
> This will not only increase the life of the SSD but also increase its 
> performance.

TRIM: maybe yes. Rest: pure handwaving.

> [...]
> > > And your guess is that intel engineers had no glue when designing the XE
> > > including its controller? You think they did not know what you and me
> > > know and
> > > therefore pray every day that some smart fs designer falls from heaven
> > > and saves their product from dying in between? Really?
> > 
> > I am saying that there are problems that CANNOT be solved on the disk
> > firmware level. Some problems HAVE to be addressed higher up the stack.
> 
> Exactly, you can't assume that the SSDs firmware understands any and all file 
> system layouts, especially if they are on fragmented LVM or other logical 
> volume manager partitions.

Hopefully the firmware understands exactly no fs layout at all. That would be
braindead. Instead it should understand how to arrange incoming and outgoing
data in a way that its own technical requirements are met as perfect as
possible. This is no spinning disk, it is completely irrelevant what the data
layout looks like as long as the controller finds its way through and copes
best with read/write/erase cycles. It may well use additional RAM for caching
and data reordering.
Do you really believe ascending block numbers are placed in ascending
addresses inside the disk (as an example)? Why should they? What does that
mean for fs block ordering? If you don't know anyway what a controller does to
your data ordering, how do you want to help it with its job?
Please accept that we are _not_ talking about trivial flash mem here or
pseudo-SSDs consisting of sd cards. The market has already evolved better
products. The dinosaurs are extincted even if some are still looking alive.

> -- 
> Hubert Kario

-- 
Regards,
Stephan

