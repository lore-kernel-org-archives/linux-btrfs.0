Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:51579 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaBOU4N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Feb 2014 15:56:13 -0500
Received: from [192.168.100.50] (cpe-024-088-095-145.sc.res.rr.com [24.88.95.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 15EAED305
	for <linux-btrfs@vger.kernel.org>; Sat, 15 Feb 2014 15:56:12 -0500 (EST)
Message-ID: <52FFD46B.6040109@jrs-s.net>
Date: Sat, 15 Feb 2014 15:56:11 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs send problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list - I'm having problems with btrfs send in general, and 
incremental send in particular.

1. Performance: in kernel 3.11, btrfs send would send data at 500+MB/sec 
from a Samsung 840 series solid state drive.  In kernel 3.12 and up, 
btrfs send will only send 30-ish MB/sec from the same drive - though if 
you interrupt a btrfs send in progress, it will "catch up" to where it 
was at 500+ MB/sec.  This is pretty weird and frustrating.  Even weirder 
and more frustrating, even at 30-ish MB/sec, a btrfs send has a very 
significant performance impact on the underlying system - which is very, 
very odd; 30MB/sec isn't even a tiny fraction of the throughput that 
drive is capable of, and being an SSD, it isn't really subject to 
degradation with a little extra IOPS concurrency.

2. Precalculation: There's no way that I'm aware of currently to 
pre-determine the size of an incremental send, so I can't get any kind 
of predictive progress bar; this is something I SORELY miss from ZFS. It 
also makes snapshot management more difficult, because AFAICT there's no 
way to see how much space on disk is referenced solely by a given snapshot.

3. Incremental sends too big?: incremental btrfs send appears to be 
sending too much data.  I have a "test production" system with a couple 
of Windows 2008 VMs on it, and it takes hourly rolling snapshots, then 
does an incremental btrfs send to another system from each snapshot to 
the next periodically.  Problem is, EACH hourly snapshot replication is 
running 6-10GB of data, which seems like far too much.  I don't have any 
particular way to prove it, since I don't know of a great way to 
actually calculate the number of changed blocks - but the two Windows 
2008 VMs have no native pagefile, so they aren't burning data that way, 
they're each running VirtIO drivers, and the users aren't changing 
6-10GB of data per DAY, much less per hour.  Finally, the 6-10GB 
incremental send size doesn't change significantly whether the increment 
in question is during the middle of the working day, or in the middle of 
the night when no users are connected (and when it isn't Patch Tuesday, 
so it's not like jillions of Windows Updates are coming in either - not 
that they constitute 120GB-240GB of data!)

I know that last is maddeningly vague, but FWIW I have 30-ish similar 
setups on ZFS, operating the same way, each with roughly the same number 
of users running roughly the same set of applications, and those ZFS 
incrementals are all very consistent; middle-of-the-night incrementals 
on ZFS running well under 100MB apiece and total bandwidth for an entire 
day's incremental replication being well under how much bandwidth btrfs 
send is eating every hour. =\
