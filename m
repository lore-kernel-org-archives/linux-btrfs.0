Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:40283 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027AbbIXOns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 10:43:48 -0400
Received: from localhost (localhost [127.0.0.1])
	by efeu.mur.at (Postfix) with ESMTP id D6EAB22275
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 16:34:16 +0200 (CEST)
Received: from efeu.mur.at ([127.0.0.1])
	by localhost (efeu.mur.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id T-j2aY0FjmcO for <linux-btrfs@vger.kernel.org>;
	Thu, 24 Sep 2015 16:34:16 +0200 (CEST)
Received: from [IPv6:2a02:3e0:201:0:6a68:68ff:fe00:79be] (unknown [IPv6:2a02:3e0:201:0:6a68:68ff:fe00:79be])
	by efeu.mur.at (Postfix) with ESMTPSA
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 16:34:16 +0200 (CEST)
Message-ID: <560409E7.5020500@mur.at>
Date: Thu, 24 Sep 2015 16:34:15 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: strange i/o errors with btrfs on raid/lvm
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CPgHwcJh8figDuCPqwrESeg7S3MpHs6SM"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CPgHwcJh8figDuCPqwrESeg7S3MpHs6SM
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi all,

We experience strange Input/output errors on our mail server (dovecot
pop/imap) that is using btrfs for its mailspool.

The server uses software RAID10.  The RAID is split into LVMs.  The
mailspool logical volume uses btrfs.  For several days now we see
Input/output errors on different files.  We could pinpoint the first
occurrence of the errors to a day when one of the RAID disks failed.
More precisely it all started while the RAID was rebuilding.

All affected files are files that are read/written frequently, like
dovecot index files, maildirsize and the likes.

Most files return to a useful state after some time (sometimes days,
sometimes minutes), which is why we didn't notice the errors right away.

We do snapshot and send/receive backup of the mailspool via cron.  A
file that is unreadable in the mailspool is totally OK on the backup
volume, even the latest 'copy' that must have been taken from an
otherwise unreadable file.  It is also possible to restore an unreadable
file from backup without Input/output error.  The file is fine and
useful then.

All disks taking part in the RAID show now SMART errors btw and a btrfs
scrub on the mailspool did not indicate any errors (I somehow expected
that).

All this runs on a virtual machine that uses kernel 4.1.3 (Debian build)
and btrfs-progs v4.0.

So finally I would ask what we can do to solve this problem?  I also
appreciate comments to the situation and of course hints to what is
going on.  This is over my head.

Thanks and cheers,
--=20
J.Hofm=C3=BCller

Nisiti    -    Abie Nathan, 1927-2008


--CPgHwcJh8figDuCPqwrESeg7S3MpHs6SM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlYECegACgkQkaXhaapqItmtIQEAnkagUuIomRFDbfw23Qx+VI+8
rxA9a5QkbfrkXsdqjxUBAJoUpSsXETs+IoyUBehHzeXR1pJ+MR+20HwiArXr2Q0O
=V1am
-----END PGP SIGNATURE-----

--CPgHwcJh8figDuCPqwrESeg7S3MpHs6SM--
