From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: too many files open
Date: Wed, 5 Oct 2011 21:31:19 +0600
Message-ID: <20111005213119.3672fdd9@natsu>
References: <4E8C76AB.6080401@webstarts.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NZiTzkpC6.lpTXGFFbwhM4G"; protocol="application/pgp-signature"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E8C76AB.6080401@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/NZiTzkpC6.lpTXGFFbwhM4G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 05 Oct 2011 11:24:27 -0400
Jim <jim@webstarts.com> wrote:

> Good morning Btrfs list,
> I have been loading a btrfs file system via a script rsyncing data files=
=20
> from an nfs mounted directory.  The script runs well but after several=20
> days (moving about 10TB) rsync reports that it is sending the file list=20
> but stops moving data because btrfs balks saying too many files open.  A=
=20
> simple umount/mount fixes the problem.  What am I flushing when I=20
> remount that would affect this, and is there a way to do this without a=20
> remount.  Once again thanks for any assistance.

Are you sure it's a btrfs problem? Check "ulimit -n", see "help ulimit" (as=
suming you use bash).

--=20
With respect,
Roman

--Sig_/NZiTzkpC6.lpTXGFFbwhM4G
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6MeEcACgkQTLKSvz+PZwgr+wCff9bvALgqZ60YpFiFInjUVqcz
mz4An0JtYOgrposn2Jl0ryZZpexDRvrz
=geUX
-----END PGP SIGNATURE-----

--Sig_/NZiTzkpC6.lpTXGFFbwhM4G--
