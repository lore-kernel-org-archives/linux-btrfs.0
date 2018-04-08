Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:56933 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752460AbeDHDFa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 7 Apr 2018 23:05:30 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Ben Parsons <9parsonsb@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz>
 <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
 <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
 <CAAGPGf8JXhrCDmGPGi90bJhD_HY=mYEZJUdJ1mvx5+MRLsb_Og@mail.gmail.com>
 <40ef1367-45f3-6c61-af68-0a6c13af6aac@gmx.com>
 <CAAGPGf8R1Q05BnxDyOWZ00Li+ocm+S46iNdxz2K2075Y35AJvg@mail.gmail.com>
 <7aaa8833-fefe-e369-ed5d-e2d5d13484a3@gmx.com>
 <CAAGPGf_5D1y6ow4DJDEas7-Zwk_Ojd5K1oFmEVaQnmkRr55aRw@mail.gmail.com>
 <6cfd8d24-679b-3e40-2566-5c54ed9205d4@gmx.com>
 <CAAGPGf-ECaX07rwGYJfFryB3_pUAY8XWuFkfS7griZLXrWjqOg@mail.gmail.com>
 <2bbd973a-7412-4f26-a2f0-cecd9fcad503@gmx.com>
 <CAAGPGf9Qd-a=sLMG5_n+ki_gi_Z4vv30tF__xQfK_LswfB5gfA@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <7ef42894-0ada-809c-cf64-67cc082930cd@gmx.com>
Date: Sun, 8 Apr 2018 11:05:21 +0800
MIME-Version: 1.0
In-Reply-To: <CAAGPGf9Qd-a=sLMG5_n+ki_gi_Z4vv30tF__xQfK_LswfB5gfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月08日 10:55, Ben Parsons wrote:
> just to confirm:
> 
> I run the following dd command to fix the superblocks:
> dd if=super_dump.sdb of=/dev/sdb bs=1 count=4096 skip=64k
> dd if=super_dump.sdc1 of=/dev/sdc1 bs=1 count=4096 skip=64k

Nope.

it's seek=64K

