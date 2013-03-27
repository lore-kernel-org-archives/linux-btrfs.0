Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from conan.mikedilger.com ([108.166.80.77]:34921 "EHLO
	conan.mikedilger.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3C0GOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 02:14:55 -0400
Received: from hero.mikedilger.com (ip-118-90-115-226.xdsl.xnet.co.nz [118.90.115.226])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by conan.mikedilger.com (Postfix) with ESMTPSA id 1D8FE7E08F
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 06:05:09 +0000 (UTC)
Date: Wed, 27 Mar 2013 19:03:49 +1300
From: Mike Dilger <mike@mikedilger.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs "stuck" on
Message-ID: <20130327190349.3b79c13f@hero.mikedilger.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I have a remarkably similar problem as Ask Bjørn Hansen.

I have a 2TB btrfs filesystem on a SATA drive, on top of an msdos partition table, partition 1, without any form of RAID.

I have been using it to make backups using rsync like this:
1) snapshot the previous backup subvolume
2) rsync into the new snapshot
3) If we are overwriting a previous backup "level", drop that previous subvolume and rename this one into it's place.
I keep 8 levels in tower-of-hanoi strategy.  It's the same backup script I've used for the last 5 years, except I removed the rsync --link-dest and added in the btrfs snapshotting, just because dropping a subvolume is so damn quick compared to deleting all the files.


After about 400 GB of backups taken all in the same day, but having already dropped probably 12 or 13 subvolumes after snapshotting, I get the behavior.

The behavior is:
*) After mounting, things are usually ok for 20 seconds or so, then it starts
*) The disk activity lite burns constantly
*) btrfs-cleaner is fairly high up in 'top'
*) Read/writes to the device are painfully slow
*) I cannot unmount the device, nor cleanly shutdown.
*) Once the system froze hard, no mouse cursor movement, not even the reset button worked.

I'm running linux 3.8.3 pulled from git, so no distribution mods or patches.

Happy to run any tests.

-Mike
[not on this list, so need to be on the reply]
