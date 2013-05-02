Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52656 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760451Ab3EBSwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 May 2013 14:52:09 -0400
Received: by mail-ob0-f177.google.com with SMTP id un3so761092obb.22
        for <linux-btrfs@vger.kernel.org>; Thu, 02 May 2013 11:52:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG42UxfctrmBK_rgVSusjQX8ur_6u_QgA1LGhRV-UW=WT8gTsA@mail.gmail.com>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda> <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
 <20130418215856.GA2305@localhost.localdomain> <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
 <20130425203900.GL2631@localhost.localdomain> <CAG42UxcVhXT5=kgUedAWDbSnPuW_Nu---PsG+WRuNCFn9Kdeng@mail.gmail.com>
 <20130425211019.GM2631@localhost.localdomain> <CAG42UxfctrmBK_rgVSusjQX8ur_6u_QgA1LGhRV-UW=WT8gTsA@mail.gmail.com>
From: Matt Pursley <mpursley@gmail.com>
Date: Thu, 2 May 2013 11:51:27 -0700
Message-ID: <CAG42UxcPiXYpngEyOfCmRJan1kc6N2WyvGT+6rFu2QQTBE7CyA@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Josef,

Were you able to try this multi-thread test on any more drives?


I did a test with 12, 6, 3, and 1 drive.  And, it looks like I see the
multi-thread speed reduces, as the number of drives in the raid goes
up.

Like this:
- 50% speed reduction with 2 threads on 12 drives
- 25% speed reduction with 2 threads on 6 drives
- 10% speed reduction with 2 threads on 3 drives
- 5% speed reduction with 2 threads on 1 drive



I only have 12 slots on my HBA card, but I wonder if 24 drives would
reduce the speed to 25% with 2 threads?

Matt










make btrfs fs...
___

12 drives...
mkfs.btrfs -f -d raid6 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde
/dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl

6 drives...
mkfs.btrfs -f -d raid6 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf

3 drives...
mkfs.btrfs -f -d raid5 /dev/sda /dev/sdb /dev/sdc

1 drive...
mkfs.btrfs -f /dev/sda

mount /dev/sda /tmp/btrfs_test/

___


make zero files...
___
kura1 ~ # for j in {1..2} ; do dd if=/dev/zero
of=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M count=10000
conv=fdatasync & done
___


===================

btrfs raid6 on 12 drives with 2 threads = ~650MB/s
___
kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
vm.drop_caches = 1
10485760000 bytes (10 GB) copied, 31.0431 s, 338 MB/s
10485760000 bytes (10 GB) copied, 31.2235 s, 336 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 29.869 s, 351 MB/s
10485760000 bytes (10 GB) copied, 30.5561 s, 343 MB/s

___


btrfs raid6 on 12 drives with 1 thread = ~1100MB/s
___
kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 9.69881 s, 1.1 GB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 9.56475 s, 1.1 GB/s
___


==================

btrfs raid6 on 6 drives with 2 thread =  ~500MB/s
___
 kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 41.3899 s, 253 MB/s
10485760000 bytes (10 GB) copied, 41.6916 s, 252 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 40.3178 s, 260 MB/s
10485760000 bytes (10 GB) copied, 41.4087 s, 253 MB/s

___



btrfs raid6 on 6 drives with 1 thread =  ~600MB/s
___

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 17.5686 s, 597 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 17.5396 s, 598 MB/s
___


==================

btrfs raid5 on 3 drives with 2 thread = ~300MB/s
___

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 67.636 s, 155 MB/s
10485760000 bytes (10 GB) copied, 70.1783 s, 149 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 69.4945 s, 151 MB/s
10485760000 bytes (10 GB) copied, 70.8279 s, 148 MB/s

___



btrfs raid5 on 3 drives with 1 thread = ~319MB/s
___

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 32.8559 s, 319 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 32.8483 s, 319 MB/s

___


==================


btrfs (no raid) on 1 drive with 2 thread =  ~155MB/s
___
 kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 134.982 s, 77.7 MB/s
10485760000 bytes (10 GB) copied, 135.237 s, 77.5 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..2} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 134.549 s, 77.9 MB/s
10485760000 bytes (10 GB) copied, 135.293 s, 77.5 MB/s


___


btrfs (no raid) on 1 drive with 1 thread =  ~162MB/s
___

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 64.5931 s, 162 MB/s

kura1 btrfs_test # sysctl vm.drop_caches=1 ; for j in {1..1} ; do dd
of=/dev/null if=/tmp/btrfs_test/testfile_bs1m_size10GB_${j} bs=1M &
done
10485760000 bytes (10 GB) copied, 64.6299 s, 162 MB/s

___



==================







On Fri, Apr 26, 2013 at 4:21 PM, Matt Pursley <mpursley@gmail.com> wrote:
> Hey Josef,
>
> Thanks for looking into this further!    That is about the same
> results that I was seeing, though I didn't test it with just one
> drive.. only with all 12 drives in my jbod.  I will do a test with
> just one disk, and see if I also get the same results.
>
> Let me know if you also see the same results with multiple drives in
> your raid...
>
>
> Thanks,
> Matt
>
>
>
>
>
> On Thu, Apr 25, 2013 at 2:10 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> On Thu, Apr 25, 2013 at 03:01:18PM -0600, Matt Pursley wrote:
>>> Ok, awesome, let me know how it goes..  I don't have the raid
>>> formatted to btrfs right now, but I could probably do that in about 30
>>> minutes or so.
>>>
>>
>> Huh so I'm getting the full bandwidth, 120 mb/s with one thread and 60 mb/s with
>> two threads.  These are just cheap sata drives tho, I'll try and dig up a box
>> with 3 fusion cards for something a little closer to the speeds you are seeing
>> and see if that makes a difference.  Thanks,
>>
>> Josef
