Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF92C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB6FC20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 23:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Z7yfgtEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfCYXGH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:06:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:34331 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfCYXGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 19:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553555158;
        bh=99zj5PHYrhCHZc4NiW2LTq+CvDk/1wybVAespgT7Kn0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Z7yfgtEjkphj+ypS/sCPw8XsHo+A8X6GjtbClounNkJVnj4hGsLcR+cceCFjg0Gqn
         RAF/tMtFRRTqFOxJBX4zD3/CoTm79bLA05lPeVZB7QJEs5/fesZ1cbVhAr3uE34mm0
         jcst3HqbrKDE6/XCwIoCCD+q6Jgc8KvVFDnltNqc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M51eM-1gm2rj1Yp4-00zChb; Tue, 26
 Mar 2019 00:05:58 +0100
Subject: Re: [PATCH v1.1] btrfs-progs: Do metadata prealloc as long as we're
 not modifying extent tree
To:     Omar Sandoval <osandov@osandov.com>, David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180914074944.19526-1-wqu@suse.com>
 <20190305135508.GA31119@twin.jikos.cz> <20190325180614.GD5826@vader>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <68522c31-11cc-ed2f-ce60-339a9b75edbf@gmx.com>
Date:   Tue, 26 Mar 2019 07:05:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190325180614.GD5826@vader>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wBNFKF0DelPB0XL6HS17IRMXyjtjoBSxR"
X-Provags-ID: V03:K1:4NbFJkUYssfGTSZ71h8V6vyQUUzByeQsIsqHSwHhzBnjhS2CZJV
 CAnifOSNJ0DJK8IMBzeDWAWmBq9BNbCxRq7EUjj1kKpjbr3QRqVIMkAMA5w4I3AT/RtsJ2h
 5qufX7PduOWcPj7rxLxH+EcapQxzfynIaRTvq9kmsG69RZcbAfnMHz5LhTEUL5aJOcpWSX7
 xzUQIBBWDg4G3c7Sd3V9w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/WnW0UcCS54=:k9ax/PFiUHjyKuGY+sxeH4
 yNuMhY6oyMuONKRQHncl0eGvVxm+ZWPAbZQZaDfsIbr23Lkyr7qfUA0xs5DY4xCQZkIqZkbjn
 SEsXlOuOP3tXz+hoqiD2oxk08OFyvhAaPHZ6/1XtzZ8CVIsWHU2MHYEW5lvfvq/j38oE5y6MD
 vOh7642AJobcG8Fs4tWU0q96N4/20rN/UKWn//WHFgkRjSKKVRtu3e/y0x4wnobqBeViQVhXS
 jA2GxEeT/spU40F8Gi4XE3Ognt0SJuYZ9PohTK9ck2YC2WE4MN6OE9G0cQYvUZPSJ8N8AuQR5
 RJUdUMFzDm1wVboZmZaXrSfbgk3aHyOb3G/ep+gPXr7OOPWZCwbAJC0X2xA/njTDMPEWSUy7h
 W6/k/xRgvCnTrpPLt+3ZbR4ljFxlboSmHwhS/3Z7kLnNK7HhFwiCRqJrt91Csm0dHEtgCF1/g
 YOrE5JEtuIPu4gWhkukAcotd76BQuYQZAm1Ym3xTmsOqIUwKFxJmYUaOBkjBAbg1mBfB6tTzK
 wp+IfD3vX0XIFkoGPLK6UXCcpdjB2o/owMmNGdbZxji6MR76ohXyf5HCm2Ovzlxh2LBthE+GA
 bOfUOv6U5lfZRb8fhwRBKS0zA/IjUACQdNIh+UFjU3BQ8fvW6mjyi2QfJw7/OhuMi3ydD3g33
 Ru0+BqBCPDdV+kYC5w4qezbyz5OhRXMiUwow3h9isVx1P5VYg58SJVdpp1rJvADHysXxxLYJo
 vt/22BLJEIBQucd2p9/H6mK4yFJ7Ke+OHcaM989s0DkAXxZzM44gBAzE4mRo5pSQxbruIDci5
 FGWB9cr8d8wWPmBs/yTYOOMkmZd+iqdxx8/61mRHeF0ktVpVVuy1qMQk0oAUUdTI+ECTttYet
 HgUaKJKprcsAHlQeDU2ytzxrVFehEq60LigG6dK9fF+Wp61Eg9rIfe+OBU9+Y7
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wBNFKF0DelPB0XL6HS17IRMXyjtjoBSxR
Content-Type: multipart/mixed; boundary="qO5DnMPvktT6uccjw1n2jQD5tzaJOPG1V";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Omar Sandoval <osandov@osandov.com>, David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <68522c31-11cc-ed2f-ce60-339a9b75edbf@gmx.com>
Subject: Re: [PATCH v1.1] btrfs-progs: Do metadata prealloc as long as we're
 not modifying extent tree
