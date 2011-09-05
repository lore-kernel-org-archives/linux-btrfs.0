From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Mon, 5 Sep 2011 20:20:00 +0600
Message-ID: <20110905202000.4c539297@natsu>
References: <4E64D3D5.7020407@petaramesh.org>
	<20110905140023.GP9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gcvx.H85=.nkDYQt_JVx+eq"; protocol="application/pgp-signature"
Cc: =?UTF-8?B?U3fDom1p?= Petaramesh <swami@petaramesh.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905140023.GP9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/Gcvx.H85=.nkDYQt_JVx+eq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 5 Sep 2011 15:00:23 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:
> >=20
> > BTRFS machine took 20 HOURS so far, still counting (ETA 15 minutes left=
).
> >=20
> > Wow. Impressive.
>=20
>    That's because dpkg is known for using (f)sync very heavily.  btrfs
> honours the sync request in all cases

I don't think it's *just* that.

I had the same problem, recently upgrading Debian from Stable to Testing, i=
t was taking more than 24 hours. I stopped the upgrade, then resumed it thi=
s time via eatmydata, and it proceeded perhaps two orders of magnitude fast=
er than before, finishing the remaining packages in 5 minutes or so.

Problem is, even when I stopped the upgrade and waited a considerable time,=
 each 'sync' was still taking 5-7 seconds. No other disk activity in the sy=
stem, no snapshot creation/deletion/cleanup going on either, just multiple =
consecutive syncs:

rm@rm:~$ time sync

real	0m4.772s
user	0m0.000s
sys	0m0.480s
rm@rm:~$ time sync

real	0m6.831s
user	0m0.000s
sys	0m0.472s
rm@rm:~$ time sync

real	0m8.069s
user	0m0.000s
sys	0m0.468s
rm@rm:~$ time sync

real	0m6.675s
user	0m0.000s
sys	0m0.464s
rm@rm:~$ time sync

real	0m4.293s
user	0m0.000s
sys	0m0.464s
rm@rm:~$ time sync

real	0m4.230s
user	0m0.000s
sys	0m0.472s
rm@rm:~$ time sync

real	0m6.924s
user	0m0.000s
sys	0m0.464s

To be fair, this was on the 2.6.39.2 kernel, and the performance seems to b=
e somewhat better on 3.0 (though I didn't do tests like this one or any sig=
nificant dpkg operations on it yet).

--=20
With respect,
Roman

--Sig_/Gcvx.H85=.nkDYQt_JVx+eq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5k2pAACgkQTLKSvz+PZwj/hQCaAl8trEpePslkwUzAVQDCsAKP
DLIAnRE9x+BcaDdgzF8Q/O/ATPDxhVuM
=fKnd
-----END PGP SIGNATURE-----

--Sig_/Gcvx.H85=.nkDYQt_JVx+eq--
