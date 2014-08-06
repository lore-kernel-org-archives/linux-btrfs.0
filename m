Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ngcobalt08.manitu.net ([217.11.48.108]:36550 "EHLO
	ngcobalt08.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHFN1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 09:27:36 -0400
Received: from lapbok.localnet (unknown [46.189.32.222])
	(Authenticated sender: jseifert)
	by ngcobalt08.manitu.net (Postfix) with ESMTPSA id 68B933A8074
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Aug 2014 15:20:08 +0200 (CEST)
From: Justus Seifert <justus.seifert@cloudandheat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Unrecoverable errors when the btrfs file system was modified outside the running OS
Date: Wed, 06 Aug 2014 15:19:50 +0200
Message-ID: <1740245.62hL253geB@lapbok>
In-Reply-To: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
References: <CAOgBZNo0hvmCJhm4Oqnnavkt8qyafLHk6eMQ5uPzpHkb4OtbCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1509564.NocDkyUSB6"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart1509564.NocDkyUSB6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Monday 04 August 2014 01:29:49 you wrote:
> Hello,
>=20
> I just had a very frustrating experience with btrfs, which I was only=

> able to resolve by rolling back to ext4 using the subvol btrfs-conver=
t
> created. The same type of situation occurred before when I was using
> the ext file system and the result was far less disastrous.
>=20
> The source of problem came from the fact that I have a Windows and
> Ubuntu 14.04 dual-boot setup and within Windows I also use VirtualBox=

> to run the same Ubuntu with rawdisk. Today I updated Ubuntu to a new
> kernel within VirtualBox. At this point, I would usually shutdown
> VirtualBox before I let my machine go to hibernation. However, this
> time I forgot. And when the machine started up, it went directly into=

> Ubuntu (because grub was updated and to avoid issues my VirtualBox
> setup didn't allow Ubuntu to see my Windows partitions). I did a
> grub-udpate, and rebooted back to Windows, where my VirtualBox was
> still up and running fine. The tragedy happened when I now shut down
> Ubuntu and VirtualBox. The btrfs file system was totally corrupted. I=

> tried various combinations ro, recovery, nospace_cache, and
> clear_cache mount options, and it wouldn't mount. dmesg showed some
> "transid verify failed", "open_ctree failed" error messages. btrfs
> restore only retrieved three files.. btrfsck --repair and
> btrfs-zero-log didn't help either.
>=20
> To my very surprise, btrfs-convert -r was able to use the subvol it
> created to roll back to ext4. But had I not converted from ext4 to
> btrfs, this would be an unrecoverable situation. Whether or not I hav=
e
> backups is a separate issue, being able to recover at least "somewhat=
"
> in this situation seems to be a desired feature for any file system.
>=20
> Roc


btrfs is CoW
stale metadata means stale block info
stale block info means no idea where the files are on disk and no idea =
where=20
free blocks are
btrfs does not know, that it does not know, where to read and where to =
write,=20
it assumes the metadata cached in ram is correct and just reads and wri=
tes to=20
the disk where it sees fit.
this is disastrous if the location of files changes
cow means the location of files and metadata changes with _every single=
 write_=20
!

ext4 is not CoW
if you do not delete, grow, shrink or create files =E2=80=93 only inpla=
ce edits or=20
small appeds that do not allocate aditional blocks, then the location o=
f the=20
files on disk does not change.
this is often the case for most files and metadata on a root filesystem=
.
thus it is no surprise at all that the consequences of using stale meta=
data=20
for a filesystem that was mounted elsewhere differs dramatically betwee=
n ext4=20
and btrfs.

please keep in mind that all filesystems assume that the ram is a safe =
place to=20
keep metadataduring runtime,  since reading all the required metadata a=
ll the=20
time would be a huge performance brake for modern filesystems.  old fil=
esystems=20
might be different.

if you want the metadata not to change then try a read-only filesystem =
for root=20
for a while.  squashfs is the default root fs for openwrt and is ro.

sry kmail ate my draft for this mail once and i was too lazy to retype =
it=20
completely thus only simple grammar and no spell checks.

if you are interested in more details, ask detailed questions.  duncan =
might=20
also help you if you ask him.

regards
justus seifert
--nextPart1509564.NocDkyUSB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJT4it2AAoJELFJh75Z+IvIDH0P/Rdt5I9fuRWlxHfRKQWPPp+0
olywSPrnGgP7Ora8njpUzrH0gyAslHVRASoUWLa1Dsl88rE+3bJApES7fiK+fUTQ
Yv9kQbDtbdHErFlFHzT/+nalTPDxxKI5JkWmomfzqAR4aSXUrxt0xc5ZMI0XkMIc
GoI0cF6wZ11SRDcYqVf/dZICr8Jc7U3a4LFHXxR8e6M0VsA5lAGSEkjZDTChpAff
yolnsEPrDgZ9ikwqSTUUQJl8UXo1JX2Ty+WYRMFcnSgCZU2tCjwbK6jvEFVCsgxR
2qWZK5w03dX0uNxw90JxBkGy9f3kThUkJira95UZoFz5UlrOhGmxe2b6SH7Eml91
Y8w/5B0IFsoSt7ux2rp5B5i8r9COOohEtag4mEyQVYDZLs38Xy+f6bz8Fd7QY2vk
t3NYft+ZUPOYjfyQPcBlJH6TpqHU6XSt8At5yPZInLSaFLV0yskBU5bIiC8Brfap
6g5E6f4gvr4T3KrtkHAviY5FEBFZkDWeTEPvBjcIxj5inSyrxH6a8U9dAOTQJc0r
caR5Vk8gwPiBYiBbclR51EzKHNRJISUhAQnqf0RtYXGvMg39/j6VTYFoO5j2Pniu
c4s7964e2LSFURsFO/auhuooaBtvS0jB6xjm2z8sPlHhjISwh+AHS7Cr8/nPG0YN
jQm29IVX3vsL0GQIloAy
=Neip
-----END PGP SIGNATURE-----

--nextPart1509564.NocDkyUSB6--

