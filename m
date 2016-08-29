Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36031 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932346AbcH2Ldy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 07:33:54 -0400
Received: by mail-wm0-f54.google.com with SMTP id q128so74497329wma.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 04:33:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com> <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 29 Aug 2016 14:33:12 +0300
Message-ID: <CAGqmi75sBZot6unB9eV_EgD7pmf0xTMkO0p6KDyY61axp98KPQ@mail.gmail.com>
Subject: Re: btrfs and systemd
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do you try: nofail,noauto,x-systemd.automount ?

2016-08-29 9:28 GMT+03:00 Stefan Priebe - Profihost AG <s.priebe@profihost.ag>:
> Hi Qu,
>
> Am 29.08.2016 um 03:48 schrieb Qu Wenruo:
>>
>>
>> At 08/29/2016 04:15 AM, Stefan Priebe - Profihost AG wrote:
>>> Hi,
>>>
>>> i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
>>> But this always fails with: "mounting timed out. Stopping." after 90s.
>>
>> 60TB is quite large, and under most case it will already cause mount
>> speed problem.
>>
>> In our test environment, filling a fs with 16K small files to 2T (just
>> 128K files)will already slow the mount process to 10s.
>>
>> For larger fs, or more specifically, large extent tree, will slow the
>> mount process obviously.
>>
>> The root fix will need a rework of extent tree.
>> AFAIK Josef is working on the rework.
>>
>> So the btrfs fix will need some time.
>
> thanks but i've no problem with the long mount time (in my case 6
> minutes) i'm just wondering how to live with it with systemd. As it
> always cancels the mount process after 90s and i see no fstab option to
> change this.
>
> Greets,
> Stefan
>
>>
>> Thanks,
>> Qu
>>>
>>> I can't find any fstab setting for systemd to higher this timeout.
>>> There's just  the x-systemd.device-timeout but this controls how long to
>>> wait for the device and not for the mount command.
>>>
>>> Is there any solution for big btrfs volumes and systemd?
>>>
>>> Greets,
>>> Stefan
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
