Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33608 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbbFQHRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 03:17:03 -0400
Date: Wed, 17 Jun 2015 00:16:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20150617071654.GI16468@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a few power offs due to a faulty power supply, and my mdadm raid5
got into fail mode after 2 drives got kicked out since their sequence
numbers didn't match due to the abrupt power offs.

I brought the swraid5 back up by force assembling it with 4 drives (one
was really only a few sequence numbers behind), and it's doing a full
parity rebuild on the 5th drive that was farther behind.

So I can understand how I may have had a few blocks that are in a bad
state.
I'm getting a few (not many) of those messages in syslog.
BTRFS: read error corrected: ino 1 off 226840576 (dev /dev/mapper/dshelf1 sector 459432)

Filesystem looks like this:
Label: 'btrfs_pool1'  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
        Total devices 1 FS bytes used 8.29TiB
        devid    1 size 14.55TiB used 8.32TiB path /dev/mapper/dshelf1

gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=8.29TiB, used=8.28TiB
System, DUP: total=8.00MiB, used=920.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=14.00GiB, used=10.58GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

Kernel 3.19.8.

Just to make sure I understand, do those messages in syslog mean that my
metadata got corrupted a bit, but because I have 2 copies, btrfs can fix
the bad copy by using the good one?

Also, if my actual data got corrupted, am I correct that btrfs will
detect the checksum failure and give me a different error message of a
read error that cannot be corrected?

I'll do a scrub later, for now I have to wait 20 hours for the raid rebuild
first.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
