Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60857 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaCIMLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 08:11:06 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Massive BTRFS performance degradation
Date: Sun, 09 Mar 2014 13:10:05 +0100
Message-ID: <9889995.2gi4G0FAds@tethys>
In-Reply-To: <20140309113350.GH6318@carfax.org.uk>
References: <531C1CC4.701@gmail.com> <1756989.4ep0Vdupld@tethys> <20140309113350.GH6318@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 9 mars 2014 11:33:50 Hugo Mills a écrit :
> 
>    ssd should be activated automatically on any non-rotational device.
> ssd_spread is generally slower on modern SSDs than the ssd option.
> discard is, except on the very latest hardware, a synchronous command
> (it's a limitation of the SATA standard), and therefore results in
> very very poor performance.

Thanks for the info Hugo :-)

>    There's one known and serious bug in 3.11 before 3.11.6 which
> affects balances. Please make sure that you're running 3.11.6 or
> later. There may be other bugs in there that have been fixed in later
> kernel versions as well, but that's the "headline" one.

Latest Ubuntu / Mint now have 3.11.0-18. Anyway I don't think my "old lady 
neighbour" will ever hear about balance or care, and will ever try to run it 
on her laptop. She would first have to figure out what a terminal and command 
line are ;-)

>    We don't get many bug reports of kernel oopses in send. This may be
> that we don't have many people trying to use it (it is, after all,
> fairly deep and poorly explained magic at the moment). It may be that
> you have some corruption that's gone undetected otherwise, 

Well, that's a rather "young" BTRFS setup (less than a month) that passes 
scrub without detecting any error, and a plain "btrfs send" works, then an 
incremental one fails...

> send code isn't handling it well. Or it may be an actual bug in send.

I would tend to believe so ;-)

> At least you've reported it. (It might also be worth putting a copy of
> the report on bugzilla.kernel.org, because then it doesn't get
> forgotten in the email noise here).

> > - btrfs-defrag.sgh hangs because of some glitch with "filefrag".
> 
>    Is that a btrfs problem, or a filefrag problem?

Looks like it's a filefrag problem. Looks like filefrag stalls forever trying to 
figure out the fragmentation status of some files...

> btrfs-defrag.sh isn't something I've heard of before, so I'd say it's
> unlikely to be maintained by any of the main btrfs developers (and hence is
> much more likely to be unmaintained or just plain broken in general).

It's a useful script that can be found there
https://gitorious.org/btrfs-defrag
...and it's maintained by Dmitry, who's a nice, responsive and helpful guy.

> > - bedup crashes badly and looks completely unmaintained as far as I can
> > tell and nobody seems to care.
> 
>    That's because nobody here is connected to bedup in any way. It was
> a third-party piece of software written by someone (I don't even
> recall who) who hasn't, as far as I know, engaged with the main btrfs
> developers at all.

bedup is mentioned on the BRTFS wiki 
https://btrfs.wiki.kernel.org/index.php/Deduplication
...as being the only current way to perform BTRFS deduplication. I found it in 
the wiki and belived/hoped it was something more "official and maintained" that 
what you seem to mean - alas...

Actually deduplication WAS the reason why I recently made the move to BTRFS 
again, for deduplication in ZFS is working, but *SO* memory hungry and 
performance killer unless you have *lots* of RAM...

So I wanted to give a try at BTRFS offline bedup.

> > Soooo weeelllll... Looks like readiness for prime time is still
> > ahead of us...
> 
>    I think that's fair to say. However, it is noticeably improving
> over time. The timescales are just quite long.

If the timescales become really too long, people with just end keeping with 
the idea that BTRFS is not ready for production and won't be any previsible 
time soon...

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

