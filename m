Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F47C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 861BF20879
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 07:17:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="B1DhIWQD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfDFHRD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 03:17:03 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:58320 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfDFHRC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 03:17:02 -0400
Received: from [192.168.178.50] (ip5f5867e1.dynamic.kabel-deutschland.de [95.88.103.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id BF55B48B221A;
        Sat,  6 Apr 2019 10:16:59 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554535020;
        bh=EMgrbPNWHaIMHzuOITbz+pUKbwbEFRmpxdwz0lHCcSc=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=B1DhIWQDU7u/TQV+UsBL+oChuATM35G2KCjO6RcKaBmOZPS9QK8JgUywC63o/6Uc2
         PYQx7JJSBYZXbZ0DSyCgKyOvPDos9xsZb7Pv1w84Nhu3hvkaLzM4Ai5e4/oDoWTqlk
         /LPaFmwMZOdcl9reXfETTvdgwUD7WG/7gbWyHIM4LQxzzfop7iqVXBcAzTJCwJOdFx
         /QWO6iTDj3fu1f/xx4/ppT+TTNSsRPWX4Hb2lXkNpFGjV7L8ve4F3PGjcE25pgMLQ+
         6d9x8Zqq2v8fTBVp7zorEnwsgoYhFEGmBS6zr/pZf2nf8zvGOgIMLOAQYFvrTTBLRm
         p4VMzyGVeCOpg==
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
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu>
Date:   Sat, 6 Apr 2019 09:16:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-1901
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-06 02:03, Qu Wenruo:
> 
> 
> On 2019/4/6 上午3:38, Nik. wrote:
>>
>>
>> 2019-04-05 10:15, Qu Wenruo:
>>>
>>>
>>> On 2019/4/5 下午3:41, Nik. wrote:
>>>>
>>>> Below is the stderr of both commands:
>>>>
>>>> # btrfs inspect dump-tree -t chunk /dev/md0>DT-chunk.log
>>>> # btrfs inspect dump-tree -t extent /dev/md0>DT-extent.log
>>>> ERROR: leaf 1894009225216 slot 30 pointer invalid, offset 146038 size 37
>>>> leaf data limit 16283
>>>> ERROR: skip remaining slots
>>>>
>>>> Since the output on stdout is pretty long even after gzip, I am
>>>> providing only the output of the first command as attachment. The output
>>>> of the second command (25 MB after gzip -9) can be downloaded here:
>>>>
>>>> https://cloud.avgustinov.eu/index.php/s/AgbwWyCrbYjenq8
>>>
>>> Sorry, I should have use a more specific command to get a smaller output.
>>> But anyway, your output is good enough for me to craft the fix patch.
>>>
>>> Here is the dirty fix branch:
>>> https://github.com/adam900710/btrfs-progs/tree/dirty_fix_for_nik
>>>
>>> Compile the btrfs-progs as usual.
>>> Just a late hint, you can disable document/btrfs-convert to reduce the
>>> dependency:
>>> $ ./configure --disable-documentation --disable-convert
>>>
>>> Then, inside btrfs-progs directory, call:
>>> # ./btrfs-corrupt-block -X /dev/md0
>> incorrect offsets 15003 146075
>> Open ctree failed
> 
> Oh, I forgot it's in extent tree, which may need to be read out at mount
> time.
> 
> Just a new flag can handle it.
> 
> The branch is updated, please check.

New output:
Successfully repair tree block at 1894009225216

# mount -t btrfs -o ro /dev/md0 /mnt/md0/
mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0, 
missing codepage or helper program, or other error.

# dmesg|tail
...
[34848.784117] BTRFS info (device md0): disk space caching is enabled
[34848.954741] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0, 
flush 0, corrupt 2181, gen 0
[34850.150789] BTRFS critical (device md0): corrupt leaf: root=1 
block=1894009225216 slot=30, unexpected item end, have 131072 expect 15003
[34850.151209] BTRFS error (device md0): failed to read block groups: -5
[34850.196156] BTRFS error (device md0): open_ctree failed

It seems that there is improvement...

Thank you.
Nik.
--

> Thanks,
> Qu
> 
>>
>> Actually there was one warning during make, I don't know of it is relevant:
>>      [CC]     check/main.o
>> check/main.c: In function ‘try_repair_inode’:
>> check/main.c:2688:5: warning: ‘ret’ may be used uninitialized in this
>> function [-Wmaybe-uninitialized]
>>    if (!ret) {
>>       ^
>> check/main.c:2666:6: note: ‘ret’ was declared here
>>    int ret;
>>        ^~~
>>
>> The previous steps were as follow (output ommited, since nothing
>> unexpected happened):
>> #git clone --single-branch -v -b dirty_fix_for_nik
>> https://github.com/adam900710/btrfs-progs.git
>> #cd btrfs-progs/
>> #./autogen.sh
>> #./configure --disable-documentation --disable-convert
>> #make
>>
>> Did I got the right branch? Or miss any step?
>>
>> Kind regards,
>> Nik.
>> -- 
>>
>>> If everything goes correctly, it should output something like:
>>>     Successfully repaired tree block at 1894009225216
>>> (And please ignore any grammar error in my code)
>>>
>>> After that, please run a "btrfs check --readonly" to ensure no other bit
>>> flip in your fs.
>>>
>>> Thanks,
>>> Qu
>>>
>>>
>>>
>>>>
>>>> Hope this is ok.
>>>>
>>>> Regards,
>>>> Nik.
>>>> -
>>>
> 
