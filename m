Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38893 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbbAGTI7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 14:08:59 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Hugo Mills <hugo@carfax.org.uk>, Robert White <rwhite@pobox.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS free space handling still needs more work: Hangs again (no complete lockups, "just" tasks stuck for some time)
Date: Wed, 07 Jan 2015 20:08:50 +0100
Message-ID: <1499386.KVI6lPzt8j@merkaba>
In-Reply-To: <20150106200322.GA12706@hungrycats.org>
References: <3738341.y7uRQFcLJH@merkaba> <2191338.tRc7Jxvh05@merkaba> <20150106200322.GA12706@hungrycats.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3916039.5WgbHboRIU"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart3916039.5WgbHboRIU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Dienstag, 6. Januar 2015, 15:03:23 schrieb Zygo Blaxell:
> On Mon, Dec 29, 2014 at 10:32:00AM +0100, Martin Steigerwald wrote:
> > Am Sonntag, 28. Dezember 2014, 21:07:05 schrieb Zygo Blaxell:
> > > On Sat, Dec 27, 2014 at 08:23:59PM +0100, Martin Steigerwald wrot=
e:
[=E2=80=A6]
> > > > Zygo, was is the characteristics of your filesystem. Do you use=

> > > > compress=3Dlzo and skinny metadata as well? How are the chunks
> > > > allocated?
> > > > What kind of data you have on it?
> > >=20
> > > compress-force (default zlib), no skinny-metadata.  Chunks are d=3D=
single,
> > > m=3Ddup.  Data is a mix of various desktop applications, most act=
ive
> > > file sizes from a few hundred K to a few MB, maybe 300k-400k file=
s.
> > > No database or VM workloads.  Filesystem is 100GB and is usually =
between
> > > 98 and 99% full (about 1-2GB free).
> > >=20
> > > I have another filesystem which has similar problems when it's 99=
.99%
> > > full (it's 13TB, so 0.01% is 1.3GB).  That filesystem is RAID1 wi=
th
> > > skinny-metadata and no-holes.
> > >=20
> > > On various filesystems I have the above CPU-burning problem, a bu=
nch of
> > > irreproducible random crashes, and a hang with a kernel stack tha=
t goes
> > > through SyS_unlinkat and btrfs_evict_inode.
> >=20
> > Zygo, thanks. That desktop filesystem sounds a bit similar to my us=
ecase,
> > with the interesting difference that you have no databases or VMs o=
n it.
> >=20
> > That said, I use the Windows XP rarely, but using it was what made =
the
> > issue so visible for me. Is your desktop filesystem on SSD?
>=20
> No, but I recently stumbled across the same symptoms on an 8GB SD car=
d
> on kernel 3.12.24 (raspberry pi).  When the filesystem hit over ~97%
> full, all accesses were blocked for several minutes.  I was able to
> work around it by adjusting the threshold on a garbage collector daem=
on
> (i.e. deleting a lot of expendable files) to keep usage below 90%.
> I didn't try to balance the filesystem, and didn't seem to need to.

Interesting.

> ext3 has a related problem when it's nearly full:  it will try to sea=
rch
> gigabytes of block allocation bitmaps searching for a free block, whi=
ch
> can result in a single 'mkdir' call spending 45 minutes reading a lar=
ge
> slow 99.5% full filesystem.

Ok, thats for bitmap access. Ext4 uses extens. BTRFS can use bitmaps as=
 well,=20
but also supports extents and I think uses it for most use cases.

> I'd expect a btrfs filesystem that was nearly full to have a small tr=
ee
> of cached free space extents and be able to search it quickly even if=

> the result is negative (i.e. there's no free space).  It seems to be
> doing something else... :-P

Yeah :)


> > Do you have the chance to extend one of the affected filesystems to=
 check
> > my theory that this does not happen as long as BTRFS can still allo=
cate
> > new
> > data chunks? If its right, your FS should be fluent again as long a=
s you
> > see more than 1 GiB free
> >=20
> > Label: none  uuid: 53bdf47c-4298-45bc-a30f-8a310c274069
> >=20
> >         Total devices 2 FS bytes used 512.00KiB
> >         devid    1 size 10.00GiB used 6.53GiB path
> >         /dev/mapper/sata-btrfsraid1
> >         devid    2 size 10.00GiB used 6.53GiB path
> >         /dev/mapper/msata-btrfsraid1
> >=20
> > between "size" and "used" in btrfs fi sh. I suggest going with at l=
east
> > 2-3
> > GiB, as BTRFS may allocate just one chunk so quickly that you do no=
t have
> > the chance to recognize the difference.
>=20
> So far I've found that problems start when space drops below 1GB free=

> (although it can go as low as 400MB) and problems stop when space get=
s
> above 1GB free, even without resizing or balancing the filesystem.
> I've adjusted free space monitoring thresholds accordingly for now,
> and it seems to be keeping things working so far.

Just to see whether we are on the same terms: You talk about space that=
 BTRFS=20
has not yet reserved for chunks, i.e. the difference between size and u=
sed in=20
btrfs fi sh, right?

No BTRFS developers commented yet on this, neither in this thread nor i=
n the=20
bug report at kernel.org I made.

> > Well, and if thats works for you, we are back to my recommendation:=

> >=20
> > More so than with other filesystems give BTRFS plenty of free space=
 to
> > operate with. At best as much, that you always have a mininum of 2-=
3 GiB
> > unused device space for chunk reservation left. One could even do s=
ome
> > Nagios/Icinga monitoring plugin for that :)

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--nextPart3916039.5WgbHboRIU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlSthEkACgkQmRvqrKWZhMe2igCfYEhf2KkyzRk/BAvn+fprbk7B
CI0An0rfMAQx8KL5PZH9oVn6Nu661tZu
=eo5S
-----END PGP SIGNATURE-----

--nextPart3916039.5WgbHboRIU--

