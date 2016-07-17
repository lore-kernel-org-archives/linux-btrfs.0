Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dd15408.kasserver.com ([85.13.136.168]:56602 "EHLO
	dd15408.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbcGQIgd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jul 2016 04:36:33 -0400
Received: from [192.168.0.13] (p5DDCF0BD.dip0.t-ipconnect.de [93.220.240.189])
	by dd15408.kasserver.com (Postfix) with ESMTPSA id 0CD95940837
	for <linux-btrfs@vger.kernel.org>; Sun, 17 Jul 2016 10:26:40 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: Status of SMR with BTRFS
Message-ID: <91da7783-ffa1-7d35-a364-344c61e7ddbe@matthiasprager.de>
Date: Sun, 17 Jul 2016 10:26:36 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hendrik,

from my experience btrfs does work as badly with SMR drives (I only had
the opportunity to test on a 8TB Seagate device-managed drive) as ext4.
The initial performance is fine (for a few gigabytes / minutes), but
drops of a cliff as soon as the internal buffer-region for
non-sequential writes fills up (even though I tested large file SMB
transfers).

The only file system that worked really well with the 8TB Seagate SMR
drive was f2fs. I used 'mkfs.f2fs -o 0 -a 0 -s 9 /dev/sdx' to create one
and mounted it with noatime. -o means no additional over provisioning
(the 5% default is a lot of wasted space on a 8TB drive), -a 0 tells
f2fs not to use separate areas on the disks at the same time (which does
not perform well on hdds only on ssds) and finally -s 9 tells f2fs to
layout the file system in 1GB chunks.
I hammered this file system for some days (via SMB and via shred-script)
and it worked really well (performance and stability wise).

I am considering using SMR drives for the next upgrades in my storage
server in the basement - the only things missing in f2fs are checksums
and raid1 support. But in my current setup (md-raid1+ext4) I don't get
checksums either so f2fs+smr is still on my road-map. Long term, I would
really like to switch to btrfs with it's built-in check summing (which
unfortunately does not work with NOCOW) and raid1. But some of the file
systems are almost 100% filled and I'm not trusting btrfs's stability
yet (and the manageability / handling of btrfs lacks behind compared to
say zfs).


I realize this mails sounds very negative for btrfs, I'm sorry that was
not my intention. I'm actually a big fan of btrfs and already running it
on my test-server, but I fear it still needs quite some time to mature.
That's why I really appreciate all the hard work of the btrfs-devs!


Kind regards
Matthias
