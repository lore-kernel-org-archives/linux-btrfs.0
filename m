Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81655C10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 06:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E2282082A
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 06:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dsAyRqoN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfDJGeQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:34:16 -0400
Received: from mout.gmx.net ([212.227.15.18]:46289 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfDJGeP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 02:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554878054;
        bh=oxDCM+INoThlvGXRkoIANGjtT5ldSJXZE1GGoohAtc8=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=dsAyRqoNc6WU8EIrViijR8KdK2x23H1YJeej36oLnwZy882nM/u62DLZjRP+wWFWi
         XjRy2LlKsEAnLXpvIiJpSgpsPjEGDLczHW+8+J+57Z0pSIvSHkG5Hvi90p7rkQT18+
         /XVjUpBQFmiDPryaYiLoOwoSY8pPSgC7lP7W+3GA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M1HZo-1hCRqx1ysE-002nlH for
 <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 08:34:14 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
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
Message-ID: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
Date:   Wed, 10 Apr 2019 14:34:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mHCh68JQdGlnsBNb0vTSVX49cOTHrrVrF"
X-Provags-ID: V03:K1:pPyZ+1GV+Rouc0a+OhtZAUpOQT6x8AyhT4KYUN/pznAyyi1Nbk3
 8tvwv5BsSQf+7zrN+msn5ybVo0/QinkEv0Esg3ms7gqxLxaUinsONguCybZQk7UWP36UIWQ
 rkgd4XI1shqMykV0G8Udfy9y7BxhRY/2HXJMYrTOaupw5+oVGtPeIlNxkvD1XWNJcG5JEsg
 y+48DOPBqNgoT9BJzudQQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zYWPNI/uXyg=:TtZf1u3Sef8ewyPfBnjttY
 m2F58Le7CsSiPzI/z68cT607QNJpa2ZTmBXxW+sZS5tvHbpwhkTgqaEFJE2+ynH3kI1hLMGxL
 y257Dr/G9tB37TfB4hTturw/wZpydNeKgqjczMY1sLjDKd6x7Wc9X0LmoWnvUx/QK8ZXuab9q
 d6OcuQ28rtBG02URLDmh246CUZMd8YTcs2RdVocJNG1RyCnmqT+x/AjW/edzoR/g4nVMCHaHD
 0grn5IaLRi+SGcNS444t3HGJXMju4h4mGVTaayNxdl0ovQ5zdRxaslF6W8zoEaduNggxFD8b+
 nriF0/e5pAThSK84PyJ8fskqmewXrdFJDzDxjMshj2qP3lU1kdiTNbcdWfExtR3QITsPphFis
 YHRB3YZeBmK/zY+ZHokPqNLszsQVduacz+9r0ZMnEHO1goHXdtJvboOBRJ53qsUO5TPhD9H2S
 ihGup0seLmCrICBJ3tGGovhEcFN6uGayTGbT8E/ZZmJf3gEsvB/Zl2NqLc8ovP76zwz+xRKbY
 71xLYk/J0ET8IhK0xBmf3KenrDFcOdgoAtoxh1rqO8Qc4RsA+eLTGB8sEvNVYN9PdEPv7Ia0v
 lZRjV8YLaZMtNbUPGQZ946fF9325IUmTWZ7Y1E6SP/4vSXaWWRlVHtnLpJX3hs5DJqYQkb9U9
 24VVi+zVWtb2HqVQheLVM1Sj3iUddeEah6xjUN9Qa/JfKz+E3ZTPjmtq2zyIUECiNtE47iZ9T
 vilnChbYYmmUht3XfHxLeJG5fAAi/WUGLNelL6Wl3WdNwNj/BAa7Y9F1dBKzcEJpFyeBwZ2h9
 Imaxt3tB+GYlkZ12WI3v9tO42GJNdzRZm+iQLvjZvPoFA/Iet4/1BBA3kv4ZheNrAGynCugCQ
 CW1Nc6M3txCEP6IGfo8pDpg5y4f8J3/qYd2xctYusBX3E3SzViZM2iZfcEOEdM
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mHCh68JQdGlnsBNb0vTSVX49cOTHrrVrF
Content-Type: multipart/mixed; boundary="svWB6QDVdmrAWhJjmOnJ5aU6y2Fp5l2RW";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
Subject: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?

--svWB6QDVdmrAWhJjmOnJ5aU6y2Fp5l2RW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

As we have memleak.py in bcc tools, and it provides better info
including the calling stack, I'm wondering if we should replace current
eb leakage check with bcc based one.

Any idea on this?

Thanks,
Qu


--svWB6QDVdmrAWhJjmOnJ5aU6y2Fp5l2RW--

--mHCh68JQdGlnsBNb0vTSVX49cOTHrrVrF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlytjmIACgkQwj2R86El
/qg5/Qf7BxCi5aFliKfONeDvj0mNlV9Lp1Db80CVi2GMcbQVyae0j3Rj9ireqnTK
TnOfwJoCl9giU/0PAP2xjYrsimrgbFZTsHElkU2ER3koDJWoaV2FNX9G/gFjSj2R
mDhsqpDcAQRBtY3G/yAH8Fd79ungjERIqSM7rN+1ThV8agaEzG3xmVAL8Av8URiq
FNO7YrTXrJ7qgpgSzfWvlYOOtaMErDRpfJpxoil/U+b8COBQMhakQbN/pY06oYqX
Wg9FOS5lkyGgtCSpOi09DcP8IFiTXNOJLVHUwGT76nbRhTyKTlGG9sYvYvUYg88M
gBAVw/CnAhY9ejfGjVt0vPy7DZVAlw==
=+YP8
-----END PGP SIGNATURE-----

--mHCh68JQdGlnsBNb0vTSVX49cOTHrrVrF--
