Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8D5C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 23:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB80C20878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 23:26:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB80C20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbeLFX0l (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 18:26:41 -0500
Received: from mout.gmx.net ([212.227.15.19]:57997 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbeLFX0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 18:26:41 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7pku-1hQ9wC3Dyi-00vS6i; Fri, 07
 Dec 2018 00:26:37 +0100
Subject: Re: BTRFS RAID filesystem unmountable
To:     Michael Wade <spikewade@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com>
 <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com>
 <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
 <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
 <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
 <f9694e69-ca47-57cd-3afb-2279bb79467a@gmx.com>
 <CAB+znrHAKZ8TOTBtd3AtUJCZqcC77+m41sq+zMB12w=oWY0trw@mail.gmail.com>
 <df3b2ffd-2188-0f14-1ff0-afb98ffb70a9@gmx.com>
 <CAB+znrEfAA4FSspB8-ACUXXuFp8wOCDr_mH9Xth_snkvUmHQYw@mail.gmail.com>
 <CAB+znrEEO+-L-Fn2u=tNSXXEhLLS1_a1aFTzG_AeA5tYinsUOg@mail.gmail.com>
 <31f77b2f-4110-9868-2c6b-abf40ccef316@gmx.com>
 <CAB+znrHU5ca73AMFEBVD5OkJSgPE=7Eyk8wQdzYM9UrdAfEVug@mail.gmail.com>
 <CAB+znrFS=Xi+4tPS3szqZro1FdjnVcbe29UV9UMUUxsGL6NJUg@mail.gmail.com>
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
Message-ID: <cbe495db-d567-515b-fd5e-89b685f0ea16@gmx.com>
Date:   Fri, 7 Dec 2018 07:26:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <CAB+znrFS=Xi+4tPS3szqZro1FdjnVcbe29UV9UMUUxsGL6NJUg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9ry7KaafFnS4EBJn0fXRjoSPUCTRIoFzm"
X-Provags-ID: V03:K1:FyMBohiRcdC6ccStO1U8+9ldV9x1SVdxQBuIK5iFZHHpQ1m3XFx
 /PFgTMnM2BzOYqJpHkPs8ow9ly8XmUZGhCMPK17UUwDvc33Y3VXDSfKVvQGTNV2+hJvkwd4
 SVOq9HNTo4BodWU5BdYTQezu2v6NfwDgRD2mDG1JpgkSv5CT+PT5JxYvj+oe0OIxG1cESgI
 gq7rbyErVv/gvo83Cm6gQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:DC8/71WfFng=:RkH0C0P9o2+sTUEEeulDl5
 wuYMTO9PRMrvlgakk9IXo7qxCkPFp6TCB/NxjppiEpN3svxkx5eiZ/w5PM+MCTBPKG+V4l8rP
 bEu6wBbh+sbmAVXpcp0U/grFMDTKpt9ME/dNn2sClRkHPxiYrg/qrYOWAeyaErM7DLiOq5q3d
 2kKfwD4VTvjeOaCxwRSfNIc1NnIYvlYUJo6K4PQ7nT8RGWHToBemIUKxehTDsqmTS2pCnFfd/
 Cgw9Z1H/dDxwBtvV4nCDCxBYllwwYEO/eA3FMCWaROaL60/ktro6+NR7KuDo8mXSdA3EhEdJu
 rN5yJZt48B3zhc3cU7xcvr8JMYqlBWsSghuS1zXQivW6YoHtgjGzX0+D/2ha07xgQjtlY7xLz
 Llnrw0d0XTXiq6EpekQ3wZOLewoSobmg38xQ83/LrRHLV+weLst7Md01nimM3B5qnfpLnKejj
 CaHn/8s3sEpzHoloJx/5rfDywDeF5ueZvymQ174Nerv29uuggoAhCBgn6CqBaN/Bj624Msj3I
 1r/xLJ2AL7YmXO+p5hf62B2jLPMvfBjoRYQtzmfFOXnaDLLvxEvXoTAZc7z+J5HKCRsQDccYO
 32XHw/nIhodVvL59wbwOjsauGfow+0yyrTfSMG6xyL0Cp1+cx0uEqwHUmAJFxUacfs1hAX5n4
 adhLzDFk8VxX3O4JXT26xoF27FycZn1OKnQZNCM3DJX7K2OqQ+P0xiWZCm1k+RBHe/zABxept
 iOuYpHXm6oax9scqVufYuIY7WSkJzkRd83PeNe0mAAeC+6qzNsIyrULlfnBGZtVy1j1nNnqFp
 s/e2cALcvH+csAaX+wrBpPEQXM23yiY1ZxH43eemalvIPWvo6X0UtndY45MdC+Z6C3GekALx1
 L7StzMCty4QM1OJxkrYqXehHoLU3wq/o0CErZpmVa5mV2pc/rA8zRQU7k5++zl
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9ry7KaafFnS4EBJn0fXRjoSPUCTRIoFzm
Content-Type: multipart/mixed; boundary="aa0vqkV5Lu8sAa2z3tjppWBlQFIJmJiBQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Michael Wade <spikewade@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <cbe495db-d567-515b-fd5e-89b685f0ea16@gmx.com>
Subject: Re: BTRFS RAID filesystem unmountable
References: <CAB+znrFyimDnOZt46CqterRJ6MvwD4TSWagQvv-oQxjPvG-m2w@mail.gmail.com>
 <54d2f70a-adae-98cc-581f-2e4786783b26@gmx.com>
 <CAB+znrHYrhBB4cstUaS3KcOfEHhOTPUsfAJKj3Cj62HJ-05FrQ@mail.gmail.com>
 <d32f3fdc-5ba0-2b62-ce79-5e5665d4c960@gmx.com>
 <CAB+znrF_d+Hg_A9AMvWEB=S5eVAtYrvr2jUPcvR4FfB4hnCMWA@mail.gmail.com>
 <bff1c7b3-5bac-9806-a376-3612057865cf@gmx.com>
 <CAB+znrHPF7963-MAXtgu8s3+vLEA7ENE0=uCCJ6sWCF6KUWToQ@mail.gmail.com>
 <bb0df6b1-3780-8ea5-b48e-e82f65a68f60@gmx.com>
 <CAB+znrEcW3+++ZBrB_ZGRFncssO-zffbJ6ug8_z0DJOhbp+vGA@mail.gmail.com>
 <f9694e69-ca47-57cd-3afb-2279bb79467a@gmx.com>
 <CAB+znrHAKZ8TOTBtd3AtUJCZqcC77+m41sq+zMB12w=oWY0trw@mail.gmail.com>
 <df3b2ffd-2188-0f14-1ff0-afb98ffb70a9@gmx.com>
 <CAB+znrEfAA4FSspB8-ACUXXuFp8wOCDr_mH9Xth_snkvUmHQYw@mail.gmail.com>
 <CAB+znrEEO+-L-Fn2u=tNSXXEhLLS1_a1aFTzG_AeA5tYinsUOg@mail.gmail.com>
 <31f77b2f-4110-9868-2c6b-abf40ccef316@gmx.com>
 <CAB+znrHU5ca73AMFEBVD5OkJSgPE=7Eyk8wQdzYM9UrdAfEVug@mail.gmail.com>
 <CAB+znrFS=Xi+4tPS3szqZro1FdjnVcbe29UV9UMUUxsGL6NJUg@mail.gmail.com>
In-Reply-To: <CAB+znrFS=Xi+4tPS3szqZro1FdjnVcbe29UV9UMUUxsGL6NJUg@mail.gmail.com>

--aa0vqkV5Lu8sAa2z3tjppWBlQFIJmJiBQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/7 =E4=B8=8A=E5=8D=887:15, Michael Wade wrote:
> Hi Qu,
>=20
> Me again! Having formatted the drives and rebuilt the RAID array I
> seem to have be having the same problem as before (no power cut this
> time [I bought a UPS]).

But strangely, your super block shows it has log tree, which means
either your hit a kernel panic/transaction abort, or a unexpected power
loss.

> The brtfs volume is broken on my ReadyNAS.
>=20
> I have attached the results of some of the commands you asked me to
> run last time, and I am hoping you might be able to help me out.

This time, the problem is more serious, some chunk tree blocks are not
even inside system chunk range, no wonder it fails to mount.

To confirm it, you could run "btrfs ins dump-tree -b 17725903077376
<device>" and paste the output.

But I don't have any clue. My guess is some kernel problem related to
new chunk allocation, or the chunk root node itself is already seriously
corrupted.

Considering how old your kernel is (4.4), it's not recommended to use
btrfs on such old kernel, unless it's well backported with tons of btrfs
fixes.

Thanks,
Qu

>=20
> Kind regards
> Michael
> On Sat, 19 May 2018 at 12:43, Michael Wade <spikewade@gmail.com> wrote:=

>>
>> I have let the find root command run for 14+ days, its produced a
>> pretty huge log file 1.6 GB but still hasn't completed. I think I will=

>> start the process of reformatting my drives and starting over.
>>
>> Thanks for your help anyway.
>>
>> Kind regards
>> Michael
>>
>> On 5 May 2018 at 01:43, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2018=E5=B9=B405=E6=9C=8805=E6=97=A5 00:18, Michael Wade wrote:
>>>> Hi Qu,
>>>>
>>>> The tool is still running and the log file is now ~300mb. I guess it=

>>>> shouldn't normally take this long.. Is there anything else worth
>>>> trying?
>>>
>>> I'm afraid not much.
>>>
>>> Although there is a possibility to modify btrfs-find-root to do much
>>> faster but limited search.
>>>
>>> But from the result, it looks like underlying device corruption, and =
not
>>> much we can do right now.
>>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Kind regards
>>>> Michael
>>>>
>>>> On 2 May 2018 at 06:29, Michael Wade <spikewade@gmail.com> wrote:
>>>>> Thanks Qu,
>>>>>
>>>>> I actually aborted the run with the old btrfs tools once I saw its
>>>>> output. The new btrfs tools is still running and has produced a log=

>>>>> file of ~85mb filled with that content so far.
>>>>>
>>>>> Kind regards
>>>>> Michael
>>>>>
>>>>> On 2 May 2018 at 02:31, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>
>>>>>>
>>>>>> On 2018=E5=B9=B405=E6=9C=8801=E6=97=A5 23:50, Michael Wade wrote:
>>>>>>> Hi Qu,
>>>>>>>
>>>>>>> Oh dear that is not good news!
>>>>>>>
>>>>>>> I have been running the find root command since yesterday but it =
only
>>>>>>> seems to be only be outputting the following message:
>>>>>>>
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>
>>>>>> It's mostly fine, as find-root will go through all tree blocks and=
 try
>>>>>> to read them as tree blocks.
>>>>>> Although btrfs-find-root will suppress csum error output, but such=
 basic
>>>>>> tree validation check is not suppressed, thus you get such message=
=2E
>>>>>>
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>>
>>>>>>> I tried with the latest btrfs tools compiled from source and the =
ones
>>>>>>> I have installed with the same result. Is there a CLI utility I c=
ould
>>>>>>> use to determine if the log contains any other content?
>>>>>>
>>>>>> Did it report any useful info at the end?
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Kind regards
>>>>>>> Michael
>>>>>>>
>>>>>>>
>>>>>>> On 30 April 2018 at 04:02, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 22:08, Michael Wade wrote=
:
>>>>>>>>> Hi Qu,
>>>>>>>>>
>>>>>>>>> Got this error message:
>>>>>>>>>
>>>>>>>>> ./btrfs inspect dump-tree -b 20800943685632 /dev/md127
>>>>>>>>> btrfs-progs v4.16.1
>>>>>>>>> bytenr mismatch, want=3D20800943685632, have=3D3118598835113619=
663
>>>>>>>>> ERROR: cannot read chunk root
>>>>>>>>> ERROR: unable to open /dev/md127
>>>>>>>>>
>>>>>>>>> I have attached the dumps for:
>>>>>>>>>
>>>>>>>>> dd if=3D/dev/md127 of=3D/tmp/chunk_root.copy1 bs=3D1 count=3D32=
K skip=3D266325721088
>>>>>>>>> dd if=3D/dev/md127 of=3D/tmp/chunk_root.copy2 bs=3D1 count=3D32=
K skip=3D266359275520
>>>>>>>>
>>>>>>>> Unfortunately, both dumps are corrupted and contain mostly garba=
ge.
>>>>>>>> I think it's the underlying stack (mdraid) has something wrong o=
r failed
>>>>>>>> to recover its data.
>>>>>>>>
>>>>>>>> This means your last chance will be btrfs-find-root.
>>>>>>>>
>>>>>>>> Please try:
>>>>>>>> # btrfs-find-root -o 3 <device>
>>>>>>>>
>>>>>>>> And provide all the output.
>>>>>>>>
>>>>>>>> But please keep in mind, chunk root is a critical tree, and so f=
ar it's
>>>>>>>> already heavily damaged.
>>>>>>>> Although I could still continue try to recover, there is pretty =
low
>>>>>>>> chance now.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>>
>>>>>>>>> Kind regards
>>>>>>>>> Michael
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 29 April 2018 at 10:33, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:59, Michael Wade wro=
te:
>>>>>>>>>>> Ok, will it be possible for me to install the new version of =
the tools
>>>>>>>>>>> on my current kernel without overriding the existing install?=
 Hesitant
>>>>>>>>>>> to update kernel/btrfs as it might break the ReadyNAS interfa=
ce /
>>>>>>>>>>> future firmware upgrades.
>>>>>>>>>>>
>>>>>>>>>>> Perhaps I could grab this:
>>>>>>>>>>> https://github.com/kdave/btrfs-progs/releases/tag/v4.16.1 and=

>>>>>>>>>>> hopefully build from source and then run the binaries directl=
y?
>>>>>>>>>>
>>>>>>>>>> Of course, that's how most of us test btrfs-progs builds.
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> Qu
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> Kind regards
>>>>>>>>>>>
>>>>>>>>>>> On 29 April 2018 at 09:33, Qu Wenruo <quwenruo.btrfs@gmx.com>=
 wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> On 2018=E5=B9=B404=E6=9C=8829=E6=97=A5 16:11, Michael Wade w=
rote:
>>>>>>>>>>>>> Thanks Qu,
>>>>>>>>>>>>>
>>>>>>>>>>>>> Please find attached the log file for the chunk recover com=
mand.
>>>>>>>>>>>>
>>>>>>>>>>>> Strangely, btrfs chunk recovery found no extra chunk beyond =
current
>>>>>>>>>>>> system chunk range.
>>>>>>>>>>>>
>>>>>>>>>>>> Which means, it's chunk tree corrupted.
>>>>>>>>>>>>
>>>>>>>>>>>> Please dump the chunk tree with latest btrfs-progs (which pr=
ovides the
>>>>>>>>>>>> new --follow option).
>>>>>>>>>>>>
>>>>>>>>>>>> # btrfs inspect dump-tree -b 20800943685632 <device>
>>>>>>>>>>>>
>>>>>>>>>>>> If it doesn't work, please provide the following binary dump=
:
>>>>>>>>>>>>
>>>>>>>>>>>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy1 bs=3D1 count=3D32=
K skip=3D266325721088
>>>>>>>>>>>> # dd if=3D<dev> of=3D/tmp/chunk_root.copy2 bs=3D1 count=3D32=
K skip=3D266359275520
>>>>>>>>>>>> (And will need to repeat similar dump for several times acco=
rding to
>>>>>>>>>>>> above dump)
>>>>>>>>>>>>
>>>>>>>>>>>> Thanks,
>>>>>>>>>>>> Qu
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Kind regards
>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 28 April 2018 at 12:38, Qu Wenruo <quwenruo.btrfs@gmx.co=
m> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 17:37, Michael Wade=
 wrote:
>>>>>>>>>>>>>>> Hi Qu,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thanks for your reply. I will investigate upgrading the k=
ernel,
>>>>>>>>>>>>>>> however I worry that future ReadyNAS firmware upgrades wo=
uld fail on a
>>>>>>>>>>>>>>> newer kernel version (I don't have much linux experience =
so maybe my
>>>>>>>>>>>>>>> concerns are unfounded!?).
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I have attached the output of the dump super command.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I did actually run chunk recover before, without the verb=
ose option,
>>>>>>>>>>>>>>> it took around 24 hours to finish but did not resolve my =
issue. Happy
>>>>>>>>>>>>>>> to start that again if you need its output.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The system chunk only contains the following chunks:
>>>>>>>>>>>>>> [0, 4194304]:           Initial temporary chunk, not used =
at all
>>>>>>>>>>>>>> [20971520, 29360128]:   System chunk created by mkfs, shou=
ld be full
>>>>>>>>>>>>>>                         used up
>>>>>>>>>>>>>> [20800943685632, 20800977240064]:
>>>>>>>>>>>>>>                         The newly created large system chu=
nk.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The chunk root is still in 2nd chunk thus valid, but some =
of its leaf is
>>>>>>>>>>>>>> out of the range.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> If you can't wait 24h for chunk recovery to run, my advice=
 would be move
>>>>>>>>>>>>>> the disk to some other computer, and use latest btrfs-prog=
s to execute
>>>>>>>>>>>>>> the following command:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> # btrfs inpsect dump-tree -b 20800943685632 --follow
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> If we're lucky enough, we may read out the tree leaf conta=
ining the new
>>>>>>>>>>>>>> system chunk and save a day.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>>> Qu
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Thanks so much for your help.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Kind regards
>>>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> On 28 April 2018 at 09:45, Qu Wenruo <quwenruo.btrfs@gmx.=
com> wrote:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 2018=E5=B9=B404=E6=9C=8828=E6=97=A5 16:30, Michael Wa=
de wrote:
>>>>>>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I was hoping that someone would be able to help me reso=
lve the issues
>>>>>>>>>>>>>>>>> I am having with my ReadyNAS BTRFS volume. Basically my=
 trouble
>>>>>>>>>>>>>>>>> started after a power cut, subsequently the volume woul=
d not mount.
>>>>>>>>>>>>>>>>> Here are the details of my setup as it is at the moment=
:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> uname -a
>>>>>>>>>>>>>>>>> Linux QAI 4.4.116.alpine.1 #1 SMP Mon Feb 19 21:58:38 P=
ST 2018 armv7l GNU/Linux
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> The kernel is pretty old for btrfs.
>>>>>>>>>>>>>>>> Strongly recommended to upgrade.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> btrfs --version
>>>>>>>>>>>>>>>>> btrfs-progs v4.12
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> So is the user tools.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Although I think it won't be a big problem, as needed to=
ol should be there.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> btrfs fi show
>>>>>>>>>>>>>>>>> Label: '11baed92:data'  uuid: 20628cda-d98f-4f85-955c-9=
32a367f8821
>>>>>>>>>>>>>>>>> Total devices 1 FS bytes used 5.12TiB
>>>>>>>>>>>>>>>>> devid    1 size 7.27TiB used 6.24TiB path /dev/md127
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> So, it's btrfs on mdraid.
>>>>>>>>>>>>>>>> It would normally make things harder to debug, so I coul=
d only provide
>>>>>>>>>>>>>>>> advice from the respect of btrfs.
>>>>>>>>>>>>>>>> For mdraid part, I can't ensure anything.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Here are the relevant dmesg logs for the current state =
of the device:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> [   19.119391] md: md127 stopped.
>>>>>>>>>>>>>>>>> [   19.120841] md: bind<sdb3>
>>>>>>>>>>>>>>>>> [   19.121120] md: bind<sdc3>
>>>>>>>>>>>>>>>>> [   19.121380] md: bind<sda3>
>>>>>>>>>>>>>>>>> [   19.125535] md/raid:md127: device sda3 operational a=
s raid disk 0
>>>>>>>>>>>>>>>>> [   19.125547] md/raid:md127: device sdc3 operational a=
s raid disk 2
>>>>>>>>>>>>>>>>> [   19.125554] md/raid:md127: device sdb3 operational a=
s raid disk 1
>>>>>>>>>>>>>>>>> [   19.126712] md/raid:md127: allocated 3240kB
>>>>>>>>>>>>>>>>> [   19.126778] md/raid:md127: raid level 5 active with =
3 out of 3
>>>>>>>>>>>>>>>>> devices, algorithm 2
>>>>>>>>>>>>>>>>> [   19.126784] RAID conf printout:
>>>>>>>>>>>>>>>>> [   19.126789]  --- level:5 rd:3 wd:3
>>>>>>>>>>>>>>>>> [   19.126794]  disk 0, o:1, dev:sda3
>>>>>>>>>>>>>>>>> [   19.126799]  disk 1, o:1, dev:sdb3
>>>>>>>>>>>>>>>>> [   19.126804]  disk 2, o:1, dev:sdc3
>>>>>>>>>>>>>>>>> [   19.128118] md127: detected capacity change from 0 t=
o 7991637573632
>>>>>>>>>>>>>>>>> [   19.395112] Adding 523708k swap on /dev/md1.  Priori=
ty:-1 extents:1
>>>>>>>>>>>>>>>>> across:523708k
>>>>>>>>>>>>>>>>> [   19.434956] BTRFS: device label 11baed92:data devid =
1 transid
>>>>>>>>>>>>>>>>> 151800 /dev/md127
>>>>>>>>>>>>>>>>> [   19.739276] BTRFS info (device md127): setting nodat=
asum
>>>>>>>>>>>>>>>>> [   19.740440] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740450] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740498] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740512] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740552] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740560] BTRFS critical (device md127): unable to=
 find logical
