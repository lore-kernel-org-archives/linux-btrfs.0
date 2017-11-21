Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:43245 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdKUEGs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 23:06:48 -0500
Received: by mail-ot0-f169.google.com with SMTP id 105so9457429oth.10
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 20:06:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <d784d9a6-bc0e-e4c3-6633-043081ea800b@gmx.com> <CAJCQCtSZmRmeFUGPSiRLV4TCOjbD6uTqpoEqKD24Li8w1iO7qQ@mail.gmail.com>
 <0f6c7514-1cf2-1d88-1307-c43f7642b525@gmx.com> <CAJCQCtSH-w4Pt9kmGhuYZUX_FdktFEpV4WyKnxw5GaDKfVmdng@mail.gmail.com>
 <d8973b92-b320-5088-aae6-2b3835f1b2ca@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 21:06:47 -0700
Message-ID: <CAJCQCtSjBWMauccwremxQ+eCTTBXsz=VEXFy=ckABpKtC-9NTw@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 6:16 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年11月21日 06:23, Chris Murphy wrote:
>> On Sun, Nov 19, 2017 at 7:42 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>
>>>
>>> On 2017年11月20日 10:24, Chris Murphy wrote:
>>>> On Sun, Nov 19, 2017 at 7:13 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>
>>>>>
>>>>> On 2017年11月19日 14:17, Chris Murphy wrote:
>>>>>> fstrim should trim free space, but it only trims unallocated. This is
>>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>>>>> behaved this way with 4.12 also.
>>>>>
>>>>> Tested with 4.14-rc7, can't reproduce it.
>>>>
>>>> $ sudo btrfs fi us /
>>>> Overall:
>>>>     Device size:          70.00GiB
>>>>     Device allocated:          31.03GiB
>>>>     Device unallocated:          38.97GiB
>>>>     Device missing:             0.00B
>>>>     Used:              22.12GiB
>>>>     Free (estimated):          47.62GiB    (min: 47.62GiB)
>>>> ...snip...
>>>>
>>>> $ sudo fstrim -v /
>>>> /: 39 GiB (41841328128 bytes) trimmed
>>>>
>>>> Then I run btrfs-debug -b / and find the least used block group, at 8% usage;
>>>>
>>>> block group offset   174202028032 len 1073741824 used   89206784
>>>> chunk_objectid 256 flags 1 usage 0.08
>>>>
>>>> And balance that block group:
>>>>
>>>> $ sudo btrfs balance start -dvrange=174202028032..174202028033 -dlimit=1 /
>>>> Done, had to relocate 1 out of 32 chunks
>>>>
>>>> And trim again:
>>>>
>>>> /: 39 GiB (41841328128 bytes) trimmed
>>>>
>>>>
>>>>> Any special mount options or setup?
>>>>> (BTW, I also tried space_cache=v2 and default v1, no obvious difference)
>>>>
>>>>
>>>> /dev/nvme0n1p8 on / type btrfs
>>>> (rw,relatime,seclabel,ssd,space_cache,subvolid=333,subvol=/root27)
>>>
>>> Nothing special at all.
>>>
>>> And unfortunately, no trace point inside btrfs_trim_block_group() at all.
>>>
>>> But a quick glance shows me that, the loop to iterate existing block
>>> groups to trim free space inside them has a return value overwrite bug.
>>>
>>> So only unallocated space get trimmed.
>>>
>>> Would you please try this diff to get the return value?
>>>
>>> ------
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 309a109069f1..dbec05dc8810 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -10983,12 +10983,12 @@ int btrfs_trim_fs(struct btrfs_fs_info
>>> *fs_info, struct fstrim_range *range)
>>>                                 ret = cache_block_group(cache, 0);
>>>                                 if (ret) {
>>>                                         btrfs_put_block_group(cache);
>>> -                                       break;
>>> +                                       goto out;
>>>                                 }
>>>                                 ret = wait_block_group_cache_done(cache);
>>>                                 if (ret) {
>>>                                         btrfs_put_block_group(cache);
>>> -                                       break;
>>> +                                       goto out;
>>>                                 }
>>>                         }
>>>                         ret = btrfs_trim_block_group(cache,
>>> @@ -11000,7 +11000,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
>>> struct fstrim_range *range)
>>>                         trimmed += group_trimmed;
>>>                         if (ret) {
>>>                                 btrfs_put_block_group(cache);
>>> -                               break;
>>> +                               goto out;
>>>                         }
>>>                 }
>>>
>>> @@ -11019,6 +11019,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info,
>>> struct fstrim_range *range)
>>>         }
>>>         mutex_unlock(&fs_info->fs_devices->device_list_mutex);
>>>
>>> +out:
>>>         range->len = trimmed;
>>>         return ret;
>>>  }
>>> ------
>>
>> This won't apply on tag v4.14 for some reason.
>>
>> [chris@f27s linux]$ git apply -v ~/qutrim1.patch
>> Checking patch fs/btrfs/extent-tree.c...
>> error: while searching for:
>>                                ret = cache_block_group(cache, 0);
>>                                if (ret) {
>>                                        btrfs_put_block_group(cache);
>>                                        break;
>>                                }
>>                                ret = wait_block_group_cache_done(cache);
>>                                if (ret) {
>>                                        btrfs_put_block_group(cache);
>>                                        break;
>>                                }
>>                        }
>>                        ret = btrfs_trim_block_group(cache,
>>
>> error: patch failed: fs/btrfs/extent-tree.c:10983
>> error: fs/btrfs/extent-tree.c: patch does not apply
>> [chris@f27s linux]$
>>
>>
>> If I do it manually (just adding the goto and build it, reboot, I
>> still get the same result for fstrim and nothing in dmesg.
>
> Sorry, that diff will not output extra info. Just to abort the process
> and return true error code.

OK? It didn't seem to do that either. I see no change.


>
> I have update the patch to output more verbose output.
> You could find it in patchwork:
> https://patchwork.kernel.org/patch/10065991/

Patch applies on v4.14.0, and still nothing in dmesg, or in user space
when issuing fstrim.

# fstrim -v /
/: 38 GiB (40767586304 bytes) trimmed
# dmesg | grep -i btrfs
[    2.745902] btrfs: loading out-of-tree module taints kernel.
[    2.749905] Btrfs loaded, crc32c=crc32c-intel
[    2.751072] BTRFS: device label fedora devid 1 transid 252048 /dev/nvme0n1p8
[    4.295891] BTRFS info (device nvme0n1p8): disk space caching is enabled
[    4.295892] BTRFS info (device nvme0n1p8): has skinny extents
[    4.307326] BTRFS info (device nvme0n1p8): enabling ssd optimizations
[    4.959467] BTRFS info (device nvme0n1p8): disk space caching is enabled
[root@f27h ~]#


Pretty sure the patch is applied because of the first message about
the out of tree module, which I do not get with Fedora kernels.



-- 
Chris Murphy
