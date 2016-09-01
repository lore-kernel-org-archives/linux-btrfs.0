Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36228 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755163AbcIALRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 07:17:47 -0400
Received: by mail-it0-f51.google.com with SMTP id i184so61065343itf.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 04:17:46 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 15sm8593439itl.0.2016.09.01.04.17.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Sep 2016 04:17:44 -0700 (PDT)
Subject: Re: your mail
To: linux-btrfs@vger.kernel.org
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
Date: Thu, 1 Sep 2016 07:17:38 -0400
MIME-Version: 1.0
In-Reply-To: <20160901074415.pz32d72d4h6pk77t@invalid>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-01 03:44, M G Berberich wrote:
> Am Mittwoch, den 31. August schrieb Fennec Fox:
>> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37 UTC
>> 2016 x86_64 GNU/Linux
>> btrfs-progs v4.7
>>
>> Data, single: total=30.01GiB, used=18.95GiB
>> System, single: total=4.00MiB, used=16.00KiB
>> Metadata, single: total=1.01GiB, used=422.17MiB
>> GlobalReserve, single: total=144.00MiB, used=0.00B
>>
>> {02:50} Wed Aug 31
>> [fennectech@Titanium ~]$  sudo fstrim -v /
>> [sudo] password for fennectech:
>> Sorry, try again.
>> [sudo] password for fennectech:
>> /: 99.8 GiB (107167244288 bytes) trimmed
>>
>> {03:08} Wed Aug 31
>> [fennectech@Titanium ~]$  sudo fstrim -v /
>> [sudo] password for fennectech:
>> /: 99.9 GiB (107262181376 bytes) trimmed
>>
>>   I ran these commands minutes after echother ane each time it is
>> trimming the entire free space
>>
>> Anyone else seen this?   the filesystem is the root FS and is compressed
>
> You should be very happy that it is trimming at all. Typical situation
> on a used btrfs is
>
>   # fstrim -v /
>   /: 0 B (0 bytes) trimmed
>
> even if there is 33G unused space ob the fs:
>
>   # df -h /
>   Filesystem      Size  Used Avail Use% Mounted on
>   /dev/sda2        96G   61G   33G  66% /
>
I think you're using an old kernel, this has been working since at least 
4.5, but was broken in some older releases.

