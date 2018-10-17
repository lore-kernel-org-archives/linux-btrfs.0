Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F12C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 01:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC13214AB
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 01:08:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BC13214AB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbeJQJB1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 05:01:27 -0400
Received: from mout.gmx.net ([212.227.15.15]:35191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbeJQJB0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 05:01:26 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MDhba-1gQNZv2vl8-00H9se; Wed, 17
 Oct 2018 03:08:18 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MDhba-1gQNZv2vl8-00H9se; Wed, 17
 Oct 2018 03:08:18 +0200
Subject: Re: btrfs check: Superblock bytenr is larger than device size
To:     Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
 <20181016182550.60bafce18bfb07fb4bcf24d0@gmail.com>
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
Message-ID: <8635c78b-8a4c-c9cd-9a5f-6066ec981caf@gmx.com>
Date:   Wed, 17 Oct 2018 09:08:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181016182550.60bafce18bfb07fb4bcf24d0@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4AMeB1uE49uutHsdL29sH0YSyfAJyzJnX"
X-Provags-ID: V03:K1:lv2RIRXv4LTA1Wp1Hqtm+QiKjOyEZezfmHNL0smLJeZrbTTnCV+
 hoMNug4nEJNfJb3FTPJ71v1cIzAedaHcCg9Jjd1NQ+Ff0wKRDrD8EmXhHnX0B0ykNp/bJR9
 Apmg/FaD9g0OLT2bUtuS35Vz7lzZO7oLdUgFRwffcTdUYZDTNMd547LI2N4JtB4dx0LP5Ie
 H3gZPaUZ7n5PyRZciuOog==
X-UI-Out-Filterresults: notjunk:1;V01:K0:9b4lhVWmfl8=:7QcLssYMKHofz8YwgA8hJ2
 aiOm9tsjLN/rn5zOiHGdM1PnYFYDa/VEj/44LojBl6//iPWrmKw2+JvXfbWj/x1okhZecdKTV
 ykbr1ZhNfhDCUp/D2s0/epfxsoS5rC+jiLGJKnJVhk9eLullV7Gl6MqKl9iOtRh34UXcR4mIW
 n96R8xorrCLBhR76Y0rT+q2HOHjgH6A5q6EhPwHDxFsph8P/OjFlvHBjs56AdV3VQBo97gzZf
 Vfj58Vhc92OHHhbvn+Q9Kh8kyXAMIGtHznixqBRvyAfPimGvA1cmvwkiegiTRF6vMHit/9MfX
 4jlA3z5FZpfVjzjLbpKr/yoWsKwiTjx6QK+bV325mKm07W47tfrE7vMQFZJkceQTy6oHoZNFZ
 aZM7x35JQq7ik4CMtqaUL9bMHB8G+APRbEueEcfOL+CvcuXnUDITYArw6IyQg9Tjz0xf3k/ua
 bObzbnm4GqYxh2/6CTi+Dgfl3rrRQCCFmP/tbRZtbh2K75VWqYi7PXi404oR4b+03B1JT/ISA
 kYeWsmGBh7fWJ9eReQx7NYoR26GiUi62tyz1iL6eDDKzZ64Z5/FZw1eUINMOCIcYHeKm2ZvWn
 8SrFJyYxE9SGwdy7yJO86kF7VY3ZNmDZ93s/iZS4L47Solqt93D1eVYwGvikHNiJFoKA0X7mX
 OcVtkya49qIfwGvl/rULz04neqekt+E8AyRwKeq6z0WxAbSaWcOZFY25hejN/8I8hZMcUIigt
 qHEsWbIYDTE9I/vFpmTb0/dJKOx0U+sPqORme4ifRxmGcRWu/o1f9+TrRDRrZqlSkaMP6WOHr
 s5n96DynrxCyW8tUj7PjKbyidXhNw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4AMeB1uE49uutHsdL29sH0YSyfAJyzJnX
Content-Type: multipart/mixed; boundary="Lt4e9yJaWByQx7j7sDd4uoCTQGrk9LCuJ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anton Shepelev <anton.txt@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <8635c78b-8a4c-c9cd-9a5f-6066ec981caf@gmx.com>
Subject: Re: btrfs check: Superblock bytenr is larger than device size
References: <20181016170538.8a7d2fce3a9c7bc9e63642cc@gmail.com>
 <20181016182550.60bafce18bfb07fb4bcf24d0@gmail.com>
In-Reply-To: <20181016182550.60bafce18bfb07fb4bcf24d0@gmail.com>

--Lt4e9yJaWByQx7j7sDd4uoCTQGrk9LCuJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/16 =E4=B8=8B=E5=8D=8811:25, Anton Shepelev wrote:
> Qu Wenruo to Anton Shepelev:
>=20
>>> On all our servers with BTRFS, which are otherwise working
>>> normally, `btrfs check /' complains that
>>>
>>> Superblock bytenr is larger than device size
>>> Couldn't open file system
>>>
>> Please try latest btrfs-progs and see if btrfs check
>> reports any error.
>=20
> It is SUSE Linux Enterprise with its native repository, so I
> cannot update btrfs easily.  I will, though.

Then I recommend to use latest openSUSE Tumbleweed rescue ISO to do the
mount and check.

Thanks,
Qu

>=20


--Lt4e9yJaWByQx7j7sDd4uoCTQGrk9LCuJ--

--4AMeB1uE49uutHsdL29sH0YSyfAJyzJnX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvGi34ACgkQwj2R86El
/qjJWAf/Zq1tIVJ+/34MPI0SJLm19UfuNqvZ8SFgK9RjclaRCGyxaDXGQc8JtSHI
mOjEmDdAQdJXVxd32TozADEkCNMNh6lqwe4rq46Q2rj+sjG7Rhj1+GVjmNvfgdft
AWfiCMMDLQxFHr+smg+HVEbQJ/j+Rd3xF/qnp4JnYMx/5Gg5GnMv3Wd225PhBrBx
RDgzhyAt1zJ1L2C4lmx3bvQTMaDcEbqyYIMV1UsPYNXL1T+YhnNoMDhgK23e1UbR
UYjIsi3lv7xPanqOwaz3nf40vZxCn01d4rdio5aoN/QtF31MkPvWG4FSpeJH3e5P
LdlspqZxX8wTbJCfDrQXBeagHV+5vw==
=IQ0V
-----END PGP SIGNATURE-----

--4AMeB1uE49uutHsdL29sH0YSyfAJyzJnX--
