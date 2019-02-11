Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55287C282C2
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 01:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24F982146F
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 01:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbfBKBhB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:37:01 -0500
Received: from mout.gmx.net ([212.227.17.20]:58949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfBKBhB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 20:37:01 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M3NEK-1hAOr31vOK-00r3xi; Mon, 11
 Feb 2019 02:36:58 +0100
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     Chris Murphy <lists@colorremedies.com>,
        =?UTF-8?Q?Jakob_Sch=c3=b6ttl?= <jschoett@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
 <CAJCQCtSY8JR4G5JKLaKn-uT=CV+SMDom0j3Nt98wEOE9k=F-uQ@mail.gmail.com>
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
Message-ID: <4b89cb69-34da-9e98-d288-141a0a9900af@gmx.com>
Date:   Mon, 11 Feb 2019 09:36:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSY8JR4G5JKLaKn-uT=CV+SMDom0j3Nt98wEOE9k=F-uQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HOrJml8rjbBwA50TB0PjOJnoSmgfGg1ka"
X-Provags-ID: V03:K1:40aeL7vluivrtUmVaXbzNiXd9EleTnnKfFby0tj2iIVDETeo7H/
 1F+lBGoAmv4XAbRkfbLsQ2IuV1OG0u+rcdi9JeaDjCQoM32Q50GYrU6ioN0DmDfP16qK+Af
 ziDLAqD6i+R1+d4vkzMmnO8ILXa67/aJo4YpbbFHeFwYZxO5TZlbsR01o+qj1sF6GBipRoB
 uvndX+z9j3N8QNZWG+C4g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SE9ly6wpkR0=:j7wnuDAtckHm/okd2QFicM
 h11fp9CRQzGBsNSx+y+R4WaiQQpxcVZgHXO6+qIFTwp6pRZXDWJjYRyM+jgjC2Un5G7M3BjNK
 8Hgz0t55CjCuaoG3zMxpiWPlxOPr7qXWDZa6UC1uQXYFsTLF+cKvPaxcY8eS95Yqqe3UchWwa
 k0L9pCbZe9uyD+wZhETQ0Oxj1cfn8Ehvo6GC7YXQQbHRBxDsMxJiKw6JD4VNWRdZBu8AbL7Dc
 OSS1KBQti04YxAE9sQRi2RDfEG9m1i1+GbF5p6Z3LUvzN0HArcHhiqYFyDLWY1bDsvw20cjGu
 oYC0wJu1m4EluM35yfqcuBCbtH3UtquGQcb0aqcXL5FeiFkYjYvrEN/60WeKRf4lHIJ8zBQXZ
 ppCnsdUlt8b7uSiYXc2e3EeduWgn6g7RNlVpByYkEkNYb33eHXIHZWJjd7kHGKiUgEAPvmowB
 cY3V0omFTYO6GD1zI/er6VqRXhQLyXLR2AJsvzfYaqXlgL10B6H8fPw8Kpejre6+SQVfoOyjo
 vFAgeIb4LKHjlCDB+Maf+1+/gpyRUtkj+v9eAxSF4mWh/gwya8acwYIdW4kDW2Xh4dTe0ZNZD
 obiB02tqvn777FdIyM1FGeBuQl+gbXl0hqantaJ6oKXHhjUdkslfoA5SOrDcts2ejyUuS2mLJ
 W47XDvcOz1R32vpMLjDI1s8hiE+LihzdNZm6xRT6CrcjcgbhR6+W8caY0eINOou8IhqH1pdj0
 tbIzv/kxtQTeoHohVvwGpQpgC7HU+4REjwet3Nk5f+mTXRNsQIM2zhwrNUWzbOP9a4qld9lxW
 kQh02tHA/IbJeJgplx26WP1yz5UuL3KBbozE4oN25f0L5YNQ1o57PaWICb5xY6sM8lyQS/yh2
 AdWrpGEGtf6ZgmTSlRikN0tNyEnsvQA9X1IBAUXNxAL89qnaZ9ftwDdrjftZR6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HOrJml8rjbBwA50TB0PjOJnoSmgfGg1ka
Content-Type: multipart/mixed; boundary="B0G0fhSNzhz9OcM0IXrgcF78cWGb9ON1r";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Chris Murphy <lists@colorremedies.com>, =?UTF-8?Q?Jakob_Sch=c3=b6ttl?=
 <jschoett@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4b89cb69-34da-9e98-d288-141a0a9900af@gmx.com>
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
 <CAJCQCtSY8JR4G5JKLaKn-uT=CV+SMDom0j3Nt98wEOE9k=F-uQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSY8JR4G5JKLaKn-uT=CV+SMDom0j3Nt98wEOE9k=F-uQ@mail.gmail.com>

--B0G0fhSNzhz9OcM0IXrgcF78cWGb9ON1r
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/11 =E4=B8=8A=E5=8D=882:44, Chris Murphy wrote:
> On Sat, Feb 9, 2019 at 3:36 AM Jakob Sch=C3=B6ttl <jschoett@gmail.com> =
wrote:
>>
>> Replace device 2 with device 3:
>>
>>    mount -o degraded /dev/loop1 /mnt
>>    btrfs filesystem show   # to get devid of device 2
>>    btrfs replace start -Br 2 /dev/loop3 /mnt
>>    btrfs replace status /mnt   # check success
>>    umount /mnt
>=20
> The first command causes the creation of metadata and system chunk
> using single profile, on loop1, and even after a replace, both devices
> know that there is a single and required chunk on loop1. So subsequent
> degraded mount fails because the volume was not fully redundant.
>=20
> The missing step is between 'btrfs replaced start' completing, and
> umount. There needed to be at least a 'btrfs fi us' to check if there
> are any single chunks and to convert them with 'btrfs balance start
> -dconvert=3Draid1,soft -mconvert=3Draid1,soft' where soft is only possi=
ble
> if there were no data writes while degraded; if there were degraded
> writes, a scrub is also necessary to make sure any single mirror raid1
> chunk writes to the degraded device are replicated to the replacement.
>=20
> Yep - kinda ugly. And not intuitive. But that's the present status.

Not exactly.

Currently the problem is, there is extra DUP sys/meta/data chunks created=
=2E
So despite the SINGLE chunks, we still can't mount it degraded.

IIRC there is some patch trying to address the SINGLE problem, but the
DUP one seems to be something new.

Thanks,
Qu

>=20
>=20


--B0G0fhSNzhz9OcM0IXrgcF78cWGb9ON1r--

--HOrJml8rjbBwA50TB0PjOJnoSmgfGg1ka
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxg0bUACgkQwj2R86El
/qgB4Qf+OkrGsDzBGiQvYmpWzoj9d1xnAWAuLJ8adwJbALkDbjITHw7KFz2AXQl4
IkQ1OmZRRn0o5eJIBdE3tvvY3SriDMbmSNsov7gHoucvWAu+Fyww8x/eQwvn4ZVJ
iz4svBlGa4Kg3BPh9/KT1CWNL1QqUVKRgreX3k87HexgVVBYhwFMwFCPjf/OAta8
AxCIDI59vKprhZH8lMw5JWy99vzsxUtyfNZQU3UXBZakMZFTVgSALySadZFSwHrO
YNEB7dliygnkhV0zITIuNkwxY4b7qCVPcE5eI1gpsLr98NmLAt+Y63lZjt/KfCKM
jgryB7Tbs/+4l6a7TVwNsbjMoRR9yQ==
=M2fS
-----END PGP SIGNATURE-----

--HOrJml8rjbBwA50TB0PjOJnoSmgfGg1ka--
