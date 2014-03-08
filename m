Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zixgateway01.papersolve.com ([71.125.1.135]:51077 "EHLO
	sw-email.stardatecomputer.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751609AbaCHBqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 20:46:14 -0500
Received: from sw-email.stardatecomputer.com (127.0.0.1) id h39r6c0171sh for <linux-btrfs@vger.kernel.org>; Fri, 7 Mar 2014 20:46:13 -0500 (envelope-from <mike@PaperSolve.com>)
From: Mike Russo <mike@PaperSolve.com>
To: "'linux-btrfs@vger.kernel.org'" <linux-btrfs@vger.kernel.org>
Subject: RE: ENOSPC errors during raid1 rebalance
Date: Sat, 8 Mar 2014 01:46:12 +0000
Message-ID: <DF16C10AFF7F394A8C8A09C9405478890BCCCB2C@EXHOST.stardatecomputer.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
 <20140303183911.GL13899@carfax.org.uk>
 <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
 <73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
 <loom.20140305T190503-404@post.gmane.org>
 <pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
 <loom.20140307T021006-737@post.gmane.org>
 <20140307080213.GC6318@carfax.org.uk>
 <DF16C10AFF7F394A8C8A09C9405478890BCCC2EB@EXHOST.stardatecomputer.com>
In-Reply-To: <DF16C10AFF7F394A8C8A09C9405478890BCCC2EB@EXHOST.stardatecomputer.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alright! After doing:

cd /mymedia; find . -type f | while read file; do mv -v "$file" /dev/shm; f2=`basename "$file"`; mv -v "/dev/shm/$f2" "$file"; done 

I finally moved whatever files out of the "single" allocation and back onto the new RAID1 profile:

oot@ossy:~# /usr/src/btrfs-progs/btrfs fi df /mymedia
Data, RAID1: total=1.23TiB, used=1000.43GiB
Data, single: total=10.00GiB, used=0.00
System, RAID1: total=32.00MiB, used=184.00KiB
Metadata, RAID1: total=3.00GiB, used=1.34GiB

And then the rebalance finally was able to move those two block groups and I got no errors:

root@ossy:~# btrfs balance start -dconvert=raid1,soft /mymedia
Done, had to relocate 2 out of 1264 chunks

And now I'm totally RAID1:

root@ossy:~# /usr/src/btrfs-progs/btrfs fi df /mymedia
Data, RAID1: total=1.23TiB, used=1000.43GiB
System, RAID1: total=32.00MiB, used=184.00KiB
Metadata, RAID1: total=3.00GiB, used=1.34GiB

Yay!! If I want to get back the space I can do another defragment but I don't really care right now.  Thanks everyone for all your help on this! Hopefully this thread will assist anyone else in the future if this occurs again. 

Sincerely,

Michael Russo, Systems Engineer
PaperSolve, Inc.
268 Watchogue Road
Staten Island, NY 10314

Randomly generated quote of the last 5 minutes:
A good plan today is better than a perfect plan tomorrow.
                -- Patton
