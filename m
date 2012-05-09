From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: failed disk
Date: 09 May 2012 17:14:00 +0200
Message-ID: <C8XJ9Fm9CXB@helmut.hullen.de>
References: <20120509143735.GQ8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120509143735.GQ8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 09.05.12:

>>>    mkfs.btrfs -m raid1 -d single should give you that.

>> Just a small bug, perhaps:
>>
>> created a system with
>>
>>         mkfs.btrfs -m raid1 -d single /dev/sdl1
>>         mount /dev/sdl1 /mnt/Scsi
>>         btrfs device add /dev/sdk1 /mnt/Scsi
>>         btrfs device add /dev/sdm1 /mnt/Scsi
>>         (filling with data)
>>
>> and
>>
>>         btrfs fi df /mnt/Scsi
>>
>> now tells
>>
>> Data, RAID0: total=183.18GB, used=76.60GB
>> Data: total=80.01GB, used=79.83GB
>> System, DUP: total=8.00MB, used=32.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=1.00GB, used=192.74MB
>> Metadata: total=8.00MB, used=0.00
>>
>> --------------------------------------
>>
>> "Data, RAID0" confuses me (not very much ...), and the system for
>> metadata (RAID1) is not told.

>    DUP is two copies of each block, but it allows the two copies to
> live on the same device. It's done this because you started with a
> single device, and you can't do RAID-1 on one device. The first bit
> of metadata you write to it should automatically upgrade the DUP
> chunk to RAID-1.

Ok.

Sounds familiar - have you explained that to me many months ago?

>    As to the spurious "upgrade" of single to RAID-0, I thought Ilya
> had stopped it doing that. What kernel version are you running?

3.2.9, self made.
I could test the message with 3.3.4, but not today (if it's only an  
interpretation of always the same data).

>    Out of interest, why did you do the device adds separately,
> instead of just this?

a) making the first 2 devices: I have tested both versions (one line  
with 2 devices or 2 lines with 1 device); no big difference.

But I had tested the option "-L" (labelling) too, and that makes shit  
for the oneliner: both devices get the same label, and then "findfs"  
finds none of them.

The really safe way would be: deleting this option for the "mkfs.btrfs"  
command and only using

        btrfs fi label <device> [<newlabel>]

b) third device: that's my usual test:
        make a cluster of 2 deivces
        fill them with data
        add a third device
        delete the smallest device

Viele Gruesse!
Helmut
