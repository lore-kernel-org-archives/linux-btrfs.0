Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:60322 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbcEKTBK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 15:01:10 -0400
Date: Thu, 12 May 2016 00:01:03 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Richard Lochner <lochner@clone1.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS Data at Rest File Corruption
Message-ID: <20160512000103.7ba65149@natsu>
In-Reply-To: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/VnPVj+aWi/DBbGtyH=wnNWC"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/VnPVj+aWi/DBbGtyH=wnNWC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 May 2016 13:36:23 -0500
Richard Lochner <lochner@clone1.com> wrote:

> Recently, a scrub returned an unrecoverable error on that file.
> Again, the file has not been modified since it was originally copied
> and has the time stamp from December.  Furthermore, SMART tests (long)
> for both drives do not indicate any errors (Current_Pending_Sector or
> otherwise).
>=20
> I should note that the system does not have ECC memory.

> [2027323.705035] BTRFS warning (device sdc1): checksum error at
> logical 3037444042752 on dev /dev/sdc1, sector 4988750584, root 259,
> inode 1437377, offset 75754369024, length 4096, links 1 (path:
> Rick/sda4.img)
> [2027323.705056] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr 0,
> rd 13, flush 0, corrupt 3, gen 0
> [2027323.718869] BTRFS error (device sdc1): unable to fixup (regular)
> error at logical 3037444042752 on dev /dev/sdc1

I wonder, did you try rebooting the system after getting this? And if you g=
et
the same error also after a reboot, check if the sector/offset numbers are =
the
same. That way you could at least rule out any kind of transient (RAM?) err=
ors.

--=20
With respect,
Roman

--Sig_/VnPVj+aWi/DBbGtyH=wnNWC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlczgXIACgkQTLKSvz+PZwiy4wCfc/YDk8r7h/TW3iVW2CwKRtew
q1QAn3Up4GQ9WzlbKFGSgGVkSF1p2D+M
=n5J0
-----END PGP SIGNATURE-----

--Sig_/VnPVj+aWi/DBbGtyH=wnNWC--
