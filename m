Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.automatix.de ([213.131.255.221]:43365 "EHLO
	mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbbAZMZp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 07:25:45 -0500
Received: from [192.168.11.16] (vpn1 [213.131.255.219])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: jojo@automatix.de)
	by mail.automatix.de (Postfix) with ESMTPSA id D4C7C600A6
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 13:16:33 +0100 (CET)
Message-ID: <54C63021.8000502@automatix.de>
Date: Mon, 26 Jan 2015 13:16:33 +0100
From: Juergen Sauer <juergen.sauer@automatix.de>
Reply-To: service@automatix.de
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Bug Report Data Rescue: btrfs send ... btrfs set prop on linux 3.18-2
 on Arch Linux
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Moin,

this weekend a ssd disk got an problem.

No Problem, I thought... but real word acts sometime other the you think :)

1. Szenario
I got an media Error on a ssd disk. So, I think trimming the whole
device may work.
Mounting the btrfs in rw is not possible anymore. Because the system is
going to write on damaged blocks.

Mounting ro is possible.
So I tried to
	mount -o ro,subvol=/ /dev/sdl1 /mnt -> worked.

The Try to send the ro-mounted subvol "rootfs", which I want to recover
did not work:
	btrfs send -f /srv/backup/rootfs.btrfs rootfs
	ERROR: /mnt/rootfs is not read-only

The try to change the ro-flag
	btrfs prop set rootfs ro true
	ERROR: failed to set flags for rootfs. Read-only file system

was impossible.

I think this is an Bug in btrfs send, not to check if an btrfs
filesystem is mounted ro for refusing working.

It may be much more easier to recover damaged systems, if such annoying
thngs would not occour.

mit freundlichen Grüßen
Jürgen Sauer
- -- 
Jürgen Sauer - automatiX GmbH,
+49-4209-4699, juergen.sauer@automatix.de
Geschäftsführer: Jürgen Sauer,
Gerichtstand: Amtsgericht Walsrode • HRB 120986
Ust-Id: DE191468481 • St.Nr.: 36/211/08000
GPG Public Key zur Signaturprüfung:
http://www.automatix.de/juergen_sauer_publickey.gpg
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlTGMCEACgkQW7UKI9EqarG8QwCgu80ihnBxKrnjy4rzzbrz6Riu
wS0AoIEiNicS/6Zz12ct7T4fZncW5xsP
=3PPi
-----END PGP SIGNATURE-----
