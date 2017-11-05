Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42025 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdKEGwS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 01:52:18 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eBEmv-00035M-0i
        for linux-btrfs@vger.kernel.org; Sun, 05 Nov 2017 07:52:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Parity-based redundancy (RAID5/6/triple parity and beyond) on
 BTRFS and MDADM (Dec 2014) =?CP1251?B?lg==?= Ronny Egners Blog
Date: Sun, 5 Nov 2017 06:52:02 +0000 (UTC)
Message-ID: <pan$6d65a$2ecbe9db$2b478297$e529e2dc@cox.net>
References: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
        <7178555e-5f84-4e8a-243e-f1108d06136e@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead posted on Thu, 02 Nov 2017 23:06:41 +0100 as excerpted:

> Dave wrote:
>>
>> TL;DR: There are patches to extend the linux kernel to support up to 6
>> parity disks but BTRFS does not want them because it does not fit their
>> “business case” and MDADM would want them but somebody needs to develop
>> patches for the MDADM component. The kernel raid implementation is
>> ready and usable. If someone volunteers to do this kind of work I would
>> support with equipment and myself as a test resource.
>> --
> I am just a list "stalker" and no BTRFS developer, but as others have
> indirectly said already. It is not so much that BTRFS don't want the
> patches as it is that BTRFS do not want to / can't focus on this right
> now due to other priorities.

Indeed.

There's a meme that USAF pilots call situations in which they're 
seriously outnumbered by the enemy "target rich environments."

Using that analogy here, btrfs is an "development opportunity rich 
environment".

IOW, the basic btrfs design is quite flexible and there's all sorts of 
ideas as to what sort of features it'd be nice to have at some point, but 
there's way more good feature ideas than there are qualified devs to work 
on them, and getting upto speed on btrfs takes long enough even for 
experienced kernel/fs devs that it's not the sort of thing where just any 
dev can simply pick up a project from the list and have it ready for 
mainlining in six months...

Meanwhile, btrfs history is a wash/rinse/repeat list of features that 
took rather longer, sometimes /years/ and multiple rewrites longer, to 
implement, debug and reasonably stabilize.  Quotas/qgroups and the 
existing raid56 parity-raid are both prime examples, as the devs have 
been working on both features for years and while they both appear to be 
/somewhat/ stabilized in terms of egregious bugs, there remain big 
caveats on both, primarily performance on quotas, and the parity-write-
hole undermining the normal checksummed data and metadata integrity and 
thus the greater reliability people would otherwise choose it for, on 
raid56.

Given that status and history, realistic estimates on when particular 
features may be available as reasonably stable really extend to years for 
features under current development, perhaps the 3-5 year timeframe for 
those queued up for development "soon", and very likely the 10 years out 
timeframe for anything beyond that.

But the thing is, anything beyond five years out in Linux development by 
definition is in practice beyond the reasonably predictable -- just look 
back at where Linux was 5 or 10 years ago and the unexpected twists and 
turns it has taken since then that have played havoc with predictions 
from that period, and project that forward 5 to 10 years, and I imagine 
you'll agree.  (Tho the history of btrfs itself is in that time frame, 
but I'm not saying long term projects can't be started with a hope that 
they'll be reasonably successful 5-10 years out, just that the picture 
you're trying to project out that far is likely to look wildly different 
than the picture when you actually get there.  Certainly I don't think 
many expected btrfs to take this long, tho others cautioned the 
projections were wildly optimistic and 7-10 years to approach stability 
wasn't unreasonable.)

The point being, if it's not on the "current" or "queued-to-next" lists, 
in practice it's almost certainly 5+ years out, and that's beyond 
reasonable predictability range, so it's "bluesky", aka "it'd be nice to 
have... someday", range.

And honestly there's quite a lot of ideas in that "bluesky" range, and 
just because triple-parity-plus is one of them doesn't mean the devs have 
rejected it, just that there's this thing called reality that they're up 
against.

I know, because my personal wish-list item, N-way-mirroring, has been on 
the "right after raid56 mode, since it'll be re-using some of that code" 
queue since before the kernel 3.6 era, with raid56 expected to be 
introduced for 3.6 when I first looked at btrfs seriously, and N-way-
mirroring assumed to be introduced perhaps 2-3 kernel cycles later.

Of course I was soon disabused of that notion, but even so, N-way-
mirroring has been "3-5 years out" for more than 3-5 years now, and it's 
on the "soon" list, so anything /not/ on that "soon" list... well, better 
point your time machine at least 10 years out...

But the one thing that can change that is if there's at least one 
*really* interested kernel dev (or sponsor willing to pay sufficiently to 
create one, or more if necessary) willing to learn btrfs internals and 
take on a particular feature as their major personal task for the multi-
year time-period scope necessary, even if it means coping with the 
project possibly getting back-burnered for a year or more in the 
process.  I believe I've seen one such "from left field" feature merged 
in the years since I started following the list with 3.5-ish (tho 
unfortunately IDR what it was ATM), and a couple others that haven't yet 
been merged, but they have proof-of-concept code and have been approved 
for soon/next, tho they're backburnered for the moment due to 
dependencies and merge-queue scheduling issues.  The hot-spare patch set 
is in that last category, tho a few patches that had been in that set 
were recently dusted off, cleaned up and merged as they turned out to be 
useful in their own right.  That of course is a good thing, since it 
makes the remaining patch set smaller and simpler, and less likely to 
conflict with other current or queued/soon projects, as it moves forward 
in that queue.

> There was some updates to raid5/6 in kernel 4.12 that should fix (or at
> least improve) scrub/auto-repair. The write hole does still exist.
> 
> That being said there might be configurations where btrfs raid5/6 might
> be of some use. I think I read somewhere that you can set data to
> raid5/6 and METADATA to raid1 or 10 and you would risk loosing some data
> (but not the filesystem) in the event of a system crash / power failure.
> 
> This sounds tempting since it in theory would not make btrfs raid 5/6
> significantly less reliable than other RAID's which will corrupt your
> data if the disk happens to spits out bad bits without complaining (one
> possible exception that might catch this is md raid6 which I use). That
> being said there is no way I would personally use btrfs raid 5/6 even
> with metadata raid1/10 yet without proper tested backups at standby at
> this point.

Indeed.  Unfortunately, the infamous parity-write-hole is rather the 
antithesis of btrfs checksummed integrity feature, and until it's fixed, 
the reasons one would choose btrfs in general rather conflict with using 
raid56 mode in particular.  There's no immediate or easy fix.  There /is/ 
a possible mid-term fix, journaling writes, but that's likely to 
absolutely kill write speed, making it impractical for most usage, thus 
making the use-case small enough it's arguably not worth the trouble.  
But the real fix is unfortunately a near full rewrite of the current 
raid56 mode, using what we've learned from the current implementation to 
hopefully create a better one not affected by the write hole (yes, 
there's ways around it), which likely puts 3-5 years out, at least.  I'd 
put it on the 10 year list but it does seem there's quite an interest by 
current devs, thus upgrading it to the queued list.

Unfortunately, if that's the case, then it may well delay other projects, 
including the N-way-mirroring I have a personal interest in and that as I 
said has been on that 3-5 year list for longer than that now, even 
further.

So I'm 50 now; /maybe/ I'll be able to use btrfs N-way-mirroring from the 
nursing home, when I'm 70 or 80... if technology hasn't made btrfs as we 
know it obsolete by then...

> Anyway - I would worry more about getting raid5/6 to work properly
> before even thinking about multi-parity at all :)

For sure.  Even the "soon" N-way-mirroring, which was waiting for raid56 
mode, continues to wait...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

