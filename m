From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: [GIT PULL] Btrfs pull request
Date: Mon, 7 Nov 2011 15:49:36 +0600
Message-ID: <20111107154936.7c60be38@natsu>
References: <20111106183851.GA4339@shiny>
	<CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
	<4EB7A6CC.5030502@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qny5ElJ8_RS1iDUlV+0T7IK"; protocol="application/pgp-signature"
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB7A6CC.5030502@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/qny5ElJ8_RS1iDUlV+0T7IK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Nov 2011 10:37:16 +0100
Arne Jansen <sensille@gmx.net> wrote:

> >    I've got this:
> >=20
> > root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /dev/md126
> > ERROR: scrubbing /dev/md126 failed for device id 1 (Cannot allocate mem=
ory)
> > scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> > 	scrub started at Sun Nov  6 20:23:46 2011 and was aborted after 0 seco=
nds
> > 	total bytes scrubbed: 0.00 with 0 errors
> > root@Q45:/home/gelma/dev/prg/btrfs# ./btrfs scrub start -Br /home/
> > ERROR: scrubbing /home/ failed for device id 1 (Cannot allocate memory)
> > scrub canceled for 11827b37-1ba0-4b3e-883d-2746987724ca
> > 	scrub started at Sun Nov  6 20:25:01 2011 and was aborted after 0 seco=
nds
> > 	total bytes scrubbed: 0.00 with 0 errors
>=20
> On what platform are you running this? Can you please try this after
> a fresh boot? Maybe there's an allocation that can't be served with
> a badly fragmented memory.

If so, shouldn't there also be a corresponding dmesg warning about "Unable =
to allocate....", which would confirm or rule this out?
So before following the "did you try turning it off and on again" advice (a=
nd throwing away useful debug info), I'd suggest checking/saving dmesg firs=
t.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/qny5ElJ8_RS1iDUlV+0T7IK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk63qbAACgkQTLKSvz+PZwjl2gCfWCKNKJ4mNUz3BDNL3qSDIM9M
Od8AnA6wg8G4aNE/bD+ERsp9mVZHhXY3
=ljW8
-----END PGP SIGNATURE-----

--Sig_/qny5ElJ8_RS1iDUlV+0T7IK--
