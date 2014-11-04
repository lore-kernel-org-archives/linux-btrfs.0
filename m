Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38440 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751682AbaKDUBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 15:01:23 -0500
Date: Tue, 4 Nov 2014 15:01:21 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: LuVar <luvar@plaintext.sk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs deduplication and linux cache management
Message-ID: <20141104200121.GO17395@hungrycats.org>
References: <20141030160004.GK17395@hungrycats.org>
 <1959259002.1771415023751082.JavaMail.root@shiva>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
In-Reply-To: <1959259002.1771415023751082.JavaMail.root@shiva>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 03:09:11PM +0100, LuVar wrote:
> Thanks for nice and "replicate at home yourself" example. On my machine i=
t is behaving precisely like in your:
>=20
> <code>
> root@blackdawn:/home/luvar# sync; sysctl vm.drop_caches=3D1
> vm.drop_caches =3D 1
> root@blackdawn:/home/luvar# time cat /home/luvar/programs/adt-bundle-linu=
x/sdk/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null=
=20
> real    0m6.768s
> user    0m0.016s
> sys     0m0.599s
>=20
> root@blackdawn:/home/luvar# time cat /home/luvar/programs/android-sdk-lin=
ux/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null=20
> real    0m5.259s
> user    0m0.018s
> sys     0m0.695s
>=20
> root@blackdawn:/home/luvar# time cat /home/luvar/programs/adt-bundle-linu=
x/sdk/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null=
=20
> real    0m0.701s
> user    0m0.014s
> sys     0m0.288s
>=20
> root@blackdawn:/home/luvar# time cat /home/luvar/programs/android-sdk-lin=
ux/system-images/android-L/default/armeabi-v7a/userdata.img > /dev/null
> real    0m0.286s
> user    0m0.013s
> sys     0m0.272s
> </code>
>=20
> If you would mind asking, is there any plan to optimize this
> behaviour? I know that btrfs is not like ZFS (whole system from
> blockdevice, through cache, to VFS), so vould be possible to implement
> such optimization without major patch in linux block cache/VFS cache?

I'd like to know this too.  I think not any time soon though.

