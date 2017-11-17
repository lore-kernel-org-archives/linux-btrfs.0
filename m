Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65290 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757279AbdKQIMT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Nov 2017 03:12:19 -0500
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
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
Date: Fri, 17 Nov 2017 16:12:07 +0800
MIME-Version: 1.0
In-Reply-To: <20171117073046.ehdlw5essf7lhw7k@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wHo60SOcO5hVsPXdTnTr6if1F8HNCcR64"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wHo60SOcO5hVsPXdTnTr6if1F8HNCcR64
Content-Type: multipart/mixed; boundary="hDwPlslqvQOsBDSCNkhQ5An0fk4Eqe3nF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <aafe0b68-26ce-914b-c7cb-f4a775a9c1b9@gmx.com>
Subject: Re: btrfs check: add_missing_dir_index: BUG_ON `ret` triggered, value
 -17
References: <20171117022615.GO10969@merlins.org>
 <3e4de2ce-28c8-23c0-c25d-70659a378865@gmx.com>
 <20171117061707.geqtk3ydj2elv4o7@merlins.org>
 <20171117073046.ehdlw5essf7lhw7k@merlins.org>
In-Reply-To: <20171117073046.ehdlw5essf7lhw7k@merlins.org>

--hDwPlslqvQOsBDSCNkhQ5An0fk4Eqe3nF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 15:30, Marc MERLIN wrote:
> Here's the whole output:
> gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 19198056=
47

Sorry, I missed "-C10" parameter for grep.

>                 location key (1919805647 INODE_ITEM 0) type FILE

This should be the DIR_ITEM/DIR_INDEX pointing to that inode.

Although there is only one hit, means we missed one DIR_ITEM/DIR_INDEX.
Maybe it's btrfs-progs re-inserting the wrong DIR_INDEX/DIR_ITEM that
leads to -EEXIST.

This needs extra info from "-C10" to determine.

>         item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 16=
0
>         item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 ite=
msize 26

Here we know the parent inode number is 1919785864.

>         item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize 5=
3
> parent transid verify failed on 1173964603392 wanted 2244945 found 2247=
404
> parent transid verify failed on 1173964603392 wanted 2244945 found 2247=
404
> parent transid verify failed on 1173964603392 wanted 2244945 found 2247=
404
> parent transid verify failed on 1173964603392 wanted 2244945 found 2247=
404
> Ignoring transid failure

I think the transid failure is the root cause.

Although what we could try is to avoid BUG_ON(), but I'm afraid the
problem is more severe than my expectation.

Any idea how such corruption happened?

Thanks,
Qu

