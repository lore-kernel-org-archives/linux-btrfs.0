Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:48019 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbLXJFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 04:05:13 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 89A2247ECDD
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Dec 2015 10:04:53 +0100 (CET)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: BTRFS: could not find root 8
Date: Thu, 24 Dec 2015 10:04:48 +0100
Message-ID: <4764679.qpAWc4Esch@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I’m running Arch Linux with kernel 4.2.5-1-ARCH

Since a few days, I have noticed a series of messages :

« BTRFS: could not find root 8 »

During boot.

Besides that, the system behaves normally, and I have no clue…

Here is an extract of the relevant parts of my dmesg :

[    1.515764] Btrfs loaded
[    1.516239] BTRFS: device label BOOT devid 1 transid 8557 /dev/sda8
[    1.523135] device-mapper: uevent: version 1.0.3
…
[   20.639556] BTRFS: device label LINUX devid 1 transid 474967 /dev/dm-1
[   20.952280] PM: Starting manual resume from disk
[   20.952291] PM: Hibernation image partition 254:2 present
[   20.952295] PM: Looking for hibernation image.
[   20.952730] PM: Image not found (code -22)
[   20.952738] PM: Hibernation image not present or could not be loaded.
[   20.979997] BTRFS info (device dm-1): use ssd allocation scheme
[   20.980008] BTRFS info (device dm-1): turning on discard
[   20.980014] BTRFS info (device dm-1): disk space caching is enabled
[   20.980017] BTRFS: has skinny extents
[   21.319036] ip_tables: (C) 2000-2006 Netfilter Core Team
…
[   23.047601] FS-Cache: Loaded
[   23.053089] systemd[1]: Mounted POSIX Message Queue File System.
[   23.070842] systemd[1]: Mounted Huge Pages File System.
[   23.072100] systemd[1]: Mounted Temporary Directory.
[   23.080089] BTRFS info (device dm-1): disk space caching is enabled
[   23.087653] systemd[1]: Started Remount Root and Kernel File Systems.
…
[   25.429686] BTRFS info (device sda8): use ssd allocation scheme
[   25.429694] BTRFS info (device sda8): turning on discard
[   25.429698] BTRFS info (device sda8): disk space caching is enabled
[   25.429700] BTRFS: has skinny extents
…
[   25.593769] Adding 4530172k swap on /dev/mapper/VGZ-SWAP.  Priority:-1 
extents:1 across:4530172k SSDscFS
…
[   25.777378] FAT-fs (sda2): utf8 is not a recommended IO charset for FAT 
filesystems, filesystem will be case sensitive!
[   25.800485] FAT-fs (sda2): Volume was not properly unmounted. Some data may 
be corrupt. Please run fsck.
[   25.817125] BTRFS: could not find root 8
[   25.844334] BTRFS: could not find root 8
[   25.845650] BTRFS: could not find root 8
[   25.847190] BTRFS: could not find root 8
[   25.855431] BTRFS: could not find root 8
[   25.856834] BTRFS: could not find root 8
[   25.860539] BTRFS: could not find root 8
[   25.862021] BTRFS: could not find root 8
[   29.778795] IPv6: ADDRCONF(NETDEV_UP): enp3s0: link is not ready
…

TIA, kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

