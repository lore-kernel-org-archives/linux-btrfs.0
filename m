Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1487EC0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 07:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D024C2081D
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 07:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D024C2081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbeKGQmO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 11:42:14 -0500
Received: from mout.gmx.net ([212.227.15.19]:49673 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbeKGQmO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 11:42:14 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lbuo0-1fdIF20ZwC-00jIhN; Wed, 07
 Nov 2018 08:13:05 +0100
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lbuo0-1fdIF20ZwC-00jIhN; Wed, 07
 Nov 2018 08:13:05 +0100
Subject: Re: [PATCH 11/13] btrfs-progs: check: Delete file extent item with
 unaligned extent backref
To:     "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-12-suy.fnst@cn.fujitsu.com>
 <18e31f91-74ef-1416-8b87-32a108700269@gmx.com>
 <24a149df-1b5d-8c9d-2f4d-37e2338a6c8a@cn.fujitsu.com>
 <e2113bf4-b888-2d6f-0a7b-f0c734d63172@gmx.com>
 <05530906-9f07-0f36-baa5-ccbef423c632@cn.fujitsu.com>
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
Message-ID: <ea4e1ca2-25f8-6aa0-7f19-025806cc41f4@gmx.com>
Date:   Wed, 7 Nov 2018 15:13:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <05530906-9f07-0f36-baa5-ccbef423c632@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OOyiu9cvInUp1AGPpwDi5XEyL6Acen4Xj0KEVtClTvJkaknUfCO
 sRKVzlFDSxJUfZZ9EZzO5DSsvSEWQj+5WFVgjWukQpm/vbHllPidujf4FhAT6aRpw63W92i
 /9EmpBbTJaQQ+m2zCq6YLGYV/JjtMaucDxv8U/fUTK8IihGNs7BtciUH9NJMZAdW/RZAFj5
 6VsWR5kjnr3KCm0CluUtw==
X-UI-Out-Filterresults: notjunk:1;V01:K0:Ib/5ZzoDrrE=:VkLcT3StRoWxA5FjL+UEc6
 BG5hyLU+bZ81pM1coZu7dkD0zHk7lXE55FaUeAmiOUhZT0k2DFSPcBn26PMB2f5DDEFPvSG31
 HEHqQhyeZz5pcTxM88Ok28hguttiDVLQ4ZSan9LwAFiPlX4pemTeqM0vmG9rpQp94oNNsKiBL
 HIZMZUInYz/fm366I5uEixUwgQs1Msamd0jWw/7JErh4gTaT6QC1bRdg8c46DujkzPujRzkpF
 NuJ5LJKC1ItYdU9dKvsaak1/QBc9QUr34L6QK0bYsx/aX8+IrFzs6i+08X8Pbj9P3cMjycKmJ
 zTT/iT64kflxY5JTVlCe4uLDvYDqPcHFdVdR/AdU9MlcLqB6QiN2+udkNpMntjmAZvwXue+zL
 tWojTQYpOY5kaviN4fO5UhoH6NQ9uM8uegwzp7RnioM+3zwZcsOKgGov4ljsxEtm5WMinGxCf
 cBdOrUfLlTpPpOIDqVbmGmH3eXXwMpwpO/bE/+yVhIB/q173s04RV32Xsh/UrHRB2QE+LGKnL
 YYO8/8oXvU+w4oGL4hG8Bc1WMUjmDRPbJzmY5hmdGDidf16iOKq+h/sePQaTRiW/j5W2rVC7z
 LgTKqaAHHxfAULfvAS8GsCI/aRgQ+PsWfiMF9bJTqaEmymgtWhaVvxsqupGK1hKCa9piDOj/Q
 DoJlam/clQuBjEWZNGKHgbP1Vzzfb5i068p2cgmD+Mx3+Ndhrz2tnckHzXE4+5bToTy3dNDbB
 Z+rK3N6+yDf4TfCNjwKHC76vONTsStwgPRPU2xMlj6R5/YvO/imVpyHnTYyR4k/ks6AIUCB/A
 tsd8/+SFvq++AxPlDOGFMi7X7+veuVexZUcOZ453e6g9aV59cE=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/7 下午3:04, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
> 
> 
> On 11/7/2018 2:38 PM, Qu Wenruo wrote:
>>
>> On 2018/11/7 下午2:21, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
>>>
>>> On 10/24/2018 8:45 AM, Qu Wenruo wrote:
>>>> On 2018/10/23 下午5:41, Su Yue wrote:
>>>>> From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>>>>>
>>>>> In original mode, if some file extent item has unaligned extent
>>>>> backref,
>>>>> fixup_extent_refs can't repair it. This patch will check extent
>>>>> alignment
>>>>> then delete file extent with unaligned extent backref.
>>>> This looks a little strange to me.
>>>>
>>>> You mean, an unaligned FILE EXTENT has an unaligned EXTENT_ITEM?
>>>>
>>>> Then why not just delete the EXTENT_ITEM directly? No need to go back
>>>> checking if it has a corresponding EXTENT_DATA since unaligned one is
>>>> definitely corrupted.
>>>>
>>>> For corrupted EXTENT_DATA, it should get deleted when we check fs tree.
>>>>
>>>> This would save you a lot of codes.
>>>>
>>>> Thanks,
>>>> Qu
>>> The situation is that the file extent has wrong extent backref, actually
>>> it doesn't exist.
>> Did you mean extent EXTENT_ITEM key's objectid is unaligned?
>>
>> Would you please give an example on this case? Like:
>> (<ino> EXTENT_DATA <offset>
>>     disk bytenr <XXXX> disk len <YYYY>
>>
>> And its backref like:
>> (<XXXX> EXTENT_ITEM <YYYY>)
>>
>> And then mark where the number is incorrect.
>>
>> Thanks,
>> Qu
> 
> As in /btrfs-progs/tests/fsck-tests/001-bad-file-extent-bytenr case:
> 
> item 7 key (257 EXTENT_DATA 0) itemoff 3453 itemsize 53
> 
>                 generation 6 type 1 (regular)
> 
>                 extent data disk byte 755944791 nr 1048576
>                                 ^^^^^^^^^
> 
>                 extent data offset 0 nr 1048576 ram 1048576
> 
>                 extent compression 0 (none)

Then there is no "unaligned extent backref".

It's just a unaligned disk bytenr of a file extent.
Nothing to do with backref.

Please update the commit message to avoid such confusing words, and
include above info, which is pretty easy to understand.

Thanks,
Qu

> 
> Thanks,
> 
> Su
> 
>>> Thanks,
>>> Su
>>>
>>>
>>>
>>>
>>>
>>
> 
> 
> 
