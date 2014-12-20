Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:53994 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaLTJPV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 04:15:21 -0500
Received: by mail-la0-f51.google.com with SMTP id ms9so1974011lab.24
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 01:15:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <549495D4.9030800@fb.com>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
	<54949454.9020601@fb.com>
	<549495D4.9030800@fb.com>
Date: Sat, 20 Dec 2014 17:15:19 +0800
Message-ID: <CAN6BF2KkLrUK7fDiU8zTHLKi-nS=FRGX9geVj5Wuv92g9L6HMw@mail.gmail.com>
Subject: Re: btrfs is using 25% more disk than it should
From: Daniele Testa <daniele.testa@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, so this is what I did:

1. Copied the sparse 315GB (with 302GB inside) to another server
2. Re-formatted the btrfs partition
3. chattr +C on the parent dir
4. Copied the 315GB file back to the btrfs partition (the file is not
sparse any more due to the copying)

This is the end result:

root@s4 /opt/drives/ssd # ls -alhs
total 316G
 16K drwxr-xr-x 1 libvirt-qemu libvirt-qemu   42 Dec 20 07:00 .
4.0K drwxr-xr-x 4 libvirt-qemu libvirt-qemu 4.0K Dec 18 14:31 ..
315G -rw-r--r-- 1 libvirt-qemu libvirt-qemu 315G Dec 20 09:11 disk_208.img
   0 drwxr-xr-x 1 libvirt-qemu libvirt-qemu    0 Dec 20 06:53 snapshots

root@s4 /opt/drives/ssd # du -h
0       ./snapshots
316G    .

root@s4 /opt/drives/ssd # df -h
/dev/md3                                                411G  316G
94G  78% /opt/drives/ssd

root@s4 /opt/drives/ssd # btrfs filesystem df /opt/drives/ssd
Data, single: total=323.01GiB, used=315.08GiB
System, DUP: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=880.00KiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=16.00MiB, used=0.00

root@s4 /opt/drives/ssd # lsattr
---------------- ./snapshots
---------------C ./disk_208.img

As you can see, it looks much better now. The file takes as much space
as it should and the Metadata is only 880kb.

I will do some writes inside the VM and see if the file grows on the
"outside". If everything is ok, it should not.

2014-12-20 5:17 GMT+08:00 Josef Bacik <jbacik@fb.com>:
> On 12/19/2014 04:10 PM, Josef Bacik wrote:
>>
>> On 12/18/2014 09:59 AM, Daniele Testa wrote:
>>>
>>> Hey,
>>>
>>> I am hoping you guys can shed some light on my issue. I know that it's
>>> a common question that people see differences in the "disk used" when
>>> running different calculations, but I still think that my issue is
>>> weird.
>>>
>>> root@s4 / # mount
>>> /dev/md3 on /opt/drives/ssd type btrfs
>>> (rw,noatime,compress=zlib,discard,nospace_cache)
>>>
>>> root@s4 / # btrfs filesystem df /opt/drives/ssd
>>> Data: total=407.97GB, used=404.08GB
>>> System, DUP: total=8.00MB, used=52.00KB
>>> System: total=4.00MB, used=0.00
>>> Metadata, DUP: total=1.25GB, used=672.21MB
>>> Metadata: total=8.00MB, used=0.00
>>>
>>> root@s4 /opt/drives/ssd # ls -alhs
>>> total 302G
>>> 4.0K drwxr-xr-x 1 root         root           42 Dec 18 14:34 .
>>> 4.0K drwxr-xr-x 4 libvirt-qemu libvirt-qemu 4.0K Dec 18 14:31 ..
>>> 302G -rw-r--r-- 1 libvirt-qemu libvirt-qemu 315G Dec 18 14:49
>>> disk_208.img
>>>     0 drwxr-xr-x 1 libvirt-qemu libvirt-qemu    0 Dec 18 10:08 snapshots
>>>
>>> root@s4 /opt/drives/ssd # du -h
>>> 0       ./snapshots
>>> 302G    .
>>>
>>> As seen above, I have a 410GB SSD mounted at "/opt/drives/ssd". On
>>> that partition, I have one single starse file, taking 302GB of space
>>> (max 315GB). The snapshots directory is completely empty.
>>>
>>> However, for some weird reason, btrfs seems to think it takes 404GB.
>>> The big file is a disk that I use in a virtual server and when I write
>>> stuff inside that virtual server, the disk-usage of the btrfs
>>> partition on the host keeps increasing even if the sparse-file is
>>> constant at 302GB. I even have 100GB of "free" disk-space inside that
>>> virtual disk-file. Writing 1GB inside the virtual disk-file seems to
>>> increase the usage about 4-5GB on the "outside".
>>>
>>> Does anyone have a clue on what is going on? How can the difference
>>> and behaviour be like this when I just have one single file? Is it
>>> also normal to have 672MB of metadata for a single file?
>>>
>>
>> Hello and welcome to the wonderful world of btrfs, where COW can really
>> suck hard without being super clear why!  It's 4pm on a Friday right
>> before I'm gone for 2 weeks so I'm a bit happy and drunk so I'm going to
>> use pretty pictures.  You have this case to start with
>>
>> file offset 0                                               offset 302g
>> [-------------------------prealloced 302g extent----------------------]
>>
>> (man it's impressive I got all that lined up right)
>>
>> On disk you have 2 things.  First your file which has file extents which
>> says
>>
>> inode 256, file offset 0, size 302g, offset0, disk bytenr 123, disklen
>> 302g
>>
>> and then in the extent tree, who keeps track of actual allocated space
>> has this
>>
>> extent bytenr 123, len 302g, refs 1
>>
>> Now say you boot up your virt image and it writes 1 4k block to offset
>> 0.  Now you have this
>>
>> [4k][--------------------302g-4k--------------------------------------]
>>
>> And for your inode you now have this
>>
>> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
>> disklen 4k
>> inode 256, file offset 4k, size 302g-4k, offset 4k, diskbytenr 123,
>> disklen 302g
>>
>> and in your extent tree you have
>>
>> extent bytenr 123, len 302g, refs 1
>> extent bytenr whatever, len 4k, refs 1
>>
>> See that?  Your file is still the same size, it is still 302g.  If you
>> cp'ed it right now it would copy 302g of information.  But what you have
>> actually allocated on disk?  Well that's now 302g + 4k.  Now lets say
>> your virt thing decides to write to the middle, lets say at offset 12k,
>> now you have this
>>
>> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
>> disklen 4k
>> inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen
>> 302g
>> inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
>> disklen 4k
>> inode 256, file offset 16k, size 302g - 16k, offset 16k, diskbytenr 123,
>> disklen 302g
>>
>> and in the extent tree you have this
>>
>> extent bytenr 123, len 302g, refs 2
>> extent bytenr whatever, len 4k, refs 1
>> extent bytenr notimportant, len 4k, refs 1
>>
>> See that refs 2 change?  We split the original extent, so we have 2 file
>> extents pointing to the same physical extents, so we bumped the ref
>> count.  This will happen over and over again until we have completely
>> overwritten the original extent, at which point your space usage will go
>> back down to ~302g.
>>
>> We split big extents with cow, so unless you've got lots of space to
>> spare or are going to use nodatacow you should probably not pre-allocate
>> virt images.  Thanks,
>>
>
> Sorry should have added a
>
> tl;dr: Cow means you can in the worst case end up using 2 * filesize -
> blocksize of data on disk and the file will appear to be filesize.  Thanks,
>
> Josef
>