Thanks,
Qu
> 
> Thanks,
> Ben
> 
> On 8 April 2018 at 12:27, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> Here you go, all patched super block attached.
>>
>> Thanks,
>> Qu
>>
>> On 2018年04月08日 10:14, Ben Parsons wrote:
>>> Super block of sdb as requested
>>>
>>> Thanks,
>>> Ben
>>>
>>> On 8 April 2018 at 11:53, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018年04月08日 08:57, Ben Parsons wrote:
>>>>> See attached for requested output.
>>>>>
>>>>> Do I still need to recover the super block of sdb?
>>>>
>>>> Yep. Please also attach the binary dump of superblock of sdb.
>>>>
>>>>>
>>>>> Could you please point me the right direction for doing the inplace recovery?
>>>>
>>>> I'll provide the patched superblock for both disks (sdb and sdc1)
>>>>
>>>> And with them written back to disk, just run "btrfs check" first, if
>>>> nothing wrong, mount it RW and run scrub.
>>>>
>>>> Pretty straightforward.
>>>>
>>>> Thanks,
>>>> Qu
>>>>>
>>>>> I have not rebooterd or tried to recover / mount the disc btw.
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>>> On 8 April 2018 at 10:02, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>
>>>>>>
>>>>>> On 2018年04月08日 07:29, Ben Parsons wrote:
>>>>>>> On 7 April 2018 at 22:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2018年04月07日 10:31, Ben Parsons wrote:
>>>>>>>> [snip]
>>>>>>>>>> Pretty common hard power reset.
>>>>>>>>>>
>>>>>>>>>>> looking at journalctl, there is a large stacktrace from kernel: amdgpu
>>>>>>>>>>> (see attached).
>>>>>>>>>>> then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't mount.
>>>>>>>>>>
>>>>>>>>>> I'd say such corruption is pretty serious.
>>>>>>>>>>
>>>>>>>>>> And what's the profile of the btrfs? If metadata is raid1, we could at
>>>>>>>>>> least try to recovery the superblock from the remaining disk.
>>>>>>>>>
>>>>>>>>> I am not sure what the metadata was but the two disks had no parity
>>>>>>>>> and just appeared as a single disk with total space of the two disks
>>>>>>>>
>>>>>>>> Strangely, for the 2nd disk, it's sdc1, which means it has partition table.
>>>>>>>> While for the 1st disk, it's sda, without partition table at all.
>>>>>>>> Is there any possibility that you just took run partition?
>>>>>>>> (Or did some program uses it incorrectly?)
>>>>>>>>
>>>>>>>
>>>>>>> I dont quite understand what you are asking.
>>>>>>> I was always under the impression I could run mount on either
>>>>>>> partition and it would mount the pool
>>>>>>>
>>>>>>>>>
>>>>>>>>> how would i got about recovering the 2nd disk? attached is
>>>>>>>>
>>>>>>>> The 2nd disk looks good, however it's csum_type is wrong.
>>>>>>>> 41700 looks like garbage.
>>>>>>>>
>>>>>>>> Despite that, incompact_flags also has garbage.
>>>>>>>>
>>>>>>>> The good news is, the system (and metadata) profile is RAID1, so it's
>>>>>>>> highly possible for us to salvage (to be more accurate, rebuild) the
>>>>>>>> superblock for the 1st device.
>>>>>>>>
>>>>>>>> Please dump the superblock of the 2nd device (sdc1) by the following
>>>>>>>> command:
>>>>>>>>
>>>>>>>> # dd if=/dev/sdc1 of=super_dump.sdc1 bs=1 count=4096 skip=64k
>>>>>>>>
>>>>>>>
>>>>>>> See attached.
>>>>>>>
>>>>>>>>
>>>>>>>> Unfortunately, btrfs-sb-mod tool added recently doesn't have all needed
>>>>>>>> fields, so I'm afraid I need to manually modify it.
>>>>>>>>
>>>>>>>> And just in case, please paste the following output to help us verify if
>>>>>>>> it's really sda without offset:
>>>>>>>>
>>>>>>>> # lsblk /dev/sda
>>>>>>>> # grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D"
>>>>>>>>
>>>>>>>
>>>>>>> dd if=/dev/sdb of=toGrep.sdb bs=1 count=128M status=progress
>>>>>>> cat toGrep.sdb | grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D"
>>>>>>>
>>>>>>> 65600:_BHRfS_M
>>>>>>> 67108928:_BHRfS_M
>>>>>>
>>>>>> Well, the magic number is completely correct, and at correct location.
>>>>>>
>>>>>> Would you please run "btrfs inspect dump-super -fFa /dev/sdb" again?
>>>>>> This time it should provide good data.
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> Above grep could be very slow since it will try to iterate the whole
>>>>>>>> disk. It's recommended to dump the first 128M of the disk and then grep
>>>>>>>> on that 128M image.
>>>>>>>>
>>>>>>>>
>>>>>>>> BTW, with superblock of sdc1 patched, you should be able to mount the fs
>>>>>>>> with -o ro,degraded, and salvage some data.
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> Qu
>>>>>>>
>>>>>>> Thank you so much!
>>>>>>>
>>>>>>> I am better off copying the data to another disk and then rebuilding the pool?
>>>>>>> or can I just run a scrub after the super block is fixed?
>>>>>>
>>>>>> According to your latest grep output, strangely the 1st device is not
>>>>>> that corrupted as before.
>>>>>>
>>>>>> So I think in-place recover should save you a lot of time.
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> For reference here is lsblk:
>>>>>>>
>>>>>>> sda      8:0    0 465.8G  0 disk
>>>>>>> ├─sda1   8:1    0   512M  0 part /boot
>>>>>>> ├─sda2   8:2    0 455.3G  0 part /
>>>>>>> └─sda3   8:3    0    10G  0 part [SWAP]
>>>>>>>
>>>>>>> sdb      8:16   0 931.5G  0 disk
>>>>>>> -- first disk
>>>>>>>
>>>>>>> sdc      8:32   0   1.8T  0 disk
>>>>>>> └─sdc1   8:33   0   1.8T  0 part
>>>>>>> -- 2nd disk
>>>>>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
