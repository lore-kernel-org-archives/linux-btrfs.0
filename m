Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41936 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992623AbcB0XPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Feb 2016 18:15:24 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe  doesnt work
Date: Sun, 28 Feb 2016 00:15:21 +0100
Message-ID: <1595760.q3He7oiP70@merkaba>
In-Reply-To: <20160227211450.GS26042@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Samstag, 27. Februar 2016 22:14:50 CET Marc Haber wrote:
> Hi,

Hi Marc.

> I have again the issue of no space left on device while rebalancing
> (with btrfs-tools 4.4.1 on kernel 4.4.2 on Debian unstable):
> 
> mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> ERROR: error during balancing '/mnt/fanbtr': No space left on device
> mh@fan:~$ sudo btrfs fi show /mnt/fanbtr
> mh@fan:~$ sudo btrfs fi show -m
> Label: 'fanbtr'  uuid: 4198d1bc-e3ce-40df-a7ee-44a2d120bff3
>         Total devices 1 FS bytes used 116.49GiB
>         devid    1 size 417.19GiB used 177.06GiB path /dev/mapper/fanbtr

Hmmm, thats still a ton of space to allocate chunks from.

> mh@fan:~$ sudo btrfs fi df /mnt/fanbtr
> Data, single: total=113.00GiB, used=112.77GiB
> System, DUP: total=32.00MiB, used=48.00KiB
> Metadata, DUP: total=32.00GiB, used=3.72GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> mh@fan:~$
> 
> The filesystem was recently resized from 300 GB to 420 GB.
> 
> Why does btrfs fi show /mnt/fanbtr not give any output? Wy does btrfs
> fi df /mnt/fanbtr say that my data space is only 113 GiB large?

Cause it is.

The "used" in "devid 1" line is btrfs fi sh is "data + 2x system + 2x metadata 
= 113 GiB + 2 * 32 GiB + 2 * 32 MiB, i.e. what amount of the size of the 
device is allocated for chunks.

The value one line above is what is allocated inside the chunks.

I.e. the line in "devid 1" is "total" of btrfs fi df summed up, and the line 
above is "used" in btrfs fi df summed up. And… with more devices you have more 
fun.

I suggest:

merkaba:~> btrfs fi usage -T /daten
Overall:
    Device size:                 235.00GiB
    Device allocated:            227.04GiB
    Device unallocated:            7.96GiB
    Device missing:                  0.00B
    Used:                        225.84GiB
    Free (estimated):              8.48GiB      (min: 8.48GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              128.00MiB      (used: 0.00B)

             Data      Metadata  System              
Id Path      single    single    single   Unallocated
-- --------- --------- --------- -------- -----------
 1 /dev/dm-1 226.00GiB   1.01GiB 32.00MiB     7.96GiB
-- --------- --------- --------- -------- -----------
   Total     226.00GiB   1.01GiB 32.00MiB     7.96GiB
   Used      225.48GiB 371.83MiB 48.00KiB 

as that is much clearer to read IMHO.

and

merkaba:~> btrfs device usage /daten   
/dev/dm-1, ID: 1
   Device size:           235.00GiB
   Data,single:           226.00GiB
   Metadata,single:         1.01GiB
   System,single:          32.00MiB
   Unallocated:             7.96GiB

(although thats include in the filesystem usage output)


Or for a BTRFS RAID 1:

merkaba:~> btrfs fi usage -T /home  
Overall:
    Device size:                 340.00GiB
    Device allocated:            340.00GiB
    Device unallocated:            2.00MiB
    Device missing:                  0.00B
    Used:                        306.47GiB
    Free (estimated):             14.58GiB      (min: 14.58GiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 0.00B)

             Data      Metadata System              
Id Path      RAID1     RAID1    RAID1    Unallocated
-- --------- --------- -------- -------- -----------
 1 /dev/dm-0 163.94GiB  6.03GiB 32.00MiB     1.00MiB
 2 /dev/dm-3 163.94GiB  6.03GiB 32.00MiB     1.00MiB
-- --------- --------- -------- -------- -----------
   Total     163.94GiB  6.03GiB 32.00MiB     2.00MiB
   Used      149.36GiB  3.88GiB 48.00KiB            


merkaba:~> btrfs device usage /home
/dev/dm-0, ID: 1
   Device size:           170.00GiB
   Data,RAID1:            163.94GiB
   Metadata,RAID1:          6.03GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.00MiB

/dev/dm-3, ID: 2
   Device size:           170.00GiB
   Data,RAID1:            163.94GiB
   Metadata,RAID1:          6.03GiB
   System,RAID1:           32.00MiB
   Unallocated:             1.00MiB


(this is actually the situation asking for hung task trouble with kworker 
threads seeking for free space inside chunks, as no new chunks can be 
allocated, lets hope kernel 4.4 finally really has fixes for this)

> btrfs balance start -dusage=5 works up to -dusage=100:
> 
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 111 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 111 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 110 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start -dusage=100 /mnt/fanbtr
> Done, had to relocate 109 out of 179 chunks
> mh@fan:~$ sudo btrfs balance start /mnt/fanbtr
> ERROR: error during balancing '/mnt/fanbtr': No space left on device
> mh@fan:~$
> 
> What is going on here? How do I get away from here?

Others may have better tips, but what can always work is:

Adding a new device temporarily, doing the balance and then removing it.

Before that I´d try to balance the metadata chunks, cause 

> Metadata, DUP: total=32.00GiB, used=3.72GiB

32 GiB chunks allocated, only 3,72 GiB used.

Maybe that way you can gain more free space to have a full balance run.

Also note that it is not necessary to do a full balance in case everything 
works okayish.

Thanks,
-- 
Martin
