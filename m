Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58070 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbbAIX6K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 18:58:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9jRQ-0007iS-HT
	for linux-btrfs@vger.kernel.org; Sat, 10 Jan 2015 00:58:08 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 00:58:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 00:58:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs scrub and kernel parent transid
Date: Fri, 9 Jan 2015 23:57:58 +0000 (UTC)
Message-ID: <pan$2fc5a$d7961867$68930ae0$a3bcf496@cox.net>
References: <1420816425.4982.7.camel@AMD>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lars Callenbach posted on Fri, 09 Jan 2015 16:13:45 +0100 as excerpted:

> in kernel logs I get an error message of the type 'parent transid verify
> failed' but 'btrfs scrub ...' does not show any errors/inconsistencies.
> Do I have to worry about these kernel error messages?

I believe you're failing to understand either the nature of these 
messages, or what scrub actually does (if not both), as scrub wouldn't 
be /expected/ to detect/fix this sort of problem.

> ~ # uname -a
> [...] Linux 3.17.8-MYVERSION [...]
> ~ #   btrfs --version
> Btrfs v3.18+20141230

Thanks. =:^)

> ~ # dmesg 
> ...
> [    3.405363] parent transid verify failed on 1514311680
> wanted 21004 found 35043
> [    3.406370] parent transid verify failed on 17290989568
> wanted 21054 found 32893

In btrfs-speak, transid and generation (number) refer to the same thing, 
a monotonically increasing commit number.  In btrfs, various individual 
file changes can occur, with the changes cascading up the tree until an 
atomic root commit, which in theory represents a known valid state of the 
filesystem at that point.  Thus, in theory at least, the filesystem 
progresses from one known valid root commit to the next, and an invalid 
in-between state should not occur, it should always fall back to the last 
root tree commit, which should always be valid.

Of course that's the theory, not the reality we live in complete with 
bugs and hardware that doesn't exactly behave as it is documented to 
behave.  And btrfs not being a fully mature filesystem, to be sure 
there's certainly bugs!

Anyway, generation, aka transaction ID, aka transid, is simply an 
increasing number reflecting the number of root-tree commits to date.  A 
lower transid therefore reflects an earlier state of the tree, and 
"parent" refers to the next level of the commit tree, closer to root.

Here we're seeing HIGHER transids than expected.  The expected 
transaction ID is (for the first one above) 21004, but a much higher 
transid, 35043, was found.

I'm not a dev and thus don't grok the full implications here, but I do 
know that at one point fairly recently there was a bug that would reset 
transid for some nodes to zero in some circumstances.  It's possible that 
happened in your case, and that the differing transids reflect resets to 
zero of differing parts of the tree.


Whatever the cause, however, it's not a problem that scrub would be 
expected to handle.

What scrub does is simply this.  Btrfs data and metadata nodes are 
checksummed so that corruption can be detected and if there's a valid 
copy of the data/metadata elsewhere (as there normally is in raid1 or dup 
modes, for instance, but not in single or raid0 modes), it can be 
rewritten over the bad copy.

While this occurs in normal usage as btrfs reads requested nodes, what 
scrub does is systematically read /everything/ validating its checksum 
and reporting and/or correcting errors where it has a valid copy 
elsewhere and can do so.


Now what we're seeing above is actually valid data/metadata in terms of 
what scrub sees -- the calculated checksum matches that recorded, so 
there's nothing for scrub to report or fix.  It's simply not the 
/expected/ metadata -- the generation-number/transid is wrong.  Scrub 
doesn't detect or fix /that/ sort of problem, as it's designed to detect 
and fix an entirely /different/ sort of problem.

Now what /should/ detect and hopefully be able to fix the problem, is 
btrfs check.  Run it in read-only mode (without --repair or other 
"fixing" options) first, and see what it reports.

However, at least in the past, btrfs check in --repair mode could 
actually make certain problems it didn't properly understand worse.  I'm 
not sure if that remains the case or not, but the recommendation has 
always been NOT to run it in --repair mode until you're sure it can 
actually repair the problems you're seeing, without creating new problems.

What that means in practice is this:  Either make a full backup (and as 
every good sysadmin knows, a backup isn't a backup until you've tested 
that you can properly recover from it) before attempting btrfs check
--repair, or post the results of the read-only run, and let a dev tell 
you whether it's safe to run in --repair mode or not, based on the 
results of the read-only run and the problems you're experiencing that 
you're trying to fix.


Meanwhile, here's an example of something that scrub /can/ fix.

Most of my btrfs are pair-device raid1 mode for both data and metadata, 
so there's two copies of everything, one copy each on two different 
devices.  My root filesystem is normally mounted read-only unless I'm 
actively updating it, but my (separate btrfs) /home and /var/log 
filesystems are of course mounted read-write by default, and in the event 
of a loss of system power or a crash, particularly /var/log is often in 
the middle of writing something.

But for raid1 mode, btrfs writes first to one device, and then when it's 
done, to the other.  So when the power goes out or the system crashes, 
one or the other copy should either be fully written, or not yet 
started.  When I reboot after such an unclean shutdown, I normally do a 
scrub, and it will frequently find and fix errors on the device that was 
being written to at the time, as those blocks will fail checksum 
verification and their (meta)data will be rewritten using the valid copy 
from the other device.

This actually works rather nicely and has saved my filesystems from worse 
problems a number of times. =:^)

Of course the fact that I keep my root filesystem read-only unless I'm 
actually updating it, so unlike /home and /var/log, it doesn't tend to be 
subject to such crash-related problems in the first place, does help me 
sleep better, since I know that if I /do/ end up trying to recover a bad 
filesystem, the root filesystem itself, where all the tools and 
documentation I'll be using to fix the problem are located, is normally 
unaffected, as it wasn't mounted writable when the problem occurred. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

