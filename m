Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50455 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751556AbdITORG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 10:17:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 20 Sep 2017 16:14:53 +0200
From: nborisov <nborisov@suse.de>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Rich Rauenzahn <rich@shroop.net>, Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
 btrfs_update_device+0x1c5/0x1d0 [btrfs]
In-Reply-To: <c0be1b97-43d1-1ebb-f745-b7308e6a9eba@gmx.com>
References: <CAG+QAKXTRiC0s5pH_EQoz7Zd7nNfMC5++AN+EFgU6yY=3uvckw@mail.gmail.com>
 <69ee49ff-d2d6-bec9-055c-18697b71ec20@gmx.com>
 <1f8d39cd-a36a-6b4d-dea8-7a9acd9f9396@shroop.net>
 <a7334014-9f8e-55e0-83d1-0c14ce1522f6@gmx.com>
 <8df27746-487b-c5f2-59a0-8eb24b95571a@gmx.com>
 <eda7f67a-ee75-2536-96d6-27bd816c34f0@gmx.com>
 <25600b6b3bd712edb60962357c42d163@suse.de>
 <c0be1b97-43d1-1ebb-f745-b7308e6a9eba@gmx.com>
Message-ID: <2e940d95b1e00ebb2a873b89760ec236@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-20 08:23, Qu Wenruo wrote:
> On 2017年09月20日 14:11, nborisov wrote:
>> On 2017-09-20 07:39, Qu Wenruo wrote:
>>> On 2017年09月20日 13:10, Qu Wenruo wrote:
>>>> 
>>>> 
>>>> On 2017年09月20日 12:59, Qu Wenruo wrote:
>>>>> 
>>>>> 
>>>>> On 2017年09月20日 12:49, Rich Rauenzahn wrote:
>>>>>> 
>>>>>> 
>>>>>> On 9/19/2017 5:31 PM, Qu Wenruo wrote:
>>>>>>> On 2017年09月19日 23:56, Rich Rauenzahn wrote:
>>>>>>>> [    4.747377] WARNING: CPU: 3 PID: 439 at fs/btrfs/ctree.h:1559
>>>>>>>> btrfs_update_device+0x1c5/0x1d0 [btrfs]
>>>>>>> 
>>>>>>> Is that line the following WARN_ON()?
>>>>>>> ---
>>>>>>> static inline void btrfs_set_device_total_bytes(struct 
>>>>>>> extent_buffer *eb,
>>>>>>>                         struct btrfs_dev_item *s,
>>>>>>>                         u64 val)
>>>>>>> {
>>>>>>>     BUILD_BUG_ON(sizeof(u64) !=
>>>>>>>              sizeof(((struct btrfs_dev_item *)0))->total_bytes);
>>>>>>>     WARN_ON(!IS_ALIGNED(val, eb->fs_info->sectorsize)); <<<
>>>>>>>     btrfs_set_64(eb, s, offsetof(struct btrfs_dev_item, 
>>>>>>> total_bytes), val);
>>>>>>> }
>>>>>>> ---
>>>>>>> 
>>>>>>> If so, that means your devices size is not aligned to 4K.
>>>>>>> 
>>>>>>> Is your block device still using old 512 block size?
>>>>>>> AFAIK nowadays most HDDs are using 4K blocksize and it's 
>>>>>>> recommended to use it.
>>>>>>> 
>>>>>>> It's not a big problem and one can easily remove the WARN_ON().
>>>>>>> But I think we'd better fix the caller to do round_down() before 
>>>>>>> calling this function.
>>>>>>> 
>>>>>> 
>>>>>> That's interesting!  I believe I made an effort to align them when 
>>>>>> I set it up years ago, but never knew how to verify.
>>>>> 
>>>>> Well, best verifying if that's the line causing the warning, since 
>>>>> I don't have the source of RedHat kernel.
>>>>> 
>>>>>> 
>>>>>> I have three mirrored filesystems:
>>>>>> 
>>>> [snip]
>>>>>> 
>>>>>> Number  Start (sector)    End (sector)  Size       Code Name
>>>>>>     1              40      3907029134   1.8 TiB     8300 BTRFS 
>>>>>> MEDIA
>>>>>> GPT fdisk (gdisk) version 0.8.6
>>>>> 
>>>>> At least this size is not aligned to 4K.
>>>>> 
>>>>>> 
>>>>>> Partition table scan:
>>>> [snip]
>>>>>> 
>>>>>> .....and one is aligned differently!
>>>>>> 
>>>>>> Could it be /dev/sdd that's the issue?  But it's aligned at 4096 
>>>>>> -- so I'm not sure that's the issue after all.
>>>>> 
>>>>> Its start sector is aligned, but end point is not, so the size is 
>>>>> not aligned either.
>>>>> 
>>>>> BTW, is /dev/sdd added to btrfs using "btrfs device add"?
>>>>> In my test, if making btrfs on a unaligned file, it will round down 
>>>>> to its sectorsize boundary.
>>>> 
>>>> Confirmed that "btrfs device add" won't round down the size.
>>>> Check the btrfs-debug-tree output:
>>>> ------
>>>>          item 0 key (DEV_ITEMS DEV_ITEM 1) itemoff 16185 itemsize 98
>>>>                  devid 1 total_bytes 10737418240 bytes_used 
>>>> 2172649472
>>>>                  io_align 4096 io_width 4096 sector_size 4096 type 0
>>>>                  generation 0 start_offset 0 dev_group 0
>>>>                  seek_speed 0 bandwidth 0
>>>>                  uuid 243a1117-ca31-4d87-8656-81c5630aafb2
>>>>                  fsid 6452cde7-14d5-4541-aa07-b265a400bad0
>>>>          item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16087 itemsize 98
>>>>                  devid 2 total_bytes 1073742336 bytes_used 0
>>>>                  io_align 4096 io_width 4096 sector_size 4096 type 0
>>>>                  generation 0 start_offset 0 dev_group 0
>>>>                  seek_speed 0 bandwidth 0
>>>>                  uuid 6bb07260-d230-4e22-88b1-1eabb46622ed
>>>>                  fsid 6452cde7-14d5-4541-aa07-b265a400bad0
>>>> ------
>>> 
>>> Sorry, the output is from v4.12.x, so no kernel warning nor the patch
>>> rounding down the value.
>>> 
>>>> 
>>>> Where first device is completely aligned, the 2nd device which is 
>>>> just 1G + 512, definitely not aligned.
>>>> 
>>>> So if you're using single device purely created by mkfs.btrfs, 
>>>> you're OK.
>>>> But if any new device added, you're not OK and causing the false 
>>>> alert.
>>>> 
>>>> Any way, it should not be hard to fix.
>>>> Just remove the WARN_ON() and add extra round_down when adding 
>>>> device.
>>> 
>>> In v4.13 kernel, the newly added devices are in fact rounded down.
>>> But existing device doesn't get the round down.
>> 
>> We got a report internally at Suse of this problem and it prevented a 
>> filesystem from being mounted due to the
>> following check failing: 
>> http://elixir.free-electrons.com/linux/latest/source/fs/btrfs/volumes.c#L6893. 
>> Hence I added the rounding down fixes. And this warning was put 
>> specifically to catch future offenders and see
>> if I had missed a place to patch it. So removing the warning is the 
>> wrong solution to the problem.
> 
> Then at least only enable it for BTRFS_DEBUG.

