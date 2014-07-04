Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56671 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDC0A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 22:26:00 -0400
Received: by mail-ie0-f178.google.com with SMTP id rl12so1070621iec.23
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 19:25:59 -0700 (PDT)
Message-ID: <53B610B6.8020704@gmail.com>
Date: Thu, 03 Jul 2014 21:25:58 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Quota Ignored On write
References: <53B60DE1.9070905@gmail.com> <53B60F91.9070004@jp.fujitsu.com>
In-Reply-To: <53B60F91.9070004@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.15.3 via arch/ and from linux-git

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
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

