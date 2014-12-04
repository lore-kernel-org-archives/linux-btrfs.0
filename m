Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:48936 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbaLDXze (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 18:55:34 -0500
Received: by mail-yh0-f43.google.com with SMTP id z6so8851115yhz.30
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 15:55:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417733909.6853.17.camel@gentoo.org>
References: <1417434411.20237.1.camel@gentoo.org>
	<547D16F0.60809@cn.fujitsu.com>
	<1417733909.6853.17.camel@gentoo.org>
Date: Thu, 4 Dec 2014 16:55:33 -0700
Message-ID: <CAJCQCtRXcjZ27mjAp=nhMbPS3zF9L2La=C5HW8DazG-2amBkEA@mail.gmail.com>
Subject: Re: Reiterate: btrfs stuck with lot's of files
From: Chris Murphy <lists@colorremedies.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 4, 2014 at 3:58 PM, Peter Volkov <pva@gentoo.org> wrote:
> Hi, guys again. Looking at this issue, I suspect this is bug in btrfs.
> We'll have to clean up this installation soon, so if there is any
> request to do some debugging, please, ask. I'll try to reiterate what
> was said in this thread.
>
> Short story: btrfs filesystem made of 22 1Tb disks with lot's of files
> (~30240000). Write load is 25 Mbyte/second. After some time file system
> became unable to cope with this load. Also at this time `sync` takes
> ages to finish, shutdown -r hangs (I guess related to sync).
>
> Also I see there is one some kernel kworker that is main suspect for
> this behavior: all the time it takes 100% of CPU core, jumping from core
> to core. At the same time according to iostat write/read speed is close
> to zero and everything is stuck.
>
> Siting some details from previous messages:
>
>> > top - 13:10:58 up 1 day,  9:26,  5 users,  load average: 157.76, 156.61, 149.29
>> > Tasks: 235 total,   2 running, 233 sleeping,   0 stopped,   0 zombie
>> > %Cpu(s): 19.8 us, 15.0 sy,  0.0 ni, 60.7 id,  3.9 wa,  0.0 hi,  0.6 si, 0.0 st
>> > KiB Mem:  65922104 total, 65414856 used,   507248 free,     1844 buffers
>> > KiB Swap:        0 total,        0 used,        0 free. 62570804 cached Mem
>> >
>> >    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
>> > COMMAND
>> >   8644 root      20   0       0      0      0 R  96.5  0.0 127:21.95 kworker/u16:16
>> >   5047 dvr       20   0 6884292 122668   4132 S   6.4  0.2 258:59.49 dvrserver
>> > 30223 root      20   0   20140   2600   2132 R   6.4  0.0   0:00.01 top
>> >      1 root      20   0    4276   1628   1524 S   0.0  0.0   0:40.19 init
>> >
>> > There are about 300 treads on server, some of which are writing on disk.
>> > A bit information about this btrfs filesystem: this is 22 disk file
>> > system with raid1 for metadata and raid0 for data:
>> >
>> >   # btrfs filesystem df /store/
>> > Data, single: total=11.92TiB, used=10.86TiB
>> > System, RAID1: total=8.00MiB, used=1.27MiB
>> > System, single: total=4.00MiB, used=0.00B
>> > Metadata, RAID1: total=46.00GiB, used=33.49GiB
>> > Metadata, single: total=8.00MiB, used=0.00B
>> > GlobalReserve, single: total=512.00MiB, used=128.00KiB
>> >   # btrfs property get /store/
>> > ro=false
>> > label=store
>> >   # btrfs device stats /store/
>> > (shows all zeros)
>> >   # btrfs balance status /store/
>> > No balance found on '/store/'
>
>  # btrfs filesystem show
> Label: 'store'  uuid: 296404d1-bd3f-417d-8501-02f8d7906bcf
>         Total devices 22 FS bytes used 6.50TiB
>         devid    1 size 931.51GiB used 558.02GiB path /dev/sdb
>         devid    2 size 931.51GiB used 559.00GiB path /dev/sdc
>         devid    3 size 931.51GiB used 559.00GiB path /dev/sdd
>         devid    4 size 931.51GiB used 559.00GiB path /dev/sde
>         devid    5 size 931.51GiB used 559.00GiB path /dev/sdf
>         devid    6 size 931.51GiB used 559.00GiB path /dev/sdg
>         devid    7 size 931.51GiB used 559.00GiB path /dev/sdh
>         devid    8 size 931.51GiB used 559.00GiB path /dev/sdi
>         devid    9 size 931.51GiB used 559.00GiB path /dev/sdj
>         devid   10 size 931.51GiB used 559.00GiB path /dev/sdk
>         devid   11 size 931.51GiB used 559.00GiB path /dev/sdl
>         devid   12 size 931.51GiB used 559.00GiB path /dev/sdm
>         devid   13 size 931.51GiB used 559.00GiB path /dev/sdn
>         devid   14 size 931.51GiB used 559.00GiB path /dev/sdo
>         devid   15 size 931.51GiB used 559.00GiB path /dev/sdp
>         devid   16 size 931.51GiB used 559.00GiB path /dev/sdq
>         devid   17 size 931.51GiB used 559.00GiB path /dev/sdr
>         devid   18 size 931.51GiB used 559.00GiB path /dev/sds
>         devid   19 size 931.51GiB used 559.00GiB path /dev/sdt
>         devid   20 size 931.51GiB used 559.00GiB path /dev/sdu
>         devid   21 size 931.51GiB used 559.01GiB path /dev/sdv
>         devid   22 size 931.51GiB used 560.01GiB path /dev/sdw
>
> Btrfs v3.17.1
>
>> > iostat 1 exposes following problem:
>> >
>> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>> >            16.96    0.00   17.09   65.95    0.00    0.00
>> >
>> > Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
>> > sda               0.00         0.00         0.00          0          0
>> > sdc               0.00         0.00         0.00          0          0
>> > sdb               0.00         0.00         0.00          0          0
>> > sde               0.00         0.00         0.00          0          0
>> > sdd               0.00         0.00         0.00          0          0
>> > sdf               0.00         0.00         0.00          0          0
>> > sdg               0.00         0.00         0.00          0          0
>> > sdj               0.00         0.00         0.00          0          0
>> > sdh               0.00         0.00         0.00          0          0
>> > sdk               0.00         0.00         0.00          0          0
>> > sdi               1.00         0.00       200.00          0        200
>> > sdl               0.00         0.00         0.00          0          0
>> > sdn              48.00         0.00     17260.00          0      17260
>> > sdm               0.00         0.00         0.00          0          0
>> > sdp               0.00         0.00         0.00          0          0
>> > sdo               0.00         0.00         0.00          0          0
>> > sdq               0.00         0.00         0.00          0          0
>> > sdr               0.00         0.00         0.00          0          0
>> > sds               0.00         0.00         0.00          0          0
>> > sdt               0.00         0.00         0.00          0          0
>> > sdv               0.00         0.00         0.00          0          0
>> > sdw               0.00         0.00         0.00          0          0
>> > sdu               0.00         0.00         0.00          0          0
>
> At that time I saw such load profile. Write load changed from disk to
> disk with time, so I do not suspect broken disk. Currently write profile
> is different:
> https://drive.google.com/file/d/0BygFL6N3ZVUAVmxaZ1Q5VTZpSGc/view?usp=sharing
> Sometimes like above, sometimes all zero, most time load is very low.
>
>> > write goes to one disk. I've tried to debug what's going in kworker and
>> > did
>> >
>> > $ echo workqueue:workqueue_queue_work
>> >> /sys/kernel/debug/tracing/set_event
>> > $ cat /sys/kernel/debug/tracing/trace_pipe > trace_pipe.out2
>
> I've put result here:
> https://drive.google.com/file/d/0BygFL6N3ZVUAMWxCQ0tDREE1Uzg/view?usp=sharing
>

Is Btrfs single profile expected to parallel write to block devices?

Initially, any write is a new write rather than an overwrite, because
of COW. All writes go into a single chunk on a single device until the
chunk is full, then onto the next device with a new chunk until that
chunk is full. And so on. This behavior only changes once all space is
allocated as a data or metadata chunk on all block devices, which
actually could take some time. If there are many chunks on many
devices that are 90% full, then I don't know how Btrfs decides which
chunks it writes to. But I still don't think it's highly parallelized
like it is on XFS.

Are reads are parallelized in this case? Unless there's parallelized
reads and writes, the single profile isn't scalable. So before
something is a bug, I'd wonder if the design expects this layout to be
used for the intended use case rather than raid0. The chances of a
single drive dying with 22 drives in the volume is astronomically
high, probably 100% over as short as 6 months, and then what?

I'm unaware of either existing or planned functionality to allow such
a volume to remain functional: to do that, Btrfs needs to delete all
affected files so they're no longer referenced. I've actually thought
of this layout for use with GlusterFS and Ceph, in such a way that a
drive can die and Btrfs informs the distributed filesystem above it
what files are no longer available by this particular storage brick;
next the brick's filesystem can be "cleaned up" by deleting all
missing files, then deleting the missing device, thereby stabilizing
the existing fs. The distributed file system starts replicating
missing files according to its policies.

But right now, if any device dies in your example layout, the
filesystem is functionally lost. Yes you can get remaining data out of
it, but it's in a sense 1/22nd's broken and not fixable as far as I
know. But I haven't tried fixing this manually, e.g. do a scrub to get
a missing files listing and start delete those files, add a new
device, and delete the missing device. If the missing files aren't
explicitly deleted, I think the fs still has references for them and
will just return read/corruption errors rather than denying the file
even exists.

-- 
Chris Murphy
