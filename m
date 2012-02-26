From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: LABEL only 1 device
Date: 26 Feb 2012 17:57:00 +0100
Message-ID: <C3b1BrAT1uB@helmut.hullen.de>
References: <20120226164400.GC18898@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120226164400.GC18898@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 26.02.12:

>> My (planned) usual work (once a year or so):
>>
>>         btrfs device add <biggerdevice> <path>
>>         btrfs filesystem balance <path>
>>         btrfs device delete <smallerdevice> <path>

>    OK, the real problem you're seeing is that when btrfs removes a
> device from the filesystem, that device is not modified in any way.
> This means that the old superblock is left behind on it, containing
> the FS label information. What you need to do is, immediately after
> removing a device from the FS, zero the first part of the partition
> with dd and /dev/zero.

Ok - I'll try again (not today ...).
If I remember correct in early times deleting only the first block of  
the partition didn't reach ...

My last try with "delete" let me believe that btrfs had deleted the  
"critical" informations; I had tested it with "blkid". But looking into  
the first sector of the partition may be more reliable.

>> I prefer LABELling the devices/partitions, and then I'd seen that
>> the option "-L" makes problems when I use it for more than 1 device/
>> partition.

[...]

>    I say again, partitions are not labelled. *Filesystems* are
> labelled. I think that with a GPT you can refer to the disk itself
> and its partitions by a UUID each, but I'm not 100% certain.

My last try:

        mkfs.btrfs -d raid0 -m raid1 /dev/sdk1 /dev/sdl1 /dev/sdm1

        mkfs.btrfs -L SCSI /dev/sdk1

seemed to work.

        mount LABEL=SCSI /mnt/btr

worked as expected, the bundle of 3 partitions was mounted. And only "/ 
dev/sdk1" got this label, no other partition.

Viele Gruesse!
Helmut