References: <20180914074944.19526-1-wqu@suse.com>
 <20190305135508.GA31119@twin.jikos.cz> <20190325180614.GD5826@vader>
In-Reply-To: <20190325180614.GD5826@vader>

--qO5DnMPvktT6uccjw1n2jQD5tzaJOPG1V
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/26 =E4=B8=8A=E5=8D=882:06, Omar Sandoval wrote:
> On Tue, Mar 05, 2019 at 02:55:08PM +0100, David Sterba wrote:
>> On Fri, Sep 14, 2018 at 03:49:44PM +0800, Qu Wenruo wrote:
>>> In github issues, one user reports unexpected ENOSPC error if enablin=
g
>>> datasum.
>>> After some investigation, it looks like that during ext2_saved/image
>>> creation, we could create large file extent whose size can be 128M (m=
ax
>>> data extent size).
>>>
>>> In that case, its csum will be at least 128K. Under certain case we n=
eed
>>> to allocate extra metadata chunks to fulfill such space requirement.
>>>
>>> However we only do metadata prealloc if we're reserving extents for f=
s
>>> trees.
>>> (we use btrfs_root::ref_cows to determine whether we should do metada=
ta
>>> prealloc, and that member is only set for fs trees).
>>>
>>> There is no explaination on why we only do metadata prealloc for file=

>>> trees, but at least from my investigation, it could be related to avo=
id
>>> nested extent tree modication.
>>>
>>> At least extent reservation for csum tree shouldn't be a problem with=

>>> metadata block group preallocation.
>>>
>>> So change the metadata block group preallocation check from
>>> "root->ref_cow" to "root->root_key.objectid !=3D
>>> BTRFS_EXTENT_TREE_OBJECTID", and add some comment for it.
>>
>> This looks a bit fragile to me but I don't have a better suggestion fo=
r
>> a fix. Added to devel, thanks.
>=20
> This seems to be causing infinite recursion in do_chunk_alloc() during =
mkfs:

I can also reproduce it.

And indeed it's caused by this patch.

Please discard this patch until a better solution is found.

