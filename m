Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F33EC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEA120856
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 14:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfAQOyP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 09:54:15 -0500
Received: from mout.gmx.net ([212.227.15.18]:36947 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfAQOyO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 09:54:14 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MGSgq-1gxMTR3zcW-00DJqE; Thu, 17
 Jan 2019 15:54:11 +0100
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>,
        linux-btrfs@vger.kernel.org
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
 <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
 <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
 <6c33c8a0-2dd0-c43f-3ddc-5f24ed609a43@gmx.com>
 <28c98f6d-9fa6-8463-99bc-a42aecc15bfe@ch-sc.de>
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
Message-ID: <54befcbc-4590-e377-f26d-99f170a5c6b2@gmx.com>
Date:   Thu, 17 Jan 2019 22:54:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <28c98f6d-9fa6-8463-99bc-a42aecc15bfe@ch-sc.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9przBR9Hr8eRG1vlxMvRsLRGPm4bhjQPG"
X-Provags-ID: V03:K1:isj6aSCRMVmBv7e1sGMmbqpKnmixnGV27RYtnsu00d+wqELkCpX
 8HaVSuGmS63aZReCFBcuJovrTorYaxgHIIXiT8nCtIn8twYdW5U+FsumgGnnCtGXmVS6BjU
 fnGd7JSzRIrBTxWUD6XVj0hHNqdhTPL/gyd86K2hkyGEAcdeqrBcJoeiqQ3sW5rkiwTJoaY
 aaglQvCCiqV03LJUutlTg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:342ODBZr+Qo=:Mvu+Lvp5KeKk/KC1Xioz0A
 I1mnm1INt9Um2AUyShnUslV8VEi3dJOiVjL6gs2rzjNmyXuNmCJ1Bd1bCH0LOjxEX6gLkgm3s
 NnTJsgAU6OoGBxJT+G/I2e1yRruEgr6+M0qyC5B9t4kRgF8r/abDhDhJrWUHyNFwlUOFN5bsS
 btoaEKXTafBVQbUDRFdQ8taJkMI+DztsGbwR1F2WMdkxzU8RPKDFd37c4A4nJ5PSCDB7xPIOB
 UAJodFHEzds+aa3iCnXRWPbd39w5NRclSnz3m2Xmz07qwtNTL2QPsl78w02fvYArExkYCDEMp
 aQxNWIj6RbH7zZ0mdhNHKvXbcHnLu+IICqLKfQS5rkkmmcmlpf52ZZFg3SUV29wy8ljmCIUbK
 wA5g5tLkmYKP36vtaV7uLdgM77YAd2+0RjJb39fO2gEqNxb+2oucch9k483s++eSPujmNt99w
 VK2JItCzUxdr+7rzq9O7OVVH0uRke4FF2ov9dhg4LY0djJmaP1DfUf4NikCe1tY6RB9Q60czL
 kFAysvp9ja00ShqMNAsAXTaByONVQUd3rpoGDblQAdIJVI1eUquibTKUiOeqdpLKMz0QqZ7u6
 NIiOLMkRaJr2zRjH2f5306/utcNqsk/C4/vtvZxhIrTdCy3rVOMPQP88gWRrcFpO84I0Zzduj
 OTvjVAL7gdN7cvZGuMoZZBPVZ7wQSB/J0fQ0Mvcu1bCdj39GRLVJWTnT0CNNvUGE73cF5R2Nu
 ebnWfOiD9Mro7/LQwk6WjBATGBNv3mVBdyypCFX6TmFd11c5IFxO5qEywY4CcBg6uiO+sVutY
 H0M+igQEM1pZ+FVI+pQEMzHcJ9mgAya70KJfx4QP6arl76U6Z/zUqZNQ0mkdCM/UvVnqe1+m7
 nPEs0/SJoZcYJOkpuBF+VqZUaGTBxf7y6KsM5PaSDttIkRe9+Mut46GM0g8FeY
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9przBR9Hr8eRG1vlxMvRsLRGPm4bhjQPG
Content-Type: multipart/mixed; boundary="mF8Rj7PlLKvZJNUxzhxfzCazzd9owRSwb";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Christian Schneider <christian@ch-sc.de>, linux-btrfs@vger.kernel.org
Message-ID: <54befcbc-4590-e377-f26d-99f170a5c6b2@gmx.com>
Subject: Re: issue mounting volume
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <06650972-ba8c-0b5a-f1ee-09656e0bf649@gmx.com>
 <3e1fd623-651e-9f48-0a79-2d1194b3d42d@ch-sc.de>
 <bd849a01-708d-2d4a-2f50-50b6967edf6c@gmx.com>
 <2c7c5f67-94f7-c9c7-4d9f-a76ef5dc81d0@ch-sc.de>
 <6c33c8a0-2dd0-c43f-3ddc-5f24ed609a43@gmx.com>
 <28c98f6d-9fa6-8463-99bc-a42aecc15bfe@ch-sc.de>
In-Reply-To: <28c98f6d-9fa6-8463-99bc-a42aecc15bfe@ch-sc.de>

--mF8Rj7PlLKvZJNUxzhxfzCazzd9owRSwb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/17 =E4=B8=8B=E5=8D=8810:38, Christian Schneider wrote:
> May I ask for a little technical details, about what happened/was wrong=
?

(This may be pretty similar to what I explained before)

parent transid verify failed on 448888832 wanted 68773 found 68768
parent transid verify failed on 448888832 wanted 68773 found 68771

These two lines are the root cause.

Your tree block at 448888832 doesn't has the transid its parent expects.

Normally this means either
a) One tree block overwrites an existing tree block
   This means btrfs metadata CoW is screwed up completely.
   Possible causes are bad free space cache/tree or corrupted extent
   tree.
   (Thus metadata backup profile like DUP/RAID1/RAID10/RAID5/6 provides
    no help at all)

