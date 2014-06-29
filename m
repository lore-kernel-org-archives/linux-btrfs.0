Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56707 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbaF2RyJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 13:54:09 -0400
Received: from [192.168.1.72] (unknown [87.81.212.47])
	by mail.messagingengine.com (Postfix) with ESMTPA id A5A8A6800BC
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 13:54:07 -0400 (EDT)
Message-ID: <1404064438.2907.3.camel@s-Air>
Subject: btrfs send/receive test failing
From: Sam Bull <sam.hacking@sent.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 29 Jun 2014 18:53:58 +0100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fMVCxXzpVpNbjfXqFsWM"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-fMVCxXzpVpNbjfXqFsWM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm trying out the btrfs send|receive command as shown on the
incremental backup wiki page, but the command is failing. I've tried it
with sudo as it had not permitted errors, but still no luck. The output
is:

        s@s-Air:~$ btrfs send /home/BACKUP | btrfs receive /media/s/99b1c51=
d-b3bb-4179-a621-9d5a27acc385/Air
        ERROR: failed to determine mount point for /home/BACKUP
        ERROR: failed to open destination directory /media/s/99b1c51d-b3bb-=
4179-a621-9d5a27acc385/Air. Operation not permitted
       =20
        s@s-Air:~$ sudo btrfs send /home/BACKUP | btrfs receive /media/s/99=
b1c51d-b3bb-4179-a621-9d5a27acc385/Air
        ERROR: failed to open destination directory /media/s/99b1c51d-b3bb-=
4179-a621-9d5a27acc385/Air. Operation not permitted
        [sudo] password for s:=20
        At subvol /home/BACKUP
        ERROR: open @home/BACKUP failed. No such file or directory
       =20
        s@s-Air:~$ sudo btrfs send /home/BACKUP | sudo btrfs receive /media=
/s/99b1c51d-b3bb-4179-a621-9d5a27acc385/Air
        At subvol /home/BACKUP
        ERROR: open @home/BACKUP failed. No such file or directory

--=-fMVCxXzpVpNbjfXqFsWM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEABECAAYFAlOwUroACgkQX+kozZYmzisKOACguKMbt4Dd68v6PZW2e9fZKBor
tmoAoKf/DdZroQDfwSHr8pLR8czzH4Cq
=UG3s
-----END PGP SIGNATURE-----

--=-fMVCxXzpVpNbjfXqFsWM--

