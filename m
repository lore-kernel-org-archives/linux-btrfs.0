Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:51604
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932145AbaJNPSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 11:18:04 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id ACA2721F71
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 16:18:02 +0100 (BST)
Message-ID: <543D3EAA.4000706@barrowhillfarm.org.uk>
Date: Tue, 14 Oct 2014 16:18:02 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Scrub already running
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

In my openSUSE 13.1 system, I have / and /home on separate partitions
of a two disk btrfs raid1 array.

# btrfs fi sh
Label: system  uuid: 0b07b829-9a0e-44ab-89ee-14b36a45199e
        Total devices 2 FS bytes used 11.99GiB
        devid    1 size 40.00GiB used 16.04GiB path /dev/sda2
        devid    2 size 40.01GiB used 16.03GiB path /dev/sdb2

Label: home  uuid: 56884b1d-93ab-4db9-bc93-eff3833e91e1
        Total devices 2 FS bytes used 1.23TiB
        devid    1 size 2.69TiB used 1.24TiB path /dev/sda3
        devid    2 size 2.69TiB used 1.24TiB path /dev/sdb3

Btrfs v3.12+20131125

Once a week, I run a scrub on each of them, during the night. One
morning I found the computer locked, but on vt2 btrfs was churning out
error messages. Unfortunately, I can't remember what they said, and
didn't write them down (or photograph them).

SMART doesn't report any problems with the hardware.

When I run scrub on the root (system) partition now, I get

ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /'.
To see the status use 'btrfs scrub status [-d] /'.

but

# btrfs scrub cancel /
ERROR: scrub cancel failed on /: not running

and scrub status reports:

scrub status for 0b07b829-9a0e-44ab-89ee-14b36a45199e
	scrub started at Tue Sep 30 01:00:01 2014, running for 300 seconds
	total bytes scrubbed: 6.10GiB with 1284927 errors
	error details: read=1284925 super=2
	corrected errors: 192, uncorrectable errors: 1284729, unverified
errors: 0

This situation (scrub running persistently) survives reboots.

On the /home partition, everything is OK:

scrub status for 56884b1d-93ab-4db9-bc93-eff3833e91e1
	scrub started at Tue Oct 14 02:00:01 2014 and finished after 9972 seconds
	total bytes scrubbed: 2.47TiB with 0 errors

Should I worry about this (apart from the fact that I cannot scrub /)?
What can I do about it?

BTW. I know I'm running a rather old version of btrfs, but at the
moment I want to stick with the default kernel (3.11.10-21-desktop)
for openSUSE 13.1.

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-21-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.1
Uptime:  06:00am up 6 days 11:04, 5 users, load average: 0.01, 0.03, 0.05
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQ9PqcACgkQ0Sr7eZJrmU7c8wCgj3IQ+XehQ31K9tXqsx3zUD7H
bysAoJKG7++Su+xAPlvHftKABoVPpB5y
=Nxp3
-----END PGP SIGNATURE-----
