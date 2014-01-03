Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36149 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaACXEP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jan 2014 18:04:15 -0500
Date: Fri, 3 Jan 2014 23:04:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Jim Salter <jim@jrs-s.net>
Cc: Joshua =?iso-8859-1?Q?Sch=FCler?= <joshua.schueler@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
Message-ID: <20140103230410.GI8913@carfax.org.uk>
References: <52C73987.7000106@jrs-s.net>
 <52C73D1A.8060805@gmail.com>
 <52C7402A.7050605@jrs-s.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EdRE1UL8d3mMOE6m"
In-Reply-To: <52C7402A.7050605@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EdRE1UL8d3mMOE6m
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 03, 2014 at 05:56:42PM -0500, Jim Salter wrote:
> I actually read the wiki pretty obsessively before blasting the list
> - could not successfully find anything answering the question, by
> scanning the FAQ or by Googling.
>=20
> You're right - mount -t btrfs -o degraded /dev/vdb /test worked fine.
>=20
> HOWEVER - this won't allow a root filesystem to mount. How do you
> deal with this if you'd set up a btrfs-raid1 or btrfs-raid10 as your
> root filesystem? Few things are scarier than seeing the "cannot find
> init" message in GRUB and being faced with a BusyBox prompt...

   Use grub's command-line editing to add rootflags=3Ddegraded to it.

   Hugo.

> which
> is actually how I initially got my scare; I was trying to do a
> walkthrough for setting up a raid1 / for an article in a major
> online magazine and it wouldn't boot at all after removing a device;
> I backed off and tested with a non root filesystem before hitting
> the list.
>=20
> I did find the -o degraded argument in the wiki now that you
> mentioned it - but it's not prominent enough if you ask me. =3D)
>=20
>=20
>=20
> On 01/03/2014 05:43 PM, Joshua Sch=FCler wrote:
> >Am 03.01.2014 23:28, schrieb Jim Salter:
> >>I'm using Ubuntu 12.04.3 with an up-to-date 3.11 kernel, and the
> >>btrfs-progs from Debian Sid (since the ones from Ubuntu are ancient).
> >>
> >>I discovered to my horror during testing today that neither raid1 nor
> >>raid10 arrays are fault tolerant of losing an actual disk.
> >>
> >>mkfs.btrfs -d raid10 -m raid10 /dev/vdc /dev/vdd /dev/vdd /dev/vde
> >>mkdir /test
> >>mount /dev/vdb /test
> >>echo "test" > /test/test
> >>btrfs filesystem sync /test
> >>shutdown -hP now
> >>
> >>After shutting down the VM, I can remove ANY of the drives from the
> >>btrfs raid10 array, and be unable to mount the array. In this case, I
> >>removed the drive that was at /dev/vde, then restarted the VM.
> >>
> >>btrfs fi show
> >>Label: none  uuid: 94af1f5d-6ad2-4582-ab4a-5410c410c455
> >>         Total devices 4 FS bytes used 156.00KB
> >>          devid    3 size 1.00GB used 212.75MB path /dev/vdd
> >>          devid    3 size 1.00GB used 212.75MB path /dev/vdc
> >>          devid    3 size 1.00GB used 232.75MB path /dev/vdb
> >>          *** Some devices missing
> >>
> >>OK, we have three of four raid10 devices present. Should be fine. Let's
> >>mount it:
> >>
> >>mount -t btrfs /dev/vdb /test
> >>mount: wrong fs type, bad option, bad superblock on /dev/vdb,
> >>        missing codepage or helper program, or other error
> >>        In some cases useful info is found in syslog - try
> >>        dmesg | tail or so
> >>
> >>What's the kernel log got to say about it?
> >>
> >>dmesg | tail -n 4
> >>[  536.694363] device fsid 94af1f5d-6ad2-4582-ab4a-5410c410c455 devid 1
> >>transid 7 /dev/vdb
> >>[  536.700515] btrfs: disk space caching is enabled
> >>[  536.703491] btrfs: failed to read the system array on vdd
> >>[  536.708337] btrfs: open_ctree failed
> >>
> >>Same behavior persists whether I create a raid1 or raid10 array, and
> >>whether I create it as that raid level using mkfs.btrfs or convert it
> >>afterwards using btrfs balance start -dconvert=3Draidn -mconvert=3Draid=
n.
> >>Also persists even if I both scrub AND sync the array before shutting
> >>the machine down and removing one of the disks.
> >>
> >>What's up with this? This is a MASSIVE bug, and I haven't seen anybody
> >>else talking about it... has nobody tried actually failing out a disk
> >>yet, or what?
> >Hey Jim,
> >
> >keep calm and read the wiki ;)
> >https://btrfs.wiki.kernel.org/
> >
> >You need to mount with -o degraded to tell btrfs a disk is missing.
> >
> >
> >Joshua
> >
> >
>=20

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---     =20
                     headline (possibly apocryphal)                     =20

--EdRE1UL8d3mMOE6m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUsdB6VheFHXiqx3kAQLEgQ//bIfcnmg3QZNOtxTrgeb9G9ZitLNH+w3b
zXGW9JNgYTR9ZQnWOE3y+4Kb34evyZwgkNrvqdjeCiE+TLA2DBy4Uvfr3Zgsoqh3
GdHEcw12zqUF7vAN9F91czQ+e91ZonUOIMsKaW1cQ9AEs89VzGGs7q51rcHnx/W/
6OSfZPYzeKb7y1bAgd6XPB1cgJbe3a5xy8/mRr+j/a/GNZ1FyqEFDFHszNGq+w5E
hiCjpYBk5ruXwagsvBIkci/X3pDvZvqHisY8QejBbOs/AAlt65v29m3OE1nyemLX
B+ezssq98az7OTvWVx6BsZGiZdeD+7oTJ72IoeDSki/kwLDJ7snoG4vYFLl2Pnbx
c/3vAa5x57mz6ykq/Vv/Q1MKHvCUuq29YdVCFjeIYZtAviq8UztH2CiLA9sSed6z
A1FQxdfyIagSIre1XaBKhzgj8Pqw+wurWEY2noTTEcMIGcXg7BJ93nkv8zoERenQ
qA4qR0hdRCNjU77uYnWzMzCOCPOcIZfkZncPG5+CZOXQdyy82hpEHsm7BceDq2JC
9ulXXYNfBjNrFPv9a88oHRdOk7f4Z7w+K8XjQQyhoRwyPh4pGzay5G5MEIl+q6eL
LdDIr5WVJ7mRCjUgQPLRVAFzpqoKiYTzz60GiAUgLfwiJCwMd/lAoQKfHIWjAXCc
QEp+7hrp39c=
=oKaR
-----END PGP SIGNATURE-----

--EdRE1UL8d3mMOE6m--
