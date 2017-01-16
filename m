Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:55574 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdAPLmV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 06:42:21 -0500
Received: from localhost (dra38-7-88-179-85-77.fbx.proxad.net [88.179.85.77])
        by smtp.webfaction.com (Postfix) with ESMTP id 5EC91219CF50
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jan 2017 11:10:35 +0000 (UTC)
From: Christoph Groth <christoph@grothesque.org>
To: linux-btrfs@vger.kernel.org
Subject: Unocorrectable errors with RAID1
Date: Mon, 16 Jan 2017 12:10:30 +0100
Message-ID: <87o9z7dzvd.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi,

I=E2=80=99ve been using a btrfs RAID1 of two hard disks since early 2012=20
on my home server.  The machine has been working well overall, but=20
recently some problems with the file system surfaced.  Since I do=20
have backups, I do not worry about the data, but I post here to=20
better understand what happened.  Also I cannot exclude that my=20
case is useful in some way to btrfs development.

First some information about the system:

root@mim:~# uname -a
Linux mim 4.6.0-1-amd64 #1 SMP Debian 4.6.3-1 (2016-07-04) x86_64=20
GNU/Linux
root@mim:~# btrfs --version
btrfs-progs v4.7.3
root@mim:~# btrfs fi show
Label: none  uuid: 2da00153-f9ea-4d6c-a6cc-10c913d22686
	Total devices 2 FS bytes used 345.97GiB
	devid    1 size 465.29GiB used 420.06GiB path /dev/sda2
	devid    2 size 465.29GiB used 420.04GiB path /dev/sdb2

root@mim:~# btrfs fi df /
Data, RAID1: total=3D417.00GiB, used=3D344.62GiB
Data, single: total=3D8.00MiB, used=3D0.00B
System, RAID1: total=3D40.00MiB, used=3D68.00KiB
System, single: total=3D4.00MiB, used=3D0.00B
Metadata, RAID1: total=3D3.00GiB, used=3D1.35GiB
Metadata, single: total=3D8.00MiB, used=3D0.00B
GlobalReserve, single: total=3D464.00MiB, used=3D0.00B
root@mim:~# dmesg | grep -i btrfs
[    4.165859] Btrfs loaded
[    4.481712] BTRFS: device fsid=20
2da00153-f9ea-4d6c-a6cc-10c913d22686 devid 1 transid 2075354=20
/dev/sda2
[    4.482025] BTRFS: device fsid=20
2da00153-f9ea-4d6c-a6cc-10c913d22686 devid 2 transid 2075354=20
/dev/sdb2
[    4.521090] BTRFS info (device sdb2): disk space caching is=20
enabled
[    4.628506] BTRFS info (device sdb2): bdev /dev/sdb2 errs: wr=20
0, rd 0, flush 0, corrupt 3, gen 0
[    4.628521] BTRFS info (device sdb2): bdev /dev/sda2 errs: wr=20
0, rd 0, flush 0, corrupt 3, gen 0
[   18.315694] BTRFS info (device sdb2): disk space caching is=20
enabled

The disks themselves have been turning for almost 5 years by now,=20
but their SMART health is still fully satisfactory.

I noticed that something was wrong because printing stopped to=20
work.  So I did a scrub that detected 0 "correctable errors" and 6=20
"uncorrectable" errors.  The relevant bits from kern.log are:

Jan 11 11:05:56 mim kernel: [159873.938579] BTRFS warning (device=20
sdb2): checksum error at logical 180829634560 on dev /dev/sdb2,=20
sector 353143968, root 5, inode 10014144, offset 221184, length=20
4096, links 1 (path: usr/lib/x86_64-linux-gnu/libcups.so.2)
Jan 11 11:05:57 mim kernel: [159874.857132] BTRFS warning (device=20
sdb2): checksum error at logical 180829634560 on dev /dev/sda2,=20
sector 353182880, root 5, inode 10014144, offset 221184, length=20
4096, links 1 (path: usr/lib/x86_64-linux-gnu/libcups.so.2)
Jan 11 11:28:42 mim kernel: [161240.083721] BTRFS warning (device=20
sdb2): checksum error at logical 260254629888 on dev /dev/sda2,=20
sector 508309824, root 5, inode 9990924, offset 6676480, length=20
4096, links 1 (path:=20
var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64=
_Packages)
Jan 11 11:28:42 mim kernel: [161240.235837] BTRFS warning (device=20
sdb2): checksum error at logical 260254638080 on dev /dev/sda2,=20
sector 508309840, root 5, inode 9990924, offset 6684672, length=20
4096, links 1 (path:=20
var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64=
_Packages)
Jan 11 11:37:21 mim kernel: [161759.725120] BTRFS warning (device=20
sdb2): checksum error at logical 260254629888 on dev /dev/sdb2,=20
sector 508270912, root 5, inode 9990924, offset 6676480, length=20
4096, links 1 (path:=20
var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64=
_Packages)
Jan 11 11:37:21 mim kernel: [161759.750251] BTRFS warning (device=20
sdb2): checksum error at logical 260254638080 on dev /dev/sdb2,=20
sector 508270928, root 5, inode 9990924, offset 6684672, length=20
4096, links 1 (path:=20
var/lib/apt/lists/ftp.fr.debian.org_debian_dists_unstable_main_binary-amd64=
_Packages)