No, the idea is that if a bug in the code causes such a "corruption" we 
ought to be able to catch it in the first instance and not post factum. 
If a bug in btrfs is introduced in a call path which invokes 
btrfs_update_device with misaligned values we won't see which was the 
culprit. If one then enables BTRFS_DEBUG and starts seeing the warnings 
it will likely yield no useful information since the value will already 
be corrupted.

> 
> For end user it's just confusing.
> 
> I have submitted a patch to do the check at mounting time, and warning
> user to do shrink to fix it.
> (Although still removed the WARN_ON)
> 
> I think such warning breaks backward compatibility should be as gentle
> as possible for end users.

How exactly is it breaking backward compatibility?

> 
> Thanks,
> Qu
> 
>> Generally if
>> balancing kicked in had to resize his disk everything would be back to 
>> normal. >
>>> 
>>> So it's recommended to resize (shrink) your fs for very small size to
>>> fix it if you don't want to wait for the kernel fix.
>>> 
>>> Thanks,
>>> Qu
>>>> 
>>>> Thanks for the report,
>>>> Qu
>>>> 
>>>>> 
>>>>> So I'm wondering if it's caused by added new btrfs device.
>>>>> 
>>>>> Thanks,
>>>>> Qu
>>>>> 
>>>>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>>>>> linux-btrfs" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> -- To unsubscribe from this list: send the line "unsubscribe 
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> -- To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

