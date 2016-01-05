Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53696 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbcAEPen (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 10:34:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aGTdB-00042i-Cc
	for linux-btrfs@vger.kernel.org; Tue, 05 Jan 2016 16:34:41 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 16:34:41 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 16:34:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs Check - "type mismatch with chunk"
Date: Tue, 5 Jan 2016 15:34:35 +0000 (UTC)
Message-ID: <pan$2c260$62827c72$5fe5d34$36d9b844@cox.net>
References: <CACRRrm9SwfDzqHNpWjAGniuu6HDu5wo3vW_ETdzijrdYm7YGGw@mail.gmail.com>
	<pan$ed44$b7377cf0$bc775a24$c5211738@cox.net>
	<9871.1451021289@ccs.covici.com>
	<pan$c92dd$6a940cd1$f625da64$e4be62fc@cox.net>
	<1451711566.8761.31.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 02 Jan 2016 06:12:46 +0100 as
excerpted:

> On Fri, 2015-12-25 at 08:06 +0000, Duncan wrote:
>> I wasn't personally sure if 4.1 itself was affected or not, but the
>> wiki says don't use 4.1.1 as it's broken with this bug, with the
>> quick-fix in 4.1.2, so I /think/ 4.1 itself is fine.  A scan with a
>> current btrfs check should tell you for sure.  But if you meant 4.1.1
>> and only typed 4.1, then yes, better redo.

> What exactly was that bug in 4.1.1 mkfs and how would one notice that
> one suffers from it?
> I created a number of personal filesystems that I use "productively" and
> I'm not 100% sure during which version I've created them... :/
> 
> Is there some easy way to find out, like a fs creation time stamp??

I believe a current btrfs check will flag the errors, but can't fix them, 
as the problem was in the filesystem creation and is simply too deep to 
fix, so the bad filesystems must be wiped and recreated with a mkfs.btrfs 
without the bug, to fix.

There's a current or near-current thread (say from Dec 28 or newer) that 
seems to have the specific errors btrfs check reports, based on others' 
replies.  I'm getting behind on this list so won't go attempting to find 
it ATM, and haven't seen the problem myself, so...

>> Unfortunately, the btrfs-
>> convert bug isn't as nailed down, but btrfs-convert has a warning up on
>> the wiki anyway, as currently being buggy and not reliable.

> I hope I don't step on anyone's toes who puts efforts into this, but in
> all doing respect,... I think the whole convert thing is at least in
> parts a waste of manpower - or perhaps better said: it would be nice to
> have, but given the lack of manpower at btrfs development and the
> numerous areas[0] that would need some urgent and probably lots of
> care,... having a convert from other fs to btrfs seems like luxury that
> isn't really needed.

Were btrfs development a zero-sum game, I'd tend to agree with you.  
However, in a free/libre and open source software environment where
many/most contributions are from volunteers, either directly or because 
someone with resources who can't themselves do the coding has taken an 
interest and is effectively volunteering to exchange some of those 
resources for code, things are a bit different.  Code talks, and the 
people volunteering (directly or indirectly) to do that coding scratch, 
or choose not to scratch by spending their time and/or resources 
elsewhere, their own itches in the priority they choose.  That 
environment -- our environment as a FLOSS project -- is no longer zero-
sum as you can't force volunteers to work on something they're not 
interested in -- they walk away and do something else instead.

And obviously, here we have someone with a particular itch to do btrfs-
convert.  To the extent that their code works, as you said, it's it's 
nice to have, particularly if the alternative isn't that some other part 
of btrfs works better, but that they walk away and do their volunteering 
on some other project instead.

Of course right now the code isn't working so well, thus the big warning 
on the wiki and the various recommendations here not to use it.  But to 
the extent that someone takes an interest and fixes it to work again and 
their code is to project standard, particularly if their work doesn't 
come at the expense of other btrfs code, as it may well not if it's 
something a dev takes as a personal challenge and thus puts more hours 
into it than he would into anything else btrfs related, who are we to say 
no, we aren't going to take that unarguably useful code?


It's the same reason that I as a kde user who finds the gnome "dumb-down" 
approach horribly frustrating, remain extremely glad there's a gnome 
project for those who approve of that sort of approach to work on -- by 
definition, they'd find working on kde, with its plethora of options 
approach, extremely frustrating, and would either walk away, or worse yet 
for those who prefer kde's approach, muck things up with fights that 
either take away options or at minimum cause less actual kde work to get 
done.  People who complain about gnome and kde and xfce and ... all 
taking away effort from each other simply don't understand how freedomware 
works, and that it's not a question of wasting effort that could be 
better put to use elsewhere, but of either not having that effort spent 
at all or worse yet, of starting fights so less gets done and more people 
simply quit in frustration.


So it's not a zero-sum game at all, and if the choice is in having 
someone that's interested in btrfs-convert spend time on it, or having 
them not working on btrfs at all, as is very possibly the case, I, and I 
guess most on the project, would prefer they spend the time on
btrfs-convert, even if it's not the absolutely most critical tool in the 
btrfs-tools package. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

