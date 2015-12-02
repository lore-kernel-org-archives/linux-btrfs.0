Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54639 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbbLBXwH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 18:52:07 -0500
Date: Wed, 2 Dec 2015 23:51:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Russell Coker <russell@coker.com.au>, Chris Mason <clm@fb.com>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Bug/regression: Read-only mount not read-only
Message-ID: <20151202235155.GM8775@carfax.org.uk>
References: <20151128134634.GF24333@carfax.org.uk>
 <20151201190018.GD8918@ret.masoncoding.com>
 <565DEF65.4080900@redhat.com>
 <201512021725.32750.russell@coker.com.au>
 <565EB480.4010509@cn.fujitsu.com>
 <565EB878.9090501@cn.fujitsu.com>
 <565F2260.1080004@redhat.com>
 <565F2EF7.5000109@gmail.com>
 <565F753B.5020000@redhat.com>
 <565F8158.4090304@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xtmLDbP6TiKhntQb"
In-Reply-To: <565F8158.4090304@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xtmLDbP6TiKhntQb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03, 2015 at 07:40:08AM +0800, Qu Wenruo wrote:
>=20
>=20
> On 12/03/2015 06:48 AM, Eric Sandeen wrote:
> >On 12/2/15 11:48 AM, Austin S Hemmelgarn wrote:
> >
> >>On a side note, do either XFS or ext4 support removing the norecovery
> >>option from the mount flags through mount -o remount?  Even if they
> >>don't, that might be a nice feature to have in BTRFS if we can safely
> >>support it.
> >
> >It's not remountable today on xfs:
> >
> >         /* ro -> rw */
> >         if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
> >                 if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> >                         xfs_warn(mp,
> >                 "ro->rw transition prohibited on norecovery mount");
> >                         return -EINVAL;
> >                 }
> >
> >not sure about ext4.
> >
> >-Eric
>=20
> Not remountable is very good to implement it.
> Makes things super easy to do.
>=20
> Or we will need to add log replay for remount time.
>=20
> I'd like to implement it first for non-remountable case as a try.
> And for the option name, I prefer something like "notreereplay", but
> I don't consider it the best one yet....

   Thinking out loud...

no-log-replay, no-log, hard-ro, ro-log,
really-read-only-i-mean-it-this-time-honest-guvnor

Delete hyphens at your pleasure.

   Hugo.

--=20
Hugo Mills             | ORLY? I=C4! R'LYH!
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--xtmLDbP6TiKhntQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWX4QbAAoJEFheFHXiqx3kL04P+wV+Pe/PI7FkjVR/WfxmaWTC
oaGEmMqk6VbC9ZeGFTO1qLLWVBUfZCqBO1aKBuI9ZK1/VaFxJvqI7mTx18IS8z5n
XQkzgVwmkh0dSF45BNBXHC9boUZMRSMxNw5CiJRCH1GX2bllF8P5Lu5z66TDF7Z/
D3KZ7nCRLklPJVLhvFFeKT5QmtAaBgTZjqqSPq+aFXhHNMI3Sqw5REiKGzdCs9kT
I1ZgDtVoKY/wZVo097H1OLLnCkICIaGtmVljzMe3z4iIzeqNAaRalymnGfiMPhNz
l62ofeYlL/pWyd0AS9wtJwRl6GRyuVuxsoXX++yHSrvvRDLktpBX4ODRhasOWQbn
W1mTub+JrQt8uzUd4WlPIBboA8b7onETgUOLZg0CF5HLsXIv3urRctz30PbvzYLO
9MBOtF+O9OUkovPasGlGg6DXSgcZmZYzUv3Jy7pIlmtmRcGgyeDltdhMRecvgJOo
GAfa8aGUpYyxuxbYgHswMqWB2gn+X/5PVd5wPsVLC2KUh/ip7ETyPUbW9yYWceDX
gOsTy7uef+VyZH/eT6mI5A5PLKf7zNqtiQuDVPpH11OPiCZFO9NSc87uTXQTBeCU
wGki02oj0Ucrap+HzU/BPgaKPfFQa2fVzOwB4f0AS/9N9+awPNh/qGasg4hZKTx1
q8fMMrB6NyIhs6yWr9MU
=Xy3o
-----END PGP SIGNATURE-----

--xtmLDbP6TiKhntQb--
