Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A6CC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49D9205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfAQOin (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:38:43 -0500
Received: from mout.gmx.net ([212.227.15.15]:33515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfAQOin (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:38:43 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LqRKT-1hNrHk0aCP-00e3n1; Thu, 17
 Jan 2019 15:38:34 +0100
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
 <20190117143021.GR2900@twin.jikos.cz>
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
Message-ID: <3ce5bb05-5005-62f7-5174-4c7f3ebd7f8c@gmx.com>
Date:   Thu, 17 Jan 2019 22:38:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190117143021.GR2900@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Q9JglhzwVTEYBRoUo0Q9twzU0rM1KZQb4"
X-Provags-ID: V03:K1:tyU92UckPQY4LE8mQiSWtrUEAnv1SEV5cIipCMHBMMSrgiNJPmi
 xOQ+28mDPUh7wbGLFHQ8CT6k/K7GI7CYw0i7eV8Lge5aA7pukf3qQGmHQh3qfSi8B3AeC05
 uTMoA3RaUKAJiST9VUmqXBJPUe+TJKsU82g3oQrYIXyPysZ3pBOKhojbNB0C0u0F9I7ppjX
 0SGuU0WQ7U+eh6+gX4sLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sWNVrOVzvg8=:rMR+jK59RSiGxuyODtwtIO
 ofkCWsPb7FNfgTnzvkMPKiMfHGGlV4fRYrQPthPY8+HWOUJqHMT/07Xlir8aQD3mk7OGBJC7j
 URqI0kTQdfOSpdUefqebVA7Vd53qkAcBdGg2TcqDZtirJHBo4SaFcoOYecKKU5m1XVEUjLqoY
 a463Jcizo3d4ec36TKrD+EoZn8AvqoHbyK6xjRGaTml7Xz4KaBCaKvhxuN3mjSOqwNxtWBw3y
 sw9B63tLLRoLsy+xER0pyFUGpcxhBpuNVd8SPHIUIAQKP/bXLHSdQPwVgSHblIcCMFbjZWqdH
 0ZmBzOcEgpEpWt/pKlEePEkaqS1079uHxA6jeJMCQcHqYWl+LzXzRXZjTVKerOh26B22WgKaM
 3X6AZrUuf+iGHsVMjw2p0EnwVelSLadTRi7+aWFLPOJH08FjgPaQE4Cnss5U1kqizukFNWK9D
 R+13lm752flFm8qxCK+llcCX/NILRx9bIV0sblY0mOeuPcLmbM6ucGTN/bmj+vpYRngrL55a7
 RJEQ6TZlrEkSnmKQSae02bXOv/WcPW63kx7dWt3AYVgaJ2vwhYD2iwf0XTs6/A++yPlukl01Y
 EcJf73+xIq98gKSOBQQ3lNsUZoH9t0G/QyHW1N94L99nhhBGOrFcHqG9NyXr4xe6/4qp14mrR
 dhwHzabZYWLZfVUpMgxdyxxLJ4K4tkMOF1HWPRYORw5wWS2ty9K2vmK9VMflUCsEb5F6GYnOK
 kYTeWB3vpbxSEgRsXziPca2g1MDOlAjSODzRK6HyYv5EYOUP0hGg//5HXx8UEYDsPwBKOtu1w
 JraGaUQBWVjlfbq4135At+qJ0qnAPMqeVrvH38hnRhExaQc9OqOqhqLPO2LQkzwagUkCNUBj+
 XjdFgTAjCf3l+9m2Ac1DUXCQ+ygWTIHiqqC4qiH8W8Oeq6Vc8dkPb/h6Lf73l6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Q9JglhzwVTEYBRoUo0Q9twzU0rM1KZQb4
Content-Type: multipart/mixed; boundary="W3shcZRP0FhhCvQdsTbHbNw156DdK5TEv";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
 linux-btrfs@vger.kernel.org, kernel-team@fb.com
Message-ID: <3ce5bb05-5005-62f7-5174-4c7f3ebd7f8c@gmx.com>
Subject: Re: [PATCH] btrfs: honor path->skip_locking in backref code
References: <20190116160057.22040-1-josef@toxicpanda.com>
 <ef892414-ea36-271b-35f5-b4f753ff7bea@gmx.com>
 <20190117143021.GR2900@twin.jikos.cz>
In-Reply-To: <20190117143021.GR2900@twin.jikos.cz>

--W3shcZRP0FhhCvQdsTbHbNw156DdK5TEv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/17 =E4=B8=8B=E5=8D=8810:30, David Sterba wrote:
> On Thu, Jan 17, 2019 at 09:04:13AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/1/17 =E4=B8=8A=E5=8D=8812:00, Josef Bacik wrote:
>>> qgroups will do the old roots lookup at delayed ref time, which could=
 be
>>> while walking down the extent root while running a delayed ref.  This=

>>> should be fine, except we specifically lock eb's in the backref walki=
ng
>>> code irrespective of path->skip_locking, which deadlocks the system.
>>> Fix up the backref code to honor path->skip_locking, nobody will be
>>> modifying the commit_root when we're searching so it's completely saf=
e
>>> to do.  Thanks,
>>>
>>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>>
>> Reviewed-by: Qu Wenruo <wqu@suse.com>
>=20
> What can we use from https://patchwork.kernel.org/patch/10725371/ to
> add to the changelog? Is the deadlock caused by fb235dc06fac?

The error and cause part should be the same.

Just Josef's is much better than my patch.

Only the [FIX] part needs some update.

Thanks
Qu

> The fix
> applies to stable 4.19+ directly and to 4.14 with context fixups.
> Thanks.
>=20


--W3shcZRP0FhhCvQdsTbHbNw156DdK5TEv--

--Q9JglhzwVTEYBRoUo0Q9twzU0rM1KZQb4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxAk2IACgkQwj2R86El
/qhycQf/UXVk0pQCuyD32yghhGE4MyAU4mPPN5y5HHutRm6u/T4sKiNVpqvAmhhy
NqW6wi+lGU3103ZVUYS8xsAmp3bwd1Iln22Ld3YFoRTKgDoONpcY4z6BfodyGJCg
Aj3vtgPGdw6b7z2/2TfEqWq3h+wqnHBQRPMpMnT8tnx5DbhsH9/LbFSzpN96SLS4
vM0SW/eQZ+Uacqfok3BOudArkuPgTYGCPSALhUba7kMiKh7dEf9Fk33tMMg7vmJv
8N33Zpuvd/d/yWCPnesph9AkyDorCjHiQxKn5hIlhJ91cEyiNbWHJdPojGGHgDTc
/HgMvH2++yE2z3gBuADLYkaZuq3gYQ==
=NfIS
-----END PGP SIGNATURE-----

--Q9JglhzwVTEYBRoUo0Q9twzU0rM1KZQb4--
