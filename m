Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53110 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751674AbdHRLcm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 07:32:42 -0400
Subject: Re: BTRFS error (device sda4): failed to read chunk tree: -5
To: Zirconium Hacker <jared.e.vb@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CALsQ4_wnfHtJ+Drn3DJsQxdkX9=ZYDqH_H=hi3BxdSrnDZpqmw@mail.gmail.com>
 <CAJCQCtR-+o_GA7fCfSe8Lfwp8h6FzfiSR=qz8ekc4=dy98mtiQ@mail.gmail.com>
 <CALsQ4_zTdxgfN25pkbhtXfj5EMVUbZ2=FrUHUocNxjynHhYhuA@mail.gmail.com>
 <CAJCQCtTuxjKcZqLOqQvVYZANXyke1_ZeKXF_fr8UG-5mUb=hhw@mail.gmail.com>
 <38bbcea5-882b-1637-1970-e147cb141d39@gmx.com>
 <CAJCQCtTGy1yw+b2ZWNdBA_OZwywzsA0efO2tCrrr02922oKoAg@mail.gmail.com>
 <CALsQ4_y=36OQPqq-o5mB4LQeui4h4qoc5QZnj0cCTBULbRX-dA@mail.gmail.com>
 <5193c358-f64b-6b1f-bc55-c9e423a1ac8c@gmx.com>
 <CALsQ4_yw0zbtuCbRQiUXCeft0OaukD9N=2UKM-bk36D8-8iiBQ@mail.gmail.com>
 <585f0572-cfd1-ee0d-3fc3-a7fdc4f48b0b@gmx.com>
 <CALsQ4_x48t6FmnswR1Bjmy9pQ9KnBpwfoihm7n55sUp6tfHOcA@mail.gmail.com>
 <23c14ae4-270e-25a4-f791-513c19623707@gmx.com>
 <CALsQ4_ztOseBiza39_KWGQoVZ1poz8o-Hn9zwij8LGLLvY3V6A@mail.gmail.com>
 <2e65511a-943b-7aad-25ce-a46824d05d78@gmx.com>
 <CALsQ4_x+TLWA+RKH3Y8CrFMy5CCqgYzx8=Y+ttTjr_Z-gyuhXw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c7ede1a7-0b25-b0fe-668f-359a4c0bc331@gmx.com>
Date: Fri, 18 Aug 2017 19:32:32 +0800
MIME-Version: 1.0
In-Reply-To: <CALsQ4_x+TLWA+RKH3Y8CrFMy5CCqgYzx8=Y+ttTjr_Z-gyuhXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月18日 18:20, Zirconium Hacker wrote:
> # ./btrfs-debug-tree -b 131072 /dev/sda4
> https://pastebin.com/TDa0GuqB

At least this output explains everything.
( although the result may not make you happy )

Check this:

     item 59 key (FIRST_CHUNK_TREE CHUNK_ITEM 62351474688) itemoff 11447 
itemsize 80
         length 1073741824 owner 2 stripe_len 65536 type DATA
         io_align 65536 io_width 65536 sector_size 4096
         num_stripes 1 sub_stripes 1
             stripe 0 devid 2 offset 1074790400
             dev_uuid 039224e8-dd3a-4e95-af1d-660a2021ac55

This means that, for logical address in range [62351474688, 
62351474688+1073741824), all these very important metadata are in your 
*2nd* device!!
( And 4G data is also on that device)

That's why all tree backup roots and tree roots read fails.
Because there is no such device for btrfs to read, and that's why all we 
get is 0.

And considering all your tree root and backup roots are in this range, 
that's to say, without finding your 2nd device (whose dev uuid is 
039224e8-dd3a-4e95-af1d-660a2021ac55) you lost all your possibility to 
recovery the fs.
(This reminds me to enhance btrfs kernel message about missing device)

