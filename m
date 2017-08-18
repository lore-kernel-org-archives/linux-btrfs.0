Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33009 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdHRJ37 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 05:29:59 -0400
Received: by mail-wr0-f175.google.com with SMTP id b65so65127727wrd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 02:29:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23c14ae4-270e-25a4-f791-513c19623707@gmx.com>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CAJCQCtTx_i_PrqgRbA-P9+zKX926KKeT1nwAJT=dkr-qcOpCCg@mail.gmail.com>
 <CALsQ4_wZLvdqHdKa9DyjRXTmf1CV47+11-O_SqLRQJoQDT+gqQ@mail.gmail.com>
 <CAJCQCtRYxb4QdN__WcUX_Jhs=GyguwJV79pKUp4PYhC9h_H-xA@mail.gmail.com>
 <CALsQ4_xWte-vOJD-ppOPkvfHpLtu_-24KZPj2H9Tp99S7jDGcw@mail.gmail.com>
 <CAJCQCtR-+o_GA7fCfSe8Lfwp8h6FzfiSR=qz8ekc4=dy98mtiQ@mail.gmail.com>
 <CALsQ4_zTdxgfN25pkbhtXfj5EMVUbZ2=FrUHUocNxjynHhYhuA@mail.gmail.com>
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com> <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
 <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com> <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
 <585f0572-cfd1-ee0d-3fc3-a7fdc4f48b0b@gmx.com> <CALsQ4_x48t6FmnswR1Bjmy9pQ9KnBpwfoihm7n55sUp6tfHOcA@mail.gmail.com>
 <23c14ae4-270e-25a4-f791-513c19623707@gmx.com>
From: Zirconium Hacker <jared.e.vb@gmail.com>
Date: Fri, 18 Aug 2017 05:29:57 -0400
Message-ID: <CALsQ4_ztOseBiza39_KWGQoVZ1poz8o-Hn9zwij8LGLLvY3V6A@mail.gmail.com>
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

$ sudo btrfs check -r 1085440000 /dev/sda4
parent transid verify failed on 1085440000 wanted 325966 found 325709
parent transid verify failed on 1085440000 wanted 325966 found 325709
Ignoring transid failure
bytenr mismatch, want=61352312832, have=0
Couldn't setup device tree
ERROR: cannot open file system