>>>>>>>>>>>>>>>>> 3208757641216 len 4096
>>>>>>>>>>>>>>>>> [   19.740576] BTRFS error (device md127): failed to re=
ad chunk root
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> This shows it pretty clear, btrfs fails to read chunk ro=
ot.
>>>>>>>>>>>>>>>> And according your above "len 4096" it's pretty old fs, =
as it's still
>>>>>>>>>>>>>>>> using 4K nodesize other than 16K nodesize.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> According to above output, it means your superblock by s=
omehow lacks the
>>>>>>>>>>>>>>>> needed system chunk mapping, which is used to initialize=
 chunk mapping.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Please provide the following command output:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> # btrfs inspect dump-super -fFa /dev/md127
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Also, please consider run the following command and dump=
 all its output:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> # btrfs rescue chunk-recover -v /dev/md127.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Please note that, above command can take a long time to =
finish, and if
>>>>>>>>>>>>>>>> it works without problem, it may solve your problem.
>>>>>>>>>>>>>>>> But if it doesn't work, the output could help me to manu=
ally craft a fix
>>>>>>>>>>>>>>>> to your super block.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Thanks,
>>>>>>>>>>>>>>>> Qu
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> [   19.783975] BTRFS error (device md127): open_ctree f=
ailed
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> In an attempt to recover the volume myself I run a few =
BTRFS commands
>>>>>>>>>>>>>>>>> mostly using advice from here:
>>>>>>>>>>>>>>>>> https://lists.opensuse.org/opensuse/2017-02/msg00930.ht=
ml. However
>>>>>>>>>>>>>>>>> that actually seems to have made things worse as I can =
no longer mount
>>>>>>>>>>>>>>>>> the file system, not even in readonly mode.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> So starting from the beginning here is a list of things=
 I have done so
