Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C83FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD0421900
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 12:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387570AbfBNMZf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:25:35 -0500
Received: from mout.gmx.net ([212.227.15.18]:34551 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbfBNMZe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 07:25:34 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lmqxo-1hZ40T2eGi-00h5UI; Thu, 14
 Feb 2019 13:25:30 +0100
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
To:     Jesper Utoft <jesper.utoft@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
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
Message-ID: <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
Date:   Thu, 14 Feb 2019 20:25:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WRrA4e2xSJAFclo7FRl3RJrTXILYwVm9q"
X-Provags-ID: V03:K1:H3fQWsRHmq3zElV1rxRZXjgVsORl4fOqJgZOlGKOwv/UVNGCr6K
 y2eNUAUKBsJ4aIxlrmanEFrXUWzl9WlHpfRP4DvLf72KCWWiPiYgrhhPDRPCVRMPhrfDMZe
 bUueJWc55xBk0AcearBcYqs1NDgbqEfg3XmF0eWTlcRNN32nHuRP+WzdJJeYFYZ3JitVJbK
 W3RI1L6Y5ecXlqTwUZfqg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8UW63UPysQg=:x9z6TMACgaifSmRyiLQ18R
 /tPA1UsMkTPSZnRqAuAYZCJxmokXzc4e6Ixbx42+x4H4nB80IHdd+BpOO/LdcF9GUeL5e68v4
 U7U82JUqKxePGIyXV20OgH2GOMsv2m2ir/3K8lEulSWlpXU98mml4gav3GDk0f7pAwDN4lI9e
 xHxf7FG69bIkBrEm6V+FbImKbQhbunPI9rv+PO9A5R6mAzM94O40VLqemfRaE96ndd/I8aQOF
 hUI9HO1ugGxebbvXSJuypaWat830UDDSG5O57wSueEbnTDZ9FwUAn53PzUkjcVCAxLm9Pbovn
 9kqGTJTFBE/JOoGlnohuifAp4w+R1uL+hNm3UBKq6S1nguawRe/lnjdCTtDUVsWcGZqfEU9gE
 N4FY083ojAeMuQ7oYVJS2t6zBRneMMBcXet4lREqrWQMJGiuQzgu/BRsuuuktcWpD51YOMZeY
 c5aKFPZIISVKaQM2PDds42/tpI95AZSYCBXsnmF+JSrndfoXFR5ao69RfaFzE0hW7YoVZ3mZp
 xe7BU6r2ppTRCHMC3nbwDV/MuRkWWlkt0/V+5VvC7ZT6dNRf9p0JpkgIEm4f72UpAM0vg7Xbr
 QV6/etStuEfBimuEO2IvtaafFmeoy6GYgpS8u6w4Yue9Nz8R9eFOeTbtk5T26rNovKCB3IBUu
 WHj6jxL0tcTt5kF/qA/23Wd/vqknaWIC2Nu9tSeuce/G9jvg3U26wv/bb4ATo9C2Cg52U/fTi
 hySbAI23HmTKKgnR/slvyqNezQhgdWlPgvVJjNdAHlPXKn13Cv00+YKykgr4I4AJW3Eos4uBO
 kIZNZSevPC+snOxn0fQWAJij5V5NKjr9/ouASxTyicRQ9ZfCi8gdUelcsKPknjScFKcLHmaHO
 Dba+YQq1JCkwOjz1zjXiLekaf/AApMMByI8NNSqgJdQQ4Ghqyi3F6zSmTqQvID
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WRrA4e2xSJAFclo7FRl3RJrTXILYwVm9q
Content-Type: multipart/mixed; boundary="lgxfoYkzcb2C7VTbALJxLVlqzLjXddkTK";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Jesper Utoft <jesper.utoft@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <717fd0a7-68ff-da60-b7e5-4223d16d0b54@gmx.com>
Subject: Re: corrupt leaf: root=1 block=57567265079296 slot=83, bad key order
References: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>
In-Reply-To: <CAOna0f32bUq=jaJQjHdeQjRxbkANmE8FvL=-6qpYFHAwhND_ZQ@mail.gmail.com>

--lgxfoYkzcb2C7VTbALJxLVlqzLjXddkTK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/14 =E4=B8=8B=E5=8D=887:58, Jesper Utoft wrote:
> Hello Fellow BTRFS users.
>=20
> I have run into the bad key order issue.
> corrupt leaf: root=3D1 block=3D57567265079296 slot=3D83, bad key order,=
 prev
> (18446744073709551605 0 57707594776576) current (18446726481523507189
> 0 57709742260224)
> The lines repeats over and over..
>=20
> I read a thread between Hugo Mills and Eric Wolf about a similar issue
> and i have gathered the same info.=20
Now we have all the needed info.

>=20
> I understand that it probably is hardware related, i have been running
> memtest for 60h+ to see if i could reproduce it.
> I also tried to run btrfs check --recover but it did not help.
>=20
> My questions is if it can be fixed?

Yes, but only manual patching is possible yet.

[snip]
> [  550.070483] BTRFS critical (device sdc4): corrupt leaf: root=3D1
> block=3D57567265079296 slot=3D83, bad key order, prev
> (18446744073709551605 0 57707594776576) current (18446726481523507189
> 0 57709742260224)
> [  550.070569] BTRFS warning (device sdc4): btrfs_uuid_scan_kthread fai=
led -5
>=20
> Debug info:
> sudo btrfs inspect-internal dump-tree -b 57567265079296 --follow /dev/s=
da4
> btrfs-progs v4.16.1
> leaf 57567265079296 items 246 free space 47 generation 7325984 owner RO=
OT_TREE
> leaf 57567265079296 flags 0x1(WRITTEN) backref revision 1
> fs uuid 90900a21-8a71-4301-b5c2-21dea31f1132
> chunk uuid b3eed334-68af-43e6-ae1e-c05e504f30cf
>     item 0 key (FREE_SPACE UNTYPED 57557270921216) itemoff 16242 itemsi=
ze 41
>         location key (74274 INODE_ITEM 0)
>         cache generation 7325984 entries 308 bitmaps 8
>     item 1 key (FREE_SPACE UNTYPED 57558344663040) itemoff 16201 itemsi=
ze 41
>         location key (74275 INODE_ITEM 0)
>         cache generation 7325984 entries 338 bitmaps 8
> ... [snip] ...
>     item 81 key (FREE_SPACE UNTYPED 57705447292928) itemoff 12921 items=
ize 41
>         location key (74392 INODE_ITEM 0)
>         cache generation 2530576 entries 0 bitmaps 0
>     item 82 key (FREE_SPACE UNTYPED 57707594776576) itemoff 12880 items=
ize 41
>         location key (74393 INODE_ITEM 0)
>         cache generation 2530576 entries 0 bitmaps 0
>     item 83 key (18446726481523507189 UNKNOWN.0 57709742260224) itemoff=
 12839 itemsize 41
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Thankfully, all keys around give us a pretty good idea what the original
value should be: (FREE_SPACE UNTYPED 57709742260224).

And for the raw value:
bad:  0xffffeffffffffff5
good: 0xfffffffffffffff5
            ^
e->f, one bit get flipped.
(UNTYPED is the same value for UNKNOWN.0, so don't worry about that).

I have created a special branch for you:
https://github.com/adam900710/btrfs-progs/tree/dirty_fix

Just compile that btrfs-progs, no need to install, then excute the
following command inside btrfs-progs directory:

# ./btrfs-corrupt-block -X <device>

And your report just remind me to update the write time tree block
checker....

Thanks,
Qu

>     item 84 key (FREE_SPACE UNTYPED 57711889743872) itemoff 12798 items=
ize 41
>         location key (74395 INODE_ITEM 0)
>         cache generation 2530576 entries 0 bitmaps 0
>     item 85 key (FREE_SPACE UNTYPED 57714037227520) itemoff 12757 items=
ize 41
>         location key (74396 INODE_ITEM 0)
>         cache generation 5542000 entries 0 bitmaps 0
> ... [snip] ...
>=20


--lgxfoYkzcb2C7VTbALJxLVlqzLjXddkTK--

--WRrA4e2xSJAFclo7FRl3RJrTXILYwVm9q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxlXjYACgkQwj2R86El
/qiWWwf+KBNBYZAP8NGyRUmLzJLiqEd12gze7pXpdCt1AJqPWHXaN5h96aIYiTO8
s1h49IyjUXawnU0pGEHQCG0Pa8EaYbvYf0yU0LCQHrPhNJg//13wqX68jxr9bqEi
p409Hq5RIdwRHQEprlXIat1gUATTNDKwRzkwy7Za36gOVpR6ucenwDBgXGhJC7pT
UqOzL5mA7+NNq9qNPkCIaV5ThtgPHXd7Uej7BIPXsShq8acIAYele75xlsY1NmOe
yDlsTa/DwvKtQsTE7tAwS7euL3YVbjzWFRAr1j4NvibcWkaGOOzAOihLnkRv/hXt
LUmDnXdB6mBpaw9GT26BL8aXm24kGg==
=XdpS
-----END PGP SIGNATURE-----

--WRrA4e2xSJAFclo7FRl3RJrTXILYwVm9q--
