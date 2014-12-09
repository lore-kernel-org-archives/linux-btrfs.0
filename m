Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:39728 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbaLILPM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 06:15:12 -0500
Received: from omgreatgod.store (com4.strato.de [81.169.145.237])
	by smtp-ox.front (RZmta 36.2 AUTH)
	with ESMTPSA id i00b16qB9BF90Oz
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Tue, 9 Dec 2014 12:15:09 +0100 (CET)
Date: Tue, 9 Dec 2014 12:15:09 +0100 (CET)
From: Florian Uekermann <florian@uekermann.me>
Reply-To: Florian Uekermann <florian@uekermann.me>
To: linux-btrfs@vger.kernel.org
Message-ID: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store>
Subject: Device only missing if unmounted
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am using a few disks in Raid1 mode. This is the output of various
commands in unmounted state.

root@oot:/# uname -a
Linux oot 3.18.0-rc5+ #1 SMP Sun Nov 23 18:01:56 CET 2014 x86_64 GNU/Linux
root@oot:/# btrfs --version
Btrfs v3.17
root@oot:/# btrfs fi show
Label: none uuid: be2b3499-7452-4b91-b664-4ec4d7ff62b9
Total devices 3 FS bytes used 149.68GiB
devid 2 size 465.76GiB used 151.03GiB path /dev/sdb
devid 3 size 465.76GiB used 151.03GiB path /dev/sda
devid 4 size 92.26GiB used 0.00B path /dev/sdc4

Btrfs v3.17
root@oot:/# btrfs fi df /srv/storage/
Data, RAID1: total=150.00GiB, used=149.40GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=1.00GiB, used=287.42MiB
GlobalReserve, single: total=96.00MiB, used=0.00B

I stripped a few lines from the output of btrfs fi show, which
describe other filesystems.
If I unmount the devices in question, I get the following
output (note that missing devices are reported now):

root@oot:/# btrfs fi show
Label: none uuid: be2b3499-7452-4b91-b664-4ec4d7ff62b9
Total devices 4 FS bytes used 149.68GiB
devid 2 size 465.76GiB used 151.03GiB path /dev/sdb
devid 3 size 465.76GiB used 151.03GiB path /dev/sda
devid 4 size 92.26GiB used 0.00B path /dev/sdc4
*** Some devices missing

Btrfs v3.17

I got into this state by removing a device from the array formatting it
and then adding it again (some time ago, I can't remember the exact
sequence of commands)

The discrepancy in output between mounted and unmounted state is not
a problem in itself for me, but this issue seems to interrupt systemds
boot sequence, which only continues successfully if I mount the array manually.
The array is not degraded, I just removed a drive (via btrfs delete I think).

If I try to remove the "missing devices" with the btrfs tool the following
happens:

btrfs dev del missing /srv/storage
ERROR: error removing the device 'missing' - no missing devices found to remove

btrfs balance start /srv/storage/ does not solve the issue.
