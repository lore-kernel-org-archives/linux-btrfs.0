Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:43274 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756673AbbAFUD2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 15:03:28 -0500
Date: Tue, 6 Jan 2015 15:03:23 -0500
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no
 complete lockups, "just" tasks stuck for some time)
Message-ID: <20150106200322.GA12706@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba>
 <2138510.KXMt4iLDat@merkaba>
 <20141229020705.GA17679@hungrycats.org>
 <2191338.tRc7Jxvh05@merkaba>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
In-Reply-To: <2191338.tRc7Jxvh05@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 10:32:00AM +0100, Martin Steigerwald wrote:
> Am Sonntag, 28. Dezember 2014, 21:07:05 schrieb Zygo Blaxell:
> > On Sat, Dec 27, 2014 at 08:23:59PM +0100, Martin Steigerwald wrote:
> > > My simple test case didn=B4t trigger it, and I so not have another tw=
ice 160
> > > GiB available on this SSDs available to try with a copy of my home
> > > filesystem. Then I could safely test without bringing the desktop ses=
sion to
> > > an halt. Maybe someone has an idea on how to "enhance" my test case in
> > > order to reliably trigger the issue.
> > >=20
> > > It may be challenging tough. My /home is quite a filesystem. It has a=
 maildir
> > > with at least one million of files (yeah, I am performance testing KM=
ail and
> > > Akonadi as well to the limit!), and it has git repos and this one VM =
image,
> > > and the desktop search and the Akonadi database. In other words: It h=
as
> > > been hit nicely with various mostly random I think workloads over the=
 last
> > > about six months. I bet its not that easy to simulate that. Maybe som=
e runs
> > > of compilebench to age the filesystem before the fio test?
> > >=20
> > > That said, BTRFS performs a lot better. The complete lockups without =
any
> > > CPU usage of 3.15 and 3.16 have gone for sure. Thats wonderful. But t=
here
> > > is this kworker issue now. I noticed it that gravely just while tryin=
g to
> > > complete this tax returns stuff with the Windows XP VM. Otherwise it =
may
> > > have happened, I have seen some backtraces in kern.log, but it didn=
=B4t last
> > > for minutes. So this indeed is of less severity than the full lockups=
 with
> > > 3.15 and 3.16.
> > >=20
> > > Zygo, was is the characteristics of your filesystem. Do you use
> > > compress=3Dlzo and skinny metadata as well? How are the chunks alloca=
ted?
> > > What kind of data you have on it?
> >=20
> > compress-force (default zlib), no skinny-metadata.  Chunks are d=3Dsing=
le,
> > m=3Ddup.  Data is a mix of various desktop applications, most active
> > file sizes from a few hundred K to a few MB, maybe 300k-400k files.
> > No database or VM workloads.  Filesystem is 100GB and is usually between
> > 98 and 99% full (about 1-2GB free).
> >=20
> > I have another filesystem which has similar problems when it's 99.99%
> > full (it's 13TB, so 0.01% is 1.3GB).  That filesystem is RAID1 with
> > skinny-metadata and no-holes.
> >=20
> > On various filesystems I have the above CPU-burning problem, a bunch of
> > irreproducible random crashes, and a hang with a kernel stack that goes
> > through SyS_unlinkat and btrfs_evict_inode.
>=20
> Zygo, thanks. That desktop filesystem sounds a bit similar to my usecase,
> with the interesting difference that you have no databases or VMs on it.
>=20
> That said, I use the Windows XP rarely, but using it was what made the is=
sue
> so visible for me. Is your desktop filesystem on SSD?

No, but I recently stumbled across the same symptoms on an 8GB SD card
on kernel 3.12.24 (raspberry pi).  When the filesystem hit over ~97%
full, all accesses were blocked for several minutes.  I was able to
work around it by adjusting the threshold on a garbage collector daemon
(i.e. deleting a lot of expendable files) to keep usage below 90%.
I didn't try to balance the filesystem, and didn't seem to need to.

ext3 has a related problem when it's nearly full:  it will try to search
gigabytes of block allocation bitmaps searching for a free block, which
can result in a single 'mkdir' call spending 45 minutes reading a large
slow 99.5% full filesystem.

I'd expect a btrfs filesystem that was nearly full to have a small tree
of cached free space extents and be able to search it quickly even if
the result is negative (i.e. there's no free space).  It seems to be
doing something else... :-P

> Do you have the chance to extend one of the affected filesystems to check
> my theory that this does not happen as long as BTRFS can still allocate n=
ew
> data chunks? If its right, your FS should be fluent again as long as you =
see
> more than 1 GiB free
>=20
> Label: none  uuid: 53bdf47c-4298-45bc-a30f-8a310c274069
>         Total devices 2 FS bytes used 512.00KiB
>         devid    1 size 10.00GiB used 6.53GiB path /dev/mapper/sata-btrfs=
raid1
>         devid    2 size 10.00GiB used 6.53GiB path /dev/mapper/msata-btrf=
sraid1
>=20
> between "size" and "used" in btrfs fi sh. I suggest going with at least 2=
-3
> GiB, as BTRFS may allocate just one chunk so quickly that you do not have
> the chance to recognize the difference.

So far I've found that problems start when space drops below 1GB free
(although it can go as low as 400MB) and problems stop when space gets
above 1GB free, even without resizing or balancing the filesystem.
I've adjusted free space monitoring thresholds accordingly for now,
and it seems to be keeping things working so far.

> Well, and if thats works for you, we are back to my recommendation:
>=20
> More so than with other filesystems give BTRFS plenty of free space to
> operate with. At best as much, that you always have a mininum of 2-3 GiB
> unused device space for chunk reservation left. One could even do some
> Nagios/Icinga monitoring plugin for that :)
>=20
> --=20
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7



--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlSsP4kACgkQgfmLGlazG5whJgCfUJFKTaHZIG8dN5YmYA47yhO7
C9QAoMylelsy+oQM8tT59IEGrsUes51H
=BuVw
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
