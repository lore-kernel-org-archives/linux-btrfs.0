Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51598 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3JaPWF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Oct 2013 11:22:05 -0400
Date: Thu, 31 Oct 2013 15:22:02 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Balance empty filesystem loses raid profile for data
Message-ID: <20131031152202.GW14405@carfax.org.uk>
References: <CAC4gV=4Y-Yn4Wc=VSXTONPaaxA1t_GSN6JR2ZPzh59mOWNPy4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTjKcilERHWBCdCp"
In-Reply-To: <CAC4gV=4Y-Yn4Wc=VSXTONPaaxA1t_GSN6JR2ZPzh59mOWNPy4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--UTjKcilERHWBCdCp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 31, 2013 at 10:51:28AM -0400, Frank Holton wrote:
> So I just noticed this while running some tests and am not sure if
> this is the expected behavior but it doesn't seem right to me.
> 
> If you run a balance on an empty filesystem, it removes all of the
> data chunks. Writing files to the fs results in a new data chunk being
> allocated of type single completely ignoring what the filesystem was
> created with.

   It's known about, certainly. I'm not sure if anyone's planning on
doing anything about it. I thought I'd seen a patch recently that
might have done something about it, but I can't see anything obvious
in the list archives for the last week or so. I think it's generally
considered a minor, if weird, side-effect that few people are likely
to hit.

> ./btrfs version
> Btrfs v0.20-rc1-548-g4597c6d-dirty (newest btrfs-progs-integration)
> 
> Tested on kernels 3.11 and 3.12rc6
> 
> Results of df after sudo mkfs.btrfs -m raid1 -d raid0 -L test
> /dev/loop0 /dev/loop1
> Data, RAID0: total=2.00GiB, used=0.00
> Data, single: total=8.00MiB, used=0.00
> System, RAID1: total=8.00MiB, used=4.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=1.00GiB, used=24.00KiB
> Metadata, single: total=8.00MiB, used=0.00
> 
> After sudo btrfs balance start /test/
> System, RAID1: total=32.00MiB, used=4.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=256.00MiB, used=24.00KiB
> 
> And after writing new files to the fs
> Data, single: total=1.00GiB, used=10.31MiB
> System, RAID1: total=32.00MiB, used=4.00KiB
> System, single: total=4.00MiB, used=0.00
> Metadata, RAID1: total=256.00MiB, used=40.00KiB
> 
> Now it has reverted to single for data raid type. Also is btrfs.mkfs
> supposed to make all of those single chunks?

   Not sure about "supposed to" -- it certainly has always done so.
It's an artefact of the way that mkfs works, I think -- as I
understand it, it creates a really basic FS structure with minimal
metadata in it, and lets the kernel fill in the rest on the first
mount. They're generally small and harmless, and go away after the
first balance.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
       --- "You got very nice eyes, Deedee. Never noticed them ---       
                           before. They real?"                           

--UTjKcilERHWBCdCp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUnJ1mlheFHXiqx3kAQKdEw//fPLWiywcVz1dObTjTE11Pxcl8JSxjT1P
eQT6Tad7w5RvJmdb29n73Z8oAK6so1SY4CYG8wkbR89zqoZt/+wVIuUk96gPWAOs
R99pVNF2lnkH11ompxQnxCkwKEsHraP1hdB5UDQCqSIy6subco0sQeHXnUM5IM5k
giydQz1HV1OSaIPHYyE3qbkEQ7Z/80ak+/v/dJimjSCjxiWpnUBWXS079fEhI8oj
GTMIwrYMJbWLr0PWXt+UUd/8qFIGNYwCRncDmgNSL5ZsXM/CYiVUNMil7YbTPdJH
uHiBjO41d1MVF0zgEPYDCW+YtkrZjKxSceTduk8DXV5tII4hHf4ybd7/RR2L/v6h
dvi7NiQ0FiodnrG1ScynVguqcxVmEF8yGSV+QDLjbBcniW6uz+AgueBwdRinOXLK
ADa3qoHiFESIetSnd0gWdf+z2LVEIhYvJz1UWrMCO5bwN8ztH28OB4J84uAbo00y
zjsbdsNgg4VJO7oq8teZQxFAI/u9NVSMH2eG5YZBOoG6g6Wt7wLgdOh8sC9FFwYD
vmleClHt1vZjKWUi7tbudnnst1/LIjk5XksqkbvKDnm09mrHCQvBJXiseXlC2G+p
u7iWiQGfdxyhc4v69kXml765ghztZd4v54p6LttMW3eZ0YXqV3PIGQwo7CveXwfU
9J/x/AhWaks=
=ejeO
-----END PGP SIGNATURE-----

--UTjKcilERHWBCdCp--
