From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Problems with set-default, home subvolume and snapshot
Date: Mon, 5 Sep 2011 11:30:33 +0100
Message-ID: <20110905103033.GL9907@carfax.org.uk>
References: <4E64A0C5.2060409@cyberphoria.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjamM5M9kpPM/bcu"
Cc: linux-btrfs@vger.kernel.org
To: =?iso-8859-1?Q?Bj=F6rn?= Kalkbrenner <terminar@cyberphoria.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E64A0C5.2060409@cyberphoria.org>
List-ID: <linux-btrfs.vger.kernel.org>


--xjamM5M9kpPM/bcu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 05, 2011 at 12:13:25PM +0200, Bj=F6rn Kalkbrenner wrote:
> Hi,
>=20
> i've got an interesting btrfs subvolume problem which i can't
> understand... Maybe someone here can give me a tip because i think
> that's only a user error...
>=20
> I had a root btrfs on / and made a subvolume some month ago for my home
> on /home (i think cwd was / and i used "btrfs subvolume create /home").
>=20
> On friday i wanted to try an update of my distribution, so i
> created a snapshot on /snapshots/20110902 (cwd was / and i entered
> "btrfs subvolume snapshot / /snapshots/20110902).
>=20
> Today i realized that my update failed, so i did
> "btrfs set-default 257 /" (257 is the id of the snapshot from friday)...
>=20
> When i rebooted, the trouble began. The mounted "home" subvolume was
> empty (even if mounted) and the new root from today which i used before
> trying the set-default seems to be lost. Ok, not the main problem...

   The original root is available by mounting with "subvolid=3D0" as a
mount option.

   Snapshots do not recurse into snapshots, so when you took a
snapshot of your original / (at the top level), you will have got a
snapshot of everything within / *except* /home (which is a
subvolume). /home should still be available as subvol=3D/home, or as
subvolid=3D256.

> The snapshot from friday was mounted correctly on boot as root.
>=20
> The directory /snapshots/20110902 is empty but it is still listed as
> subvolume. My "home" was also empty but still listed as subvolume.
> I tried to remove the subvolume, i tried to remove the directory, both
> not working.

   The directory you refer to is just a directory at this point, since
it's the copy inside /snapshots/20110902. Anything else would be
somewhat insane, as you'd have a directory/snapshot loop.

   The subvolume path it's referring to is not from your
currently-mounted /, but is instead from the (currently invisible)
top-level directory of your btrfs filesystem, which is only reachable
if you mount your filesystem somewhere with subvolid=3D0.

> Then i tried to
> "mount -o subvolumeid=3D256 /dev/mapper/root /home" (id of home subvol)
> and the content of my home is back...
>=20
>=20
> My questions are:
>=20
> 1. where is the "original" root from today morning before i did
> set-default? Lost?

   subvolid=3D0

> 2. why can't i do "mount -o subvolume=3Dhome /dev/mapper/root /home"
> anymore? To be more exact, i can, but why is it empty and why is it
> working when i enter the subvolume id?

   I don't know about this one, sorry.

> 3. I am now using the snapshot /snapshots/20110902 but what is
> /snapshots/20110902 now and why is it still listed? It's empty?

   It's an empty directory.

> 4. can i now delete the snapshots/20110902 or will that drop my current
> active working root?

   The latter -- it will drop your working root.

> 5. can i rename snapshots, e.g. the snapshots/20110902 or "home" to
> "home-20110905"?

   I believe that "mv" will accomplish this.

> 6. is my btrfs filesystem broken now and should i recreate the whole
> thing or is it safe to use it?

   It sounds like it's all working correctly, and there's nothing
wrong. (Well, bar the inability to mount with "subvol=3Dhome")

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- If it's December 1941 in Casablanca,  what time is it ---     =20
                              in New York?                              =20

--xjamM5M9kpPM/bcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOZKTJIKyzvlFcI40RAjfaAJ4jaLqztMg5H+01r5XO4zBw3w2abACfcsbv
+VylnNPi9m3TD16F7dzAj/4=
=xl6C
-----END PGP SIGNATURE-----

--xjamM5M9kpPM/bcu--
