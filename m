Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:53829 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdJRQk6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 12:40:58 -0400
Received: by mail-pf0-f193.google.com with SMTP id t188so4355387pfd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 09:40:58 -0700 (PDT)
Subject: Re: SOLVED - 32-bit kernel 4.13 bug - Mount failing - unable to find
 logical
To: Roman Mamedov <rm@romanrm.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
References: <8aa155ab-4722-9448-0f9e-b383f37d7973@gmail.com>
 <93bfd00c-1ade-176d-0c0f-675fe904ab88@gmx.com>
 <20171018101052.3e5221af@natsu>
From: Cameron Kelley <cameronkelley28@gmail.com>
Message-ID: <eb8f527a-24fa-f701-ec16-10895d1588be@gmail.com>
Date: Wed, 18 Oct 2017 09:40:55 -0700
MIME-Version: 1.0
In-Reply-To: <20171018101052.3e5221af@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10-17-2017 10:10 PM, Roman Mamedov wrote:
> On Wed, 18 Oct 2017 09:24:01 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> 
>>
>>
>> On 2017-10-18 04:43, Cameron Kelley wrote:
>>> Hey btrfs gurus,
>>>
>>> I have a 4 disk btrfs filesystem that has suddenly stopped mounting
>>> after a recent reboot. The data is in an odd configuration due to
>>> originally being in a 3 disk RAID1 before adding a 4th disk and running
>>> a balance to convert to RAID10. There wasn't enough free space to
>>> completely convert, so about half the data is still in RAID1 while the
>>> other half is in RAID10. Both metadata and system are RAID10. It has
>>> been in this configuration for 6 months or so now since adding the 4th
>>> disk. It just holds archived media and hasn't had any data added or
>>> modified in quite some time. I feel pretty stupid now for not correcting
>>> that sooner though.
>>>
>>> I have tried mounting with different mount options for recovery, ro,
>>> degraded, etc. Log shows errors about "unable to find logical
>>> 3746892939264 length 4096"
>>>
>>> When I do a btrfs check, it doesn't find any issues. Running
>>> btrfs-find-root comes up with a message about a block that the
>>> generation doesn't match. If I specify that block on the btrfs check, I
>>> get transid verify failures.
>>>
>>> I ran a dry run of a recovery of the entire filesystem which runs
>>> through every file with no errors. I would just restore the data and
>>> start fresh, but unfortunately I don't have the free space at the moment
>>> for the ~4.5TB of data.
>>>
>>> I also ran full smart self tests on all 4 disks with no errors.
>>>
>>> root@nas2:~# uname -a
>>> Linux nas2 4.13.7-041307-generic #201710141430 SMP Sat Oct 14 14:39:06
>>> UTC 2017 i686 i686 i686 GNU/Linux
>>
>> I don't think i686 kernel will cause any difference, but considering
>> most of us are using x86_64 to develop/test, maybe it will be a good
>> idea to upgrade to x86_64 kernel?
> 
> Indeed a problem with mounting on 32-bit in 4.13 has been reported recently:
> https://www.spinics.net/lists/linux-btrfs/msg69734.html
> with the same error message.
> 
> I believe it's this patchset that is supposed to fix that.
> https://www.spinics.net/lists/linux-btrfs/msg70001.html
> 
> @Cameron maybe you didn't just reboot, but also upgraded your kernel at the
> same time? In any case, try a 4.9 series kernel, or a 64-bit machine if you
> want to stay with 4.13.
> 

Just for reference to anyone else having this issue, it is indeed a bug in 
the 32-bit release of the 4.13 kernel. The x64 kernel had no issues 
mounting it.

An interesting thing to note is that I still had all the exact same mount 
issues and errors when I booted the latest PartedMagic live image with 
kernel 4.12.9 in 32-bit mode. The same PatedMagic image in 64-bit mode had 
no issues which is how I confirmed your suspicions.

Now for the part where I feel more stupid than I have in a long time.

1. Apparently I had updated the kernel one this NAS without realizing it 
since I was doing updates on multiple appliances at once a little while 
ago and just hadn't rebooted it since. When I ran into issues, I updated 
the kernel to the latest without looking at the kernel I was on just to 
see if that solved it.

2. And here's the real kicker. The processor in this NAS (Pentium E5200) 
is actually x64 capable. I must have skimmed information too quickly when 
I first built this years ago and thought it wasn't x64 capable.

I have rebuilt the NAS and I'm now running a scrub just to make sure steps 
I was taking to recover didn't cause any issues.

Anything else you would recommend to make sure there aren't any other 
issues that could have been caused by my tinkering?

Thank you very much for your help as I was banging my head against a wall. 
This NAS does so little that I tend to get careless with it. Lesson 
learned and embarrassment felt. The only solace is that this might help 
someone else who runs into this with kernel 4.13 on a 32-bit system.
