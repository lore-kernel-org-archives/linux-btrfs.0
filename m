Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:44522 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753639AbcI0W5s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Sep 2016 18:57:48 -0400
Date: Tue, 27 Sep 2016 18:57:16 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Ruben Salzgeber <ruben.salzgeber@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: OS X Time Machine and BTRFS
Message-ID: <20160927225715.GQ21290@hungrycats.org>
References: <CA+Fk0XLfXVaMVTKyovwedBAAAMhpoiuF2b1yuAPbxsOQrkR3=A@mail.gmail.com>
 <CA+Fk0XKZbf1wamCuT7AZPNVOTmapyr-e9ACnjJ0kqzav561ysA@mail.gmail.com>
 <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HAv5+T9jbwMPl6Kw"
In-Reply-To: <CAJCQCtQvaJM-kkP12KRdNpMLAJYcJdi8Fm2b3GgE=Fqm2sUEjg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HAv5+T9jbwMPl6Kw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 26, 2016 at 03:06:39PM -0600, Chris Murphy wrote:
> On Mon, Sep 26, 2016 at 2:15 PM, Ruben Salzgeber
> <ruben.salzgeber@gmail.com> wrote:
> > Hi everyone
> >
> > I'm reaching out to you because I experience unusually slow read and
> > write speeds on my Arch Linux server in combination with OS X time
> > machine. My setup is consists of an Core i3 6300, 16GB Ram, 128GB SSD
> > for the OS and a 8 drive RAID5 BTRFS volume as archive. The latest
> > version of Avahi, Netatalk and BTRFS-Progs are installed. On a wired
> > connection I reach 120MB/s for normal filetransfers from OS X to the
> > Server. When using Time Machine I measure peak network trafic around
> > 1-2MB/s and long durations of almost no trafic. Could this be in any
> > relation to BTRFS? Is there a special configuration necessary for
> > folders containing the Time Machine sparsebundle file?

Ruben, if nobody has told you before now:  don't use btrfs raid5 in
production.

> For the likely majority who have no idea what this means: this creates
> a file on the server, on which an HFS+ volume is created and then
> remotely mounted on the client. Client sees an HFS+ volume. Server
> side, this file isn't really just one file, it's actually a directory
> containing a bunch of 8MiB files. So it's like a qcow2 file, in that
> it grows dynamically, but is made up of 8MiB "extents" that appear as
> files.
>=20
> First question is if the directory containing the sparsebundle file
> has xattr +C set on it? If not, individual bundle files won't inherit
> nodatacow as they're created. You'll have literally hundreds if not
> thousands of these files, many of which are being CoW'd constantly and
> simultaneously as they're being modified. Even a tiny metadata "touch"
> for an area of the HFS+ file system will result in an 8MiB file being
> affected. What I don't know, but suspect, is that each change to one
> of these 8MiB files is causing the whole 8MiB to be CoW'd. I have no
> idea what kind of optimization is possible here. If Netatalk is
> updating one of these 8MiB files, what does that write pattern look
> like? If it's making half a dozen small changes, is that half a dozen
> CoW of that entire 8MiB file? Or is it just CoW'ing what's changed?
> And then to what degree is Netatalk doing fsync at all? It could be a
> worse case scenario where it's CoWing 8MiB increments each time and
> with lots of fsyncs, which would just obliterate the performance.

Btrfs will CoW just the parts that are changed, leaving the original 8MB
extent on disk until the last original block is overwritten.  This could
double the amount of disk space used easily (and multiply it by several
thousand times in the worst case).

fsync could be heavy especially with older btrfs versions.  For that
matter, kernels before 4.4 will burn a lot of CPU looking for free space.

Lots of random small writes will drive up the extent count, which would
mean lots of extra seeks, each costing a few milliseconds on spinning
rust.  Over time, free space fragmentation would mean that random block
updates would trigger more raid5 stripe RMW updates (which, in addition to
eating the data when a disk fails, will make random writes much slower).

> xattr +C would probably solve most of this, so long as you're not
> taking Btrfs snapshots during a TM backup. Of course if +C is set,
> notdatacow implies nodatasum so there's no checksumming of this
> sparsebundle.
>=20
> Maybe someone has an idea how to sample the activity as it happens, to
> model the write pattern for this use case? Without knowing more about
> the pattern, it's a stab in the dark how to optimize the storage for
> it.

Run 'filefrag -v' on the sparse files at e.g. hourly intervals, and
compare the results.  It will show extents changing physical address
and size as they are split up.  Each one will cost a few milliseconds
to access; if there are millions, you'll be waiting a long time.

>=20
> --=20
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HAv5+T9jbwMPl6Kw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfq+T8ACgkQgfmLGlazG5xS5wCguZoEolOzwOu24E0zajBlTDqY
sUUAnRj0xkAMotyQtBg6WmQJHpr9CNpY
=0ije
-----END PGP SIGNATURE-----

--HAv5+T9jbwMPl6Kw--