Thanks,
Qu
>=20
> $ truncate -s $((1024 * 1024 * 1024)) foo
> $ gdb --args ./mkfs.btrfs foo
> GNU gdb (GDB) 8.2.1
> Copyright (C) 2018 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl=
=2Ehtml>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.
> Type "show copying" and "show warranty" for details.
> This GDB was configured as "x86_64-pc-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
>     <http://www.gnu.org/software/gdb/documentation/>.
>=20
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from ./mkfs.btrfs...done.
> (gdb) r
> Starting program: /home/osandov/linux/btrfs-progs/mkfs.btrfs foo
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/usr/lib/libthread_db.so.1".
> btrfs-progs v4.20.2
> See http://btrfs.wiki.kernel.org for more information.
>=20
>=20
> Program received signal SIGSEGV, Segmentation fault.
> 0x000055555557fe24 in memcpy (__len=3D17, __src=3D0x5555555e5ef5, __des=
t=3D0x7fffff7ff040) at /usr/include/bits/string_fortified.h:34
> 34        return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (=
__dest));
> (gdb) bt
> #0  0x000055555557fe24 in memcpy (__len=3D17, __src=3D0x5555555e5ef5, _=
_dest=3D0x7fffff7ff040) at /usr/include/bits/string_fortified.h:34
> #1  read_extent_buffer (eb=3Deb@entry=3D0x5555555e5e10, dst=3Ddst@entry=
=3D0x7fffff7ff040, start=3Dstart@entry=3D101, len=3Dlen@entry=3D17) at ex=
tent_io.c:975
> #2  0x0000555555565d1e in btrfs_item_key (nr=3D0, disk_key=3D0x7fffff7f=
f040, eb=3D0x5555555e5e10) at ctree.h:1905
> #3  __btrfs_cow_block (trans=3Dtrans@entry=3D0x5555555f2430, root=3Droo=
t@entry=3D0x5555555d3e40, buf=3Dbuf@entry=3D0x5555555e5e10, parent=3Dpare=
nt@entry=3D0x0, parent_slot=3Dparent_slot@entry=3D0, cow_ret=3Dcow_ret@en=
try=3D0x7fffff7ff288, search_start=3D0, empty_size=3D0) at ctree.c:291
> #4  0x0000555555566676 in btrfs_cow_block (trans=3Dtrans@entry=3D0x5555=
555f2430, root=3Droot@entry=3D0x5555555d3e40, buf=3D0x5555555e5e10, paren=
t=3D0x0, parent_slot=3D0, cow_ret=3Dcow_ret@entry=3D0x7fffff7ff288) at ct=
ree.c:388
> #5  0x0000555555569319 in btrfs_search_slot (trans=3D<optimized out>, r=
oot=3Droot@entry=3D0x5555555d3e40, key=3Dkey@entry=3D0x7fffff7ff440, p=3D=
p@entry=3D0x555555738ea0, ins_len=3Dins_len@entry=3D73, cow=3Dcow@entry=3D=
1) at ctree.c:1158
> #6  0x000055555556ab6f in btrfs_insert_empty_items (trans=3Dtrans@entry=
=3D0x5555555f2430, root=3Droot@entry=3D0x5555555d3e40, path=3Dpath@entry=3D=
0x555555738ea0, cpu_key=3Dcpu_key@entry=3D0x7fffff7ff440, data_size=3Ddat=
a_size@entry=3D0x7fffff7ff43c, nr=3Dnr@entry=3D1) at ctree.c:2612
> #7  0x0000555555580ad7 in btrfs_insert_empty_item (data_size=3D<optimiz=
ed out>, key=3D0x7fffff7ff440, path=3D0x555555738ea0, root=3D0x5555555d3e=
40, trans=3D0x5555555f2430) at ctree.h:2650
> #8  btrfs_insert_dev_extent (trans=3Dtrans@entry=3D0x5555555f2430, devi=
ce=3Ddevice@entry=3D0x5555555d59e0, chunk_offset=3Dchunk_offset@entry=3D5=
242880, num_bytes=3Dnum_bytes@entry=3D8388608, start=3D5242880) at volume=
s.c:574
> #9  0x00005555555818c1 in btrfs_alloc_dev_extent (start=3D0x7fffff7ff56=
8, num_bytes=3D8388608, chunk_offset=3D5242880, device=3D0x5555555d59e0, =
trans=3D0x5555555f2430) at volumes.c:610
> #10 btrfs_alloc_chunk (trans=3Dtrans@entry=3D0x5555555f2430, info=3Dinf=
o@entry=3D0x5555555d2970, start=3Dstart@entry=3D0x7fffff7ff698, num_bytes=
=3Dnum_bytes@entry=3D0x7fffff7ff6a0, type=3D4) at volumes.c:1143
> #11 0x0000555555575ca4 in do_chunk_alloc (trans=3Dtrans@entry=3D0x55555=
55f2430, fs_info=3Dfs_info@entry=3D0x5555555d2970, alloc_bytes=3Dalloc_by=
tes@entry=3D16384, flags=3Dflags@entry=3D4) at extent-tree.c:1876
> #12 0x0000555555575f8d in btrfs_reserve_extent (trans=3Dtrans@entry=3D0=
x5555555f2430, root=3Droot@entry=3D0x5555555d3e40, num_bytes=3Dnum_bytes@=
entry=3D16384, empty_size=3Dempty_size@entry=3D0, hint_byte=3Dhint_byte@e=
ntry=3D0, search_end=3Dsearch_end@entry=3D18446744073709551615, ins=3D0x7=
fffff7ff8c0, is_data=3Dfalse) at extent-tree.c:2516
> #13 0x0000555555576914 in alloc_tree_block (ins=3D0x7fffff7ff8c0, searc=
h_end=3D18446744073709551615, hint_byte=3D0, empty_size=3D0, level=3D0, k=
ey=3D0x7fffff7ff960, flags=3D0, generation=3D<optimized out>, root_object=
id=3D4, num_bytes=3D16384, root=3D0x5555555d3e40, trans=3D0x5555555f2430)=
 at extent-tree.c:2641
