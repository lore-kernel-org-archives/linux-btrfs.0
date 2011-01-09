From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 9 Jan 2011 18:30:30 +0000
Message-ID: <20110109183030.GA29572@carfax.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com>
 <201101061342.23991.CACook@quantum-sci.com>
 <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
 <201101071720.08298.hka@qbs.com.pl>
 <4D29A033.7000803@chandlerfamily.org.uk>
 <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
 <4D29D508.6080006@chandlerfamily.org.uk>
 <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Cc: Alan Chandler <alan@chandlerfamily.org.uk>,
	linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 09, 2011 at 09:59:46AM -0800, Freddie Cash wrote:
> On Sun, Jan 9, 2011 at 7:32 AM, Alan Chandler
> <alan@chandlerfamily.org.uk> wrote:
> > I think I start to get it now. =A0Its the fact that subvolumes can be
> > snapshotted etc without mounting them that is the difference. =A0I gues=
s I am
> > too used to thinking like LVM and I was thinking subvolumes where like =
an
> > LV. =A0They are, but not quite the same.
>=20
> Let see if I can match up the terminology and layers a bit:
>=20
> LVM Physical Volume =3D=3D Btrfs disk =3D=3D ZFS disk / vdevs
> LVM Volume Group =3D=3D Btrfs "filesystem" =3D=3D ZFS storage pool
> LVM Logical Volume =3D=3D Btrfs subvolume =3D=3D ZFS volume
> 'normal' filesysm =3D=3D Btrfs subvolume (when mounted) =3D=3D ZFS filesy=
stem
>=20
> Does that look about right?

   Kind of. The thing is that the way that btrfs works is massively
different to the way that LVM works (and probably massively different
to the way that ZFS works, but I don't know much about ZFS, so I can't
comment there). I think that trying to think of btrfs in LVM terms is
going to lead you to a large number of incorrect conclusions. It's
just not a good model to use.

> LVM: A physical volume is the lowest layer in LVM and they are
> combined into a volume group which is then split up into logical
> volumes, and formatted with a filesystem.
>=20
> Btrfs: A bunch of disks are "formatted" into a btrfs "filesystem"
> which is then split up into sub-volumes (sub-volumes are
> auto-formatted with a btrfs filesystem).

   No, subvolumes are a part of the whole filesystem. In btrfs, there
is only one filesystem. There are 6 main B-trees that store metadata
in btrfs (plus a couple of others). One of those is the "filesystem
tree" (or FS tree), which contains all the metadata associated with
the normal POSIX directory/file namespace (basically all the inode and
xattr data). When you create a subvolume, a new FS tree is created,
but it shares *all* of the other btrfs B-trees.

   There is only one filesystem, but there may be distinct namespaces
within that filesystem that can be mounted as if they were
filesystems. Think of it more like NFSv4, where there's one overall
namespace exported per server, but clients can mount subsections of
it.

> ZFS: A bunch of disks are combined into virtual devices, then combined
> into a ZFS storage pool, which can be split up into either volumes
> formatted with any filesystem, or ZFS filesystems.

   OK, this is _definitely_ not the way that btrfs works. As I said
above, a btrfs subvolume is just a namespace that is mountable in its
own right. It's *not* a block device, and can't be formatted with any
other filesystem.

> Just curious, why all the new terminology in btrfs for things that
> already existed?  And why are old terms overloaded with new meanings?
> I don't think I've seen a write-up about that anywhere (or I don't
> remember it if I have).

   The main awkward piece of btrfs terminology is the use of "RAID" to
describe btrfs's replication strategies. It's not RAID, and thinking
of it in RAID terms is causing lots of confusion. Most of the other
things in btrfs are, I think, named relatively sanely.

> Perhaps it's time to start looking at separating the btrfs pool
> creation tools out of mkfs (or renaming mkfs.btrfs), since you're
> really building a a storage pool, and not a filesystem.  It would
> prevent a lot of confusion with new users.  It's great that there's a
> separate btrfs tool for manipulating btrfs setups, but "mkfs.btrfs" is
> just wrong for creating the btrfs setup.

   I think this is the wrong thing to do. I hope my explanation above
helps.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Try everything once,  except incest and folk-dancing. ---     =20

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNKf7GIKyzvlFcI40RAqkgAKCW0scylmzqNqziqItSagy7Idm65gCeOjRX
xvRnJbo4NH2GiMqwE7xjw3c=
=PG7s
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