>>>>>>>>>>>>>>>>> far (hopefully I remembered the order in which I ran th=
em!)
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> 1. Noticed that my backups to the NAS were not running =
(didn't get
>>>>>>>>>>>>>>>>> notified that the volume had basically "died")
>>>>>>>>>>>>>>>>> 2. ReadyNAS UI indicated that the volume was inactive.
>>>>>>>>>>>>>>>>> 3. SSHed onto the box and found that the first drive wa=
s not marked as
>>>>>>>>>>>>>>>>> operational (log showed I/O errors / UNKOWN (0x2003))  =
so I replaced
>>>>>>>>>>>>>>>>> the disk and let the array resync.
>>>>>>>>>>>>>>>>> 4. After resync the volume still was unaccessible so I =
looked at the
>>>>>>>>>>>>>>>>> logs once more and saw something like the following whi=
ch seemed to
>>>>>>>>>>>>>>>>> indicate that the replay log had been corrupted when th=
e power went
>>>>>>>>>>>>>>>>> out:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root l=
eaf's nritems
>>>>>>>>>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root l=
eaf's nritems
>>>>>>>>>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>>>>>>>>>> BTRFS: error (device md127) in btrfs_replay_log:2524: e=
rrno=3D-5 IO
>>>>>>>>>>>>>>>>> failure (Failed to recover log tree)
>>>>>>>>>>>>>>>>> BTRFS error (device md127): pending csums is 155648
>>>>>>>>>>>>>>>>> BTRFS error (device md127): cleaner transaction attach =
returned -30
>>>>>>>>>>>>>>>>> BTRFS critical (device md127): corrupt leaf, non-root l=
eaf's nritems
>>>>>>>>>>>>>>>>> is 0: block=3D232292352, root=3D7, slot=3D0
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> 5. Then:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> btrfs rescue zero-log
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> 6. Was then able to mount the volume in readonly mode.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> btrfs scrub start
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Which fixed some errors but not all:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for =
04:00:34
>>>>>>>>>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>>>>>>>>>> error details: csum=3D6
>>>>>>>>>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverifie=
d errors: 0
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> scrub status for 20628cda-d98f-4f85-955c-932a367f8821
>>>>>>>>>>>>>>>>> scrub started at Tue Apr 24 17:27:44 2018, running for =
04:34:43
>>>>>>>>>>>>>>>>> total bytes scrubbed: 224.26GiB with 6 errors
>>>>>>>>>>>>>>>>> error details: csum=3D6
>>>>>>>>>>>>>>>>> corrected errors: 0, uncorrectable errors: 6, unverifie=
d errors: 0
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> 6. Seeing this hanging I rebooted the NAS
>>>>>>>>>>>>>>>>> 7. Think this is when the volume would not mount at all=
=2E
>>>>>>>>>>>>>>>>> 8. Seeing log entries like these:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> BTRFS warning (device md127): checksum error at logical=
 20800943685632
