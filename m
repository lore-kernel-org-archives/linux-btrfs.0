Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58159 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbaGDCfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:35:31 -0400
Received: by mail-ig0-f175.google.com with SMTP id h3so8334025igd.14
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 19:35:30 -0700 (PDT)
Message-ID: <53B612F1.1030701@gmail.com>
Date: Thu, 03 Jul 2014 21:35:29 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Quota Ignored On write
References: <53B60DE1.9070905@gmail.com> <53B60F91.9070004@jp.fujitsu.com>
In-Reply-To: <53B60F91.9070004@jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hmm, is it possible that btrfs is doing some deduplication or compression?
The expected behavior works fine with small quotas like 10/20MB
but at 1GB i can overwrite quite a bit from /dev/zero
I also tried to dd from /dev/urandom (to get some variety other than zeros)
dd if=/dev/urandom of=meow bs=1024 count=1500000
output:
dd: error writing ‘meow’: Disk quota exceeded
1163330+0 records in
1163329+0 records out
1191248896 bytes (1.2 GB) copied, 110.25 s, 10.8 MB/s

So it looks like its stopping the write, but with a 1GB quota, thats a
20% over quota

-Kevin

On 07/03/2014 09:21 PM, Satoru Takeuchi wrote:
> Hi Kevin,
>
> (2014/07/04 11:13), Kevin Brandstatter wrote:
>> basing of the latest for-linus branch i found i can write way more than
>> the quota
>>
>> btrfs quota enable
>> btrfs subvolume create test
>> btrfs qgruop limit 1G test
>> dd if=/dev/zero of=test/file bs=1024 count=1500000
>> output:
>> 1500000+0 records in
>> 1500000+0 records out
>> 1536000000 bytes (1.5 GB) copied, 5.91909 s, 259 MB/s
>>
>> thats a full half gig over the quota limit. I noticed some changes to
>> the quota
>> accounting in the logs, what changed that could cause this?
>
> Do you remember what kernel version quota worked correctly?
>
> Thanks,
> Satoru
>
>>
>> -Kevin Brandstatter
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>

