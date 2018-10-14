Return-Path: <SRS0=Sb/y=M2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1422C6787C
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 11:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75F4F2077C
	for <linux-btrfs@archiver.kernel.org>; Sun, 14 Oct 2018 11:31:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 75F4F2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbeJNTML (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 14 Oct 2018 15:12:11 -0400
Received: from mout.gmx.net ([212.227.17.21]:49529 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbeJNTML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Oct 2018 15:12:11 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M20Jj-1fMQqE20OB-00u17c; Sun, 14
 Oct 2018 13:31:18 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M20Jj-1fMQqE20OB-00u17c; Sun, 14
 Oct 2018 13:31:18 +0200
Subject: Re: BTRFS bad block management. Does it exist?
To:     waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
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
Message-ID: <ee7ffc4f-c49e-7900-11c6-f506ec372746@gmx.com>
Date:   Sun, 14 Oct 2018 19:31:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cJ6AjUgTOiPJ63ZrrsRGo580qO0VkoVFx"
X-Provags-ID: V03:K1:bYJ4seCBkGWqHIioYdoPd4yEO0VmpGXaqvdFK0n4C5Gnbv3QxRt
 PelBrwLZsZYPn3jT5v0K+B0hbpq8HsEGMoxNUKvOQ8mnvQ+FoWVSv9R7sG9FVDNOMwgH5Gl
 TXHDZyDpNYK3e9kaAgDpMnvaazYGdRF0FX63L0+qmiNGtoPp8yXWOxGurPeP6yg5bAber9u
 4ECEC/6Q3C7Qvr8GaXX0w==
X-UI-Out-Filterresults: notjunk:1;V01:K0:HRWw1xiqAJQ=:AVlpQp0QG76yiUZB+UstBZ
 +hCHTsw56AxNHP+W3+d6LeyGW+eEfshI8a8QeUjvj9q66SKi91ngG8/wzWklfJJ499x2gI4Nm
 cgRSknqaYzJnGH5T7FtNDrMDyOib4OPyGjAB3bwV7QV3J4sVd73y6wFPAJbPzSTdOG2mSQkxC
 SvBYU9p58L+ukZnCbavNaUIi43uYo8tm0DnM4Hf7BUBfk6m4jXbme8QeGyW6epUyg4ryzF0Oh
 BgFVZhIr0sKJZSEqoKHx9aAf4J+RfoPkO8mBwMazrNqh1UobGxR8US4l0dm4Q36iRzkVl6TS+
 /L5IeEsqYdhrt9bRFLGexVDzixmIwpsmEBr/oiCz63Zf2uGdnZWCzyfzoEiA/Y3g8IHIaiNxP
 hIGtq10ILHfXvvyJsN5oyoEWjqqjo13JzQJ1zs/3D3J9WBhz068Xd1lws+CvugS/t5WsHWShI
 J2PjOf0zSuDMLt+a8Hn1xc+QPigKYdQdbZO/sFoRiRIX61I91ZIYvtCNT7uxdnpScl9YWTzke
 HjgVKxndTqcKwNG3lkSra5toj9y+qYYM1OQqTw7iCvZdzR0aP3UnyGiN2rJfys2RtRXyLgWno
 STE5MuAH2OhY1nrA6zyOFVcEiJ1xrQW0pt61dVQ0ZrsWRrhsjWVTOSeIAlHDbXl/+duB7gBRZ
 /lRheK9RFUPZYpRn2bbbyGyC81U2ufwku43xrvUSephFUnvkRRwSR7h6KxRcqPl1a6BuE8M59
 sC1GVaiG4ZIZXD+MBrMFAlERpsvCQRJu+xL6h+vC0s2fOokmut5Q7M5h7yn/dpPt9dttMP1l1
 c2e9tSKR3tEY/wGHZnZqkwW63Dfaw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cJ6AjUgTOiPJ63ZrrsRGo580qO0VkoVFx
Content-Type: multipart/mixed; boundary="tZziZzNt5BtexTGpNjDa15lvutVdXDFaa";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: waxhead@dirtcellar.net, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <ee7ffc4f-c49e-7900-11c6-f506ec372746@gmx.com>
Subject: Re: BTRFS bad block management. Does it exist?
References: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>
In-Reply-To: <42b1965a-356c-25c9-8c49-788a9a8a11aa@dirtcellar.net>

--tZziZzNt5BtexTGpNjDa15lvutVdXDFaa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/14 =E4=B8=8B=E5=8D=887:08, waxhead wrote:
> In case BTRFS fails to WRITE to a disk. What happens?

Normally it should return error when we flush disk.
And in that case, error will leads to transaction abort and the fs goes
RO to prevent further corruption.

> Does the bad area get mapped out somehow?

No.

> Does it try again until it
> succeed or until it "times out" or reach a threshold counter?

Unless it's done by block layer, btrfs doesn't try that.

> Does it eventually try to write to a different disk (in case of using
> the raid1/10 profile?)

No. That's not what RAID is designed to do.

It's only allowed to have any flush error if using "degraded" mount
option and the error is under tolerance.

Thanks,
Qu


--tZziZzNt5BtexTGpNjDa15lvutVdXDFaa--

--cJ6AjUgTOiPJ63ZrrsRGo580qO0VkoVFx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvDKQEACgkQwj2R86El
/qjJaggApUDK+57bQA6NQQ/xMAnNIibRhGBn0f2k3WyCljC0qLMZ0CNtmu1CCG8I
xf8IE1LJLVc/fMFAzGDxFrnZkhk0RaCbGba6yymiuHcI8L+nJIRwabiUxm3xO6wB
7+FiR7qaT0LiSjMwrTzewm+wIkUJX9xL/dn00oXyzp+05a/y74tJIkmtvCCTtoq5
7pjy3XijVXOKwtorY3JmhAbOCwUbzGtR0JVr1mfNLn+9XQN6tCQkxlraM/iuYHk+
7j5xie8qZwpdikmMXXl8jjnx2HQjx/zbwwvnGgf9JKW+m4o5WPqUpMPQ7VyaTHp0
jG7iHCE9aS4E/TcVGvXJK90cnltEjw==
=AFKZ
-----END PGP SIGNATURE-----

--cJ6AjUgTOiPJ63ZrrsRGo580qO0VkoVFx--
