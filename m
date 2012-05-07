From: Hullen@t-online.de (Helmut Hullen)
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: 07 May 2012 14:15:00 +0200
Message-ID: <C8PC6xN9CXB@helmut.hullen.de>
References: <20120507105944.GD8938@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120507105944.GD8938@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 07.05.12:

>> Yesterday I compiled kernel 3.3.4, and this morning I started the
>> machine with this kernel. There may be some ugly problems.
>>
>> Copying something into the btrfs "directory" worked well for some
>> files, and then I got error messages (I've not copied them,
>> something with "IO error" under Samba).

[...]

>> Data, RAID0: total=5.29TB, used=4.29TB
>> System, RAID1: total=8.00MB, used=352.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, RAID1: total=149.00GB, used=5.00GB

>>
>> Label: 'MMedia'  uuid: 9adfdc84-0fbe-431b-bcb1-cabb6a915e91
>> 	Total devices 3 FS bytes used 4.29TB
>> 	devid    3 size 2.73TB used 1.98TB path /dev/sdi1
>> 	devid    2 size 2.73TB used 1.94TB path /dev/sdf1
>> 	devid    1 size 1.82TB used 1.63TB path /dev/sdc1
>>
>> Btrfs Btrfs v0.19
>>
>> =================== boot messages, kernel related ==============
>>
>> [boot with kernel 3.3.4]
>> May  7 06:55:26 Arktur kernel: ata5: exception Emask 0x10 SAct 0x0
>> SErr 0x10000 action 0xe frozen
>> May  7 06:55:26 Arktur kernel: ata5: SError: { PHYRdyChg }
>> May  7 06:55:26 Arktur kernel: ata5: hard resetting link

>    This is a hardware error. You have a device that's either dead or
> dying. (Given the number of errors, probably already dead).

It seems to be undecided which status it has ...

>> Can I repair the system? Or have I to copy it to a set of other
>> disks?

>    If you have RAID-1 or RAID-10 on both data and netadata, then you
> _should_ in theory just be able to remove the dead disk (physically),
> then btrfs dev add a new one, btrfs dev del missing, and balance.


I haven't - I have a kind of copy/backup in the neighbourhood.

Viele Gruesse!
Helmut
