Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58576 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaCFVdt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 16:33:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLfvI-00070O-CD
	for linux-btrfs@vger.kernel.org; Thu, 06 Mar 2014 22:33:48 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 22:33:48 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 22:33:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Understanding btrfs and backups
Date: Thu, 6 Mar 2014 21:33:24 +0000 (UTC)
Message-ID: <pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>
References: <loom.20140306T191655-366@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Mesa posted on Thu, 06 Mar 2014 18:18:15 +0000 as excerpted:

> apologies if this is a resend - it appeared to me that it was rejected
> because of something in how Gmail was formatting the message. I can't
> find it in the Gmane archives which leads me to believe it was never
> delivered.

Probably HTML-formatted.  AFAIK vger.kernel.org (the list-serv for many 
kernel lists) is set to reject that.  Too bad more list-servs don't do 
likewise. =:^(

> I was hoping to gain some clarification on btrfs snapshops and how they
> function as backups.

Looking at the below it does indeed appear you are confused, but this is 
the place to post the questions necessary to get unconfused. =:^)

> I did a bit of Googling and found lots of examples of bash commands, but
> no one seemed to explain what was going on to a level that would satisfy
> me for my data needs.

You don't mention whether you've seen/read the btrfs wiki or not.  That's 
the most direct and authoritative place to look... and to bookmark. =:^)

https://btrfs.wiki.kernel.org

> I read this Ars Technica article today
> http://arstechnica.com/information-technology/2014/01/bitrot-and-atomic-
cows-inside-next-gen-filesystems/
> 
> First of all, the btrfs-raid1 sounds awesome. Because it helps protect
> against one of RAID1's failings - bit rot issues. But raid1 is not
> backup, it's just redundancy.
> 
> Second, the article mentions using snapshots as a backup method.

Well, this is where you start to be confused.  Snapshots are not backups 
either, altho they're sort of opposite raid in that while raid is 
redundancy-only, snapshots are rollback-only, without the redundancy 
(I'll explain...).

> Page 3 section: Using the features.
> 
> He makes a snapshot and sends that. Then he sends what changed the
> second time. He mentions that because btrfs knows what's changed it's a
> quick process.

OK, what that is discussing is btrfs send/receive, with snapshots simply 
part of the process of doing that.  Think rsync in effect, but btrfs-
specific and much more efficient.  Btrfs send/receive does use snapshots 
but only as part of making the send/receive process more reliable and 
efficient.  I'll discuss snapshots (and COW) first, below, then bring in 
btrfs send/receive at the end.

> Right now on my Linux computer I use Back in Time which, I think, is
> just an rsync frontend. It takes a long time to complete the backup for
> my 1 TB /home drive. The copy part is nice and quick, but the comparison
> part takes a long time and hammers the CPU. I have it setup to run at
> night because if it runs while I'm using the computer, things can crawl.
> 
> So I was wondering if btrfs snapshots are a substitute for this. Right
> now if I realize I deleted a file 5 days ago, I can go into Back in Time
> (the gui) or just navigate to it on the backup drive and restore that
> one file.

> From what I've read about btrfs, I'd have to restore the entire home
> drive, right? Which means I'd lose all the changes from the past five
> days. If that's the case, it wouldn't really solve my problem -
> although maybe I'm just not thinking creatively.

No, in snapshot terms you don't restore the entire drive.  Rather, the 
snapshots are taken on the local filesystem, storing (like one still 
frame in a series that makes a movie, thus the term snapshot) the state 
of the filesystem at the point the snapshot was taken.  Files can be 
created/deleted/moved/altered after the snapshot, and only the 
differences between snapshots and between the last snapshot and the 
current state are changed.

The fact that btrfs is a copy-on-write (COW) filesystem makes 
snapshotting very easy... trivial... since it's a byproduct of the COW 
nature of the filesystem and thus comes very nearly for free, with only 
hooking up some way to access specific bits of functionality that's 
already there necessary in ordered to get snapshotting.

A copy-on-write illustration (please view with a monospace font for 
proper alignment):

Suppose each letter of the following string represents a block of a 
particular size (say 4KiB) of a file, with the corresponding block 
addresses noted as well:

0000000001111111  
1234567890123456
||||||||||||||||
abcdefgxijklmnop

It's the first bit of the alphabet, but notice the x where h belongs.  
Now someone notices and edits the file, correcting the problem:

abcdefghijklmnop

Except when they save the file, a COW-based filesystem will make the 
change like this:

0000000501111111
1234567390123456
||||||| ||||||||
abcdefg ijklmnop
       |
       h

The unchanged blocks of the file all remain in place.  The only change is 
to the one block, which unlike normal filesystems, isn't edited in-place, 
but rather, is written into a new location, and the filesystem simply 
notes that the new location (53) should be used to read that file block 
now, instead of the old location (08).  Of course as illustrated here, 
the addresses each take up two characters while the data block only takes 
up one, but each of those letters represents a whole 4 KiB, so in 
actuality the data is much larger than the address referring to it.

Now all that a snapshot taken when the first copy of the file was there 
has to do is keep the old address list for it, 01-16 around when the new 
copy, addresses 01-07,53,09-16, gets made.  And the only space the 
snapshot takes up is the metadata block for the old address list and the 
single data block number 08, where that x was in the illustration.

The only thing needed was that some mechanism be hooked up to tell the 
filesystem when to record the current situation as a snapshot, and some 
way to select the various snapshots.


As for restoring, since a snapshot is a copy of the filesystem as it 
existed at that point, and the method btrfs exposes for accessing them is 
to mount that specific snapshot, to restore an individual file from a 
snapshot, you simply mount the snapshot you want somewhere and copy the 
file as it existed in that snapshot over top of your current version 
(which will have presumably already been mounted elsewhere, before you 
mounted the snapshot to retrieve the file from), then unmount the 
snapshot and go about your day. =:^)

