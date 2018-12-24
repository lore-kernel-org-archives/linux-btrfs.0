Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3190C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 13:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73FF020855
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 13:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbeLXNCx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 08:02:53 -0500
Received: from mout.gmx.net ([212.227.15.15]:39569 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbeLXNCw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 08:02:52 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LjIBr-1hEbFY2eOl-00dXo2; Mon, 24
 Dec 2018 14:02:48 +0100
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc:     Peter Chant <pete@petezilla.co.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
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
Message-ID: <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
Date:   Mon, 24 Dec 2018 21:02:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sVu9HiNKMOQqLHxyr5kIpnuo3bX9xoEDl"
X-Provags-ID: V03:K1:Wo8vIsZw+LF2qLz0rhR60ov3uLHsoqcfSE5ComILPOStoF+FGtl
 3wkvGTKwG9fKjEbsL9wZ8YGf1vXd7TFMAlI3Tv+9CWcT/zMJMlmg69gFy+Bh/E9HKS1Jfxw
 2OqDlSThtAEeW7SV2FxApdATOZWBnUKl0cA/g3ndTLt18GXjfMbMJBfbdfPyKODjfj7glxZ
 h91Uj3k2RBbbYm13k06cw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6mrQvRh5Uh0=:L+jp4OsYHZ9akjS55fKfNF
 HLGZOTq3Di2QFQJrTR1NKk95G9lT3KnGFrympaMwaCEL8LZ/kUaxDmsEx154z4ezzHuGmCIcF
 86F4ArWfIkBsQMtOSrUBQqRtflPpmvjLRBFLIM80tCK2ZQsChBiz/9WJSBpm0jrqbndRj7lns
 QmpqL3r4a8UkP17nrWC5tK1JI+Ep9rmdkQbDFcW2+F7cz2WK0YZMjn25JNeu93gSiC0+PIhb1
 nAz189BKMJs8SYuVIvk2SJ+Kj+k8JmpKRKAxRHGZaj4zKXlGR0kzsAh5QtZKxyqi9F+jvqLVe
 nn/43rO5TLXdXmlkc5Ouwb8b377CW9am0k2b1UisAlzS9WNqJVLd0Egn/JM1+gd67dmfZBVcT
 NtC+e0nXg9L5GduhMlWB6v+93K7dzNaHklj2qqoLUQSq+FgAqbxrm12yrjAGtE5Jg247KAQOz
 a5jrRVGqyf8wQANQriRmwJddRraQbi72+5mn8w89uHEtjVfR0dSZxTgtOZxabhSljuYDqi01Y
 P96p7sypNgvDkH/I8fgwvu0ol7SFtIswfW6QigvukrEqxL6QP9xzshBBJLv7nk4U5QcbEQzSF
 XIKokfjzc8JKjwm72Cij1y8k+LfXV3RD78SWjIJ2BGvNkqaDYHhtZTcIUoWGjneTScQUWYIac
 hRzQTYJrX1pizmIGb5BTxWBeyt4ALoyDcthHO/v24Cm+UbfFm94ZOi+1RzT2RLaNQMnrXFMuh
 XHuLpPfx0MNzE6lHHwoweHyRRsyQ3RW4JNbovazkhkq6vvxJgCxGpy79MkYRB/NutaIkGkhlh
 a0Y/llCxvyxwUAJkPWsSNLXeR110gEZig3jkjUU5g3+hQI4XIqnOHAU5D3LH81WhJxMnmiJvp
 j5GUVuqWV5A0X99fYp+vney0ZT4JE3t4CTFR62lXXkwoM/gVxrZRGi7NXRs7kE
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sVu9HiNKMOQqLHxyr5kIpnuo3bX9xoEDl
Content-Type: multipart/mixed; boundary="p0LC1ianXcgTBD6xztXFcRCt4dEAtw1as";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?VG9tw6HFoSBNZXRlbGth?= <tomas.metelka@metaliza.cz>
Cc: Peter Chant <pete@petezilla.co.uk>, Chris Murphy
 <lists@colorremedies.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <d29c3f7f-33b8-e1fc-e6ae-672a5bf52376@gmx.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <99716398-e99c-6ee9-e256-6d05fdc48122@petezilla.co.uk>
 <0024a4b2-7117-8d76-45c5-240e23edc29b@gmx.com>
 <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>
In-Reply-To: <5670f5ac-b9e9-8bed-67ee-d113a385a304@metaliza.cz>

--p0LC1ianXcgTBD6xztXFcRCt4dEAtw1as
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/24 =E4=B8=8B=E5=8D=888:48, Tom=C3=A1=C5=A1 Metelka wrote:
> Hi Qu,
>=20
> just 1 curious question (maybe 2) about your statement "log_root is 0":=

>=20
> What does it mean when log_root is non-zero?

This means there are some dirty log, namely caused by fsync().

You could consider log tree as some kind of journal used in ext/xfs.

Btrfs doesn't rely on log tree to keep its metadata consistent, but uses
it as a faster way to implement fsync().

For fs with dirty log, btrfs itself should be consistent no matter if we
replay the log or not.


The only certain thing a non-zero log tree shows is, there is definitely
an unexpected powerloss happened.
(But not vice verse, it's completely possible to hit a unexpected
powerloss without a dirty log, either it's lucky that no fsync() called
during that trans, or notreelog mount option is used)

> Because I have similar
> problem (unmountable FS ... I don't know how much but I know there's
> corrupted 2 subsequent items in chunk tree node)

Then the problem is not related to log root.
But either chunk tree get corrupted or metadata cow get exploited.

> and when I have made
> "btrfs inspect-internal dump-super":
>=20
> superblock: bytenr=3D65536, device=3D/dev/sda4
> ...
> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2488742
> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
232408301568
> sys_array_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 97
> chunk_root_generation=C2=A0=C2=A0=C2=A0 2487902
> root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> chunk_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 242098421760
> chunk_root_level=C2=A0=C2=A0=C2=A0 1
> log_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 232433811456

log_root is only recorded in the primary super block.
So it's fine that your backup super block doesn't contain log root.

It's the designed behavior.

> log_root_transid=C2=A0=C2=A0=C2=A0 0
> log_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>=20
> superblock: bytenr=3D67108864, device=3D/dev/sda4
> ...
> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2488742
> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
232408301568
> sys_array_size=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 97
> chunk_root_generation=C2=A0=C2=A0=C2=A0 2487902
> root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> chunk_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 242098421760
> chunk_root_level=C2=A0=C2=A0=C2=A0 1
> log_root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> log_root_transid=C2=A0=C2=A0=C2=A0 0
> log_root_level=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
>=20
> Unfortunately when I try to do "btrfs rescue chunk-recover" I get
> (beside others):
>=20
> "...
>=20
> Unrecoverable Chunks:
> =C2=A0 Chunk: start =3D 0, len =3D 4194304, type =3D 2, num_stripes =3D=
 1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Stripes list:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [ 0] Stripe: devid =3D 1, offset =3D 0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 No block group.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 No device extent.
>=20
> Total Chunks:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 184
> =C2=A0 Recoverable:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 183
> =C2=A0 Unrecoverable:=C2=A0=C2=A0=C2=A0 1
>=20
> Orphan Block Groups:
>=20
> Orphan Device Extents:
>=20
> Chunk tree recovery failed
> "
>=20
> And when I try "btrfs restore -m -S -v -i -D <dev>" I get only:
> Could not open root, trying backup super
> Could not open root, trying backup super
> ERROR: superblock bytenr 274877906944 is larger than device size
> 212000047104
> Could not open root, trying backup super
>=20
> Is it possible to recover data (at least some of them)? And is it worth=

> to upgrade to newest btrfs-progs?

btrfs check --readonly output please.

btrfs check --readonly is always the most reliable and detailed output
for any possible recovery.

Also kernel message for the mount failure could help.

btrfs ins dump-tree/super is only useful when we have some ideas to verif=
y.

Thanks,
Qu

>=20
> uname -a:
> Linux tisc5 4.15.0-43-generic #46-Ubuntu SMP Thu Dec 6 14:45:28 UTC 201=
8
> x86_64 x86_64 x86_64 GNU/Linux
>=20
> btrfs-progs v4.15.1
>=20
> Thanks
> Metaliza
>=20
>=20
> On 24. 12. 18 13:02, Qu Wenruo wrote:
>>
>>
>> On 2018/12/24 =E4=B8=8B=E5=8D=887:31, Peter Chant wrote:
>>> On 12/24/18 12:58 AM, Chris Murphy wrote:
>>>> On Sat, Dec 22, 2018 at 10:22 AM Peter Chant <pete@petezilla.co.uk>
>>>> wrote:
>>>>
>>>>> btrfs rescue super -v /dev/sdb2
>>>> ...
>>>>> All supers are valid, no need to recover
>>>>>
>>>>>
>>>>> btrfs insp dump-s -f <dev>
>>>> ...
>>>>> generation=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 7937947
>>>> ...
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 0:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1113909100544=C2=A0=C2=A0 gen:
>>>>> 7937935=C2=A0=C2=A0=C2=A0 level: 1
>>>> ...
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 1:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1113907347456=C2=A0=C2=A0 gen:
>>>>> 7937936=C2=A0=C2=A0=C2=A0 level: 1
>>>> ...
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 2:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1113911951360=C2=A0=C2=A0 gen:
>>>>> 7937937=C2=A0=C2=A0=C2=A0 level: 1
>>>> ...
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup 3:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 backup_tree_root:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1113907494912=C2=A0=C2=A0 gen:
>>>>> 7937934=C2=A0=C2=A0=C2=A0 level: 1
>>>> ...
>>>>
>>>>
>>>> The kernel wrote out three valid checksummed supers, with what seems=

>>>> to be a rather significant sanity violation. The super generation an=
d
>>>> tree root address do not match any of the backup tree roots. The
>>>> *current* tree root is supposed to be in one of the backups as well.=

>>>>
>>>
>>> I wonder if this is a result of my trying to fix things?=C2=A0 E.g. b=
trfs
>>> rescue super-recover or my attempts using the tools (and kernel) in M=
int
>>> 18.1 at one point?
>>
>> At least super-recover is not responsible for this.
>> While btrfs check --repair could indeed cause problems.
>>
>> So it may be the case.
>>
>>>
>>> I must admit, early on I had assumed that either this file system was=
 a
>>> simple fix or was completely trashed, so I thought I'd have a quick g=
o
>>> at fixing it, or wipe it and start again.=C2=A0 But then I seemed to =
get
>>> close with only the one error, but unmountable.
>>>
>>>
>>>> Qu, any idea how this is even theoretically possible? Bit flip right=

>>>> before the super is computed and checksummed? Seems like some kind o=
f
>>>> corruption before checksum is computed.
>>>>
>>>>
>>>>> I'm getting suspicious of the drive as when I was trying the variou=
s
>>>>> btrfs rescue * tools I saw a 'bad block', or similar, error display=
ed.
>>>>> I also have a separate basic install on ext4 on the same disk.=C2=A0=
 Though
>>>>> e2fsck shows no errors and mounts fine I cannot log into that insta=
ll.
>>>>> Maybe a coincidence, but too many bad things thrown up make me
>>>>> suspicious.=C2=A0 Whatever is happening this seems to be really fig=
hting
>>>>> me.
>>>>
>>>> I'm not sure how even a bad device accounts for the super generation=

>>>> and backup mismatches. That's damn strange.
>>>
>>> I'm less suspicious of the drive now.=C2=A0 I've been using an ext4 p=
artition
>>> on the same drive for a few days now, having reinstalled on that and
>>> everything _seems_ fine.=C2=A0 Mind you, apart from usb sticks, I've =
not
>>> experienced a ssd failure.=C2=A0 Perhaps my hdd failure experience is=
 not
>>> relevent, i.e. they work until they start throwing errors and then
>>> rapidly fail?
>>
>> I don't really believe a drive can be so easily corrupted to certain
>> bits while all other bits are OK.
>>
>>>
>>>
>>>>
>>>> If you get bored with the back and forth and just want to give up,
>>>> that's fine. I suggest that if you have the time and space, to take =
a
>>>> btrfs-image in case Qu or some other developer wants to look at this=

>>>> file system at some point. The btrfs-image is a read only process, c=
an
>>>> be set to scrub filenames, and only contains metadata. Size of the
>>>> resulting file is around 1/2 of the size of metadata, when doing
>>>> 'btrfs filesystem usage' or 'btrfs filesystem df'. So you'll need th=
at
>>>> much free space to direct the command to.
>>>>
>>>> btrfs-image -ss -c9 -t4 <devicetoimage> pathtofile
>>>
>>> Just done that:
>>> bash-4.3# btrfs-image -ss -c9 -t4 /dev/sdd2
>>> /mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_20181224.img
>>> WARNING: cannot find a hash collision for '..', generating garbage, i=
t
>>> won't match indexes
>>>
>>>
>>>
>>>>
>>>> It might fail, if so you can try adding -w and see if that helps.
>>>
>>>
>>> OK, try with -w:
>>>
>>> OK, many many complaints about hash collisions:
>>> ...
>>> ARNING: cannot find a hash collision for 'ifup', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'catv', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'FDPC', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'LIBS', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'INTC', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'SPI', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'PDCA', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'EBI', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'SMC', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'WIFI', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'LWIP', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'HID', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'yun', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'avr4', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'avr6', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'WiFi', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'TFT', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'Knob', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'FP.h', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'SD.h', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'Beep', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'FORK', generating garbage,=
 it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'CHM', generating garbage, =
it
>>> won't match indexes
>>> WARNING: cannot find a hash collision for 'HandS', generating garbage=
,
>>> it won't match indexes
>>> WARNING: cannot find a hash collision for 'dm-0', generating garbage,=
 it
>>> won't match indexes
>>>
>>>
>>> Now seems to stopped producing output.=C2=A0 Can't see if it is doing=

>>> something useful.=C2=A0 (note, started again, more such messages)
>>
>> I don't know about other developers, normally I don't like btrfs-image=

>> -ss at all.
>>
>> Even plain btrfs-image isn't so helpful, especially considering its si=
ze.
>>
>> Anyway, from all the data you collected, I suspect it's a corruption i=
n
>> tree blocks allocation, maybe a btrfs bug in older kernels, which buri=
ed
>> a dangerous seed into the fs, breaking the metadata CoW.
>>
>> And one day, an unexpected powerloss makes the seed grow and screw up
>> the fs.
>>
>> Just a personal recommendation, for btrfs especially used with older
>> kernels, after a powerloss, it's highly recommended to run btrfs check=

>> --readonly before mounting it.
>>
>> Thanks,
>> Qu
>>
>>>
>>>
>>>>
>>>> There is no log listed in the super so zero-log isn't indicated, and=

>>>> also tells me there were no fsync's still flushing at the time of th=
e
>>>> crash. The loss should be at most a minute of data, not an
>>>> inconsistent file system that can't be mounted anymore. Pretty weird=
=2E
>>>>
>>>
>>> I think I ran zero-log to see if that helped.=C2=A0 Given that there =
was no
>>> important data and I'd assume I'd either easily fix it, or wipe it an=
d
>>> start over I may have taken the 'monkey radomly pounding the buttons'=

>>> approach, short of 'btrfs check --repair'.=C2=A0 I only posted here a=
s I
>>> though I'd fixed it apart from the one error!=C2=A0 If it were a simp=
le fix
>>> then it was worth asking.
>>>
>>>
>>>> What were your mount options? Defaults? Anything custom like discard=
,
>>>> commit=3D, notreelog? Any non-default mount options themselves would=
 not
>>>> be the cause of the problem, but might suggest partial ideas for wha=
t
>>>> might have happened.
>>>>
>>> fstab states:
>>> autodefrag,ssd,discard,noatime,defaults,subvol=3D_r_sl14.
>>> 2,compress=3Dlzo
>>>
>>> However, I used an initrd, so I'm not sure if that is correct?
>>>
>>> Ok, digging into init within my initrd, the line where the root parti=
on
>>> is mounted:
>>> =C2=A0=C2=A0 mount -o ro -t $ROOTFS $ROOTDEV /mnt
>>>
>>> Where $ROOTFS is:
>>> btrfs -o subvol=3D_r_sl14.2
>>>
>>> and $ROOTDEV is:
>>> /dev/disk/by-uuid/6496aabd-d6aa-49e0-96ca-e49c316edd8e
>>>
>>>
>>>
>>> Pete
>>>
>>


--p0LC1ianXcgTBD6xztXFcRCt4dEAtw1as--

--sVu9HiNKMOQqLHxyr5kIpnuo3bX9xoEDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwg2PIACgkQwj2R86El
/qgB+Qf/dw0YcLolw3jh0icdgwz7CUNCy+AeBn09ZxR5Ea1b8LHoFE1bDRnnN6tB
fuYQ00NFTUL0Iq53LImHcG0FDn44sN+WLopgA/5uHobTxVgYbLbdiCZvMEZWH5Rl
InaYCRcfpXm7Ic76GgXSoCx4tSPbx6Bh/52MHThJWhXY/pCMxB1HWVuYl83pLjJA
H1gDbNOBHvf90Kw901jgvht+lfUY0aOIye2iC3jisoErO6oz+XfY4U/PtkmM/kTa
bsMhrc2AP46474u8JLn19rjj+ubi0ffiXIOv52Q3OxDHbnTPfHW4PevJHfFLXlRc
KnO704i8tSy+rf24fedrUUZjGNCzcQ==
=1+dD
-----END PGP SIGNATURE-----

--sVu9HiNKMOQqLHxyr5kIpnuo3bX9xoEDl--
