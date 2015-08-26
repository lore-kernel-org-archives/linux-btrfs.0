Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbbHZG6V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 02:58:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUUf4-0006jv-Sd
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 08:58:19 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 08:58:18 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 08:58:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Trying to balance/delete after drive failure
Date: Wed, 26 Aug 2015 06:57:55 +0000 (UTC)
Message-ID: <pan$92274$238c815$22837b41$b232829f@cox.net>
References: <82aaa9565d7e4304b47cbccb63eddae4@wth.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

jan posted on Mon, 24 Aug 2015 11:20:41 +0000 as excerpted:

> I am running a raid1 btrfs with 4 disks. One of my disks died the other
> day. So I replaced it with a new one. After that I tried to delete the
> failed (now missing) disk. This resulted in some but not much IO and
> some messages like these:
> 
> kernel: BTRFS info (device sdd): found 9 extents
> kernel: [22138.202334] BTRFS info (device sdd): relocating block group
> 10093403832320 flags 17
> 
> Perf show this:
>   47.21%  [kernel]                    [k] rb_next
>   29.89%  [kernel]                    [k] comp_entry
>    9.54%  [kernel]                    [k] btrfs_merge_delayed_refs
> 
> And top this:
> 27742 root      20   0       0      0      0 R 100.0  0.0  19:22.90
> kworker/u8:7
> 
> But at one point no new messages appeared and no IO could be seen. I
> thought maybe the process hung. So I rebooted the machine. After that I
> tried a balance with the same result.
> 
> Here some information that might be important:
> 
> uname -a Linux thales 4.1.5-100.fc21.x86_64 #1 SMP Tue Aug 11 00:24:23
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> ###
> 
> btrfs --version btrfs-progs v4.1

FWIW, one-for-one replace is what the (relatively new) btrfs replace 
(note, NOT btrfs device replace, as might have been expected) command is 
for, as it shortcuts the add/delete steps a bit.  See the btrfs-replace 
manpage.

I had delayed replying to this in the hope that someone else who could 
perhaps be of more help would reply, but since I don't see any replies 
yet...

First, let me congratulate you on being actually mostly current.  You're 
slightly behind on btrfs-progs, with 4.1.2 being the latest, but nothing 
major there, and are on the latest stable 4.1 kernel series, so good 
going! =:^)

How many btrfs snapshots, if any, on the filesystem, and do you have 
btrfs quotas enabled on it at all?

I ask because btrfs maintenance such as balance, either directly invoked, 
or invoked with a btrfs device delete or btrfs replace, doesn't scale 
particularly well in the presence of large numbers of snapshots or with 
quotas enabled.  In these instances, the balance will appear to have 
stopped in terms of IO, but it's still doing heavy CPU work figuring out 
the mapping between all those snapshots (and/or quotagroups) and the 
extents it happens to be working on at the time.

Generally, I recommend no more than 10K snapshots at absolute most, and 
if at all possible, keep it to 1-2K snapshots.  Even with say half-hourly 
snapshots, given reasonable thinning, 250-ish snapshots per subvolume is 
quite reasonable, thus allowing four subvolumes at the full 250 snapshots 
schedule for the 1000 snapshot per filesystem cap, or eight subvolumes 
worth for the 2K cap.  And quotas are still problematic and unreliable on 
btrfs for other reasons as well, tho they're working on it, so there I 
recommend that people use other more mature filesystems if they really 
need quotas, or keep them off on btrfs, if not, unless of course they're 
working with the devs to test the quota feature specifically.

Between that and the several TiB of raw data and metadata shown in your 
btrfs fi show and df, it could take awhile, tho if you've only a handful 
of snapshots and don't have quotas enabled, IO shouldn't be stalled for 
/too/ long and it shouldn't take /forever/.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

