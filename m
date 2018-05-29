Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35243 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934533AbeE2OfR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 10:35:17 -0400
Received: by mail-io0-f195.google.com with SMTP id g1-v6so17859015iob.2
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 07:35:17 -0700 (PDT)
Subject: Re: csum failed root raveled during balance
To: ein <ein.net@gmail.com>, linux-btrfs@vger.kernel.org
References: <5B047817.3040106@gmail.com>
 <e04ab862-abe3-7187-1519-b89776df9362@suse.com> <5B052068.5000608@gmail.com>
 <pan$d9d06$238f0899$805884d5$1c7cb19b@cox.net> <5B053DF2.4030301@gmail.com>
 <34e2ea9c-dc43-af9e-6de1-566e411f7660@gmail.com>
 <a83bc158-716c-81c9-de43-0caca11ef4e6@gmail.com>
 <9aef47e7-7415-2465-6380-daafcba82e45@gmail.com>
 <52ac7589-ff7f-79b3-3ce7-4c7e128d67a0@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5e9c8ff8-c763-6217-0887-ad76aa48d256@gmail.com>
Date: Tue, 29 May 2018 10:35:13 -0400
MIME-Version: 1.0
In-Reply-To: <52ac7589-ff7f-79b3-3ce7-4c7e128d67a0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-29 10:02, ein wrote:
> On 05/29/2018 02:12 PM, Austin S. Hemmelgarn wrote:
>> On 2018-05-28 13:10, ein wrote:
>>> On 05/23/2018 01:03 PM, Austin S. Hemmelgarn wrote:
>>>> On 2018-05-23 06:09, ein wrote:
>>>>> On 05/23/2018 11:09 AM, Duncan wrote:
>>>>>> ein posted on Wed, 23 May 2018 10:03:52 +0200 as excerpted:
>>>>>>
>>>>>>>> IMHO the best course of action would be to disable checksumming for
>>>>>>>> you
>>>>>>>> vm files.
>>>>>>>
>>>>>>> Do you mean '-o nodatasum' mount flag? Is it possible to disable
>>>>>>> checksumming for singe file by setting some magical chattr? Google
>>>>>>> thinks it's not possible to disable csums for a single file.
>>>>>>
>>>>>> You can use nocow (-C), but of course that has other restrictions (like
>>>>>> setting it on the files when they're zero-length, easiest done for
>>>>>> existing data by setting it on the containing dir and copying files (no
>>>>>> reflink) in) as well as the nocow effects, and nocow becomes cow1
>>>>>> after a
>>>>>> snapshot (which locks the existing copy in place so changes written to a
>>>>>> block /must/ be written elsewhere, thus the cow1, aka cow the first time
>>>>>> written after the snapshot but retain the nocow for repeated writes
>>>>>> between snapshots).
>>>>>>
>>>>>> But if you're disabling checksumming anyway, nocow's likely the way
>>>>>> to go.
>>>>>
>>>>> Disabling checksumming only may be a way to go - we live without it
>>>>> every day. But nocow @ VM files defeats whole purpose of using BTRFS for
>>>>> me, even with huge performance penalty - backup reasons - I mean few
>>>>> snapshots (20-30), send & receive.
>>>>>
>>>> Setting NOCOW on a file doesn't prevent it from being snapshotted, it
>>>> just prevents COW operations from happening under most normal
>>>> circumstances.  In essence, it prevents COW from happening except for
>>>> writing right after the snapshot.  More specifically, the first write to
>>>> a given block in a file set for NOCOW after taking a snapshot will
>>>> trigger a _single_ COW operation for _only_ that block (unless you have
>>>> autodefrag enabled too), after which that block will revert to not doing
>>>> COW operations on write.  This way, you still get consistent and working
>>>> snapshots, but you also don't take the performance hits from COW except
>>>> right after taking a snapshot.
>>>
>>> Yeah, just after I've post it, I've found some Duncan post from 2015,
>>> explaining it, thank you anyway.
>>>
>>> Is there anything we can do better in random/write VM workload to speed
>>> the BTRFS up and why?
>>>
>>> My settings:
>>>
>>> <disk type='file' device='disk'>
>>>         <driver name='qemu' type='raw' cache='none' io='native'/>
>>>         <source file='/var/lib/libvirt/images/db.raw'/>
>>>         <target dev='vda' bus='virtio'/>
>>>         [...]
>>> </disk>
>>>
>>> /dev/mapper/raid10-images on /var/lib/libvirt type btrfs
>>> (rw,noatime,nodiratime,compress=lzo:3,ssd,space_cache,autodefrag,subvolid=5,subvol=/)
>>>
>>> md1 : active raid10 sdc1[2] sdb2[1] sdd1[3] sda2[0]
>>>         468596736 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>>>         bitmap: 0/4 pages [0KB], 65536KB chunk
>>>
>>> CPU: E3-1246 with: VT-x, VT-d, HT, EPT, TSX-NI, AES-NI on debian's
>>> kernel 4.15.0-0.bpo.2-amd64
>>>
>>> As far as I understand compress and autodefrag are impacting negatively
>>> for performance (latency), especially autodefrag. I think also that
>>> nodatacow shall also speed things up and it's a must when using qemu and
>>> BTRFS. Is it better to use virtio or virt-scsi with TRIM support?
>>>
>> FWIW, I've been doing just fine without nodatacow, but I also use raw images contained in sparse
>> files, and keep autodefrag off for the dedicated filesystem I put the images on.
> 
> So do I, RAW images created by qemu-img, but I am not sure if preallocation works as expected. The
> size of disks in filesystem looks fine though.
Unless I'm mistaken, qemu-img will fully pre-allocate the images.

