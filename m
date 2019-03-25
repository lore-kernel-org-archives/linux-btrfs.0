Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5900C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9878620828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:33:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="XdlJAlp8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfCYEc7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 00:32:59 -0400
Received: from mout.gmx.net ([212.227.15.15]:51473 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfCYEc6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 00:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553488369;
        bh=7tPa/sHuOlXJ15MSMYSJ3t88+MNMul0MtjJ6VkCru7s=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=XdlJAlp8/ow51nwpYnSfTvBV6n7iKS6plVx/+YM24ekNymP5rO8vP4od6+dj/VMbM
         lXEEwpJmJBhwam5Cz9Nua+xgJdU28U/NDlz61F/iwZrdhoLrgkIi1NeLJHDkuDEegf
         NkfAy7B7Wraqh5BEL9F6ml4BtyHdiVsbRvLYtRcE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M6Ana-1gkfpS1gLa-00yACi; Mon, 25
 Mar 2019 05:32:49 +0100
Subject: Re: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190321143406.GF26179@twin.jikos.cz>
 <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
 <20190322175233.GA10640@twin.jikos.cz>
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
Message-ID: <b263e5b1-abb0-b158-8236-48163ea0f8ca@gmx.com>
Date:   Mon, 25 Mar 2019 12:32:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190322175233.GA10640@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OaUWRgKloQchCHkgAJXJQXO30RXyQ9pfC"
X-Provags-ID: V03:K1:gtSyEJ7fDT20aB0ZTQG+IUtafe4mE2lRluF8LFZ8TQdOzSqdQ4z
 0PG1X3ssTx0T/qq4Zk3X/4XuB29bf81ZZYmTPrHUn++LFT+n8y8ox1GHg/hz09a7RZxzMYz
 RbAA0oFOl10XCKNT8omB5fIyzNwYFMLKacpn2XW8ae1EN1lVTi9ZgnMcU+/R3TBvG84WUG2
 NNv+zIpXkpY/qCItKxAWg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bgzcjhCI95Y=:vRDu2/5m8JrmRFuEh9QrkA
 HrF2T+jZtpUM78u4wws2vEMIryfTODR3VrRtEJI4+BPCl6AHyPumOSe/Ce/Xi1VpI7XlWdbAQ
 HqtuJ25C5gn5xYF2WXCX2VIz9TlPOwnHSnnSg/SNO7VWseN/EdumFQECaz8Lm4utDyp0faeeD
 w0/yBJwn2S6KjB6UPI8jU11P3/V37APzHw5ZYPGaM6aQutkPawMXmt1kihxWPmIrL+D2mPKez
 UEKY9Ibyw4rlBBi4EqnGvsx7JzMwlcb5k5cCjdVW7DcKkcfr1/v7B+vQifikVX0/xVD0tYRS3
 LZ7CtE5+J4b5hskW/2Y3KkCA2gSsX7ng1NjuUE/RJH7o50rm1Plfxp7v9kGVqCzOhF9ohBYnL
 ngirqVpd0jxkwBtk2SZSxxj8NGhrTEoISUsnC9AVyJKwOi0wQY5G0fAARm3ehsCetr+6ITb38
 pQPZE05WJHlyP0F+0bho1LdnQsfT8LK3jaMIgKt6U/QcEU/r5ZXgEqyGFgXOHD5zNCIMB0tnV
 g+R11FM043gl0nfqw3D5/vMGAmM0Jr3iAhtdsl6AAxeoHkJlxhhIT+tQ2sazx4/ADf3Ilxula
 tgOwOZ9VbyU+r4tEr2YTRvFk12tEcgZogpIjmRtQrVvPdOjyjPqWYGACShPMTVZLP8rmPH1xw
 qRjIIET3A4XX7ECu6yQZRG08MybbqV1suYZjHU0XTPRIJiTgNaYRQvDnsHho0pCYuasYVEXvO
 lU9H7LJvGE44MfIdgUEnRoHcGGfiFbsasMU5iP1ZiF8E3AtrK0kFb7A/1oWdpQxrz3kNQUdmB
 CSvMqOfL7sT451odFBDanJdWwxT6oleCEcvhiXA9ugGzV2m3iLEbENDObuACxejXn4PiBXhsg
 G2wvecyidA19s1pwtKLs7kbXwFiF9i+CxSdeLhh0gsh9UGK7neex7g/33mhS/Y
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OaUWRgKloQchCHkgAJXJQXO30RXyQ9pfC
Content-Type: multipart/mixed; boundary="ggJBVdcY7VFDZEXNHfD5chZI1znqoNN0I";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <b263e5b1-abb0-b158-8236-48163ea0f8ca@gmx.com>
Subject: Re: [PATCH v5.3 00/11] btrfs: tree-checker: Write time tree checker
References: <20190320062749.30953-1-wqu@suse.com>
 <20190321143406.GF26179@twin.jikos.cz>
 <ec2d0bb8-49bf-a7ec-3bc5-7c0f80adf018@gmx.com>
 <20190322175233.GA10640@twin.jikos.cz>
In-Reply-To: <20190322175233.GA10640@twin.jikos.cz>

--ggJBVdcY7VFDZEXNHfD5chZI1znqoNN0I
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/23 =E4=B8=8A=E5=8D=881:52, David Sterba wrote:
> On Fri, Mar 22, 2019 at 07:56:37AM +0800, Qu Wenruo wrote:
>>>>   btrfs: Do mandatory tree block check before submitting bio
>>>
>>> All except 9 and 11 are going to misc-next after a final test. The tw=
o
>>> patches are only postponed, one for review and the other one due to
>>> conflict with another patch in misc-next.
>>
>> Do I need to resend the last patch to solve the conflict by myself?
>=20
> Please check that I've resoved the conflict correctly, the updated patc=
h
> is not top commit in misc-next. Thanks.

Thank you for the work.

I find nothing wrong, so it should be OK.

Thanks,
Qu


--ggJBVdcY7VFDZEXNHfD5chZI1znqoNN0I--

--OaUWRgKloQchCHkgAJXJQXO30RXyQ9pfC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyYWesACgkQwj2R86El
/qghiggAg5NR3h8SHf+CmRyDZ5LX2F1LoRk1aKCDSrTdEws4S9c+/fNKBIrMRvmM
bmZ7picdYmbiuSVsbTZGlTqnt1qR3576VQUzD6Ov6kF+zwj7YY1cSndSVsm6HgdT
dGrWtFnnS7W/B++cV0wt6ABLu2IjaAfrmEF4eIw3i9JI+41xE5l++ruhLI33i4er
G5ytR2M9ZFiEdEW9I9o7pTyoI3CNP+Crrlx7qpCeVqwGtFxMF9Rhf6wd9TDBKxIM
wou+/oVOBNfNaNN/BLoFZrWR8sB8V2hjhW+785LjP0zKjxSrUFjcbjhDTZBNKlVb
fGPF+sqFf/LbWZeCUZ/QCZVrbZmW0w==
=LQ9A
-----END PGP SIGNATURE-----

--OaUWRgKloQchCHkgAJXJQXO30RXyQ9pfC--
