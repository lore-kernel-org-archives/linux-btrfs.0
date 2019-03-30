Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6118DC10F00
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31F97218A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:31:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="eLI+reTg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730697AbfC3MbT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 08:31:19 -0400
Received: from mout.gmx.net ([212.227.15.15]:39915 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbfC3MbT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 08:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553949077;
        bh=9ZHyt3SR+rgdJcF4NsX8GUU3tK45nZVWmsb9fW5V+i0=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=eLI+reTgRcmVyvuwqKGz2HIaj5K+VSsKF0kvjNRMKmT5m+8W/2eOSqjW9LNJEL/mW
         rt1JMehHn24xzvHCMxMV9wokOMnjS/byJha2C/n7quROOYX7zmE+K8cBm00YdRQbOa
         FmVDqdpK1iYo2D9U6kHuCHaLXl/oFS5251pMgUAk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lpbqo-1gV7kw03pm-00fTBh; Sat, 30
 Mar 2019 13:31:17 +0100
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Is it possible that certain physical disk doesn't implement flush
 correctly?
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
Message-ID: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
Date:   Sat, 30 Mar 2019 20:31:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LgzMUsLborRE8e4cwj4yTVNxGRf2MnYFv"
X-Provags-ID: V03:K1:FhiomOT/Crfn+x0qtR8kwWj4qjzIu7Qr/OtN/UW3834YW7ZB1Mn
 1QXb4VCAuXHN7WAAfjJpVdhuYQpR3gNXSkV9TYS+NUci5+t9rBrQMgnH1GcvylrYRs/UWWX
 3AW6JvOtSAIqyK9YV5WYmNcpKym/0E9n6lSGWEgBvgxQ5JUP2LcvVH9gqlyQVpIZ0xqMfYW
 bwHH+A8R8jq9dzRBeZooQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VlS7qES0mkc=:DZOLllc9HVbfBGHd0QhX+m
 4zFaNy/nfxnOLNzx3cvIEbt643nmIKRfZynZZFgU2rchh3fvgprbq+gsESrkMvqyDTVeDQ6Gc
 EBGbMlzq45p+DkirMhn+F/6ySbtJvjNU63QAp0qJ1WN0FKM9CtRCUA+nrCdDlDf/YKPlXWjwZ
 6McoiHbQkI8jMQ9SoEVh3oSA+K1fr5+N074UVy2vT//WMl/q5dLhfW6kWxUnn2U0O0SJQof7y
 TgsUsjUX0kfFJcN1B+FqZ9bicoCsgcMklub8P8nfHBpDOVn6LeGBJsthKZ+CEZDPSGcd4S2Lc
 Pmboj0B5QysWg80uZD1uCAFm3Xtw3i9U8qzobdGPJmUCdrpQqvhOh2Q/LrB6kbRcYIXDsHnT5
 tnsjbeejD+YaAbRjeWthw1qde8YalvQ5B0iHLQ7QxW3uFKqgEjbmyiqPL4JbYQiLZEiQltiCc
 goteB99lo94lASecSBamWzS+IdWTEwqbGKnEPj1PicZKoXIMHIQ2bgsRy7msmL0UXZh0tbVl4
 nYGRVvhDkhXkye2fjEckCe25UTXFv/f5/gPYZYYaXxkz3v54dyQBNFaCefywzVUZpNMyutsTs
 6cRKuNPncSERa1lxiCIrLh5Q9ycozuPECx5p/WXNRnOsmAjtGoDOtMclwI4TqDt50c/pJavVx
 YGr/CdXJhnuUiIMmXZBkJZJWRYQUHtcbcIRmkUNpbrnyfIsJoaWL1VloICt9JP+eEYkr23NPh
 azCUJTZGV5WNnbuLn87qAGrbVO9LWSQ5PhuPfBif9xLmpKGR1285WBNut7PHG9uduGtEAjqge
 JxitnU/nMI/jnv0lEFKTdHlXotzLtgyt4Znx/br5ICaMM7fN6cR+GqjREcrEwkOdqr6Phn8tI
 7lRS4Tljk/7wrQ+pjesJcNtpOHMuHqQLAM6vCGMvMtAoS1qbXVcHRJzPCA6DdI
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LgzMUsLborRE8e4cwj4yTVNxGRf2MnYFv
Content-Type: multipart/mixed; boundary="lJJTIDHHrLzsySp7feQTJfLGV7wLPCjwN";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-block@vger.kernel.org
Message-ID: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
Subject: Is it possible that certain physical disk doesn't implement flush
 correctly?

--lJJTIDHHrLzsySp7feQTJfLGV7wLPCjwN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I'm wondering if it's possible that certain physical device doesn't
handle flush correctly.

E.g. some vendor does some complex logical in their hdd controller to
skip certain flush request (but not all, obviously) to improve performanc=
e?

Do anyone see such reports?

And if proves to happened before, how do we users detect such problem?

Can we just check the flush time against the write before flush call?
E.g. write X random blocks into that device, call fsync() on it, check
the execution time. Repeat Y times, and compare the avg/std.
And change X to 2X/4X/..., repeat above check.

Thanks,
Qu



--lJJTIDHHrLzsySp7feQTJfLGV7wLPCjwN--

--LgzMUsLborRE8e4cwj4yTVNxGRf2MnYFv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyfYYwACgkQwj2R86El
/qicQAgAkP9/9VhXS899TPfJdRpv0eFR0IGDUQzly5VyqzhwOwR2ejbXUVGaLsU3
3rCv988uZwU634rKyA1PGZs1L7yYY0Cd4hBrK4FMA1x8+TCI7Idc4N5C6Ho5+aCd
HoOB5WG/I2nQLv0wglOeKvBPwSsTFmVOoFwTa/UQT/zMaONlhTkNf0FInOB1W8W0
Dl0/k+NModJfXYrLl67SQjDqBsbUlsLtkZBTrPC8rRz8L9J3rOw3pslgQtLhORI2
nAc7b9/+UevL0G2/jh9Lh3JTcAAhLPE8Jv8gFcJ8bP66QycCqtqrQvOCyWxCiHRe
31oahlkJdQ+SpeyOBmonxmkAGEeg8A==
=GkOv
-----END PGP SIGNATURE-----

--LgzMUsLborRE8e4cwj4yTVNxGRf2MnYFv--
