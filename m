Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50211 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbdDYEFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 00:05:54 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1d2rjW-00013x-J0
        for linux-btrfs@vger.kernel.org; Tue, 25 Apr 2017 06:05:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problem with file system
Date: Tue, 25 Apr 2017 04:05:39 +0000 (UTC)
Message-ID: <pan$abe0f$67f7c415$77be962b$81e0757d@cox.net>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
        <CAJCQCtQ2d1c6OOGnJkKQ269kR526Y=krOcnJgy9cJHGQiw4aQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 24 Apr 2017 11:02:02 -0600 as excerpted:

> On Mon, Apr 24, 2017 at 9:27 AM, Fred Van Andel <vanandel@gmail.com>
> wrote:
>> I have a btrfs file system with a few thousand snapshots.  When I
>> attempted to delete 20 or so of them the problems started.
>>
>> The disks are being read but except for the first few minutes there are
>> no writes.
>>
>> Memory usage keeps growing until all the memory (24 Gb) is used in a
>> few hours. Eventually the system will crash with out of memory errors.

In addition to what CMurphy and QW suggested (both valid), I have a 
couple other suggestions/pointers.  They won't help you get out of the 
current situation, but they might help you stay out of it in the future.

1) A "few thousand snapshots", but no mention of how many subvolumes 
those snapshots are of, or how many per subvolume.

As CMurphy says but I'll expand it here, taking a snapshot is nearly 
free, just a bit of metadata to write because btrfs is COW-based and all 
a snapshot does is lock down a copy of everything in the subvolume as it 
exists currently and the filesystem's already tracking that, but removal 
is expensive, because btrfs must go thru and check everything to see if 
it can actually be deleted (no other snapshots referencing the block) or 
not (something else referencing it).

Obviously, then, this checking gets much more complicated the more 
snapshots of the same subvolume that exist.  IOW, it's a scaling issue.

The same scaling issue applies to various other btrfs maintenance tasks, 
including btrfs check (aka btrfsck), and btrfs balance (and thus btrfs 
device remove, which does an implicit balance).  Both of these take *far* 
longer if the number of snapshots per subvolume is allowed to get out of 
hand.

Due to this scaling issue, the recommendation is no more than 200-300 
snapshots per subvolume, and keeping it down to 50-100 max is even 
better, if you can do it reasonably.  That helps keep scaling issues and 
thus time for any necessary maintenance manageable.  Otherwise... well, 
we've had reports of device removes (aka balances) that would take 
/months/ to finish at the rate they were going.  Obviously, well before 
it gets to that point it's far faster to simply blow away the filesystem 
and restore from backups.[1]

It follows that if you have an automated system doing the snapshots, it's 
equally important to have an automated system doing snapshot thinning as 
well, keeping the number of snapshots per subvolume within manageable 
scaling limits.

So if that's "a few thousand snapshots", I hope you that's of (at least) 
a double-digit number of subvolumes, keeping the number of snapshots per 
subvolume under 300, and under 100 if your snapshot rotation schedule 
will allow it.

2) As Qu suggests, btrfs quotas increase the scaling issues significantly.

Additionally, there have been and continue to be accuracy issues with 
certain quota corner-cases, so they can't be entirely relied upon anyway.

Generally, people using btrfs quotas fall into three categories:

a) Those who know the problems and are working with Qu and the other devs 
to report and trace issues so they will eventually work well, ideally 
with less of a scaling issue as well.

Bless them!  Keep it up! =:^)

b) Those who have a use-case that really depends on quotas.

Because btrfs quotas are buggy and not entirely reliable now, not to 
mention the scaling issues, these users are almost certainly better 
served using more mature filesystems with mature and dependable quotas.

c) Those who don't really care about quotas specifically, and are just 
using them because it's a nice feature.  This likely includes some who 
are simply running distros that enable quotas.

My recommendation for these users is to simply turn btrfs quotas off for 
now, as they're presently in general more trouble than they're worth, due 
to both the accuracy and scaling issues.  Hopefully quotas will be stable 
in a couple years, and with developer and tester hard work perhaps the 
scaling issues will have been reduced as well, and that recommendation 
can change.  But for now, if you don't really need them, leaving quotas 
off will significantly reduce scaling issues.  And if you do need them, 
they're not yet reliable on btrfs anyway, so better off using something 
more mature where they actually work.

3) Similarly (tho unlikely to apply in your case), beware of the scaling 
implications of the various reflink-based copying and dedup utilities, 
which work via the same copy-on-write and reflinking technology that's 
behind snapshotting.

Tho snapshotting is effectively reflinking /everything/ in the subvolume, 
so the scaling issues compound much faster there than they will with a 
more trivial level of reflinking.  Of course, when it comes to dedup, a 
more trivial level of reflinking means less benefit from doing the dedup 
in the first place, so there's a limit to the effectiveness of dedup 
before it starts having the same scaling issues that snapshots do.  But 
if you have exactly two copies of /everything/ in a subvolume, and dedup 
it down to a single copy, that's the same effect as a single snapshot, so 
it does take a lot of reflink-based deduping to get to the same level as 
a couple hundred snapshots.  But it's something to think about if you're 
planning to dedup say 1000 copies of a bunch of stuff by making them all 
reflinks to the same single copy.



Bottom line, if those "few thousand snapshots" are all of the same subvol 
or two, /especially/ if you're running btrfs quotas on top of that... 
that's very likely your problem right there.  Keep your number of 
snapshots per subvolume under 300, and turn off btrfs quotas, and you'll 
very likely find the problem disappears.


---
[1] Backups:  Sysadmin's first rule of backups, simple form:  If you 
don't have a backup, you are by lack thereof defining the data at risk as 
worth less than the time/hassle/resources to do that backup.  Because if 
it was worth more than the time/hassle/resources necessary for the 
backup, by definition, it would /be/ backed up.

It's your choice to make, but no redefining after the fact.  If you lost 
the primary copy due to whatever reason and didn't have that backup, you 
simply defined the data as not worth enough to have a backup, and get to 
be happy because you saved what your actions, or lack thereof, defined as 
of most value to you, the time/hassle/resources you would have otherwise 
spent doing that backup.

Sysadmin's second rule of backups:  A backup isn't complete until it has 
been tested restorable.  Until then, it's simply a would-be backup, 
because you don't actually know if it worked or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

