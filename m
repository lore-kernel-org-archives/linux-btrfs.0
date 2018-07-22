Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55987 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728220AbeGVCQg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 22:16:36 -0400
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
To: Alexander Wetzel <alexander.wetzel@web.de>, linux-btrfs@vger.kernel.org
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
 <aa82a6ba-b961-25db-2487-59aa64193257@web.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <79e88abd-d505-ec2b-a960-a07c0a5b7815@gmx.com>
Date: Sun, 22 Jul 2018 09:21:34 +0800
MIME-Version: 1.0
In-Reply-To: <aa82a6ba-b961-25db-2487-59aa64193257@web.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="bqPnWM2FqsrhSG4G6KJzgxtNoheVXOfUh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bqPnWM2FqsrhSG4G6KJzgxtNoheVXOfUh
Content-Type: multipart/mixed; boundary="xGlTLTRru2Pm04ZAaGnqZqb3D5RccuNKM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Alexander Wetzel <alexander.wetzel@web.de>, linux-btrfs@vger.kernel.org
Message-ID: <79e88abd-d505-ec2b-a960-a07c0a5b7815@gmx.com>
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
 <eed6fd0d-c89e-5f3e-026e-0364b0bffda1@gmx.com>
 <aa82a6ba-b961-25db-2487-59aa64193257@web.de>
In-Reply-To: <aa82a6ba-b961-25db-2487-59aa64193257@web.de>

--xGlTLTRru2Pm04ZAaGnqZqb3D5RccuNKM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B407=E6=9C=8821=E6=97=A5 14:39, Alexander Wetzel wrote:
>>>
>>> I'm running my normal workstation with git kernels from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testi=
ng.git
>>>
>>> and just got the second file system corruption in three weeks. I do n=
ot
>>> have issues with stable kernels, and just want to give you a heads up=

>>> that there might be something seriously broken in current development=

