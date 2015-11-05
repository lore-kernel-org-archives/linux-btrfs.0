Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smx-7fb.smtp.startmail.com ([37.153.204.247]:38011 "EHLO
	smx-7fb.smtp.startmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031074AbbKEKpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 05:45:11 -0500
Message-ID: <563B3323.8080609@startmail.com>
Date: Thu, 05 Nov 2015 10:44:51 +0000
From: OmegaPhil <OmegaPhil@startmail.com>
Mime-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: Unable to allocate for space usage in particular btrfs volume
References: <563A7452.4050202@startmail.com>	<20151104213039.GC27446@carfax.org.uk> <563A7E45.1050806@startmail.com> <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
In-Reply-To: <pan$b856e$b1f161a7$4a31aba1$83a27ad@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XuHO0XiGD0pUB0gJWTf22apffQsOV3sNa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XuHO0XiGD0pUB0gJWTf22apffQsOV3sNa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/11/15 04:18, Duncan wrote:
> OmegaPhil posted on Wed, 04 Nov 2015 21:53:09 +0000 as excerpted:
>=20
>> The volume doesn't change hugely over time, so it really ought not to
>> have broken so quickly - a quick rundown of the storage usage:
>>
>> 36% general (small files, some smallish videos)
>> 24% music 23% pr0n 17% VMs
>>
>> But in terms of 'large files changing', it could be the VM disks perha=
ps
>> -
>> I'll move them out, balance, and then back in again, hopefully that'd =
be
>> a meaningful test.
>=20
> VM image files (and large database files, for the same reason) are a bi=
t=20
> of a problem on btrfs, and indeed, any COW-based filesystem, since the =

> random rewrite pattern matching that use-case is pretty much the absolu=
te=20
> worst-case match for a COW-based filesystem there is.
>=20
> And that would be the worst-case in terms of the unsplit extents issue =

> Hugo was talking about as well.  So they may well be the problem, indee=
d.
>=20
> Since you're not doing snapshotting (which conflicts with this option, =

> with an imperfect workaround), setting nocow on those files may well=20
> eliminate the problem, but be aware if you aren't already that (1) noco=
w=20
> does turn off checksumming as well, in ordered to avoid a race that cou=
ld=20
> easily lead to data corruption, and (2) you can't just activate nocow o=
n=20
> the existing file and expect it to work, the procedure is a bit more=20
> complicated than that, since nocow is only guaranteed to work if it's s=
et=20
> at file creation.  Detailed instructions for #2 skipped as they've been=
=20
> posted many times, but if you are interested and haven't seen them, ask=
=2E


Thankyou Hugo, Duncan - moving VMs out, then:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

sudo chattr +C '/mnt/storage-1/Virtual Machines'
sudo btrfs balance start -mconvert=3Ddup /mnt/storage-1
sudo btrfs fi defrag -rv /mnt/storage-1

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

And after moving VMs back, du reports 884GB used,

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

$ sudo btrfs fi usage /mnt/storage-1

Overall:
    Device size:		 953.87GiB
    Device allocated:		 924.07GiB
    Device unallocated:		  29.80GiB
    Device missing:		     0.00B
    Used:			 886.11GiB
    Free (estimated):		  65.72GiB	(min: 50.82GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:918.01GiB, Used:882.09GiB
   /dev/sdb	 918.01GiB

Metadata,DUP: Size:3.00GiB, Used:2.01GiB
   /dev/sdb	   6.00GiB

System,DUP: Size:32.00MiB, Used:128.00KiB
   /dev/sdb	  64.00MiB

Unallocated:
   /dev/sdb	  29.80GiB

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

So a couple of gig still unaccountable but irrelevant. Thanks, problem
solved! Although hopefully checksumming will be allowed on nocow files
in the future as thats currently 17% of all data unprotected and will
get worse...


--XuHO0XiGD0pUB0gJWTf22apffQsOV3sNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWOzM0AAoJEBfSPH39wvOP+UMP/AjNQoRkuk6AGxQHhwc324jK
I6QErtJ+6yNUHk4YO1B233qNQYRB38Owe/gnCUZH589+0MZ8UgRqj3wX1g9XPjm0
owQKvvBDJbArrb29dnLiIJRY10ys/wq9uy5oj//PIj3sk2Ig4EhDBP9vQygGO9n/
UYQbEYE9BtW+CwFJzRXPZZWSbDzTU9aZCSaqK43iCktBQTI3A52Y20vjCputnT2Z
QGEqFm1qXBJwdhzUpRjyaLT4fge6uGgzL185Lr19CEV5RsU0YDgg62tI2/ePa1qi
eTYxyvCn/9SF0tS4yJCSb/xudXT4gy85kB+nXyahRKF02sC1EbixNUKq4M3IVVkt
RO/xL0ssPmF4Bl1QVvfFjLcj8DPuM+HuFAnY/DacI4juDEE+fln7Kj2rAt6LOwXL
5+wmSghtW0LVxo9c30jVDAQjHg6zKJuA2vfuVL2zmto875fjsKWf2d3KsRpkaNCi
mtCg6zUmXrLDCutWmwGWybEbRFTdUF291PQwgVV+JJ3gCM6dmKnfLOzMFe0vbyDN
dfNPaNjztbShmsbMsaX/JlemRtaZtH/SDC6Nw8EnaxcPW0vI+/E2ZTDjscNo/Nai
JRqLAu7woRXo6mjf9BiCjp+BVBarZmLBtwAqIjBbb0ZW+xoUjCdeBw0FRR46RVa7
frP58crXM/IDxDrneHNx
=o3V2
-----END PGP SIGNATURE-----

--XuHO0XiGD0pUB0gJWTf22apffQsOV3sNa--