b) The tree block at 448888832 is heavily damaged
   Normally this means the generation should be some garbage, but not
   for your case.

So a) should be your case.

But unlike normal a) case, your two metadata copies points to 2
different tree blocks, as the generation is completely different.

So this looks like there is a power loss happened after one metadata
copy written.

And since the powerloss happened, one of the 3 generations should be the
problem.

My guess is, the last transaction 68773 who is writting the parent of
448888832 is causing the problem.
But that doesn't explain everything, especially why one copy differs
from the other.

So I'm saying your fs may be totally corrupted, but as long as no power
loss happen, the seed of destruction doesn't grow.

But when power loss happens, the already screwed-up extent tree/space
cache/space tree could destroy the full fs, as btrfs is way too
dependent on metadata CoW to protect itself, and if the basis of
metadata CoW is screwed up, nothing you can do but salvaging your data.

Thanks,
Qu

> I don't know really anything about internal btrfs stuff, but would like=

> to gain a little insight. Also, if there is a explanation online, where=

> you can point me to would be nice.
> BR, CHristian
>=20
> Am 17.01.19 um 15:12 schrieb Qu Wenruo:
>>
>>
>> On 2019/1/17 =E4=B8=8B=E5=8D=889:54, Christian Schneider wrote:
>>>>>
>>>>> Do you know, which kernel is needed as base for the patch? Can I ap=
ply
>>>>> it to 4.19 or do I need more recent? If you don't know, I can just =
try
>>>>> it out.
>>>>
>>>> My base is v5.0-rc1.
>>>>
>>>> Although I think there shouldn't be too many conflicts for older
>>>> kernels.
>>>>
>>> I could apply the patch on 4.19, but compilation failed. So I went
>>> straight to master, where it worked, and I could even mount the fs no=
w.
>>>
>>> Your patch also has a positive impact on free space:
>>>
>>> =C2=A0=C2=A0df -h /home
>>> Filesystem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=A0 Used Avail Use% M=
ounted on
>>> /dev/md42=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7.3T=C2=A0 1.9T=C2=A0 1=
=2E8P=C2=A0=C2=A0 1% /home
>>>
>>> 1.8PB available space should be enough for the next few years :D
>>>
>>> Thank you very much so far!!!
>>>
>>> So, for further steps: As far as I understood, no possibility to repa=
ir
>>> the fs?
>>
>> Unfortunately, no possibility.
>>
>> The corruption of extent tree is pretty nasty.
>> Your metadata CoW is completely broken.
>> It really doesn't make much sense to repair, and I don't really believ=
e
>> the repaired result could be any good.
>>
>>> I just get the data I can and create it new?
>>
>> Yep.
>>
>> And just a general tip, for any unexpected power loss, do a btrfs chec=
k
>> --readonly before doing RW mount.
>>
>> It would help us to detect and locate possible cause of any corruption=

>> before it cause more damage.
>>
>> Thanks,
>> Qu
>>
>>>
>>> BR, CHristian
>>


--mF8Rj7PlLKvZJNUxzhxfzCazzd9owRSwb--

--9przBR9Hr8eRG1vlxMvRsLRGPm4bhjQPG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxAlwwACgkQwj2R86El
/qitCgf+L0k19JeMGznfQWnZBlilrNLdvOIVRx3du1WNUCvW+23FRb51sFUxuj7L
GxP3Y56jxdbrDbsEzDITaF8tpLdx06UUOSBNJUysNFIv8QLJUqieCsqUC/PpIwSk
EYr9BZIEb+g7GPQY/BOMXPBRkVUzhh8Ox4VWo7DorbCw5h5B7DoyCrgDlgLJ99zz
1UCzojTOtoc0oZmOMIEOXhdG4qo/pdo7165BXhRhKb0O+VG8lX9fmhyGdu6ocSDl
4fCjAeq3l7dgb2kyuQoTQ5seoe01Wq1Bn8UfDE7YF3vVeqaezy7faLRjqcFjDPAx
TBxXepAXj0O8iG52R6KiMuAIFWj8xA==
=zzBq
-----END PGP SIGNATURE-----

--9przBR9Hr8eRG1vlxMvRsLRGPm4bhjQPG--
