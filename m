Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:45689 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3CUTm1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 15:42:27 -0400
Message-ID: <514B62A4.1030201@profihost.ag>
Date: Thu, 21 Mar 2013 20:42:28 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Chris Mason <clmason@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <514ABEB8.3090104@profihost.ag> <20130321180020.30044.84729@localhost.localdomain> <967ED686-7E9C-4158-80A0-D58D18818BA2@profihost.ag> <20130321190249.30044.79438@localhost.localdomain>
In-Reply-To: <20130321190249.30044.79438@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, i've now upgraded to 3.9-rc3 same result.

rsync: rename 
"/mnt/.software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/.c2_ae.h.WEhLGP" 
-> 
".software/kernel/linux-3.9-rc3/drivers/infiniband/hw/amso1100/c2_ae.h": 
No space left on device (28)

# btrfs filesystem df /mnt/
Data: total=18.14TB, used=15.05TB
System, DUP: total=8.00MB, used=1.94MB
System: total=4.00MB, used=0.00
Metadata, DUP: total=23.98GB, used=17.98GB
Metadata: total=8.00MB, used=0.00

Stefan

Am 21.03.2013 20:02, schrieb Chris Mason:
> Quoting Stefan Priebe - Profihost AG (2013-03-21 14:35:59)
>> Hi Chris,
>>
>> Am 21.03.2013 um 19:00 schrieb Chris Mason <chris.mason@fusionio.com>:
>>
>>> Quoting Stefan Priebe - Profihost AG (2013-03-21 04:03:04)
>>>> Hi,
>>>>
>>>> while copying a 15GB file to my btrfs volume i'm getting "No space left
>>>> on device".
>>>>
>>>> Some information:
>>>>
>>>> # btrfs filesystem df /mnt/
>>>> Data: total=18.14TB, used=15.05TB
>>>> System, DUP: total=8.00MB, used=1.94MB
>>>> System: total=4.00MB, used=0.00
>>>> Metadata, DUP: total=23.98GB, used=17.97GB
>>>> Metadata: total=8.00MB, used=0.00
>>>>
>>>> # df -h
>>>> Filesystem             Size  Used Avail Use% Mounted on
>>>> /dev/mapper/raid54tb1   19T   16T  3,1T  84% /mnt
>>>>
>>>> # btrfs fi show
>>>> Label: none  uuid: fc23c4a8-a351-4c91-96a2-ee6abeffe59a
>>>>         Total devices 1 FS bytes used 15.07TB
>>>>         devid    1 size 18.19TB used 18.19TB path /dev/dm-3
>>>>
>>>> # btrfs fi balance start -dusage=5 /mnt/
>>>> Done, had to relocate 0 out of 18604 chunks
>>>>
>>>> What wrong here? What is about the last 3TB?
>>>
>>> Which kernel are you running?
>>>
>>> -chris
>>
>> vanilla 3.8.3.
>
> Ok, with the 3.9 merge window Josef changed how we do the reservations.
> Are you able to try a slightly more experimental kernel?
>
> -chris
>
