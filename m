Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63983 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab3JMWB2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Oct 2013 18:01:28 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so2396059bkb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Oct 2013 15:01:26 -0700 (PDT)
From: Marius Kittelmann <mkaayde@gmail.com>
Content-Type: multipart/signed; boundary="Apple-Mail=_134D5D35-91B2-4419-9F88-462DE70C7F3B"; protocol="application/pgp-signature"; micalg=pgp-sha512
Subject: Can't mount btrfs - bad tree block start
Message-Id: <6999B76B-9A12-4C6D-960C-3D44FF7B750C@gmail.com>
Date: Mon, 14 Oct 2013 00:01:23 +0200
To: btrfs list <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_134D5D35-91B2-4419-9F88-462DE70C7F3B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello,

after a power outage, I can't mount one of my btrfs fs anymore.
The mount output is:

[root@absolut ~]# mount /dev/mapper/wdb
mount: wrong fs type, bad option, bad superblock on /dev/mapper/wdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

dmesg output:

[ 4675.304832] device fsid cdb5080d-8aa3-4938-ad38-f4ff4c6efa7c devid 1 =
transid 212017 /dev/mapper/wdb
[ 4675.305768] btrfs: disk space caching is enabled
[ 4675.789190] btrfs bad tree block start 6226359148539426339 =
2665114812416
[ 4675.798276] btrfs bad tree block start 3867827444190911355 =
2665114812416
[ 4675.833689] btrfs: open_ctree failed

If I try mounting with '-o ro,recovery', dmesg gives me:

[ 4820.176934] device fsid cdb5080d-8aa3-4938-ad38-f4ff4c6efa7c devid 1 =
transid 212017 /dev/mapper/wdb
[ 4820.178198] btrfs: enabling auto recovery
[ 4820.178208] btrfs: disk space caching is enabled
[ 4820.224417] btrfs bad tree block start 6226359148539426339 =
2665114812416
[ 4820.224739] btrfs bad tree block start 3867827444190911355 =
2665114812416
[ 4820.225072] btrfs bad tree block start 6226359148539426339 =
2665114812416
[ 4820.225418] btrfs bad tree block start 3867827444190911355 =
2665114812416
[ 4820.683797] btrfs bad tree block start 6226359148539426339 =
2665114812416
[ 4820.684527] btrfs bad tree block start 3867827444190911355 =
2665114812416
[ 4820.698474] parent transid verify failed on 936925569024 wanted =
212015 found 212017
[ 4820.702996] parent transid verify failed on 936925569024 wanted =
212015 found 212017
[ 4820.703017] btrfs: failed to read tree root on dm-8
[ 4820.713317] parent transid verify failed on 936932843520 wanted =
212014 found 212016
[ 4820.716356] parent transid verify failed on 936932843520 wanted =
212014 found 212016
[ 4820.716377] btrfs: failed to read tree root on dm-8
[ 4820.799898] btrfs: open_ctree failed

btrfs-image produces the following output and the output file is empty:

[root@absolut ~]# btrfs-image -c9 -t4 /dev/mapper/wdb wdb-image
Check tree block failed, want=3D2665114812416, have=3D6226359148539426339
Check tree block failed, want=3D2665114812416, have=3D6226359148539426339
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
read block failed check_tree_block
Couldn't setup device tree
Open ctree failed
create failed (Success)

System info:

Kernel: 3.10.13-1-lts
btrfs-progs from arch-linux repo (btrfs-progs 0.20rc1.3-1)
FS is inside a dm-crypt on a 3TB drive

Is there any chance to recover from these errors or restore some of the =
files?

Any help would be appreciated.
Thanks,

Marius

--Apple-Mail=_134D5D35-91B2-4419-9F88-462DE70C7F3B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJSWxg0AAoJEBmvzEpGP5mlKR0P/1WYT52vvJK+SMi0icHcPgqg
R+8q6zZPdsJpXQEDq1uuhlq75oEjGUdeOQPFwI4hek2giK5fymyEhufFmKOoG9A1
FE+K5Zz4p/6bc6M1lZ9TxrvTgPqIyXgbIO4Og82GKdZAga4obFEa/cXN2kypwiN0
Lfb4EsRJAcYJERNcDyNwwYVVKIQM7R35e+4BSgl/UvIrpctl8Uf+bbEW4wgey6uN
k1rYdL4KAKTomOza9LhA3s3h/fnNUpioc7JLIUI+9UMp4WdcR19SGm9eCu3ncblk
hOLO4U0rhLgjS/alpJFGf0sMB2ZrBSdOCBWM+IWOW8DUgnpgfC0w+nlDXpcmG3UN
6lmZfovC+Q9KvK187mWS4JEYtOxH0E6gv6EaKtqgg0oENi3heVm+9rgO0ALluveK
P50LDBVODBgUDcEw8W/qtfQXMzu3+9VP6ZTd3BEuP/EyYpWTJYqeMCVfpJhWg3Y0
6cAhA8aUBcYHZ95OuKanBG8NM3Z20t5o51acUSZuGwSre+U2i+9zVmWrU9wzKyaX
+8eNkoG3BGsXm+g7iJHOChVx3VBrmCqBlH0rmMRxL1ihtT0irdfjHv5aWCddLFq1
K3ldlPzSxaK2GmpI9aatZYZ7ZivZzwiPld5zhAd1jiKRkjQt3/+X50CfMlfJs2I2
lRMdM+ayy6hAnTyDfwPl
=ToPX
-----END PGP SIGNATURE-----

--Apple-Mail=_134D5D35-91B2-4419-9F88-462DE70C7F3B--
