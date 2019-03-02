Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95935C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 01:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67EB22083E
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 01:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfCBBGB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 20:06:01 -0500
Received: from mout.gmx.net ([212.227.15.18]:48419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfCBBGB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Mar 2019 20:06:01 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LiTm8-1hXqsE1XTA-00cgKo; Sat, 02
 Mar 2019 02:05:59 +0100
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
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
Message-ID: <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
Date:   Sat, 2 Mar 2019 09:05:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HUz4QXihNTmascuQAGbpdbxWGp3Y5ilbm"
X-Provags-ID: V03:K1:tXwYcnVZCWNAtIvzPhF1w37J4DVcFDci1uAV5T6NoLGB1K/lwZt
 34NJLzHfo0iofjABgsym20hglH7aJq3h5mi6wSLmcbV2u+lcQAp22CxnkIrozdB3HmGpLAS
 CkCKw+sO0CW/fOLqSImK7vTZcUlMvOKnV2abFXwoUH2UIJx1SpuDULZ0LNF65pYp4+j0AW2
 YzRhedGnMXzRHo7LHvOkA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CItORgYMzCo=:PGePlldcQAWVoMBjxA23TU
 WSV7n1ePLxYCqe9VK7b/JCBPBN1LS6oqsCDxTP72QkKuQHbXJMGIyeyIluCmwhpuFHTcdRrFn
 CqYQ3ihR0OhL+Xv6qFc0fhfP8ogr7j8ZgH7m/jLsu7K1FYum14Do9sL55wAxw2f1blCAc7GYT
 Hn4MNY3GKqnSJpatULPVQCjo4aCu8QBEuH9jJCFaoXVG9AeVWwatOSCnDobmoqi0MdP5GOGI9
 KU8EIg9tF/XoJd+XzJlpiBRpOJ0ceKkvfFISTfooiGGtnmXG7mH91LWoCwRXLNho5/ngaMSLx
 04jb9QSgzFGh9rG4fYbtwYsgJVd7aAX+lCImC36Nk9QqH1FYIE7gaGcT15bzrSgWcbjuStRjG
 KFjgFZercCs/187bT300DchOiqPWa7i8heXPuZgw2hLx0+oUhqR+G6btkE2zApBggjwuxVuUK
 wDq5Qod4nC5H6QqlBZgIXfAUN9pswf8Ai45RI/BVKNzfumFiOsE7jcm8fsAasSm6xNFDyw4O4
 oGu1vx9jQVIhZHHDAE5AENBuhlmb+0XlYP1DVe9SaGT8/HbcomoYdx/EnBrSNMDcE6zintokK
 IGvar2jEHrdCRSKaRoqU/U8NMNDVGlkMdMaMyD/h66zVvlIGVQ1eDxUA4bIXfecoad0jC8RvP
 FekUJhftRGnj3Q4O6qEv4hs9bM3yKp+rRP9wLnZNWjmSUYxVxaEZRlUmxfb5fS5789zZGEOV6
 TIqKUX6gMug+NJhrivfm4YMFH/e9QN/xTI+/oqL9mjxeDBNIEsMZxNDjc6X1qRh0AGpCLRCOt
 BufO/TA9hUrNpbhsLVi28J4kHeaSgQqd2lax5IFX1CRuSePRUYgKV1jdIHUeY/lOU0D9RjVE/
 30M+FgVhj3giirKOM794BE0nr0zczb4dckoXUfBgoyRNGGyh8WePEQ+BsW3rCO
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HUz4QXihNTmascuQAGbpdbxWGp3Y5ilbm
Content-Type: multipart/mixed; boundary="7q9h6V50b7ydsmbXIVqjprKXgfoh3hI1Y";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
In-Reply-To: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>

--7q9h6V50b7ydsmbXIVqjprKXgfoh3hI1Y
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/2 =E4=B8=8A=E5=8D=888:20, Chris Murphy wrote:
> Problem happens with btrfsprogs 4.19.1
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D202717
>=20
> That bug report includes the trace in user space; but I've also
> processed the resulting coredump file with gdb and attached that to
> the bug report.
>=20
> Before using --clear-space-cache v1, btrfs scrub and btrfs check came
> up clean no errors. Following the crash, I compiled brfsprogs 4.20.2
> and ran 'btrfs check' which finds corruption.
>=20
> I've taken no further action, and the btrfs check output gives me no
> useful plain language information what the next steps are. So I'm just
> gonna leave it alone since it's a backup volume anyway.

Is the backup volume binary dump of the original fs?

I'm interesting why clear space cache v1 doesn't work, to find out that,
we need tree dump of the original fs.

And is the original check done by latest btrfs-progs or v4.19.1?

Thanks,
Qu


--7q9h6V50b7ydsmbXIVqjprKXgfoh3hI1Y--

--HUz4QXihNTmascuQAGbpdbxWGp3Y5ilbm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlx51vIACgkQwj2R86El
/qihjQf+LLj6P91VUUyQ9d20VOT8EAVr/HhE0or6YZBM+1L7jlSASIX5Oeo9qfKZ
0X+0LRXTdfun1lxSuXAPc5SSF02J+zfxyO9vZXS31Yv+TLQvueYCvWrWUDZ/KG3X
11ojmQq1nNACkMt4Nczja+/+50oqdRS+NgGfDGCp90CTTEGXfRguQoPfzqSPi5qI
RAVSMK6CcllS16xsie6x3wrLX+tw9aGlP3meB0a475Y+0iUl7qgCwkRwPBK+YjVp
2ZGpHJp5shZjbUZbFU7HIwbITs50iWeh6sh18WxZfq90wtq2lIa1c4YOdxH20xHj
SMN6QjW6wViZZKIsKDFjoCy/Fc5tWg==
=4npl
-----END PGP SIGNATURE-----

--HUz4QXihNTmascuQAGbpdbxWGp3Y5ilbm--
