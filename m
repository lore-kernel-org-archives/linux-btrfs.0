Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6259C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A1C02084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 05:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A1C02084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLEFYS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 00:24:18 -0500
Received: from mout.gmx.net ([212.227.17.22]:44985 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbeLEFYS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 00:24:18 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MVNWU-1gzgoc1I58-00YlXe; Wed, 05
 Dec 2018 06:24:13 +0100
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     Mike Javorski <mike.javorski@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
 <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
 <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>
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
Message-ID: <8bb26660-0dbf-1fbd-9472-b64daa88d252@gmx.com>
Date:   Wed, 5 Dec 2018 13:24:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yl3arjcY0h1UsIo62fuDGBTVNRsGWOlSZ"
X-Provags-ID: V03:K1:DxcZR8NwJYHyU06hajCStpnWPof5h+NSQAHaRmUXz7uM5YesXRr
 VdDgrmFa2oIh93ryJo8DGdbHVU/FI8hptldPfzQYO5ocvhwAmxOXS3PWHU2lVYukK9lgALb
 WRuSnMzMWpZUzhQiR79D1S54R4tfcE10VWmxjp4p1KXNcaY9ziTjm+Mb7RzG1KRd3ngwc2a
 no8LG4BbDN9OGtNYeKYuQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Nt6HV+j/Gfo=:ZeXi1ahu7KXwA7dd+d8enD
 dp+hAaRld7bUDgWZinYllq9D6L0ylRmNDlpxhlrUQaRwXboF+0wOnuou321oCRtCpVGbt+YZF
 uknNwOJXFNspOaA6kky4i7p30ffpmicixkxbMBMxEHMkPksrcb9D4empEOWOt7FIKBZdtyxS0
 lpVQeP5xAHrwIalNBXSJ5kBtl5XkGOfiV13g0IW0d5XorCer+1rrLbVoAdDqWS+EW10QUjZnr
 LfvBVme0X7+s2Cm+l4699vAoXSdkzCyavSXsbdeOp2Cph46piZHNoAS32hBMhcSNLQ74FSWsw
 p8OpFIv/ae11kjZg8PC5l4ZOB/pjvmKL+uPsd1I+TI9ECie92f7icUxG49qtKs3YGYyN/VfRR
 sC8Q00npYvPmi4YBrAOcO0X/IdKqe9G+Qg1FobtPD6xw7pHETi6/vT8XWpHbn15En+9oIYMeG
 bv1bkzZ+Rsdke3S2CuQJL8JXCDhetz2yX8E+CphH0leOa+gpQHt4Yl/ql4tCxyGDPqZtM1FlH
 anzKUKzVSMZWbWJEgSuxopjFFmcKcM4+ajL43baRMUIbmXqQtcW5miuiud+Iu4joA1tOPShG2
 5pmXS7yHp2tByNDBYchNpC4rtevBsvmFavDrNuKNDevAwj7TdtM0roB0WQp5+oR9AKMN/lcwQ
 DO6STRht1nuWfYWKCHS4uG9Yg/OMbEus7sRkBth8kagQlbhR17EkR4HV0DlEvr1ZjwfhlVW5H
 LbRAaZ5NTDjfColZi908ctcT3OcM0oLOnpM3G9a5f8/qFz8pyHypI5CIeXYfodEgZN8I7hUJo
 rO9PxkzQCNIGPyDVbvc4IAOSMmRN3xEh4d6HQketqCgcCAh1mqQpCgyAfNWZxOt6jyG/cbuvV
 EgG/kbfQpheDaICwjMtLoImEp9ngCyuKz9I5RjY7muX9+oo6hOVVgBAsLF2eOB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yl3arjcY0h1UsIo62fuDGBTVNRsGWOlSZ
Content-Type: multipart/mixed; boundary="DMWlIh0T03gXQpB0PKFfRjoHtFwH1bL4F";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mike Javorski <mike.javorski@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <8bb26660-0dbf-1fbd-9472-b64daa88d252@gmx.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
 <35c0af18-35ea-fd2a-5388-c6ee4ce9f434@gmx.com>
 <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>
In-Reply-To: <CAOv1SKA=psv4wu18YiWy89UAB-R+o5+2qt9jvu6TKjf9EeOvNA@mail.gmail.com>

--DMWlIh0T03gXQpB0PKFfRjoHtFwH1bL4F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/5 =E4=B8=8A=E5=8D=886:33, Mike Javorski wrote:
> On Tue, Dec 4, 2018 at 2:18 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
>>
>>
>>
>> On 2018/12/4 =E4=B8=8A=E5=8D=8811:32, Mike Javorski wrote:
>>> Need a bit of advice here ladies / gents. I am running into an issue
>>> which Qu Wenruo seems to have posted a patch for several weeks ago
>>> (see https://patchwork.kernel.org/patch/10694997/).
>>>
>>> Here is the relevant dmesg output which led me to Qu's patch.
>>> ----
>>> [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=3D2
>>> block=3D24655027060736 slot=3D20 bg_start=3D13188988928 bg_len=3D1080=
4527104,
>>> invalid block group size, have 10804527104 expect (0, 10737418240]
>>> [   10.032493] BTRFS error (device sdb): failed to read block groups:=
 -5
>>> [   10.053365] BTRFS error (device sdb): open_ctree failed
>>> ----
>>
>> Exactly the same symptom.
>>
>>>
>>> This server has a 16 disk btrfs filesystem (RAID6) which I boot
>>> periodically to btrfs-send snapshots to. This machine is running
>>> ArchLinux and I had just updated  to their latest 4.19.4 kernel
>>> package (from 4.18.10 which was working fine). I've tried updating to=

>>> the 4.19.6 kernel that is in testing, but that doesn't seem to resolv=
e
>>> the issue. From what I can see on kernel.org, the patch above is not
>>> pushed to stable or to Linus' tree.
>>>
>>> At this point the question is what to do. Is my FS toast?
>>
>> If there is no other problem at all, your fs is just fine.
>> It's my original patch too sensitive (the excuse for not checking chun=
k
>> allocator carefully enough).
>>
>> But since you have the down time, it's never a bad idea to run a btrfs=

>> check --readonly to see if your fs is really OK.
>>
>=20
> After running for 4 hours...
>=20
> UUID: 25b16375-b90b-408e-b592-fb07ed116d58
> [1/7] checking root items
> [2/7] checking extents
> [3/7] checking free space cache
> [4/7] checking fs roots
> [5/7] checking only csums items (without verifying data)
> [6/7] checking root refs
> [7/7] checking quota groups
> found 24939616169984 bytes used, no error found
> total csum bytes: 24321980768
> total tree bytes: 41129721856
> total fs tree bytes: 9854648320
> total extent tree bytes: 737804288
> btree space waste bytes: 7483785005
> file data blocks allocated: 212883520618496
>  referenced 212876546314240
>=20
> So things appear good to go. I will keep an eye out for the patch to
> land before upgrading the kernel again.
>=20
>>> Could I
>>> revert to the 4.18.10 kernel and boot safely?
>>
>> If your btrfs check --readonly doesn't report any problem, then you're=

>> completely fine to do so.
>> Although I still recommend to go RAID10 other than RAID5/6.
>=20
> I understand the risk, but don't have the funds to buy sufficient
> disks to operate in RAID10.

Then my advice would be, for any powerloss, please run a full-disk scrub
(and of course ensure there is not another powerloss during scrubbing).

I know this sounds silly and slow, but at least it should workaround the
write hole problem.

Thanks,
Qu

> The data is mostly large files and
> activity is predominantly reads, so risk is currently acceptable given
> the backup server. All super critical data is backed up to (very slow)
> cloud storage.
>=20
>>
>> Thanks,
>> Qu
>>
>>> I don't know if the 4.19
>>> boot process may have flipped some bits which would make reverting
>>> problematic.
>>>
>>> Thanks much,
>>>
>>> - mike
>>>
>>


--DMWlIh0T03gXQpB0PKFfRjoHtFwH1bL4F--

--yl3arjcY0h1UsIo62fuDGBTVNRsGWOlSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwHYPkACgkQwj2R86El
/qgTtQf9Fw+5GNIGKZA7FC+/E5eHyi/TsLQLGQhSg1kkITcQWiq0k92gln207WHa
bse493V35vai/RRwtCC0F0QA/F4QThvdIgNwSjOldo0JmTTmxh40C6JwA3ugkIys
PAl8FIVVkV8mntn/0HXfBtaL+qGJHH2GdGm5ykU84SlVDd8mg2mL2zMawvn02H1t
HUn9xnnbSTQC3KGNhWRVmfSf6bYPyplANeGMMoYoVUIaraoxFlIlOPIBDdR+RfwU
nogQLNsPdN57E/fYVRounaR6Kh+n4cpL0cppW2aLkxrjzocUHlM6oxskZQaoVmUn
oG4wI91+iCt5nn9+paF0FBGuNws0zg==
=Mmaz
-----END PGP SIGNATURE-----

--yl3arjcY0h1UsIo62fuDGBTVNRsGWOlSZ--
