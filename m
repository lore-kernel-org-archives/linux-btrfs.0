From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Raid0 and drive failure.
Date: Sat, 17 Sep 2011 12:36:40 +0100
Message-ID: <20110917113640.GA21530@carfax.org.uk>
References: <CAC_HdUrrEzUYp3K=ZAG9sQK=6totXmoy5FswGg=huTuxb6vtnw@mail.gmail.com>
 <CAAeznTp1eX8m--Mw-RFNY8VmU8O08kRNQeOmHAZo=cGNxvV7Tg@mail.gmail.com>
 <CAC_HdUrh+LhBfHTMKE8VTkuwEgJbcX2mBP3pJFYivk228-VctA@mail.gmail.com>
 <20110916151044.GF11031@carfax.org.uk>
 <CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Cc: Leonidas Spyropoulos <artafinde@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Henti Smith <henti@geekware.co.za>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAC_HdUrxn__yW5o024iMZXdJaO0Kge6eav8fhZrTCrhicmTx2A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 17, 2011 at 09:20:28AM +0200, Henti Smith wrote:
> On Fri, Sep 16, 2011 at 5:10 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Fri, Sep 16, 2011 at 05:06:03PM +0200, Henti Smith wrote:
> >> On Fri, Sep 16, 2011 at 4:49 PM, Leonidas Spyropoulos
> >> <artafinde@gmail.com> wrote:
> >> > On Sep 16, 2011 1:25 PM, "Henti Smith" <henti@geekware.co.za> wrote:
> >> >> This is likely a newbie question, but I just need to confirm. If you
> >> >> have 3 x 100GB drives in RAID0 and one drive dies this will result =
in
> >> >> total data loss correct?
> >> >>
> >> > Yes the data are lost. Read more on how raid 0 works.
> >>
> >> I have read on how raid 0 works, I was merely asking about the
> >> implementation of raid0 on btrfs.
> >>
> >> >> Is there no way to loose only the data that resides (even partly) on
> >> >> the missing drive but retain the rest of the data ?
> >>
> >> This is the more pertinent question, which it seem btrfs can't do curr=
ently.
> >
> > =A0 btrfs stripes its RAID-0 data across all available disks, so you'd
> > lose approximately 1/3 of the data for each file. In some cases, you
> > might get lucky and have a small file that resides entirely on the two
> > undamaged disks. In that case, it *might* be possible to recover your
> > data, but I think in general the amount of effort involved to get that
> > degree of recovery is probably far outweighted by the use of your
> > backups to restore all of the missing data...
> >
> > =A0 Hugo.
>=20
> Hi Hugo, Leonidas, everybody
>=20
> Sorry to keep this going.
>=20
> I've read some more on btrfs and one of the features listed as planned
> is "Object-level RAID"
> What will be the functional advantages of this as opposed to
> filesystem level RAID.

   It'll mean that you can specify that individual files should be
stored with different replication. (e.g. you could give the files
containing your latest novel RAID-6 replication, but your CD
collection RAID-0, all on the same filesystem).

   It'll use exactly the same mechanisms that already exist in btrfs
for replication, but will be configurable at finer levels of
granularity (at least subvolumes, possibly down to individual files).

> Would this not be the place to possibly add features to allow recovery
> of raid0 on an object level when a disk in the pool is lost, rather
> than loosing all data ?

   I'm confused. How would you expect to recover a file on a broken
RAID-0 when half (or 1/3, or whatever) of the data in it has gone away
for good? The file is lost and gone forever. If you care somewhat
about your data, use RAID-1, or -10 (or -5 or -6 when they arrive in
btrfs[1]). If you really care about your data, keep off-machine and
off-site backups -- RAID is not a backup.

   Hugo.

[1] Although I see the demon that picks my .sig quotes has found an
appropriate one again...

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- Great oxymorons of the world, no. 8: The Latest ---        =20
                          In Proven Technology                          =20

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOdIZIIKyzvlFcI40RAtNoAJ0cjW59t9qeCRlPy8zFbxJ3X1dTugCgr3fb
1n8F+6hhHHKORqc2Dhu/+pQ=
=51/Y
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
