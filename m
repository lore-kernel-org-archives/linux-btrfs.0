Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F64C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0545E2084B
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 07:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="aaVhNAhg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbfDJHRZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:17:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:44677 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfDJHRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 03:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554880638;
        bh=yIwjFuac7tJbeZykjx2+6aHvDq+HXzt+9vma+ns2nDA=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=aaVhNAhg7RgusRLuKRE7YOmB2tb3mYPH0gAPEUfixLU/st34WPlz0Pzew0uanzTFO
         b0Og03drRxCezfnq7lYfEyjk3THh5RkMyIAcM+4DW41eLc5jU0hpvFyGScMLAluT1o
         jmBxRI425MQf3uWtgKHZa6fJrQKITzWjvEDT5akM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MYeQr-1hRgNS0eBf-00Vhfs; Wed, 10
 Apr 2019 09:17:18 +0200
Subject: Re: Is it a good idea to replace current eb leakage detector with
 bcc/ebpf based one?
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <d0a50191-4506-7e21-5be9-4a5940563904@gmx.com>
 <b902732c-93e9-ddb5-231b-69012abf9d70@suse.com>
 <fe4b2eea-40eb-4b47-3596-601086af3e9f@gmx.com>
 <d845ae4c-9f50-c28f-f85d-a09df6a7a1b8@suse.com>
 <5d5faadc-3769-7b54-cfef-54b786d93c34@gmx.com>
 <51acdb2c-6b02-51e6-f18e-2e1643f60b74@suse.com>
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
Message-ID: <d1a6b77d-0b47-f0ea-1443-e8fa485c4da9@gmx.com>
Date:   Wed, 10 Apr 2019 15:17:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <51acdb2c-6b02-51e6-f18e-2e1643f60b74@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+BEpBxnPd5BRRhsqqGJL/asNrnimqk4eVHBH99XnP1/EtXnrmAa
 qWxaTys1H7Vi3/hesEYQsV2uTqzOacWPB1GkIt5/ox037jbYjzkQEpRzsPNRrjaYghqpivj
 QcM01mcOoBDW4NBgn3sXUXcrRQki8lBx33jHybhoDmvX71YtF+aQg7iFcGi9TSuYOlyPWqk
 mOc00upjy5MEcmYKV037Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:F1YANe2rlgc=:iPaHY6g3Na2UGb5SeHSbQn
 TVr5v/Pmes45K64azjORjXslrytSE3NHL96yQlcuOQ8upA9tacGp5s+lmQTz0xoHuD6jqfCBi
 NgWcfSFL7r13orKrcheqeOPCMFtz+q7C76ZbmZnlAJTJGQi7Ju//7MPxb2+pVAWCteCX/G1R2
 UTKYSiognOj5q7ysS6qlgxVYv9NlPOnV2/Y9dNGdXss8TViyin71ieg7GayeU2xMJ6VJQrjNz
 0/1pJVEothCarTAgIjcX77KZjFqW8HoMD1+lCf2dep3CYdepy/E5FVPrAe/fOeYEBqkFHLdEO
 YqY50VsyVY3nHNns76wFe3l7sAGhLFgGSdlvtnDm5FNfPZb2x2pg2W6nhfaZSD5Iynyjlg7h8
 9r7MGfoqguw8mdzWxTsf0F6yy/UcDw2CIPXTvRzAV5OfYbqNujNp1IRlQQkOEYGjdPiAczoMv
 kOBRtOXpeQG6UqwRfEJCjbHeXWRKxgVhsaF1RY7Hmzq3NquUp1twHEZpWMfqIc3ji148Fpt4E
 Y1FM7uGeudkL3+Tsx/L5xwfKB0kXAu/DdptJzhEnQb+y0juTXnZ5Cj5k4EjIvhGxQWWtza77l
 FohDZ5KPlj2qzFJkiD6svagg4mYjhMyaHh4aVOOO8lGtb18weCkknQB5RLVLIHpRsP13e2Hpm
 +wP9sGeJbEs2t5CilF5YI5TrY0qqN1GdHl2ROmjpCpG4k3qGCz2w9ZGEJdXuxQmeg+mFiEtPg
 Blnhcplnq6TQRVOgx9TCYbQkt1rq8nx7KrgR2bC4ZVcnoUxw8f7P3FoboMkkz7UGCC4JINBRT
 I0qB35kEpCCoB4d/CuCRwrt79l3YCYOi9Ur4JvOdrzpu0sh09saBRMozxQVmkjPejOlqxsbKn
 8jzhfP4kBH9IMAAZHEq6qzp+kaYZ092RFRGIJIWZTqn/lZn4qS4AWcQYyXMoqAjaG1DaFfOfw
 79eIPCfQPoA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/10 =E4=B8=8B=E5=8D=883:16, Nikolay Borisov wrote:
