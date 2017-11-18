Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934035AbdKRAQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 19:16:53 -0500
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value
 -17
To: Marc MERLIN <marc@merlins.org>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
 <20171117073046.ehdlw5essf7lhw7k@merlins.org>
 <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
 <20171117155009.po4wxaqlyqnzqpom@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <46fbd8c2-65f1-b281-7e17-2253f6dc3aa9@gmx.com>
Date: Sat, 18 Nov 2017 08:16:32 +0800
MIME-Version: 1.0
In-Reply-To: <20171117155009.po4wxaqlyqnzqpom@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="k9AhJ9Ikcw1A2ocN7fvmj9OkNKdjxmMK3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k9AhJ9Ikcw1A2ocN7fvmj9OkNKdjxmMK3
Content-Type: multipart/mixed; boundary="09C1wWjSGkdAHC0QsMNugwrSKNlJLHP4P";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <46fbd8c2-65f1-b281-7e17-2253f6dc3aa9@gmx.com>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value
 -17
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
 <20171117073046.ehdlw5essf7lhw7k@merlins.org>
 <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
 <20171117155009.po4wxaqlyqnzqpom@merlins.org>
In-Reply-To: <20171117155009.po4wxaqlyqnzqpom@merlins.org>

--09C1wWjSGkdAHC0QsMNugwrSKNlJLHP4P
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 23:50, Marc MERLIN wrote:
> On Fri, Nov 17, 2017 at 04:12:07PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 15:30, Marc MERLIN wrote:
>>> Here's the whole output:
>>> gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 191980=
5647
>>
>> Sorry, I missed "-C10" parameter for grep.
> =20
>                 generation 2231977 transid 2237084 size 64 nbytes 0
>                 block group 0 mode 40755 links 1 uid 33 gid 33 rdev 0
>                 sequence 0 flags 0x1710(none)
>                 atime 1510290002.516060162 (2017-11-09 21:00:02)
>                 ctime 1510477350.88506455 (2017-11-12 01:02:30)
>                 mtime 1510477350.88506455 (2017-11-12 01:02:30)
>                 otime 1510290002.516060162 (2017-11-09 21:00:02)
>         item 26 key (1919785864 INODE_REF 1919785862) itemoff 14683 ite=
msize 12
>                 index 2 namelen 2 name: 00
>         item 27 key (1919785864 DIR_ITEM 2591417872) itemoff 14637 item=
size 46
>                 location key (1919805647 INODE_ITEM 0) type FILE
>                 transid 2231988 data_len 0 name_len 16
>                 name: 1955-capture.jpg

OK, this DIR_ITEM matches with INODE_REF.
So btrfs-check should only need to insert DIR_INDEX for it.

>         item 28 key (1919785864 DIR_ITEM 3406016191) itemoff 14591 item=
size 46
>                 location key (1919805657 INODE_ITEM 0) type FILE
>                 transid 2231988 data_len 0 name_len 16
>                 name: 1956-capture.jpg
>         item 29 key (1919785864 DIR_INDEX 1957) itemoff 14575 itemsize =
16
>                 location key (7383370114097217536 UNKNOWN.211 156519724=
32879681580) type DIR_ITEM.0
>                 transid 72057594045427176 data_len 0 name_len 0
>                 name:=20
>         item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 16=
0
>                 generation 2231988 transid 2231989 size 81701 nbytes 81=
920
>                 block group 0 mode 100644 links 1 uid 33 gid 33 rdev 0
>                 sequence 8 flags 0x14(NOCOMPRESS)
>                 atime 1510290392.703320623 (2017-11-09 21:06:32)
>                 ctime 1510290392.715320477 (2017-11-09 21:06:32)
>                 mtime 1510290392.715320477 (2017-11-09 21:06:32)
>                 otime 1510290392.703320623 (2017-11-09 21:06:32)
>         item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 ite=
msize 26
>                 index 1957 namelen 16 name: 1955-capture.jpg
>         item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize 5=
3
>                 generation 2231989 type 1 (regular)
>                 extent data disk byte 2381649588224 nr 81920
>                 extent data offset 0 nr 81920 ram 81920
>                 extent compression 0 (none)
>         item 33 key (1919805657 INODE_ITEM 0) itemoff 14176 itemsize 16=
0
>                 generation 2231988 transid 2231989 size 81856 nbytes 81=
920
>                 block group 0 mode 100644 links 1 uid 33 gid 33 rdev 0
>                 sequence 8 flags 0x14(NOCOMPRESS)
>                 atime 1510290392.919317997 (2017-11-09 21:06:32)
>                 ctime 1510290392.931317852 (2017-11-09 21:06:32)

No extra interesting things here.

>=20
>=20
>> Although what we could try is to avoid BUG_ON(), but I'm afraid the
>> problem is more severe than my expectation.
> =20
> How does it look now?

At least we know what btrfs check should do.
I could dig it a little deeper to see if we could fix it.
(Or something strange happened again)

Thanks
Qu

>=20
>> Any idea how such corruption happened?
>=20
> Sigh, I wish I knew.
>=20
> It feels like every btrfs filesystem I've had between my 3 systems has
> gotten inexplicably corrupted at least once.
> This one is not even using bcache, just dmcrypt underneath.
>=20
> It's my only one using btrfs raid (1):
> gargamel:~# btrfs fi show /dev/mapper/raid0d1=20
> Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
>         Total devices 2 FS bytes used 1.12TiB
>         devid    1 size 836.13GiB used 722.03GiB path /dev/mapper/raid0=
d1
>         devid    2 size 836.13GiB used 722.03GiB path /dev/mapper/raid0=
d2
>=20
> Data, RAID0: total=3D38TiB, used=3D1.11TiB
> System, RAID1: total2.00MiB, used=128.00KiB
> Metadata, RAID1: total=13.00GiB, used=3D8.54GiB
> GlobalReserve, single: totalQ2.00MiB, used=3D0.00B
>=20
> Now, I didn't get errors or warnings, or even scrub warnings on it, I j=
ust ran=20
> btrfs check to see what would happen.
>=20
> Marc
>=20


--09C1wWjSGkdAHC0QsMNugwrSKNlJLHP4P--

--k9AhJ9Ikcw1A2ocN7fvmj9OkNKdjxmMK3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloPe+AXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgoAQf8C9/NF3F3sESIlcv60eL+CPBR
cQA60KuE8ZW/lX1+zqGK04gTk0pHQS5rMACrqo6dek+dv/4szkgHG/HlQXgmPIDj
tGgR+crVThpXsep4EfA/3MpuUMhzVcvCoBfYPyIHgYR1yyUqQ/QrKY4JGFcwFaTp
XDyVQIBXUpQ6Rr4hM+iXY6843+VWTtsoY7wZjCXmZSayVhB8V7B7igC6lGAXTqN3
fTJgrYgL+2cgYP+D2Xil14Mk13trk6cLdKtBG+Kt0fH7ArWXbtLu3hd4CtG0/EgF
8d66xf2+qntw0clZ6D4J59CiCI053NYMPabC43f7sxZxW1RFIwinEnVD6xbijQ==
=zRxw
-----END PGP SIGNATURE-----

--k9AhJ9Ikcw1A2ocN7fvmj9OkNKdjxmMK3--