Since both super block and dump-tree result point to a missing device, I 
really recommend you to double check the history of the fs.
( Maybe you added a usb device to do balance but forget to run "btrfs 
device remove"? )

BTW, to check the dev uuid, you could use the following command to get 
dev_uuid:
# btrfs inspect dump-super <dev> | grep dev_item.uuid

Good luck.

Thanks,
Qu

> # ./btrfs-debug-tree -b 61809344512 /dev/sda4
> btrfs-progs v4.12-dirty
> bytenr mismatch, want=61809344512, have=0
> Couldn't read tree root
> bytenr mismatch, want=61809344512, have=0
> ERROR: failed to read 61809344512
> # ./btrfs-debug-tree -b 61807755264 /dev/sda4
> btrfs-progs v4.12-dirty
> bytenr mismatch, want=61809344512, have=0
> Couldn't read tree root
> bytenr mismatch, want=61807755264, have=0
> ERROR: failed to read 61807755264
> 
> And that last one you wanted me to run debug-tree on was a duplicate.
> 
> Bonus:
> # ./btrfs-debug-tree -b 1085440000 /dev/sda4
> btrfs-progs v4.12-dirty
> bytenr mismatch, want=61809344512, have=0
> Couldn't read tree root
> node 1085440000 level 1 items 2 free 491 generation 325709 owner 1
> fs uuid 29889b3a-1c10-48e4-ad6d-21d03d06e90b
> chunk uuid 33f664ec-d0bc-42f9-87f1-d2c0bbbb5046
> key (EXTENT_TREE ROOT_ITEM 0) block 1085456384 (66251) gen 325709
> key (286 INODE_ITEM 0) block 1085505536 (66254) gen 325709
> 
> BTW, thank you for your quick responses and help so far.
> 
> On Fri, Aug 18, 2017 at 5:46 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> Would you please try this patch?
>> https://patchwork.kernel.org/patch/9908173/
>>
>> This should allow btrfs-debug-tree to output tree block even tree root is
>> corrupted.
>> You could apply it on lasted master branch (tagged as v4.12).
>>
>> Then re-execute the following command (with patched btrfs-progs):
>> # btrfs-debug-tree -b 131072 /dev/sda4
>>
>> And some new output:
>> # btrfs-debug-tree -b 61809344512 /dev/sda4
>> # btrfs-debug-tree -b 61807755264 /dev/sda4
>> # btrfs-debug-tree -b 61809344512 /dev/sda4
>>
>> Thanks,
>> Qu
>>
>>
>> On 2017年08月18日 17:29, Zirconium Hacker wrote:
>>>
>>> $ sudo btrfs check -r 1085440000 /dev/sda4
>>> parent transid verify failed on 1085440000 wanted 325966 found 325709
>>> parent transid verify failed on 1085440000 wanted 325966 found 325709
>>> Ignoring transid failure
>>> bytenr mismatch, want=61352312832, have=0
>>> Couldn't setup device tree
>>> ERROR: cannot open file system
>>>
>>> On Fri, Aug 18, 2017 at 5:19 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2017年08月18日 17:08, Zirconium Hacker wrote:
>>>>>
>>>>>
>>>>> I already ran that earlier, here's the pastebin:
>>>>> https://pastebin.com/KGB8nVRA
>>>>>
>>>>> Running debug-tree on all 1084 of them (I guess that was unnecessary)
>>>>> gave the same errors every time:
>>>>> bytenr mismatch, want=61809344512, have=0
>>>>> Couldn't read tree root
>>>>> ERROR: unable to open /dev/sda4
>>>>>
>>>>
>>>> Then try using btrfs check with new root:
>>>>
>>>> # btrfs check -r 1085440000 /dev/sda4
>>>>
>>>> Please note that, the generation in superblock differs quite a lot with
>>>> find-root result.
>>>> So I'm afraid it will cause quite a lot of problems.
>>>>
>>>> But least, it should help btrfs check to get over "Couldn't read tree
>>>> root"
>>>> error message.
>>>>
>>>> And for btrfs-debug-tree error, I'll submit a patch soon to allow it to
>>>> be
>>>> run on such heavily damaged fs.
>>>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>> On Fri, Aug 18, 2017 at 5:03 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2017年08月18日 16:47, Zirconium Hacker wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> $ sudo btrfs-debug-tree -b 131072 /dev/sda4
>>>>>>> btrfs-progs v4.12
>>>>>>> bytenr mismatch, want=61809344512, have=0
>>>>>>> Couldn't read tree root
>>>>>>> ERROR: unable to open /dev/sda4
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> I think this can be improved for case like this.
>>>>>> I'll try to submit a patch to enhance btrfs-debug-tree.
>>>>>>
>>>>>> Would you please try "btrfs-find-root /dev/sda4"?
>>>>>> This will try to locate on-disk old tree root, and if we're lucky, old
>>>>>> tree
>>>>>> root can allow us to mount the fs.
>>>>>>
>>>>>>>
>>>>>>> Mounting with degraded,ro does not fix the multi-device issue.  The
>>>>>>> system was never really intended to have a second device, though:
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Wait for a minute, did you mean this btrfs doesn't ever have a second
>>>>>> device?
>>>>>> This seems quite weird now.
>>>>>>
>>>>>>>
>>>>>>> $ sudo btrfs fi show /dev/sda4
>>>>>>> bytenr mismatch, want=61809344512, have=0
>>>>>>> Couldn't read tree root
>>>>>>> Label: none  uuid: 29889b3a-1c10-48e4-ad6d-21d03d06e90b
>>>>>>> Total devices 2 FS bytes used 49.52GiB
>>>>>>> devid    1 size 54.07GiB used 54.07GiB path /dev/sda4
>>>>>>> *** Some devices missing
>>>>>>>
>>>>>>> I vaguely remember following this guide at some point:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>>>>>> -- specifically the "Balance cannot run because the filesystem is
>>>>>>> full" part.  This may have broken some things?
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Not sure, at least from your superblock, too many things are in doubt.
>>>>>>    From the number of devices, to strange system chunk.
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Fri, Aug 18, 2017 at 4:15 AM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2017年08月18日 15:17, Zirconium Hacker wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I checked my fstab, and my mount options for that partition are:
>>>>>>>>> nodev,nosuid (so no discard).
>>>>>>>>> As far as I remember, I had some issues converting from ext4 with
>>>>>>>>> existing tools (I think that was on Debian so the tools were likely
>>>>>>>>> older) so I did a manual conversion backup, wipe, copy files back).
>>>>>>>>>
>>>>>>>>> $ sudo btrfs-find-root -o 3 /dev/sda4
>>>>>>>>> Couldn't read tree root
>>>>>>>>> Superblock thinks the generation is 311252
>>>>>>>>> Superblock thinks the level is 0
>>>>>>>>> ERROR: tree block bytenr 0 is not aligned to sectorsize 4096
>>>>>>>>> Found tree root at 131072 gen 311252 level 0
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> So chunk root (and since it's level 0, the whole chunk tree) seems
>>>>>>>> good.
>>>>>>>>
>>>>>>>> Could you please try the following command?
>>>>>>>> # btrfs-debug-tree -b 131072 /dev/sda4
>>>>>>>>
>>>>>>>> I assume it may fail due to the fact that root tree is corrupted.
>>>>>>>> But maybe we are lucky?
>>>>>>>>
>>>>>>>>
>>>>>>>> And further investigating your super dump and the code, it's shows
>>>>>>>> some
>>>>>>>> clue, mostly related to your multi-device setup.
>>>>>>>>
>>>>>>>> Your find-root output shows that, the only chunk leaf in /dev/sda4
>>>>>>>> seems
>>>>>>>> good.
>>>>>>>> And in btrfs_read_chunk_tree(), which returned -EIO and caused the
>>>>>>>> error
>>>>>>>> message, will first search chunk root.
>>>>>>>>
>>>>>>>> Since your chunk leaf is good, such search itself should not cause
>>>>>>>> too
>>>>>>>> much
>>>>>>>> problem.
>>>>>>>>
>>>>>>>> Then btrfs_read_chunk_tree() will try to read out each device, by
>>>>>>>> calling
>>>>>>>> read_one_dev().
>>>>>>>> Which can return -EIO if any device is missing and you're not using
>>>>>>>> degraded
>>>>>>>> mount option.
>>>>>>>>
>>>>>>>> Is your 2nd device missing? If so, would you please try to mount with
>>>>>>>> "degraded,ro" mount option?
>>>>>>>>
>>>>>>>> BTW, if you didn't manually convert chunk profiles, did you first
>>>>>>>> create
>>>>>>>> btrfs on single device, and then added a new device to the btrfs?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Fri, Aug 18, 2017 at 12:10 AM, Chris Murphy
>>>>>>>>> <lists@colorremedies.com>
>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On Thu, Aug 17, 2017 at 4:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>>> BTW are you using discard mount option? Sometimes it can cause
>>>>>>>>>>> problem.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> OP did not say if it was using discard mount option; but did say
>>>>>>>>>> some
>>>>>>>>>> time before this (I'm not sure how recent) he had used fstrim. The
>>>>>>>>>> firmware for this SSD model is current.
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> Chris Murphy
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-btrfs"
>>>>>>>>> in
>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
