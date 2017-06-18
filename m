Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36019 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752187AbdFRMiO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 08:38:14 -0400
Received: by mail-qk0-f179.google.com with SMTP id g83so17573839qkb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Jun 2017 05:38:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57be3486-3d00-44ab-d777-b05bc3e245d3@stroebel.fr>
References: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr> <57be3486-3d00-44ab-d777-b05bc3e245d3@stroebel.fr>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sun, 18 Jun 2017 15:37:32 +0300
Message-ID: <CAGqmi77oVBAwER_a18aMWX6Lq1ND_ZhZa1W5Rv396m1p4nTN0A@mail.gmail.com>
Subject: Re: Disk usage is more than double the snapshots exclusive data
To: Vianney Stroebel <vianney@stroebel.fr>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-18 15:28 GMT+03:00 Vianney Stroebel <vianney@stroebel.fr>:
> Wow, thank you so much for your detailed replies!
>
> It would be great if your explanations were included in the wiki.
>
> My backup script uses snapshot + rsync but I've just realized that a lot of
> data was duplicated (my script must have skipped the snapshotting part
> somehow).
>
> I've used "bedup" to deduplicate the data and it has saved more than 250 GB
> of duplicated data.
>
> Vianney

Looks like you didn't use rsync with --inplace
So rsync just replace whole changed file instead of true diff
(read rsync man for more info)

>
> On 15/06/2017 11:44, Vianney Stroebel wrote:
>>
>> On a backup drive for a home computer, disk usage as shown by 'btrfs fi
>> show'
>> is more than double the snapshots exclusive data as shown by "btrfs qgroup
>> show" (574 GB vs 265 GB).
>>
>> I've done a lot of research online and I couldn't find any answer to this
>> problem.
>>
>> Output of some commands:
>>
>> uname -a
>> Linux viybel-pc 4.10.0-22-generic #24-Ubuntu SMP Mon May 22 17:43:20 UTC
>> 2017
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> btrfs --version
>> btrfs-progs v4.9.1
>>
>> sudo btrfs fi show
>> Label: 'btrfs-backup'  uuid: 35905dc5-1400-4687-8be7-cf87d6ad0980
>>     Total devices 1 FS bytes used 573.89GiB
>>     devid    1 size 698.64GiB used 697.04GiB path /dev/sdb1
>>
>> btrfs fi df /mnt/btrfs-backup
>> Data, single: total=670.01GiB, used=564.26GiB
>> System, DUP: total=8.00MiB, used=112.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, DUP: total=13.50GiB, used=8.64GiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=512.00MiB, used=14.95MiB
>>
>> From https://github.com/agronick/btrfs-size (i.e. more readable "btrfs
>> qgroup
>> show")
>>
>> btrfs-size /mnt/btrfs-backup
>>
>> ==================================================================================================================================
>>
>> Snapshot / Subvolume                                               ID
>> Total
>>   Exclusive Data
>>
>> ==================================================================================================================================
>>
>> 10726 gen 216807 top level 5 path full/2016-06-19_12-32-01         10726
>> 208.68GB 208.68GB
>> 21512 gen 216853 top level 5 path full/2016-12-14_16-21-34         21512
>> 166.98GB 40.36GB
>> 23054 gen 216853 top level 5 path full/2017-03-03_08-47-00         23054
>> 154.79GB 7.53GB
>> 25451 gen 216856 top level 5 path full/2017-04-14_21-54-25         25451
>> 123.48GB 3.07GB
>> 26514 gen 216862 top level 5 path full/2017-05-02_14-58-09         26514
>> 123.70GB 5.03GB
>> 28499 gen 218095 top level 5 path full/2017-06-11_19-29-16         28499
>> 154.65GB 169.78MB
>> 28556 gen 218094 top level 5 path full/2017-06-13_03-15-00         28556
>> 154.88GB 403.89MB
>>
>> ==================================================================================================================================
>>
>>                                                                 Exclusive
>> Total: 265.23GB
>>
>> Feel free to ask me any question.
>>
>> Vianney
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
