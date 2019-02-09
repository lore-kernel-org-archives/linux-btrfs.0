Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599D9C282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 12:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26C6B20863
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 12:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfBIMQU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 07:16:20 -0500
Received: from mout.gmx.net ([212.227.17.22]:36359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbfBIMQT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Feb 2019 07:16:19 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MfzEP-1gVZ7K3yIX-00NTiJ; Sat, 09
 Feb 2019 13:16:16 +0100
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
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
Message-ID: <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
Date:   Sat, 9 Feb 2019 20:16:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3JVEzO07EazwOAMQ2VwloS7nzQ4rdAPoZ"
X-Provags-ID: V03:K1:vR9xyFZfuL3810aXGa7INT+1xRmrxk/6cpJoTNt0DWyRQFbI1fd
 sR8j8OvY1eWiT/+Q449y3GFoxwClm7wwg5Rwu6WWS2m24uEH1fK4CvMeuh6cOI6cLjs44VN
 wAtP+gxoXNKilZru8xKOBlAJoKo8eNHoQ4Ak9a815KLDA95ZsUU6vzm4YCVLaVabA52x3Un
 E84xGs+UuOqDScexu838Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2olx1cFSzkY=:YRu72ckHSuP7U9/I3JtE7P
 UbLo3OJ6/t/uxHdFZoHq4WOu+CWAMHjQ3pyRW8qA7Ilh3EsD95QJxyjyaA5wYlm8fvUC/Yjj/
 GS/T87uNXaNLWU2jd3maLDrPTLFFLDWGf6dTzsEuXLkNb4x51EKVaV5caIhOfuMpRXovBNyeZ
 DRpb3kK2mX0yS3kFGuMy4Lkoba3yxZeLL0Z6QqsLbZJ4Y/sRnhlOZwcOYezZFyGfE2dvXFW+B
 rkeNJ5SYiuOio5MTfltyZrmG4TtfvLPprP4whauganLkqqt6NHb9qUk6DhxsrVXULMZxcSKy0
 Gvseh4LdgrHcF5Gn7/UCkOp0VGs2hAqhzS8cJW0eou+2SsBYAFoahR9xtMiZqdeqp0i/bhs2O
 PfEBm+K8ryGiA7MOMMdMRRHpeyGDiDHJhOWnHqyasNsib2splfB7pc2baB8nLl2Bsvsue7YCK
 Mrfr+4Gt6qQnwMpNiVHMybvY+4QgiYfEpZMwNVA3FY2ZZ4nvovenjLH9CvT4j9CzsvdDYCNxQ
 H9NS85U9mAYLlxGVlqARE84cJ+eTTXAfj1/2pE1psHlJxV3nAw0nLXEqcpu+QZKcEIuDTsu5Q
 Y3kF7PL+W5z4a6ygGWQ6JG4B+0fzjk7gPA5HSr69NjsiGujbyO9CblbpZhQbSqRdhOfIC2hhz
 DNY3hyr8pB2nafP2YFoDO4R2/rC9LTSOuFRjKmNMqd/+nskQZxtwdNWmWiSHLQ+owZYiOeiuk
 Ovv1va9/RBoI6/7tWRCcmmnEBq9boXnHPBOO9XWMLgBk/sT13jxH5tGs7ykCBzSkO8jomF8UN
 QWRgy7s/dgjhLW5DDMNSoC68FjtUPeSk8ujwVIhmpZ1MTZ3fTi/RApjVyQbyZQPHP6ksFdKCz
 mkb2VQt88UkrG4Y8Pmz4Y8JTPW1oXLxvAiXfkRsYbOy6QWdO9oisXQNCClClcF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3JVEzO07EazwOAMQ2VwloS7nzQ4rdAPoZ
Content-Type: multipart/mixed; boundary="AC0uvjwxeQFqzFTkNggmCBdNUGLE5Mz64";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>,
 linux-btrfs@vger.kernel.org
Message-ID: <5441dc9d-a552-e77e-f74d-fe6ef702d400@gmx.com>
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
In-Reply-To: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>

--AC0uvjwxeQFqzFTkNggmCBdNUGLE5Mz64
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/9 =E4=B8=8B=E5=8D=886:36, Jakob Sch=C3=B6ttl wrote:
> Hi,
>=20
> I've setup a RAID1 with two disks (disk1 and disk2) and I'm testing the=

> btrfs replace command.
>=20
> After replacing disk2 with disk3, I can only mount
> (a) disk1 or disk3 (if both disk are plugged) and
> (b) the original disk1 (degraded, if disk3 is unplugged).
>=20
> I cannot mount the replacement disk3 if disk1 is unplugged.

Sounds like there is one single chunk on disk1, which caused the problem.=


>=20
>> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3,
> missing codepage or helper program, or other error.

dmesg please.

And btrfs-progs version please.

Maybe mkfs is too old to leave SINGLE profile chunks on the original fs.

And you could verify the chunk mapping by executing 'btrfs ins dump-tree
-t chunk <device>' and paste the output.

Thanks,
Qu

>=20
> What I expect is that both disk1 and disk3 are fully valid and working
> after a replace.
>=20
> Steps to reproduce:
>=20
> =C2=A0 dd if=3D/dev/zero of=3D/vdisk1 bs=3D1024 count=3D300000
> =C2=A0 losetup /dev/loop1 /vdisk1
> =C2=A0 dd if=3D/dev/zero of=3D/vdisk2 bs=3D1024 count=3D300000
> =C2=A0 losetup /dev/loop2 /vdisk2
> =C2=A0 dd if=3D/dev/zero of=3D/vdisk3 bs=3D1024 count=3D300000
> =C2=A0 # losetup /dev/loop3 /vdisk3=C2=A0=C2=A0=C2=A0 # don't plug this=
 device yet
>=20
> Create RAID1 file system:
>=20
> =C2=A0 mkfs.btrfs -L datavol -m raid1 -d raid1 /dev/loop1 /dev/loop2
>=20
> Unplug device 2 to simulate a defect:
>=20
> =C2=A0 losetup -d /dev/loop2
>=20
> Plug device 3:
>=20
> =C2=A0 losetup /dev/loop3 /vdisk3
>=20
> Replace device 2 with device 3:
>=20
> =C2=A0 mount -o degraded /dev/loop1 /mnt
> =C2=A0 btrfs filesystem show=C2=A0=C2=A0 # to get devid of device 2
> =C2=A0 btrfs replace start -Br 2 /dev/loop3 /mnt
> =C2=A0 btrfs replace status /mnt=C2=A0=C2=A0 # check success
> =C2=A0 umount /mnt
>=20
> Unplug the original device 1 to see if device 3 has really replaced
> device 2:
>=20
> =C2=A0 losetup -d /dev/loop1
> =C2=A0 mount -o degraded /dev/loop3 /mnt
>=20
> The mount fails with this error:
>=20
>> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/loop3,
> missing codepage or helper program, or other error.
>=20
> In this situation, btrfs device scan does not change anything and btrfs=

> filesystem show shows:
>=20
>> warning, device 1 is missing
>> warning, device 1 is missing
>> warning, device 1 is missing
>> warning, device 1 is missing
>> bad tree block 198180864, bytenr mismatch, want=3D198180864, have=3D0
>> ERROR: cannot read chunk root
>> Label: 'datavol'=C2=A0 uuid: 640e45d3-e741-4a78-a24e-2d8a41c6b8c3
>> =C2=A0=C2=A0=C2=A0 Total devices 2 FS bytes used 128.00KiB
>> =C2=A0=C2=A0=C2=A0 devid=C2=A0=C2=A0=C2=A0 2 size 292.97MiB used 104.0=
0MiB path /dev/loop3
>> =C2=A0=C2=A0=C2=A0 *** Some devices missing
>=20
> Is this a known problem? Can you reproduce it? Am I doing something wro=
ng?
>=20
> Regards, Jakob
>=20


--AC0uvjwxeQFqzFTkNggmCBdNUGLE5Mz64--

--3JVEzO07EazwOAMQ2VwloS7nzQ4rdAPoZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxexI0ACgkQwj2R86El
/qiWGwf6A3wibmp3iXQ4hD0e6DyWxmj1JPPE3JdMMu/CMEI1GS95GiVjYFOZSWi2
LS6NUkB52lQHW5s7bsmUWFpHH6fgWF4S3fR7g8XUlikzKeCv2gyI4z+QNf5hmYj5
tgCJCMwYjCLktYx2k6RI8cHrC6sVMFaB138Ouant0p0ty3wpZVT5NHr0JJOLG9zM
Gs2sVOmUHgRUaz73AjSV4AQSE3/b3rU6Yxz/SjX7Egojiw+O748kzDgR4HhR9J2v
LmVH8r9QhMGo/x4kZBED/o/vhbb2li4hsQKXm7kMbHhnXa2gvR+Qw/JydtkyEOe8
5zZttO8R/CzdFNATGzne9RwcuEKm9Q==
=/etQ
-----END PGP SIGNATURE-----

--3JVEzO07EazwOAMQ2VwloS7nzQ4rdAPoZ--
