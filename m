Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAD3C282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDD32175B
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="fK4+sCZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfDFADI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 20:03:08 -0400
Received: from mout.gmx.net ([212.227.15.18]:41703 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbfDFADI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 20:03:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554508984;
        bh=a4wvFc4yjd9vBIv8MI3XKoKw1SIzrv2eqzLj7P1c8Wg=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=fK4+sCZo7xJ2PgtZi8tkBFuMIocBjwiC3ry929QcYAvqYqrC9FodqUUomgNv0fTy1
         VU25dOQnNkTmuPrLyzBF31B/dJlcVAh6dUf5zkGsCpyTymKI6WLGP2grOxEXgNILkB
         y/0bg1WzCxAcH9g/Wznytw6CWecaEghBpmWPSfOo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MIuSH-1hETfy1C3d-002XiR; Sat, 06
 Apr 2019 02:03:04 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
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
Message-ID: <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
Date:   Sat, 6 Apr 2019 08:03:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TbAUtqZeLrJxe0NiwpHYV10SRZktWSACQ"
X-Provags-ID: V03:K1:BHUxLX7ktcSToGkR2A+QB/IC6YZuoz1jC5zVtzAsyXptrb02H8E
 CAXeSPcKpnH1pJCzlKsjDksscZ/eEQ6QdYOozGg3/59hH9Y8tsP9u7aHlUt6svRf6ZDn2JX
 GDFkTQwmmhNLqLAJePyefzADY/C2XBXtOz22ij/NcBlbwvJwfDZLyj5nNSLkRinLSxpDpSq
 OtmgPuMMIzuxRG7tkfGzg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BOuUsVUOfiE=:yEDXE/xRs+QEmJMtmzpRqo
 nACFM+Ffnkh5M1EJ4nWEy++YmsFai6r0RgOh0ZfQG8jYYmR4QTRODLyqBwZ0DvTR50OaIe8xn
 3SZO6fSegYdQ6wHxnjOEI67WgKM58pqnFa4HPxj6Hh3M3OJQxN96qCL2R3IjuDqA5psKnXqw8
 SBPyLAFGAC59aROFuhTPfY86bn5sdOG0Mrq/47UQkoMGOfuGz5veHWTyVhllqkWQlKhEs1adt
 auDhXSW2S7FNwlM+1Zwh4NmTjYE3HP6poMi1Lwu3YaODCeJTDr6stG27IB/hWC6Ib2u5t2jyF
 8nbCkIlKVJh5o4KmTjH2jIdDpePwg1LPPzFijjr3hDVWde9LXu73cC20ATN8xmwvspoXE4PUD
 Bg2viQAE3lsO/YqMt/BmXNhi132qeem+njnAj1b/kzPESj+gJLMEujTla3ACRQ+x9HTgo8L8f
 Cg6yuAs+X9BBz2Yp6OKk2IrwUOZmjU2DZxMeuX4hxYYXlSKxsX7lxUYZPvtaw6u9DdOyWAuzK
 V0Brm+Br0VZyeRxfNAkxv9Sucu5x1NtwNYrSeGlXkq9klzetGp6v8UrpyJDxoVWhGuubJZSGt
 FjgXoH4EUjZMQzsnG0I2XT2ONuHQ7AGE8yEQW0Og6tB72Dn+MuEFT2XyuB8IZYCGgvZemAFeV
 ec/SHs/14q5KsgZ0Xntt8MwJlS7cwGZ89ec/jSo6/xxDVBw/8tlUefvRc02TBKs+D3JM4uKjO
 SHalwjnW//1Qjhw/pYmYEB8MFpTVWIncHvRXI5ipOd3O2sAzScvTgTFWjP6+S6UBo/kEvmp2C
 BiTpIMWEKDE8CmB+2oB2oID0NU0Lp05D+BGtCKLoSRM2mpqobPzGoIzBhZl/+r2VLKQ3AJkM+
 bGt0ZHwXUC3z1+I5P/FVYtsp7hciRg6vFj/kvq3smibV7Adw/v1aOns6qTEZy4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TbAUtqZeLrJxe0NiwpHYV10SRZktWSACQ
Content-Type: multipart/mixed; boundary="aIonC9VuiPPSgEfcE8ymTY0BiZwbSrIQh";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
In-Reply-To: <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>

--aIonC9VuiPPSgEfcE8ymTY0BiZwbSrIQh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/6 =E4=B8=8A=E5=8D=883:38, Nik. wrote:
>=20
>=20
> 2019-04-05 10:15, Qu Wenruo:
>>
>>
>> On 2019/4/5 =E4=B8=8B=E5=8D=883:41, Nik. wrote:
>>>
>>> Below is the stderr of both commands:
>>>
>>> # btrfs inspect dump-tree -t chunk /dev/md0>DT-chunk.log
>>> # btrfs inspect dump-tree -t extent /dev/md0>DT-extent.log
>>> ERROR: leaf 1894009225216 slot 30 pointer invalid, offset 146038 size=
 37
>>> leaf data limit 16283
>>> ERROR: skip remaining slots
>>>
>>> Since the output on stdout is pretty long even after gzip, I am
>>> providing only the output of the first command as attachment. The out=
put
>>> of the second command (25 MB after gzip -9) can be downloaded here:
>>>
>>> https://cloud.avgustinov.eu/index.php/s/AgbwWyCrbYjenq8
>>
>> Sorry, I should have use a more specific command to get a smaller outp=
ut.
>> But anyway, your output is good enough for me to craft the fix patch.
>>
>> Here is the dirty fix branch:
>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_nik
>>
>> Compile the btrfs-progs as usual.
>> Just a late hint, you can disable document/btrfs-convert to reduce the=

>> dependency:
>> $ ./configure --disable-documentation --disable-convert
>>
>> Then, inside btrfs-progs directory, call:
>> # ./btrfs-corrupt-block -X /dev/md0
> incorrect offsets 15003 146075
> Open ctree failed

Oh, I forgot it's in extent tree, which may need to be read out at mount
time.

Just a new flag can handle it.

The branch is updated, please check.

Thanks,
Qu

>=20
> Actually there was one warning during make, I don't know of it is relev=
ant:
> =C2=A0=C2=A0=C2=A0 [CC]=C2=A0=C2=A0=C2=A0=C2=A0 check/main.o
> check/main.c: In function =E2=80=98try_repair_inode=E2=80=99:
> check/main.c:2688:5: warning: =E2=80=98ret=E2=80=99 may be used uniniti=
alized in this
> function [-Wmaybe-uninitialized]
> =C2=A0 if (!ret) {
> =C2=A0=C2=A0=C2=A0=C2=A0 ^
> check/main.c:2666:6: note: =E2=80=98ret=E2=80=99 was declared here
> =C2=A0 int ret;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~~
>=20
> The previous steps were as follow (output ommited, since nothing
> unexpected happened):
> #git clone --single-branch -v -b dirty_fix_for_nik
> https://github.com/adam900710/btrfs-progs.git
> #cd btrfs-progs/
> #./autogen.sh
> #./configure --disable-documentation --disable-convert
> #make
>=20
> Did I got the right branch? Or miss any step?
>=20
> Kind regards,
> Nik.
> --=20
>=20
>> If everything goes correctly, it should output something like:
>> =C2=A0=C2=A0 Successfully repaired tree block at 1894009225216
>> (And please ignore any grammar error in my code)
>>
>> After that, please run a "btrfs check --readonly" to ensure no other b=
it
>> flip in your fs.
>>
>> Thanks,
>> Qu
>>
>>
>>
>>>
>>> Hope this is ok.
>>>
>>> Regards,
>>> Nik.
>>> -
>>


--aIonC9VuiPPSgEfcE8ymTY0BiZwbSrIQh--

--TbAUtqZeLrJxe0NiwpHYV10SRZktWSACQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyn7LQACgkQwj2R86El
/qhfcAf/esMz4SXayM6sNGPAD7w52VniVg/d2EAp8UKH797SjqBz9oDjKB0/YuUY
zRJv81dBRouUN8tl7wJl8hgumn4nTiWT9EDuU9Ej9qgvwSV1kBdQCkDQGPne8AgK
pyVO4iaM+mRyaVNvkU6bs2JqILI0Z0o2Ubq7lIUwaX/1O9ID0vW+kZdkkzqE9Go8
nauxYOW5k3undaDWQa5egxA12WapxLuT9tzURIwut+FtiewPwUurvSF9KqYF1suO
ymqAcFMLbbsS0OIYGWIcXgeUgRP9elVL0GC6zJkW2DIBeOQz9/YNraIpoLJ+kJhB
jQBg65hBn9ohUagTS29YMU34CGDVlg==
=LN8J
-----END PGP SIGNATURE-----

--TbAUtqZeLrJxe0NiwpHYV10SRZktWSACQ--