AIUI (I'm not really an expert here), the VFS cache is keyed on tuples of
(device:inode, offset), so it has no way to cope with aliasing the same
physical blocks through distinct inodes.  It would have to learn about
reference counting (so multiple inodes can refer to shared blocks, one
inode can refer to the same blocks twice, etc) and copy-on-write (so we
can modify just one share of a shared-extent cache page).  For compressed
data caching, the filesystem would be volunteering references to blocks
that were not asked for (e.g.  unread portions of compressed extents).

It's not impossible to make those changes to the VFS cache, but the
only filesystem on mainline Linux that would benefit is btrfs (ZFS is
not on mainline Linux, the ZFS maintainers probably prefer to use their
own cache layer anyway, and nobody else shares extents between files).
For filesystems that don't share extents, adding the necessary stuff to
VFS is a lot of extra overhead they will never use.

Back in the day, the Linux cache used to use tuples of (device,
block_number), but this approach doesn't work on non-block filesystems
like NFS, so it was dropped in favor of the inode+offset caching.
A block-based scheme would handle shared extents but not compressed ones
(e.g. you've got a 4K cacheable page that was compressed to 312 bytes
somewhere in the middle of a 57K compressed data extent...what's that
page's block number, again?).

> Thanks, have a nice day,
> --
> LuVar
>=20
>=20
> ----- "Zygo Blaxell" <zblaxell@furryterror.org> wrote:
>=20
> > On Thu, Oct 30, 2014 at 10:26:07AM +0100, luvar@plaintext.sk wrote:
> > > Hi,
> > > I want to ask, if deduplicated file content will be cached in linux
> > kernel just once for two deduplicated files.
> > >=20
> > > To explain in deep:
> > >  - I use btrfs for whole system with few subvolumes with some
> > compression on some subvolumes.
> > >  - I have two directories with eclipse SDK with slightly differences
> > (same version, different config)
> > >  - I assume that given directories is deduplicated and so two
> > eclipse installations take place on hdd like one would (in rough
> > estimation)
> > >  - I will start one of given eclipse
> > >  - linux kernel will cache all opened files during start of eclipse
> > (I have enough free ram)
> > >  - I am just happy stupid linux user:
> > >     1. will kernel cache file content after decompression? (I think
> > yes)
> > >     2. cached data will be in VFS layer or in block device layer?
> >=20
> > My guess based on behavior is the VFS layer.  See below.
> >=20
> > >  - When I will lunch second eclipse (different from first, but
> > deduplicated from first) after first one:
> > >     1. will second start require less data to be read from HDD?
> >=20
> > No.
> >=20
> > >     2. will be metadata for second instance read from hdd? (I asume
> > yes)
> >=20
> > Yes (how could it not?).
> >=20
> > >     3. will be actual data read second time? (I hope not)
> >=20
> > Unfortunately, yes.
> >=20
> > This is my test:
> >=20
> > 1.  Create a file full of compressible data that is big enough to
> > take
> > a few seconds to read from disk, but not too big to fit in RAM:
> >=20
> > 	yes $(date) | head -c 500m > a
> >=20
> > 2.  Create a "deduplicated" (shared extent) copy of same:
> >=20
> > 	cp --reflink=3Dalways a b
> >=20
> > 	(use filefrag -v to verify both files have same physical extents)
> >=20
> > 3.  Drop caches
> >=20
> > 	sync; sysctl vm.drop_caches=3D1
> >=20
> > 4.  Time reading both files with cold and hot cache:
> >=20
> > 	time cat a > /dev/null
> > 	time cat b > /dev/null
> > 	time cat a > /dev/null
> > 	time cat b > /dev/null
> >=20
> > Ideally, the first 'cat a' would load the file back from disk, so it
> > will take a long time, and the other three would be very fast as the
> > shared extent data would already be in RAM.
> >=20
> > That is what happens on 3.17.1:
> >=20
> > 	time cat a > /dev/null
> > 	real    0m18.870s
> > 	user    0m0.017s
> > 	sys     0m3.432s
> >=20
> > 	time cat b > /dev/null
> > 	real    0m16.931s
> > 	user    0m0.007s
> > 	sys     0m3.357s
> >=20
> > 	time cat a > /dev/null
> > 	real    0m0.141s
> > 	user    0m0.001s
> > 	sys     0m0.136s
> >=20
> > 	time cat b > /dev/null
> > 	real    0m0.121s
> > 	user    0m0.002s
> > 	sys     0m0.116s
> >=20
> > Above we see that reading 'b' the first time takes almost as long as
> > 'a'.
> > The second reads are cached, so they finish two orders of magnitude
> > faster.
> >=20
> > That suggests that deduplicated extents are read and cached as
> > entirely
> > separate copies of the data.  The sys time for the first read of 'b'
> > would imply separate decompression as well.
> >=20
> > Compare the above result with a hardlink, which might behave more
> > like
> > what we expect:
> >=20
> > 	rm -f b
> > 	ln a b
> > 	sync; sysctl vm.drop_caches=3D1
> >=20
> > 	time cat a > /dev/null
> > 	real    0m20.262s
> > 	user    0m0.010s
> > 	sys     0m3.376s
> >=20
> > 	time cat b > /dev/null
> > 	real    0m0.125s
> > 	user    0m0.003s
> > 	sys     0m0.120s
> >=20
> > 	time cat a > /dev/null
> > 	real    0m0.103s
> > 	user    0m0.004s
> > 	sys     0m0.097s
> >=20
> > 	time cat b > /dev/null
> > 	real    0m0.098s
> > 	user    0m0.002s
> > 	sys     0m0.091s
> >=20
> > Above we clearly see that we read 'a' from disk only once, and use
> > the
> > cache three times.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRZMJEACgkQgfmLGlazG5ygDACg2rzvBNXyVAUw3oiBGDCHZ3Z+
b4EAn3Gwrx8NudSI1Y9Jv/e/IJVRUSjH
=RbrE
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
