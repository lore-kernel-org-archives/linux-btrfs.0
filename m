Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:49358 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdISTUC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 15:20:02 -0400
Received: by mail-it0-f52.google.com with SMTP id w204so553139itc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 12:20:02 -0700 (PDT)
Subject: Re: Storage and snapshots as historical yearly
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        =?UTF-8?Q?Sen=c3=a9n_Vidal_Blanco?= <senenvidal@sgisoft.com>
Cc: linux-btrfs@vger.kernel.org
References: <9208764.SjP1vfhOIA@pcsenen>
 <aebb8966-ca9b-7008-d329-3e60989a5c01@gmail.com> <2457840.3HpkerP4PG@pcsenen>
 <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7653471f-72b9-c1c2-6783-85fba1f61ffe@gmail.com>
Date: Tue, 19 Sep 2017 15:19:56 -0400
MIME-Version: 1.0
In-Reply-To: <d83f3017-ded3-fabf-856c-95e6d71747e2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-19 14:33, Andrei Borzenkov wrote:
> 19.09.2017 14:49, Senén Vidal Blanco пишет:
>> Perfect!! Just what I was looking for.
>> Sorry for the delay, because before doing so, I preferred to test to see if it
>> actually worked.
>>
>> I have a doubt. The system works perfectly, but at the time of deleting the
>> writing disk and merging the data on the read-only disk I fail to understand
>> the process.
>>
>> I have tried to remove the seed bit on disk A and delete the write B as you
>> mention, and so move the data to A, but tells me that disk B does not exist.
>> These are the orders I have made:
>>
>> md127-> A
>> md126-> B
>>
>> btrfstune -S 0 /dev /md127
>> mount /dev/md127 /mnt (I mount this disk since the md126 gives error)
>> btrfs device delete /dev/md126 /mnt
>> ERROR: error removing device '/dev/md126': No such file or directory
>>
>> Another thing I've tried is to remove disk B without removing the seed bit,
>> but it gives me the error:
>>
>> ERROR: error removing device '/dev/md126': unable to remove the only writeable
>> device.
>>
>> Any ideas about it?
> 
> Yes, sorry about it. Clearing seed flag on device invalidates
> filesystem. What you can do, is to rotate devices. I.e. remove
> /dev/md126, set seed flag on md127 and add md126 back.
> 
> I actually tested it and it works for me.
Same.  FWIW, this (like many other things in BTRFS) could stand to be 
better documented, especially since it's not likely to be intuitive for 
most people.
> 
>> Thank you very much for the reply.
>> Greetings.
>>
>> El martes, 12 de septiembre de 2017 6:34:15 (CEST) Andrei Borzenkov escribió:
>>> 11.09.2017 21:17, Senén Vidal Blanco пишет:
>>>> I am trying to implement a system that stores the data in a unit (A) with
>>>> BTRFS format that is untouchable and that future files and folders created
>>>> or modified are stored in another physical unit (B) with BTRFS format.
>>>> Each year the new files will be moved to store A and start over.
>>>>
>>>> The idea is that a duplicate of disk A can be made to keep it in a safe
>>>> place and that the files stored there can not be modified until the
>>>> mixture of (A) and (B) is made.
>>>
>>> This can probably be achieved using seed device. Mark original device as
>>> seed and all changes will go to another writable device, similar to
>>> overlay; then remove seed bit from original device, "btrfs device remove
>>> writable" device and it should relocate its content back. Rinse and repeat.
>>
> 
> 

