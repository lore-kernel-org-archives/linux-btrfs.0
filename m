Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38875 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbcELKTI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 06:19:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b0nhx-00076O-6T
	for linux-btrfs@vger.kernel.org; Thu, 12 May 2016 12:19:05 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 12:19:05 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 12:19:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Amount of scrubbed data goes from 15.90GiB to 26.66GiB after
 defragment -r -v -clzo on a fs always mounted with compress=lzo
Date: Thu, 12 May 2016 10:18:45 +0000 (UTC)
Message-ID: <pan$331b6$43ad41cc$c9aa5858$e14154bc@cox.net>
References: <264486fb-94ce-4040-a436-e9db5de9a203@linuxsystems.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niccolò Belli posted on Wed, 11 May 2016 21:50:43 +0200 as excerpted:

> Hi,
> Before doing the daily backup I did a btrfs check and btrfs scrub as
> usual.

> After that this time I also decided to run btrfs filesystem defragment
> -r -v -clzo on all subvolumes (from a live distro) and just to be sure I
> runned check and scrub once again.
> 
> Before defragment: total bytes scrubbed: 15.90GiB with 0 errors
> After  defragment: total bytes scrubbed: 26.66GiB with 0 errors
> 
> What did happen? This is something like a night and day difference:
> almost double the data! As stated in the subject all the subolumes have
> always been mounted with compress=lzo in /etc/fstab, even when I
> installed the distro a couple of days ago I manually mounted the
> subvolumes with -o compress=lzo. Instead I never used autodefrag.

I'd place money on your use of either snapshots or dedup.  As CAM says 
(perhaps too) briefly, defrag isn't snapshot (technically, reflink) 
aware, and will break reflinks from other snapshots/dedups as it defrags 
whatever file it's currently working on.

If there's few to no reflinks, as there won't be if you're not using 
snapshots, btrfs dedup, etc, no problem, but where there's existing 
reflinks, the mechanism both snapshots and the various btrfs dedup tools 
use, it will rewrite only the copy of the data it's working on, leaving 
the others as they are, thus effectively doubling (for the snapshots and 
first defrag case) the data usage, the old possibly multiply snapshot-
reflinked copy, and the new defragged copy that no longer shares extents 
with the snapshots and other previously reflinked copies.


And unlike a normal defrag, when you use the compress option, it forced 
rewrite of every file in ordered to (possibly re)compress it.  So while a 
normal defrag would have only rewritten some files and would have only 
expanded data usage to the extent it actually did rewrites, the compress 
option forced it to recompress all files it came across, breaking all 
those reflinks and duplicating the data if existing snapshots, etc, still 
referenced the old copies, in the process, thereby effectively doubling 
your data usage.

The fact that it didn't /quite/ double usage may be down to the normal 
compress mount option only doing a quick compression test and not 
compressing it if the file doesn't seem particularly compressible based 
on that quick test, while the defrag with compress likely actually checks 
every (128 KiB compression) block, getting a bit better compression in 
the process.  So the defrag/compress run didn't quite double usage as it 
compressed some stuff that the runtime compression didn't.  (FWIW, you 
can get the more thorough runtime compression behavior with the compress-
force option, which always tries compression, not just doing a quick test 
and skipping compression on the entire file if the bit the test tried 
didn't compress so well.)


FWIW, around 3.9, btrfs defrag was actually snapshot/reflink aware for a 
few releases, but it turned out that dealing with all those reflinks 
simply didn't scale well with the then existing code, and people were 
reporting defrag runs taking days or weeks, to (would-be) months with 
enough snapshots and with quotas (which didn't scale well either) turned 
on.

Obviously that was simply unworkable, so defrag's snapshot awareness was 
reverted until they could make it scale better, as a working but snapshot 
unaware defrag was clearly more practical than one that couldn't be run 
because it'd take months, and that snapshot awareness has yet to be 
reactivated.


So now the bottom line is don't defrag what you don't want un-reflinked.


FWIW, autodefrag has the same problem in theory, but the effect in 
practice is far more limited, in part because it only does its defrag 
thing when some part of the file is being rewritten (and thus COWed 
elsewhere, doing a limited dereflink already for the actually written 
block(s) already, and while autodefrag will magnify that a bit by COWing 
somewhat larger extents, for files of any size (MiB scale and larger) 
it's not going to rewrite and thus duplicate the entire file, as as 
defrag could do.  And it's definitely not going to be rewriting all files 
in large sections of the filesystem as recursive defrag with the 
compression option will.

Additionally, autodefrag will tend to defrag the file shortly after it 
has been changed, likely before any snapshots have been taken if they're 
only taken daily or so, so you'll only have effectively two copies of the 
portion of the file that was changed, the old version as still locked in 
place by previous snapshots and the new version, not the three that 
you're likely to have if you wait until snapshots have been done before 
doing the defrag (the old version as in previous snapshots, the new 
version as initially written and locked in place by post-change pre-
defrag snapshots, and the new version as defragged).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

