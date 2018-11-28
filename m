Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304A3C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF2262081B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 13:54:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF2262081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbeK2A43 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 19:56:29 -0500
Received: from mout.gmx.net ([212.227.17.22]:45463 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbeK2A43 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 19:56:29 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LfkJC-1fcj6p4A2s-00pJKX; Wed, 28
 Nov 2018 14:54:43 +0100
Subject: Re: Balance: invalid convert data profile raid10
To:     Mikko Merikivi <mikkommm@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
 <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
 <CAFmqBACW=tf5ATAr7vNvtQ0ZLMEaJOw7-vEifbuc2CKKaQa7HA@mail.gmail.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <7b9f7c3f-910d-943b-93ac-72b237c7c013@gmx.com>
Date:   Wed, 28 Nov 2018 21:54:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAFmqBACW=tf5ATAr7vNvtQ0ZLMEaJOw7-vEifbuc2CKKaQa7HA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="igIC8lzzb8V25RKBgt3DEHJySJlPtDb4y"
X-Provags-ID: V03:K1:OSHq19XE/sNMhjA+MXG9B9YYYlYQHd9cadqtmutmx9/9IFip68u
 harahVdVea+J1QDFfW1mYjygsrvzQ9fuXR4GlmTIUVeOgToPiR179PULCW8jYZJReq3EtJk
 GRJHkuwjnoVfJoAn2fgT0LRVO3DnLk7B2fRXESeJxwwbe1fvMmucKh3/mnrgGNteeJp0AZI
 EOoY/yMpC/rOzOldv+/Xw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qxxVHdffGtk=:ZfCdKcIPnxiI1hzZh6yHRP
 G7krJiGQwTSjNtTb69A5W/NO5jWSJS6BAnAXegcQh7c6+8KczVDRM4X51L7MoEBPI0ZEEYpZK
 NFBAkvvMsSvCUco9HxOsIwS2gtTGeU5L9GQcoN3nVHsVVUlJawpldLdoqXvrIoslmpde+x+Dz
 4jtlNTV9x+U9fVkGrYpYG40RRac1TSsr/RU1atrvr50aOOGKwTZqQNRHADy/Q4FmLRvWQDDXF
 XSeBGkXHcZWKUw4j6OhbYyJmbxigZZiNcfFAySawf7oTPvykn7cUPo3Am0L79Nyk0bvnZBAI2
 OjDIntF5FcxzlXJInZrHrKqMGKsOA/NYmpRTVcxLmGsiIIpZGek0WMWmkKtJQNgYuLyV2TZXl
 ZtIj7/GB31AaZGkSu+lEbFDE2wERm4qxpmfkTaOWStokc9wKXw5CHeivv/MtzGFbRxA7wgVQH
 C7kUnAT3Cl+Y2WAO6vzefBtbQZsuALtVlq9pBpBkTaPK2TbNln3Y4XuvrcxOtZIqNmfgUQlvm
 ZgA8Pj+ULSU/fXKenFxQ/Y3LkusuCJOhXt8USxJPskUBSF6oUIEUX7K1eTd6W5tKPr8petjvo
 HX1yC93O67iIDhxYvRNsRvII0ISx7HalIqHAV6RTJcRRtNRcSVSWWBJ7qZTNQFIXxAvcPxaex
 Lha5V/7/MlXXDe7OXTTVLNYKmXVyT+bpmkgjNAUb+2wr89LTNv7Oa8yJuy8/vR/n4hLNjLqYl
 Bt2cUOM5b1sWhJdq1HQCmtqIj0Kx1QrDUZqrBoiR5JQY4G/1qMFrYqgT833yVIfA2OMXOripK
 LAO/83txF/xNjnZ2YSn9Dh1nIUEPQxviVhM6otdcY8e867/r9rg0FEuDgtFZcEFtKcSjgA9FO
 7+vFI87nCgcsIaAtnfDOb8mOiuS6zHYZhgQie8KJB4jKuQPshRJ6LPZzj1KIVa
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--igIC8lzzb8V25RKBgt3DEHJySJlPtDb4y
Content-Type: multipart/mixed; boundary="aDAZVWvE3nAlLASVBLqHG4EtctVSjAd2Z";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mikko Merikivi <mikkommm@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <7b9f7c3f-910d-943b-93ac-72b237c7c013@gmx.com>
Subject: Re: Balance: invalid convert data profile raid10
References: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
 <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
 <CAFmqBACW=tf5ATAr7vNvtQ0ZLMEaJOw7-vEifbuc2CKKaQa7HA@mail.gmail.com>
In-Reply-To: <CAFmqBACW=tf5ATAr7vNvtQ0ZLMEaJOw7-vEifbuc2CKKaQa7HA@mail.gmail.com>

--aDAZVWvE3nAlLASVBLqHG4EtctVSjAd2Z
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8B=E5=8D=883:20, Mikko Merikivi wrote:
> Well, excuse me for thinking it wouldn't since in md-raid it worked.
> https://wiki.archlinux.org/index.php/RAID#RAID_level_comparison
>=20
> Anyway, the error message is truly confusing for someone who doesn't
> know about btrfs's implementation. I suppose in md-raid the near
> layout is actually RAID 1 and far2 uses twice as much space.
> https://en.wikipedia.org/wiki/Non-standard_RAID_levels#LINUX-MD-RAID-10=

>=20
> Well, I guess I'll go with RAID 1, then. Thanks for clearing up the con=
fusion.

You should check mkfs.btrfs(8).
It has a pretty good datasheet for all supported profiles under PROFILES
section, and it mentions min/max devices.

Thanks,
Qu


> ke 28. marrask. 2018 klo 3.14 Qu Wenruo (quwenruo.btrfs@gmx.com) kirjoi=
tti:
>>
>>
>>
>> On 2018/11/28 =E4=B8=8A=E5=8D=885:16, Mikko Merikivi wrote:
>>> I seem unable to convert an existing btrfs device array to RAID 10.
>>> Since it's pretty much RAID 0 and 1 combined, and 5 and 6 are
>>> unstable, it's what I would like to use.
>>>
>>> After I did tried this with 4.19.2-arch1-1-ARCH and btrfs-progs v4.19=
,
>>> I updated my system and tried btrfs balance again with this system
>>> information:
>>> [mikko@localhost lvdata]$ uname -a
>>> Linux localhost 4.19.4-arch1-1-ARCH #1 SMP PREEMPT Fri Nov 23 09:06:5=
8
>>> UTC 2018 x86_64 GNU/Linux
>>> [mikko@localhost lvdata]$ btrfs --version
>>> btrfs-progs v4.19
>>> [mikko@localhost lvdata]$ sudo btrfs fi show
>>> Label: 'main1'  uuid: c7cbb9c3-8c55-45f1-b03c-48992efe2f11
>>>         Total devices 1 FS bytes used 2.90TiB
>>>         devid    1 size 3.64TiB used 2.91TiB path /dev/mapper/main
>>>
>>> Label: 'red'  uuid: f3c781a8-0f3e-4019-acbf-0b783cf566d0
>>>         Total devices 2 FS bytes used 640.00KiB
>>>         devid    1 size 931.51GiB used 2.03GiB path /dev/mapper/red1
>>>         devid    2 size 931.51GiB used 2.03GiB path /dev/mapper/red2
>>
>> RAID10 needs at least 4 devices.
>>
>> Thanks,
>> Qu
>>
>>> [mikko@localhost lvdata]$ btrfs fi df /mnt/red/
>>> Data, RAID1: total=3D1.00GiB, used=3D512.00KiB
>>> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
>>> Metadata, RAID1: total=3D1.00GiB, used=3D112.00KiB
>>> GlobalReserve, single: total=3D16.00MiB, used=3D0.00B
>>>
>>> ---
>>>
>>> Here are the steps I originally used:
>>>
>>> [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
>>> --use-random /dev/sdc
>>> [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
>>> --use-random /dev/sdd
>>> [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdc red1
>>> [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdd red2
>>> [mikko@localhost lvdata]$ sudo mkfs.btrfs -L red /dev/mapper/red1
>>> btrfs-progs v4.19
>>> See http://btrfs.wiki.kernel.org for more information.
>>>
>>> Label:              red
>>> UUID:               f3c781a8-0f3e-4019-acbf-0b783cf566d0
>>> Node size:          16384
>>> Sector size:        4096
>>> Filesystem size:    931.51GiB
>>> Block group profiles:
>>>   Data:             single            8.00MiB
>>>   Metadata:         DUP               1.00GiB
>>>   System:           DUP               8.00MiB
>>> SSD detected:       no
>>> Incompat features:  extref, skinny-metadata
>>> Number of devices:  1
>>> Devices:
>>>    ID        SIZE  PATH
>>>     1   931.51GiB  /dev/mapper/red1
>>>
>>> [mikko@localhost lvdata]$ sudo mount -t btrfs -o
>>> defaults,noatime,nodiratime,autodefrag,compress=3Dlzo /dev/mapper/red=
1
>>> /mnt/red
>>> [mikko@localhost lvdata]$ sudo btrfs device add /dev/mapper/red2 /mnt=
/red
>>> [mikko@localhost lvdata]$ sudo btrfs balance start -dconvert=3Draid10=

>>> -mconvert=3Draid10 /mnt/red
>>> ERROR: error during balancing '/mnt/red': Invalid argument
>>> There may be more info in syslog - try dmesg | tail
>>> code 1
>>>
>>> [mikko@localhost lvdata]$ dmesg | tail
>>> [12026.263243] BTRFS info (device dm-1): disk space caching is enable=
d
>>> [12026.263244] BTRFS info (device dm-1): has skinny extents
>>> [12026.263245] BTRFS info (device dm-1): flagging fs with big metadat=
a feature
>>> [12026.275153] BTRFS info (device dm-1): checking UUID tree
>>> [12195.431766] BTRFS info (device dm-1): enabling auto defrag
>>> [12195.431769] BTRFS info (device dm-1): use lzo compression, level 0=

>>> [12195.431770] BTRFS info (device dm-1): disk space caching is enable=
d
>>> [12195.431771] BTRFS info (device dm-1): has skinny extents
>>> [12205.815941] BTRFS info (device dm-1): disk added /dev/mapper/red2
>>> [12744.788747] BTRFS error (device dm-1): balance: invalid convert
>>> data profile raid10
>>>
>>> Converting to RAID 1 did work but what can I do to make it RAID 10?
>>> With the up-to-date system it still says "invalid convert data profil=
e
>>> raid10".
>>>
>>


--aDAZVWvE3nAlLASVBLqHG4EtctVSjAd2Z--

--igIC8lzzb8V25RKBgt3DEHJySJlPtDb4y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv+nh0ACgkQwj2R86El
/qgXFAf/YzzjTlkwUBBUasL3kyiy1GLPEAmoL8XR3Lt8Z8pfaeHjLzON57ctUb1i
HcwHcpjDehmeqr4ImB2NlZouDW9ak+/UA93AzQgPSENLiQm/H9oe0oLJcXM4WgR5
Jea3G8RAax9ay3eKsnkP8YnOAg0Cv50c2loSDIAUsEmLoMqzx6CaDP6rcuZFDNpu
s0Oe2pk3d0n0mDcACr8AF39gnbuq+mEnaHqg2kRd5iKgl0Kk5uJ+rGfpLP5qNydB
mtc5t3tRmFtjxbjDH9s/FvWPOCOSqJixovtm+XIVSDNcg2NuX14fcu92Y087MiCS
zr+vO6Usm2bjamHTZgZJyQBsU0NPIQ==
=BhRR
-----END PGP SIGNATURE-----

--igIC8lzzb8V25RKBgt3DEHJySJlPtDb4y--
