Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.111]:58126 "EHLO
        mail1.arhont.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdHaK4x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 06:56:53 -0400
Date: Thu, 31 Aug 2017 11:56:47 +0100 (BST)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.UK>
Message-ID: <7655278.170.1504177003160.JavaMail.gkos@dynomob>
In-Reply-To: <22912.57311.417226.447973@tree.ty.sabi.co.uk>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob> <22907.32175.311827.10738@tree.ty.sabi.co.uk> <19527869.26.1501422186960.JavaMail.gkos@dynomob> <22911.5971.350346.969146@tree.ty.sabi.co.uk> <6022267.255.1501581534233.JavaMail.gkos@dynomob> <22912.32415.601826.757780@tree.ty.sabi.co.uk> <15990599.40.1501611004053.JavaMail.gkos@dynomob> <22912.57311.417226.447973@tree.ty.sabi.co.uk>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello again list. I thought I would clear the things out and describe what is happening with my troubled RAID setup.

So having received the help from the list, I've initially run the full defragmentation of all the data and recompressed everything with zlib. 
That didn't help. Then I run the full rebalance of the data and that didn't help either.

So I had to take a disk out of the raid, copy all the data onto it, recreate the RAID drive with 32kb chunk size and 96kb stripe and copied the data back. Then added the disk back and resynced the raid.


So currently the RAID device is 

Adapter 0 -- Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 21.830 TB
Sector Size         : 512
Is VD emulated      : Yes
Parity Size         : 7.276 TB
State               : Optimal
Strip Size          : 32 KB
Number Of Drives    : 4
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
Bad Blocks Exist: No
Is VD Cached: No


It is about 40% full with compressed data
# btrfs fi usage /mnt/arh-backup1/
Overall:
    Device size:                  21.83TiB
    Device allocated:              8.98TiB
    Device unallocated:           12.85TiB
    Device missing:                  0.00B
    Used:                          8.98TiB
    Free (estimated):             12.85TiB      (min: 6.43TiB)
    Data ratio:                       1.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)


I've decided to run a set of test, where 5 gb file was created using different blocksizes and different flags.
one file with urandom data was generated and another one filled with zeroes. the data was written with compression and without compression, and it seems that without compression it is possible to gain 30-40% speed, while the cpu was running at 50% idle during the highest loads.
dd write speeds (mb/s)

flags: conv=fsync
compress-force=zlib  compress-force=none
         RAND ZERO    RAND ZERO
bs1024k  387  407     584  577
bs512k   389  414     532  547
bs256k   412  409     558  585
bs128k   412  403     572  583
bs64k    409  419     563  574
bs32k    407  404     569  572


flags: oflag=sync
compress-force=zlib  compress-force=none
         RAND  ZERO    RAND  ZERO
bs1024k  86.1  97.0    203   210
bs512k   50.6  64.4    85.0  170
bs256k   25.0  29.8    67.6  67.5
bs128k   13.2  16.4    48.4  49.8
bs64k    7.4   8.3     24.5  27.9
bs32k    3.8   4.1     14.0  13.7




flags: no flags
compress-force=zlib  compress-force=none
         RAND  ZERO    RAND  ZERO
bs1024k  480   419     681   595
bs512k   422   412     633   585
bs256k   413   384     707   712
bs128k   414   387     695   704
bs64k    482   467     622   587
bs32k    416   412     610   598


I have also run a test where I filled the array to about 97% capacity and the write speed went down by about 50% compared with the empty RAID.


thanks for the help. 

----- Original Message -----
From: "Peter Grandi" <pg@btrfs.list.sabi.co.UK>
To: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
Sent: Tuesday, 1 August, 2017 10:09:03 PM
Subject: Re: Btrfs + compression = slow performance and high cpu usage

>> [ ... ] a "RAID5 with 128KiB writes and a 768KiB stripe
>> size". [ ... ] several back-to-back 128KiB writes [ ... ] get
>> merged by the 3ware firmware only if it has a persistent
>> cache, and maybe your 3ware does not have one,

> KOS: No I don't have persistent cache. Only the 512 Mb cache
> on board of a controller, that is BBU.

If it is a persistent cache, that can be battery-backed (as I
wrote, but it seems that you don't have too much time to read
replies) then the size of the write, 128KiB or not, should not
matter much; the write will be reported complete when it hits
the persistent cache (whichever technology it used), and then
the HA fimware will spill write cached data to the disks using
the optimal operation width.

Unless the 3ware firmware is really terrible (and depending on
model and vintage it can be amazingly terrible) or the battery
is no longer recharging and then the host adapter switches to
write-through.

That you see very different rates between uncompressed and
compressed writes, where the main difference is the limitation
on the segment size, seems to indicate that compressed writes
involve a lot of RMW, that is sub-stripe updates. As I mentioned
already, it would be interesting to retry 'dd' with different
'bs' values without compression and with 'sync' (or 'direct'
which only makes sense without compression).

> If I had additional SSD caching on the controller I would have
> mentioned it.

So far you had not mentioned the presence of BBU cache either,
which is equivalent, even if in one of your previous message
(which I try to read carefully) there were these lines:

>>>> Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU
>>>> Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if Bad BBU

So perhaps someone else would have checked long ago the status
of the BBU and whether the "No Write Cache if Bad BBU" case has
happened. If the BBU is still working and the policy is still
"WriteBack" then things are stranger still.

> I was also under impression, that in a situation where mostly
> extra large files will be stored on the massive, the bigger
> strip size would indeed increase the speed, thus I went with
> with the 256 Kb strip size.

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

> Would I be correct in assuming that the RAID strip size of 128
> Kb will be a better choice if one plans to use the BTRFS with
> compression?

That would need to be tested, because of "depends a lot on
specific workload profile, caching and queueing algorithms", but
my expectation is the the lower the better. Given that you have
4 drives giving a 3+1 RAID set, perhaps a 32KiB or 64KiB strip
size, given a data stripe size of 96KiB or 192KiB, would be
better.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