>
>
> On 10.04.19 =D0=B3. 10:11 =D1=87., Qu Wenruo wrote:
>>
>>
>> On 2019/4/10 =E4=B8=8B=E5=8D=883:01, Nikolay Borisov wrote:
>>>
>>>
>>> On 10.04.19 =D0=B3. 9:58 =D1=87., Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/4/10 =E4=B8=8B=E5=8D=882:51, Nikolay Borisov wrote:
>>>>>
>>>>>
>>>>> On 10.04.19 =D0=B3. 9:34 =D1=87., Qu Wenruo wrote:
>>>>>> Hi,
>>>>>>
>>>>>> As we have memleak.py in bcc tools, and it provides better info
>>>>>> including the calling stack, I'm wondering if we should replace cur=
rent
>>>>>> eb leakage check with bcc based one.
>>>>>>
>>>>>> Any idea on this?
>>>>>
>>>>> Why do you want to change it, given that the existing one is only
>>>>> activate if btrfs is compiled with debug enabled and is "seamless"?
>>>>
>>>> Well, I don't want to change that part, but to enhance it by external=
 tools.
>>>>
>>>> E.g, better call stack to mimic valgrind output. So when one develope=
r
>>>> caused some leakage,  he or she can locate the problem easier.
>>>>
>>>> Personally speaking, the external tool may be just an good enhancemen=
t,
>>>> but may not get much usage.
>>>
>>> How do you envision this bcc-based tool to work? Create a probe hooked
>>> up to eb alloc function which records allocated eb's, a probe on eb fr=
ee
>>> function and finally have another probe at module unload to check that
>>> all ebs are freed?
>>
>> hook to catch free_extent_buffer(), get_extent_buffer() (does the
>> function just get removed?) and alloc_extent_buffer(), passing all the
>> @bytenr and stack to user space.
>>
>> That's all needed to be done in kernel space.
>>
>> User space catch the bytenr and stack to match the refs increase and
>> decrease.
>> No hook is needed at modules unload.
>>
>> Each refs inc/dec will trigger a check. If one eb get refs =3D=3D 0, th=
en
>> it's removed from the list/dict/whatever the structure is called in
>> python, along with all its previous call stacks.
>>
>> If dec on an non-existing one, output the stack, this should be the sam=
e
>> behavior of current kernel.
>>
>> If any eb still has refs >0, output all the allocation stack, this the
>> enhanced behavior.
>>
>> It's users' response to ensure the tool is loaded/terminated at proper
>> timing, e.g. loaded before mounting the fs of interest and terminated
>> after the fs is unmounted.
>
> Such tool might indeed be useful, however it's going to be just a 3rd
> party tool. As such it's up to you whether you want to develop it and
> use or not and share it on github. However, the in-kernel infrastructure
> should stay untouched (although it's rather crude). Subsequently we
> might think about removing it.

Good, I'll just try to craft the tool, and see if the community wants it.

Thanks,
Qu
>
>>
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>  What
>>>>> are we going to gain by introducing yet another tool or replacing an
>>>>> existing infrastructure with bcc (or whatever) based one?
>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>
>>
