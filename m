Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:55211 "EHLO tur.go2.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752667AbdHNXOb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 19:14:31 -0400
Received: from moh2-ve1.go2.pl (moh2-ve1.go2.pl [193.17.41.186])
        by tur.go2.pl (Postfix) with ESMTP id 94CC5FC44EA
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 00:57:44 +0200 (CEST)
Received: from moh2-ve1.go2.pl (unknown [10.0.0.186])
        by moh2-ve1.go2.pl (Postfix) with ESMTP id A684444C27B
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 00:57:42 +0200 (CEST)
Received: from unknown (unknown [10.0.0.42])
        by moh2-ve1.go2.pl (Postfix) with SMTP
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Aug 2017 00:57:42 +0200 (CEST)
Date: Tue, 15 Aug 2017 00:57:40 +0200
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi du -s gives Inappropriate ioctl for device
Message-ID: <20170814225740.GK19638@pontus.sran>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi list,

I have some weird issue.

So, I have btrfs fs and some subvols, like that:
~ # btrfs sub list /mnt/red/
ID 260 gen 827956 top level 5 path @home
ID 261 gen 827926 top level 5 path @backup
ID 645 gen 827911 top level 5 path @svn
*snip*

and some snapshots on those subvols:
*snip*
ID 2501 gen 827894 top level 260 path @home/.snapshot/monthly_2017-05-01_05:30:01
ID 2603 gen 827894 top level 260 path @home/.snapshot/monthly_2017-06-01_05:30:01
ID 2604 gen 827927 top level 261 path @backup/.snapshot/monthly_2017-06-01_05:30:02
ID 2680 gen 827895 top level 260 path @home/.snapshot/monthly_2017-07-01_05:30:01
ID 2681 gen 827927 top level 261 path @backup/.snapshot/monthly_2017-07-01_05:30:01
ID 2734 gen 827895 top level 260 path @home/.snapshot/weekly_2017-07-22_04:20:01
ID 2735 gen 827905 top level 645 path @svn/.snapshot/weekly_2017-07-22_04:20:02
ID 2754 gen 827895 top level 260 path @home/.snapshot/weekly_2017-07-29_04:20:01
ID 2755 gen 827906 top level 645 path @svn/.snapshot/weekly_2017-07-29_04:20:01
ID 2763 gen 827896 top level 260 path @home/.snapshot/monthly_2017-08-01_05:30:01
*snip*

and... some issues:
~ # btrfs fi du -s /mnt/red/\@backup/
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for device

and it works for other subvols:
~ # btrfs fi du -s /mnt/red/\@svn/
     Total   Exclusive  Set shared  Filename
  52.22GiB    10.59MiB     4.13GiB  /mnt/red/@svn/

~ # btrfs fi du -s /mnt/red/\@home/
     Total   Exclusive  Set shared  Filename
   2.08TiB     4.54GiB   124.51GiB  /mnt/red/@home/

on the other hand, those values also look wrong (2.08TiB?):
~ # btrfs fi df /mnt/red/\@home/
Data, RAID1: total=448.00GiB, used=447.39GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=3.00GiB, used=2.02GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

~ # btrfs fi usage /mnt/red/\@home/
Overall:
    Device size:                   1.36TiB
    Device allocated:            902.06GiB
    Device unallocated:          493.21GiB
    Device missing:                  0.00B
    Used:                        898.81GiB
    Free (estimated):            247.22GiB      (min: 247.22GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:448.00GiB, Used:447.39GiB
   /dev/mapper/wd0       448.00GiB
   /dev/mapper/wd1       448.00GiB

Metadata,RAID1: Size:3.00GiB, Used:2.02GiB
   /dev/mapper/wd0         3.00GiB
   /dev/mapper/wd1         3.00GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
   /dev/mapper/wd0        32.00MiB
   /dev/mapper/wd1        32.00MiB

Unallocated:
   /dev/mapper/wd0       246.60GiB
   /dev/mapper/wd1       246.60GiB

~ # uname -sr
Linux 4.4.76

~ # btrfs --version
btrfs-progs v4.12

Whats wrong with one of my subvols? Whats wrong with space reported by fi du?


Best regards,
Piotr Szymaniak.

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEFSphDYLXjiCg60ZUQykCi/VzD2UFAlmSKuAACgkQQykCi/Vz
D2U4qA//ch/8O1mYYBHtwPDIL/DFM+NvJNEybzARO8bycpOuWpgH8H84TPISz46J
O2K79t6JzckywpJCnWoGAguwXYVD+FkBuQvHDfJcbSIjgSPtlVKuvxiVanvBHE3r
EOUe5uj1MzLfRrXooSm9P4MrxVr1SWPeqCkQkRs3+MIkBjq15VoP2N2pi4MkGVJN
OVYVqlE2LZudSQ6WoIjLw1o2nvjs4XB9AWFFs6aHyNRX+WF0RnJHPG7Xmt7OWIJe
QYrqjRAkuJqZq9GUrqF/zOTumzn5UvxlKxvc65+LJpveNCAk2LsxAgC94TkLeh7k
8RoYQZAlR1HRztWZJr9exREfcYO28ghSnLOx8gTQkFNINZb107j8XeKNL+iZHju9
6kkKmc6M35e39pQcAnq4GgtiqHodAQNZB69M5m5NFXv8vM6+S65IpwJ1annB3GGP
bL9CCWyEc+HtFspaDiGuUlg8VjABoGut9G8wc1puqqZ2ZsB9FNynhy6uR+SmKH2i
uiK+9EdOSObVDBa8RpFVBafbzRbm2y88nAVZEoFHnI1mRyckFp0Vszu49Vn11hQt
r2eUm1VMkG8TsmgAC/KzW1cYYUg0KU4/REavfVUhReJp6Gso7OicMXX8obs0OGXz
YxVjxpy3JWmInzc5RcegQ6+6tXC7I39SzeEU+BkEufSBMUdQtw0=
=g5ab
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
