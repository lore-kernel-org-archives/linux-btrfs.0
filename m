Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39081 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaDEMQl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Apr 2014 08:16:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WWPWZ-0004HA-6P
	for linux-btrfs@vger.kernel.org; Sat, 05 Apr 2014 14:16:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 14:16:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Apr 2014 14:16:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 5 Apr 2014 12:16:23 +0000 (UTC)
Message-ID: <pan$8df02$88ced518$8a164b97$5b1bfadd@cox.net>
References: <2692878.dRG1K49eOP@fnix> <7675297.F25Z3Ox7Yz@tethys>
	<pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>
	<12471892.pAn1KAtSS4@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Sat, 05 Apr 2014 13:10:13 +0200 as excerpted:

> Le samedi 5 avril 2014 10:12:17 Duncan wrote [excellent performance
> advice about disabling Akonadi in BTRFS etc]:
> 
> Thanks Duncan for all this excellent discussion.
> 
> However I'm still rather puzzled with a filesystem for which advice is
> "if you want tolerable performance, you have to turn off features that
> are the default with any other FS out there (relatime -> noatime) or you
> have to quit using this database, or you have to fiddle around with
> esoteric option such as disabling COW wich BTW is one of BTRFS most
> promiment features".

> I need a filesystem that fits me, I don't want to have to fit my
> filesystem :-\

In fairness, there are two points to consider.

1)  Btrfs is still relatively immature and there are corner-cases and 
kinks and bugs that haven't been worked out yet.

2) If you're going to compare filesystems, be sure you're comparing like 
features.

In the case of noatime in particular, it's recommended for most 
filesystems these days, with the only reason it's not the default being 
backward compatibility with apps like mutt that depend on atime.

But the reason it's more of a problem on btrfs than on other filesystems 
is PRECISELY because of btrfs' snapshotting feature -- a feature that 
most other filesystems simply don't have, AT ALL.  Thus, if you're going 
to compare btrfs against other filesystems in that regard, since most 
other filesystems don't have the snapshotting feature that makes atime a 
bad idea on btrfs, to compare like to like, you must compare btrfs 
without using snapshotting to other filesystems that don't have the 
feature in the first place, and once you do that, btrfs' behavior with 
relatime or even strict atime isn't all that bad.  It's only when you 
bring in snapshots that it's an issue at all, and most filesystems don't 
even have snapshots, so it's not fair to compare the after all relatively 
small efficiency related recommendation to turn off a legacy-support 
feature in ordered to get better efficiency on a brand new feature, with 
filesystems that don't even have that new feature in the first place.

The exception of course is zfs, which does have snapshotting (and which 
isn't an alternative for me so I've not looked into its details enough to 
know the specifics of its snapshot atime handling).  But if you do the 
research, I'm confident you'll find atime updates have a similar 
efficiency cost in relation to snapshotting there, because atime updates 
/are/ a change, and if they're tracked at all, that change must be 
stored /somewhere/.  Now they may not /mention/ the cost, or perhaps 
their snapshot format is inefficient enough the cost of storing atime 
updates is lost in the overall inefficiency of the design, but the cost 
DOES exist, those metadata changes must be stored SOMEWHERE, and either 
their design is efficient enough that it will show up and thus be a 
factor, or it's inefficient and thus it won't be a factor, one or the 
other.

If it's a bother, just ignore what is after all just a small efficiency 
tweaking hint, and pretend it doesn't matter on btrfs either.  Snapshots 
will be a bit bigger and thus you'll either run out of space for 
additional snapshots and have to delete some a bit sooner, or you'll have 
less room to store the actual data, but you can pretend you never read 
about that slight loss of efficiency and go on using relatime or even 
strictatime, and it shouldn't otherwise affect btrfs much more than it 
affects any other filesystem.  Or just don't use snapshots, if you 
prefer, and again, it shouldn't affect btrfs much more differently than 
it affects other filesystems that don't have the snapshotting feature 
available in the first place.

As for COW, the problems there are two-fold.  To some extent, it's 
inherent in the technology.  But there are certainly optimizations that 
can be had, that btrfs isn't doing at this time.  As the filesystem 
matures, these will no doubt be added, and btrfs will handle larger 
internal-write files rather better than it does now.  Still, given the 
technology, I imagine it'll always be possible to get a bit more 
performance by setting nocow on this type of file, because it /is/ a 
problem that's characteristic of COW filesystems and technology in 
general.

Meanwhile, one of the great things about Linux is that it DOES have all 
these filesystem choices available; it's NOT one-size-fits-all (or two-
sizes, fat and ntfs).  The various filesystems each have their individual 
quirks and are better or worse in specific use-cases, and btrfs is and 
will remain no exception.  While btrfs should eventually mature into a 
reasonable general purpose filesystem, suitable to replace the ext* 
series as such, /just/ like the ext* series, there will still be use-
cases where other filesystems are more specifically suited.  For large 
frequent internal-write files, for example, xfs is I believe the 
recommended filesystem today, and it may well remain so as btrfs replaces 
ext3/4, particularly where other btrfs features such as built-in multiple 
device raidN support aren't needed, and where various limitations such as 
first-write-after-snapshot-is-cow even on otherwise nocow files make 
btrfs snapshots not a particularly useful feature for certain types of 
files.

As for disabling akonadi, it's worth noting that when I did that, I was 
still on reiserfs.  Perhaps that's one of the reasons it made such a big 
difference to me, and that may or may not apply to btrfs or ext3/4 
users.  But given that it /did/ make such a difference to me, it's 
certainly worth a try.  I'm certainly biased given my experience with 
akonadi and will admit just that, but /based/ on that experience, if 
akonadi is in fact another common thread to all those installations along 
with btrfs, then based on my own experience, I'd definitely be pointing 
my finger at it, NOT at btrfs, because I've been very happy with btrfs 
performance, while akonadi... let's just say the fact that I compared it 
to malware says it all.

OTOH, for all I know you only had akonadi on one of those installations 
and just happened to mention it.  Perhaps it had nothing to do with the 
slowdowns.

Fine.  I'd say it's still worth testing if disabling it gets you back 
some of that speed.  But it's your systems not mine, and my experience 
may have in fact been a corner-case that has nothing at all to do with 
yours, so believe and do what you will.

Meanwhile, you /were/ asking for advice and I gave you mine.  If you 
don't like it, treat it as worth what you paid for it (zero).  No skin 
off my nose.  But one more zero-cost bit of advice.  If your btrfs 
experience really is that consistently bad, it doesn't really matter what 
I say or someone else says or our experience or advice, why are you still 
bothering with it?  I certainly wouldn't be, because as you said:

> I need a filesystem that fits me, I don't want to have to fit my
> filesystem :-\

If that's not happening with btrfs, honestly, why are you still using 
it?  That's /exactly/ why I'm not using kmail and akonadi today, after 
nearly a decade of being quite happy with it, and despite the trouble of 
converting to something else.  When it didn't fit my needs, I found 
something that did.  Simple as that.  And if btrfs isn't fitting your 
needs, I'd recommend you do likewise, simple as that.

Tho I do believe it can be made a better match, if you wish to spend the 
time to make it so, which after all your post implied you were in fact 
willing and wanting to do.  Your system; your choice. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