As you can see each disk has the same three errors, and there are=20
no other errors.  Random bad blocks cannot explain this situation.=20
I asked on #btrfs and someone suggested that these errors are=20
likely due to RAM problems.  This may indeed be the case, since=20
the machine has no ECC.  I managed to fix these errors by=20
replacing the broken files with good copies.  Scrubbing shows no=20
errors now:

root@mim:~# btrfs scrub status /
scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
	scrub started at Sat Jan 14 12:52:03 2017 and finished=20
	after 01:49:10
	total bytes scrubbed: 699.17GiB with 0 errors

However, there are further problems.  When trying to archive the=20
full filesystem I noticed that some files/directories cannot be=20
read.  (The problem is localized to some ".git" directory that I=20
don=E2=80=99t need.)  Any attempt to read the broken files (or to delete=20
them) does not work:

$ du -sh .git
du: cannot access=20
'.git/objects/28/ea2aae3fe57ab4328adaa8b79f3c1cf005dd8d': No such=20
file or directory
du: cannot access=20
'.git/objects/28/fd95a5e9d08b6684819ce6e3d39d99e2ecccd5': Stale=20
file handle
du: cannot access=20
'.git/objects/28/52e887ed436ed2c549b20d4f389589b7b58e09': Stale=20
file handle
du: cannot access '.git/objects/info': Stale file handle
du: cannot access '.git/objects/pack': Stale file handle

During the above command the following lines were added to=20
kern.log:

Jan 16 09:41:34 mim kernel: [132206.957566] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.957924] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.958505] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.958971] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.959534] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.959874] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.960523] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15
Jan 16 09:41:34 mim kernel: [132206.960943] BTRFS critical (device=20
sda2): corrupt leaf, slot offset bad: block=3D192561152,root=3D1,=20
slot=3D15

So I tried to repair the file system by running "btrfs check=20
=2D-repair", but this doesn=E2=80=99t work:

(initramfs) btrfs --version
btrfs-progs v4.7.3
(initramfs) btrfs check --repair /dev/sda2
UUID: ...
checking extents
incorrect offsets 2527 2543
items overlap, can't fix
cmds-check.c:4297: fix_item_offset: Assertion `ret` failed.
btrfs[0x41a8b4]
btrfs[0x41a8db]
btrfs[0x42428b]
btrfs[0x424f83]
btrfs[0x4259cd]
btrfs(cmd_check+0x1111)[0x427d6d]
btrfs(main+0x12f)[0x40a341]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7fd98859d2b1]
btrfs(_start+0x2a)[0x40a37a]

I now have the following questions:

* So scrubbing is not enough to check the health of a btrfs file=20
  system?  It=E2=80=99s also necessary to read all the files?

* Any ideas what coud have caused the "stale file handle" errors?=20
  Is there any way to fix them?  Of course RAM errors can in=20
  principle have _any_ consequences, but I would have hoped that=20
  even without ECC RAM it=E2=80=99s practically inpossible to end up with=20
  an unrepairable file system.  Perhaps I simply had very bad=20
  luck.

* I believe that btrfs RAID1 is considered reasonably safe for=20
  production use by now.  I want to replace that home server with=20
  a new machine (still without ECC).  Is it a good idea to use=20
  btrfs for the main file system?  I would certainly hope so! :-)

Thanks for your time,
Christoph

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh8qiYACgkQw/FH9ZgP
NTVmQQ/+OTUOjO12tAxeL9d7WcPQSFE+7PtAhFrtxjKjymEZJfRsXOch8d4o30o4
GJ/p6xPXq4YNJt1J6krUZwaxlmEepsBx8xPYO8VBf90Shhi4pKFziDtnBkplIDmZ
Klqw88fEbwGKnPp1iFA4AIc7ZA8gxZ4Zk5wmk3xVTQkhunMYs3fvk2sZ3pVQCnPk
fYj3y/FQm+tyjzohB2n4kxdTDWPQrxwvGQU1zZtlqXmG9SF4FNghBxTuXuQ5kv7A
Mpa1eSQFw6s1/DNhIRicNZDUP29HHkqei37JDTBz4uQBbJb+C9nT1XkWVEr9P6lW
YgLVUbytp38Cdcwye7zYLgD0yr55mU44l/mz0VmD+D2QZB57uvNPDmr6ppCf77BJ
MAR8SkH+O6anjax3/Q0cSz6orbcLEjC+f/T/EALfn9bH6vnH2o8kH3iwZc0MlheG
2q5G2hx71Voe0/B0IwLMsb/biO346oQL0cNXE9E6LrrGqlZPn+QmDwjHMpSYe5Ww
bGvwMzNvEPPd5nzkQD8wJc6Jq0ls1PThNeUpPU0hO30G4mVux2R+3VJTdgTITYKs
5C3iIFmfURi3d2wwwghphy7zQVYZBSlpve51Xs0nzK83ZWjDmyhPaFAniM4y8P/n
ARKIgAdx8dMDymVsEvGMgESZ43553ZrE/phN4uMPQs7fQ1ZzP8k=
=chst
-----END PGP SIGNATURE-----
--=-=-=--
