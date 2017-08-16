Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.132]:56835 "EHLO mail.arhont.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751370AbdHPLsm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 07:48:42 -0400
Date: Wed, 16 Aug 2017 12:48:42 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>
Message-ID: <18522132.418.1502884115575.JavaMail.gkos@dynomob>
In-Reply-To: <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
References: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag> <4772c3f2-0074-d86f-24c4-02ff0730fce7@rqc.ru> <064eaaed-7748-7064-874e-19d270d0854e@profihost.ag> <4669553.344.1502874134710.JavaMail.gkos@dynomob> <f6f3998b-3ca7-7344-a577-6b02a5b11359@profihost.ag>
Subject: Re: slow btrfs with a single kworker process using 100% CPU
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I believe the chunk size of 512kb is even worth for performance then the default settings on my HW RAID of  256kb.

Peter Grandi explained it earlier on in one of his posts.

QTE
++++++
That runs counter to this simple story: suppose a program is
doing 64KiB IO:

* For *reads*, there are 4 data drives and the strip size is
  16KiB: the 64KiB will be read in parallel on 4 drives. If the
  strip size is 256KiB then the 64KiB will be read sequentially
  from just one disk, and 4 successive reads will be read
  sequentially from the same drive.

* For *writes* on a parity RAID like RAID5 things are much, much
  more extreme: the 64KiB will be written with 16KiB strips on a
  5-wide RAID5 set in parallel to 5 drives, with 4 stripes being
  updated with RMW. But with 256KiB strips it will partially
  update 5 drives, because the stripe is 1024+256KiB, and it
  needs to do RMW, and four successive 64KiB drives will need to
  do that too, even if only one drive is updated. Usually for
  RAID5 there is an optimization that means that only the
  specific target drive and the parity drives(s) need RMW, but
  it is still very expensive.

This is the "storage for beginners" version, what happens in
practice however depends a lot on specific workload profile
(typical read/write size and latencies and rates), caching and
queueing algorithms in both Linux and the HA firmware.
++++++
UNQTE


I've also found another explanation of the same problem with the right chunk size and how it works here
http://holyhandgrenade.org/blog/2011/08/disk-performance-part-2-raid-layouts-and-stripe-sizing/#more-1212



So in my understanding, when working with compressed data, your compressed data will vary between 128kb (urandom) and 32kb (zeroes) that will be passed to the FS to take care of.

and in our setup of large chunk sizes, if we need to write 32kb-128kb of compressed data, the RAID5 would need to perform  3 read operations and 2 write operations.

As updating a parity chunk requires either
- The original chunk, the new chunk, and the old parity block
- Or, all chunks (except for the parity chunk) in the stripe

disk        disk1   disk2   disk3   disk4
chunk size  512kb   512kb   512kb   512kbP

So in worst case scenario, in order to write 32kb, RAID5 would need to read (480 + 512 + P512) then write (32 + P512)

That's my current understanding of the situation.
I was planning to write an update to my story later on, once I hopefully solve the problem. But an intermidiary update is that I have performed full defrag with full compression (2 days). Then balance of the all data (10 days)and it didn't help the performance .

So now I am moving the data from the array and will be rebuilding it with 64 or 32 chunk size and checking the performance.

VG,
kos



----- Original Message -----
From: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
Sent: Wednesday, 16 August, 2017 11:26:38 AM
Subject: Re: slow btrfs with a single kworker process using 100% CPU

Am 16.08.2017 um 11:02 schrieb Konstantin V. Gavrilenko:
> Could be similar issue as what I had recently, with the RAID5 and 256kb chunk size.
> please provide more information about your RAID setup.

Hope this helps:

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath]
[raid0] [raid10]
md0 : active raid5 sdd1[1] sdf1[4] sdc1[0] sde1[2]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 6/30 pages [24KB], 65536KB chunk

md2 : active raid5 sdm1[2] sdl1[1] sdk1[0] sdn1[4]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 7/30 pages [28KB], 65536KB chunk

md1 : active raid5 sdi1[2] sdg1[0] sdj1[4] sdh1[1]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 7/30 pages [28KB], 65536KB chunk

md3 : active raid5 sdp1[1] sdo1[0] sdq1[2] sdr1[4]
      11717406720 blocks super 1.2 level 5, 512k chunk, algorithm 2
[4/4] [UUUU]
      bitmap: 6/30 pages [24KB], 65536KB chunk

# btrfs fi usage /vmbackup/
Overall:
    Device size:                  43.65TiB
    Device allocated:             31.98TiB
    Device unallocated:           11.67TiB
    Device missing:                  0.00B
    Used:                         30.80TiB
    Free (estimated):             12.84TiB      (min: 12.84TiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID0: Size:31.83TiB, Used:30.66TiB
   /dev/md0        7.96TiB
   /dev/md1        7.96TiB
   /dev/md2        7.96TiB
   /dev/md3        7.96TiB

Metadata,RAID0: Size:153.00GiB, Used:141.34GiB
   /dev/md0       38.25GiB
   /dev/md1       38.25GiB
   /dev/md2       38.25GiB
   /dev/md3       38.25GiB

System,RAID0: Size:128.00MiB, Used:2.28MiB
   /dev/md0       32.00MiB
   /dev/md1       32.00MiB
   /dev/md2       32.00MiB
   /dev/md3       32.00MiB

Unallocated:
   /dev/md0        2.92TiB
   /dev/md1        2.92TiB
   /dev/md2        2.92TiB
   /dev/md3        2.92TiB


Stefan

> 
> p.s.
> you can also check the tread "Btrfs + compression = slow performance and high cpu usage"
> 
> ----- Original Message -----
> From: "Stefan Priebe - Profihost AG" <s.priebe@profihost.ag>
> To: "Marat Khalili" <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
> Sent: Wednesday, 16 August, 2017 10:37:43 AM
> Subject: Re: slow btrfs with a single kworker process using 100% CPU
> 
> Am 16.08.2017 um 08:53 schrieb Marat Khalili:
>>> I've one system where a single kworker process is using 100% CPU
>>> sometimes a second process comes up with 100% CPU [btrfs-transacti]. Is
>>> there anything i can do to get the old speed again or find the culprit?
>>
>> 1. Do you use quotas (qgroups)?
> 
> No qgroups and no quota.
> 
>> 2. Do you have a lot of snapshots? Have you deleted some recently?
> 
> 1413 Snapshots. I'm deleting 50 of them every night. But btrfs-cleaner
> process isn't running / consuming CPU currently.
> 
>> More info about your system would help too.
> Kernel is OpenSuSE Leap 42.3.
> 
> btrfs is mounted with
> compress-force=zlib
> 
> btrfs is running as a raid0 on top of 4 md raid 5 devices.
> 
> Greets,
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
