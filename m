Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43726 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaLLXfH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 18:35:07 -0500
Date: Fri, 12 Dec 2014 23:35:03 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Robert White <rwhite@pobox.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID0 extent sizes?
Message-ID: <20141212233503.GH1442@carfax.org.uk>
References: <548B7220.1040403@pobox.com>
 <20141212225918.GG1442@carfax.org.uk>
 <548B795F.2050509@pobox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
In-Reply-To: <548B795F.2050509@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 03:25:19PM -0800, Robert White wrote:
> On 12/12/2014 02:59 PM, Hugo Mills wrote:
> >On Fri, Dec 12, 2014 at 02:54:24PM -0800, Robert White wrote:
> >>I've seen it mentioned here that generally data extents are 1G and
> >>metadata extents are 256M.
> >>
> >>Is that per-drive or per-stripe in the case of RAID0?
> >>
> >>That is, if I have data mode raid0 across N drives does the system
> >>allocate one 1G extent on each drive making the full stripe
> >>allocation N-gigs; or does it allocate 1/Nth(gig) on each drive
> >>making the total new allocation 1G?
> >>
> >>Does the raid0 have any arity constraints (like how raid1 is always
> >>arity-2)?
> >
> >    The 1 GiB (or 256 MiB for metadata) is the allocation unit. So for
> >striped RAID levels (like 0, 10, 5, 6), the FS will allocate as many
> >as it can across all the available devices, and stripe within those.
> >
> >    Now on to your question -- the stripes within the allocation unit
> >are 64 KiB in size, so the first 64k goes on the first device, the
> >next 64k on the second device, and so on.
> >
> >    The minimum stripe width (e.g. number of devices) is 2 for RAID-0,
> >4 for RAID-10, 2 for RAID-5 and 3 for RAID-6.
> >
> >    Hugo.
> >
> 
> [So to check my understanding, and just sticking to RAID-0 data only].
> 
> So for RAID-0 data on 5 drives with ample space, the expected
> outcome of allocating more data space is 5GiB, one 1GiB allocated on
> each drive.

   Correct.

> If one drive is too full (say it was smaller) and didn't have 1G of
> contiguous space available, the allocation would simply fail.

   No, it would allocate on the remaining 4 devices instead, with a
total of 4 GiB of space. The allocation in these cases is the maximum
feasible, not precisely the number of devices.

> The net effect is to create an association of allocations, one on
> each available drive that had "enough space", each of which will
> contribute exactly 1GiB to the association.

   Yes.

> So every time the data
> space allocation expands its going to expand by N-GiB total on an
> N-drive data=raid0 system.

   Not necessarily -- if one device is already full (because it's
smaller), then the number of devices will decrease as appropriate,
down to the minimum of 2.

> Since data and metadata are separate you can end up being "out of
> space" for big files but still be able to create files small enough
> to fit into the metadata with the inode.

   Yes, but this isn't related to the number of devices in striped
RAID allocations.

> Am I correct?

   Partially. :)

   Hugo.

-- 
Hugo Mills             | "How deep will this sub go?"
hugo@... carfax.org.uk | "Oh, she'll go all the way to the bottom if we don't
http://carfax.org.uk/  | stop her."
PGP: 65E74AC0          |                                                  U571

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUi3unAAoJEFheFHXiqx3kN0MP/2dv0ekKGgJoqioLpBMf+0w6
tMFezEf9wp7ilQUq9zRsW4QVSF/W5soyjw22+HGueAbO7BZ/Iq+sHMDINBNNUGXa
34c2VT1vHQd2Kado5MN34EXbBLXj3dNZid+QyfNtRGdyEGWbxHqt8Z4BpJuBx5cY
XPsLzEkHoBSOovi4fzLItvsAmkuPug1VldjMmQZZmRyKnC/1PQGiXycnxI8SGf5S
BrTBiGTRHzaULs7HeRWl99sM7Cyh0gkkYzEpRqkl+gFYgNOkNp/quUFE8rzZHLLW
lsNUUs3V9ZVtQE5hnLJha9J9ntygkRERBOlQCXi/N29DpwSSo621dBLJr66zUIsg
IIw/tLvaXBropSTf/BTtVxvrVIcpaDz1WVSALcCxjuhh/9macGVDZf6CoxY7sryw
ijqhE/+NiYtjmPsgniqpoDABzaH773NuyL9i9zXORS7/GOf/n+AcqitftksxAUvG
r2KQZjTMVxCU70RRqtA91MTnMcyAHRI7hgSZ+AK5wz2zErobdOsI4lGvmur8KwT3
Q952Bdnh/eSRBAOcFRNsVuZrH/zHqaLN+vr5TJ10JVY1DlDvMERSc9U5Xxmu9SCJ
AkS0KsOasYFimt2yP0X3jgS3qeaoPa8xd6HUqp0y2zU3DVow7EMEXrksR6WhA3q3
6jPtZE5MI38MzNzcFByF
=17fY
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
