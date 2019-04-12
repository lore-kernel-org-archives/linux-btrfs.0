Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BD7C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DA572082E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:15:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="CxZmKnXY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfDLHPg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 03:15:36 -0400
Received: from mout.gmx.net ([212.227.17.20]:34799 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfDLHPg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 03:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555053330;
        bh=I3H3XMuw8eZhsQVoSwj/CN5fLxQfPhQY45ACVyTHveI=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=CxZmKnXYl0b8XPW4LJGixOROyQziniwiFatlkDxf8I44JraNP0qE0jRWrctteKcPL
         1vjb8HmNKwkjxARlZoi1nsGly+sW/8I+BdmIFViDhresjh/RRWMbDk+A2SdZUesbAm
         VRz04+27MNjexbG7NyiKh+uLo+KECLA9jqZDme9s=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0Lyj4F-1gm7z53u91-016ACU; Fri, 12
 Apr 2019 09:15:29 +0200
Subject: Re: [PATCH RFC] fstests: generic/077: fix populate fs use _fill_fs()
To:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <20190412052418.22206-1-anand.jain@oracle.com>
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
Message-ID: <91949b01-d016-f732-265b-77a397a1efbe@gmx.com>
Date:   Fri, 12 Apr 2019 15:15:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412052418.22206-1-anand.jain@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BpJ4qmCH949WG6u4zZER2hlWiemmZnWS0"
X-Provags-ID: V03:K1:IwzqWhFWmGnoq642Bv9HA/zt31uCGGw9ouFfIqdSUEf2bU7lZQR
 jchJrF+E4Au+SS2so0SngFTsNR/rniggQXV/Wb5z238KuPwgRkmGEYfwYPGopC3vGiq3U3M
 loJ7NM+aZ6He34GFFjKkRW4Xc/zq3+6jpOjie13oMHSvm/aG23pROviQnL3ohSl+wcUub3p
 sBgEYZSbVuPIw1xvmUKmw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7rx9ljMHE5U=:qfx0CInLa35bjFStoaLirB
 gU23V99ndgJPXRPRK0oEeVcAXaVmfrpXIZZXlFupKHpyVItlvY6FjKYHHgkNl2c2RKZmfC56y
 y9bblrBgdnemOmbL7d02uQIb6P8y6TSwikIUUHn21flEW1ecvucXDOYTasB3+XOibvNk/FdEI
 7YzOac3I44H0oWRKWzO6UML5XWiudHzYAr3tVu9VgBT9HybMG8dzvQhztnZY/Q8vLpY8jEO1B
 4PGFch4qXLy5hyyniStv7vL1GqAt3x6fnXe+2oJ1T8gfzQklEAs98Ube4MY3+Uk6jklLGXisV
 dKY9/ZDMcZsCPBGtFFl3I49NPlANrzATPHqq2qQoj2CUkN6q662KBf9rnC1bGBwirAHZntl+E
 COfrp2jGYUrfT/n/zms7fncWQvDpOVnFND9s8Q2m+IMzRNjxuAwzLDK5aomImYhSmOS8WYr10
 owicAzC1XqznVNQ6oQvX+PSB5n4KtfnIjSNXlh5BizwjbxGwzVEYT2z84E5Pzwyp6lh+EvFUi
 hUZpuInRWBrGr52DJo1qDDfoY3kCdfWWCzlMyGGDY2uxJUuUd2sP5Omw9DtDMcHWOrrXnZpfX
 ICUA37TsEUicH61cISqeJZSOAfQjScT/at6jdvWQmfnNEOahhkUNK/HxNwTVuYkex9zGvY+yv
 shns1D6J1lmK0gXoVlt/Ezzy55RWNgE2T5q+2THDwGPV8mjJCDd9wZhVyPsHP19FqZN002Ifi
 Yb0TnIGSUxDbwXVsblf0zC6vCL4ayttaz3A7pUbP8o7I2z/JzCtc3lsYRJuHk40v0Ulq7443y
 HJXY1h0TEn+bSi2+S6N0PTvCnsyKTWPr7cYUZMr+p35ejZcCkHT5gu8c7UJBZKQyPtWsB7GFb
 UnejKcZdbQ9f8wAH94HkxPUoar+5LbTJ0+tq3EKixvKWRbYpGPN7sggcZC3HQZ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BpJ4qmCH949WG6u4zZER2hlWiemmZnWS0
Content-Type: multipart/mixed; boundary="kAriEelbh5SPnFyGqyo8QgiETQDCDwJoR";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Message-ID: <91949b01-d016-f732-265b-77a397a1efbe@gmx.com>
Subject: Re: [PATCH RFC] fstests: generic/077: fix populate fs use _fill_fs()
References: <20190412052418.22206-1-anand.jain@oracle.com>
In-Reply-To: <20190412052418.22206-1-anand.jain@oracle.com>

--kAriEelbh5SPnFyGqyo8QgiETQDCDwJoR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/12 =E4=B8=8B=E5=8D=881:24, Anand Jain wrote:
> Test case generic/077 uses files under /lib or /usr to fill SCRATCH_MNT=
=2E
> If /usr or /lib is below 256mb then test fails to run, or if these dirs=

> are too large it takes a long time for the cp to finish. On my machine
> it takes 645sec.

Wait for a minute, ths fs is only 256M sized, if it takes you over 10
minutes, there must be something else wrong.

>=20
> This patch propose to use the common/populate function _fill_fs() to
> write files into the target directory instead. However I am not too
> sure about the motivation of this test case in the first place, and
> why does it wanted to cp /usr or /lib,

To my eyes, it's using /usr or /lib just for it's mostly full/contains a
lot of files for most systems.

> and why fs should become full?

Maybe to hit certain ENOSPC corner case for ACL/xattr, just my guess.

> Any idea? Thanks.

Use populate_fs is definitely the right move.

However I have some concern below.

[snip]
>  echo "*** set default ACL"
>  setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx $SCRATCH_MNT/subdir
> =20
> -echo "*** populate filesystem, pass #1" | tee -a $seqres.full
> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
> -
> -echo "*** populate filesystem, pass #2" | tee -a $seqres.full
> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
> +blksz=3D"$(_get_block_size $SCRATCH_MNT/subdir)"
> +echo "*** populate filesystem" | tee -a $seqres.full
> +echo "*** fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0" >> $seqres.fu=
ll
> +_fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0 >> $seqres.full 2>&1

Unlike the original behavior, which do 2 passes and the 2nd pass will
overwrite previous files.

While after your modification, it's no longer the case.

At least we should try to replay the 1st run to mimic the original behavi=
or.

Thanks,
Qu

> =20
>  _check_scratch_fs
> =20
> diff --git a/tests/generic/077.out b/tests/generic/077.out
> index eae7226ab29c..9c143c902a2c 100644
> --- a/tests/generic/077.out
> +++ b/tests/generic/077.out
> @@ -1,7 +1,6 @@
>  QA output created by 077
>  *** create filesystem
>  *** set default ACL
> -*** populate filesystem, pass #1
> -*** populate filesystem, pass #2
> +*** populate filesystem
>  *** all done
>  *** unmount
>=20


--kAriEelbh5SPnFyGqyo8QgiETQDCDwJoR--

--BpJ4qmCH949WG6u4zZER2hlWiemmZnWS0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlywOw0ACgkQwj2R86El
/qgGZQf8Cvq/9+VJjQ/tjXy5UzCyZiyFfvrtf3MnSxRUcSwj0EL/mFECBiwA0f9K
PPpfzYhdh1fXJbVEdIa58O8U2uupNSLWOVL/pBOhEXX04W5PtX+56nWSYFd2kJrt
os0H/ZLt+6pG/mMrIjlMnDmGwguXk3ynT1U5DQt0Xwwcv8ibJX4ljXfHPMkmoft/
b5k2LR+7xXg0WCOA3Mbu5c/uc7q1cmxQo/eDUXJzT3A/7+3sFXwHnQakB5PNf6K2
18/5F9MBDO65gUYh72/qtcGq/sgG6TEWTDCZSI9tPIdwcJKZsRxM6ip45IHnRGVh
4RVDt+d9E7y8EqsdawQ4Hy+X1OVufw==
=n/II
-----END PGP SIGNATURE-----

--BpJ4qmCH949WG6u4zZER2hlWiemmZnWS0--
