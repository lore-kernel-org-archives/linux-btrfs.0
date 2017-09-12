Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:37092 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbdILDeV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 23:34:21 -0400
Received: by mail-lf0-f52.google.com with SMTP id 80so23071167lfy.4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 20:34:21 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>,
        linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com>
Date: Tue, 12 Sep 2017 06:34:15 +0300
MIME-Version: 1.0
In-Reply-To: <9208764.SjP1vfhOIA@pcsenen>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="4Sho1K9mxLxKVtSRv9Anh7xElDeSmoLAw"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4Sho1K9mxLxKVtSRv9Anh7xElDeSmoLAw
Content-Type: multipart/mixed; boundary="X411uKhgEk1m89R5daowVVaei5t5VVKrJ";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com>
Subject: Re: Storage and snapshots as historical yearly
References: <9208764.SjP1vfhOIA@pcsenen>
In-Reply-To: <9208764.SjP1vfhOIA@pcsenen>

--X411uKhgEk1m89R5daowVVaei5t5VVKrJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

11.09.2017 21:17, Sen=C3=A9n Vidal Blanco =D0=BF=D0=B8=D1=88=D0=B5=D1=82:=

> I am trying to implement a system that stores the data in a unit (A) wi=
th=20
> BTRFS format that is untouchable and that future files and folders crea=
ted or=20
> modified are stored in another physical unit (B) with BTRFS format.
> Each year the new files will be moved to store A and start over.
> =20
> The idea is that a duplicate of disk A can be made to keep it in a safe=
 place=20
> and that the files stored there can not be modified until the mixture o=
f (A) and=20
> (B) is made.
> =20

This can probably be achieved using seed device. Mark original device as
seed and all changes will go to another writable device, similar to
overlay; then remove seed bit from original device, "btrfs device remove
writable" device and it should relocate its content back. Rinse and repea=
t.



--X411uKhgEk1m89R5daowVVaei5t5VVKrJ--

--4Sho1K9mxLxKVtSRv9Anh7xElDeSmoLAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlm3VboACgkQR6LMutpd94xF8QCeObxrQkExj82l658XcVhHaPl9
i0YAoKXifqXuhC7329XBcyUdoZIhl+T1
=1sbc
-----END PGP SIGNATURE-----

--4Sho1K9mxLxKVtSRv9Anh7xElDeSmoLAw--
