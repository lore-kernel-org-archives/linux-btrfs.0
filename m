From: paran@lysator.liu.se (=?utf-8?Q?P=C3=A4r?= Andersson)
Subject: Re: btrfs-vol -b endless loop
Date: Fri, 12 Feb 2010 23:46:54 +0100
Message-ID: <87zl3ehy1t.fsf@nsc.liu.se>
References: <87636ej6t3.fsf@nsc.liu.se>
	<3d0408631002031859r69ac7ef8r248ffab3a2774b6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: "Yan\, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408631002031859r69ac7ef8r248ffab3a2774b6a@mail.gmail.com>
	(Zheng Yan's message of "Thu, 4 Feb 2010 10:59:16 +0800")
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Yan, Zheng " <yanzheng@21cn.com> writes:

> The loop is due to fragments of free space. I'm working on make 'btrfs-vo=
l -b'
> return -ENOSPC in this case.

If I remember correctly the filesystem had 3G free space according to
df, which I know is not reliable on btrfs.

After removing one 540M file 'btrfs-vol -b' ran successfully.

Thanks,
P=C3=A4r

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt12l8ACgkQyi5LJcueYEvW6ACgoaRVXs25rjMAGKJwTOxkzD1k
ob8AnjZJhf8N4w0Tvxqm16S+A6WAb90t
=A7fK
-----END PGP SIGNATURE-----
--=-=-=--
