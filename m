From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Single drive volume + second drive -> RAID1?
Date: Mon, 23 Jan 2012 09:25:15 +0000
Message-ID: <20120123092514.GA5531@carfax.org.uk>
References: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
 <CAEPoJ-34AmiaRpSCk4Whby4gDM6PSKYRyLHmG1my5_WFODaNrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Cc: linux-btrfs@vger.kernel.org
To: James <torpesco@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEPoJ-34AmiaRpSCk4Whby4gDM6PSKYRyLHmG1my5_WFODaNrQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2012 at 12:52:11AM -0800, James wrote:
> On Mon, Jan 23, 2012 at 12:36 AM, James <torpesco@gmail.com> wrote:
> > I bought one drive to replace the failing one. I'd like to end up with
> > RAID1. Back in July I set up a server for my brother and (unless I'm
> > forgetting a different path we ended up taking), I thought what I did
> > was:
> > =A01. mkfs.btrfs on a single drive but tell it to use RAID1
> > =A02. copy data on
> > =A03. once the second drive for the RAID1 was available, add it to the
> > volume and rebalance (or something)

   Why not just create the filesystem as RAID-1 in the first place?

# mkfs.btrfs -d raid1 -m raid1 /dev/sda1 /dev/sdb1

   Then you can restore from your backups. You do have backups, right?
(Remember, this is a filesystem still marked as "experimental").

> I must be mixing memories. Maybe that's what I did to end up with the
> volume that turned out to be RAID0 for the data. On a whim, even
> thought btrfs filesystem df /path showed no indications of RAID after
> adding the second drive, I issued a balance command. I ran 'df' right
> away and now see the results I don't want -- RAID0 data, RAID1
> metadata. Ctrl-C doesn't seem to be aborting the balance.

   Yes, balances are not interruptible right now. The restriper
patches (in 3.3-rc1) will allow you to monitor balance progress and
stop/restart them. They will also allow you to change RAID levels on
the fly, which is what you were asking for in the first place.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There's an infinite number of monkeys outside who want to ---   =20
               talk to us about this new script for Hamlet              =20
                           they've worked out!                          =20

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPHSd6IKyzvlFcI40RArfSAJ9D+4XCNPsLB4S8a61iGV0siEp2zwCfUOyd
QdecUjlVDQs9nseUA3ALNcE=
=6JUf
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
