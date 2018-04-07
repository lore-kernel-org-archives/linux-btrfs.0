Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:38757 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751475AbeDGMJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 7 Apr 2018 08:09:41 -0400
Subject: Re: Bad magic on superblock on /dev/sda at 65536
To: Ben Parsons <9parsonsb@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <CAAGPGf9+y_BXj=jQ1aY3xSPzMTjOTWPPO2avBODSYem5pyRXGQ@mail.gmail.com>
 <20180406170329.GH8557@twin.jikos.cz>
 <1401c2e5-d0e9-ac9e-178f-776cb9847ffb@gmx.com>
 <CAAGPGf8m-8qQ-tsW6ZxtEktm1DbP4FfrU6FZr+tX3vb_Cq+9_g@mail.gmail.com>
 <17a45d05-1dc9-4b1b-5786-c4bf8ae8a5eb@gmx.com>
 <CAAGPGf8JXhrCDmGPGi90bJhD_HY=mYEZJUdJ1mvx5+MRLsb_Og@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <40ef1367-45f3-6c61-af68-0a6c13af6aac@gmx.com>
Date: Sat, 7 Apr 2018 20:09:29 +0800
MIME-Version: 1.0
In-Reply-To: <CAAGPGf8JXhrCDmGPGi90bJhD_HY=mYEZJUdJ1mvx5+MRLsb_Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月07日 10:31, Ben Parsons wrote:
[snip]
>> Pretty common hard power reset.
>>
>>> looking at journalctl, there is a large stacktrace from kernel: amdgpu
>>> (see attached).
>>> then when I booted back up the pool (2 disks, 1TB + 2TB) wouldn't mount.
>>
>> I'd say such corruption is pretty serious.
>>
>> And what's the profile of the btrfs? If metadata is raid1, we could at
>> least try to recovery the superblock from the remaining disk.
> 
> I am not sure what the metadata was but the two disks had no parity
> and just appeared as a single disk with total space of the two disks

Strangely, for the 2nd disk, it's sdc1, which means it has partition table.
While for the 1st disk, it's sda, without partition table at all.
Is there any possibility that you just took run partition?
(Or did some program uses it incorrectly?)

> 
> how would i got about recovering the 2nd disk? attached is

The 2nd disk looks good, however it's csum_type is wrong.
41700 looks like garbage.

Despite that, incompact_flags also has garbage.

The good news is, the system (and metadata) profile is RAID1, so it's
highly possible for us to salvage (to be more accurate, rebuild) the
superblock for the 1st device.

Please dump the superblock of the 2nd device (sdc1) by the following
command:

# dd if=/dev/sdc1 of=super_dump.sdc1 bs=1 count=4096 skip=64k

Unfortunately, btrfs-sb-mod tool added recently doesn't have all needed
fields, so I'm afraid I need to manually modify it.

And just in case, please paste the following output to help us verify if
it's really sda without offset:

# lsblk /dev/sda
# grep -obUaP "\x5F\x42\x48\x52\x66\x53\x5F\x4D"

Above grep could be very slow since it will try to iterate the whole
disk. It's recommended to dump the first 128M of the disk and then grep
on that 128M image.


BTW, with superblock of sdc1 patched, you should be able to mount the fs
with -o ro,degraded, and salvage some data.

Thanks,
Qu
> 
> btrfs inspect dump-super -Ffa
> 
> for the second disk
> 
>> And is there special mount options used here like discard?
> 
> compress=lzo, noauto
> 
>> Thanks,
>> Qu
>>
> 
> Thank you for all your help so far.
> Does this mean that the first disk is definatly gone? is there any way
> to recover?
> 
> 
> Thank,
> Ben
> 
>>>
>>> Thanks,
>>> Ben
>>>
>>> On 7 April 2018 at 09:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> On 2018年04月07日 01:03, David Sterba wrote:
>>>>> On Fri, Apr 06, 2018 at 11:32:34PM +1000, Ben Parsons wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I just had an unexpected restart and now my btrfs pool wont mount.
>>>>>> The error on mount is:
>>>>>>
>>>>>>     "ERROR: unsupported checksum algorithm 41700"
>>>>>>
>>>>>> and when running
>>>>>>
>>>>>>     btrfs inspect-internal dump-super /dev/sda
>>>>>>     ERROR: bad magic on superblock on /dev/sda at 65536
>>>>>>
>>>>>> I saw a thread in the mailing list about it:
>>>>>> https://www.spinics.net/lists/linux-btrfs/msg75326.html
>>>>>> However I am told on IRC that Qu fixed it using magic.
>>>>>>
>>>>>> Any help would be much appreciated.
>>>>>
>>>>> In the previous report, there were 2 isolated areas of superblock
>>>>> damaged. Please post output of
>>>>>
>>>>>       btrfs inspect dump-super /path
>>>>
>>>> And don't forget -Ffa option.
>>>> -F to force btrfs-progs to recognize it as btrfs no matter what the magic is
>>>> -f shows all data so we could find all corruption and fix them if possible
>>>> -a shows all backup superblocks, and if some backup is good, "btrfs
>>>> rescue super-recovery" mentioned by Nikolay would be the best solution.
>>>>
>>>> Despite that, any extra info on how this happened is also appreciated,
>>>> as similar problem happened twice, which means we need to pay attention
>>>> on this.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> so we can see if it's a similar issue.
>>>>>
>>>>> In case it is, there's a tool in the btrfs-progs repo that can fix the
>>>>> individual values.
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
