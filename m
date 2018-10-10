Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A361C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB9882086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 23:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB9882086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbeJKHII (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 03:08:08 -0400
Received: from mout.gmx.net ([212.227.17.22]:43727 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbeJKHIH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 03:08:07 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4o41-1flIjW1AVx-00z28v; Thu, 11
 Oct 2018 01:43:24 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M4o41-1flIjW1AVx-00z28v; Thu, 11
 Oct 2018 01:43:24 +0200
Subject: Re: Scrub aborts due to corrupt leaf
To:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>
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
Message-ID: <5f77e276-7fe7-aeb4-6927-5f2c9f1c52b0@gmx.com>
Date:   Thu, 11 Oct 2018 07:43:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l8nCxUbonC9lfvSpeAVdX3CzJf59mSpH5"
X-Provags-ID: V03:K1:SwN8uzjjldxsehwAU6PysgK9AOHXfpl9aSNNG9USicH019T+8DI
 LDgcT7vDmSgMMMNgVu08pq4a8kyI+2nWlJINqXIipzAm6h1O32eQgMt28zC5UuyDX84rZQC
 N/1tAI5r4Oh1V85ucD0AFpPO6eJ/8/4O36B9AhKnzFzOo8v8XkEuFx/rCvr+m2/yGxjJ5PJ
 XKdJF/B+Y0kN2ts/M+xoA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:15y0QTPNICY=:st5t9dwiFnwm1+eeU3CGQU
 8kTBCE9gVPbSKx03X4NGLjsuwT8Jm7rw9067xFYqdvtalaM86HKQJpbxtK/2r37CDmM2+RCxw
 f0jHeOM5rULtjcbHTwrcwJHpII5N/Hw76BEN6LwTKLI2lgg3cPcDwDH3f2bwz3ueV1Z1Mw3x4
 4BC7Xbq3HrwTJSl9PJsBjhrG4Aomv3ggNIlKDoTDV7bk69UMOLS0noPB2n3OCe5rJg+bLJ6zh
 NWMkImS7c7Ga9DoWFaqi8CmFLKtPEyo3cnBfM/o4lEMDG0F+HxtMZGwUmwCMVi7rmS9a+bWn6
 ht4d+rHUbeao9SdE1dX7bZV4DcnJcM1E+y62OF7/6s11UmQB5/scFErhqjdwAqj435l39xMzS
 gbWrwzLMcL1pkatbUQ+75IaC4oINUmvtgAxLqf71Z/up6YIkeeLBCsLs8MsEV1drOvZLCvZHw
 FvnpwFFdKZruRXCz18MKsdraSz3mJM8aSachhz+4Y1RT55qXcdUjT1wrQyRulNQpIIPwYVobD
 altUnZtuDvL/uOYz+Sbczf7PIXNoLNCiB5dzCXsMw3rUt6FgpAqJTJD/Ehd73SCk7larqkDEW
 lLKoyx0Yy8NJLn9JdDN6ffAgIQzvr7J3oYu10vqWtwK6C6BdV2tI2F2FNoeotEAqMroSJhzHi
 7u4KE0x6+TE80dE30Jq53K3/sfxQh/Qg4yI47nY8Bjw75DYZtg6GS8Ec2LLDoN9NX6VCr/W+g
 vRgFDDLer9Wa8/GJ3LErIvXY7gjGT1vyT8t+0M5FFiMGe9vEYznfziI3H2iLuNmeQ+eRtpSlv
 EUOf3wmutYFdHFZqyhKu3S03UXhxQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l8nCxUbonC9lfvSpeAVdX3CzJf59mSpH5
Content-Type: multipart/mixed; boundary="C8og6iq8VcpbEqOLe9bIH4bBpk4JmxVwe";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Larkin Lowrey <llowrey@nuclearwinter.com>,
 =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <5f77e276-7fe7-aeb4-6927-5f2c9f1c52b0@gmx.com>
Subject: Re: Scrub aborts due to corrupt leaf
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com>
 <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>
In-Reply-To: <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com>

--C8og6iq8VcpbEqOLe9bIH4bBpk4JmxVwe
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/11 =E4=B8=8A=E5=8D=881:25, Larkin Lowrey wrote:
> On 10/10/2018 12:04 PM, Holger Hoffst=C3=A4tte wrote:
>> On 10/10/18 17:44, Larkin Lowrey wrote:
>> (..)
>>> About once a week, or so, I'm running into the above situation where
>>> FS seems to deadlock. All IO to the FS blocks, there is no IO
>>> activity at all. I have to hard reboot the system to recover. There
>>> are no error indications except for the following which occurs well
>>> before the FS freezes up:
>>>
>>> BTRFS warning (device dm-3): block group 78691883286528 has wrong
>>> amount of free space
>>> BTRFS warning (device dm-3): failed to load free space cache for
>>> block group 78691883286528, rebuilding it now
>>>
>>> Do I have any options other the nuking the FS and starting over?
>>
>> Unmount cleanly & mount again with -o space_cache=3Dv2.
>=20
> It froze while unmounting. The attached zip is a stack dump captured vi=
a
> 'echo t > /proc/sysrq-trigger'. A second attempt after a hard reboot
> worked.

The trace shows it's indeed free space cache write back code causing the
problem.

It may be a deadlock caused by nested tree locks caused by extent
allocator and free space writeback code.

To avoid such problem, you could completely disable v1 free space cache
or goes to v2 cache.

Chris Murphy's guide should be pretty good.


Personally speaking, if your usage is not a performance critical case,
the following things can be disable and avoid possible bugs:

1) free space cache
   It only increase the speed to lookup free space.
2) tree log
   It only speed up fsync() causes. Without it we just falls back to
   sync()

So I'd recommend the following mount option:
nospace_cache,notreelog

Thanks,
Qu

>=20
> --Larkin


--C8og6iq8VcpbEqOLe9bIH4bBpk4JmxVwe--

--l8nCxUbonC9lfvSpeAVdX3CzJf59mSpH5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlu+jpcACgkQwj2R86El
/qjCsQf+JucsA1aLnznaY19SHDf3sXzSr8linLVNOb1adDRhP4JGdSPBNak+19HE
Rs80uQV6Q7yyly0clJ4N15EJ4b4EG1MYem/mU+yvjIn1YtoXLP6MXRaY5EehS2a3
+Ub1pGMY02LVZMRGqWwRPwg7/WmGFC3+ba3A9ugSAZfM/IYObzLLghTYyQKx4ZUe
609YNadhcExuv7zc0gXKE3kfSRXbd1CKQLq5vxWPWbEZAYCM3FCdeM+8V8bZxLT0
Hx5NDuWXlJkar37+q3fIeFiKiBNX+ljzoGM9vCyNYq4pp5slHWrArtqszcNf67C7
evkowthIxgNHqq85vVDkc+ie0KOaog==
=wCzF
-----END PGP SIGNATURE-----

--l8nCxUbonC9lfvSpeAVdX3CzJf59mSpH5--
