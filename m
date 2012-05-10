From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: failed disk
Date: 10 May 2012 04:49:00 +0200
Message-ID: <C8aKwmMPCXB@helmut.hullen.de>
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

It has done - ok. Adding and removing disks/partitions works as  
expected.

Viele Gruesse!
Helmut
