Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:48520 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966450AbcKXXLE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 18:11:04 -0500
Date: Thu, 24 Nov 2016 18:11:02 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Increased disk usage after deduplication and system running out
 of memory
Message-ID: <20161124231102.GY21290@hungrycats.org>
References: <51c36f62-739b-425c-9252-8f7dcf9d016c@linuxsystems.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GohmpbibSJzDFTQZ"
In-Reply-To: <51c36f62-739b-425c-9252-8f7dcf9d016c@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--GohmpbibSJzDFTQZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 24, 2016 at 03:00:26PM +0100, Niccol=F2 Belli wrote:
> Hi,
> I use snapper, so I have plenty of snapshots in my btrfs partition and mo=
st
> of my data is already deduplicated because of that.
> Since long time ago I run offline defragmentation once (because I didn't
> know extents get unshared) I wanted to run offline deduplication to free a
> couple of GBs.
>=20
> This is the script I use to stop snapper, set snapshots to rw, balance,
> deduplicate, etc: https://paste.pound-python.org/show/vPUGVNjPQbDvr4HbtMg=
s/
>=20
> $ cat after_balance Overall:
>    Device size:                 152.36GiB
> Device allocated:            136.00GiB
> Device unallocated:           16.35GiB
> Device missing:                  0.00B
> Used:                        133.97GiB
> Free (estimated):             17.17GiB      (min: 17.17GiB)
> Data ratio:                       1.00
> Metadata ratio:                   1.00
> Global reserve:              239.94MiB      (used: 0.00B)
> Data,single: Size:133.00GiB, Used:132.18GiB
> /dev/mapper/cryptroot         133.00GiB
> Metadata,single: Size:3.00GiB, Used:1.79GiB
> /dev/mapper/cryptroot           3.00GiB
> System,single: Size:3.00MiB, Used:16.00KiB
> /dev/mapper/cryptroot           3.00MiB
> Unallocated:
> /dev/mapper/cryptroot          16.35GiB
>=20
>=20
> $ cat after_duperemove_and_balance
> Overall:
> Device size:                 152.36GiB
> Device allocated:            136.03GiB
> Device unallocated:           16.33GiB
> Device missing:                  0.00B
> Used:                        133.81GiB
> Free (estimated):             16.55GiB      (min: 16.55GiB)
> Data ratio:                       1.00
> Metadata ratio:                   1.00
> Global reserve:              512.00MiB      (used: 0.00B)
>=20
> Data,single: Size:127.00GiB, Used:126.77GiB
>   /dev/mapper/cryptroot         127.00GiB
>=20
> Metadata,single: Size:9.00GiB, Used:7.03GiB
>   /dev/mapper/cryptroot           9.00GiB
>=20
> System,single: Size:32.00MiB, Used:16.00KiB
>   /dev/mapper/cryptroot          32.00MiB
>=20
> Unallocated:
>   /dev/mapper/cryptroot          16.33GiB
>=20
>=20
> As you can see it freed 5.41 GB of data, but it also added 5.24 GB of
> metadata. The estimated free space is now 16.55 GB, while before the
> deduplication it was higher: 17.17 GB.
>=20
> This is when running duperemove git with noblock, but almost nothing chan=
ges
> if I omitt it (it defaults to block).
> Why did my metadata increase by a 4x factor? 99% of my data already had
> shared extents because of snapshots, so why such a huge increase?

Sharing by snapshot is different from sharing by dedup.

For snapshots, a new tree node is introduced which shares the entire
rest of the tree.  So you get:

        Root 123 -----\                   /--- Node 85 --- data 84
                       >----- Node 87 ---<
        Root 124 -----/                   \--- Node 43 --- data 42

This means there's 16K of metadata (actually probably more, but small
nonetheless) that is sharing the entire subvol.

For dedup, each shared data extent is shared individually, and metadata
is not shared at all:

    Root 123 -----\                   /--- Node 85 --- data 84 (shared)
                   \----- Node 87 ---<
                                      \--- Node 43 --- data 42 (shared)

                                  /--- Node 129 --- data 84 (shared)
    Root 124 ------- Node 131 ---<
                                  \--- Node 126 --- data 42 (shared)

If you dedup over a set of snapshots, it eventually unshares the metadata.
The data is still shared, but _only_ the data, so it multiplies the
metadata size by the number of snapshots.  It's even worse if you have
dup metadata since the cost of each new metadata page is doubled.

> Deduplication didn't finish up to 100%, because duperemove got killed by =
OOM
> killer at 99%: https://paste.pound-python.org/show/yUcIOSzXcrfNPkF9rV2L/
>=20
> As you can see from dmesg
> (https://paste.pound-python.org/show/eZIkpxUU6QR9ij6Rn1Oq/) there is no
> process stealing so much memory (my system has 8GB): the biggest one takes
> as much as 700MB of vm.
>=20
> Another strange thing that you can see from the previous log is that it
> tries to deduplicate /home/niko/nosnap/rootfs/@images/fedora25.qcow2 which
> is a UNIQUE file. Such image is stored in a separate subvolume because I
> don't want it to be snapshotted, so I'm pretty sure there are no other
> copies of this image, but still it tries to deduplicate it.
>=20
> Niccol=F2 Belli
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--GohmpbibSJzDFTQZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlg3c4YACgkQgfmLGlazG5wP0wCgoUlqy8QgBvSbHQyJ0svo38dd
h0oAoJbzx8JiaYdSn00Qmft033tO60Fs
=/8xu
-----END PGP SIGNATURE-----

--GohmpbibSJzDFTQZ--
