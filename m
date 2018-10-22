Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03668C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 06:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A090220779
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 06:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A090220779
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbeJVPK4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 11:10:56 -0400
Received: from mout.gmx.net ([212.227.17.21]:48551 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbeJVPK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 11:10:56 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LxxNo-1fZo7k1Rhc-015KdA; Mon, 22
 Oct 2018 08:53:41 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LxxNo-1fZo7k1Rhc-015KdA; Mon, 22
 Oct 2018 08:53:41 +0200
Subject: Re: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
To:     =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>,
        linux-btrfs@vger.kernel.org
References: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
 <CAHj_TLAHdUqPV_fbPD6G9FNsPhdg5=Hqt1simx256t-2mom4cA@mail.gmail.com>
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
Message-ID: <4e2ad497-8491-2250-f1ee-e5e5bb42364d@gmx.com>
Date:   Mon, 22 Oct 2018 14:53:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAHj_TLAHdUqPV_fbPD6G9FNsPhdg5=Hqt1simx256t-2mom4cA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zntsTuPuVdDM25ikzVHkC3XFFpByjvLAs"
X-Provags-ID: V03:K1:/bWUn2AUiDQwP/TMzAphXv/s1WSzpUGfzoR27bLg1LFM0MSDIPt
 6l48gqc6/PfkSiR2vYpc4sSvZnnrUXqf0suHHUmf/6Y8AHJ3f6lWrvjfZy6nP3ERdu4NTiv
 3v8OEmYYZR48bCofJXpOuaieoPUEido1Hsslh2u/KKZR4j5RbbzatN0AvYTv4QkidLnfzga
 cKfzO1eMy//7PF+scTPxg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:94akGMBXWMc=:VIP/IchSO6BRRS9jZ7QsSt
 EJFV73VYUAZXJYHEd+7y4VSers5cmUStYn+mhsMQQjIRPr0pm+tOawcqqgiqggZwmnK/+daG6
 laX7rR/FafRB/bPBg7GkEu6PR0XZkNUye7vil04j9U2SlawB20YUWl+ZNhewpEa7SZd0Er2F7
 lnyhcSKRNYFRzLtctfpKFiYMan/4PWKLbYdBfYmrmLV2KWFR2+2YW8nRQzMTv2fUrMPZIWepT
 344/eSs1a5SIwsg7vGwH+BZRLtDCdFpuuz5Bcy4nDCyBFxTZgnDcs/9IBeH2JrjY363Yns+xd
 O++Rxw+8klFNnra++Q3DlZzXJOJosM7pnO0B9G0sE7sVuQ24V98+mUxzMM9uHmBvLYfW+VHlE
 hI/w5S+oUFMXaqWc7y3VXDuJqDpyEvYVLtdL114vSQF+OCf9fhr+I4mtjCZVEyzaxee5c6VTE
 0WXSR48ONMAfvQTVx2ymvzL9Ajc8VBDRgG+kPBSHA8Mz7vXw3S1acmr9sECJIE2b1e8sk34jt
 SWXfClsgFavyTMZ/C2sMqWws5/85OzOpRWDw8bIjJxO/5k2tRoobWDHy//YclTd2dtySNbu8/
 q01zj9EclagSzeMBmGA5XzL58wOXTv0BrBk1dLkb8ck/cAjeuRpD/jOvZikNjtOV/am83/U9B
 mr6vi0cq+rnD03zw+Cr5zb0GTVHGF5iocnIjSPVDw5s8B3p2h6ly4VrRf/6nCR1sjYqSIbf4p
 rHzfbZ4nDOFK2OLzU5Rko/Y6iqg2HX5c+wZLyIRaQdJc7Xka4jGFCNBPFVHAuvpgnF4IW2f8j
 BwUzDSbxnRSRltu9NUnKq22bAXRUA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zntsTuPuVdDM25ikzVHkC3XFFpByjvLAs
Content-Type: multipart/mixed; boundary="Iq5OG3E41js7UXbdumTKlmssLmBni5enG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>,
 linux-btrfs@vger.kernel.org
Message-ID: <4e2ad497-8491-2250-f1ee-e5e5bb42364d@gmx.com>
Subject: Re: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
References: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
 <CAHj_TLAHdUqPV_fbPD6G9FNsPhdg5=Hqt1simx256t-2mom4cA@mail.gmail.com>
In-Reply-To: <CAHj_TLAHdUqPV_fbPD6G9FNsPhdg5=Hqt1simx256t-2mom4cA@mail.gmail.com>

--Iq5OG3E41js7UXbdumTKlmssLmBni5enG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/10/22 =E4=B8=8B=E5=8D=882:29, Otto Kek=C3=A4l=C3=A4inen wrote:
> I never got a reply to this thread,=20

I replied to you but got no rely:

https://lore.kernel.org/linux-btrfs/eba5de6f-535a-0f5d-e415-9cd622d71b36@=
gmx.com/

And your steps are just what I suggested.

Thanks,
Qu

> but I am not replying to myself in
> case somebody has the same issue and is reading the archive:
>=20
> The problem went away after:
> - deleted all snapshots as they seemed to slow down btrfs I/O so much
> that simple commands like rm and rsync were unusable
> - replaced the disk that had the corrupted file (just in case -
> smartctl did not indicate any disk failures) with btrfs replace
> - rsynced files from another location to this filesystem so that the
> corrupted files got overwritten
>=20
> Now btrfs scrub does not find any corruption anymore and the
> filesystem I/O speed is usable, though still slower than what it used
> to be in the past.
>=20
> ma 15. lokak. 2018 klo 10.50 Otto Kek=C3=A4l=C3=A4inen (otto@seravo.fi)=
 kirjoitti:
>>
>> Hello!
>>
>> I am trying to figure out how to recover from errors detected by btrfs=
 scrub.
>>
>> Scrub status reports:
>>
>> scrub status for 4f4479d5-648a-45b9-bcbf-978c766aeb41
>>         scrub started at Mon Oct 15 10:02:28 2018, running for 00:35:3=
9
>>         total bytes scrubbed: 791.15GiB with 18 errors
>>         error details: csum=3D18
>>         corrected errors: 0, uncorrectable errors: 18, unverified erro=
rs: 0
>>
>> Kernel log contains lines like
>>
>>   BTRFS warning (device dm-8): checksum error at logical 7351706472448=
 on dev
>>   /dev/mapper/disk6tb, sector 61412648, root 12725, inode 152358265,
>> offset 483328:
>>   path resolving failed with ret=3D-2
>>
>> I've tried so far:
>> - deleting the files (when path is visible)
>> - overwriting the files with new data
>> - changed disk (with btrfs replace)
>>
>> The checksum errors however persist.
>> How do I get rid of them?
>>
>>
>> The files are logs and other non-vital information. I am fine by
>> deleting the corrupted files. It is OK to recover so that I loose a
>> few gigabytes of data, but not the entire filesystem.
>>
>> Setup is a multi-disk btrfs filesystem, data single, metadata RAID-1
>> Mounted with:
>>
>> /dev/mapper/wdc3td on /data type btrfs
>> (rw,noatime,compress=3Dlzo,space_cache,subvolid=3D5,subvol=3D/)
>>
>> I've read lots of online sources on the topic but none of these help
>> me on how to recover from the current state:
>>
>> https://btrfs.wiki.kernel.org/index.php/Btrfsck
>> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-=
Scrub-and-Btrfs-Filesystem-Repair.html
>> https://wiki.archlinux.org/index.php/Identify_damaged_files#Find_damag=
ed_files
>=20
>=20
>=20


--Iq5OG3E41js7UXbdumTKlmssLmBni5enG--

--zntsTuPuVdDM25ikzVHkC3XFFpByjvLAs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlvNc/EACgkQwj2R86El
/qijDggAo45d6v/wZ8uDu7gWPrP2xq25Cf8YJlROlXUziVYI4+8UYEp4uNGPwEmn
VyeMNR7Zz2RDixlRxHNzedi7wKegmonz4tvYRC0OT4f3eO4tRXuKL9h+UMgbxz4E
UJRYFWLzPwXIfGyJSYqwrr3GGJwQkq0xU1hJ+lWRon3GximyfvwH6QO75uh2a/hf
8ib5wdberK95xaaZYLIVA3eJTXRq7n17bSxaIG2ykx70QtBB2N7ZhNUjYjNvOE1q
gzcM3pxAL1zr/nINSZ6Gxwvu5VpdR3IXwHM/mGKM+CLQ7vnfGj922yj9UFZmPVHk
KwfoNdrVVBMiq4suBTBglhHngerxKQ==
=ckuR
-----END PGP SIGNATURE-----

--zntsTuPuVdDM25ikzVHkC3XFFpByjvLAs--
