Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaHUJOk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 05:14:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XKOS4-00025T-4I
	for linux-btrfs@vger.kernel.org; Thu, 21 Aug 2014 11:14:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 11:14:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 11:14:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Significance of high number of mails on this list?
Date: Thu, 21 Aug 2014 09:14:24 +0000 (UTC)
Message-ID: <pan$d267e$1210562f$8bf8dd69$ab91a1c@cox.net>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Shriramana Sharma posted on Thu, 21 Aug 2014 08:52:52 +0530 as excerpted:

> Hello. People on this list have been kind enough to reply to my
> technical questions. However, seeing the high number of mails on this
> list, esp with the title PATCH, I have a question about the development
> itself:
> 
> Is this just an indication of a vibrant user/devel community [*] and
> healthy development of many new nice features to eventually come out in
> stable form later, or are we still at the fixing rough edges stage?
> IOW what is the proportion of commits adding new features to those
> stabilising/fixing features?
> 
> [* Since there is no separate btrfs-users vs brtfs-dev I'm not able to
> gauge this difference either. i.e. if there were a dedicated -dev list I
> might not be alarmed by a high number of mails indicating fast
> development.]
> 
> Mostly I have read like "BTRFS is mostly stable but there might be a few
> corner cases as yet unknown since this is a totally new generation of
> FSs". But still given the volume of mails here I wanted to ask... I'm
> sorry I realize I'm being a bit vague but I'm not sure how to exactly
> express what I'm feeling about BTRFS right now...

Good question, but certainly one where opinions are likely to differ.  Of 
course there a more or less official answer on the wiki 
( btrfs.wiki.kernel.org ), but given the previous research the level of 
the questions you've been asking demonstrate, I expect you've seen that 
and well, it's simply not at the level of detail you find yourself 
needing at this point, so here you are, asking for more detail and, I 
guess, personal opinion.

I'm going to frame my own answer as several general "observations of 
fact" which I don't believe there's likely to be much dispute over, then 
explain them, then follow that with my own opinion.

"Observations of fact" enumerated:

1) Definitions of "stable" differ.
2) Mailing lists distort reality.
3) Previous btrfs warnings have been removed.
4) Two major recent stability-affecting bugs.
5) Some bits of btrfs more stable than others.

"Observations of fact" explained:

1) Definitions of "stable" differ.

There's the "stable" that people like me sometimes simply omit the "b" 
from and call stale, and there's "dogfoodable" stable.

In distro terms, sta(b)le is RHEL 5 or Debian old-stable.  In filesystem 
terms, it's ext3, as ext4 is only now beginning to look stable.

"Dogfoodable" stable refers to the point at which developers and early 
testers find software stable enough to actually use in their ordinary 
daily routine.

I can't see anyone arguing that btrfs meets the sta(b)le standard or that 
it's any closer than a few years out.  OTOH, I guess most regulars here 
have found btrfs "dogfoodable stable" for some time.  But "stable" for 
most people means something in between, and just where btrfs is in that 
in between, is where the debate is.

2) Filesystem mailing lists distort reality.

It's exceeding difficult to draw accurate stability conclusions (well, 
beyond the sta(b)le level) from a filesystem's mailing list.  If the 
filesystem's under active development, there /will/ be numbers of active 
bugs reported, some of which will look pretty bad from the outside or 
simple sysadmin's perspective, and lots of patches floating around in 
various stages of development as well.  An uninitiated outsider's 
reaction will almost certainly be "and THIS is what they call STABLE?"

But that's a fairly obvious first-order conclusion.  The immediate 
natural reaction is to discount it, but it's just as easy to over-
discount and see it as more stable than it is.  Accurately calibrating 
the amount of discount without other information is basically impossible, 
so other information must be used as a primary gauge, with the mailing 
list possibly used as a reality check on /that/.

OTOH, I'd expect a fully mature and stable (post-mature? sta(b)le?) 
filesystem, without much /need/ for new development, only maintenance of 
current state, to have a much quieter list.  Obviously as a filesystem 
falls into obsolescence and disuse, it'll have a quieter list as well.

3) Previous btrfs warnings have been removed.

In the last few kernel cycles the previous more or less official "btrfs 
will eat your babies" level instability warning has been removed, from 
the kernel option description, to the wording used on the wiki, to the 
warning in the manpages and printed by mkfs.btrfs, if there's any warning 
at all left, it's far less strident than it was.

Some here believe the complete removal of such warnings has been 
premature, altho arguably it was time to tone them down.

4) Two severe stability-affecting bugs have recently been traced and have 
patches working thru the pipeline as we speak.

One of these bugs has been there since very near the beginning, but 
happened to only be triggered rarely, the reason it wasn't caught until 
now.  The patch is to be applied to stable going back as far as stable 
series (with btrfs) go and should already be in 3.17-development (which 
I've not switched to yet so I can't say for sure).

The other of these bugs was introduced with the switch from btrfs-kernel 
private worker threads before and in 3.14, to the generic kworker thread 
facility in 3.15, and apparently triggers only for those using btrfs 
compression.  It has thus been there for the full 3.15 and 3.16 kernel 
cycles, with a fix to go into 3.17 (again, I'm not sure if it's there 
yet) and presumably be backported to 3.16. (3.15 isn't a long-term-
support kernel and is thus nearing/at EOL, and isn't likely to get the 
patch.)  This bug hit enough people hard enough that the current 
recommendation is to stick with 3.14 until 3.16-stable and 3.17-
development have the fix.  I've not been as severely affected, perhaps 
due to my general desktop use-case and the fact that I'm on ssd.

Of course such bugs hit much longer term stable kernel subsystems too -- 
there was recently an mdraid bug in this category that hit the news, 
but...

5) Some bits of btrfs are unquestionably more "stable" than others.

The btrfs raid5/6 code, for instance, isn't even complete yet, let alone 
stable.

The longest implemented and most well tested stable code is the basic, 
single device btrfs in default single-mode data, dup-mode metadata, 
configuration, in ordinary filesystem feature replacement mode -- no 
special use of any of the fancy btrfs specific features and no quota 
usage.  This generally works quite well in normal operation.

Multi-device raid0/1/10 modes are now reasonably stable as well and don't 
see a lot of serious normal operational problems reported.  Device add/
delete/replace isn't quite as stable however, and does see bugs reported 
from time to time.

Quota support and more advanced btrfs specific features such as 
snapshotting and send/receive are less stable and have more problems.  
Even the relatively critical kworker threads related bug mentioned above 
apparently only affected those using the btrfs specific transparent 
compression feature, which wouldn't be included in an apples to apples 
comparison with traditional filesystems since they don't normally have 
such a feature.

Of course, without the btrfs specific features there's little or no 
reason to pick btrfs over other filesystems, so the stability of those 
advanced filesystem features matters!

My opinion:

Bottom line, keep your backups tested and ready for use if necessary, 
know the stability level of the filesystem device modes and features you 
use and be prepared accordingly, keep current on your kernels unless you 
have a specific reason not to (like the current kworker related bug 
keeping many to 3.14 until it's fixed), and keep current with btrfs 
current status on the mailing list, and you shouldn't have too much 
problem.

Of course that's a stiff set of requirements for widely deployed "stable" 
use as most people simply aren't used to having to do all that to support 
their "stable" systems, which is why I'm among those who believe 
stripping the previous warnings was somewhat premature, altho toning them 
down a bit was arguably appropriate.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

