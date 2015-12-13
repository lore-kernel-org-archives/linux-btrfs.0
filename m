Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50244 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbbLMHKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 02:10:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a80nr-0001Mu-Nl
	for linux-btrfs@vger.kernel.org; Sun, 13 Dec 2015 08:10:43 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 08:10:43 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 08:10:43 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs: poor performance on deleting many large files
Date: Sun, 13 Dec 2015 07:10:38 +0000 (UTC)
Message-ID: <pan$2ad7b$daf1d36c$45046af8$71124522@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<pan$eea04$e9596e27$78b44461$c5754723@cox.net>
	<1448488198.4717.4.camel@gmail.com>
	<pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
	<1448562347.8809.16.camel@scientia.net>
	<pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
	<1448582805.11377.9.camel@scientia.net>
	<pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
	<1448683025.6837.4.camel@scientia.net>
	<pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
	<1449958538.15961.3.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Sat, 12 Dec 2015 23:15:38 +0100 as
excerpted:

> On Sat, 2015-11-28 at 06:49 +0000, Duncan wrote:
>> Christoph Anton Mitterer posted on Sat, 28 Nov 2015 04:57:05 +0100 as
>> excerpted:
>> > Still, specifically for snapshots that's a bit unhandy, as one
>> > typically doesn't mount each of them... one rather mount e.g. the top
>> > level subvol and has a subdir snapshots there...
>> > So perhaps the idea of having snapshots that are per se noatime is
>> > still not too bad.
>> Read-only snapshots?
> So you basically mean that ro snapshots won't have their atime updated
> even without noatime?
> Well I guess that was anyway the recent behaviour of Linux filesystems,
> and only very old UNIX systems updated the atime even when the fs was
> set ro.

I'd test it to be sure before relying on it (keeping in mind that my own 
use-case doesn't include subvolumes/snapshots so it's quite possible I 
could get fine details of this nature wrong), but that would be my very 
(_very_! see next) strong assumption, yes.

Because read-only snapshots are used for btrfs-send among other things, 
with the idea being that the read-only will keep them from changing in 
the middle of the send, and ro snapshot atime updates would seem to throw 
that entirely out the window.  So I can't imagine ro snapshots doing atime 
updates under any circumstance because I just can't see how send could 
rely on them then, but I'd still test it before counting on it.

>> That'd do it, and of course you can toggle the read-
>> only property (see btrfs property and its btrfs-property manpage).
> Sure, but then it would still be nice for rw snapshots.
> 
> I guess what I probably actually want is the ability to set noatime as a
> property.
> I'll add that in a "feature request" on the project ideas wiki.

AFAIK, the general idea was to eventually have all the (possible, some 
are global-filesystem-scope) subvolume mount options exposed as 
properties, it's just not implemented yet, but I'm not entirely sure if 
that was all /btrfs-specific/ mount options, or included the generic ones 
such as the *atime and no* (noexec/nodev/...) options as well.  In view 
of that and the fact that noatime is generic, adding it as a specific 
request still makes sense.  Someone with more specific knowledge on the 
current plan can remove it if it's already covered.

>> Alternatively, mount the toplevel subvol read-only or noatime on one
>> mountpoint, and bind-mount it read-write or whatever other appropriate
> Well it's of course somehow possible... but that seems a bit ugly to
> me... the best IMHO, would really be if one could set a property on
> snapshots that marks them noatime.

Yes.  Possible is good, but "just works", as one would hope the 
properties solution to eventually be, is still better than "possible by 
jumping thru mount-bind hoops", the current "possibility method". =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