> #14 btrfs_alloc_free_block (trans=3Dtrans@entry=3D0x5555555f2430, root=3D=
root@entry=3D0x5555555d3e40, blocksize=3D16384, root_objectid=3D4, key=3D=
key@entry=3D0x7fffff7ff960, level=3Dlevel@entry=3D0, hint=3D0, empty_size=
=3D0) at extent-tree.c:2694
> #15 0x0000555555565d4a in __btrfs_cow_block (trans=3Dtrans@entry=3D0x55=
55555f2430, root=3Droot@entry=3D0x5555555d3e40, buf=3Dbuf@entry=3D0x55555=
55e5e10, parent=3Dparent@entry=3D0x0, parent_slot=3Dparent_slot@entry=3D0=
, cow_ret=3Dcow_ret@entry=3D0x7fffff7ffba8, search_start=3D0, empty_size=3D=
0) at ctree.c:295
> #16 0x0000555555566676 in btrfs_cow_block (trans=3Dtrans@entry=3D0x5555=
555f2430, root=3Droot@entry=3D0x5555555d3e40, buf=3D0x5555555e5e10, paren=
t=3D0x0, parent_slot=3D0, cow_ret=3Dcow_ret@entry=3D0x7fffff7ffba8) at ct=
ree.c:388
> #17 0x0000555555569319 in btrfs_search_slot (trans=3D<optimized out>, r=
oot=3Droot@entry=3D0x5555555d3e40, key=3Dkey@entry=3D0x7fffff7ffd60, p=3D=
p@entry=3D0x555555738d30, ins_len=3Dins_len@entry=3D73, cow=3Dcow@entry=3D=
1) at ctree.c:1158
> #18 0x000055555556ab6f in btrfs_insert_empty_items (trans=3Dtrans@entry=
=3D0x5555555f2430, root=3Droot@entry=3D0x5555555d3e40, path=3Dpath@entry=3D=
0x555555738d30, cpu_key=3Dcpu_key@entry=3D0x7fffff7ffd60, data_size=3Ddat=
a_size@entry=3D0x7fffff7ffd5c, nr=3Dnr@entry=3D1) at ctree.c:2612
> #19 0x0000555555580ad7 in btrfs_insert_empty_item (data_size=3D<optimiz=
ed out>, key=3D0x7fffff7ffd60, path=3D0x555555738d30, root=3D0x5555555d3e=
40, trans=3D0x5555555f2430) at ctree.h:2650
> #20 btrfs_insert_dev_extent (trans=3Dtrans@entry=3D0x5555555f2430, devi=
ce=3Ddevice@entry=3D0x5555555d59e0, chunk_offset=3Dchunk_offset@entry=3D5=
242880, num_bytes=3Dnum_bytes@entry=3D8388608, start=3D5242880) at volume=
s.c:574
> #21 0x00005555555818c1 in btrfs_alloc_dev_extent (start=3D0x7fffff7ffe8=
8, num_bytes=3D8388608, chunk_offset=3D5242880, device=3D0x5555555d59e0, =
trans=3D0x5555555f2430) at volumes.c:610
> #22 btrfs_alloc_chunk (trans=3Dtrans@entry=3D0x5555555f2430, info=3Dinf=
o@entry=3D0x5555555d2970, start=3Dstart@entry=3D0x7fffff7fffb8, num_bytes=
=3Dnum_bytes@entry=3D0x7fffff7fffc0, type=3D4) at volumes.c:1143
> #23 0x0000555555575ca4 in do_chunk_alloc (trans=3Dtrans@entry=3D0x55555=
55f2430, fs_info=3Dfs_info@entry=3D0x5555555d2970, alloc_bytes=3Dalloc_by=
tes@entry=3D16384, flags=3Dflags@entry=3D4) at extent-tree.c:1876
> #24 0x0000555555575f8d in btrfs_reserve_extent (trans=3Dtrans@entry=3D0=
x5555555f2430, root=3Droot@entry=3D0x5555555d3e40, num_bytes=3Dnum_bytes@=
entry=3D16384, empty_size=3Dempty_size@entry=3D0, hint_byte=3Dhint_byte@e=
ntry=3D0, search_end=3Dsearch_end@entry=3D18446744073709551615, ins=3D0x7=
fffff8001e0, is_data=3Dfalse) at extent-tree.c:2516
> #25 0x0000555555576914 in alloc_tree_block (ins=3D0x7fffff8001e0, searc=
h_end=3D18446744073709551615, hint_byte=3D0, empty_size=3D0, level=3D0, k=
ey=3D0x7fffff800280, flags=3D0, generation=3D<optimized out>, root_object=
id=3D4, num_bytes=3D16384, root=3D0x5555555d3e40, trans=3D0x5555555f2430)=
 at extent-tree.c:2641
