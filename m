Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59607 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbAJAls (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 19:41:48 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y9k7d-0003cz-Om
	for linux-btrfs@vger.kernel.org; Sat, 10 Jan 2015 01:41:45 +0100
Received: from 178-83-247-126.dynamic.hispeed.ch ([178.83.247.126])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 01:41:45 +0100
Received: from remy.blank by 178-83-247-126.dynamic.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jan 2015 01:41:45 +0100
To: linux-btrfs@vger.kernel.org
From: Remy Blank <remy.blank@pobox.com>
Subject: Re: Segfault in "btrfs balance start" due to kernel page allocation
 failure
Date: Sat, 10 Jan 2015 01:41:31 +0100
Message-ID: <m8psfs$h0t$1@ger.gmane.org>
References: <m8odfs$rv2$1@ger.gmane.org> <pan$91b96$595041e4$b1777a9d$1c82bf25@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$91b96$595041e4$b1777a9d$1c82bf25@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan wrote on 2015-01-09 23:43:
> Also, when you post errors, please post kernel and btrfs-progs versions.  
> I see from the trace that your kernel version is 3.17.7 so you're 
> reasonably current there, but of course that doesn't give the userspace 
> version.

I did mention 3.17.7, but I forgot to say it was the kernel :) Userspace
is 3.18.

> And finally just a practical note.  Over time I've noticed that rsync 
> seems to be involved in quite a few posted bugs, most of which have of 
> course been fixed by now.  Rsync apparently stresses btrfs in ways few 
> other tasks do, thus triggering more than its share of bugs that most 
> other things don't tend to tickle. 

Maybe it would be worth adding some tests using rsync to the test suite
(I assume there is one)?

> I'm a gentooer myself, with (among 
> other things) the main package tree rsynced to btrfs, and have seemed to 
> escape these issues, but (1) all my btrfs are on SSD and thus likely 
> escape some of the race conditions that trigger on spinning rust, and (2) 
> I'm a strong believer in not putting all my data eggs in the same 
> filesystem basket

Yeah, that's definitely very good advice. I'm currently using
rdiff-backup for my backups, but it's been unsupported for years and I
was looking for a good replacement. Btrfs snapshots seemed like a very
good candidate, so I converted my 4 machines to btrfs and set up hourly
snapshots on the laptops and rsync/snapshot backups on the servers.
While doing this, I was hit with several errors, some of which I could
fix and some that I don't know what to do about. This is one of them.

Having kernel errors pop up under totally normal conditions, when the
only load is periodically copying stuff over and snapshotting, scared me
enough that I'm now converting back to ext4 (I was on ext3 before, but
apparently ext4 is now safe enough since the fsync fiasco was resolved).
I never had any issues with ext*, but of course that's only a single
data point.

> so I partition heavily, and all my partitions are 
> relatively small (biggest btrfs 24 GiB, actually the gentoo tree, 
> sources, and binpkgs partition).  Additionally, I prefer backups to 
> identically sized partitions over snapshots (which are nice but if the 
> filesystem has problems it takes all the snapshots with it), and thus 
> don't tend to use the btrfs snapshots feature.  I suspect that has 
> something to do with my relative scarcity of triggered btrfs issues, here.

I'll continue using btrfs but on loopback-mounted files stored on ext4,
and play some more with snapshot-based backups (while still doing
backups with rdiff-backup, so I can afford to lose the containers). I'll
check back in a year or two, hopefully btrfs will have gained more
stability by then. The feature set is certainly awesome, so I'm looking
forward to being able to use it.

> So just be aware that rsync /does/ seem to stress btrfs more than most 
> tasks, and try to plan/behave accordingly, perhaps avoiding rsync when 
> possible, or keeping additional backups in case, and/or choosing 
> something other than btrfs for at least one level of backups, etc.

Having to restrict what kinds of tools I can use on a filesystem is a
serious limitation, so for now I'm not going to use btrfs for anything
that isn't completely disposable.

-- Remy

