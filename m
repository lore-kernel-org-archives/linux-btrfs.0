Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA754C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 07:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9341F20882
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 07:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="lPO439uY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfDCHFp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:05:45 -0400
Received: from mout.gmx.net ([212.227.17.21]:35561 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfDCHFp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 03:05:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554275141;
        bh=e2TxF63MXKz2/q2NroE57M7Yxj9fkBzchcOKSaErFnE=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=lPO439uYM2m/WsfrKyQI0BNFc3NO6SeDQJe9vcpHOUrDGwBbNUIKTUVhInedoUT2g
         c+k1qXnFlkkKkQL5lbgFe7TKACUKLlyB+5C30lfCMlzZCNyj/ZoOCK8A7CEbkoboyo
         i6wUMurUnQ5vbNv4W11xjhXOMQBihWSE5UiQ7ogk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LyS5K-1gp7Ra1jss-015t9L; Wed, 03
 Apr 2019 09:05:41 +0200
Subject: Re: life time of backup roots
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>
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
Message-ID: <186f3845-10b2-35c0-0ca3-3518b45acdd8@gmx.com>
Date:   Wed, 3 Apr 2019 15:05:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uTvjbf7oJWcHpLSAOtQj1PCSxfeqDXgoM"
X-Provags-ID: V03:K1:jT8MMZnXytBwx44HX7pCZg2IGrK6F/Hia11of2DtgAIGAWApbN4
 sgslkj+2ruHIlK2I+ZjmMSGqGHID6dWlp8HIT8fYSX5mK3Qq1XgdQIlptDjPXe3Sh+t/UsM
 rft0LO9UyUR6kN6wIm5jnVee+uXdAHrOQtmWGU0lkKW1G9Uiq1AbdGOpAOPTF2RlqTfconM
 GFNPRbrbVD99AjOIdj7zg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8k2cxHbOleU=:fHiEJFUwuc39xlEnIZE2o2
 orJCL+rDIDXWOgxGUaf3FQqQjnd+9SQfabU0Yxodgrymz2Dj2KTHHC68Kb5uJao0KiYVgXWRQ
 GqpTYu4f/Ht/ZLKR3Sb2X1sS5NfAgt5DS/HJMOD9LSQZQa4VRydxEsUKDGHt28C399pSaeF2O
 GyICxF73WGQfK43TYtdrvFYZf6CUIpGgV/N8eqU8WMvJ0tvB73MFd9/YJyFzf4nfHQ/HNaDaT
 JClb3wKtqLzyDoxknNvLh9+0ao4PBt8Jojo/PbNQv9BoEfzDV/+5U1rDBOu2o1k+L32mYj5ba
 i2G0NBgdw6m5WcnMvFCaXsm7hmT1SUK7m1GjLAXZOsy2nae1bNjY5yywBVlLM15hVtLImXzBv
 97x/ecAxCV+Y2RJxdoulP5p7uWwwuPxY4RTNxiYDlk35igRSiRc0XP2w/1YSiTvrSzREwYIrh
 5KRJAbfCdPWu4/HxFNaTj8WVhdkTgn1YFoG2InRvirFojfgIQq7KZJfUDTv97fY60N5qEUZ97
 s2Qgx9LCtc7nfEXwXT1jfrujne7r5cZHuru+bFYxbLgERgISO/v4BwhS1+5qhrSkXvtf0syBH
 Z2g00VbBQZtbO8ImJ7lKq0QWsvBAKzj3vj+vfzKmSRsC93J8ssP4VusQ6AleXEp9/hW7kTC0E
 tJvEERXhUDawzY8Wfay5SnIBwpbALA/gvRtVPvvioIP+kvVlqBCNLUqEkLPj2ZN7ycUn0AaXe
 1WoyVFvvJW98PFbt1rKBNrR/jlphfWamViIU6gU4Rs+pT7zvMN3nM1gwZ0EMYoAhPupkzGdOP
 ZSxpzJVkzDjWmKcU9/5kTcS4FxxGKBBb2x4O6c5J/LxcK+yxRFzJUWdV0ARQEu5hQdZzRbLCi
 hwoBvb2tMSa5OcTzavxHV/wBuIB2hX4+hlBb3MuacFhSAqt/NH5T7nX3Gxcxai
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uTvjbf7oJWcHpLSAOtQj1PCSxfeqDXgoM
Content-Type: multipart/mixed; boundary="KywlcfP8P2hrGC1PPjyXwqwV4U6vBp1mZ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <186f3845-10b2-35c0-0ca3-3518b45acdd8@gmx.com>
Subject: Re: life time of backup roots
References: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>
In-Reply-To: <CAJCQCtTwrBS-ZCm=MWStBdfm4iRgMiCt9vnC-WZHYNr9m1dO_Q@mail.gmail.com>

--KywlcfP8P2hrGC1PPjyXwqwV4U6vBp1mZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/3 =E4=B8=8A=E5=8D=8811:58, Chris Murphy wrote:
> I'm sometimes seeing the same backup_tree_root used more than once.
> Below you'll see backup 0 and backup 2 have the same address,
> different generation. The concern is if this suggests backup 2 is
> actually stale and not useful?

Currently, backup root of btrfs only has a life time of one generation.

That's to say, any backup older than current generation - 1 is already
stale.

Filipe had tried to make btrfs to pin down extents up to 4 generations.
Thus btrfs could make all 4 backup roots valid, but that leaded to a lot
of ENOSPC. So he gave up that idea.

Thanks,
Qu

>=20
> We've previously seen that Btrfs with discard mount option can very
> quickly cause the locations pointed to by backup roots to return no
> data (metadata deallocated and trimmed). I wonder if this is similar
> where Btrfs has no concept of delaying metadata deallocation for a
> while so that the backup trees remain valid for a while (few minutes?)
> Anyway if these backup roots can become stale, if they're ever needed
> they're not going to be useful.
>=20
> superblock: bytenr=3D65536, device=3D/dev/mapper/sdc
> ---------------------------------------------------------
> csum_type        0 (crc32c)
> csum_size        4
> csum            0xe0c01b78 [match]
> bytenr            65536
> flags            0x1
>             ( WRITTEN )
> magic            _BHRfS_M [match]
> fsid            ecd5e90e-6fb7-4b42-ab57-515a733c01f2
> metadata_uuid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2
> label            third
> generation        686
> root            3355115520
> sys_array_size        129
> chunk_root_generation    685
> root_level        1
> chunk_root        4325376000
> chunk_root_level    1
> log_root        0
> log_root_transid    0
> log_root_level        0
> total_bytes        1000207335424
> bytes_used        439356653568
> sectorsize        4096
> nodesize        32768
> leafsize (deprecated)    32768
> stripesize        4096
> root_dir        6
> num_devices        2
> compat_flags        0x0
> compat_ro_flags        0x3
>             ( FREE_SPACE_TREE |
>               FREE_SPACE_TREE_VALID )
> incompat_flags        0x171
>             ( MIXED_BACKREF |
>               COMPRESS_ZSTD |
>               BIG_METADATA |
>               EXTENDED_IREF |
>               SKINNY_METADATA )
> cache_generation    18446744073709551615
> uuid_tree_generation    686
> dev_item.uuid        de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
> dev_item.fsid        ecd5e90e-6fb7-4b42-ab57-515a733c01f2 [match]
> dev_item.type        0
> dev_item.total_bytes    500103667712
> dev_item.bytes_used    442415185920
> dev_item.io_align    4096
> dev_item.io_width    4096
> dev_item.sector_size    4096
> dev_item.devid        2
> dev_item.dev_group    0
> dev_item.seek_speed    0
> dev_item.bandwidth    0
> dev_item.generation    0
> sys_chunk_array[2048]:
>     item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 4325376000)
>         length 33554432 owner 2 stripe_len 65536 type SYSTEM|RAID1
>         io_align 65536 io_width 65536 sector_size 4096
>         num_stripes 2 sub_stripes 1
>             stripe 0 devid 2 offset 1083179008
>             dev_uuid de7a23cd-ec25-47d4-bbdb-fcf9c4dc705a
>             stripe 1 devid 1 offset 1104150528
>             dev_uuid 15e28877-dbc7-446d-9991-618504a758ca
> backup_roots[4]:
>     backup 0:
>         backup_tree_root:    3355115520    gen: 686    level: 1
>         backup_chunk_root:    4325376000    gen: 685    level: 1
>         backup_extent_root:    3358523392    gen: 686    level: 2
>         backup_fs_root:        3550511104    gen: 497    level: 0
>         backup_dev_root:    3358752768    gen: 685    level: 1
>         backup_csum_root:    3259400192    gen: 500    level: 2
>         backup_total_bytes:    1000207335424
>         backup_bytes_used:    439356653568
>         backup_num_devices:    2
>=20
>     backup 1:
>         backup_tree_root:    3358752768    gen: 683    level: 1
>         backup_chunk_root:    4325441536    gen: 677    level: 1
>         backup_extent_root:    3359506432    gen: 683    level: 2
>         backup_fs_root:        3550511104    gen: 497    level: 0
>         backup_dev_root:    3358982144    gen: 677    level: 1
>         backup_csum_root:    3259400192    gen: 500    level: 2
>         backup_total_bytes:    1000207335424
>         backup_bytes_used:    439356653568
>         backup_num_devices:    2
>=20
>     backup 2:
>         backup_tree_root:    3355115520    gen: 684    level: 1
>         backup_chunk_root:    4325441536    gen: 677    level: 1
>         backup_extent_root:    3358523392    gen: 684    level: 2
>         backup_fs_root:        3550511104    gen: 497    level: 0
>         backup_dev_root:    3358982144    gen: 677    level: 1
>         backup_csum_root:    3259400192    gen: 500    level: 2
>         backup_total_bytes:    1000207335424
>         backup_bytes_used:    439356653568
>         backup_num_devices:    2
>=20
>     backup 3:
>         backup_tree_root:    3359834112    gen: 685    level: 1
>         backup_chunk_root:    4325376000    gen: 685    level: 1
>         backup_extent_root:    3361898496    gen: 685    level: 2
>         backup_fs_root:        3550511104    gen: 497    level: 0
>         backup_dev_root:    3358752768    gen: 685    level: 1
>         backup_csum_root:    3259400192    gen: 500    level: 2
>         backup_total_bytes:    1000207335424
>         backup_bytes_used:    439356653568
>         backup_num_devices:    2
>=20
>=20
>=20
>=20


--KywlcfP8P2hrGC1PPjyXwqwV4U6vBp1mZ--

--uTvjbf7oJWcHpLSAOtQj1PCSxfeqDXgoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykW0EACgkQwj2R86El
/qi04Af/c6vHbERoB4E9SaFSgDJmZLXdbZ2rego16Zi21Z4+KGESSm3naxMayShY
1cmMsGCr8I3xktAEc2XQuLUa8ZH0BeaXh5p/Hb+yLVKsH0wjWs+kAAoHIE5Y6WpQ
i9212sQCPw3Q4iuPatt7BJrZAgweSTEBjqdGlduTWaZh/oo+ubnEDbThdjOEHLoW
GZfctQ1mFhiPwQVk5JLXOrEIUnGrmL7jNCQDpuuKfQl56OeXPuc8B5EFjq7Dpjy5
LgZXxoydAgVeQ7X3CfmCRH0e5IUfQRDcxUcKlnVMyFYQxcvn24hUjFfhUPSzrZuw
NkueOdTLOO9GSzYFLuNdvAVtaiViDQ==
=Ggo1
-----END PGP SIGNATURE-----

--uTvjbf7oJWcHpLSAOtQj1PCSxfeqDXgoM--
