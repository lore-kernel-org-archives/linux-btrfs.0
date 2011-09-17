From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Raid0 and drive failure.
Date: Sat, 17 Sep 2011 15:56:28 +0100
Message-ID: <20110917145628.GB21530@carfax.org.uk>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
 <CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
 <CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
 <20110916151044.GF11031@carfax.org.uk>
 <CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
 <20110917113640.GA21530@carfax.org.uk>
 <CAC_HdUrwBYgVMGiFA8dHM5X=QSksQ37iyEWSSyDipqoKKTYEsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Cc: Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Henti Smith <henti@geekware.co.za>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUrwBYgVMGiFA8dHM5X=QSksQ37iyEWSSyDipqoKKTYEsw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2011 at 04:10:44PM +0200, Henti Smith wrote:
> Hugo Mills wrote at some point:
> > =A0 I'm confused. How would you expect to recover a file on a broken
> > RAID-0 when half (or 1/3, or whatever) of the data in it has gone away
> > for good? The file is lost and gone forever. If you care somewhat
> > about your data, use RAID-1, or -10 (or -5 or -6 when they arrive in
> > btrfs[1]). If you really care about your data, keep off-machine and
> > off-site backups -- RAID is not a backup.
>=20
> That's just it, I don't care about my data that is lost when a drive
> fails, I care about loosing all the data when only one drive fails.
> Hence I'm trying to find out if there is a way to have fault tolerant
> drive pooling.
> After some more reading linear mode seems to offer the best options if
> you can only discard the files in the FS that islost when a drive is
> lost, but I'm still looking more into this.
>=20
> At it's core I'm looking for a way to do something similar windows
> drive extender that allows you to pool your drives without loosing all
> your data when one drive is lost.

   Aaaah, OK. Things become clearer.

   mkfs.btrfs -d single -m raid1 is probably what you want, then.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Quantum Mechanics: the dreams stuff is made of. ---        =20

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOdLUcIKyzvlFcI40RApSeAJ90d/KihPjNaJ9vMC8dLR0nJq8CUACgv/d/
uAJzUiWRPQwGC1sf2w5zoA8=
=GA2K
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
