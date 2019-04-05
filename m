Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F572C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1947217D7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=avgustinov.eu header.i=@avgustinov.eu header.b="Ui4YV4/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbfDEG7A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:59:00 -0400
Received: from cloud.avgustinov.eu ([62.73.84.164]:47796 "EHLO
        cloud.avgustinov.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDEG67 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 02:58:59 -0400
Received: from [192.168.178.50] (ip5f5867e1.dynamic.kabel-deutschland.de [95.88.103.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by cloud.avgustinov.eu (Postfix) with ESMTPSA id B48444874C0A;
        Fri,  5 Apr 2019 09:58:57 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=avgustinov.eu;
        s=default; t=1554447538;
        bh=8nhgFVAbTeSUUmZVB2HDV9hGO1UtRPfg6O4G6QqmBVA=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=Ui4YV4/ZIxidZWCKK6VaZnhcLWfFcjT/rdSyrzp9yFqoRMArZrbLwSVk9FklgJYZe
         9kq/9tuaKnI0lHNOTsozc82M86kINpuZwI8gjl4RrvXz/tWZo3JVU5E5RsHSTwtVGj
         puDA2+9Y3TKWrFdLXmvyjmGowVJHKYqmQqefTJo4fHpd9EsP2M1RO4sLOv2CF9Hl/h
         CFuiwKIhG9FYHVRSIQS8rgnhvxVS7NnMfFfYeQlFXFKbL11bCW5g9cWUFR59H76hyr
         BUwZcRuQOI9m4CePWEztkmu6kpurXsAjRa2VtummAS0/voQeVgPXsCXNbpYfSquKRy
         REDXG1KAi8+9g==
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
From:   "Nik." <btrfs@avgustinov.eu>
Message-ID: <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu>
Date:   Fri, 5 Apr 2019 08:58:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-1901
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



2019-04-05 02:47, Qu Wenruo:
> 
> 
> On 2019/4/4 下午11:27, Nik. wrote:
>>
>>
>> 2019-04-03 03:04, Qu Wenruo:
>>>
>>
>> [snip]
>> ...
>>
>>>>> In your case, you just need latest btrfs-progs and re-run "btrfs check
>>>>> --readonly" on it.
>>>>
>>>> Will try this, but have no time before tomorrow evening.
>>>>
>>>>
>>>>> If it just shows the same result, meaning I can't get the info about
>>>>> which tree block is corrupted, then you could try to mount it with
>>>>> -o ro
>>>>> using *LATEST* kernel.
>>>>
>>>> I tried this before with the 4.15.0-46 kernel, it was impossible. Will
>>>> try again with newer one as soon as possible (in best case tomorrow
>>>> evening); I will post the results.
>>
>> Sorry for the delay, compiling the btrfs-progs took much more time than
>> expected (had to install new packages again and again). Finally had to
>> give up the conversion ("make" could not find reiserfs/misc.h, although
>> both libreiserfscore and reiser4fs are installed).
>> Output of the commands:
>> # uname -r
>> 5.0.6-050006-generic
>> #btrfs --version
>> btrfs-progs v4.20.2
>> # btrfs check --readonly /dev/md0
>> Opening filesystem to check...
>> incorrect offsets 15003 146075
>> ERROR: cannot open file system
>>
>> It seems that I will wait until 5.2 is out...
>> (the answer to Jeff Mahoney is coming with separate e-mail!)
> 
> OK, then you can try mount it with 5.0 with -o ro.

# mount -t btrfs -o ro /dev/md0 /mnt/md0/
mount: /mnt/md0: wrong fs type, bad option, bad superblock on /dev/md0, 
missing codepage or helper program, or other error.

> The objective is not to make it work, but to get the dmesg, which should

# dmesg|tail
[65283.442278] audit: type=1107 audit(1554438151.396:115): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='Unknown class service 
exe="/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
[72504.975359] audit: type=1107 audit(1554445372.928:116): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='Unknown class service 
exe="/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
[72535.214394] audit: type=1107 audit(1554445403.166:117): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='Unknown class service 
exe="/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
[72535.257571] audit: type=1107 audit(1554445403.210:118): pid=1 uid=0 
auid=4294967295 ses=4294967295 subj=kernel msg='Unknown class system 
exe="/lib/systemd/systemd" sauid=0 hostname=? addr=? terminal=?'
[73427.486853] BTRFS info (device md0): disk space caching is enabled
[73427.938260] BTRFS info (device md0): bdev /dev/md0 errs: wr 0, rd 0, 
flush 0, corrupt 2181, gen 0
[73429.172707] BTRFS critical (device md0): corrupt leaf: root=2 
block=1894009225216 slot=30, unexpected item end, have 146075 expect 15003
[73429.176628] BTRFS critical (device md0): corrupt leaf: root=2 
block=1894009225216 slot=30, unexpected item end, have 146075 expect 15003
[73429.177153] BTRFS error (device md0): failed to read block groups: -5
[73429.197019] BTRFS error (device md0): open_ctree failed


> contain the tree block bytenr, so that we can try to fix that offending
> tree block manually.
> 
> Thanks,
> Qu

Should I try something alse?
Thank you!
Nik.
--
> 
>>
>>>>> Latest kernel will report anything wrong pretty vocally, in that case,
>>>>> dmesg would include the bytenr of corrupted tree block.
>>>>>
>>>>> Then I could craft needed commands to further debug the fs.
>>>>
>>>> Ok, I will try to post more info tomorrow about this time.
>>>>
>>>> Nik.
>>>> -- 
>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> Thank you for trying to improve btrfs!
>>>>>>
>>>>>> Nik.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Qu
>>>>>>
>>>>>> You are not from the 007 - lab, are you? ;-)
>>>>>>
>>>>>>>>
>>>>>>>> Kind regards,
>>>>>>>>
>>>>>>>> Nik.
>>>>>>>
>>>>>
>>>
> 
