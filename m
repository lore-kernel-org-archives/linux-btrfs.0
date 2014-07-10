Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p02c12o148.mxlogic.net ([208.65.145.81]:42694 "EHLO
	p02c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaGJWI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jul 2014 18:08:57 -0400
From: David Player <dplayer@seagullscientific.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Using serialized BTRFS snapshots as a backup
Date: Thu, 10 Jul 2014 22:08:45 +0000
Message-ID: <B2E8CD86330BEF41BB6ED95EFC9EBBEE58814D@SRVEX2.corp.seagullscientific.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to use serialized BTRFS snapshots as a backup system. The problem is that I don't know how to avoid sending duplicate data and also have the ability to prune old backups.

Specifically I've considered the following:

#snapshot
btrfs subvolume snapshot -r  live-volume  volume-date

#serialize snapshot for transmission to remote machine
btrfs send -f backup.date volume-date -p volume-yesterday

However this means I have to keep every serialized snapshot forever. I've tried unpacking these incremental snapshots, deleting intermediate volumes, and repacking the latest version. Unfortunately, deleting an intermediate snapshot appears to change the IDs for later snapshots, and future serialized snapshots can't be unpacked. In other words, I have incremental snapshots 1-4, I unpack 1-3, erase 2, and now I can't unpack 4 due to: "ERROR: could not find parent subvolume".

I've also considered keeping a chain of incremental monthly backups, and basing daily backups on both the monthly and previous daily. This would allow me to delete daily backups in the future, but now I have to send twice as much data to the backup machine.

What bothers me is that subvolume 3 (from the example above) really has all the same data before and after I delete subvolume 2. The IDs of the volume change, preventing me from unpacking incremental 4, and that's causing my problems.

Are there any better ideas I haven't thought of?

Currently running BTRFS 3.12 on kernel 3.13 (Ubuntu 14.04).

Thanks,
David Player

