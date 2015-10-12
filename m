Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbJLFd3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 01:33:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZlVji-0005kG-BX
	for linux-btrfs@vger.kernel.org; Mon, 12 Oct 2015 07:33:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 07:33:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 07:33:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: filesystem goes ro trying to balance. "cpu stuck"
Date: Mon, 12 Oct 2015 05:33:20 +0000 (UTC)
Message-ID: <pan$121e9$47325977$22468ecf$501b7fa2@cox.net>
References: <CAC=t97BtYg4W_Jxk6HdxbDmbJ1HFM1BbxTDPr+Y1KOd7M8W4gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Sun, 11 Oct 2015 11:46:14 -0500 as excerpted:

> Kernel 4.2.2-1.el7.elrepo btrfs-progs v4.2.1
> 
> I'm attempting to convert a filesystem from raid6 to raid10.  I didn't
> have any functional problems with it, but performance is abysmal
> compared to basically the same arrangement in raid10 so I thought I'd
> just get away from raid56 for a while (I also saw something about parity
> raid code developed beyond 2-disk parity that was ignored/thrown away so
> I'm thinking the devs don't care much about about parity raid at least
> for now).

Note on the parity-raid story:  AFAIK at least the btrfs folks aren't 
ignoring it (I don't know about the mdraid/dmraid folks).  There's simply 
more opportunities for new features than there are coders to code them 
up, and while progress is indeed occurring, some of these features may 
well take years.

Consider, even standard raid56 support was originally planned for IIRC 
3.5, but it wasn't actually added until (IIRC) 3.9, and that was only 
partial/runtime support (the parities were being calculated and written, 
but the tools to rebuild from parity were incomplete/broken/non-existent, 
so it was effectively a slow raid0 in terms of reliability, that would be 
upgraded to raid56 "for free" once the tools were done).  Complete raid56 
support wasn't even nominally there until 3.19, with the initial bugs 
still being worked out thru 4.0 and into 4.1.  So it took about /three/ 
/years/ longer than initially planned.

This sort of longer-to-implement-than-planned pattern has repeated 
multiple times over the life of btrfs, which is why it's taking so long 
to mature and stabilize.

So it's not that multi-parity-raid is being rejected or ignored, it's 
simply that there's way more to do than people to do it, and btrfs as a 
cow-based filesystem isn't exactly the simplest thing to implement 
correctly, so initial plans turned out to be /wildly/ optimistic, and 
honestly, some of these features, while not rejected, could well be a 
decade out.  Obviously others will be implemented before then, but 
there's just so many, and so few devs working on what really is a complex 
project, so something ends up being shoved back to that decade out, and 
that's the way it's going to be unless btrfs suddenly gets way more 
developer resources working on it than it has now.

> Partway through the balance something goes wrong and filesystem is
> forced read-only stopping the balance.
> 
> I did a fschk and it didn't complain about/find any errors.  The drives
> aren't throwing any errors or incrementing any smart attributes.  This
> is a backup array, so it's not the end of the world if I have to just
> blow it away and rebuild as raid10 from scratch.
> 
> The console prints this error.
> NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
> [btrfs-balance:8015]

I'm a user not a dev, tho I am a regular on this list, and backtraces 
don't mean a lot to me, so take this FWIW...

1) How old is the filesystem?  It isn't quite new, created with 
mkfs.btrfs from btrfs-progs v4.2.0 or v4.2.1, is it?  There's a known 
mkfs.btrfs bug along in there, that I don't remember whether it's fixed 
by 4.2.1 or only the latest 4.2.2, but it creates invalid filesystems.  
Btrfs check from 4.2.2 can detect the problem, but can't fix it, and as 
the filesystems as they are are unstable, it's best to get what you need 
off of them and recreate them with a non-buggy mkfs.btrfs ASAP.

2) Since you're on progs v4.2.1 ATM, that may apply to its mkfs.btrfs as 
well.  Please upgrade to 4.2.2 before creating any further btrfs, or 
failing that, downgrade to 4.1.3 or whatever the last in the progs 4.1 
series was.

3) Are you running btrfs quotas on the filesystem?  Unfortunately, btrfs 
quota handling code remains an unstable sore spot, tho they're continuing 
to work hard on fixing it.  I'm continuing to recommend, as I have for 
some time now, that people don't use it unless they're willing to deal 
with the problems and are actively working with the devs to fix them.  
Otherwise, either they need quota support and should really choose a 
filesystem where the feature is mature and stable, or they don't, in 
which case just leaving it off (or turning it off if on) avoids the 
problem.

There's at least two confirmed reasonably recent cases where turning off 
btrfs quota support eliminated the issues people were reporting, so this 
isn't an idle recommendation, it really does help in at least some 
cases.  If you don't really need quotas, leave (or turn) them off.  If 
you do, you really should be using a filesystem where the quota feature 
is mature and stable enough to rely on.  Yes, it does make a difference.

4) Snapshots (scaling).  While snapshots are a reasonably mature feature, 
they do remain a scaling challenge.  My recommendation is that you try to 
keep to about 250-ish snapshots per subvolume, no more than 3000 
snapshots worst-case total, and better no more than 1000 or 2000 (with 
1000, at the 250-per number, obviously letting you do that for four 
subvolumes).  If you're doing scheduled snapshotting, setup a scheduled 
thinning script as well, to keep your snapshots to around 250 or less per 
subvolume.  With reasonably thinning, that's actually a very reasonable 
number, even for those starting at multiple snapshots per hour.

Keeping the number of snapshots below 3000 at worst, and preferably to 
1000 or less, should dramatically speed up maintenance operations such as 
balance.  We sometimes see people with hundreds of thousands of 
snapshots, and then on top of that running quotas, and for them, 
balancing TiB-scale filesystems really can take not hours or days, but 
weeks or months, making it entirely unworkable in practice.  Keeping to a 
couple thousand snapshots, with quotas turned off, should at least keep 
that in the semi-reasonable days range (assuming the absence of bugs like 
the one you unfortunately seem to have, of course).

5) Snapshots (as a feature that can lock in place various not directly 
related bugs).  Despite the fact that snapshots are a reasonably stable 
feature, btrfs itself isn't yet entirely stable, and there remain bugs 
from time to time.  When a bug occurs and some part of the filesystem 
breaks, because of the way snapshots work to lock down older file extents 
that would be deleted or rewritten on a normal filesystem or on btrfs 
without snapshots, people often find that the problem isn't actually in 
the current copy of some file, but in some subset of their snapshots of 
that file.  If they simply delete all the snapshots that reference that 
bad bit of the filesystem, it frees it, and the balance that was hanging 
before, suddenly works.

Again, this isn't a snapshot bug directly, it's simply that on a 
filesystem with a snapshot history going back some time, often whatever 
filesystem bug or physical media defect occurred, happens to affect only 
the older extents that haven't been changed in awhile, and if the file 
has changed over time, often the newer version is no longer using the 
block that's bad, so deleting the snapshots that are still referencing 
it, suddenly eliminates the problem.

There have been several posters who reported various problems with 
balance, that went away when they deleted either their oldest, or all, 
snapshots.  It's by no means everyone, but it's a significant enough 
number that if you do have a bunch of old snapshots and can afford to 
delete them, often because you have the same files actually backed up 
elsewhere, it's worth a shot.

6) That's the obvious stuff.  If it's nothing there, then with luck 
somebody will recognize the trace and match it to a bug, or a dev with 
have the time to look at it.  Give it a couple days if you like to see if 
that happens, and if not, then I'd say, blow it away and start over, 
since it's backups anyway, so you can.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

