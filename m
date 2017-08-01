Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:37552 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751166AbdHAPBE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 11:01:04 -0400
Received: by mail-io0-f196.google.com with SMTP id c74so1710901iod.4
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 08:01:03 -0700 (PDT)
Subject: Re: Massive loss of disk space
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: pwm <pwm@iapetus.neab.net>, Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
Message-ID: <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
Date: Tue, 1 Aug 2017 11:00:59 -0400
MIME-Version: 1.0
In-Reply-To: <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-01 10:47, Austin S. Hemmelgarn wrote:
> On 2017-08-01 10:39, pwm wrote:
>> Thanks for the links and suggestions.
>>
>> I did try your suggestions but it didn't solve the underlying problem.
>>
>>
>>
>> pwm@europium:~$ sudo btrfs balance start -v -dusage=20 /mnt/snap_04
>> Dumping filters: flags 0x1, state 0x0, force is off
>>    DATA (flags 0x2): balancing, usage=20
>> Done, had to relocate 4596 out of 9317 chunks
>>
>>
>> pwm@europium:~$ sudo btrfs balance start -mconvert=dup,soft /mnt/snap_04/
>> Done, had to relocate 2 out of 4721 chunks
>>
>>
>> pwm@europium:~$ sudo btrfs fi df /mnt/snap_04
>> Data, single: total=4.60TiB, used=4.59TiB
>> System, DUP: total=40.00MiB, used=512.00KiB
>> Metadata, DUP: total=6.50GiB, used=4.81GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> pwm@europium:~$ sudo btrfs fi show /mnt/snap_04
>> Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
>>          Total devices 1 FS bytes used 4.60TiB
>>          devid    1 size 9.09TiB used 4.61TiB path /dev/sdg1
>>
>>
>> So now device 1 usage is down from 9.09TiB to 4.61TiB.
>>
>> But if I test to fallocate() to grow the large parity file, I directly 
>> fail. I wrote a little help program that just focuses on fallocate() 
>> instead of having to run snapraid with lots of unknown additional 
>> actions being performed.
>>
>>
>> Original file size is  5050486226944 bytes
>> Trying to grow file to 5151751667712 bytes
>> Failed fallocate [No space left on device]
>>
>>
>>
>> And result after shows 'used' have jumped up to 9.09TiB again.
>>
>> root@europium:/mnt# btrfs fi show snap_04
>> Label: 'snap_04'  uuid: c46df8fa-03db-4b32-8beb-5521d9931a31
>>          Total devices 1 FS bytes used 4.60TiB
>>          devid    1 size 9.09TiB used 9.09TiB path /dev/sdg1
>>
>> root@europium:/mnt# btrfs fi df /mnt/snap_04/
>> Data, single: total=9.08TiB, used=4.59TiB
>> System, DUP: total=40.00MiB, used=992.00KiB
>> Metadata, DUP: total=6.50GiB, used=4.81GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>
>>
>> It's almost like the file system have decided that it needs to make a 
>> snapshot and store two complete copies of the complete file, which is 
>> obviously not going to work with a file larger than 50% of the file 
>> system.
> I think I _might_ understand what's going on here.  Is that test program 
> calling fallocate using the desired total size of the file, or just 
> trying to allocate the range beyond the end to extend the file?  I've 
> seen issues with the first case on BTRFS before, and I'm starting to 
> think that it might actually be trying to allocate the exact amount of 
> space requested by fallocate, even if part of the range is already 
> allocated space.

OK, I just did a dead simple test by hand, and it looks like I was 
right.  The method I used to check this is as follows:
1. Create and mount a reasonably small filesystem (I used an 8G 
temporary LV for this, a file would work too though).
2. Using dd or a similar tool, create a test file that takes up half of 
the size of the filesystem.  It is important that this _not_ be 
fallocated, but just written out.
3. Use `fallocate -l` to try and extend the size of the file beyond half 
the size of the filesystem.

For BTRFS, this will result in -ENOSPC, while for ext4 and XFS, it will 
succeed with no error.  Based on this and some low-level inspection, it 
looks like BTRFS treats the full range of the fallocate call as 
unallocated, and thus is trying to allocate space for regions of that 
range that are already allocated.

>>
>> No issue at all to grow the parity file on the other parity disk. And 
>> that's why I wonder if there is some undetected file system corruption.
>>
