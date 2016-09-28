Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33306 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756381AbcI1Cxw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 22:53:52 -0400
Date: Tue, 27 Sep 2016 22:53:50 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: OS X Time Machine and BTRFS
Message-ID: <20160928025350.GR21290@hungrycats.org>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
 <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
 <20160927225715.GQ21290@hungrycats.org>
 <CAJCQCtTu2XRnmsVULrvOHhU2pwcckMABsXKET+we6KwduNy6Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
In-Reply-To: <CAJCQCtTu2XRnmsVULrvOHhU2pwcckMABsXKET+we6KwduNy6Ew@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2016 at 07:31:00PM -0600, Chris Murphy wrote:
> On Tue, Sep 27, 2016 at 4:57 PM, Zygo Blaxell
> <ce3g8jdj@umail.furryterror.org> wrote:
> > On Mon, Sep 26, 2016 at 03:06:39PM -0600, Chris Murphy wrote:
> >> On Mon, Sep 26, 2016 at 2:15 PM, Ruben Salzgeber
> >> <ruben.salzgeber@gmail.com> wrote:
> >> > Hi everyone
> >> >
> >> > I'm reaching out to you because I experience unusually slow read and
> >> > write speeds on my Arch Linux server in combination with OS X time
> >> > machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
> >> > for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
> >> > version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
> >> > connection I reach 120MB/s for normal filetransfers from OS X to the
> >> > Server. When using Time Machine I measure peak network trafic around
> >> > 1-2MB/s and long durations of almost no trafic. Could this be in any
> >> > relation to BTRFS? Is there a special configuration necessary for
> >> > folders containing the Time Machine sparsebundle file?
> >
> > Ruben, if nobody has told you before now:  don't use btrfs raid5 in
> > production.
>=20
>=20
> I spaced this out, it might be a factor in the performance problem. More =
below.
>=20
>=20
> >
> >> For the likely majority who have no idea what this means: this creates
> >> a file on the server, on which an HFS+ volume is created and then
> >> remotely mounted on the client. Client sees an HFS+ volume. Server
> >> side, this file isn't really just one file, it's actually a directory
> >> containing a bunch of 8MiB files. So it's like a qcow2 file, in that
> >> it grows dynamically, but is made up of 8MiB "extents" that appear as
> >> files.
> >>
> >> First question is if the directory containing the sparsebundle file
> >> has xattr +C set on it? If not, individual bundle files won't inherit
> >> nodatacow as they're created. You'll have literally hundreds if not
> >> thousands of these files, many of which are being CoW'd constantly and
> >> simultaneously as they're being modified. Even a tiny metadata "touch"
> >> for an area of the HFS+ file system will result in an 8MiB file being
> >> affected. What I don't know, but suspect, is that each change to one
> >> of these 8MiB files is causing the whole 8MiB to be CoW'd. I have no
> >> idea what kind of optimization is possible here. If Netatalk is
> >> updating one of these 8MiB files, what does that write pattern look
> >> like? If it's making half a dozen small changes, is that half a dozen
> >> CoW of that entire 8MiB file? Or is it just CoW'ing what's changed?
> >> And then to what degree is Netatalk doing fsync at all? It could be a
> >> worse case scenario where it's CoWing 8MiB increments each time and
> >> with lots of fsyncs, which would just obliterate the performance.
> >
> > Btrfs will CoW just the parts that are changed, leaving the original 8MB
> > extent on disk until the last original block is overwritten.
>=20
> If the parts that are changed are less than the full data stripe size,
> in this case 448KiB, then my understanding is it's not CoW, it's RMW
> for that stripe.

There are two levels at work here:

At the *extent* level (the structure you can see with FIEMAP or filefrag
-v), the small data writes are doing CoW in increments as small as 4K.
If the writes are all block-aligned there is no reading of data at all,
the new writes will just be blasted out to disk in big mostly-contiguous
physical (but highly discontiguous logical) bursts.

At the *block* level (inside each raid5 block group) small data writes
are doing RMW on 448K physical stripes.  If there's a burst of blocks
then these get batched up into full-stripe writes and there's no
performance problem (well, not one unique to this use case, anyway).
If the filesystem is partly full then old physical addresses can be
re-used and the RMW rate goes back up again.

In btrfs, the CoW and RMW layers have no knowledge of each other:  the CoW
layer thinks the disk is a contiguous surface of individually-addressable
4K blocks, while the RMW layer can't cope with (or atomically update)
anything smaller than 448KB.  Worse, the allocator (which lives on the
CoW layer) tends to stumble into the bad RMW cases very hard if you do
a lot of fsync().

> In this use case, I mostly expect the backup is producing new writes
> on HFS+, and thus new writes on Btrfs. But two things could cause a
> lot of RMW: the HFS+ journal is ~16MiB, and maybe it's getting hit
> with lots of changes during backups, I'm not sure. And there could be
> a lot of small block writes for HFS+ metadata, also causing RMW.

While raid5 RMW would make this even slower, it's not going to be fast
on any other btrfs raid profile either.  If you're OK with not having
checksums, nodatacow is the way to go for this use case; otherwise,
invest heavily in SSD and RAID1.

>=20
>=20
> --=20
> Chris Murphy

--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfrML4ACgkQgfmLGlazG5wTMACfQkFq9z97D5GyNGSope9tA4ME
CugAoN4tLTWbF1HCKnsesK7azPEK9xul
=5Gro
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
