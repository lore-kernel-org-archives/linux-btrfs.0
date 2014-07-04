Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:57004
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaGDOqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 10:46:47 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id 0A60622AD3
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 15:38:30 +0100 (BST)
Message-ID: <53B6BC65.3080302@barrowhillfarm.org.uk>
Date: Fri, 04 Jul 2014 15:38:29 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: A question about subvolumes
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have a disc formatted as btrfs, on which is mounted /home.

/home/bob is a regular directory.

/home/bob/Documents is a btrfs subvolume

/home is btrfs root

If I do

# mv /home/bob /home/bob_original
# btrfs subvolume create /home/bob
# mv /home/bob_original/* /home/bob/
# rm /home/bob_original

will the original subvolume /home/bob/Documents survive this
operation, and will it now exist as a subvolume under the new
subvolume /home/bob?

I realise it's best to create subvolumes progressively from the top of
the filesystem tree, but this system originated as an ext4fs which was
migrated to btrfs, and some sensible things got missed in all the
excitement. ;-)

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-17-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.13.2
Uptime:  06:00am up 5 days 20:14, 3 users, load average: 0.00, 0.04, 0.08
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO2vGQACgkQ0Sr7eZJrmU6CPACgoLTFUxx68+z/H30C5wd/MPe4
6rcAoKpqxoETgkbgMd+MAbHEL7BWpLBs
=Cbmm
-----END PGP SIGNATURE-----
