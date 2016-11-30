Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35460 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753498AbcK3PoC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 10:44:02 -0500
Received: by mail-io0-f196.google.com with SMTP id h133so3170661ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Nov 2016 07:44:01 -0800 (PST)
Subject: Re: Convert from RAID 5 to 10
To: Roman Mamedov <rm@romanrm.net>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <4ef63089-407d-0f18-b182-74c631874a02@gmail.com>
 <0d3d3ecd-44a4-fb7f-8f68-aca342d89d04@googlemail.com>
 <CAJCQCtSnt5yqm6kpA2AOz7p=wZFVxzUz8RH8r2o73ym45mYVFg@mail.gmail.com>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu>
 <d9a72702-0507-c085-3bed-7ee5f8063ae3@gmail.com>
 <20161130190404.4f0e4bd5@natsu>
Cc: Wilson Meier <wilson.meier@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <074d7199-7a33-a7b7-9525-ebb4a062849d@gmail.com>
Date: Wed, 30 Nov 2016 10:43:55 -0500
MIME-Version: 1.0
In-Reply-To: <20161130190404.4f0e4bd5@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-30 09:04, Roman Mamedov wrote:
> On Wed, 30 Nov 2016 07:50:17 -0500
> "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>
>>> *) Read performance is not optimized: all metadata is always read from the
>>> first device unless it has failed, data reads are supposedly balanced between
>>> devices per PID of the process reading. Better implementations dispatch reads
>>> per request to devices that are currently idle.
>> Based on what I've seen, the metadata reads get balanced too.
>
> https://github.com/torvalds/linux/blob/v4.8/fs/btrfs/disk-io.c#L451
> This starts from the mirror number 0 and tries others in an incrementing
> order, until succeeds. It appears that as long as the mirror with copy #0 is up
> and not corrupted, all reads will simply get satisfied from it.
That's actually how all reads work, it's just that the PID selects what 
constitutes the 'first' copy.  IIRC, that selection is doen by a lower 
layer.
>
>>> *) Write performance is not optimized, during long full bandwidth sequential
>>> writes it is common to see devices writing not in parallel, but with a long
>>> periods of just one device writing, then another. (Admittedly have been some
>>> time since I tested that).
>> I've never seen this be an issue in practice, especially if you're using
>> transparent compression (which caps extent size, and therefore I/O size
>> to a given device, at 128k).  I'm also sane enough that I'm not doing
>> bulk streaming writes to traditional HDD's or fully saturating the
>> bandwidth on my SSD's (you should be over-provisioning whenever
>> possible).  For a desktop user, unless you're doing real-time video
>> recording at higher than HD resolution with high quality surround sound,
>> this probably isn't going to hit you (and even then you should be
>> recording to a temporary location with much faster write speeds (tmpfs
>> or ext4 without a journal for example) because you'll likely get hit
>> with fragmentation).
>
> I did not use compression while observing this;
Compression doesn't make things parallel, but it does cause BTRFS to 
distribute the writes more evenly because it writes first one extent 
then the other, which in turn makes things much more efficient because 
you're not stalling as much waiting for the I/O queue to finish.  It 
also means you have to write less overall to the disk, so on systems 
which can do LZO compression significantly faster than they can write to 
or read from the disk, it will generally improve performance all around.
>
> Also I don't know what is particularly insane about copying a 4-8 GB file onto
> a storage array. I'd expect both disks to write at the same time (like they
> do in pretty much any other RAID1 system), not one-after-another, effectively
> slowing down the entire operation by as much as 2x in extreme cases.
I'm not talking 4-8GB files, I'm talking really big stuff at least an 
order of magnitude larger than that, stuff like filesystem images and 
big databases.  On the only system I have where I have traditional hard 
disks (7200RPM consumer SATA3 drives connected to an LSI MPT2SAS HBA, 
about 80-100MB/s bulk write speed to a single disk), an 8GB copy from 
tmpfs is only in practice about 20% slower to BTRFS raid1 mode than to 
XFS on top of a DM-RAID RAID1 volume, and about 30% slower than the same 
with ext4.  In both cases, this is actually about 50% faster than ZFS 
(which does prallelize reads and writes) in an equivalent configuration 
on the same hardware.  Comparing all of that to single disk versions on 
the same hardware, I see roughly the same performance ratios between 
filesystems, and the same goes for running on the motherboard's SATA 
controller instead of the LSI HBA.  In this case, I am using compression 
(and the data gets reasonable compression ratios), and I see both disks 
running at just below peak bandwidth, and based on tracing, most of the 
difference is in the metadata updates required to change the extents.

I would love to see BTRFS properly parallelize writes and stripe reads 
sanely, but I seriously doubt it's going to have as much impact as you 
think, especially on systems with fast storage.
>
>> As far as not mounting degraded by default, that's a conscious design
>> choice that isn't going to change.  There's a switch (adding 'degraded'
>> to the mount options) to enable this behavior per-mount, so we're still
>> on-par in that respect with LVM and MD, we just picked a different
>> default.  In this case, I actually feel it's a better default for most
>> cases, because most regular users aren't doing exhaustive monitoring,
>> and thus are not likely to notice the filesystem being mounted degraded
>> until it's far too late.  If the filesystem is degraded, then
>> _something_ has happened that the user needs to know about, and until
>> some sane monitoring solution is implemented, the easiest way to ensure
>> this is to refuse to mount.
>
> The easiest is to write to dmesg and syslog, if a user doesn't monitor those
> either, it's their own fault; and the more user friendly one would be to still
> auto mount degraded, but read-only.
And mounting read-only will actually cause most distros to fail to boot 
properly too.  You'll generally end up with a system that only half 
works, and can't do almost anything with it.
>
> Comparing to Ext4, that one appears to have the "errors=continue" behavior by
> default, the user has to explicitly request "errors=remount-ro", and I have
> never seen anyone use or recommend the third option of "errors=panic", which
> is basically the equivalent of the current Btrfs practce.
And the default ext4 behavior tends to make things worse over time. 
I've lost 3 filesystems over the years because of that default.
>
>>> *) It does not properly handle a device disappearing during operation. (There
>>> is a patchset to add that).
>>>
>>> *) It does not properly handle said device returning (under a
>>> different /dev/sdX name, for bonus points).
>> These are not an easy problem to fix completely, especially considering
>> that the device is currently guaranteed to reappear under a different
>> name because BTRFS will still have an open reference on the original
>> device name.
>>
>> On top of that, if you've got hardware that's doing this without manual
>> intervention, you've got much bigger issues than how BTRFS reacts to it.
>>   No correctly working hardware should be doing this.
>
> Unplugging and replugging a SATA cable of a RAID1 member should never put your
> system under the risk of a massive filesystem corruption; you cannot say it
> absolutely doesn't with the current implementation.
>
For a single event like that?  Yes, it absolutely should be sanely 
handled.  For that happening repeatedly?  In that case, even LVM and MD 
will eventually fail (how long it takes is non-deterministic and 
probably NP hard if it happens randomly).

We should absolutely be able to handle someone hot-swapping a storage 
device while we're running without dying.  Beyond sanely going degraded 
though, pretty much everything else should be up to userspace (including 
detecting whether or not the newly swapped-in device is the same as the 
one that got swapped out).
