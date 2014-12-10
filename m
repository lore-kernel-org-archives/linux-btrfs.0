Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f169.google.com ([209.85.160.169]:48891 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593AbaLJPCQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 10:02:16 -0500
Received: by mail-yk0-f169.google.com with SMTP id 79so1304964ykr.0
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 07:02:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
References: <B3CDA0F0-14F7-4539-B7FF-B2D2E5F7CAF2@colorremedies.com>
	<1418124037-8210-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<548743CE.1020403@inwind.it>
	<54879CFE.1090909@cn.fujitsu.com>
	<54882634.4000809@pobox.com>
	<pan$5a1c1$2e13a998$8c1ffe18$ead381f2@cox.net>
Date: Wed, 10 Dec 2014 23:02:15 +0800
Message-ID: <CA+qeAOo4NT5NEO97YJMq-asQVm4OZUdJECqqojTzjhmso_Jj4Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: get more accurate output in fd command.
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 10, 2014 at 9:21 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Robert White posted on Wed, 10 Dec 2014 02:53:40 -0800 as excerpted:
>
>> On 12/09/2014 05:08 PM, Dongsheng Yang wrote:
>>> On 12/10/2014 02:47 AM, Goffredo Baroncelli wrote:
>>>> Hi Dongsheng On 12/09/2014 12:20 PM, Dongsheng Yang wrote:
>>>>> When function btrfs_statfs() calculate the tatol size of fs, it is
>>>>> calculating the total size of disks and then dividing it by a factor.
>>>>> But in some usecase, the result is not good to user.
>>>>>
>>>>> Example:
>>>>>     # mkfs.btrfs -f /dev/vdf1 /dev/vdf2 -d raid1
>>>>>     # mount /dev/vdf1 /mnt
>>>>>     # dd if=/dev/zero of=/mnt/zero bs=1M count=1000
>>>>>     # df -h /mnt
>>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>>> /dev/vdf1       3.0G 1018M  1.3G  45% /mnt
>>>>>
>>>>>     # btrfs fi show /dev/vdf1
>>>>> Label: none  uuid: f85d93dc-81f4-445d-91e5-6a5cd9563294
>>>>>     Total devices 2 FS bytes used 1001.53MiB
>>>>>     devid    1 size 2.00GiB  used 1.85GiB path /dev/vdf1
>>>>>     devid    2 size 4.00GiB  used 1.83GiB path /dev/vdf2
>>>>>
>>>>> a. df -h should report Size as 2GiB rather than as 3GiB.
>>>>> Because this is 2 device raid1, the limiting factor is devid 1 @2GiB.
>>>> I agree
>>
>> NOPE.
>>
>> The model you propose is too simple.
>>
>> While the data portion of the file system is set to RAID1 the metadata
>> portion of the filesystem is still set to the default of DUP.
>
> Metadata defaults to DUP only on a single-device filesystem.  On a multi-
> device filesystem, metadata defaults to raid1.  (FWIW, for both, data
> defaults to single.)

Exactly. Thanx for your clarification. :)
>
> And in the example, the mkfs was supplied with two devices, so there's no
> dup metadata remaining from a formerly single-device filesystem, either.
> (Tho there will be the small single-mode stubs, empty, remaining from the
> mkfs process, as no balance has been run to delete them yet, but those
> are much smaller and empty.)

Yes. One question not related here: how about delete them in the end of mkfs?

Thanx
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
