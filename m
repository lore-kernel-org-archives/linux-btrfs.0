Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E314C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 08:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE4D218C3
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 08:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="HKFt7JTM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfDFIoc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 04:44:32 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:58830 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfDFIoc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 04:44:32 -0400
Received: from [192.168.178.50] (ip5f5867e1.dynamic.kabel-deutschland.de [95.88.103.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id D12D448B5C26;
        Sat,  6 Apr 2019 11:44:29 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554540270;
        bh=3WGmiuxQVLamPlZ5ewFxL3rZJ3RFxPgEPa5k46bt908=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=HKFt7JTMSVzySAKOIgJ9hH2hY2a1+5obDyqkIxQuONSqbDdLusBzI9xH5C05Ts/Uu
         19WZKc1va26QC+UXk7zfLbOHRn8YJuDmXsAd8LqsRITmlv7aU0eGE57uJuQ+Pfp2Ls
         sdStVlLc7nZwUcYRTZGgFTKYb0AjyR7NfY01Cx2jHtIUdEB2zkVdig/mM0CTC4qy5C
         RlBw8y+TnRIpSQYTgRtNlDmGwZ9nwDAIrciwF0LWKh9Vv8wW2U8ppjD5NbdPrbwHrv
         k/pZ82MgFpimtFJGiOHeJ+FU6OsFprvhcXeSyaWvvgFI0Kr0fahjqwpf52O2kcGYp9
         g1N7JmldwkRQA==
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
 <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
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
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu>
Date:   Sat, 6 Apr 2019 10:44:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-06 09:45, Qu Wenruo:
> 
> 
> On 2019/4/6 下午3:16, Nik. wrote:
>>
>>
>> 2019-04-06 02:03, Qu Wenruo:
>>>
>>>
>>> On 2019/4/6 上午3:38, Nik. wrote:
>>>>
>>>>
>>>> 2019-04-05 10:15, Qu Wenruo:
>>>>>
>>>>>
>>>>> On 2019/4/5 下午3:41, Nik. wrote:
>>>>>>
>>>>>> Below is the stderr of both commands:
>>>>>>
>>>>>> # btrfs inspect dump-tree -t chunk /dev/md0>DT-chunk.log
>>>>>> # btrfs inspect dump-tree -t extent /dev/md0>DT-extent.log
>>>>>> ERROR: leaf 1894009225216 slot 30 pointer invalid, offset 146038
>>>>>> size 37
>>>>>> leaf data limit 16283
>>>>>> ERROR: skip remaining slots
>>>>>>
>>>>>> Since the output on stdout is pretty long even after gzip, I am
>>>>>> providing only the output of the first command as attachment. The
>>>>>> output
>>>>>> of the second command (25 MB after gzip -9) can be downloaded here:
>>>>>>
>>>>>> https://cloud.avgustinov.eu/index.php/s/AgbwWyCrbYjenq8
>>>>>
>>>>> Sorry, I should have use a more specific command to get a smaller
>>>>> output.
>>>>> But anyway, your output is good enough for me to craft the fix patch.
>>>>>
>>>>> Here is the dirty fix branch:
>>>>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_nik
>>>>>
>>>>> Compile the btrfs-progs as usual.
>>>>> Just a late hint, you can disable document/btrfs-convert to reduce the
>>>>> dependency:
>>>>> $ ./configure --disable-documentation --disable-convert
>>>>>
>>>>> Then, inside btrfs-progs directory, call:
>>>>> # ./btrfs-corrupt-block -X /dev/md0
>>>> incorrect offsets 15003 146075
>>>> Open ctree failed
>>>
>>> Oh, I forgot it's in extent tree, which may need to be read out at mount
>>> time.
>>>
>>> Just a new flag can handle it.
>>>
>>> The branch is updated, please check.
>>
>> New output:
>> Successfully repair tree block at 1894009225216
>>
>> # mount -t btrfs -o ro /dev/md0 /mnt/md0/
>> mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0,
>> missing codepage or helper program, or other error.
>>
>> # dmesg|tail
>> ...
>> [34848.784117] BTRFS info (device md0): disk space caching is enabled
>> [34848.954741] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0,
>> flush 0, corrupt 2181, gen 0
>> [34850.150789] BTRFS critical (device md0): corrupt leaf: root=1
>> block=1894009225216 slot=30, unexpected item end, have 131072 expect 15003
>> [34850.151209] BTRFS error (device md0): failed to read block groups: -5
>> [34850.196156] BTRFS error (device md0): open_ctree failed
>>
>> It seems that there is improvement...
> 
> Debug info added.
> 
> Please try again, and sorry for the inconvenience. Hopes this is the
> last try.

#sudo ./btrfs-corrupt-block -X /dev/md0
old offset=131072 len=0
new offset=0 len=0
Successfully repair tree block at 1894009225216
# mount -t btrfs -o ro /dev/md0 /mnt/md0/
mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0, 
missing codepage or helper program, or other error.
root@bach:~# dmesg|tail
...
[39342.860715] BTRFS info (device md0): disk space caching is enabled
[39342.933380] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0, 
flush 0, corrupt 2181, gen 0
[39344.197411] BTRFS critical (device md0): corrupt leaf: root=1 
block=1894009225216 slot=30, unexpected item end, have 0 expect 15003
[39344.197915] BTRFS error (device md0): failed to read block groups: -5
[39344.248137] BTRFS error (device md0): open_ctree failed

Sorry, I forgot to tell: this and previous attempt were with kernel 
4.15.0-47-generic. My Ubuntu 18.04 LTS is having enormous problems with 
Kernel 5.0.2 - very long boot; network, login and other services cycling 
trough "start, timeout, fail, stop" again and again, etc. If kernel 5 is 
important I will need time to get it right (maybe even assistance from 
another(?) developer group).
Actually with 5.0.2 each boot sends me an email about an empty and not 
automatically mounted btrfs filesystem with raid1 profile, consisting 
from two devices (sdb and sdi):

kernel: [    9.625619] BTRFS: device fsid 
05bd214a-8961-4165-9205-a5089a65b59b devid 2 transid 832 /dev/sdi

Scrubbing it finishes almost immediately (see below), but during next 
boot the email comes again:

#btrfs scrub status /mnt/b
scrub status for 05bd214a-8961-4165-9205-a5089a65b59b
         scrub started at Sat Apr  6 10:42:15 2019 and finished after 
00:00:00
         total bytes scrubbed: 1.51MiB with 0 errors

Should I be worried about it?

Kind regards,
Nik.
--

> Thanks,
> Qu
>>
>> Thank you.
>> Nik.
>> -- 
>>
>>> Thanks,
>>> Qu
>>>
>>>>
>>>> Actually there was one warning during make, I don't know of it is
>>>> relevant:
>>>>       [CC]     check/main.o
>>>> check/main.c: In function ‘try_repair_inode’:
>>>> check/main.c:2688:5: warning: ‘ret’ may be used uninitialized in this
>>>> function [-Wmaybe-uninitialized]
>>>>     if (!ret) {
>>>>        ^
>>>> check/main.c:2666:6: note: ‘ret’ was declared here
>>>>     int ret;
>>>>         ^~~
>>>>
>>>> The previous steps were as follow (output ommited, since nothing
>>>> unexpected happened):
>>>> #git clone --single-branch -v -b dirty_fix_for_nik
>>>> https://github.com/adam900710/btrfs-progs.git
>>>> #cd btrfs-progs/
>>>> #./autogen.sh
>>>> #./configure --disable-documentation --disable-convert
>>>> #make
>>>>
>>>> Did I got the right branch? Or miss any step?
>>>>
>>>> Kind regards,
>>>> Nik.
>>>> -- 
>>>>
>>>>> If everything goes correctly, it should output something like:
>>>>>      Successfully repaired tree block at 1894009225216
>>>>> (And please ignore any grammar error in my code)
>>>>>
>>>>> After that, please run a "btrfs check --readonly" to ensure no other
>>>>> bit
>>>>> flip in your fs.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> Hope this is ok.
>>>>>>
>>>>>> Regards,
>>>>>> Nik.
>>>>>> -
>>>>>
>>>
> 
