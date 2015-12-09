Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39274 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbbLIKyI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 05:54:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6cNq-0005iM-G4
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 11:54:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:54:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 11:54:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Wed, 9 Dec 2015 10:53:55 +0000 (UTC)
Message-ID: <pan$a4433$5d5ccde9$c53fc1f2$f519d361@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
	<pan$22dc8$4457dc54$1cd0d037$c9fb9e32@cox.net>
	<1449635797.20578.0.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 09 Dec 2015 05:36:37 +0100 as
excerpted:

> On Fri, 2015-11-27 at 01:02 +0000, Duncan wrote:
> [snip snap]
>> #2 The point I was trying to make, now, to mount it you'll mount not a
>> native nested subvol, and not a directly available sibling
>> 5/subvols/home, but you'll actually be reaching into an entirely
>> different nesting structure to grab something down inside, mounting
>> 5/subvols/root/home subvolume nesting down inside the direct
>> 5/subvols/root sibling subvol.
> 
> Okay so your main point was basically "keeping things administrable"...

=:^)

>> one of which was that everything that the package manager installs
>> should be on the same partition with the installed-package database, so
>> if it has to be restored from backup, at least if it's all old, at
>> least it's all equally old, and the package database actually matches
>> what's on the system because it's in the same backup!

> I basically agree, though I'd allow few exceptions, like database-like
> data that is stored in /var/ sometimes and that doesn't need to be
> consistent with anything but iself... e.g. static web pages
> (/var/www)... postgresl DB, or sks keyserver DB... and so on.

Of course.  But such data isn't usually managed by the package manager, 
so splitting off a partition or subvolume or whatever, is fair game.

IOW, /var can and should still be on /, but /var/www and the like can be 
on some other subvolume or filesystem.

> 
> btw: What's the proper way for merging / splitting into subvols.
> E.g. consider I have:
> 5
> |
> +--root (subvol)
>    |
>    +-- var (no subvol)
> 
> And say I would want to split of var/www into a subvol.

> Well one obvious way would be with mv (and AFAIU that would keep my
> ref-links with clones, if any) but that also means that anything that
> accesses /var/www probably needs a downtime.
> Is it planned to have a special function that basically says:
> "make dir foo and anything below (except nested subvols) a subvol named
> foo, immediately and atomically"?

AFAIK, no.

There's a similar, but not identical, question covered on the wiki, use-
cases page (link very likely wrapped as I'm not bothering to jump thru 
the hoops to unwrap while keeping everything else formatted, ATM).

https://btrfs.wiki.kernel.org/index.php/
UseCases#Can_I_take_a_snapshot_of_a_directory.3F

If you use the recipe (subvol create, cp with reflink) it suggests there, 
you'll end up with the reflinked copy in a subvol.

You can then mount that subvol over top of the existing dir, and *new* 
file opens will access the new subvol, tho existing open files will of 
course continue to access the files/reflinks to which they have a 
reference, "underneath" the new mount.

For some services it's possible to signal them to reload their files.  
Where this is possible, you can do the overmount trick and then signal 
them to reload, and they should keep running, otherwise undisturbed (altho 
any changes between the reflink and processing the signal will still go 
to the existing open files, I don't believe there's a way around that).

But AFAIK that's the closest it gets, and nothing more along that line is 
planned.

In general, keep in mind that subvolumes work in most respects very much 
like normal directories do, except where they don't. =:^)  If it can't be 
done with normal directories and it's not specifically part of subvol/
snapshot functionality, it very likely can't be done with subvols 
either.  From my read, that's the general rule that applies here.

> And similar vice-versa... a special function that says:
> "make subvol foo and anything below (except nested subvols) a dir of the
> parent subvol named foo, immediately and atomically"?
> 
> Could be handy for real world administration, especially when one want's
> to avoid downtimes.
> 
> btw: Few days ago, either Hugo or your thought that mv'ing a subvol
> would change it's UUID, but my try (which was with coreutils 8.3 -> no
> reflinked mv) seemed to show it wouldn't but there was no further reply
> then... so am I right that the UUID wouldn't change?

That was Hugo.  I read your reply then with interest, but my own use-case 
doesn't involve subvols, so I'd be unlikely to know that level of 
specific detail, and even more unlikely to post about it unless I was 
quite sure on it (as I am about the above due to the wiki reference and 
previous list discussion).

>> The same idea applies here.  Once you start reaching into nested
>> subvols to get the deeper nested subvols you're trying to mount, it's
>> too much and you're just begging to get it wrong under the extreme
>> pressures of a disaster recovery.

> Well apparently you oversaw the extremely simple and reliable solution:
> leaving a tiny little note on your desk saying something like: "dear
> boss, things are screwed up, I'm on vacation now..." ;-)

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