> Also, if I first do the big snapshot backup and then the increments, how
> do I delete the older snapshots? In other words, the way I'm picturing
> things working is that I have the main snapshot and every snapshot after
> that is just a description of what's changed since then. So wouldn't the
> entire chain be necessary to reconstruct where I'm at now?

Since a snapshot is an image of the filesystem as it was at that 
particular point in time, and btrfs by nature copies blocks elsewhere 
when they are modified, all (well, not "all" as there's metadata like 
file owner, permissions and group, too, but that's handled the same way) 
the snapshot does is map what blocks composed each file at the time the 
snapshot was taken.

Which means you can delete any of them, and other snapshots remain in 
place.

Meanwhile, the actual data blocks remain where they were, as long as they 
are tracked by at least one snapshot.  In the illustration above, as long 
as at least one snapshot remains that contains block number 08 (the x), 
it won't be entirely erased, since something still links to the contents 
of that block.  As soon as all snapshots containing the 08 block are 
deleted, then block 08 itself can be returned to the pool of free blocks 
to be used again, since all snapshots tracking that block are now gone.

> On a somewhat separate note, I have noticed that many people/utilities
> for btrfs mention making snapshots every hour. Are the snapshots
> generally that small that such a think wouldn't quickly fill a hard
> drive?

Yes, they're that small.  Actually, if nothing has changed between 
snapshots, the only space taken by a snapshot is the space for the 
snapshot name and similar metadata.  No data space is used at all.  If 
only one block of one file has changed, then that's all the data space 
the snapshot will take.

Of course if nearly the entire filesystem changes, then it'll need nearly 
double the space, but that doesn't normally happen (for filesystems of 
any size anyway) when the snapshots are taken an hour apart!


However, best snapshot management practice does progressive snapshot 
thinning, so you never have more than a few hundred snapshots to manage 
at once.  Think of it this way.  If you realize you deleted something you 
needed yesterday, you might well remember about when you deleted it and 
can thus pick the correct snapshot to mount and copy it back from.  But 
if you don't realize you need it until a year later, say when you're 
doing your taxes, how likely are you to remember the specific hour, or 
even the specific day, you deleted it?  A year later, getting a copy from 
the correct week, or perhaps the correct month, will probably suffice, 
and even if you DID still have every single hour's snapshots a year 
later, how would you ever know which one to pick?  So while a day out, 
hourly snapshots are nice, a year out, they're just noise.

As a result, a typical automated snapshot thinning script, working with 
snapshots each hour to begin with, might look like this:

Keep two days of hourly snapshots: 48 hourly snapshots

After two days, delete five of six snapshots, leaving a snapshot every 6 
hours, four snapshots a day, for another 5 days: 4*5=20 6-hourly, 20
+48=68 total.

After a week, delete three of the four 6-hour snapshots, leaving daily 
snapshots, for 12 weeks (plus the week of more frequent snapshots above, 
13 weeks total): 7*12=84 daily snaps, 68+84=152 total.

After a quarter (13 weeks), delete six of seven daily snapshots, leaving 
weekly snapshots, for 3 more quarters plus the one above of more frequent 
snapshots, totaling a year: 3*13=39 weekly snaps, 152+39=191 total.

After a year, delete 12 of the 13 weekly snapshots, leaving one a 
quarter.  At 191 for the latest year plus one a quarter you can have 
several years worth of snapshots (well beyond the normal life of the 
storage media) and still be in the low 200s snapshots total, while 
keeping them reasonably easy to manage. =:^)


*But*, btrfs snapshots by themselves remain on the existing btrfs 
filesystem, and thus are subject to many of the same risks as the 
filesystem itself.  As you mentioned raid is redundancy not backup, 
snapshots aren't backup either; snapshots are multiple logical copies 
thus protecting you from accidental deletion or bad editing, but pointed 
at the same data blocks without redundancy, and if those data blocks or 
the entire physical media go bad...

Which is where real backups, separate copies on separate physical media, 
come in, which is where btrfs send/receive, as the ars-technica article 
was describing, comes in.

The idea is to make a read-only snapshot on the local filesystem, read-
only so it can't change while it's being sent, and then use btrfs send to 
send that snapshot to be stored on some other media, which can optionally 
be over the network to a machine and media at a different site, altho it 
can be to a different device on the same machine, as well.

The first time you do this, there's no existing copy at the other end, so 
btrfs send sends a full copy and btrfs receive writes it out.  After 
that, the receive side has a snapshot identical to the one created on the 
send side and further btrfs send/receives to the same set simply 
duplicate the differences between the reference and the new snapshot from 
the send end to the receive end.  As with local snapshots, old ones can 
be deleted on both the send and receive ends, as long as at least one 
common reference snapshot is maintained on both ends, so diffs taken 
against the send side reference can be applied to an appropriately 
identical receive side reference, thereby updating the receive side to 
match the new read-only snapshot on the send side.


Hopefully that's clearer now. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

