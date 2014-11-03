Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:33742 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752537AbaKCDni (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 22:43:38 -0500
Date: Sun, 2 Nov 2014 22:43:37 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem corruption
Message-ID: <20141103034337.GM17395@hungrycats.org>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
 <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
 <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
 <CAGwxe4hC_BtPd41YCnFnyMD3TnOeuNgAZ1dZUFRUYuOkFjy0Yg@mail.gmail.com>
 <5455B7E7.3020404@pobox.com>
 <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+svXpSx+RSEd8UhP"
In-Reply-To: <1C1C5F8B-DD79-4E4B-A530-D98DABA53E74@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--+svXpSx+RSEd8UhP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 02, 2014 at 02:57:22PM -0700, Chris Murphy wrote:
> On Nov 1, 2014, at 10:49 PM, Robert White <rwhite@pobox.com> wrote:
>=20
> > On 10/31/2014 10:34 AM, Tobias Holst wrote:
> >> I am now using another system with kernel 3.17.2 and btrfs-tools 3.17
> >> and inserted one of the two HDDs of my btrfs-RAID1 to it. I can't add
> >> the second one as there are only two slots in that server.
> >>=20
> >> This is what I got:
> >>=20
> >>  tobby@ubuntu: sudo btrfs check /dev/sdb1
> >> warning, device 2 is missing
> >> warning devid 2 not found already
> >> root item for root 1746, current bytenr 80450240512, current gen
> >> 163697, current level 2, new bytenr 40074067968, new gen 163707, new
> >> level 2
> >> Found 1 roots with an outdated root item.
> >> Please run a filesystem check with the option --repair to fix them.
> >>=20
> >>  tobby@ubuntu: sudo btrfs check --repair /dev/sdb1
> >> enabling repair mode
> >> warning, device 2 is missing
> >> warning devid 2 not found already
> >> Unable to find block group for 0
> >> extent-tree.c:289: find_search_start: Assertion `1` failed.
> >=20
> > The read-only snapshots taken under 3.17.1 are your core problem.
> >=20
> > Now btrfsck is refusing to operate on the degraded RAID because
> > degraded RAID is degraded so it's read-only. (this is an educated
> > guess).
>=20
> Degradedness and writability are orthogonal. If there's some problem
> with the fs that prevents it from being mountable rw, then that'd
> apply for both normal and degraded operation. If the fs is OK, it
> should permit writable degraded mounts.
>=20
> > Since btrfsck is _not_ a mount type of operation its got no "degraded
> > mode" that would let you deal with half a RAID as far as I know.
>=20
> That's a problem. I can see why a repair might need an additional flag
> (maybe force) to repair a volume that has the minimum number of devices
> for degraded mounting, but not all are present. Maybe we wouldn't want
> it to be easy to accidentally run a repair that changes the file system
> when a device happens to be missing inadvertently that could be found
> and connected later.
>=20
> I think related to this is a btrfs equivalent of a bitmap. The metadata
> already has this information in it, but possibly right now btrfs
> lacks the equivalent behavior of mdadm readd when a previously missing
> device is reconnected. If it has a bitmap then it doesn't have to be
> completely rebuilt, the bitmap contains information telling md how to
> "catch up" the readded device, i.e. only that which is different needs
> to be written upon a readd.
>=20
> For example if I have a two device Btrfs raid1 for both data and
> metadata, and one device is removed and I mount -o degraded,rw one
> of them and make some small changes, unmount, then reconnect the
> missing device and mount NOT degraded - what happens?  I haven't tried
> this.=20

I have.  It's a filesystem-destroying disaster.  Never do it, never let
it happen accidentally.  Make sure that if a disk gets temporarily
disconnected, you either never mount it degraded, or never let it come
back (i.e. take the disk to another machine and wipefs it).  Don't ever,
ever put 'degraded' in /etc/fstab mount options.  Nope.  No.

btrfs seems to assume the data is correct on both disks (the generation
numbers and checksums are OK) but gets confused by equally plausible but
different metadata on each disk.  It doesn't take long before the
filesystem becomes data soup or crashes the kernel.

There is more than one way to get to this point.  Take LVM snapshots of
the devices in a btrfs RAID1 array, and 'btrfs device scan' will see two
different versions of each btrfs device in a btrfs filesystem (one for
the origin LV and one for the snapshot).  btrfs then assembles LVs of
different vintages randomly (e.g. one from the mount command line, one
=66rom an earlier LVM snapshot of the second disk) with disastrous results
similar to the above.  IMHO if btrfs sees multiple devices with the same
UUIDs, it should reject all of them and require an explicit device list;
however, mdadm has a way to deal with this that would also work.

mdadm puts event counters and timestamps in the device superblocks to
prevent any such accidental disjoint assembly and modification of members
of an array.  If disks go temporarily offline with separate modifications
then mdadm refuses to accept disks with different counter+timestamp data
(so you'll get all the disks but one rejected, or only one disk with all
others rejected).  The rejected disk(s) has to go through full device
recovery before rejoining the array--someone has to use mdadm to add
the rejected disk as if it was a new, blank one.

Currently btrfs won't mount a degraded array by default, which prevents
unrecoverable inconsistency.  That's a safe behavior for now, but sooner
or later btrfs will need to be able to safely boot unattended on a
degraded RAID1 root filesystem.

> And I also don't know if a full balance (hours) is needed to
> "catch up" the formerly missing device. With md this is very fast -
> seconds/minutes depending on how much has been changed.

I schedule a scrub immediately after boot, assuming that it will resolve
any data differences (and also assuming that the reboot was caused by
a disk-related glitch, which it usually is for me).  That might not
be enough for metadata differences, and it's certainly not enough for
modifications in degraded mode.  Full balance is out of my reach--it
takes weeks on even my medium-sized filesystems, and mkfs + rsync from
backup is much faster.


--+svXpSx+RSEd8UhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRW+ekACgkQgfmLGlazG5xACQCfWxCQ0C9jqADP9Dl+JR2aZWdC
EtkAnR/20k01hMy6t5GzH9pNeJzgjyMb
=WwHF
-----END PGP SIGNATURE-----

--+svXpSx+RSEd8UhP--
