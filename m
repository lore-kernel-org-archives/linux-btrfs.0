Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:57359
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbaIJMe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 08:34:56 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 13D5D2205B
	for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 13:27:37 +0100 (BST)
Message-ID: <541043B8.7010601@barrowhillfarm.org.uk>
Date: Wed, 10 Sep 2014 13:27:36 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is it necessary to balance a btrfs raid1 array?
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have two 2TB disks formatted as a btrfs raid1 array, mirroring both
data and metadata. Last night I started

# btrfs filesystem balance <path>

and it is still running 18 hours later. This suggests that most stuff
only gets written to one physical device, which in turn suggests that
there is a risk of lost data if one physical device fails. Or is there
something clever about btrfs raid that I've missed? I've used linux
software raid (mdraid) before, and it appeared to write to both
devices simultaneously.

Is it safe to interrupt [^Z] the btrfs balancing process?

As a rough guide, how often should one perform

a) balance
b) defragment
c) scrub

on a btrfs raid setup?

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-21-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.0
Uptime:  06:00am up 5 days 15:04, 4 users, load average: 1.94, 2.21, 2.36
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQQQ6wACgkQ0Sr7eZJrmU5WlwCfd+OcuqFoz/vYSZEHg+5zNwlo
oTQAn2ZKhx4gCdQIy0gl9EBb8XXVJu1G
=2GSh
-----END PGP SIGNATURE-----