>>> kernels.
>>>
>>> The first corruption was with a kernel based on 4.18.0-rc1
>>> (wt-2018-06-20) and the second one today based on 4.18.0-rc4
>>> (wt-2018-07-09).
>>> The first corruption definitely destroyed data, the second one has no=
t
>>> been looked at all, yet.
>>>
>>> After the reinstall I did run some scrubs, the last working one one w=
eek
>>> ago.
>>>
>>> Of course this could be unrelated to the development kernels or even
>>> btrfs, but two corruptions within weeks after years without problems =
is
>>> very suspect.
>>> And since btrfs also allowed to read corrupted data (with a stable
>>> ubuntu kernel, see below for more details) it looks like this is inde=
ed
>>> an issue in btrfs, correct?
>>
>> Not in newer kernel anymore.
>>
>> Btrfs kernel module will do *restrict* check on tree blocks.
>> So anything unexpected (or doesn't follow btrfs on-disk format) will b=
e
>> rejected by btrfs module.
>>
>> To avoid further corrupting the whole btrfs.
>=20
> Not sure I can follow that. Shouldn't I get a read error for a file due=

> to checksum mismatch if btrfs did not write it out itself?

It's not data corruption, but metadata (tree block) corruption.

So it could cause more serious problem.

> I could copy the complete git tree without any noticeable errors.

Because the corruption happens in extent tree, thus it doesn't affect fs
tree (controlling how btrfs organize files/dirs/xattr) nor data.

>>
>>>
>>> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSA=
TA
>>> 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is
>>> enabled as mount option and there were roughly 5 other subvolumes.
>>>
>>> I'm currently backing up the full btrfs partition after the second
>>> corruption which announced itself with the following log entries:
>>>
>>> [=C2=A0 979.223767] BTRFS critical (device sdc2): corrupt leaf: root=3D=
2
>>> block=3D1029783552 slot=3D1, unexpected item end, have 16161 expect 1=
6250
>>
>> This shows enough info of what's going wrong.
>> Items overlaps or has holes in extent tree.
>>
>> Please dump the tree block by using the following command:
>>
>> # btrfs inspect dump-tree -b 1029783552 /dev/sdc2
>=20
> # btrfs inspect dump-tree -b 1029783552 /dev/sdc2
> btrfs-progs v4.12
> leaf 1029783552 items 204 free space 4334 generation 13058 owner 2
> leaf 1029783552 flags 0x1(WRITTEN) backref revision 1
> fs uuid 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
> chunk uuid c55861e9-91f6-413f-85f6-5014d942c2bd
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 0 key (844283904 METADA=
TA_ITEM 0) itemoff 16250 itemsize 33
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 tree block skinny level 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 shared block backref parent 166690816

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 1 key (844300288 METADA=
TA_ITEM 0) itemoff 16128 itemsize 33> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent refs 726205=
43991349248 gen 51228445761339392
flags |FULL_BACKREF
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                              These are completely garbage.
                              Looks pretty like due to some offset.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 tree block skinny level 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 2 key (844316672 METADA=
TA_ITEM 0) itemoff 16128 itemsize 33
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 extent refs 72620543991349248 gen 51228445761339392 fl=
ags |FULL_BACKREF
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                              So is this slot.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 tree block skinny level 0

While other slots looks good, it looks like a corruption in tree block
creation.

And more strangely, btrfs has such item range/offset check each time we
modify tree block.
So if you didn't hit such problem, it mostly means your memory is corrupt=
ed.

And in this case, I don't think btrfs check can repair it.

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 3 key (844333056 METADA=
TA_ITEM 0) itemoff 16151 itemsize 33
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 tree block skinny level 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 shared block backref parent 166690816
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 4 key (844349440 METADA=
TA_ITEM 0) itemoff 16118 itemsize 33
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 extent refs 1 gen 7462 flags TREE_BLOCK|FULL_BACKREF
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 tree block skinny level 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 shared block backref parent 166690816
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 5 key (844365824 METADA=
TA_ITEM 0) itemoff 16085 itemsize 33
[snip]
>> And please run "btrfs check" on the filesystem to show any other
>> problems.
>> (I assume there will be more problem than our expectation)
>=20
> Compared to the first crash this looks harmless:

Any error in btrfs check is harmful.
Nothing reported as error is harmless.

> btrfs check --repair /dev/sdc2 2>&1 | tee repair
> checking extents
> incorrect offsets 16250 16161
> corrupt extent record: key 844300288 169 16384
> corrupt extent record: key 844316672 169 16384
> ref mismatch on [844300288 16384] extent item 72620543991349248, found =
1
> Backref 844300288 parent 166690816 root 166690816 not found in extent t=
ree
> backpointer mismatch on [844300288 16384]
> repair deleting extent record: key 844300288 169 0
> adding new tree backref on start 844300288 len 16384 parent 166690816
> root 166690816
> Repaired extent references for 844300288
> bad extent [844300288, 844316672), type mismatch with chunk
> ref mismatch on [844316672 16384] extent item 72620543991349248, found =
1
> Backref 844316672 parent 528 root 528 not found in extent tree
> backpointer mismatch on [844316672 16384]
> repair deleting extent record: key 844316672 169 0
> adding new tree backref on start 844316672 len 16384 parent 0 root 528
> Repaired extent references for 844316672
> bad extent [844316672, 844333056), type mismatch with chunk
> Incorrect local backref count on 1325674496 root 534 owner 0 offset 0
> found 0 wanted 1 back 0x557cc1a41cd0
> Backref disk bytenr does not match extent record, bytenr=3D1325674496, =
ref
> bytenr=3D208
> Backref 1325674496 root 534 owner 979 offset 0 num_refs 0 not found in
> extent tree
> Incorrect local backref count on 1325674496 root 534 owner 979 offset 0=

> found 1 wanted 0 back 0x557cc3ca1530
> backpointer mismatch on [1325674496 4096]
> repair deleting extent record: key 1325674496 168 4096
> adding new data backref on 1325674496 root 534 owner 979 offset 0 found=
 1
> Repaired extent references for 1325674496
> Fixed 0 roots.
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/sdc2
> UUID: 4e36fe70-0613-410b-b1a1-6d4923f9cc8f
> Shifting item nr 1 by 89 bytes in block 4341760
> Shifting item nr 2 by 56 bytes in block 4341760
> cache and super generation don't match, space cache will be invalidated=

> found 381207048192 bytes used, no error found
> total csum bytes: 85216324
> total tree bytes: 1095172096
> total fs tree bytes: 907313152
> total extent tree bytes: 89915392
> btree space waste bytes: 226140034
> file data blocks allocated: 244093546496
> =C2=A0referenced 236476338176
>

Fortunately, at least that 2 slots are the only corruptions.

>=20
>>
>>> [=C2=A0 979.223808] BTRFS: error (device sdc2) in __btrfs_cow_block:1=
080:
>>> errno=3D-5 IO failure
>>> [=C2=A0 979.223810] BTRFS info (device sdc2): forced readonly
>>> [=C2=A0 979.224599] BTRFS warning (device sdc2): Skipping commit of a=
borted
>>> transaction.
>>> [=C2=A0 979.224603] BTRFS: error (device sdc2) in cleanup_transaction=
:1847:
>>> errno=3D-5 IO failure
>>>
>>> I'll restore the system from a backup - and stick to stable kernels f=
or
>>> now - after that, but if needed I can of course also restore the
>>> partition backup to another disk for testing.
>>
>> Since it is your fs corrupted, using older kernel ignores such problem=

>> is not the long term solution in my opinion.
>=20
> I agree. I just want to verify it's indeed stable again.
> It may well be some no kernel issue at all and just bad timing with som=
e
> HW breakdown.

At least for me, since btrfs verify we don't screw up tree blocks each
time we update the tree block, it looks pretty like a unexpected memory
corruption.

Memtest is recommend to locate such problem.

>=20
>>
>>>
>>> Here what I can say from the first crash:
>>>
>>> On Jul 4th I discovered severe file system corruptions and when booti=
ng
>>> with init=3D/bin/bash even tools like parted failed with some report =
about
>>> invalid ELF headers for some library. I started an Ubuntu 17.10 insta=
ll
>>> on another physical disk and copied some data from the damaged btrfs
>>> volume to the Ubuntu disk. And while I COULD copy the files quite man=
y
>>> of the interesting ones were broken:
>>> e.g. the git tree I rescued from the broken btrfs disk is unusable. T=
he
>>> broken files I found all look about the correct size but contain only=

>>> 0x01:
>>> $ hexdump -C .git/objects/9d/732f6506e4cecd6d2b50c5008f9d1255198c1e
>>> 00000000=C2=A0 01 01 01 01 01 01 01 01=C2=A0 01 01 01 01 01 01 01 01
>>> |................|
>>> *
>>> 00000e26
>>>
>>> After copying the files I tried a "btrfs check --repair" which was
>>> finding countless errors and I aborted after I got more than 3 millio=
n
>>> lines output.
>>
>> --repair should never be your first try by all means.
>> And in fact, sometimes it could even further corrupt the fs.
>=20
> Ups, I just notice I have called it with --repair again. At least this
> time I have a backup and can restore to the old state....
>=20
> I was aware of that the first time but lazy.
> Problem was, that many basic system binaries were broken and it looked
> like repairing it was more work than starting over from scratch.
> I was already set on reinstalling and just kind of wanted to see what
> happens.

That's fine, and in fact it fixes some thing, although still with
something left.
If you have ensured that memory is not the culprit, I could patch tree
blocks manually to fix it.

BTW, it looks like repair can only handles wrong tree block item
removal, but fails to create a new correct one, thus still fails to fix i=
t.

Thanks,
Qu

>=20
> Greetings,
>=20
> Alexander
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--xGlTLTRru2Pm04ZAaGnqZqb3D5RccuNKM--

--bqPnWM2FqsrhSG4G6KJzgxtNoheVXOfUh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAltT3B8ACgkQwj2R86El
/qjLOgf+MJozrcZcE6ae62uZKt0gFVcmf1bc1IU/BVI9+C0PwBqKqKxWz4fKDzCH
DZnuU8oCJ2kL0IEAUmzz1nuLRnqcuENArLwba0dJIeY9iLad+0DAJGiV6aNyXTU1
CJJFgiPiZ5HZ5IfbzYITjzt+ki+uJIHOPno3J9g4AfyYlL/IvUEDkHeTh5yaUTw+
ztC3qHLLeI4Sr2yuCOQOKpZQLmShToCNVfYAcEvozJwLM8EJHAVTM+MuiIvm0lxk
nm8RBSSeqJFOa+v/OFJLdtF4kaNYeQqdgYdKS+6C/h2zmecsc/aCYILoYicqxyvN
anJQBsa2tanENRPN6eVB67dqMBhZzA==
=XSrp
-----END PGP SIGNATURE-----

--bqPnWM2FqsrhSG4G6KJzgxtNoheVXOfUh--
