Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdK0KNU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Nov 2017 05:13:20 -0500
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20171127094156.GC29491@fnst.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
Date: Mon, 27 Nov 2017 18:13:10 +0800
MIME-Version: 1.0
In-Reply-To: <20171127094156.GC29491@fnst.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KdwmAVeww4aRpHJPfP7qN9jNRJ0uJwfrG"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KdwmAVeww4aRpHJPfP7qN9jNRJ0uJwfrG
Content-Type: multipart/mixed; boundary="u9ve8tTprN2Ix3FAml9HmJtEfjOxLIPnl";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-ID: <493abbdd-e412-b91e-f14e-8e40da404cf8@gmx.com>
Subject: Re: How about adding an ioctl to convert a directory to a subvolume?
References: <20171127094156.GC29491@fnst.localdomain>
In-Reply-To: <20171127094156.GC29491@fnst.localdomain>

--u9ve8tTprN2Ix3FAml9HmJtEfjOxLIPnl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8827=E6=97=A5 17:41, Lu Fengqi wrote:
> Hi all,
>=20
> As we all know, under certain circumstances, it is more appropriate to
> create some subvolumes rather than keep everything in the same
> subvolume. As the condition of demand change, the user may need to
> convert a previous directory to a subvolume. For this reason=EF=BC=8Cho=
w about
> adding an ioctl to convert a directory to a subvolume?

The idea seems interesting.

However in my opinion, this can be done quite easily in (mostly) user
space, thanks to btrfs support of relink.

The method from Hugo or Chris is quite good, maybe it can be enhanced a
little.

Use the following layout as an example:

root_subv
|- subvolume_1
|  |- dir_1
|  |  |- file_1
|  |  |- file_2
|  |- dir_2
|     |- file_3
|- subvolume_2

If we want to convert dir_1 into subvolume, we can do it like:

1) Create a temporary readonly snapshot of parent subvolume containing
   the desired dir
   # btrfs sub snapshot -r root_subv/subvolume_1 \
     root_subv/tmp_snapshot_1

2) Create a new subvolume, as destination.
   # btrfs sub create root_subv/tmp_dest/

3) Copy the content and sync the fs
   Use of reflink is necessary.
   # cp -r --reflink=3Dalways root_subv/tmp_snapshot_1/dir_1 \
     root_subv/tmp_dest
   # btrfs sync root_subv/tmp_dest

4) Delete temporary readonly snapshot
   # btrfs subvolume delete root_subv/tmp_snapshot_1

5) Remove the source dir
   # rm -rf root_subv/subvolume_1/dir_1

5) Create a final destination snapshot of "root_subv/temporary_dest"
   # btrfs subvolume snapshot root_subv/tmp_dest \
     root_subv/subvolume_1/dir_1

6) Remove the temporary destination
   # btrfs subvolume delete root_subv/tmp_dest


The main challenge is in step 3).
In fact above method can only handle normal dir/files.
If there is another subvolume inside the desired dir, current "cp -r" is
a bad idea.
We need to skip subvolume dir, and create snapshot for it.

But it's quite easy to write a user space program to handle it.
Maybe using "find" command can already handle it well.

Anyway, doing it in user space is already possible and much easier than
doing it in kernel.

>=20
> Users can convert by the scripts mentioned in this
> thread(https://www.spinics.net/lists/linux-btrfs/msg33252.html), but is=

> it easier to use the off-the-shelf btrfs subcommand?

If you just want to integrate the functionality into btrfs-progs, maybe
it's possible.

But if you insist in providing a new ioctl for this, I highly doubt if
the extra hassle is worthy.

>=20
> After an initial consideration, our implementation is broadly divided
> into the following steps:
> 1. Freeze the filesystem or set the subvolume above the source director=
y
> to read-only;

Not really need to freeze the whole fs.
Just create a readonly snapshot of the parent subvolume which contains
the dir.
That's how snapshot is designed for.

> 2. Perform a pre-check, for example, check if a cross-device link
> creation during the conversion;

This can be done in-the-fly.
As the check is so easy (only needs to check if the inode number is 256).=

We only need a mid-order iteration of the source dir (in temporary
snapshot), and for normal file, use reflink.
For subvolume dir, create a snapshot for it.

And for such iteration, a python script less than 100 lines would be
sufficient.

Thanks,
Qu

> 3. Perform conversion, such as creating a new subvolume and moving the
> contents of the source directory;
> 4. Thaw the filesystem or restore the subvolume writable property.
>=20
> In fact, I am not so sure whether this use of freeze is appropriate
> because the source directory the user needs to convert may be located
> at / or /home and this pre-check and conversion process may take a long=

> time, which can lead to some shell and graphical application suspended.=

>=20
> Please give your comments if any.
>=20


--u9ve8tTprN2Ix3FAml9HmJtEfjOxLIPnl--

--KdwmAVeww4aRpHJPfP7qN9jNRJ0uJwfrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlob5TYXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qg0RQf9EvhgRqU0KZiH3cgX0Ff5TX5m
g/hkVkGe9E+zKZmHUxHcPLpIQck8QWmwXwrMe4d34EidZzLeUF0l64PXLl/abqji
t7KBBEE94jAzEvrX1u9TzlGAL2Xf2hj0Oxz7uGfOx/nRJmKZEes1UTT4Hql83P6q
gFaeRUoo992ToMc2x+8VEOU5XebTWR1iRkxT5qqLHwPULKaznvPm1WfVjRHpppl2
/f0D5Bd460ijueBH6nSWX20R5XFhKFrwdhGKCEgP3vq+VTRXyleNy2nuuutx0s5M
RjoBpVlmP9eESdoLw19EOSXQy1AzCwy5iLX9xn+4wZ2E1batu6nTBhetY3LpuA==
=TvAl
-----END PGP SIGNATURE-----

--KdwmAVeww4aRpHJPfP7qN9jNRJ0uJwfrG--
