Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35819 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaBHJ20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 04:28:26 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WC4Cx-00015j-2R
	for linux-btrfs@vger.kernel.org; Sat, 08 Feb 2014 10:28:19 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 10:28:19 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 10:28:19 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Sat, 08 Feb 2014 09:50:20 +0100
Message-ID: <cn7hsa-9pm.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <CAE5mzviWHA=RmibQ_B3fD355nhAXgGFAGJV=Shk9M6tT6htEdQ@mail.gmail.com> <6C86A9EB-75D7-4783-B055-8D509F695412@colorremedies.com> <qhufsa-27u.ln1@hurikhan77.spdns.de> <D3E4553E-C9D8-4D94-A124-506961946360@colorremedies.com> <r53gsa-d85.ln1@hurikhan77.spdns.de> <pan$51b87$4be6129$a0bf434c$9a827758@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

[...]

Difficult to twist your mind around that but well explained. ;-)

> A snapshot thus looks much like a crash in terms of NOCOW file integrity
> since the blocks of a NOCOW file are simply snapshotted in-place, and
> there's already no checksumming or file integrity verification on such
> files -- they're simply directly written in-place (with the exception of
> a single COW write when a writable snapshottted NOCOW file diverges from
> the shared snapshot version).
> 
> But as I said, the applications themselves are normally designed to
> handle and recover from crashes, and in fact, having btrfs try to manage
> it too only complicates things and can actually make it impossible for
> the app to recover what it would have otherwise recovered just fine.
> 
> So it should be with these NOCOW in-place snapshotted files, too.  If a
> NOCOW file is put back into operation from a snapshot, and the file was
> being written to at snapshot time, it'll very likely trigger exactly the
> same response from the application as a crash while writing would have
> triggered, but, the point is, such applications are normally designed to
> deal with just that, and thus, they should recover just as they would
> from a crash.  If they could recover from a crash, it shouldn't be an
> issue.  If they couldn't, well...

So we have common sense that taking a snapshot looks like a crash from the 
applications perspective. That means if their are facilities to instruct the 
application to suspend its operations first, you should use them - like in 
the InnoDB case:

http://dev.mysql.com/doc/refman/5.1/en/lock-tables.html:

| FLUSH TABLES WITH READ LOCK;
| SHOW MASTER STATUS;
| SYSTEM xfs_freeze -f /var/lib/mysql;
| SYSTEM YOUR_SCRIPT_TO_CREATE_SNAPSHOT.sh;
| SYSTEM xfs_freeze -u /var/lib/mysql;
| UNLOCK TABLES;
| EXIT;

Only that way you get consistent snapshots and won't trigger crash-recovery 
(which might otherwise throw away unrecoverable transactions or otherwise 
harm your data for the sake of consistency). InnoDB is more or less like a 
vm filesystem image on btrfs in this case. So the same approach should be 
taken for vm images if possible. I think VMware has facilities to prepare 
the guest for a snapshot being taken (it is triggered when you take 
snapshots with VMware itself, and btw it usually takes much longer than 
btrfs snapshots do).

Take xfs for example: Although it is crash-safe, it prefers to zero-out your 
files for security reasons during log-replay - because it is crash-safe only 
for meta-data: if meta-data has already allocated blocks but file-data has 
not yet been written, a recovered file may end up with wrong content 
otherwise, so its cleared out. This _IS_NOT_ the situation you want with vm 
images with xfs inside hosted on btrfs when taking a snapshot. You should 
trigger xfs_freeze in the guest before taking the btrfs snapshot in the 
host.

I think the same holds true for most other meta-data-only-journalling file 
systems which probably even do not zero-out files during recovery and just 
silently corrupt your files during crash-recovery.

So in case of crash or snapshot (which looks the same from the application 
perspective), btrfs' capabilities won't help you here (at least in the nocow 
case, probably in the cow case too, because the vm guest may write blocks 
out-of-order without having the possibility to pass write-barriers down to 
btrfs cow mechanism). Taking snapshots of database files or vm images 
without proper prepartion only guarantees you crash-like rollback 
situations. Taking snapshots even at short intervals only makes this worse, 
with all the extra downsides of effects this has within the btrfs.

I think this is important to understand for people planning to do automated 
snapshots of such file data. Making a file nocow only helps the situation 
during normal operation - but after a snapshot, a nocow file is essentially 
cow while carried over to the new subvolume generation during writes of 
blocks from the old generation.

-- 
Replies to list only preferred.

