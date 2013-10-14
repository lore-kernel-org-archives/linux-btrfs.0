Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35378 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3JNJ7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 05:59:44 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so2457657bkj.5
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 02:59:42 -0700 (PDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_6F40BED6-338E-44DE-8AE3-CF58CCC8F019"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Can't mount btrfs - bad tree block start
From: Marius Kittelmann <mkaayde@gmail.com>
In-Reply-To: <525B4603.7030208@cn.fujitsu.com>
Date: Mon, 14 Oct 2013 11:59:41 +0200
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <AEA5C8A0-8458-4B88-A2FB-BB6AAAA1E880@gmail.com>
References: <6999B76B-9A12-4C6D-960C-3D44FF7B750C@gmail.com> <525B4603.7030208@cn.fujitsu.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_6F40BED6-338E-44DE-8AE3-CF58CCC8F019
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


On 14.10.2013, at 03:16, Wang Shilong <wangsl.fnst@cn.fujitsu.com> =
wrote:

> On 10/14/2013 06:01 AM, Marius Kittelmann wrote:
>> Hello,
>>=20
>> after a power outage, I can't mount one of my btrfs fs anymore.
>> The mount output is:
>>=20
>> [root@absolut ~]# mount /dev/mapper/wdb
>> mount: wrong fs type, bad option, bad superblock on /dev/mapper/wdb,
>>        missing codepage or helper program, or other error
>>=20
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail or so.
>>=20
>> dmesg output:
>>=20
>> [ 4675.304832] device fsid cdb5080d-8aa3-4938-ad38-f4ff4c6efa7c devid =
1 transid 212017 /dev/mapper/wdb
>> [ 4675.305768] btrfs: disk space caching is enabled
>> [ 4675.789190] btrfs bad tree block start 6226359148539426339 =
2665114812416
>> [ 4675.798276] btrfs bad tree block start 3867827444190911355 =
2665114812416
>> [ 4675.833689] btrfs: open_ctree failed
>>=20
>> If I try mounting with '-o ro,recovery', dmesg gives me:
>>=20
>> [ 4820.176934] device fsid cdb5080d-8aa3-4938-ad38-f4ff4c6efa7c devid =
1 transid 212017 /dev/mapper/wdb
>> [ 4820.178198] btrfs: enabling auto recovery
>> [ 4820.178208] btrfs: disk space caching is enabled
>> [ 4820.224417] btrfs bad tree block start 6226359148539426339 =
2665114812416
>> [ 4820.224739] btrfs bad tree block start 3867827444190911355 =
2665114812416
>> [ 4820.225072] btrfs bad tree block start 6226359148539426339 =
2665114812416
>> [ 4820.225418] btrfs bad tree block start 3867827444190911355 =
2665114812416
>> [ 4820.683797] btrfs bad tree block start 6226359148539426339 =
2665114812416
>> [ 4820.684527] btrfs bad tree block start 3867827444190911355 =
2665114812416
>> [ 4820.698474] parent transid verify failed on 936925569024 wanted =
212015 found 212017
>> [ 4820.702996] parent transid verify failed on 936925569024 wanted =
212015 found 212017
>> [ 4820.703017] btrfs: failed to read tree root on dm-8
>> [ 4820.713317] parent transid verify failed on 936932843520 wanted =
212014 found 212016
>> [ 4820.716356] parent transid verify failed on 936932843520 wanted =
212014 found 212016
>> [ 4820.716377] btrfs: failed to read tree root on dm-8
>> [ 4820.799898] btrfs: open_ctree failed
>>=20
>> btrfs-image produces the following output and the output file is =
empty:
>>=20
>> [root@absolut ~]# btrfs-image -c9 -t4 /dev/mapper/wdb wdb-image
>> Check tree block failed, want=3D2665114812416, =
have=3D6226359148539426339
>> Check tree block failed, want=3D2665114812416, =
have=3D6226359148539426339
>> Check tree block failed, want=3D2665114812416, =
have=3D3867827444190911355
>> Check tree block failed, want=3D2665114812416, =
have=3D3867827444190911355
>> Check tree block failed, want=3D2665114812416, =
have=3D3867827444190911355
>> read block failed check_tree_block
>> Couldn't setup device tree
>> Open ctree failed
>> create failed (Success)
>>=20
>> System info:
>>=20
>> Kernel: 3.10.13-1-lts
>> btrfs-progs from arch-linux repo (btrfs-progs 0.20rc1.3-1)
>> FS is inside a dm-crypt on a 3TB drive
>>=20
>> Is there any chance to recover from these errors or restore some of =
the files
> Firstly, try to update your btrfs-progs:
>=20
> git pull http://github.com/btrfs-progs.git integration-20131008
>=20
> then, you can try to recover bad supers(if existed):
>=20
> btrfs rescue super-recover -v /dev/mapper/wdb

The superblocks seem fine:

[mkaay@absolut btrfsprogs]$ sudo ./btrfs rescue super-recover -v =
/dev/mapper/wdb
All Devices:
        Device: id =3D 1, name =3D /dev/mapper/wdb

Before Recovering:
        [All good supers]:
                device name =3D /dev/mapper/wdb
                superblock bytenr =3D 65536

                device name =3D /dev/mapper/wdb
                superblock bytenr =3D 67108864

                device name =3D /dev/mapper/wdb
                superblock bytenr =3D 274877906944

        [All bad supers]:

All supers are valid, no need to recover

> If we recover bad supers successfully, but we can still not mount.
> (Or all the supers have been valid). Try:
>=20
> btrfs-zero-log  /dev/mapper/wdb

Unfortunately btrfs-zero-log outputs the following:

[mkaay@absolut btrfsprogs]$ sudo ./btrfs-zero-log /dev/mapper/wdb=20
Check tree block failed, want=3D2665114812416, have=3D6226359148539426339
Check tree block failed, want=3D2665114812416, have=3D6226359148539426339
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
Check tree block failed, want=3D2665114812416, have=3D3867827444190911355
read block failed check_tree_block
Couldn't setup device tree

Is there anything else I could try?

> See whether helps.
>=20
> Hoping it will help,
>=20
> Thanks,
> Wang
>>=20
>> Any help would be appreciated.
>> Thanks,
>>=20
>> Marius
>=20


--Apple-Mail=_6F40BED6-338E-44DE-8AE3-CF58CCC8F019
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJSW8CNAAoJEBmvzEpGP5ml/1EP/RmZyeFNXMa8Mtm3Ev2EV/uj
7/bTkVDFBD52JDkG81n8MMwI7bU+Z0yMEtb1ujlRQsOu5FwYfVUHy9MwRMwgixAH
/oMwjQt7GzclyllNWeFIKfiuvcOm8Y7t71+2MhzG8oWgUQe9ML91+/RHL9zF1eTE
P8uQ/IWp2tSG3x5uiJuQZ+0nhg8Yrg6gpf1ubO5GmhSHBUPnXQGfR5dgn67EWPa2
OV2/+OpWRcyr6f9FZPpUct0JfquMoyB2ttjQztP4l9yNBvIi2PcYrVeyHphiaUBM
3/h72cXeM6XuBmd+kjp7iZZ5SFP9UScJtSZd3kX5CJnuDv1Eh+S44ODzHh6Q8Xic
ttEE7yE1s9KOceclO/jIBte1t+J17wCRAfgTisiuB3khWAzxmpZN8bUJ3ZNfMQ3a
dfS5+2cAZwo+07fFMGU0khjyKTIOELesgHcyfk/PMC4kQR418UnbnFRuPIX6xxsT
0gOt+am7/meI11lQ49WXEL6rLmfUiuN2C4PISz1Q7+GoR1nWMLbMdglNH3E8GUgv
sfP0Ib1IsY7mtiMtv2Ly6jZjs9hLTIZI8HVBQjoWHxsniAxP1y7iF46CXO3YFZxF
s8gXLcOED+GQp/bODaXrL7fSCmz7rvjP2S594fM1Q9lz10i6t5lOFgHdy0Ac2qHL
yWnxX5IM5C/MR0xibvAY
=CV4x
-----END PGP SIGNATURE-----

--Apple-Mail=_6F40BED6-338E-44DE-8AE3-CF58CCC8F019--
