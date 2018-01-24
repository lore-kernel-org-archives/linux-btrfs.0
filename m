Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:45042 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932133AbeAXI4h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 03:56:37 -0500
Received: by mail-lf0-f48.google.com with SMTP id v188so4150191lfa.11
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 00:56:36 -0800 (PST)
Received: from [10.1.2.221] ([89.24.100.190])
        by smtp.googlemail.com with ESMTPSA id x186sm453918lfd.24.2018.01.24.00.56.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jan 2018 00:56:34 -0800 (PST)
Subject: Re: Can't mount (even in ro) after power outage - corrupt leaf,
 open_ctree failed
From: =?UTF-8?B?WmF0a292c2vDvSBEdcWhYW4=?= <msk.conf@gmail.com>
To: linux-btrfs@vger.kernel.org
References: <7ebd40d4-3eea-9ad7-492f-b5d22cf935b0@gmail.com>
 <CAJCQCtSRj1v-qksod3FetjVCutSL1MbLWdg1KSt1RsndJkTU=A@mail.gmail.com>
 <05babf08-00de-ae0f-06f3-546719674aa1@gmail.com>
 <CAJCQCtSkPTLJ0d94_HrNmr_g+1spOBXjS8EY1RkXnXf15wUKFw@mail.gmail.com>
 <CAJCQCtQ8n-MzjtHrbxYXiP03ypRf48NnqsfrqBn+0evC=HM_Ug@mail.gmail.com>
 <ed9f0354-3c83-ed11-4f42-881929524298@gmail.com>
Message-ID: <4a48db35-40c3-e640-9f1b-dfa1173f7024@gmail.com>
Date: Wed, 24 Jan 2018 09:56:32 +0100
MIME-Version: 1.0
In-Reply-To: <ed9f0354-3c83-ed11-4f42-881929524298@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, so I ended with btrfs restore, seems that all (or most important) 
files were restored.

Now looking for another reliable filesystem which will not unrecoverably 
die on power outage.

msk


Dňa 22. 1. 2018 o 10:14 Zatkovský Dušan napísal(a):
> Hi.
>
> Badblocks finished on both disks with no errors. The only messages 
> from kernel
> during night are 6x perf: interrupt took too long (2511 > 2500), 
> lowering kernel.perf_event_max_sample_rate to 79500
>
> root@nas:~# smartctl -l scterc /dev/sda
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-4-amd64] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> root@nas:~# smartctl -l scterc /dev/sdb
> smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-4-amd64] (local build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, 
> www.smartmontools.org
>
> SCT Error Recovery Control:
>            Read:     70 (7.0 seconds)
>           Write:     70 (7.0 seconds)
>
> root@nas:~# btrfs-debug-tree -t chunk /dev/sda4 | grep 'METADATA\|SYSTEM'
> incorrect offsets 13686 13622
>                 type METADATA|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>                 type SYSTEM|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>
> root@nas:~# btrfs-debug-tree -t chunk /dev/sdb4 | grep 'METADATA\|SYSTEM'
> incorrect offsets 13686 13622
>                 type METADATA|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>                 type SYSTEM|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>                 type METADATA|RAID1 num_stripes 2
>
> (still used "old" version of btrfs tools, working remotely now, I will 
> boot something newer when I will get access to that NAS at EOD)
>
> Thank you
> msk
>
>
> Dňa 22. 1. 2018 o 0:24 Chris Murphy napísal(a):
>> On Sun, Jan 21, 2018 at 4:13 PM, Chris Murphy 
>> <lists@colorremedies.com> wrote:
>>> On Sun, Jan 21, 2018 at 3:31 PM, msk conf <msk.conf@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> thank you for the reply.
>>>>
>>>>> What do you get for btrfs fi df /array
>>>>
>>>> Can't do that because filesystem is not mountable. I will get stats 
>>>> for '/'
>>>> filesystem instead (because '/array' is an empty directory - 
>>>> mountpoint on /
>>> Try
>>> $ sudo btrfs-debug-tree -t chunk /dev/mapper/first | grep 
>>> 'METADATA\|SYSTEM'
>>
>> You need to adapt that /dev/ node for your case, I just copy pasted
>> that from my setup. Anyway, that will look at the chunk tree and show
>> the profile for these chunk types.
>>
>>
>

