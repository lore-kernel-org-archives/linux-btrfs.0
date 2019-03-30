Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B6EC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A06B218A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:24:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="WfzyCiBu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbfC3NYt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:24:49 -0400
Received: from mout.gmx.net ([212.227.17.20]:34997 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbfC3NYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553952286;
        bh=7jAQ2ntaEiZKUx/MFS+mD/vyhysD5QJAA1ODp3daJCs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=WfzyCiBuaajriHvCVPt8oVk/PjdTFRBoHqlfLQHczqdTDCBD8bm1pCnMzX2WpR0mN
         DM9xwQ0aEqWo31YZdQ6f8D4uFq7yeKQX1Pz6BcohS245u3bHQArRgIpTXz4fBMn29N
         r7GsibodXlSJDZzBXJOvrXddv7yiYqr+RInSOkf4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Mhdex-1hMXvT2RSl-00MufA; Sat, 30
 Mar 2019 14:24:46 +0100
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
 <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
 <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
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
Message-ID: <4f5586f7-aef1-4e2a-2aee-5d040c023c68@gmx.com>
Date:   Sat, 30 Mar 2019 21:24:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1izgcv07X0IHw74ZdVylyyyauGPsuYK6H"
X-Provags-ID: V03:K1:mPgpHA1nBKVX94uaDMwy2FN+EoGE2mNBG9yLu2uYhX/AoZfxjlh
 3PD+4gB2gN3lYxKZKGy8hj9hWopGMsTuIYeYjEQUdJ/JZhoD3u8fBpW9ykeOiDTYh9re9JG
 Zd/+GRecO4gOdO8Xgtx7E9r0D8yrhvH6cH8FgK+Xpry7CKDR/TStYKF5ye90SDW8Os862Eh
 1NHRdfJmMrE621w7jGbwg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Zr3OMGTNwCw=:GHLpU5Y0XQMlENamVV1xHm
 8iJWpdEVytdKEg25A0c0qHQNVfFt4WP/vzgbyQjPLPkQpWa5W4D7X+55TvdeIt0RxvItj88fo
 X1D2zweycvhB9Wpco4u9Vdk1kfz+2NjwfdCYhDp7HPGGV3yLYNwzGaTowYDJyuYRZNrg0QqWx
 plKCKkfclqsB67sUBdDm8nuhWMBkaxPmThpyoyA1067vAC7NJKXVrCCc3KZwvJ1ROyot4qKZp
 wzWFf2L8lpl3vK5ubVjBhDUZUD4ZSPdfyGTKXYb/mhOvAVlGOYD0xeRGR2TF3WD/qvihseeCF
 25FChoedMNVEOL413ziV+ByHZzqUMEOgPjPKNzCnrPnjSuAEfTRXnPfYJZjH9iBoIxgu0PRJI
 vXpWAnK5u4709LtFhGhAfLoQvOYgBdWeVY4l8DLDdL26v3BYKkymYEU4gaXOzKY2ML8mXPaoO
 MrY/FcSk0wQ6oKRJ7qpeGVcNa5FNB1JklMe+e3HC+EPocd6WRepoRXX9+Wl3ehxeBEnbVMiJ2
 VG3dSmqHQzmwLPwOSLfvwklR4yzM0NxJfVsABNnAzQ9557LPhFvYA/RHcTAr0zXp/NuTHZvrg
 b90ep0CbX6kinrqxhUMrpEMK1H6BNBDXe4FY+T8t0RavXwewfKMgCxydYghNG8BTp97z4IJUt
 vIxS3M2LQaVQz+MKe+e3lb/nPwAnCA1QNuVhcuPGUcov6FkOV6P6Ng8xM9tFVvmr/T1w6JRN5
 A78zDEUQeKAE/WAgDPwzA3YGzo8BDyxaao2NWhgYI6KLPOY9lca0rGiCRxq5u6RIUYbu4KfWV
 eha/sbkCPb8ByJj7h7EUFBDW9lU2Zlj+FdAj07OeMxgGbwu1HJc+WEHBwtuDa7W5mZ4viyVEm
 NHNkw4No9/l2l6Vk71Tr7OiZI0CHa8HGgNRDaeCvwunuUpmkKzUSHD+N1KR90/
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1izgcv07X0IHw74ZdVylyyyauGPsuYK6H
Content-Type: multipart/mixed; boundary="NOQREzQziCX4ex6yG6MXBEfUFCWyZDAzy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Supercilious Dude <supercilious.dude@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org
Message-ID: <4f5586f7-aef1-4e2a-2aee-5d040c023c68@gmx.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush
 correctly?
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
 <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
 <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
 <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
In-Reply-To: <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>

--NOQREzQziCX4ex6yG6MXBEfUFCWyZDAzy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/30 =E4=B8=8B=E5=8D=889:14, Supercilious Dude wrote:
> On Sat, 30 Mar 2019 at 13:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:=

>>
>> If controller is doing so, it must have its own power or at least fini=
sh
>> flush when controller writes to its fast cache.
>>
>=20
> The controller has its own battery backup to power the DRAM cache, as
> well as flash storage to dump it onto in the exceedingly unlikely
> event that the battery gets depleted.
>=20
>> For cache case, if we have enough data, we could still find some clue =
on
>> the flush execution time.
>>
>> Despite that, for that enterprise level usage, it's OK.
>>
>> But for consumer level storage, I'm not sure, especially for HDDs, and=

>> maybe NVMe devices.
>>
>=20
> How do you distinguish who is a who? Am I an enterprise or a consumer?

Easy, price. :P

To be honest, I don't really care about that fancy use case.
It's the vendor doing its work, and if something wrong happened,
customer will yell at them.

I'm more interesting in the consumer level situation.

Thanks,
Qu

>=20
> Regards
>=20


--NOQREzQziCX4ex6yG6MXBEfUFCWyZDAzy--

--1izgcv07X0IHw74ZdVylyyyauGPsuYK6H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfbhUACgkQwj2R86El
/qjeEgf/ZKJdbW0sr5a0x7OgTCMpD+BaJRstiSWEDAtPBo0d1Re7fyrV6dMw7IKR
dL8ha2KgZl8F9CHOXwyo9XArMkcroEYiikguw+lzl+gHMbva+k7pwCcTPzH1B6Y5
uRxZwsaWTSFsUTEpLmrhu9Qt2wNLqIzAc7s5r91Jv17Y7po2r5W8CF6sbRaVliAH
Bw2geCsg5aIF6596WDBNJaaFDIw3zEBk90BvOydmWGpc50opvWj06JSVLy4wIt/f
88uuBgJbvhdHaSwzfc64Ak7lXobAfNACNSRfG4XGqktjI++LyAnrfqmajcXNBMbE
Kz9Q17nNE2kBy3Va6xpzXAm3L4kemA==
=saC3
-----END PGP SIGNATURE-----

--1izgcv07X0IHw74ZdVylyyyauGPsuYK6H--
