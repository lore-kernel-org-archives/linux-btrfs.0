Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43529 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaAET6D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 14:58:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vztph-0001Gj-ET
	for linux-btrfs@vger.kernel.org; Sun, 05 Jan 2014 20:58:01 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 20:58:01 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jan 2014 20:58:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Sun, 5 Jan 2014 19:57:38 +0000 (UTC)
Message-ID: <pan$95dc3$6f31a244$d85ae144$1545dedf@cox.net>
References: <52C2AE7C.5020601@gmx.at>
	<pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
	<20140103172506.GA10021@merlins.org>
	<pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net>
	<20140105063957.GF11749@merlins.org>
	<8EE40903-FE21-4516-B2D8-4EB8DCE79376@colorremedies.com>
	<52C99C64.2010209@jrs-s.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jim Salter posted on Sun, 05 Jan 2014 12:54:44 -0500 as excerpted:


> On 01/05/2014 12:09 PM, Chris Murphy wrote:
>> I haven't read anything so far indicating defrag applies to the VM
>> container use case, rather nodatacow via xattr +C is the way to go. At
>> least for now.

Well, NOCOW from the get-go would certainly be better, but given that the 
file is already there and heavily fragmented, my idea was to get it 
defragmented and then set the +C, to prevent it reoccurring.

But I do very little snapshotting here, and as a result hadn't considered 
the knockon effect of 100K-plus extents in perhaps 1000 snapshots.  I 
guess that's what's killing the defrag, however it's initiated.  The only 
way to get rid of the problem, then, would be to move the file away and 
then back, but doing so does still leave all those snapshots with the 
crazy fragmentation, and to kill that would require either killing all 
those snapshots, or setting them writable and doing the same move out, 
move back, on each one!  OUCH, but I guess that's why it just seems 
impossible to deal with the fragmentation on these things, whether it's 
autodefrag, or named file defrag, or doing the whole move out and back 
thing, and then having to worry about all those snapshots.

Still, I'd guess ultimately it'll need done, whether it's a wipe the 
filesystem and restore from backup or whatever.

> Can you elaborate on the rationale behind database or VM binaries being
> set nodatacow? I experimented with this*, and found no significant (to
> me,
> anyway) performance enhancement with nodatacow on - maybe 10% at best,
> and if I understand correctly, that implies losing the live per-block
> checksumming of the data that's set nodatacow, meaning you won't get
> automatic correction if you're on a redundant array.
> 
> All I've heard so far is "better performance" without any more detailed
> explanation, and if the only benefit is an added MAYBE 10%ish
> performance... I'd rather take the hit, personally.
> 
> * "experimented with this" == set up a Win2008R2 test VM and ran
> HDTunePro for several runs on binaries stored with and without nodatacow
> set, 5G of random and sequential read and write access per run.

Well, the problem isn't just performance, it's that in most such cases 
the apps actually have their own date integrity checking and management, 
and sometimes the app's integrity management and that of btrfs end up 
fighting each other, destroying the data as a result.

In normal operation, everything's fine.  But should the system crash at 
the wrong moment, btrfs' atomic commit and data integrity mechanisms can 
roll back to a slightly earlier version of the file.

Which is normally fine.  But because hardware is known to often lie about 
having committed writes that may actually still only be in buffer, if the 
power outage/crash occurred at the wrong moment, ordinary write-barrier 
ordering guarantees may be invalid (particularly on large files with 
finite-seek-speed devices), the app's own integrity checksum may have 
been updated before the data it was supposed to be a checksum on actually 
got to disk.  If btrfs ends up rolling back to that condition, btrfs will 
likely consider the file fine, but the app's own integrity management 
will consider it corrupted, which it actually is.

But if btrfs only stays out of the way, the application often can fix 
whatever minor corruption it detects, doing its own roll-backs to an 
earlier checkpoint, because it's /designed/ to be able to handle such 
problems on filesystems that don't have integrity management.

So having btrfs trying to manage integrity too on such data where the app 
already handles it is self-defeating, because neither knows about nor 
considers what the other one is doing, and the two end up undoing each 
other's careful work.

Again, this isn't something you'll see in normal operation, but several 
people have reported exactly that sort of problem with the general large-
internally-written-file, application-self-managed-file-integrity, 
scenario.  In those cases, the best thing btrfs can do is simply get out 
of the way and let the application handle its own integrity management, 
and the way to tell btrfs to do that, as well as to do in-place rewrites 
instead of COW-based rewrites, is with the NOCOW xattrib, chattr +C, and 
that must be done before the file gets so fragmented (and multi-
snapshotted in its fragmented state) in the first place.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

