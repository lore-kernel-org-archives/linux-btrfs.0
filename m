Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta4.perrit.net ([194.213.15.92]:59448 "EHLO mta4.perrit.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbaEQJ6i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 May 2014 05:58:38 -0400
Received: from apia.perrit.net (apia.colo.hnglo.perrit.net [194.0.170.50])
	by mail.perrit.nl (Postfix) with ESMTP id 7EACC16010C
	for <linux-btrfs@vger.kernel.org>; Sat, 17 May 2014 11:50:14 +0200 (CEST)
Date: Sat, 17 May 2014 11:50:14 +0200
From: Leen Besselink <leen@consolejunkie.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs RAID1 root degraded scrub/balance still giving problems
Message-ID: <20140517095014.GA17530@apia.perrit.net>
Reply-To: leen@consolejunkie.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Every 6 months or so when Ubuntu has a server release, I take an hour of my time and do a test with a VM:

- install Ubuntu on a system with only a root btrfs filesystem and a swap partitionS
- on first boot install all the updates/upgrades
- reboot into the latest kernel for that release
- add an extra disk
- copy the partition table: sfdisk -d /dev/vda | sfdisk -d /dev/vdb
- convert to raid1, making sure it's set for all 3: system, metadata and data
- run grub-install /dev/vdb
- run re-balance
- wait for it to finish
- run scrub
- wait for it to finish
- poweroff/shutdown the VM
- remove the first disk
- start up the VM, add degraded to the Linux argument in grub
- and hope that it boots
- if it works, add back the first disk and re-balance and scrub, wait and remove the other disk and try again

In the past few releases, the first boot works. In older releases, all you got were kernel panics even the first time.

This latest release, which use Linux 3.13 and btrfs 3.12, seems to do better.

I've now found that if I use KVM and live add a disk while the VM is running, the Linux kernel picks up the disk and
btrfs adds it back to the filesystem. So that's kinda cool. :-)

But still after a few runs it still crashes or in my latest try I got a NULL pointer deference when I ran a scrub
but things kept running for a bit but Linux wasn't working normally, hanging on reading certain things from disk
(forgot to copy the kernel output, I'm sorry :-( ).

On an other time I got '3 enospc' errors during balance' after adding the disk back and running the balance command.

What is strange to me is that after a scrub and a re-balance the process should start from the beginning again.

Everything should be in a clean state.

But other then maybe being lucky that it worked the first few times, it does seem to degrade the filesystem in some way
and eventually fails.

That shouldn't be possible to happen right with raid1, a balance and a scrub ?

Is anyone doing any torture tests with this ?

This seems like a pretty straight forward case.

Especially now that it is getting closer to being able to handle this situation.

Have a good weekend,
	Leen.
