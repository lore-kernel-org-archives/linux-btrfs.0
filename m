Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60577 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbbLVCNi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:13:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBCSG-0007Tu-RL
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 03:13:36 +0100
Received: from ip5f5ae08a.dynamic.kabel-deutschland.de ([95.90.224.138])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 03:13:36 +0100
Received: from hurikhan77 by ip5f5ae08a.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 03:13:36 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: attacking btrfs filesystems via UUID collisions?
Date: Tue, 22 Dec 2015 03:13:29 +0100
Message-ID: <20151222031329.5f514a5a@jupiter.sol.kaishome.de>
References: <5668A1CB.1020007@anonym.com>
	<CAJCQCtQCoi52o2REWZGObq-19EpgCv+7QmKvP=Gvk1myVq-+_g@mail.gmail.com>
	<1449872498.31388.74.camel@fo>
	<CAJCQCtSXkXs0jQ=zaP6FJvRZS0yvz5CrjP8a06K0+htG5H8LTg@mail.gmail.com>
	<1450052868.30943.27.camel@scientia.net>
	<566EC2D7.3000101@gmail.com>
	<CAJCQCtTuETCh_n3dnhPbVBx6_0dcAmNgNWN_bpsTE8goH8byKg@mail.gmail.com>
	<56701B79.8030105@gmail.com>
	<20151215141813.GG26782@carfax.org.uk>
	<1450267418.6259.11.camel@scientia.net>
	<20151216144132.GE6322@ret.masoncoding.com>
	<1450278243.5570.10.camel@scientia.net>
	<pan$8abc4$5a93b86f$66b76637$230f3991@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 17 Dec 2015 03:25:50 +0000 (UTC)
schrieb Duncan <1i5t5.duncan@cox.net>:

> So it's definitely _not_ something that reiserfsck would do in a
> "normal" fsck, only when doing "I'm desperate and don't have backups,
> go to the ends of the earth if necessary to recover what you can of
> my data, and yes, I understand it could be a bit risky or end up
> rather disordered, but I'm willing to take that risk because I _am_
> that desperate", level recovery.

What's fascinating: reiserfs was actually quite good at that and
actually saved me from "I'm desperate and don't have backups,
go to the ends of the earth if necessary to recover what you can of
my data, and yes, I understand it could be a bit risky or end up
rather disordered, but I'm willing to take that risk because I _am_
that desperate" (phew that's long). According to checksums all files
except some inflight temporary data was completely intact (in addition
to many files which came back out of nowhere - even ending up in their
original directory but not so intact). Lucky me... :-D

Cause of this was an unstable RAID controller which switched one hard
disk after the next into offline mode, then completely went offline
itself - leaving me with a system still running acceptably from cache
only. It was strange...

And reiserfs did this magic twice for me (but the second time I had
current backups, just wanted to have a copy of files created since the
nightly backup).

BTW: Ext3 partitions on the same hardware were broken beyond repair and
had to be recreated. e2fsck only made it worse.

Apparently, reiserfs did absolutely not scale to multithreaded
workloads - which is why I switched to xfs (it seemed pretty good at
it, especially on RAID and its behavior to distribute data diagonally
across the disks tho I won't recommend it without bbu as it tends to
nullify file contents during log-replay). It has proven similarly stable
in case of hardware havoc.

BTW2: The server with the "RAID controller accident" is still in
production but converted to XFS and migrated into virtualization
meanwhile. And yes: It has a daily backup schedule. :-)

-- 
Regards,
Kai

Replies to list-only preferred.

