From: Paddy Steed <jarktasaa@gmail.com>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 17:17:51 +0000
Message-ID: <1292260671.11248.609.camel@paddy-desktop>
References: <1292174654.11248.10.camel@paddy-desktop>
	 <4D05630E.7070809@bobich.net>
Reply-To: jarktasaa@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jZNp1n2PCiSR/B59K+Sl"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05630E.7070809@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>


--=-jZNp1n2PCiSR/B59K+Sl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Thank you for all your replies.
On Mon, 2010-12-13 at 00:04 +0000, Gordan Bobic wrote:
> On 12/12/2010 17:24, Paddy Steed wrote:
> > In a few weeks parts for my new computer will be arriving. The storage
> > will be a 128GB SSD. A few weeks after that I will order three large
> > disks for a RAID array. I understand that BTRFS RAID 5 support will be
> > available shortly. What is the best possible way for me to get the
> > highest performance out of this setup. I know of the option to optimize
> > for SSD's
>=20
> BTRFS is hardly the best option for SSDs. I typically use ext4 without a=
=20
> journal on SSDs, or ext2 if that is not available. Journalling causes=20
> more writes to hit the disk, which wears out flash faster. Plus, SSDs=20
> typically have much slower writes than reads, so avoiding writes is a=20
> good thing. AFAIK there is no way to disable journaling on BTRFS.

My write speed is similar to the read speed (OCZ Vertex 128GB) and it
also comes with a waranty that runs out after the drive will be
obsolete. Using up flash cycles is not an issue for me.

> > but wont that affect all the drives in the array, not to
> > mention having the SSD in the raid array will make the usable size much
> > smaller as RAID 5 goes by the smallest disk.
>=20
> If you are talking about BTRFS' parity RAID implementation, it is hard=
=20
> to comment in any way on it before it has actually been implemented.=20
> Especially if you are looking for something stable for production use,=
=20
> you should probably avoid features that immature.

I would take images until I felt it was stable every day. I spoke to
`cmasion' who has now finished fsck and is working on RAID 5 fully.

> > Is there a way to use it as
> > a cache the works even on power down.
>=20
> You want to use the SSD as a _write_ cache? That doesn't sound too=20
> sensible at all.

As previously stated, wear is not an issue.

> What you are looking for is hierarchical/tiered storage. I am not aware=
=20
> of existance of such a thing for Linux. BTRFS has no feature for it. You=
=20
> might be able to cobble up a solution that uses aufs or mhddfs (both=20
> fuse based) with some cron jobs to shift most recently used files to=20
> your SSD, but the fuse overheads will probably limit the usefulness of=
=20
> this approach.
>=20
> > My current plan is to have
> > the /tmp directory in RAM on tmpfs
>=20
> Ideally, quite a lot should really be on tmpfs, in addition to /tmp and=
=20
> /var/tmp.
> Have a look at my patches here:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D223722
>=20
> My motivation for this was mainly to improve performance on slow flash=
=20
> (when running off a USB stick or an SD card), but it also removes the=20
> most write-heavy things off the flash and into RAM. Less flash wear and=
=20
> more speed.
>=20
> If you are putting a lot onto tmpfs, you may also want to look at the=20
> compcache project which provides a compressed swap RAM disk. Much faster=
=20
> than actual swap - to the point where it actually makes swapping feasible=
.
>=20
> > the /boot directory on a dedicated
> > partition on the SSD along with a 12GB swap partition also on the SSD
> > with the rest of the space (on the SSD) available as a cache.
>=20
> Swap on SSD is generally a bad idea. If your machine starts swapping=20
> it'll grind to a halt anyway, regardless of whether it's swapping to=20
> SSD, and heavy swapping to SSD will just kill the flash prematurely.
>=20
> > The three
> > mechanical hard drives will be on a RAID 5 array using BTRFS. Can anyon=
e
> > suggest any improvements to my plan and also how to implement the cache=
?
>=20
> A very "soft" solution using aufs and cron jobs for moving things with=
=20
> the most recent atime to the SSD is probably as good as it's going to=20
> get at the moment, but bear in mind that fuse overheads will probably=20
> offset any performance benefit you gain from the SSD. You could get=20
> clever and instead of just using atime set up inotify logging and put=20
> the most frequently (as opposed to most recently) accessed files onto=20
> your SSD. This would, in theory, give you more benefit. You also have to=
=20
> bear in mind that the most frequently accessed files will be cached in=
=20
> RAM anyway, so your pre-caching onto SSD is only really going to be=20
> relevant when your working set size is considerably bigger than your RAM=
=20
> - at which point your performance is going to take a significant=20
> nosedive anyway (especially if you then hit a fuse file system).
>=20
> In either case, you should not put the frequently written files onto=20
> flash (recent mtime).
>=20
> Also note that RAID5 is potentially very slow on writes, especially=20
> small writes. It is also unsuitable for arrays over about 4TB (usable)=
=20
> in size for disk reliability reasons.
>=20
> Gordan

So, no-one has any idea's on how to implement the cache. Would making it
all swap work, does to OS cache files in swap?

--=-jZNp1n2PCiSR/B59K+Sl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJNBlU5AAoJEDU7InHYx9g8VNoH/RLSqxLdPMdRlnQTWWWd14wo
3IQU0snIDjqBurcN8J/l/UNhZI0a2uZ7aXF4Q8ZYhm/K/uP8fTWfWIDGrZJ8ruz3
igPSgtqJ+/aHUcyqK4F2CSmZK3W3q3BX/VdLYTJc66Q6wY7BeGRZWSCgaDYrNPF/
/dwMngjfNOAcEGvyJwfUDK7Mso7WO6ZVfB2Wl6tecFKa/KtZRnIYVFLjPGn3/dM2
HgWNrWmH1dT88poMNyOOHgaemX9JeDDIVDM5DyiFwwDpdk9EvyaaeQEcIxeUj2lZ
MR68/35YC/84JJJgfBeASVYJx4jKu1WjctWEcNGf0eVXVg2zbMx6EQ9hiJ0rmHk=
=9UWY
-----END PGP SIGNATURE-----

--=-jZNp1n2PCiSR/B59K+Sl--

