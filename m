Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:38842 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbaIBXaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 19:30:06 -0400
Received: by mail-oi0-f53.google.com with SMTP id i138so4937515oig.40
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 16:30:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <540617DE.5070605@gmail.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com>
	<20140812011401.568c16e6@natsu>
	<AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com>
	<CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com>
	<9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com>
	<CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com>
	<08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com>
	<CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com>
	<5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com>
	<CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com>
	<540617DE.5070605@gmail.com>
Date: Tue, 2 Sep 2014 16:30:05 -0700
Message-ID: <CADw2B2M+WSbCyphH3Y=5w8JyMHYe7sL_MdvScy9NLPS3PbRHiQ@mail.gmail.com>
Subject: Re: Large files, nodatacow and fragmentation
From: "G. Richard Bellamy" <rbellamy@pteradigm.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks @chris & @austin. You both bring up interesting questions and points.

@chris: atlas-data.qcow2 isn't running any software or logging at this
time, I isolated my D:\ drive on that file via clonezilla and
virt-resize.
Microsoft DiskPart version 6.1.7601
Copyright (C) 1999-2008 Microsoft Corporation.
On computer: ATLAS

DISKPART> list disk

  Disk ###  Status         Size     Free     Dyn  Gpt
  --------  -------------  -------  -------  ---  ---
  Disk 0    Online          350 GB      0 B
  Disk 1    Online          300 GB      0 B

DISKPART> list vol

  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
  ----------  ---  -----------  -----  ----------  -------  ---------  --------
  Volume 0     E                       CD-ROM          0 B  No Media
  Volume 1     F   CDROM        CDFS   DVD-ROM       70 MB  Healthy
  Volume 2         System Rese  NTFS   Partition    100 MB  Healthy    System
  Volume 3     C   System       NTFS   Partition    349 GB  Healthy    Boot
  Volume 4     D   Data         NTFS   Partition    299 GB  Healthy

Volume 2 & 3 == atlas-system.qcow2
Volume 4 == atlas-data.qcow2

...and the current fragmentation:
2014-09-02 16:27:45
root@eanna i /var/lib/libvirt/images # filefrag atlas-*
atlas-data.qcow2: 564 extents found
atlas-system.qcow2: 47412 extents found

@austin, the Windows 7 guest sees both disks as spinning rust.

On Tue, Sep 2, 2014 at 12:17 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-09-02 14:31, G. Richard Bellamy wrote:
>> I thought I'd follow-up and give everyone an update, in case anyone
>> had further interest.
>>
>> I've rebuilt the RAID10 volume in question with a Samsung 840 Pro for
>> bcache front device.
>>
>> It's 5x600GB SAS 15k RPM drives RAID10, with the 512MB SSD bcache.
>>
>> 2014-09-02 11:23:16
>> root@eanna i /var/lib/libvirt/images # lsblk
>> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>> sda         8:0    0 558.9G  0 disk
>> └─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
>> sdb         8:16   0 558.9G  0 disk
>> └─bcache2 254:2    0 558.9G  0 disk
>> sdc         8:32   0 558.9G  0 disk
>> └─bcache1 254:1    0 558.9G  0 disk
>> sdd         8:48   0 558.9G  0 disk
>> └─bcache0 254:0    0 558.9G  0 disk
>> sde         8:64   0 558.9G  0 disk
>> └─bcache4 254:4    0 558.9G  0 disk
>> sdf         8:80   0   1.8T  0 disk
>> └─sdf1      8:81   0   1.8T  0 part
>> sdg         8:96   0   477G  0 disk /var/lib/btrfs/system
>> sdh         8:112  0   477G  0 disk
>> sdi         8:128  0   477G  0 disk
>> ├─bcache0 254:0    0 558.9G  0 disk
>> ├─bcache1 254:1    0 558.9G  0 disk
>> ├─bcache2 254:2    0 558.9G  0 disk
>> ├─bcache3 254:3    0 558.9G  0 disk /var/lib/btrfs/data
>> └─bcache4 254:4    0 558.9G  0 disk
>> sr0        11:0    1  1024M  0 rom
>>
>> I further split the system and data drives of the VM Win7 guest. It's
>> very interesting to see the huge level of fragmentation I'm seeing,
>> even with the help of ordered writes offered by bcache - in other
>> words while bcache seems to be offering me stability and better
>> behavior to the guest, the underlying the filesystem is still seeing a
>> level of fragmentation that has me scratching my head.
>>
>> That being said, I don't know what would be normal fragmentation of a
>> VM Win7 guest system drive, so could be I'm just operating in my zone
>> of ignorance again.
>>
>> 2014-09-01 14:41:19
>> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
>> atlas-data.qcow2: 7 extents found
>> atlas-system.qcow2: 154 extents found
>> 2014-09-01 18:12:27
>> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
>> atlas-data.qcow2: 564 extents found
>> atlas-system.qcow2: 28171 extents found
>> 2014-09-02 08:22:00
>> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
>> atlas-data.qcow2: 564 extents found
>> atlas-system.qcow2: 35281 extents found
>> 2014-09-02 08:44:43
>> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
>> atlas-data.qcow2: 564 extents found
>> atlas-system.qcow2: 37203 extents found
>> 2014-09-02 10:14:32
>> root@eanna i /var/lib/libvirt/images # filefrag atlas-*
>> atlas-data.qcow2: 564 extents found
>> atlas-system.qcow2: 40903 extents found
>>
> This may sound odd, but are you exposing the disk to the Win7 guest as a
> non-rotational device? Win7 and higher tend to have different write
> behavior when they think they are on an SSD (or something else where
> seek latency is effectively 0).  Most VMM's (at least, most that I've
> seen) will use fallocate to punch holes for ranges that get TRIM'ed in
> the guest, so if windows is sending TRIM commands, that may also be part
> of the issue.  Also, you might try reducing the amount of logging in the
> guest.
>