> #26 btrfs_alloc_free_block (trans=3Dtrans@entry=3D0x5555555f2430, root=3D=
root@entry=3D0x5555555d3e40, blocksize=3D16384, root_objectid=3D4, key=3D=
key@entry=3D0x7fffff800280, level=3Dlevel@entry=3D0, hint=3D0, empty_size=
=3D0) at extent-tree.c:2694
> #27 0x0000555555565d4a in __btrfs_cow_block (trans=3Dtrans@entry=3D0x55=
55555f2430, root=3Droot@entry=3D0x5555555d3e40, buf=3Dbuf@entry=3D0x55555=
55e5e10, parent=3Dparent@entry=3D0x0, parent_slot=3Dparent_slot@entry=3D0=
, cow_ret=3Dcow_ret@entry=3D0x7fffff8004c8, search_start=3D0, empty_size=3D=
0) at ctree.c:295
> #28 0x0000555555566676 in btrfs_cow_block (trans=3Dtrans@entry=3D0x5555=
555f2430, root=3Droot@entry=3D0x5555555d3e40, buf=3D0x5555555e5e10, paren=
t=3D0x0, parent_slot=3D0, cow_ret=3Dcow_ret@entry=3D0x7fffff8004c8) at ct=
ree.c:388
> #29 0x0000555555569319 in btrfs_search_slot (trans=3D<optimized out>, r=
oot=3Droot@entry=3D0x5555555d3e40, key=3Dkey@entry=3D0x7fffff800680, p=3D=
p@entry=3D0x555555738bc0, ins_len=3Dins_len@entry=3D73, cow=3Dcow@entry=3D=
1) at ctree.c:1158
> #30 0x000055555556ab6f in btrfs_insert_empty_items (trans=3Dtrans@entry=
=3D0x5555555f2430, root=3Droot@entry=3D0x5555555d3e40, path=3Dpath@entry=3D=
0x555555738bc0, cpu_key=3Dcpu_key@entry=3D0x7fffff800680, data_size=3Ddat=
a_size@entry=3D0x7fffff80067c, nr=3Dnr@entry=3D1) at ctree.c:2612
> #31 0x0000555555580ad7 in btrfs_insert_empty_item (data_size=3D<optimiz=
ed out>, key=3D0x7fffff800680, path=3D0x555555738bc0, root=3D0x5555555d3e=
40, trans=3D0x5555555f2430) at ctree.h:2650
> #32 btrfs_insert_dev_extent (trans=3Dtrans@entry=3D0x5555555f2430, devi=
ce=3Ddevice@entry=3D0x5555555d59e0, chunk_offset=3Dchunk_offset@entry=3D5=
242880, num_bytes=3Dnum_bytes@entry=3D8388608, start=3D5242880) at volume=
s.c:574
> #33 0x00005555555818c1 in btrfs_alloc_dev_extent (start=3D0x7fffff8007a=
8, num_bytes=3D8388608, chunk_offset=3D5242880, device=3D0x5555555d59e0, =
trans=3D0x5555555f2430) at volumes.c:610
> #34 btrfs_alloc_chunk (trans=3Dtrans@entry=3D0x5555555f2430, info=3Dinf=
o@entry=3D0x5555555d2970, start=3Dstart@entry=3D0x7fffff8008d8, num_bytes=
=3Dnum_bytes@entry=3D0x7fffff8008e0, type=3D4) at volumes.c:1143
> #35 0x0000555555575ca4 in do_chunk_alloc (trans=3Dtrans@entry=3D0x55555=
55f2430, fs_info=3Dfs_info@entry=3D0x5555555d2970, alloc_bytes=3Dalloc_by=
tes@entry=3D16384, flags=3Dflags@entry=3D4) at extent-tree.c:1876
>=20


--qO5DnMPvktT6uccjw1n2jQD5tzaJOPG1V--

--wBNFKF0DelPB0XL6HS17IRMXyjtjoBSxR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyZXtAACgkQwj2R86El
/qhgcwgAouTpNriswE8dy7aggEr9cQHy5A+6SuimDLiKlMcNkbz0KDGLWtC1sKR5
MHXwk8VfNWXSMklNypON/fWgF35izoWDwpH2ObZKWOI7jKz3GEmAegY0ASFGU0yX
zzeRMqwhRkGmt1bTHxf+ckrAMv8l+r8LHl1BGJaQYD542gXiZZv76d3nclzaOvi/
qqtBdgfGH/fFALSeYAZD56+9n9wUi7iPMAmJTzr2ipqzJJK4Z7KdN/wkxF5WZScF
GaGXM6P2xlqEUN1KqIzUessyPJbmgOX0bdOBqP3bZrs82nxf7NiRkRUwLgJJZugQ
wgYwcPoEIn8fL5oHd67UbqK49qY5Sg==
=uqHj
-----END PGP SIGNATURE-----

--wBNFKF0DelPB0XL6HS17IRMXyjtjoBSxR--
