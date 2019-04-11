Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EE4C10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 08:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 370C62082E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 08:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Mcg9/cTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfDKIUa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 04:20:30 -0400
Received: from mout.gmx.net ([212.227.15.18]:45921 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfDKIUa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 04:20:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554970828;
        bh=CvaKq1Fmc9RkiitnpOewdcsrxgqfzPIQv+Nfqgr8rnY=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=Mcg9/cTwVmY0PeUGMfdkgKmo5Gf/6NRvXZoAIleVOUOLLJWKkcqN3qOwetlzm70Wv
         kXfPCux4hWLTTN2hp2fE+y9hUISFxGkMBkH+YUn+91+OOBuSEU1XISwoMuLSjDjj2p
         w9AsapsxMex+5JbqizS98YFXDtDoHa2MIS670Rh8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MZCfD-1hRqwc31If-00V9cp for
 <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2019 10:20:28 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: New btrfs related project: btrfs-profiler
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
Message-ID: <f835c577-873e-1144-136b-3129b449e43d@gmx.com>
Date:   Thu, 11 Apr 2019 16:20:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kABvd4trlwDxhCS48bKP2HS7A3VrW7eAU"
X-Provags-ID: V03:K1:MrZvMIhUocyyTMJm0soT/e/a0/G94ZAzHuRHD3qzt4dZJdRGFXi
 Dg8KJF7u+WL5DYQ4fqI76umK4X3FBFTr3uuDydi3N6T6KdlqUhPDdvZGwbK1upSDf7gmFTh
 pfZkwX1b0CoMRNAEgKJMWmgWrwMgBA45zeDlrHVucdcalih5aMlLpYjr75WNzcyl+dQs85n
 0rzeCvUN8olnIdiicrZSg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:kGABmpk0Rss=:1vSjWLYY1XPASW9wTTtWc5
 GBQM5Sw5R2HakhSnpHgJOrwqvrOwURs5bTcHp9FFPCvH8EuaIdQA/s0GTnqeDZYFsE4ii5imm
 SVC7MBf/eeA8PXu/56EnO16y62fkhtwV+f6HbjIIyUji4OLVMCegPZofzBEMs+8Z3dZk7czsQ
 kwo9hRivhX8iu2xDhhRfDWyeax17dKhfWsCZ2WMoubgNKTGPmBfQ3+kAYtbwBVwtH7ZbEl0Fi
 mzjq44CDzuWYPxlRYAJpNPbN49LO1TRO/vtRix7U9Ok0C6vLVqWZJLKWoV4frIvgjg8LcMiWO
 uOLwiot7EF86+w3n/rbJ/tlxNG0VQCBEErXLXFwdAjWJyens6MECNcPd0yd4tUPWMQstxRnSe
 xvRpREUtBGrbxNndsYhecGiFWBjQuF0tNSQiIWXhU8XluwsHEFrXAPO5bi9aE25lA+MBG7Y//
 PlLDA4AeWyoLHWpHNhL8Iy9OX1b26+89k+t9QfGSyIjBoIuzF8VhyDz5ZbXvt7b54TGDiftOa
 i/83iMhjT4idbV2yScXagqZzqflx/YdZsOLj8gBHJjXyy7DAKUvw2g2o9jmrtWTfanwbbNuCQ
 /4clwKC8Iyq9z2rYt0XMwJYxNRf5dMCOXgcRKhdHU8HQHxgbf4nuARAicM5/r4i9Xto/RJ/vm
 9bcpWzv2wbCsnmF54e6dBjzwJPEd1myPSN2SKCCgVDKW0r0I7nXtYJM3dr8675bb3sGSzHRnG
 lemL6vmH3NZTmbVGMSTpMlxdYviUa3+jA4m+9hOF7j+CW/LE/dcW7Et3nW/1gP8Q+/ZdNjSxJ
 DfjReSFFucBaVFceC6U0m+wYuM0757a1P1cob28E5o6UMqvIRuX40WSe+Umcu351ohUNVpU+Q
 9+0tjihsaqsaaABedvUlYQOAkz3J/UTyp2iEh9rIP7HUq3NA9rnGIlS/nZi4oP
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kABvd4trlwDxhCS48bKP2HS7A3VrW7eAU
Content-Type: multipart/mixed; boundary="M6RcUB8FIO4TPholKN11lDpFYlyUu6i80";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <f835c577-873e-1144-136b-3129b449e43d@gmx.com>
Subject: New btrfs related project: btrfs-profiler

--M6RcUB8FIO4TPholKN11lDpFYlyUu6i80
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

With recent dig into bcc, although I have submitted some "scripts" to
profile btrfs performance, they are just gists and mostly fire-and-forget=
=2E

Since I'm really a bad python writer, crafting/debug python script can
easily eat one or two days, it's time to craft a new project for all
these python codes.

So here comes to a new project, btrfs-profiler, to contain my python
doodles:
https://github.com/adam900710/btrfs-profiler

It only contains one tool yet, tree_lock_wait.py, a script to get
realtime tree lock wait time.
With new -t and -f options supports.

The project will definitely grow to fulfill its name "btrfs profiler".

So any contribution is welcomed, and there will be document for guys
what to contribute but not familiar with bcc (just like myself).

Thanks,
Qu


--M6RcUB8FIO4TPholKN11lDpFYlyUu6i80--

--kABvd4trlwDxhCS48bKP2HS7A3VrW7eAU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyu+MgACgkQwj2R86El
/qgz3AgAnZ5t7296q4bkbnWtnwQvS1PtoM3egWiFCkDe/TmKp/TM8WnTq18WzIqu
LitN0+rbGLq4yvZDl4F3ICtl6QHuNq57xdOIulsiqr7DWhGM5db223jJfTnbUGm2
QJAoWM5Fpt4/aesHrDdwV9aUk2ToHe2jJ+yjGwYgrRtODlXdL3cyxV2O+Woy4TPb
HTkHgUVa8lo8cO7IlWRfaBXX1rMhpK1Y0pBBSgjluzBL+18v33lm66KRCE+lWGo6
o+jLLIHqE0d3tKmfaNyc0arRKtsYmHtP329EiMKaoVnE7JlcofX8ZU33gqChz0a3
5KFgfkLZjxX25EMhFU7TPciGC7u9lQ==
=q4bc
-----END PGP SIGNATURE-----

--kABvd4trlwDxhCS48bKP2HS7A3VrW7eAU--
