Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:55325 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751119AbdLBCVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Dec 2017 21:21:55 -0500
Date: Sat, 2 Dec 2017 03:21:53 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202022153.GA7727@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 02, 2017 at 09:47:19 +0800, Qu Wenruo wrote:

>> Actually I should rephrase the problem:
>> 
>> "snapshot has taken 8 GB of space despite nothing has altered source subvolume"

Actually, after:

# btrfs balance start -v -dconvert=raid1 /
ctrl-c on block group 35G/113G
# btrfs balance start -v -dconvert=raid1,soft /
# btrfs balance start -v -dusage=55 /
Done, had to relocate 1 out of 56 chunks
# btrfs balance start -v -musage=55 /
Done, had to relocate 2 out of 55 chunks

and waiting a few minutes after ...the 8 GB I've lost yesterday is back:

#  btrfs fi sh /
Label: none  uuid: 17a3de25-6e26-4b0b-9665-ac267f6f6c4a
        Total devices 2 FS bytes used 44.10GiB
        devid    1 size 64.00GiB used 54.00GiB path /dev/sda2
        devid    2 size 64.00GiB used 54.00GiB path /dev/sdb2

#  btrfs fi usage /
Overall:
    Device size:                 128.00GiB
    Device allocated:            108.00GiB
    Device unallocated:           20.00GiB
    Device missing:                  0.00B
    Used:                         88.19GiB
    Free (estimated):             18.75GiB      (min: 18.75GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              131.14MiB      (used: 0.00B)

Data,RAID1: Size:51.97GiB, Used:43.22GiB
   /dev/sda2      51.97GiB
   /dev/sdb2      51.97GiB

Metadata,RAID1: Size:2.00GiB, Used:895.69MiB
   /dev/sda2       2.00GiB
   /dev/sdb2       2.00GiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sda2      32.00MiB
   /dev/sdb2      32.00MiB

Unallocated:
   /dev/sda2      10.00GiB
   /dev/sdb2      10.00GiB

#  btrfs dev usage /
/dev/sda2, ID: 1
   Device size:            64.00GiB
   Device slack:              0.00B
   Data,RAID1:             51.97GiB
   Metadata,RAID1:          2.00GiB
   System,RAID1:           32.00MiB
   Unallocated:            10.00GiB

/dev/sdb2, ID: 2
   Device size:            64.00GiB
   Device slack:              0.00B
   Data,RAID1:             51.97GiB
   Metadata,RAID1:          2.00GiB
   System,RAID1:           32.00MiB
   Unallocated:            10.00GiB

#  btrfs fi df /    
Data, RAID1: total=51.97GiB, used=43.22GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=895.69MiB
GlobalReserve, single: total=131.14MiB, used=0.00B

# df
/dev/sda2        64G   45G   19G  71% /

However the difference is on active root fs:

-0/291        24.29GiB      9.77GiB
+0/291        15.99GiB     76.00MiB

Still, 45G used, while there is (if I counted this correctly) 25G of data...

> Then please provide correct qgroup numbers.
> 
> The correct number should be get by:
> # btrfs quota enable <mnt>
> # btrfs quota rescan -w <mnt>
> # btrfs qgroup show -prce --sync <mnt>

OK, just added the --sort=excl:

qgroupid         rfer         excl     max_rfer     max_excl parent  child 
--------         ----         ----     --------     -------- ------  ----- 
0/5          16.00KiB     16.00KiB         none         none ---     ---  
0/361        22.57GiB      7.00MiB         none         none ---     ---  
0/358        22.54GiB      7.50MiB         none         none ---     ---  
0/343        22.36GiB      7.84MiB         none         none ---     ---  
0/345        22.49GiB      8.05MiB         none         none ---     ---  
0/357        22.50GiB      9.27MiB         none         none ---     ---  
0/360        22.57GiB     10.27MiB         none         none ---     ---  
0/344        22.48GiB     11.09MiB         none         none ---     ---  
0/359        22.55GiB     12.57MiB         none         none ---     ---  
0/362        22.59GiB     22.96MiB         none         none ---     ---  
0/302        12.87GiB     31.23MiB         none         none ---     ---  
0/428        15.96GiB     38.68MiB         none         none ---     ---  
0/294        11.09GiB     47.86MiB         none         none ---     ---  
0/336        21.80GiB     49.59MiB         none         none ---     ---  
0/300        12.56GiB     51.43MiB         none         none ---     ---  
0/342        22.31GiB     52.93MiB         none         none ---     ---  
0/333        21.71GiB     54.54MiB         none         none ---     ---  
0/363        22.63GiB     58.83MiB         none         none ---     ---  
0/370        23.27GiB     59.46MiB         none         none ---     ---  
0/305        13.01GiB     61.47MiB         none         none ---     ---  
0/331        21.61GiB     61.49MiB         none         none ---     ---  
0/334        21.78GiB     62.95MiB         none         none ---     ---  
0/306        13.04GiB     64.11MiB         none         none ---     ---  
0/304        12.96GiB     64.90MiB         none         none ---     ---  
0/303        12.94GiB     68.39MiB         none         none ---     ---  
0/367        23.20GiB     68.52MiB         none         none ---     ---  
0/366        23.22GiB     69.79MiB         none         none ---     ---  
0/364        22.63GiB     72.03MiB         none         none ---     ---  
0/285        10.78GiB     75.95MiB         none         none ---     ---  
0/291        15.99GiB     76.24MiB         none         none ---     ---  <- this one (default rootfs) got fixed
0/323        21.35GiB     95.85MiB         none         none ---     ---  
0/369        23.26GiB     96.12MiB         none         none ---     ---  
0/324        21.36GiB    104.46MiB         none         none ---     ---  
0/327        21.36GiB    115.42MiB         none         none ---     ---  
0/368        23.27GiB    118.25MiB         none         none ---     ---  
0/295        11.20GiB    148.59MiB         none         none ---     ---  
0/298        12.38GiB    283.41MiB         none         none ---     ---  
0/260        12.25GiB      3.22GiB         none         none ---     ---  <- 170712, initial snapshot, OK
0/312        17.54GiB      4.56GiB         none         none ---     ---  <- 170811, definitely less excl
0/388        21.69GiB      7.16GiB         none         none ---     ---  <- this one has <100M exclusive


So the one block of data was released, but there are probably two more
stuck here. If the 4.5G and 7G were freed I would have 45-4.5-7=33G used,
which would agree with the 25G of data I've counted manually.

Any ideas how to look inside these two snapshots?

> Rescan and --sync are important to get the correct number.
> (while rescan can take a long long time to finish)

#  time btrfs quota rescan -w /
quota rescan started
btrfs quota rescan -w /  0.00s user 0.00s system 0% cpu 30.798 total

> And further more, please ensure that all deleted files are really deleted.
> Btrfs delay file and subvolume deletion, so you may need to sync several
> times or use "btrfs subv sync" to ensure deleted files are deleted.

Yes, I was aware about that. However I've never had to wait after rebalance...

regards,
-- 
Tomasz Pala <gotar@pld-linux.org>