You can easily check though with `ls -ls`, which will show the amount of 
space taken up by the file on-disk (before compression or deduplication) 
on the left.  If that first column on the left doesn't match up with the 
apparent file size, then the file is sparse and not fully pre-allocated.

 From a practical perspective, if you really want maximal performance, 
it's worth pre-allocating space, as that both avoids the non-determinism 
of allocating blocks on first-write, and avoids some degree of 
fragmentation.

If you would rather save the space and not pre-allocate, you can either 
use touch with the `--size` argument to quickly create an apropriately 
sized virtual disk image file.
> 
> May I ask in what workloads? From my testing while having VM on BTRFS storage:
> - file/web servers works perfect on BTRFS.
> - Windows (2012/2016) file servers with AD, are perfect too, besides time required for Windows
> Update, but this service is... let's say not fine enough.
> - database (firebird) impact is huuuge, guest filesystem is Ext4, the database performs slower in
> this conditions (4 SSDs in RAID10) than when it was on raid1 with 2 10krpm SASes. I am still
> thinking how to benchmark it properly. A lot of iowait in host's kernel.
In my case, I've got a couple of different types of VM's, each with it's 
own type of workload:
- A total of 8 static VM's that are always running, each running a 
different distribution/version of Linux.  These see very little activity 
most of the time (I keep them around as reference systems so i have 
something I can look at directly when doing development or providing 
support), use ext4 for the internal filesystems, and are not 
particularly big to begin with.
- A bunch of transient VM's used for testing kernel patches for BTRFS. 
These literally start up, run xfstests, copy the results out to a file 
share on the host, and shut down.  The overall behavior for these 
shouldn't be too drastically different from most database workloads (the 
internals of BTRFS are very similar to many database systems).
- Less frequently, transient VM's for testing other software (mostly 
Netdata recently).  These have varied workloads depending on what 
exactly I'm testing, but often don't touch the disk much.

