Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36847 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcGOSwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 14:52:39 -0400
Received: by mail-it0-f45.google.com with SMTP id f6so25898459ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 11:52:39 -0700 (PDT)
Subject: Re: Data recovery from a linear multi-disk btrfs file system
To: Matt <langelino@gmx.net>
References: <A06BAA26-44FF-4947-B552-26ED228B5BF6@gmx.net>
 <179e2713-cd97-213c-3476-82f0b48c6442@gmail.com>
 <1378A988-195F-4E68-B6DE-30CEDFAC8474@gmx.net>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6acece40-1457-e4f3-646b-083780d8a251@gmail.com>
Date: Fri, 15 Jul 2016 14:52:33 -0400
MIME-Version: 1.0
In-Reply-To: <1378A988-195F-4E68-B6DE-30CEDFAC8474@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-15 14:45, Matt wrote:
>
>> On 15 Jul 2016, at 14:10, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>>
>> On 2016-07-15 05:51, Matt wrote:
>>> Hello
>>>
>>> I glued together 6 disks in linear lvm fashion (no RAID) to obtain one large file system (see below).  One of the 6 disk failed. What is the best way to recover from this?
>>>
>> The tool you want is `btrfs restore`.  You'll need somewhere to put the files from this too of course.  That said, given that you had data in raid0 mode, you're not likely to get much other than very small files back out of this, and given other factors, you're not likely to get what you would consider reasonable performance out of this either.
>
> Thanks so much for pointing me towards btrfs-restore. I surely will give it a try.  Note that the FS is not a RAID0 but  linear (“JPOD") configuration. This is why  it somehow did not occur to me to try btrfs-restore.  The good news about in this configuration  the files are *not* distributed across disks. We can  read most of the files just fine.  The failed disk was actually smaller than the others five so that we should be able to recover more than 5/6 of the data, shouldn’t we?  My trouble is that the IO errors due to the missing disk  cripple the transfer speed of both rsync and dd_rescue.
Your own 'btrfs fi df' output clearly says that more than 99% of your 
data chunks are in a RAID0 profile, hence my statement.  Functionally, 
this is similar to concatenating all the disks, but it gets better 
performance and is a bit harder to recover data from.  I hadn't noticed 
however that the disks were different sizes, so should be able to 
recover a significant amount of data from it.
>
>> Your best bet to get a working filesystem again would be to just recreate it from scratch, there's not much else that can be done when you've got a raid0 profile and have lost a disk.
>
> This is what I plan to do if there if btrfs-restore turns out to be too slow and nobody on this list has any better idea.  It will, however, require  transferring  >15TB across the Atlantic (this is were the “backup” reside).  This can be tedious which is why I would love to avoid it.
Entirely understandable.

