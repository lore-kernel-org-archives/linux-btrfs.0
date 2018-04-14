Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57787 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750948AbeDNOl5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 14 Apr 2018 10:41:57 -0400
Subject: Re: remounted ro during operation, unmountable since
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
 <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
 <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <ccc7a5d1-2605-20fb-0523-e2bdaabb9d69@gmx.com>
Date: Sat, 14 Apr 2018 22:41:50 +0800
MIME-Version: 1.0
In-Reply-To: <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="71uEPrv2EtG6LyQ4qt14SaprXnBHNQXQs"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--71uEPrv2EtG6LyQ4qt14SaprXnBHNQXQs
Content-Type: multipart/mixed; boundary="AcLzhkRP6IbFkijmeZ6tvT1bXJYwtzUZE";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Timo Nentwig <btrfs@nentwig.biz>, linux-btrfs@vger.kernel.org
Message-ID: <ccc7a5d1-2605-20fb-0523-e2bdaabb9d69@gmx.com>
Subject: Re: remounted ro during operation, unmountable since
References: <79818d44-a2f3-9992-6ea2-786abb3d9583@nentwig.biz>
 <4709536f-8ab3-67b8-9b26-253dd94f19c8@gmx.com>
 <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>
In-Reply-To: <16c10106-a1e0-2b2e-1c83-a4b06e243522@nentwig.biz>

--AcLzhkRP6IbFkijmeZ6tvT1bXJYwtzUZE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B404=E6=9C=8814=E6=97=A5 21:45, Timo Nentwig wrote:
> On 04/14/2018 11:42 AM, Qu Wenruo wrote:
>> And the work load when the RO happens is also helpful.
>> (Well, the dmesg of RO happens would be the best though)
> Surprisingly nothing special AFAIR. It's a private, mostly idle machine=
=2E
> Probably "just" browsing with chrome.
> I didn't notice the remount right away as there were no obvious
> failures. And even then I kept it running for a couple more hours/a day=

> or so.
>=20
> I had a glance at dmesg but don't remember anything specific (think the=

> usual "---- [cut here] ---" + dump of registers, but I'm not even sure
> about that). Sorry.
>=20
> Actually the same thing happened just a few days earlier and after a
> reboot (and maybe fsck) it was back up and good. Was optimistic it woul=
d
> go the same way this time as well :) In general I had to hard-reset (+
> fsck) a couple of times in recent times.

So, after each hard-reset, fsck is executed and no problem exposed by
btrfs check (before RW mount)?

That's interesting.

> Except for the SSD it's an
> all-new machine that I'm still OC/stress-testing. But not when that
> particular event happened.

A little off-topic, Linux + OC is not that common in my opinion.
Especially when we don't have AMD Ryzen Master to Intel XTU under linux.

>> Despite above salvage method, please also considering provide the
>> following data, as your case is pretty special and may help us to catc=
h
>> a long hidden bug.
> If only I had know I would have saved dmesg! :)
> Sure, I'd be happy to help. If you need any more information just let m=
e
> know.
>> 1) Extent tree dump
>> =C2=A0=C2=A0=C2=A0 Need above 2 patches applied first.
>>
>> =C2=A0=C2=A0=C2=A0 # btrfs inspect dump-tree -t extent /dev/sda2 &> \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /tmp/extent_tree_dump
>> =C2=A0=C2=A0=C2=A0 If above dump is too large, "grep -C20 166030671872=
" of the output is
>> =C2=A0=C2=A0=C2=A0 also good enough.
>=20
> I'll send you a link to the full dump directly.

It's good enough with the grepped result, feel free to delete the full du=
mp.


> =C2=A0=C2=A0=C2=A0 item 16 key (166030671872 EXTENT_ITEM 4096) itemoff =
3096 itemsize 51
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 refs 1 gen 1702074 flags TREE_BLO=
CK
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 tree block key (162793705472 EXTE=
NT_ITEM 4096) level 0
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 tree block backref root 2

So at least btrfs still consider that tree block should belong to extent
tree.

> =C2=A0=C2=A0=C2=A0 item 17 key (166030671872 BLOCK_GROUP_ITEM 107374182=
4) itemoff 3072
> itemsize 24
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 block group used 96915456 chunk_o=
bjectid 256 flags METADATA

Your metadata is SINGLE profile, default for SSD. Nothing special here.

Currently speaking, the problem looks like that tree log tree block get
allocated into extent tree (the only way btrfs allocate tree blocks
without update extent tree).
And when log tree get replayed, your fs is corrupted.

Did you have several hard-reset before the fs mounted RO itself?

>> 2) super block dump
>> =C2=A0=C2=A0=C2=A0 # btrfs inspect dump-super -f /dev/sda2
> superblock: bytenr=3D65536, device=3D/dev/sda2
> ---------------------------------------------------------
> csum_type=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0 (crc32c)
> csum_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4
> csum=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0xef0068ba=
 [match]