So, overall, I don't have any systems quite comparable to what you're 
running, but still at least have a reasonable spread of workloads.
> 
>> Compression shouldn't have much in the way of negative impact unless you're also using transparent
>> compression (or disk for file encryption) inside the VM (in fact, it may speed things up
>> significantly depending on what filesystem is being used by the guest OS, the ext4 inode table in
>> particular seems to compress very well).  If you are using `nodatacow` though, you can just turn
>> compression off, as it's not going to be used anyway.  If you want to keep using compression, then
>> I'd suggest using `compress-force` instead of `compress`, which makes BTRFS a bit more aggressive
>> about trying to compress things, but makes the performance much more deterministic.  You may also
>> want to look int using `zstd` instead of `lzo` for the compression, it gets better ratios most of
>> the time, and usually performs better than `lzo` does.
> 
> Yeah, I do know exact values from the post we both know for sure:
> https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git/commit/?h=next&id=5c1aab1dd5445ed8bdcdbb575abc1b0d7ee5b2e7
> 
>> Autodefrag should probably be off.  If you have nodatacow set (or just have all the files marked
>> with the NOCOW attribute), then there's not really any point to having autodefrag on.  If like me
>> you aren't turning off COW for data, it's still a good idea to have it off and just do batch
>> defragmentation at a regularly scheduled time.
> 
> Well, at least I need to try nodatacow to check the impact.
Provided that the files aren't fragmented, you should see an increase in 
write performance, but probably not much improvement for reads.
> 
>> For the VM settings, everything looks fine to me (though if you have somewhat slow storage and
>> aren't giving the VM's lots of memory to work with, doing write-through caching might be helpful).
>> I would probably be using virtio-scsi for the TRIM support, as with raw images you will get holes in
>> the file where the TRIM command was issued, which can actually improve performance (and does improve
>> storage utilization (though doing batch trims instead of using the `discard` mount option is better
>> for performance if you have Linux guests).
> 
> I don't consider this... :
> 4: Model=Samsung SSD 850 PRO 256GB, FwRev=EXM02B6Q, SerialNo=S251NX0H822367V
> 21: Model=Samsung SSD 850 PRO 256GB, FwRev=EXM02B6Q, SerialNo=S251NX0H822370A
> 38: Model=INTEL SSDSC2BP240G4, FwRev=L2010420, SerialNo=BTJR6141002D240AGN
> 55: Model=INTEL SSDSC2BP240G4, FwRev=L2010420, SerialNo=BTJR6063000F240AGN
> as slow in Raid 10 mode, because:
> 
> root@node0:~# time dd if=/dev/md1 of=/dev/null bs=4096 count=10M
> 10485760+0 records in
> 10485760+0 records out
> 42949672960 bytes (43 GB, 40 GiB) copied, 31.6336 s, 1.4 GB/s
> 
> real    0m31.636s
> user    0m1.949s
> sys     0m12.222s
> 
> root@node0:~# iostat -x 5 /dev/md1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>             0.63    0.00    4.85    6.61    0.00   87.91
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await
> w_await  svctm  %util
> sdc             306.80     0.00  672.00    0.00 333827.20     0.00   993.53     1.05    1.57    1.57
>     0.00   1.21  81.20
> sdb             329.80     0.00  663.40    0.00 332640.00     0.00  1002.83     0.94    1.41    1.41
>     0.00   1.05  69.44
> sdd             298.80     0.00  664.80    0.00 329110.40     0.00   990.10     1.00    1.50    1.50
>     0.00   1.22  80.96
> sda             291.60     0.00  657.40    0.00 330297.60     0.00  1004.86     0.92    1.40    1.40
>     0.00   1.05  69.20
> md1               0.00     0.00 3884.80    0.00 2693254.40     0.00  1386.56     0.00    0.00
> 0.00    0.00   0.00   0.00
> 
> It gives me much more than 100k IOPs to the BTRFS filesystem if I remember correctly while fio
> benchmark random workload (75% reads, 25% writes), 2 threads.
Yeah, I wouldn't consider that 'slow' either.  In my case, I'm running 
my VM's with the back-end storage being a BTRFS raid1 volume on top of 
two LVM thinp targets, which are in turn on top of a pair of consumer 
7200RPM SATA3 HDD's (because I ran out of space on the two half-TB SSD's 
that I had everything in the system on, and happened to have some 
essentially new 1TB HDD's around still from before I converted to SSD's 
everywhere), and that I would definitely call slow, and it's probably 
worth noting that my definition of 'works just fine' is at least partly 
based on the fact that the storage is so slow.>
>> You're using an MD RAID10 array.  This is generally the fastest option in terms of performance, but
>> it also means you can't take advantage of BTRFS' self repairing ability very well, and you may be
>> wasting space and some performance (because you probably have the 'dup' profile set for metadata).
>> If it's an option, I'd suggest converting this to a BTRFS raid1 volume on top of two MD RAID0
>> volumes, which should either get the same performance, or slightly better performance, will avoid
>> wasting space storing metadata, and will also let you take advantage of the self-repair
>> functionality in BTRFS.
> 
> That's a good point.
> 
>> You should probably switch the `ssd` mount option to `nossd` (and then run a full recursive defrag
>> on the volume, as this option affects the allocation policy, so the changes only take effect for new
>> allocations).  The SSD allocator can actually pretty significantly hurt performance in many cases,
>> and has at best very limited benefits for device lifetimes (you'll maybe get another few months out
>> of a device that will last for ten years without issue).  Make a point to test this though, because
>> you're on a RAID array, this may actually be improving performance slightly.
> 
> Good point either. I am going to test ssd parameter impact to, I think that recreating fs and copy
> the data may be good idea.
One quick point, do make sure you explicitly set 'nossd', as BTRFS tries 
to set the 'ssd' parameter automatically based on whether or not the 
underlying storage is rotational (and I don't remember if MD copies the 
rotational flag from the lower-level storage or not).
> 
> We should not care about the wearout:
> 20 users working on the database every day (work week), for about a year and:
> 
> Model Family:     Intel 730 and DC S35x0/3610/3700 Series SSDs
> Device Model:     INTEL SSDSC2BP240G4
> 
> 233 Media_Wearout_Indicator 0x0032   098   098   000    Old_age   Always       -       0
> 
> and
> 
> 177 Wear_Leveling_Count     0x0013   095   095   000    Pre-fail  Always       -       282
> 
> Model Family:     Samsung based SSDs
> Device Model:     Samsung SSD 850 PRO 256GB
> 
> Which means 50 more years @ Samsung Pro 850 and 100 years @ Intel 730, which is interesting. (btw.
> start date is exactly the same).
For what it's worth, based on my own experience, the degradation isn't 
exactly linear, it's more of an exponential falloff (as more blocks go 
bad, there's less extra space for the FTL to work with for wear 
leveling, so it can't do as good a job wear-leveling, which in turn 
causes blocks to fail faster).  Realistically though, you do still 
probably have a few decades worth of life in them at minimum.
> 
> Thank you for sharing Austin.
Glad I could help!

