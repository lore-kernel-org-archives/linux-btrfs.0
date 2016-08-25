Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42278 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756764AbcHYQWG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 12:22:06 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bcwtJ-0003te-W2
        for linux-btrfs@vger.kernel.org; Thu, 25 Aug 2016 17:48:29 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the "usual"
 problem
Date: Thu, 25 Aug 2016 17:48:23 +0200
Message-ID: <57BF1347.9010005@5t9.de>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com> <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com> <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com> <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com> <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com> <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com> <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com> <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com> <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com> <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com> <57A372F3.5090400@5t9.de> <5ee26e48-d949-502e-5884-6369c9e6b278@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <5ee26e48-d949-502e-5884-6369c9e6b278@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/05/2016 10:03 PM, Gabriel C wrote:
> On 04.08.2016 18:53, Lutz Vieweg wrote:
>>
>> I was today hit by what I think is probably the same bug:
>> A btrfs on a close-to-4TB sized block device, only half filled
>> to almost exactly 2 TB, suddenly says "no space left on device"
>> upon any attempt to write to it. The filesystem was NOT automatically
>> switched to read-only by the kernel, I should mention.
>>
>> Re-mounting (which is a pain as this filesystem is used for
>> $HOMEs of a multitude of active users who I have to kick from
>> the server for doing things like re-mounting) removed the symptom
>> for now, but from what I can read in linux-btrfs mailing list
>> archives, it pretty likely the symptom will re-appear.
>>
>> Here are some more details:
>>
>> Software versions:
>>> linux-4.6.1 (vanilla from kernel.org)
> ...
>>
>> dmesg output from the time the "no space left on device"-symptom
>> appeared:
>>
>>> [5171203.601620] WARNING: CPU: 4 PID: 23208 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x263/0x2a0 [btrfs]
>
> ....
>> ...
>>> [5171230.306037] WARNING: CPU: 18 PID: 12656 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xf3/0x100 [btrfs]
>
> Sounds like the bug I hit too also ..
>
> To fix this you'll need :
>
> crazy@zwerg:~/Work/linux-git$ git show 8b8b08cbf
> commit 8b8b08cbfb9021af4b54b4175fc4c51d655aac8c
> Author: Chris Mason <clm@fb.com>
> Date:   Tue Jul 19 05:52:36 2016 -0700
>
>      Btrfs: fix delalloc accounting after copy_from_user faults

Thanks for this hint!

Yesterday (20 days after the first time this bug struck us, and after re-mounting
the filesystem) we were hit by the same bug again - twice! - once in the morning,
and again in the evening.

That called for immediate action, and short of reverting the whole setup to XFS,
installing a new kernel with the above (and other) btrfs fix(es) was the one thing
I could try.

The system is now running linux-4.7.2, which does contain those patches.
If that doesn't fix it, we're really running out of options.

Regards,

Lutz Vieweg


