Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49516 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3FLJnt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 05:43:49 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so6402529pad.9
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 02:43:48 -0700 (PDT)
MIME-Version: 1.0
From: "mail@beta-centauri.de" <mail@beta-centauri.de>
Date: Wed, 12 Jun 2013 11:43:28 +0200
Message-ID: <CAK-gwOxmibLQSeSZnvYdqnCUShmVf03uLCRSphYWZ3do0u6Z6w@mail.gmail.com>
Subject: Mounting RAID1 writeable with two devices missing but all data present
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have potentially found a (minor) bug (or missing feature) in btrfs,
but it might be a misunderstanding, so I like to ask here first before
reporting in Bugzilla.

I have a btrfs file system in RAID1 mode with two missing devices, but
I know that all data is still present on the remaining device. btrfs
refuses mounting this fs in rw mode (too many missing devices), as it
probably just counts the number of missing devices and assumes that
more than one missing device means that it cannot access all data.
This is surely a safe assumption, but it would be nice to have a way
to escape from this situation, like a mount option that will allow rw
after checking all chunks are present on the remaining device(s).

The condition can be reproduced by the following steps (in an empty directory):

dd if=/dev/zero of=d0 bs=1M count=1k
dd if=/dev/zero of=d1 bs=1M count=1k
losetup /dev/loop0 d0
losetup /dev/loop1 d1
mkfs.btrfs -m raid1 -d raid1 /dev/loop0 /dev/loop1
mkdir mnt
mount -t btrfs /dev/loop0 mnt
btrfs fi df mnt
# shows that everything is fine and RAID1
umount mnt
dd if=/dev/zero of=/dev/loop1 bs=1M count=1k
mount -t btrfs /dev/loop0 mnt -o degraded
btrfs device add /dev/loop1 mnt
btrfs fi show
# shows the fi has missing devices and one device with 0 bytes used
umount mnt
dd if=/dev/zero of=/dev/loop1 bs=1M count=1k
mount -t btrfs /dev/loop0 mnt -o degraded
# fails
dmesg | tail
# shows "Btrfs: too many missing devices, writeable mount is not allowed"

As I see it, there is no way to recover from this situation (without
creating a new file system on the second disk, copying all data to it,
adding the first disk to it and changing raid level to 1 - which is my
way out of this for now, but it takes a long time and really isn't
nice) as it is not possible to add new devices while the fs is mounted
ro.

If there are tricky ways to do this maybe there should be some hint
somewhere (e.g. in the dmesg message stating it is not possible to
mount writeable).

Cheers,
Martin

PS: I am not on this mailing list so please include my mail address
when replying. Thanks!
