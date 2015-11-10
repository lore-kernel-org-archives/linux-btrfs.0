Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.92.155]:40107 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbKJJI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 04:08:58 -0500
Date: Tue, 10 Nov 2015 14:08:55 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
Subject: Re: Ideas for btrfs-convert fix(or rework)
Message-ID: <20151110140855.3ae7297c@natsu>
In-Reply-To: <5641A7DA.6010102@gmx.com>
References: <56418E5D.9020604@gmx.com>
	<20151110125501.1aa6f155@natsu>
	<5641A7DA.6010102@gmx.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/w0D4ct6F4OGp6D3cEyn/msq"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/w0D4ct6F4OGp6D3cEyn/msq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Nov 2015 16:16:26 +0800
Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> So if things are correct, the btrfs you converted should still be in=20
> mixed-bg mode.
> A recent 'btrfs fi df' command should show things like:
> Data+Metadata, DUP: total=3D512.00MiB, used=3D68.23MiB

Actually not quite. After all the rebalancing, I currently have:

Data, single: total=3D8.37TiB, used=3D7.50TiB
System, DUP: total=3D32.00MiB, used=3D592.00KiB
Metadata, DUP: total=3D8.00GiB, used=3D6.42GiB
GlobalReserve, single: total=3D512.00MiB, used=3D0.00B

> > But as we know recently there were reports that it now causes corruptio=
n or
> > does not work. So I wonder what happened that broke it, and is there re=
ally no
> > simpler fix? Even if requiring the user to balance to get rid of the bl=
oated
> > Metadata like I had to.
> >
>=20
> Yes, current btrfs-convert has problem on marking chunk meta or data.
> Resulting some data extents may lay in metadata chunk, and vice verse.
> At least it won't pass latest btrfsck.
>=20
> In that incorrect chunk layout, I'm not surprised any thing go wrong.

Made an experiment:

# dd if=3D/dev/zero bs=3D1M count=3D1 seek=3D100000 of=3D100G
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.0023896 s, 439 MB/s

# losetup /dev/loop7 100G

# mkfs.ext4 /dev/loop7=20

// Success

# mount /dev/loop7 /mnt/tmp1/

// Copy some files there

# df -h /mnt/tmp1/
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop7       96G  2.6G   89G   3% /mnt/tmp1

# umount /mnt/tmp1/

# btrfs-convert -d /dev/loop7=20
creating btrfs metadata.
creating ext2fs image file.
cleaning up system chunk.
conversion complete.

# mount /dev/loop7 /mnt/tmp1/

# btrfs fi df /mnt/tmp1/
Data, single: total=3D65.00GiB, used=3D1.32GiB
System, single: total=3D32.00MiB, used=3D12.00KiB
Metadata, single: total=3D32.63GiB, used=3D2.91GiB
GlobalReserve, single: total=3D92.00MiB, used=3D0.00B

# btrfs sub del /mnt/tmp1/ext2_saved
Transaction commit: none (default)
Delete subvolume '/mnt/tmp1/ext2_saved'

# btrfs fi df /mnt/tmp1/
Data, single: total=3D10.00GiB, used=3D120.12MiB
System, single: total=3D32.00MiB, used=3D4.00KiB
Metadata, single: total=3D4.00GiB, used=3D2.37GiB
GlobalReserve, single: total=3D52.00MiB, used=3D0.00B

// It has 2.6 GB of files, and most of them are now accounted as "Metadata".

# btrfs fi balance start -m /mnt/tmp1/
Done, had to relocate 5 out of 7 chunks

// They are now reclassified as data:

# btrfs fi df /mnt/tmp1/
Data, single: total=3D10.00GiB, used=3D2.49GiB
System, single: total=3D32.00MiB, used=3D4.00KiB
Metadata, single: total=3D1.00GiB, used=3D468.00KiB
GlobalReserve, single: total=3D4.00MiB, used=3D0.00B

// Unmount, mount, checked all files integrity with 'cfv', all files are
present and there is no corruption.

So this behaves just like I remember it to, after conversion at first a lar=
ge
part of the data will show up as Metadata, but a balance fixes that. And mo=
st
importantly no corruption issues. Maybe it's just because this is only a sm=
all
test FS, but my production one earlier went through the same process without
problems as well.

Using btrfs-tools v3.17 and kernel 3.18.21

--=20
With respect,
Roman

--Sig_/w0D4ct6F4OGp6D3cEyn/msq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlZBtCcACgkQTLKSvz+PZwjjUACeKGwPx5RyO5aanUR1QIg+yQ9a
a4UAn2ZcKRGOowb3IN+46cH4NPOy8D9C
=DqNQ
-----END PGP SIGNATURE-----

--Sig_/w0D4ct6F4OGp6D3cEyn/msq--
