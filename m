Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:38254
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755898Ab3AEXVD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jan 2013 18:21:03 -0500
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: BUG btrfs fi show displays stale btrfs volume
Message-Id: <96FA5245-87A9-43C4-9B56-C0F4ADB9D975@colorremedies.com>
Date: Sat, 5 Jan 2013 16:21:00 -0700
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've filed this bug under util-linux, because I think wipefs isn't deleting all btrfs metadata it could. But ultimately it appears to be a btrfs bug because nothing else sees the stale volume.

https://bugzilla.redhat.com/show_bug.cgi?id=889888#c15

btrfs-progs-0.20.rc1.20121017git92d9eec-1.fc18.x86_64
e2fs-progs-1.42.5-1.fc18.x86_64
kernel 3.7.1-2

Brand new 80GB virtual disk, so it's completely zero'd.

1. fdisk to create one partition, all defaults.
2. Format that sda1 with mkfs.btrfs -L first.
3. btrfs fi show displays "first" labeled volume.
4. wipefs -a /dev/sda1 and it finds btrfs metadata, ostensibly removes it.
5. btrfs fi show does NOT show "first" anymore.
6. fdisk /dev/sda again, delete the one partition; create a new partition 500MB and a second one for remaining space.
7. btrfs fi show still does not show "first".
8. mkfs.ext4 /dev/sda1
9. btrfs fi show NOW SHOWS "first" on sda1!
10. Reboot
11. btrfs fi show still shows "first" on sda1, size 80GB.

Tentative conclusions:

A. wipefs isn't deleting all btrfs metadata it could. 

B. mkfs.ext4 is refreshing stale btrfs metadata in a way that causes btrfs fi show to see.

C. btrfs fi show seems to blatantly disregard the partition map, because it shows a volume the partition map cannot possibly validly support.

D. Nothing else sees this phantom btrfs volume. btrfs fi show seems confused.


Chris Murphy