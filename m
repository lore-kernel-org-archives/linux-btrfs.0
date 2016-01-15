Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbcAOLs1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 06:48:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aK2rf-000298-41
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 12:48:23 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 12:48:23 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 12:48:23 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Recursive delete file from all subvolumes (snapshots)
Date: Fri, 15 Jan 2016 11:48:11 +0000 (UTC)
Message-ID: <pan$cd84a$7dd8a74d$a2b00ed6$e26c6f75@cox.net>
References: <15624885.ucZm0n36hp@discus> <20160115140539.3afa66f0@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Fri, 15 Jan 2016 14:05:39 +0500 as excerpted:

> On Fri, 15 Jan 2016 09:33:14 +0100 Wolfgang Mader
> <Wolfgang_Mader@brain-frog.de> wrote:
> 
>> I have a btrfs raid 10 from which I take hourly snapshots using
>> snapper.

Hopefully you have snapper setup with a good thinning program as well, as 
ideally, you want to keep your snapshots to 250-ish per subvolume and a 
thousand or two per filesystem, maximum, for scaling reasons, and hourly 
snapshots will eat up that 250 target in 10 days, 10 hours...

But it's quite possible to start with hourly snapshots, thinning to say 6-
hourly (four per day, deleting 5/6) after a couple days, and continuing 
to thin down to say weekly after several weeks, then keeping weekly 
snapshots for a year before deleting them to recover the space and 
resorting to proper backups if anything older needs recovered, and stay 
under 200 snapshots per subvolume.

That'll help keep your btrfs healthy and your btrfs maintenance commands 
(scrub, balance, check, etc), if needed, running in something like 
reasonable time. =:^)

>> Now, I wonder, if there is a way to delete a file together
>> with all its occurrences in all snapshots.

If the file was there at the time of the snapshot, it's part of the 
snapshot and to remove it when deleting a file from the working set 
rather defeats the purpose, tho of course with writable snapshots, you 
can delete it from the snapshot manually (see RM's method below), and as 
RM says, with read-only snapshots it's more complex but still possible 
(see my reply under that bit, further below).

>> My use case is, that the file I want to delete is large, and I want to
>> free its space on disk. Thus, I have to get rid of its "live" version
>> but also of all references to it in snapshots.
> 
> E.g. if your file is at /path/to/file.dat, and your snapshot structure
> is /snapshots/YYYY-MM-DD@time/, you would simply do:
> 
> rm /snapshots/*/path/to/file.dat
> 
> In fact this is what I often do with my timed snapshots when deleting
> some files and wanting to recover free space immediately, not waiting
> for all their snapshots to expire and get deleted by the usual
> time-based deletion rules.

Of course that implies that the root containing all the snapshots is 
itself mounted or otherwise nested in the mounted tree, somewhere.  The 
recommendation is to keep it unmounted and not directly accessible, by 
default, only mounting the snapshots root when you are directly working 
with the snapshots.

Among other reasons, there's a security issue if you're snapshots contain 
old executables including set-UID/GID executables, and they're security 
updated.  If the old vulnerable versions remain accessible to ordinary 
users, as they will if the snapshots remain routinely accessible within 
the tree, then it's possible for a user to use them to gain the privs of 
the user/group (typically root) they run as.  If these snapshots aren't 
normally accessible in the tree, then users won't have access to them and 
won't be able to use the old and vulnerable versions the snapshots 
contain to privilege-escalate.

Plus of course, if they're unmounted, they're less likely to be 
accidentally damaged or deleted.

> If your snapshots are read-only it becomes more complex, but still
> doable.

Read-only is a snapshot property.  As such, it can be toggled via btrfs 
property set calls.  So the idea here would be a script that loops thru 
the snapshots, doing a btrfs property set writable, rm file, btrfs set 
property read-only, for each snapshot.  Trivial enough shell script.  So 
a bit more complex than if the snapshots are writable in the first place, 
but far from unmanageably so. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

