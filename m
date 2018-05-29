Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35140 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933793AbeE2MMc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 08:12:32 -0400
Received: by mail-io0-f194.google.com with SMTP id g1-v6so17305227iob.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 05:12:31 -0700 (PDT)
Subject: Re: csum failed root raveled during balance
To: ein <ein.net@gmail.com>, linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
 <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net> <5B053DF2.4030301@gmail.com>
 <34e2ea9c-dc43-af9e-6de1-566e411f7660@gmail.com>
 <a83bc158-716c-81c9-de43-0caca11ef4e6@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9aef47e7-7415-2465-6380-daafcba82e45@gmail.com>
Date: Tue, 29 May 2018 08:12:28 -0400
MIME-Version: 1.0
In-Reply-To: <a83bc158-716c-81c9-de43-0caca11ef4e6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-28 13:10, ein wrote:
> On 05/23/2018 01:03 PM, Austin S. Hemmelgarn wrote:
>> On 2018-05-23 06:09, ein wrote:
>>> On 05/23/2018 11:09 AM, Duncan wrote:
>>>> ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:
>>>>
>>>>>> IMHO the best course of action would be to disable checksumming for
>>>>>> you
>>>>>> vm files.
>>>>>
>>>>> Do you mean '-o nodatasum' mount flag? Is it possible to disable
>>>>> checksumming for singe file by setting some magical chattr? Google
>>>>> thinks it's not possible to disable csums for a single file.
>>>>
>>>> You can use nocow (-C), but of course that has other restrictions (like
>>>> setting it on the files when they're zero-length, easiest done for
>>>> existing data by setting it on the containing dir and copying files (no
>>>> reflink) in) as well as the nocow effects, and nocow becomes cow1
>>>> after a
>>>> snapshot (which locks the existing copy in place so changes written to a
>>>> block /must/ be written elsewhere, thus the cow1, aka cow the first time
>>>> written after the snapshot but retain the nocow for repeated writes
>>>> between snapshots).
>>>>
>>>> But if you're disabling checksumming anyway, nocow's likely the way
>>>> to go.
>>>
>>> Disabling checksumming only may be a way to go - we live without it
>>> every day. But nocow @ VM files defeats whole purpose of using BTRFS for
>>> me, even with huge performance penalty - backup reasons - I mean few
>>> snapshots (20-30), send & receive.
>>>
>> Setting NOCOW on a file doesn't prevent it from being snapshotted, it
>> just prevents COW operations from happening under most normal
>> circumstances.  In essence, it prevents COW from happening except for
>> writing right after the snapshot.  More specifically, the first write to
>> a given block in a file set for NOCOW after taking a snapshot will
>> trigger a _single_ COW operation for _only_ that block (unless you have
>> autodefrag enabled too), after which that block will revert to not doing
>> COW operations on write.  This way, you still get consistent and working
>> snapshots, but you also don't take the performance hits from COW except
>> right after taking a snapshot.
> 
> Yeah, just after I've post it, I've found some Duncan post from 2015,
> explaining it, thank you anyway.
> 
> Is there anything we can do better in random/write VM workload to speed
> the BTRFS up and why?
> 
> My settings:
> 
> <disk type='file' device='disk'>
>        <driver name='qemu' type='raw' cache='none' io='native'/>
>        <source file='/var/lib/libvirt/images/db.raw'/>
>        <target dev='vda' bus='virtio'/>
>        [...]
> </disk>
> 
> /dev/mapper/raid10-images on /var/lib/libvirt type btrfs
> (rw,noatime,nodiratime,compress=lzo:3,ssd,space_cache,autodefrag,subvolid=5,subvol=/)
> 
> md1 : active raid10 sdc1[2] sdb2[1] sdd1[3] sda2[0]
>        468596736 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>        bitmap: 0/4 pages [0KB], 65536KB chunk
> 
> CPU: E3-1246 with: VT-x, VT-d, HT, EPT, TSX-NI, AES-NI on debian's
> kernel 4.15.0-0.bpo.2-amd64
> 
> As far as I understand compress and autodefrag are impacting negatively
> for performance (latency), especially autodefrag. I think also that
> nodatacow shall also speed things up and it's a must when using qemu and
> BTRFS. Is it better to use virtio or virt-scsi with TRIM support?
> 
FWIW, I've been doing just fine without nodatacow, but I also use raw 
images contained in sparse files, and keep autodefrag off for the 
dedicated filesystem I put the images on.

Compression shouldn't have much in the way of negative impact unless 
you're also using transparent compression (or disk for file encryption) 
inside the VM (in fact, it may speed things up significantly depending 
on what filesystem is being used by the guest OS, the ext4 inode table 
in particular seems to compress very well).  If you are using 
`nodatacow` though, you can just turn compression off, as it's not going 
to be used anyway.  If you want to keep using compression, then I'd 
suggest using `compress-force` instead of `compress`, which makes BTRFS 
a bit more aggressive about trying to compress things, but makes the 
performance much more deterministic.  You may also want to look int 
using `zstd` instead of `lzo` for the compression, it gets better ratios 
most of the time, and usually performs better than `lzo` does.

Autodefrag should probably be off.  If you have nodatacow set (or just 
have all the files marked with the NOCOW attribute), then there's not 
really any point to having autodefrag on.  If like me you aren't turning 
off COW for data, it's still a good idea to have it off and just do 
batch defragmentation at a regularly scheduled time.

For the VM settings, everything looks fine to me (though if you have 
somewhat slow storage and aren't giving the VM's lots of memory to work 
with, doing write-through caching might be helpful).  I would probably 
be using virtio-scsi for the TRIM support, as with raw images you will 
get holes in the file where the TRIM command was issued, which can 
actually improve performance (and does improve storage utilization 
(though doing batch trims instead of using the `discard` mount option is 
better for performance if you have Linux guests).

You're using an MD RAID10 array.  This is generally the fastest option 
in terms of performance, but it also means you can't take advantage of 
BTRFS' self repairing ability very well, and you may be wasting space 
and some performance (because you probably have the 'dup' profile set 
for metadata).  If it's an option, I'd suggest converting this to a 
BTRFS raid1 volume on top of two MD RAID0 volumes, which should either 
get the same performance, or slightly better performance, will avoid 
wasting space storing metadata, and will also let you take advantage of 
the self-repair functionality in BTRFS.

You should probably switch the `ssd` mount option to `nossd` (and then 
run a full recursive defrag on the volume, as this option affects the 
allocation policy, so the changes only take effect for new allocations). 
  The SSD allocator can actually pretty significantly hurt performance 
in many cases, and has at best very limited benefits for device 
lifetimes (you'll maybe get another few months out of a device that will 
last for ten years without issue).  Make a point to test this though, 
because you're on a RAID array, this may actually be improving 
performance slightly.