> parent transid verify failed on 1652248100864 wanted 2245186 found 2247=
494
> parent transid verify failed on 1652248100864 wanted 2245186 found 2247=
494
> parent transid verify failed on 1652248100864 wanted 2245186 found 2247=
494
> parent transid verify failed on 1652248100864 wanted 2245186 found 2247=
494
> Ignoring transid failure
> parent transid verify failed on 1174605512704 wanted 2245171 found 2247=
435
> parent transid verify failed on 1174605512704 wanted 2245171 found 2247=
435
> parent transid verify failed on 1174605512704 wanted 2245171 found 2247=
435
> parent transid verify failed on 1174605512704 wanted 2245171 found 2247=
435
> Ignoring transid failure
> WARNING: eb corrupted: item 130 eb level 0 next level 2, skipping the r=
est
>=20
>=20
> On Thu, Nov 16, 2017 at 10:17:07PM -0800, Marc MERLIN wrote:
>> On Fri, Nov 17, 2017 at 01:17:19PM +0800, Qu Wenruo wrote:
>>>
>>>
>>> On 2017=E5=B9=B411=E6=9C=8817=E6=97=A5 10:26, Marc MERLIN wrote:
>>>> Howdy,
>>>>
>>>> Up to date git pull from btrfs-progs:
>>>>
>>>> gargamel:~# btrfs check --repair /dev/mapper/raid0d1
>>>> enabling repair mode
>>>> Checking filesystem on /dev/mapper/raid0d1
>>>> UUID: 01334b81-c0db-4e80-92e4-cac4da867651
>>>> checking extents
>>>> corrupt extent record: key 203003699200 168 40960
>>>> corrupt extent record: key 203003764736 168 172032
>>>> ref mismatch on [203003699200 40960] extent item 0, found 1
>>>> Data backref 203003699200 root 258 owner 1933897829 offset 0 num_ref=
s 0 not found in extent tree
>>>> Incorrect local backref count on 203003699200 root 258 owner 1933897=
829 offset 0 found 1 wanted 0 back 0x5596988c2130
>>>> backpointer mismatch on [203003699200 40960]
>>>> repair deleting extent record: key 203003699200 168 40960
>>>> adding new data backref on 203003699200 root 258 owner 1933897829 of=
fset 0 found 1
>>>> Repaired extent references for 203003699200
>>>> Data backref 203003764736 root 258 owner 1932315368 offset 0 num_ref=
s 0 not found in extent tree
>>>> Incorrect local backref count on 203003764736 root 258 owner 1932315=
368 offset 0 found 1 wanted 0 back 0x5596dde358f0
>>>> backpointer mismatch on [203003764736 172032]
>>>> repair deleting extent record: key 203003764736 168 172032
>>>> adding new data backref on 203003764736 root 258 owner 1932315368 of=
fset 0 found 1
>>>> Repaired extent references for 203003764736
>>>> Fixed 0 roots.
>>>> checking free space cache
>>>> cache and super generation don't match, space cache will be invalida=
ted
>>>> checking fs roots
>>>> invalid location in dir item 0
>>>> Deleting bad dir index [1919785864,96,1958] root 258
>>>> Deleting bad dir index [1919785864,96,1957] root 258
>>>> repairing missing dir index item for inode 1919805647
>>>> cmds-check.c:2614: add_missing_dir_index: BUG_ON `ret` triggered, va=
lue -17
>>>
>>> -EEXIST. Btrfs check --repair is trying to re-insert some key which
>>> exists already.
>>>
>>> Would you please provide the output of "btrfs-debug-tree -t 258 | gre=
p
>>> 1919805647" to help the debugging?
>> =20
>> Sure. It may run all night and I'm going to bed now, but the output I
>> got so far, is:
>> gargamel:~# btrfs-debug-tree -t 258 /dev/mapper/raid0d1 | grep 1919805=
647
>>                 location key (1919805647 INODE_ITEM 0) type FILE
>>         item 30 key (1919805647 INODE_ITEM 0) itemoff 14415 itemsize 1=
60
>>         item 31 key (1919805647 INODE_REF 1919785864) itemoff 14389 it=
emsize 26
>>         item 32 key (1919805647 EXTENT_DATA 0) itemoff 14336 itemsize =
53
>> (...)
>>
>> I'll post tomorrow if I get more overnight
>>
>> Marc
>> --=20
>> "A mouse is a device used to point at the xterm you want to type in" -=
 A.S.R.
>> Microsoft is to operating systems ....
>>                                       .... what McDonalds is to gourme=
t cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024=
R/763BE901
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--hDwPlslqvQOsBDSCNkhQ5An0fk4Eqe3nF--

--wHo60SOcO5hVsPXdTnTr6if1F8HNCcR64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloOmdcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qi+QQf/S9HWI4PuEUyN0QlBPPeOESgh
3BvcuIGbmyoEORghW/DZzMQ47J31xCY57lbvPUfoLMkVB4ImfpJpJCiAo9jobQIT
/3g9AwnhW6o0BeMmqmRXpNRZodJ8P8QpGf5GX9ibzAg2lzczpnrk+RRSi+I/h2wh
ePYDJ2Me2b8E8UptJVA6orFMTT0/AlM4+sFaKkYfnROeRrpg/CV+3g2V16dGrc6R
CGUpCt//TL/XeQbeslHE1USiTkOwzWprP+cmC+3Vqp19pPo8T8FVpvj0gqH22xv1
rW/TjoE8Dosepq6hlo5GIAviUGGNuCUUmTn0p7oMO+fP+TAWYY7Ky3t+oeVUIQ==
=GJQ0
-----END PGP SIGNATURE-----

--wHo60SOcO5hVsPXdTnTr6if1F8HNCcR64--
