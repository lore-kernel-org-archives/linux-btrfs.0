Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:38934 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751701AbbDMEE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 00:04:56 -0400
Date: Mon, 13 Apr 2015 00:04:36 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Gian-Carlo Pascutto <gcp@sjeng.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Big disk space usage difference, even after defrag, on identical
 data
Message-ID: <20150413040436.GB4711@hungrycats.org>
References: <55297D36.8090808@sjeng.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
In-Reply-To: <55297D36.8090808@sjeng.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 11, 2015 at 09:59:50PM +0200, Gian-Carlo Pascutto wrote:
> Linux mozwell 3.19.0-trunk-amd64 #1 SMP Debian 3.19.1-1~exp1
> (2015-03-08) x86_64 GNU/Linux
> btrfs-progs v3.19.1
>=20
> I have a btrfs volume that's been in use for a week or 2. It has about
> ~560G of uncompressible data (video files, tar.xz, git repos, ...) and
> ~200G of data that compresses 2:1 with LZO (PostgreSQL db).
>=20
> It's split into 2 subvolumes:
> ID 257 gen 6550 top level 5 path @db
> ID 258 gen 6590 top level 5 path @large
>=20
> and mounted like this:
> /dev/sdc /srv/db btrfs rw,noatime,compress=3Dlzo,space_cache 0 0
> /dev/sdc /srv/large btrfs rw,noatime,compress=3Dlzo,space_cache 0 0
>=20
> du -skh /srv
> 768G    /srv
>=20
> df -h
> /dev/sdc        1.4T  754G  641G  55% /srv/db
> /dev/sdc        1.4T  754G  641G  55% /srv/large
>=20
> btrfs fi df /srv/large
> Data, single: total=3D808.01GiB, used=3D749.36GiB
> System, DUP: total=3D8.00MiB, used=3D112.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, DUP: total=3D3.50GiB, used=3D1.87GiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> So that's a bit bigger than perhaps expected (~750G instead of
> ~660G+metadata). I thought it might've been related to compress bailing
> out too easily, but I've done a
> btrfs fi defragment -r -v -clzo /srv/db /srv/large
> and this doesn't change anything.
>=20
> I recently copied this data to a new, bigger disk, and the result looks
> worrying:
>=20
> mount options:
> /dev/sdd /mnt/large btrfs rw,noatime,compress=3Dlzo,space_cache 0 0
> /dev/sdd /mnt/db btrfs rw,noatime,compress=3Dlzo,space_cache 0 0
>=20
> btrfs fi df
> Data, single: total=3D684.00GiB, used=3D683.00GiB
> System, DUP: total=3D8.00MiB, used=3D96.00KiB
> System, single: total=3D4.00MiB, used=3D0.00B
> Metadata, DUP: total=3D3.50GiB, used=3D2.04GiB
> Metadata, single: total=3D8.00MiB, used=3D0.00B
> GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>=20
> df
> /dev/sdd        3.7T  688G  3.0T  19% /mnt/large
> /dev/sdd        3.7T  688G  3.0T  19% /mnt/db
>=20
> du
> 767G    /mnt
>=20
> That's a 66G difference for the same data with the same compress option.
> The used size here is much more in line with what I'd have expected
> given the nature of the data.
>=20
> I would think that compression differences or things like fragmentation
> or bookending for modified files shouldn't affect this, because the
> first filesystem has been defragmented/recompressed and didn't shrink.
>=20
> So what can explain this? Where did the 66G go?

There are a few places:  the kernel may have decided your files are not
compressible and disabled compression on them (some older kernels did
this with great enthusiasm); your files might have preallocated space
=66rom the fallocate system call (which disables compression and allocates
contiguous space, so defrag will not touch it).   'filefrag -v' can
tell you if this is happening to your files.

In practice database files take about double the amount of space they
appear to because of extent shingling.

Suppose we have a defragmented file with one extent "A" like this:

        0 MB AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1MB

Now we overwrite about half of the blocks:

        0 MB BBBBBBBBBBBBBBBBAAAAAAAAAAAAAAAA 1MB

btrfs tracks references to the entire extent, so what is on disk now is thi=
s:

        0 MB aaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAA 1MB original extent
        0 MB BBBBBBBBBBBBBBBB                 1MB new extent

The "a" are blocks from the original extent that are not visible in
the file, but remain present on disk.  In other words, this 1MB file is
now taking up 1.5MB of space.

This continues as long as any blocks of partially overwritten extents
are visible in any file (including snapshots, dedup, and clones), with
the worst case being something like this:

        0 MB BBBBBBBBBBBBBCCCCCCCCCCCCCCDDDDA 1MB

which could be like this on disk:

        0 MB aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaA 1MB first extent
        0 MB BBBBBBBBBBBBBbbb                 1MB second extent
        0 MB              CCCCCCCCCCCCCCcccc  1MB third extent
        0 MB                            DDDD  1MB fourth extent

This 1MB file takes up a little over 2MB of disk space, and there are
parts of extents A, B, and C which persist on disk but are no longer
part of any file's content.

In this case, if we wrote the last 4K of the file, we would free 1MB
of disk space by doing so:

             (extent A now deleted)
        0 MB BBBBBBBBBBBBBbbb                 1MB second extent
        0 MB              CCCCCCCCCCCCCCcccc  1MB third extent
        0 MB                            DDDD  1MB fourth extent
        0 MB                                E 1MB fifth extent

Similarly to free the "B" extent we have to overwrite all the visible
blocks, i.e. from 0 to the beginning of the "C" extent, before the
last visible block from "B" is destroyed and the entire "B" extent can
be freed.

The worst case is pretty bad:  with the worst possible overwrite pattern,
a file can occupy the square of its size on disk divided by the block
size (4K) divided by two.  That's a little under 128MB for a 1MB file,
or 128TB for a 1GB file.  Above 1GB, the scaling is linear instead of
quadratic because the extent size limit (1G) has been reached and
single-extent files are no longer possible (so a worst-case 2GB file
takes only 256TB of space instead of 512TB).

Defragmenting the files helps free space temporarily; however, space usage
will quickly grow again until it returns to the steady state around 2x
the file size.

A database ends up maxing out at about a factor of two space usage
because it tends to write short uniform-sized bursts of pages randomly,
so we get a pattern a bit like bricks in a wall:

        0 MB AA BB CC DD EE FF GG HH II JJ KK 1 MB half the extents
        0 MB  LL MM NN OO PP QQ RR SS TT UU V 1 MB the other half

        0 MB ALLBMMCNNDOOEPPFQQGRRHSSITTJUUKV 1 MB what the file looks like

Fixing this is non-trivial (it may require an incompatible disk format
change).  Until this is fixed, the most space-efficient approach seems to
be to force compression (so the maximum extent is 128K instead of 1GB)
and never defragment database files ever.

> --=20
> GCP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUrQFQACgkQgfmLGlazG5zBZgCeMmBQFAMVMcb20a2xCrmuBlYW
hBgAoNfHGiruTUw/bsE8ujo4y6JaXaOD
=uY+U
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
