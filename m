Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46912 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdL1Ll7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:41:59 -0500
Received: by mail-pf0-f193.google.com with SMTP id c204so20856960pfc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 03:41:59 -0800 (PST)
Subject: Re: Hand Patching a BTRFS Superblock?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, swestrup@gmail.com,
        linux-btrfs@vger.kernel.org
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
Date: Thu, 28 Dec 2017 13:41:54 +0200
MIME-Version: 1.0
In-Reply-To: <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 28.12.2017 03:53, Qu Wenruo wrote:
> 
> 
> On 2017年12月28日 09:46, Stirling Westrup wrote:
>> Here's my situation: I have a network file server containing a 12TB
>> BTRFS spread out over four devices (sda-sdd) which I am trying to
>> recover. I do have a backup, but it's about 3 months old, and while I
>> could certainly rebuild everything from that if I really had to, I
>> would far rather not have to rerip my latest DVDs. So, I am willing to
>> experiment if it might save me a few hundred hours of reconstruction.
>> I don't currently have another 12 TB of space anywhere for making a
>> scratch copy.
>>
>> A few days ago sdb developed hard errors and I can no longer mount the
>> filesystem. sdb is no longer even recognized as a valid btrfs drive.
>> However, when I ran ddrescue over the drive I managed to make a clone
>> (sdf) which contains all but 12K of the original drive. However, those
>> missing 12K are all in the various superblocks, so the cloned drive is
>> still unreadable.
>>
>> In the hopes that I was only missing a few bits of the superblocks, I
>> started out by dd-ing the first 4M of sdd into sdf in the hopes that
>> ddrescue would overwrite much of the superblocks, and the final bits
>> from sdd would make things usable.
>>
>> No such luck. I now have a drive sdf which claims to be identical to
>> sdd but which is a clone of sdb. In case it matters, sda and sdc are
>> each 4TB while sdb and sdd are each 2TB drives; sde is my boot drive
>> and sdf is a 2TB clone of sdb.
>>
>> What I need to do is to somehow patch sdf's primary superblock so it
>> contains the correct device number and UUID_SUB for sdb, so that I can
>> attempt some sort of recovery. Right now my linux is (understandably)
>> quite confused by the situation:
> 
> Did you tried "btrfs rescue super-recover"?
> 
> Remember to use the devel branch from git, as there is a small bug
> prevent it report correct result.

Unforutnately my patchset which fixes super-recover is still not merged,
so he needs to grab the patches from the mailing list and compile the
btrfs tools himself. The patch in question can be found here:

https://patchwork.kernel.org/patch/10092471/

> 
> super-recover will try to use the backup superblock to recover the
> primary one.
> 
> Thanks,
> Qu
> 
>>
>> videon:~ # uname -a
>> Linux videon 4.4.103-18.41-default #1 SMP Wed Dec 13 14:06:33 UTC 2017
>> (f66c68c) x86_64 x86_64 x86_64 GNU/Linux
>>
>> videon:~ # btrfs --version
>> btrfs-progs v4.5.3+20160729
>>
>> videon:~ # btrfs fi show
>> Label: 'Storage'  uuid: 33d2890d-f07d-4ba8-b1fc-7b4f14463b1f
>>         Total devices 4 FS bytes used 10.69TiB
>>         devid    1 size 1.82TiB used 1.82TiB path /dev/sdd
>>         devid    3 size 3.64TiB used 3.54TiB path /dev/sdc
>>         devid    4 size 3.64TiB used 3.54TiB path /dev/sda
>>         *** Some devices missing
>>
>> Any suggestions on how to proceed would be appreciated.
>>
> 
