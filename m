Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42575 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756583AbaFAA40 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 20:56:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wqu4V-0004GD-Rs
	for linux-btrfs@vger.kernel.org; Sun, 01 Jun 2014 02:56:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 02:56:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jun 2014 02:56:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: All free space eaten during defragmenting (3.14)
Date: Sun, 1 Jun 2014 00:56:09 +0000 (UTC)
Message-ID: <pan$d1ec3$d22b3db$8681b9b1$d9742e40@cox.net>
References: <1703083.hLnNuPsKpY@linux-suse.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Szőts Ákos posted on Sat, 31 May 2014 09:19:03 +0200 as excerpted:

> A tried to make a full defragmenting on my $HOME directory (which
> doesn't contain any snapshots). After some hours of running, it stopped
> with „No space left on device” error.
> 
> I checked and it ate about 50 GB of free space.
> Before: Data, single: total=433.83GiB, used=~380.00GiB
> After: Data, single: total=433.83GiB, used=~430.00GiB
> Both times: Metadata, DUP: total=8.00GiB, used=7.08GiB
> 
> In the "btrfs fi df" man page I didn't find anything that is related to
> this phenomenon.
> 
> My questions are:
> - Is it a bug or some consequence of the defrag process?
> - Can I reclaim somehow the free space?
> 
> Command used:
> shopt -s dotglob for i in *; do echo "$i"; btrfs fi defrag -clzo -r
> "$i"; done
> 
> Btrfs and kernel version:
> Btrfs v3.12+20131125
> Linux 3.14.4-1.gbebeb6f-desktop #1 SMP PREEMPT x86_64

Your btrfs-progs version is old.  You may want to update it.  Current is 
3.14.2.

Seeing just the title, I was sure I knew what happened, but that would 
have been snapshot related, and you say above that you don't have any 
snapshots... of that directory.

But... what is your layout?  Subvolumes?  Where are they mounted?  Do you 
have snapshots of any of them?  Also, a btrfs filesystem show <mountpoint> 
should normally accompany a btrfs filesystem df, as it's pretty hard to 
interpret one without the other.

Here's the deal.  Due to scaling issues the original snapshot aware 
defrag code was recently disabled, so defrag now doesn't worry about 
snapshots, only defragging whatever is currently mounted.  If you have a 
lot of fragmentation and are using snapshots, the defrag will copy all 
those fragmented files in ordered to defrag them, thus duplicating their 
blocks and doubling their required space.  Based on the title alone, 
that's what I /thought/ happened, and given what you did /not/ say, I 
actually still think it is the case and the below assumes that, tho I'm 
no longer entirely sure.

You do say your home dir doesn't contain snapshots, but is it 
snapshotted?  If it's on a snapshotted subvolume (or the main filesystem 
if you don't do subvolumes), it'll be snapshotted along with the 
subvolume, and that explains the extra usage as it's doubling the space.  
Had you included the layout and snapshot information, we could have seen 
from that whether this was the issue, or not, but...

Meanwhile, about the defrag options.  Defrag now has the recursive option 
(-r), which you used, so you really don't need to do the fancy loop stuff 
any more.  Just use the -r/recursive option and let it do the extra work.

The -c/compress option will trigger file compression as well as defrag.  
Normally this would cause them to use less space (or do nothing if you 
had consistently mounted with compress=lzo, but since snapshot-aware-
defrag is currently disabled, in the presence of snapshots of the same 
files it could cause more space to be used instead, since it's likely to 
cause files that don't need defragged to be rewritten as well.

As for reclaiming the space... assuming you have snapshots of /home 
(either as snapshots of the /home subvolume or of /, if you don't have a 
/home subvolume and / is your main mountpoint) as seems likely from the 
given symptoms, now that you've de-duplicated the data, the way to 
recover the space would be to either delete all the pre-defrag snapshots 
so that copy can be freed, or revert to the last pre-defrag snapshot, and 
delete any snapshots since along with the working copy.  You'd be 
deleting one or the other dup of the data depending on which way you 
went, but which way you go is up to you.

The other alternative, of course, would be to mkfs the entire filesystem 
and restore from your backups. =:^)

Meanwhile, do consider using the autodefrag mount option.  That should 
help keep fragmentation from getting out of hand in the first place, altho 
if you've run without it for awhile, you're likely to already be highly 
fragmented, and you may see a slowdown for awhile until the filesystem 
catches up with the fragmentation that's already there.  Tho again, if 
you're using snapshots, given that snapshot-aware-defrag is disabled ATM, 
that could trigger data duplication as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