>>>>>>>>>>>>>>>>> on dev /dev/md127, sector 520167424: metadata node (lev=
el 1) in tree 3
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> I ran
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> btrfs check --fix-crc
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> And that brings us to where I am now: Some seemly corru=
pted BTRFS
>>>>>>>>>>>>>>>>> metadata and unable to mount the drive even with the re=
covery option.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Any help you can give is much appreciated!
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Kind regards
>>>>>>>>>>>>>>>>> Michael
>>>>>>>>>>>>>>>>> --
>>>>>>>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscri=
be linux-btrfs" in
>>>>>>>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordom=
o-info.html
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>> --
>>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe lin=
ux-btrfs" in
>>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info=
=2Ehtml
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>
>>>>>>
>>>


--aa0vqkV5Lu8sAa2z3tjppWBlQFIJmJiBQ--

--9ry7KaafFnS4EBJn0fXRjoSPUCTRIoFzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwJsCkACgkQwj2R86El
/qgsNQf/eStH1eFQJoRTcJeQcp8ppRCyfZpsxs/kMUBbKRSRRhNxkn39ixbVyOaM
ez+HMuDe/atWkvOUeSb/5QnQYvTR2dU0QRqRYimKhoJLztdnx+v5A29UisLeEbQg
gXCzunzMvxqQHmL61cxqMYOIxUZdJDw3hIURlHE1sfqsFy4yLKh6IIQyouuOzumi
BoiXBh3HuY2I9NmJ7uNUcRY4S9RQEaSyHOt0nEfhdZg+giLEC5jPdHCYzfTMyUfJ
RvTCDu4sM++Rt1IlNqmJLqqz1RvdQHWQ5rLmgUDywajEGr4h8t8QhZ/m1ZgZCQF2
ar+uKCL2sGmLlMQorF5kf83XYquyHA==
=61Q8
-----END PGP SIGNATURE-----

--9ry7KaafFnS4EBJn0fXRjoSPUCTRIoFzm--
