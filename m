Return-Path: <SRS0=vb8r=PN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBF1C43387
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 01:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8299621871
	for <linux-btrfs@archiver.kernel.org>; Sat,  5 Jan 2019 01:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfAEBSs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 20:18:48 -0500
Received: from mout.gmx.net ([212.227.17.20]:44433 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfAEBSs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 20:18:48 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MI5rO-1gjRhC0IBS-003sbw; Sat, 05
 Jan 2019 02:18:45 +0100
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
To:     Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
 <720cad6c-776b-109d-f204-fd94942bfa7c@mokrynskyi.com>
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
Message-ID: <6c249b1c-446e-a43b-ea9b-606bfff7cc88@gmx.com>
Date:   Sat, 5 Jan 2019 09:18:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <720cad6c-776b-109d-f204-fd94942bfa7c@mokrynskyi.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rDJGlnGryP5bZnedbx09oONfCixH8rwMc"
X-Provags-ID: V03:K1:FjpE3kU31ZUWQQUCL5FSVqABeHVJ3+bgRhCoGJMzWOKxkxz3m9D
 EIV+FA96PVOvYp6RVG/LLS3rSMAC17Oz82mnhAZ36dGAnrdlpfNN3lmkwr833GbQv2K2Dr0
 KpLMETbXU3ko1QVUqJTPXpVwLm5gaMyrvsMwTHVV0vBMII0xiz1QzRzZ5QtOFTnSfmX/pZd
 a3qrdzB3c6khUL1wqPm8w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OrjpW4tWrfY=:eTxyrgf0hMQ3z/A3Bzo35g
 qAcLCJhax8wXVVe6Cd4QHA2wClkdOiStFrTwp7jrAKOYuz6rFSI+nrQwlY/hgo/mUOSXV6pKV
 +b6iP7VHmyX5txy369NASeEJDnP1COsnoSkPqN2Jf/vIRDUafYC08EEauYBhuLZd7RmK/OLE1
 8IIOHt1sH+sgEThcM2XJFAlMlXTSdJO+//ufDD/J8AWcBXdlUJJ6Prc61XnCPB91LQqA/GbEq
 +dI5Ub5aalNg7dRWWD2XnIHIPNeCAgYkx3bkP4ZO62+FPDxzYduY8FVlsMuvYFsz4bEQT3QmL
 dJ157jfqroADHTLnGU1ofaAqus6CF6BVxk5F/OkhQ8H3NJVv3/LICRlrPSWMeDPqPPtT1AuSl
 b5ymoStmZtbCSFIMcB+1VC6mcMwPc2UcZPxcZ7k8479DJLeZBaIXs8p9bnPfiKBCBOunlmfhi
 zBbptfscLVxqVpcuKssLDbJOVvvkGsBwvQCE+5P+j8otsnrD9FB0oSEKJe4xB04QNHQPFx7B0
 rqD7xvSgm069pjuMPUA3ARwtF/5TsXbFnF6qKXDRBBni5kWVPlHDDlysILPzK13mjwJnNYoML
 7fgFTw8Nr/YpiU4/1iXehWvpVWCruiNYe5pXyicFtEvOU1gbS/0IARh0C6njWeUSqa2rVnIMf
 4BbYmyOdM8VJsTvTtOiq/Z2iHx8U04D89U+UhsnXGmxc+mWHMXC4LynmzDkCpf/b57QBLdWRb
 8L4cUdkWFr3G4Xm06TjXLO9zddqu9nccjkjThf4XgO6k1XJqjs28awGrC+LOoI2Dzrg3xqJRm
 MsyAARaN2YSikiPqO7lu7YSuTdIb5qzz6jUKhdJsN9T6IWlyv5AsGUKH++LiDDsZJ43pMYBX8
 WmSxOl5CH7PbbPffGkg5uwQhlzHxX5elbguMp+rorceLzlCiYRtDKFAvX5enq6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rDJGlnGryP5bZnedbx09oONfCixH8rwMc
Content-Type: multipart/mixed; boundary="w7SmOBe3mXYqNfdB29yM6zMWcsp6kAOKU";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <6c249b1c-446e-a43b-ea9b-606bfff7cc88@gmx.com>
Subject: Re: Unrecoverable btrfs corruption (backref bytes do not match extent
 backref)
References: <73e828f0-057c-830e-a6b2-570dccbdf484@mokrynskyi.com>
 <CAJCQCtTJEc8q8hrBG_HRvm1vWQvs5KgcFUKfvXPjxTNZSjd-Sg@mail.gmail.com>
 <aca3ce08-2cc6-9ace-ec3f-a9d963b4dab8@gmx.com>
 <720cad6c-776b-109d-f204-fd94942bfa7c@mokrynskyi.com>
In-Reply-To: <720cad6c-776b-109d-f204-fd94942bfa7c@mokrynskyi.com>

--w7SmOBe3mXYqNfdB29yM6zMWcsp6kAOKU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/5 =E4=B8=8A=E5=8D=887:04, Nazar Mokrynskyi wrote:
> 04.01.19 03:32, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5:
>> Please provide the dump of the following command:
>>
>> # btrfs ins dump-tree -t extent | grep 3114475520 -C 20
> root@nazarpc-Standard-PC-Q35-ICH9-2009:~# btrfs ins dump-tree -t extent=
 /dev/vdc | grep 3114475520 -C 20
[snip]
> =C2=A0=C2=A0=C2=A0 item 152 key (3114475520 EXTENT_ITEM 4096) itemoff 1=
0193 itemsize 24
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 refs 2 gen 1701147 flags DATA
> =C2=A0=C2=A0=C2=A0 item 153 key (3114475520 EXTENT_ITEM 36864) itemoff =
10169 itemsize 24
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 refs 1 gen 1712966 flags DATA

Two extent backref for one bytenr, this is definitely a problem.

> =C2=A0=C2=A0=C2=A0 item 154 key (3114475520 SHARED_DATA_REF 31140895129=
6) itemoff 10165 itemsize 4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 shared data backref count 1
> =C2=A0=C2=A0=C2=A0 item 155 key (3114475520 SHARED_DATA_REF 34256194764=
8) itemoff 10161 itemsize 4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 shared data backref count 1
> =C2=A0=C2=A0=C2=A0 item 156 key (3114475520 SHARED_DATA_REF 34854787481=
6) itemoff 10157 itemsize 4
> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 shared data backref count 1

And total of 3 refs, 1 or 2 of them are the cause.

I'd say either it's caused by kernel bug or corrupted space cache/block
group item.

Please don't mount the fs RW, and copy your data out.

In fact I don't have any idea how this happened, no clue to fix either.

Thanks,
Qu

>=20
> Actually, I removed Docker's snapshots after making image, but most oth=
ers are not there anymore.
>=20
<snip>
> I'm using qcow2 with snapshots, so I can do multiple experiments with i=
mage at the same time if necessary. Also started `btrfs check --mode=3Dlo=
wmem`, will report once it finishes.



>=20
>=20


--w7SmOBe3mXYqNfdB29yM6zMWcsp6kAOKU--

--rDJGlnGryP5bZnedbx09oONfCixH8rwMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwwBe8ACgkQwj2R86El
/qhKzggAk+gK7g/cYhlBUHmDIARav8+hjb9mFVNnSWPIIM9KIDcjzq88s2z929Z3
rG5hDkt1wjX91lE/FyWwhJ/7SbWkl1a9jy2vLejVlkFAPwX30LY+gW86WFB5Kzex
T1jFXKUg7ifoyhhMgqSBRoCmqiIoqz7H0HOHDEubVSmleUta2RIC6Q22u7IA9CuM
fsFhvcMqCREJ022nhSJ3YA7W4f4ZuUj2wr/Q9MA/OM034DAAiUFfIzxeOHKYspM1
XBiBcYKKasHQPIPi3bvkihqClTTcXQNQdR9/jvKtHpTO2pakE9tYwvRLBltva5BZ
0KT3FX8O3tHjsonoKxUe3H27Tnm2Bw==
=utAC
-----END PGP SIGNATURE-----

--rDJGlnGryP5bZnedbx09oONfCixH8rwMc--
