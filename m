Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B337EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75AAA20851
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 01:14:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75AAA20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbeK1MO1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 07:14:27 -0500
Received: from mout.gmx.net ([212.227.17.21]:42081 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbeK1MO1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 07:14:27 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LhkiL-1fez4m2iP3-00msnZ; Wed, 28
 Nov 2018 02:14:38 +0100
Subject: Re: Balance: invalid convert data profile raid10
To:     Mikko Merikivi <mikkommm@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
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
Message-ID: <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
Date:   Wed, 28 Nov 2018 09:14:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bi3l2dHhJbMvhmn9PK1Yh4ssaVPFoCKXS"
X-Provags-ID: V03:K1:l//KMP1p9cDD0ckyO3J4LIzR/FeWOJK3ot4Wwku0NIAcnPjKp/u
 qslB/zibQRr9CAba3DbYs+9BNJRU8aTjfbpnFSeOWnkhSMPxvborEUCnHwsZGK5I+WMgdbr
 F38uN+Figh0CTA4fPxLoeu4aFV3y64c4oYmgn6qIDzVwAVi+fUHfIQucVqMgqEZZjw5xnna
 brR5qnSSLYt50xdieSbvA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PdFsI21GUsM=:owOFtDk2heY04B2Sdk6VJh
 UK56BUPGy4uWAAK4yiMZW8l9uQmD9uSfbnz3+qEbubNZmAwKEusCM5xHvFtttTsWkuTzQMtLJ
 CdgQ7sQwciVKxB8C7QR7pCjG2ZGzYnMHSP6X8n1/k4Yf7FbRUKF87Vig9nFiPwtGWgiU/i8r8
 Ht/t9L1X074InWtxDZ5Zc+diJSAPTQalJSHmRIGIa4unBTuKrZLzx33/NFi1wkF4Z2PKIgJeE
 hX29guDL+MjQiItqH/SztH4faIJydQdOiXxpbKHVQd43ZBSV0reMYQ6jZLo43jX99n0vzbbym
 T2Kq9JdAbAWqegzxh3fpKThDT5yRgK7PxVxeHT7EdkrpHZFwy3Kexx7lgjp4F09K5mNoUQadC
 j3MQ5LAZjWRIqL0xGthZNVhyEawkrpNgRBDKgRpYSuuP+wu5zkNFXEF02727w2AkChUxjgOx4
 4mSUafKRXPArBXSnM3jkofGyqih9sAGkAqJnTxpwDnjU//S8RafA6XAvJDEBLj5tAIrJvAhgR
 RcUY/tuzrmtzK/gTyQNqrEaDyK1MBkf1J9NdOZNLel8fNMPBCF/W3A86GGKYyskU04ZO79GPc
 N4DcaLkOYNLZ1d744vwoWvMf+MeIUN9naZMhJhWe1tFF7xSgHuH2W/r62+S9e2umq3hVCUaK8
 8Jf/Oq24SfHet+1oL9erl+/MtPc1tsLvOk48QzfRIUn74EL3OIHnnzuFTETxl0F6HzKemRasT
 nzpuhEeH8jAZ0Pl5vYTXYvX4pWRvV022G8pJYgyBW//mgHaga/gI+cm6oCoWzA+tSjmtgCCed
 s6RWxxJq5PiG4qu7JajvPiFxMIZMLqqXsMGIeuSWKFxna8+pndLxNkHGI8pNPPdgirlNAdAzQ
 7fFYQD8jbc71vdTFxqA+GmCb2e2GKPPHcS/NUi+/4=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bi3l2dHhJbMvhmn9PK1Yh4ssaVPFoCKXS
Content-Type: multipart/mixed; boundary="Yd639KUqefSeTSpJ3KS7gK9mcDhg51ryn";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mikko Merikivi <mikkommm@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <086b9093-dfd8-c7e6-10db-0ddd0ab8ffee@gmx.com>
Subject: Re: Balance: invalid convert data profile raid10
References: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>
In-Reply-To: <CAFmqBADbLrmjE1A9ZCNYFo0jotLCnGHEiDZ5mHo1VNP1M-r2Ww@mail.gmail.com>

--Yd639KUqefSeTSpJ3KS7gK9mcDhg51ryn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/11/28 =E4=B8=8A=E5=8D=885:16, Mikko Merikivi wrote:
> I seem unable to convert an existing btrfs device array to RAID 10.
> Since it's pretty much RAID 0 and 1 combined, and 5 and 6 are
> unstable, it's what I would like to use.
>=20
> After I did tried this with 4.19.2-arch1-1-ARCH and btrfs-progs v4.19,
> I updated my system and tried btrfs balance again with this system
> information:
> [mikko@localhost lvdata]$ uname -a
> Linux localhost 4.19.4-arch1-1-ARCH #1 SMP PREEMPT Fri Nov 23 09:06:58
> UTC 2018 x86_64 GNU/Linux
> [mikko@localhost lvdata]$ btrfs --version
> btrfs-progs v4.19
> [mikko@localhost lvdata]$ sudo btrfs fi show
> Label: 'main1'  uuid: c7cbb9c3-8c55-45f1-b03c-48992efe2f11
>         Total devices 1 FS bytes used 2.90TiB
>         devid    1 size 3.64TiB used 2.91TiB path /dev/mapper/main
>=20
> Label: 'red'  uuid: f3c781a8-0f3e-4019-acbf-0b783cf566d0
>         Total devices 2 FS bytes used 640.00KiB
>         devid    1 size 931.51GiB used 2.03GiB path /dev/mapper/red1
>         devid    2 size 931.51GiB used 2.03GiB path /dev/mapper/red2

RAID10 needs at least 4 devices.

Thanks,
Qu

> [mikko@localhost lvdata]$ btrfs fi df /mnt/red/
> Data, RAID1: total=3D1.00GiB, used=3D512.00KiB
> System, RAID1: total=3D32.00MiB, used=3D16.00KiB
> Metadata, RAID1: total=3D1.00GiB, used=3D112.00KiB
> GlobalReserve, single: total=3D16.00MiB, used=3D0.00B
>=20
> ---
>=20
> Here are the steps I originally used:
>=20
> [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
> --use-random /dev/sdc
> [mikko@localhost lvdata]$ sudo cryptsetup luksFormat -s 512
> --use-random /dev/sdd
> [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdc red1
> [mikko@localhost lvdata]$ sudo cryptsetup luksOpen /dev/sdd red2
> [mikko@localhost lvdata]$ sudo mkfs.btrfs -L red /dev/mapper/red1
> btrfs-progs v4.19
> See http://btrfs.wiki.kernel.org for more information.
>=20
> Label:              red
> UUID:               f3c781a8-0f3e-4019-acbf-0b783cf566d0
> Node size:          16384
> Sector size:        4096
> Filesystem size:    931.51GiB
> Block group profiles:
>   Data:             single            8.00MiB
>   Metadata:         DUP               1.00GiB
>   System:           DUP               8.00MiB
> SSD detected:       no
> Incompat features:  extref, skinny-metadata
> Number of devices:  1
> Devices:
>    ID        SIZE  PATH
>     1   931.51GiB  /dev/mapper/red1
>=20
> [mikko@localhost lvdata]$ sudo mount -t btrfs -o
> defaults,noatime,nodiratime,autodefrag,compress=3Dlzo /dev/mapper/red1
> /mnt/red
> [mikko@localhost lvdata]$ sudo btrfs device add /dev/mapper/red2 /mnt/r=
ed
> [mikko@localhost lvdata]$ sudo btrfs balance start -dconvert=3Draid10
> -mconvert=3Draid10 /mnt/red
> ERROR: error during balancing '/mnt/red': Invalid argument
> There may be more info in syslog - try dmesg | tail
> code 1
>=20
> [mikko@localhost lvdata]$ dmesg | tail
> [12026.263243] BTRFS info (device dm-1): disk space caching is enabled
> [12026.263244] BTRFS info (device dm-1): has skinny extents
> [12026.263245] BTRFS info (device dm-1): flagging fs with big metadata =
feature
> [12026.275153] BTRFS info (device dm-1): checking UUID tree
> [12195.431766] BTRFS info (device dm-1): enabling auto defrag
> [12195.431769] BTRFS info (device dm-1): use lzo compression, level 0
> [12195.431770] BTRFS info (device dm-1): disk space caching is enabled
> [12195.431771] BTRFS info (device dm-1): has skinny extents
> [12205.815941] BTRFS info (device dm-1): disk added /dev/mapper/red2
> [12744.788747] BTRFS error (device dm-1): balance: invalid convert
> data profile raid10
>=20
> Converting to RAID 1 did work but what can I do to make it RAID 10?
> With the up-to-date system it still says "invalid convert data profile
> raid10".
>=20


--Yd639KUqefSeTSpJ3KS7gK9mcDhg51ryn--

--Bi3l2dHhJbMvhmn9PK1Yh4ssaVPFoCKXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlv96/oACgkQwj2R86El
/qjoTwf/ez00DMYGlkjXQUTb6femt82cRduWMMZLQ9ughj2gaj+lnlITosICIfWD
fzDlijkMAd3t1v5qII9b0fTRQKOHz1E8yqjaVEwRMEWn6+kgnxPVWVoZIblardsp
wKbTIqVm1VHIapE/MQRFNWJht2VJNMKonYdoHSBeUFSFhIoKW2IZGB3YzForXz8D
rDjBGtYVEXxjNLvchMM1bSFxjOGmEywJoe2Cow34q6+fqECrEU/6oCMgSsXrSJ14
5ZU2azProYWXgkBUOimGuNjvWEcO66+ee96p/ljeDKP74kussnX8LNuaws+TW38e
Pr/ms9n1YHEKO14Zms/8M8hf5ptHfw==
=BC3Z
-----END PGP SIGNATURE-----

--Bi3l2dHhJbMvhmn9PK1Yh4ssaVPFoCKXS--
