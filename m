Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48560 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQV3T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 17:29:19 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so1065621eek.10
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Apr 2014 14:29:18 -0700 (PDT)
Message-ID: <535047AB.6030606@gmail.com>
Date: Thu, 17 Apr 2014 23:29:15 +0200
From: "Oliver O." <oliver.o456i@gmail.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: File changing in snapshot
References: <534FF5C1.8070404@gmail.com> <534FF9B5.4010207@fb.com> <534FFD22.1060500@gmail.com>
In-Reply-To: <534FFD22.1060500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Am 17.04.2014 18:11, schrieb Oliver O.:
>
> Am 17.04.2014 17:56, schrieb Chris Mason:
>> On 04/17/2014 11:39 AM, Oliver O. wrote:
>>> I seem to have observed a file on a (writable) snapshot changing
>>> although there were no writes occuring on the snapshot itself. This is
>>> not supposed to happen, right?
>>
>> Was this a nodatacow file?
>>
>> -chris
>
> No. Mount options:
>
> /dev/sda2 on /home type btrfs (rw,noatime,nodiratime,subvol=@home)
>

Some additional observations:
- Subvolume used for writing: @home
- Snapshot used for backup: @home-2014-04-16
- Preceding snapshot: @home-2014-04-10

# lsattr -v @home-2014-04-10/path/to/MyFile.xls 
@home-2014-04-16/path/to/MyFile.xls @home/path/to/MyFile.xls
36066 ---------------- @home-2014-04-10/path/to/MyFile.xls
36066 ---------------- @home-2014-04-16/path/to/MyFile.xls
36066 ---------------- @home/path/to/MyFile.xls

# btrfs subvolume find-new @home-2014-04-10 99999999
transid marker was 180026

# btrfs subvolume find-new @home-2014-04-16 99999999
transid marker was 194551

# btrfs subvolume find-new @home 99999999
transid marker was 197735

# btrfs subvolume find-new @home 36066 | grep "MyFile.xls"
inode 24426 file offset 0 len 20480 disk start 9108635648 offset 0 gen 
193090 flags NONE path/to/MyFile.xls
inode 24426 file offset 20480 len 36864 disk start 25510342656 offset 
20480 gen 36067 flags NONE path/to/MyFile.xls
inode 24426 file offset 57344 len 4096 disk start 9108582400 offset 0 
gen 193090 flags NONE path/to/MyFile.xls


Conclusions:

The sequence of events seems to be:

1. The file was changed with generation 193090.
2. The snapshot for backup (@home-2014-04-16) was taken (generation 194551).
3. As the backup was reading from the snapshot, it was seeing stale data 
(MyFile still at generation 36067).
4. As the backup comparison was reading from the snapshot, is was seeing 
more recent data, causing a discrepancy with the stale data just backed up.

It seems that the snapshot needed some time to become stable for 
reading. From a file system user's point of view, I'd expect a snapshot 
to be atomic and stable at any time. Maybe some kind of caching problem 
here?

Maybe it's time to file a bug report, but first: suggestions and ideas 
appreciated.