> bytenr=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 65536
> flags=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0x1
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 ( WRITTEN )
> magic=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 _BHRfS_M =
[match]
> fsid=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 22e778f7-2=
499-4379-99d2-cdd399d1cc6e
> label=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 830
> generation=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1706541

The offending tree block has generation 1705980, which is 561
generations ago.

Although it's hard to tell the real world time, at least the problem is
not directly caused by your first automatical RO remount.

The problem should exist for a while.

> root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1671041187=
84
> sys_array_size=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 97
> chunk_root_generation=C2=A0=C2=A0=C2=A0 1702072
> root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 1
> chunk_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 186120536064
> chunk_root_level=C2=A0=C2=A0=C2=A0 1
> log_root=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 180056702976> log_root_tr=
ansid=C2=A0=C2=A0=C2=A0 0

Not sure if this is common, need to double check later.

> log_root_level=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 0
> total_bytes=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 63879249920
> bytes_used=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 36929691648
> sectorsize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096
> nodesize=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 4096

Nodesize is not the default 16K, any reason for this?
(Maybe performance?)

>> 3) Extra hardware info about your sda
>> =C2=A0=C2=A0=C2=A0 Things like SMART and hardware model would also hel=
p here.
> smartctl 6.6 2017-11-05 r4594 [x86_64-linux-4.15.15-1-ARCH] (local buil=
d)
> Copyright (C) 2002-17, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:=C2=A0=C2=A0=C2=A0=C2=A0 Samsung based SSDs
> Device Model:=C2=A0=C2=A0=C2=A0=C2=A0 SAMSUNG SSD 830 Series

At least I haven't hear much problem about Samsung SSD, so I don't think
it's the hardware to blamce. (Unlike Intel 600P)


>> 4) The mount option of /dev/sda2
>=20
> /dev/sda2=C2=A0=C2=A0=C2=A0 /=C2=A0=C2=A0=C2=A0 btrfs compress=3Dzstd,d=
iscard,autodefrag,subvol=3D/=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0

Discard used to cause some problem, but it should be fixed in recent
release IIRC.

Despite that, discard option is not recommended IIRC, routine fstrim is
preferred instead.

>=20
> And if that matters (AFAIK subvolume mount options have no effect anywa=
y):
>=20
> /dev/sda2=C2=A0=C2=A0=C2=A0 /var/lib/postgres=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 btrfs
> compress=3Dzstd,discard,nodatacow,subvol=3Dvar/lib/postgres 0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0

RDB could cause a lot of fsync, at least this explains why the tree log
is so large.

To be safe, it's recommended to use notreelog mount option, which will
degrade fsync() to sync() for btrfs, so no log tree will be used.
Although it will bring performance impact for sync(), it could help us
to determine if it's really tree log to blame.

> /dev/sda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /var/cache=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs
> compress=3Doff,discard,subvol=3Dvar/cache=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> /dev/sda2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /var/tmp=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
btrfs
> compress=3Dzstd,discard,subvol=3Dvar/tmp=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=

>=20
>> Thanks,
>> Qu
>=20
> Got a couple of these:
> We seem to be looping a lot on /mnt/sda2/var/lib/postgres/data/.., do
> you want to keep going on ? (y/N/a): y

Not familiar with btrfs-restore, so hard to say.
But it seems to report false alert quite a lot. So keep it running seems
good.

Another way to verify if it's only your extent tree corrupted, btrfs
inspect dump-tree could be used here.

# btrfs inspect dump-tree -t <subvolid> /dev/sda2 > /dev/null

If no stderr is outputted for all your subvolid, then it's should be
pretty safe.

Thanks for your info, your info indeed shows pretty useful clue here.
4K nodesize (so taller tree, smaller lock range) and RDB workload may be
the key to the problem.


Thanks,
Qu

>=20
> Is this something I need to be worried about? Postgres did at least
> start up.
>=20
>=20
> Thanks a lot for your help!
> Timo
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--AcLzhkRP6IbFkijmeZ6tvT1bXJYwtzUZE--

--71uEPrv2EtG6LyQ4qt14SaprXnBHNQXQs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlrSEy4ACgkQwj2R86El
/qjHpgf5AdLz6nit4TkAHzlBomus74aZxJOLIPgd3XTbRVwYsbzysyfgV2mVSiQZ
hhLQT2n57OlTaNoLkOG4IqdVk+6qNF1XXrLtxPYR+zxKUWu+5s92MhqcC4m1HzBi
IBjTjeHHlhNw0llAJyAQdFV9auv2xJPpE8azoOVJGCBqB1Qlk1xFxwHwTXNMZYNR
fnhjAVlVlagwIivUrrGtLF0M67UHkbQFrnXgoPInOCBR0LqRloHtPCY3u8aRpEdA
KNBiT5Yg0D4s1Gi630wfLrHajjPyF8NRHoRJbgXdxm4qoc+lRXjmM47qU6nTfkzn
yp7YMsyoJPxN/LTYzivoWm8s6Rn4Yw==
=RvNu
-----END PGP SIGNATURE-----

--71uEPrv2EtG6LyQ4qt14SaprXnBHNQXQs--
