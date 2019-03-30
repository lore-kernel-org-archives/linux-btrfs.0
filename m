Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86E3C10F00
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D08E218A6
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dAT58BW3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbfC3NJb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:09:31 -0400
Received: from mout.gmx.net ([212.227.15.19]:37663 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfC3NJb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553951368;
        bh=PJ6M9PECy3xrfF9UZYn6vO0LmA+rKlbAxvkMzBj8CgE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dAT58BW3Ky/+5C5luHaZ2Lxuw0dOZhmavLM53w8keqaNLSYU5dq7yjDae6/LR8OCV
         PaXXJiYxUPTDjPc+NzUt5abBhr+piJSMaWVNxrnbvtxaGga2RDnzrP2/mpaSSFM830
         2UUTrGDF6avYTdxDaYC8tSvPaSI/kYKUmjztp00c=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrNl6-1gy9RR1ZtM-0134uz; Sat, 30
 Mar 2019 14:09:27 +0100
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
To:     Supercilious Dude <supercilious.dude@gmail.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
 <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
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
Message-ID: <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
Date:   Sat, 30 Mar 2019 21:09:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nk8Hs40cmV9MR9zSgQnsOLP6JdZyKTUN7"
X-Provags-ID: V03:K1:x417mq9hkfntfP2lZNWqEbuZCLOSkuKdsCez0HuzGrUTGSc7sOj
 aSYp1sKDkhZjoD9JwW+DN8Hxxsh4BUlyogTcAKhY0iXgsDOjSaWBakTRH08kw5Ykvbw9IXL
 L81/qNtja4ou+VKfBTxnVmuYNrdXJcNS2ooKSbtSrvYDglyYM6puouJmTJ6kt0vBtfP27x9
 1eHN+MI1JLV9dYO7dAKag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:82aifa7zCl4=:g81eEFmatpV80rXq+4CcEr
 7zTzbtVdc7kanH5GVZBtt1f7G3N6mZ5GRb9JXFO++fSMORg2ags3T1oqL3pcr+ZDejWTwVoZp
 P8p79XM52WpGTDUNnoVq6QRWxzWCk4kQIQTuBTO+RaHK8n44PN0fEW1fyg0rCryfWg6C2t4mD
 F7WrPzDZef7dxAsm4QtY8vBv2aqpD//Azni7B2mUH6vlILgNDxJhYg9AYmNEDrsSX0Wul0wwW
 lb/X7oJ05ZPj5mYd0fWXdPuNa0fJffU+WffnABxzskY5CoitEJnpYMLxmVrZXe8BnGu7ZPZ+s
 lWDgO8tMRxvfUy5QUPQlf4TsfvME9uM5OLyhNvd0nulk7vXaRZaXP4OoN2Q84uzmv/lTza1bq
 C0zdgVanPqR4kOdY2gkdgaz4m2HDFbcs8Mwuv1gSsQXnhqfPv6H38ZGAJmROs/vobMCqxOFIZ
 04YsDv2LJ4L6wuchGckwJf9SVEnVs0V69x+id/PJDyHGo4Q4AhAAqM4DSD5s1ku22zGGqBuOw
 98kzC9duJHWUNY9o0dL0AZWDd0NxssBhtFWejGeUTy5S2e/dVCGujztKGtC/NZTTmr6faXR53
 vqfE0/ZKENVEg4lu7kBtoUlT48q6Yjkpu3Fj1pCEcZELXRBMZ+f44ySMOy3s1SArxWXoDfYhj
 XPZLIVCGabBFoEbTZVkerX5s4Gmg7huwZn3iqTZvj7xjhQvTGirzLI9ZQ1YbX5W68/gNR2rci
 00RUAHNa4RIvZS3ar+raGfwDJWrKwgSo1XHRDPTgwD/fmm6wzVC6z4wNBVar86rgKaTUF5ngG
 +tu4fdlAqVZYaoNdl2yHJFPNO1W76pg4fleJjjrJsgW1uw86yRaJKrQOhiqoerZvYWL/8AsFp
 Vdy68OjN3P5VC0HELDXOaiuIc1zJ8LwQGShSPHpn31wtALBCFVQQ08D1BjAGfL
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nk8Hs40cmV9MR9zSgQnsOLP6JdZyKTUN7
Content-Type: multipart/mixed; boundary="KgtofUoHmhYTUzhauCGGjTGnLMl2NU0B0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Supercilious Dude <supercilious.dude@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org
Message-ID: <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
 <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
In-Reply-To: <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>

--KgtofUoHmhYTUzhauCGGjTGnLMl2NU0B0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/30 =E4=B8=8B=E5=8D=889:04, Supercilious Dude wrote:
> On Sat, 30 Mar 2019 at 13:00, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:=

>> I'm purposing to measure the execution time of flush/fsync, not write.=

>>
>> And if flush takes 0ms, it means it doesn't really write cached data
>> onto disk.
>>
>=20
> That is correct. The controller ignores your flush requests on the
> virtual disk by design. When the data hits the controller it is
> considered "stored" - the physical disk(s) storing the virtual disk is
> an implementation detail. The performance characteristics of these
> controllers are needed to make big arrays work in a useful manner. My
> controller is connected to 4 HP 2600 enclosures with 12 drives each.
> Waiting for a flush on a single disk before continuing work on the
> remaining 47 disks would be catastrophic for performance.

If controller is doing so, it must have its own power or at least finish
flush when controller writes to its fast cache.

For cache case, if we have enough data, we could still find some clue on
the flush execution time.

Despite that, for that enterprise level usage, it's OK.

But for consumer level storage, I'm not sure, especially for HDDs, and
maybe NVMe devices.

So my question still stands here.

Thanks,
Qu

>=20
> Regards
>=20


--KgtofUoHmhYTUzhauCGGjTGnLMl2NU0B0--

--nk8Hs40cmV9MR9zSgQnsOLP6JdZyKTUN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfanwACgkQwj2R86El
/qhhlAf7Bf5bAv8le3D2vLv3C6smPYhs2A78ef70Flt9oTPmIzyDn1OiLHLaxGMj
q1/uOb923PO5cP4bOMKKQcFvCUE99QoNoWGmBCQIRLyhxBJOH3cCcrYhJGfywfzy
Nx3GZwjX2ZORQo4DyJf6jWER/PfDgQX7JAhJVdN1kIYIwwTp78HwhN00KDI0xoet
piUWc+H68Osl+HSrsqDi4vKVaok34ZKbet/VJg/nhxPG++8gTFBcUv7yTr3hiarj
uuPBQd+utKZkUaQIqpqS2Yr/EjrD85+wv0dtDgFGCBhzW/a0BHdOSN5qEvH4tU1+
NYQAEUzaVE4jvx3FbpKJ0GdPfD47fg==
=R7Og
-----END PGP SIGNATURE-----

--nk8Hs40cmV9MR9zSgQnsOLP6JdZyKTUN7--
