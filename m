From: Arne Jansen <sensille@gmx.net>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Wed, 06 Apr 2011 15:43:56 +0200
Message-ID: <4D9C6E1C.4040100@gmx.net>
References: <chaz20110321162450.GB918@seebyte.com> <chaz20110322092259.GA4861@seebyte.com> <AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com> <chaz20110328131748.GA18131@seebyte.com> <4D9C235C.1030106@gmx.net> <chaz20110406120535.GC20568@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110406120535.GC20568@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 06.04.2011 14:05, Stephane Chazelas wrote:
> 2011-04-06 10:25:00 +0200, Arne Jansen:
>> On 28.03.2011 15:17, Stephane Chazelas wrote:
>>>
>>> I then did a btrfs fi balance again and let it run through. However here is
>>> what I get:
>>>
>>> $ df -h /mnt
>>> Filesystem            Size  Used Avail Use% Mounted on
>>> /dev/sdb              8.2T  3.5T  3.2T  53% /mnt
>>>
>>> Only 3.2T left. How would I reclaim the missing space?
>>>
>>> $ sudo btrfs fi show
>>> Label: none  uuid: ...
>>>         Total devices 3 FS bytes used 3.43TB
>>>         devid    4 size 2.73TB used 1.17TB path /dev/sdc
>>>         devid    3 size 2.73TB used 1.17TB path /dev/sdb
>>>         devid    2 size 2.70TB used 1.14TB path /dev/sda4
>>> $ sudo btrfs fi df /mnt
>>> Data, RAID0: total=3.41TB, used=3.41TB
>>> System, RAID1: total=16.00MB, used=232.00KB
>>> Metadata, RAID1: total=35.25GB, used=20.55GB
>>>
>>> So that kind of worked but that is of little use to me as 2TB
>>> kind of disappeared under my feet in the process.
>>>
>>> Any idea, anyone?
>>>
>>
>> This can just be a miscalculation. Can you please send the output
>> of btrfs-debug-tree -d /dev/sdc? Shouldn't be too long.
> [..]
> 
> Hi Arne,
> 
> Here it is below (compressed and b64-uuencoded as it's about 1MB
> large)
> 
> begin-base64 600 bdt.log.xz

The tree says:
2x28.25 GB in metadata
3,41 TB in data
16MB in system

so I'd say the calculation of Avail in df is just wrong.

-Arne


