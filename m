Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57705 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbbBEQs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 11:48:27 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so14482549igb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Feb 2015 08:48:27 -0800 (PST)
Message-ID: <54D39ED5.408@gmail.com>
Date: Thu, 05 Feb 2015 11:48:21 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Juergen Fitschen <me@jue.yt>, linux-btrfs@vger.kernel.org
Subject: Re: Deadlock on 3.18.5
References: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt> <C90D8017-3361-4B95-99E8-859958AF5D28@jue.yt> <54D3667C.8070803@gmail.com> <1FF537B3-F790-428B-A82B-E6B8BA6E4B4E@jue.yt>
In-Reply-To: <1FF537B3-F790-428B-A82B-E6B8BA6E4B4E@jue.yt>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-02-05 10:24, Juergen Fitschen wrote:
>
>> On 05 Feb 2015, at 13:47, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>>
>> I've actually seen similar behavior without the virtualization when doing large filesystem intensive operations with compression enabled.
>> I don't know if this is significant, but it seems to be worse with lzo compression than zlib, and also seems to be worse when compression is enabled at the filesystem level instead of through 'chattr +c’.
> Zlib isn’t that performant compared to lzo. So zlib creates a bottleneck at the CPU and thereby limits the IO the volume is exposed to. So our problem might be related to intensive operations on the volume.
>
>> I'm not certain, but I think it might have something to do with the somewhat brain-dead default parameters in the default I/O scheduler (the so-called 'completely fair queue', which as I've said before was obviously named by a mathematician and not based on it's actual behavior), although it seems to be much worse when using the Deadline and no-op I/O schedulers.
> Good idea. I had a look to my configuration of the “stack” for the block devices and their queuing and caching. My setup looks like this (with default settings - I made no adjustments):
>
> * 2 HDDs
> * Hewlett-Packard Company Smart Array Gen8 Controllers (rev 01)
>    [With 1GB write cache. Other black magic seems to be included. Combines both HDDs to a RAID1]
> * Block device driver
> * IO Scheduler: deadline
> * LVM
> * QEMU
>    [With writeback cache. Should I change it to “none"? The storage controller has write cache included.]
> * virtio-blk
> * btrfs
>
> As you can see, only one IO scheduler is involved. The VM by default seems not to use any IO schedulers. I checked this by executing “cat /sys/block/vd*/queue/scheduler” on the VM and it reported “none”.
Yeah, thankfully Linux is smart enough to turn off the I/O scheduler for 
block devices that it can see are virtualized.

At the very least, I would suggest changing QEMU to not use caching. 
I've found that host-side caching for virtualized block devices tends to 
just make things slower unless the block device is imported over the 
netowkr (ie, iSCSI/ATAoE/NBD).  This is especially significant when you 
have a storage controller with such a big write-cache (I would make sure 
that the write-cache on the storage controller is non-volatile first 
though, if it isn't you should probably use writethrough mode for QEMU's 
caching).

Additionally, you might want to try using CFQ for the I/O scheduler on 
the host side, albeit with some non-default parameters (the deadline 
scheduler tends to get very laggy with really heavy random-access 
workloads).  I've found that it does do well when you actually take the 
time to fine tune things.  The particular parameters I would suggest 
some experimentation with for CFQ are:
  * Under /sys/block/<device>/queue: nomerges, rq_affinity, max_sectors_kb
  * Under /sys/block/<device>/queue/iosched: group_idle, quantum, 
slice_idle, back_seek_max, back_seek_penalty
There is good information on what each of these does in the kernel 
sources under Documentation/block/queue-sysfs.txt and 
Documentation/block/cfq-iosched.txt
Once you find a set of parameters that work well, I'd suggest writing 
some simple udev rules to automatically set them on boot/device enumeration.

FWIW, I've found that the following parameters provide near optimal 
performance for the SSD in my laptop:
queue/nomerges=1
queue/rq_affinity=2
queue/max_sectors_kb=16387 (16MB, which is 4x the erase-block size on 
the SSD)
queue/iosched/group_idle=8
queue/iosched/quantum=128 (this also happens to be equal to the device's 
NCQ queue depth)
queue/iosched/slice_idle=0
Using these settings, the time from the boot-loader handing off 
execution to the kernel to having a login prompt is about 45 seconds. 
With the default CFQ parameters, it takes almost 150 seconds, so fine 
tuning here can provide a very noticeable performance improvement.

