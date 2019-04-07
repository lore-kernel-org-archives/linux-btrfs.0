Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8848BC10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1C4021738
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 07:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="T4x6kqia"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbfDGHmD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 03:42:03 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:39602 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfDGHmD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 03:42:03 -0400
Received: from [192.168.178.50] (ip5f5867e1.dynamic.kabel-deutschland.de [95.88.103.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id 28D3948EFC30;
        Sun,  7 Apr 2019 10:42:00 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554622920;
        bh=YFDfnc3HjI256FkUVKRv8SA4jjJE8pBDXni9SZQUFug=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=T4x6kqiaUvRbIArgGFBcsLyGi14LNimf8JpHd0xlfKYBLG3J5/cItiJQOnvEolmo2
         1Y0BX9OLddGp5OU2GKSdzJHhi7eOqJWG6utLqm6Va78UC9WfPD0zhN26+tN2yRGLMa
         oYFDmv3t3qqIbIq1JGTw4ikouTwkdhxuWEwDOypG5ML9YL9/VW1iD9E1ocxBRfMl/8
         8FQ/d/ii0ppPio1LTEr29naPhBOGztH4WvTmgowNkUeP4rF6u6tdjGzZIAjbGQn/vB
         QfR/qMiBCfjD36pNGFhvhl3Sam0swdnHw61QRgoJ20JN4BoWAFuejNI4aWH+oMwLZn
         esdR3MxnZNn2w==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu>
 <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu>
 <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
 <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu>
 <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu>
 <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
 <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
 <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu>
 <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu>
 <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
Date:   Sun, 7 Apr 2019 09:41:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-07 01:18, Qu Wenruo:
> 
> 
> On 2019/4/6 下午10:19, Nik. wrote:
>>
>>
>> 2019-04-06 15:22, Qu Wenruo:
>>>
>>>
>>> On 2019/4/6 下午9:20, Nik. wrote:
>>>>
>>>>
>>>> 2019-04-06 11:06, Qu Wenruo:
>>>>>>>
>>>>>>> Please try again, and sorry for the inconvenience. Hopes this is the
>>>>>>> last try.
>>>>>>
>>>>>> #sudo ./btrfs-corrupt-block -X /dev/md0
>>>>>> old offset=131072 len=0
>>>>>> new offset=0 len=0
>>>>>
>>>>> My bad, the first fix is bad, leading the bad result.
>>>>>
>>>>> (And that's why we need to review patches)
>>>>>
>>>>> Fortunately we have everything we need to manually set the value, no
>>>>> magic any more.
>>>>
>>>> So I gues the next steps were git fetch, make and run again the above
>>>> two commands:
>>>>
>>>> #git fetch
>>>>   From https://github.com/adam900710/btrfs-progs
>>>>    + c7bfe8cc...a8c26abd dirty_fix_for_nik -> origin/dirty_fix_for_nik
>>>> (forced update)
>>>
>>> It looks like you haven't checked out to the correct branch.
>>>
>>> You could use command 'git checkout origin/dirty_fix_for_nik' to change
>>> to the latest branch.
>>
>> Sorry about this. Once again:
>>
>> #git checkout origin/dirty_fix_for_nik
>> HEAD is now at a8c26abd btrfs-progs: corrupt-block: Manually fix bit
>> flip for Nik.
>> # make
>>      [PY]     libbtrfsutil
>>
>> #./btrfs-corrupt-block -X /dev/md0
>> old offset=0 len=0
>> new offset=14966 len=37
>> Successfully repair tree block at 1894009225216
>>
>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,
>> missing codepage or helper program, or other error.
>>
>> root@bach:~# dmesg|tail
>> ...
>> [59138.540585] BTRFS info (device md0): disk space caching is enabled
>> [59138.697727] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,
>> flush 0, corrupt 2181, gen 0
>> [59139.944682] BTRFS critical (device md0): corrupt leaf: root=1
>> block=1894009225216 slot=83, bad key order, prev (564984271564800 168
>> 962560) current (2034319192064 168 262144)
> 
> Now it's a different problem at different slot.
> 
> slot 82 has key (0x201d9a6cf7000, 168, 962560)
> slot 83 has key (0x001d9a6df7000, 168, 262144)
> 
> You have 2 bits flipped just in one tree block!
> 
> Anyway, I have updated the branch, and please try it again.
> 
> Thanks,
> Qu

#./btrfs-corrupt-block -X /dev/md0
old key = 564984271564800, 168, 962560
new key = 2034318143488, 168, 962560
Successfully repair tree block at 1894009225216

# mount -t btrfs -o ro /dev/md0 /mnt/md0/
mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0, 
missing codepage or helper program, or other error.

# dmesg|tail
...
[111221.376675] md: md0: data-check done.
[122291.559537] BTRFS info (device md0): disk space caching is enabled
[122291.704292] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0, 
flush 0, corrupt 2181, gen 0
[122293.101782] BTRFS critical (device md0): corrupt leaf: root=1 
block=1894009225216 slot=82, bad key order, prev (2034321682432 168 
262144) current (2034318143488 168 962560)
[122293.102334] BTRFS error (device md0): failed to read block groups: -5
[122293.156546] BTRFS error (device md0): open_ctree failed

If the data-tree structures alone have so many bits flipped, how much 
flipped bits are to be expected in the data itself? What should a normal 
btrfs user do in order to prevent such disasters?
And another thing: if I am getting it right, it should have been more 
reliable/appropriate to let btrfs manage the five disks behind the md0 
with a raid1 profile instead binding them in a RAID5 and "giving" just a 
single device to btrfs.

Kind regards,
Nik.
--

> 
> 
>> [59139.945109] BTRFS error (device md0): failed to read block groups: -5
>> [59139.984122] BTRFS error (device md0): open_ctree failed
>>
>> Kind regards,
>> Nik.
>> --
>>
>>> Thanks,
>>> Qu
>>>
>>>> #make
>>>>       [PY]     libbtrfsutil
>>>>
>>>> #./btrfs-corrupt-block -X /dev/md0
>>>> old offset=0 len=0
>>>> new offset=0 len=0
>>>> Successfully repair tree block at 1894009225216
>>>>
>>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,
>>>> missing codepage or helper program, or other error.
>>>>
>>>> # dmesg|tail
>>>> ...
>>>> [56146.672395] BTRFS info (device md0): disk space caching is enabled
>>>> [56146.841632] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,
>>>> flush 0, corrupt 2181, gen 0
>>>> [56148.097242] BTRFS critical (device md0): corrupt leaf: root=1
>>>> block=1894009225216 slot=30, unexpected item end, have 0 expect 15003
>>>> [56148.097583] BTRFS error (device md0): failed to read block groups: -5
>>>> [56148.140137] BTRFS error (device md0): open_ctree failed
>>>>
>>>> If the above steps were wrong - please, correct!
>>>>
>>>>> The only uncertain part is the size.
>>>>> If mount still fails, dmesg will tell me the size I need.
>>>>>
>>>>>
>>>>>> Successfully repair tree block at 1894009225216
>>>>>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>>>>>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on
>>>>>> /dev/md0,
>>>>>> missing codepage or helper program, or other error.
>>>>>> root@bach:~# dmesg|tail
>>>>>> ...
>>>>>> [39342.860715] BTRFS info (device md0): disk space caching is enabled
>>>>>> [39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0,
>>>>>> rd 0,
>>>>>> flush 0, corrupt 2181, gen 0
>>>>>> [39344.197411] BTRFS critical (device md0): corrupt leaf: root=1
>>>>>> block=1894009225216 slot=30, unexpected item end, have 0 expect 15003
>>>>>> [39344.197915] BTRFS error (device md0): failed to read block
>>>>>> groups: -5
>>>>>> [39344.248137] BTRFS error (device md0): open_ctree failed
>>>>>>
>>>>>> Sorry, I forgot to tell: this and previous attempt were with kernel
>>>>>> 4.15.0-47-generic.
>>>>>
>>>>> As long as it can output above message, the kernel version doesn't make
>>>>> much difference.
>>>>>
>>>>>
>>>>>> My Ubuntu 18.04 LTS is having enormous problems with
>>>>>> Kernel 5.0.2 - very long boot; network, login and other services
>>>>>> cycling
>>>>>> trough "start, timeout, fail, stop" again and again, etc. If kernel
>>>>>> 5 is
>>>>>> important I will need time to get it right (maybe even assistance from
>>>>>> another(?) developer group).
>>>>>> Actually with 5.0.2 each boot sends me an email about an empty and not
>>>>>> automatically mounted btrfs filesystem with raid1 profile, consisting
>>>>>> from two devices (sdb and sdi):
>>>>>>
>>>>>> kernel: [    9.625619] BTRFS: device fsid
>>>>>> 05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi
>>>>>>
>>>>>> Scrubbing it finishes almost immediately (see below), but during next
>>>>>> boot the email comes again:
>>>>>>
>>>>>> #btrfs scrub status /mnt/b
>>>>>> scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
>>>>>>            scrub started at Sat Apr  6 10:42:15 2019 and finished after
>>>>>> 00:00:00
>>>>>>            total bytes scrubbed: 1.51MiB with 0 errors
>>>>>>
>>>>>> Should I be worried about it?
>>>>>
>>>>> You could try btrfs check --readonly and see what's going on.
>>>>> If btrfs check --readonly is OK, then it should be mostly OK.
>>>>
>>>> Then it seems to be ok, thank you!
>>>>
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>>>
>>>>>> Kind regards,
>>>>>> Nik.
>>>>>> -- 
>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>>>
>>>>>>>> Thank you.
>>>>>>>> Nik.
>>>>>>>> -- 
>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> Qu
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Actually there was one warning during make, I don't know of it is
>>>>>>>>>> relevant:
>>>>>>>>>>          [CC]     check/main.o
>>>>>>>>>> check/main.c: In function ‘try_repair_inode’:
>>>>>>>>>> check/main.c:2688:5: warning: ‘ret’ may be used uninitialized in
>>>>>>>>>> this
>>>>>>>>>> function [-Wmaybe-uninitialized]
>>>>>>>>>>        if (!ret) {
>>>>>>>>>>           ^
>>>>>>>>>> check/main.c:2666:6: note: ‘ret’ was declared here
>>>>>>>>>>        int ret;
>>>>>>>>>>            ^~~
>>>>>>>>>>
>>>>>>>>>> The previous steps were as follow (output ommited, since nothing
>>>>>>>>>> unexpected happened):
>>>>>>>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>>>>>>>> https://github.com/adam900710/btrfs-progs.git
>>>>>>>>>> #cd btrfs-progs/
>>>>>>>>>> #./autogen.sh
>>>>>>>>>> #./configure --disable-documentation --disable-convert
>>>>>>>>>> #make
>>>>>>>>>>
>>>>>>>>>> Did I got the right branch? Or miss any step?
>>>>>>>>>>
>>>>>>>>>> Kind regards,
>>>>>>>>>> Nik.
>>>>>>>>>> -- 
>>>>>>>>>>
>>>>>>>>>>> If everything goes correctly, it should output something like:
>>>>>>>>>>>         Successfully repaired tree block at 1894009225216
>>>>>>>>>>> (And please ignore any grammar error in my code)
>>>>>>>>>>>
>>>>>>>>>>> After that, please run a "btrfs check --readonly" to ensure no
>>>>>>>>>>> other
>>>>>>>>>>> bit
>>>>>>>>>>> flip in your fs.
>>>>>>>>>>>
>>>>>>>>>>> Thanks,
>>>>>>>>>>> Qu
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Hope this is ok.
>>>>>>>>>>>>
>>>>>>>>>>>> Regards,
>>>>>>>>>>>> Nik.
>>>>>>>>>>>> -
>>>>>>>>>>>
>>>>>>>>>
>>>>>>>
>>>>>
>>>