On Fri, Aug 18, 2017 at 5:19 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年08月18日 17:08, Zirconium Hacker wrote:
>>
>> I already ran that earlier, here's the pastebin:
>> https://pastebin.com/KGB8nVRA
>>
>> Running debug-tree on all 1084 of them (I guess that was unnecessary)
>> gave the same errors every time:
>> bytenr mismatch, want=61809344512, have=0
>> Couldn't read tree root
>> ERROR: unable to open /dev/sda4
>>
>
> Then try using btrfs check with new root:
>
> # btrfs check -r 1085440000 /dev/sda4
>
> Please note that, the generation in superblock differs quite a lot with
> find-root result.
> So I'm afraid it will cause quite a lot of problems.
>
> But least, it should help btrfs check to get over "Couldn't read tree root"
> error message.
>
> And for btrfs-debug-tree error, I'll submit a patch soon to allow it to be
> run on such heavily damaged fs.
>
>
> Thanks,
> Qu
>
>> On Fri, Aug 18, 2017 at 5:03 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>>
>>> On 2017年08月18日 16:47, Zirconium Hacker wrote:
>>>>
>>>>
>>>> $ sudo btrfs-debug-tree -b 131072 /dev/sda4
>>>> btrfs-progs v4.12
>>>> bytenr mismatch, want=61809344512, have=0
>>>> Couldn't read tree root
>>>> ERROR: unable to open /dev/sda4
>>>
>>>
>>>
>>> I think this can be improved for case like this.
>>> I'll try to submit a patch to enhance btrfs-debug-tree.
>>>
>>> Would you please try "btrfs-find-root /dev/sda4"?
>>> This will try to locate on-disk old tree root, and if we're lucky, old
>>> tree
>>> root can allow us to mount the fs.
>>>
>>>>
>>>> Mounting with degraded,ro does not fix the multi-device issue.  The
>>>> system was never really intended to have a second device, though:
>>>
>>>
>>>
>>> Wait for a minute, did you mean this btrfs doesn't ever have a second
>>> device?
>>> This seems quite weird now.
>>>
>>>>
>>>> $ sudo btrfs fi show /dev/sda4
>>>> bytenr mismatch, want=61809344512, have=0
>>>> Couldn't read tree root
>>>> Label: none  uuid: 29889b3a-1c10-48e4-ad6d-21d03d06e90b
>>>> Total devices 2 FS bytes used 49.52GiB
>>>> devid    1 size 54.07GiB used 54.07GiB path /dev/sda4
>>>> *** Some devices missing
>>>>
>>>> I vaguely remember following this guide at some point:
>>>>
>>>>
>>>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>>> -- specifically the "Balance cannot run because the filesystem is
>>>> full" part.  This may have broken some things?
>>>
>>>
>>>
>>> Not sure, at least from your superblock, too many things are in doubt.
>>>  From the number of devices, to strange system chunk.
>>>
>>>
>>> Thanks,
>>> Qu
>>>>
>>>>
>>>>
>>>> On Fri, Aug 18, 2017 at 4:15 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>> wrote:
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> On 2017年08月18日 15:17, Zirconium Hacker wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> I checked my fstab, and my mount options for that partition are:
>>>>>> nodev,nosuid (so no discard).
>>>>>> As far as I remember, I had some issues converting from ext4 with
>>>>>> existing tools (I think that was on Debian so the tools were likely
>>>>>> older) so I did a manual conversion backup, wipe, copy files back).
>>>>>>
>>>>>> $ sudo btrfs-find-root -o 3 /dev/sda4
>>>>>> Couldn't read tree root
>>>>>> Superblock thinks the generation is 311252
>>>>>> Superblock thinks the level is 0
>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>> Found tree root at 131072 gen 311252 level 0
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> So chunk root (and since it's level 0, the whole chunk tree) seems
>>>>> good.
>>>>>
>>>>> Could you please try the following command?
>>>>> # btrfs-debug-tree -b 131072 /dev/sda4
>>>>>
>>>>> I assume it may fail due to the fact that root tree is corrupted.
>>>>> But maybe we are lucky?
>>>>>
>>>>>
>>>>> And further investigating your super dump and the code, it's shows some
>>>>> clue, mostly related to your multi-device setup.
>>>>>
>>>>> Your find-root output shows that, the only chunk leaf in /dev/sda4
>>>>> seems
>>>>> good.
>>>>> And in btrfs_read_chunk_tree(), which returned -EIO and caused the
>>>>> error
>>>>> message, will first search chunk root.
>>>>>
>>>>> Since your chunk leaf is good, such search itself should not cause too
>>>>> much
>>>>> problem.
>>>>>
>>>>> Then btrfs_read_chunk_tree() will try to read out each device, by
>>>>> calling
>>>>> read_one_dev().
>>>>> Which can return -EIO if any device is missing and you're not using
>>>>> degraded
>>>>> mount option.
>>>>>
>>>>> Is your 2nd device missing? If so, would you please try to mount with
>>>>> "degraded,ro" mount option?
>>>>>
>>>>> BTW, if you didn't manually convert chunk profiles, did you first
>>>>> create
>>>>> btrfs on single device, and then added a new device to the btrfs?
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>>
>>>>>> On Fri, Aug 18, 2017 at 12:10 AM, Chris Murphy
>>>>>> <lists@colorremedies.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Thu, Aug 17, 2017 at 4:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>>>> wrote:
>>>>>>>
>>>>>>>> BTW are you using discard mount option? Sometimes it can cause
>>>>>>>> problem.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> OP did not say if it was using discard mount option; but did say some
>>>>>>> time before this (I'm not sure how recent) he had used fstrim. The
>>>>>>> firmware for this SSD model is current.
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Chris Murphy
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>>
>>>
>
