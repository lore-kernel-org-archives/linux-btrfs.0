Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56584 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbcDVNSs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 09:18:48 -0400
Received: from thetick.localnet ([93.181.44.247]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MC7em-1b2MPE35bk-008qla for
 <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 15:18:44 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: random i/o error without error in dmesg
Date: Fri, 22 Apr 2016 15:17:57 +0200
Message-ID: <1892242.Gv7fI7HlO2@thetick>
In-Reply-To: <5339076.FcC2BAjqs5@thetick>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1538400.1KA1ySMAlU"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart1538400.1KA1ySMAlU
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Friday 22 April 2016
schrieb Marc Joliet <marcec@gmx.de>

>Hi
>
>FWIW, this sounds like what I've been seeing with dovecot.  In case it=
's
>relevant, I'll try to explain.
>
>After some uptime, I'll see log messages like this:
>
>Okt 26 12:05:46 thetick dovecot[467]: imap(marcec): Error: pread() fai=
led
>with file /home/marcec/.mdbox/mailboxes/BTRFS/dbox-Mails/dovecot.index=
.log:
>Input/output error
>
>Occasionally they go away by themselves, but usually I have to reboot =
to make
>them go away.  This happens when getmail attempts to fetch mail, which=
 fails
>due to the above error.  After the reboot getmail succeeds again.
>
>As in Szalma's case, btrfs-scrub never reports anything wrong.

FWIW, this still happens.  I tried various things, in order:

=2D set mmap_disable=3Dyes (as mentioned in [0] and [1]),
=2D stop mounting with compress=3Dlzo, and
=2D upgrade dovecot 2.2.19 to 2.2.23,

none of which helped.

I found very little on the web: [0] (in German) is fairly recent, but t=
he=20
error apparently just went away.  [1] is pretty old (2007) and the repo=
rter=20
was using unionfs.  I also found a russian forum entry [2], which relat=
es to=20
btrfs again, but if Google Translate is accurate enough, the user "solv=
ed" the=20
problem by using XFS instead.

My current attempt is to use the maildir mailbox format (instead of mdb=
ox) in=20
the hope that it doesn't trigger this bug, while reverting the changes =
above=20
(except for the dovecot upgrade).  It's "just" a home server, so I don'=
t=20
expect any major differences in performance (also since KMail probably =
uses=20
akonadi for searching).

[...]
>Anyway, the current state of the system is:
>
># uname -r
>4.1.9-gentoo-r1
># btrfs filesystem show /
>Label: 'MARCEC_ROOT'  uuid: 0267d8b3-a074-460a-832d-5d5fd36bae64
>        Total devices 1 FS bytes used 74.40GiB
>        devid    1 size 107.79GiB used 105.97GiB path /dev/sda1
>
>btrfs-progs v4.2.2
># btrfs filesystem df /
>Data, single: total=3D98.94GiB, used=3D72.30GiB
>System, single: total=3D32.00MiB, used=3D20.00KiB
>Metadata, single: total=3D7.00GiB, used=3D2.10GiB
>GlobalReserve, single: total=3D512.00MiB, used=3D0.00B
>
>The filesystem is mounted as (leaving out subvolume mounts which use t=
he same
>mount options):
>/dev/sda1 on / type btrfs (rw,noatime,compress=3Dlzo,ssd,discard,space=
_cache)

I have since obtained an old Mac Mini and have been using it as a home =
server=20
since early April, onto which I moved dovecot (using doveadm-sync(1)). =
 Its=20
current state is:

diefledermaus etc # uname -r
4.4.8-gentoo
diefledermaus etc # btrfs --version
btrfs-progs v4.5.1
diefledermaus etc # btrfs fi show
Label: 'MACROOT'  uuid: 8b2b0242-5816-4529-9e88-6c82ffff2eaf
        Total devices 1 FS bytes used 12.29GiB
        devid    1 size 251.20GiB used 15.09GiB path /dev/sda3

Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
        Total devices 1 FS bytes used 797.14GiB
        devid    1 size 976.56GiB used 819.12GiB path /dev/sdb2

diefledermaus etc # btrfs fi df /
Data, single: total=3D12.01GiB, used=3D11.38GiB
System, DUP: total=3D40.00MiB, used=3D16.00KiB
Metadata, DUP: total=3D1.50GiB, used=3D926.77MiB
GlobalReserve, single: total=3D288.00MiB, used=3D0.00B
diefledermaus etc # mount | grep root
/dev/sda3 on / type btrfs=20
(rw,noatime,compress=3Dlzo,space_cache,autodefrag,subvolid=3D257,subvol=
=3D/rootfs)
/dev/sda3 on /mnt/rootfs type btrfs=20
(rw,noatime,compress=3Dlzo,space_cache,autodefrag,subvolid=3D5,subvol=3D=
/)

Note that the file system was *freshly* created using btrfs-progs 4.3.1=
 and=20
gentoo-sources 4.1.15-r1 (the current stable versions in Gentoo; -r1 is=
 a=20
Gentoo-specific revision number).

References:

[0] https://debianforum.de/forum/viewtopic.php?f=3D27&t=3D157374
[1] http://www.dovecot.org/list/dovecot/2007-November/026551.html
[2] https://www.linux.org.ru/forum/general/11598803

=2D----------------------------------------------------------

I'd like to add that dovecot is the *only* software I use that has this=
 sort=20
of problem with btrfs -- and it's *only* the transaction *.log files; t=
he few=20
times the index files had problems, they were automatically fixed.  How=
ever,=20
once the problem shows up, no other software can read the files, either=
 (e.g.,=20
cat fails).  Furthermore, restarting dovecot doesn't help, only rebooti=
ng,=20
i.e., unmounting the entire file system, not just the subvolume the mai=
lbox=20
resides on (as discussed previously in this sub-thread).  So I'm not su=
re=20
what, exactly, is at fault here: dovecot, btrfs, or both?

So given all the above, does anybody have any further suggestions on ho=
w to=20
proceed?  Because regardless of whether the switch to maildir ends up=20=

resolving the issue for me, something is going wrong.  I'm thinking of =
filing=20
a bug report with dovecot; perhaps none of their devs test with btrfs?

Greetings
=2D-=20
Marc Joliet
=2D-
"People who think they know everything really annoy those of us who kno=
w we
don't" - Bjarne Stroustrup

--nextPart1538400.1KA1ySMAlU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXGiSzAAoJEL/Q5oYsiHj0Y68P/jRkqIdiVyc8F1t4v/FtiRx9
R6VkhD+1rGbGnCVXCc3iskrwbbLB/1DlOF32X2cLnP2zVKby9oEoOXshp2q6BIXW
UvflpvUe/VDiwg9YNM3q34iHMNEcljA3eZArcxNhfYgfyLhwGVZKodzBJdi4azvG
HIOfBOvkC1ZZKNeNzszO6uXWAZiMH+N12BlGi6c4zdfYqucj3oPzs/MSxFSvIOrR
AImVHm5Cn/VCeAUPvPEjzveIDDclJPf18itvX/aMOEXdgc2peWtRukzDml6JsrrW
QVstquidZHpoX2oF3vTz9qiOffaukCO/gUcLtys8IysKxrDw8f5BAYNH2iaaRi5h
ocw/VrTUi9Z+C+oDe9Vi6CSnznzkoORSks9UoeHAsx7l5z0r505XMqaXr1jE8ioO
gtnBKHT//YdGB26CdZ7gdO/5+zw5s97DP+lCWSZyiVuE5JrbarhUPOOR/731tJcV
ZqbN2JOlPqAzGtOYrZ8TDbL6Fjy7EkElU5UV0J1PxNeiZzXhHZaXcw75NVR/DBHc
uujuw3RudvD+EzL+87y4kGwbFBKmLVJYuWolJqz/DkRmjozoANfVSTBSFqxghFpp
L1iNMHaAacTxmF3eVgCJUndo3FrQDpubIwnK+mIGGnsHV5lwuLAWFonHI4teG3p3
ehf8opZgM6gBF8X+eyVo
=VKbV
-----END PGP SIGNATURE-----

--nextPart1538400.1KA1ySMAlU--

