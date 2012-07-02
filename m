Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.ru ([176.31.121.172]:44169 "EHLO len.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab2GBI6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jul 2012 04:58:25 -0400
Received: from home.romanrm.ru (unknown [IPv6:fd14:8086:1337::100])
	by len.romanrm.ru (Postfix) with ESMTPS id BC9E2204CB
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2012 08:52:17 +0000 (UTC)
Received: from natsu (unknown [IPv6:2001:470:d7f6::100])
	by home.romanrm.ru (Postfix) with ESMTPS id 26FD61FF4D
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2012 14:52:16 +0600 (YEKT)
Date: Mon, 2 Jul 2012 14:52:15 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: linux-btrfs@vger.kernel.org
Subject: Mounting subvolumes and FS-wide mount options?
Message-ID: <20120702145215.6817ba11@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RmcYeQ3UH/FOjtQUPZ1SNjh"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/RmcYeQ3UH/FOjtQUPZ1SNjh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Suppose I have in /etc/fstab:

/dev/sda2 /mnt/p2	btrfs	noatime		0	0
/dev/sda2 /home		btrfs	subvol=3D/home	0	0
/dev/sda2 /srv		btrfs	subvol=3D/srv	0	0

Now I want to add mount options like "space_cache" and "inode_cache". As far
as I understand these are FS-wide and not per subvolume. Also, changing them
once the FS has been mounted on a later subvolume mount is not allowed (?).

The question is, where to add them?

a) to the first mount in the list? Counting on the fact that it will be mou=
nted
first (but it might be not).

b) to all of them? But that's time consuming to duplicate identical options=
 on
each line and especially when editing them later.

Also, should I duplicate options like "noatime" and other generic options a=
lso
to all of the subvolume mounts?

I feel this is not obvious, not well-documented, and generally feels messy,=
 so
until now I just avoided mounting individual subvolumes altogether, instead
preferring to mount the FS itself once somewhere under /mnt, and then "mount
--bind" stuff to final places where I needed it.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/RmcYeQ3UH/FOjtQUPZ1SNjh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/xYT8ACgkQTLKSvz+PZwjt/wCeLwrgYuIxFGLU/a7m/UxNuafx
xS8AniiF4YfWBgD/4DBZQmNSX7z725l0
=l+Zk
-----END PGP SIGNATURE-----

--Sig_/RmcYeQ3UH/FOjtQUPZ1SNjh--
