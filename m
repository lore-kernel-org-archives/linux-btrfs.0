Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:37354 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbeGSMD7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 08:03:59 -0400
Received: by mail-io0-f182.google.com with SMTP id z19-v6so6745785ioh.4
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 04:21:17 -0700 (PDT)
Subject: Re: Healthy amount of free space?
To: Chris Murphy <lists@colorremedies.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
 <2197534.TZSffJRfLT@merkaba> <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
 <1736761.B5nO4FXixV@merkaba> <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
 <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
 <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com>
 <CAJCQCtSpMi-GmJSQx+tjt+WjDqvEH5Z9yeUrYSjLFz+P4f2j2A@mail.gmail.com>
 <0a3a8550-3622-0c7b-bcf7-e2d7cabf6b4a@gmail.com>
 <CAJCQCtQrY2rz0CTntCO9szii7SveshtSMgCPz4JQqq16kfATNw@mail.gmail.com>
 <CAJCQCtSV35cR5KS4dT0x5wYyMHXszdBFGT2Rt7XAMa4dDmC5uw@mail.gmail.com>
 <72230e2d-022c-12bd-cd56-9d728989157d@gmail.com>
 <CAJCQCtSLVF8JP_KvFrwsrDDf76b2meS9HjN+ant+d3FbY-9H+Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b67be80f-574f-85f7-8a78-7b00c2f20b8b@gmail.com>
Date: Thu, 19 Jul 2018 07:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSLVF8JP_KvFrwsrDDf76b2meS9HjN+ant+d3FbY-9H+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-18 17:32, Chris Murphy wrote:
> On Wed, Jul 18, 2018 at 12:01 PM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2018-07-18 13:40, Chris Murphy wrote:
>>>
>>> On Wed, Jul 18, 2018 at 11:14 AM, Chris Murphy <lists@colorremedies.com>
>>> wrote:
>>>
>>>> I don't know for sure, but based on the addresses reported before and
>>>> after dd for the fallocated tmp file, it looks like Btrfs is not using
>>>> the originally fallocated addresses for dd. So maybe it is COWing into
>>>> new blocks, but is just as quickly deallocating the fallocated blocks
>>>> as it goes, and hence doesn't end up in enospc?
>>>
>>>
>>> Previous thread is "Problem with file system" from August 2017. And
>>> there's these reproduce steps from Austin which have fallocate coming
>>> after the dd.
>>>
>>>       truncate --size=4G ./test-fs
>>>       mkfs.btrfs ./test-fs
>>>       mkdir ./test
>>>       mount -t auto ./test-fs ./test
>>>       dd if=/dev/zero of=./test/test bs=65536 count=32768
>>>       fallocate -l 2147483650 ./test/test && echo "Success!"
>>>
>>>
>>> My test Btrfs is 2G not 4G, so I'm cutting the values of dd and
>>> fallocate in half.
>>>
>>> [chris@f28s btrfs]$ sudo dd if=/dev/zero of=tmp bs=1M count=1000
>>> 1000+0 records in
>>> 1000+0 records out
>>> 1048576000 bytes (1.0 GB, 1000 MiB) copied, 7.13391 s, 147 MB/s
>>> [chris@f28s btrfs]$ sync
>>> [chris@f28s btrfs]$ df -h
>>> Filesystem                Size  Used Avail Use% Mounted on
>>> /dev/mapper/vg-btrfstest  2.0G 1018M  1.1G  50% /mnt/btrfs
>>> [chris@f28s btrfs]$ sudo fallocate -l 1000m tmp
>>>
>>>
>>> Succeeds. If I do it with a 1200M file for dd and fallocate 1200M over
>>> it, this fails, but I kinda expect that because there's only 1.1G free
>>> space. But maybe that's what you're saying is the bug, it shouldn't
>>> fail?
>>
>> Yes, you're right, I had things backwards (well, kind of, this does work on
>> ext4 and regular XFS, so it arguably should work here).
> 
> I guess I'm confused what it even means to fallocate over a file with
> in-use blocks unless either -d or -p options are used. And from the
> man page, I don't grok the distinction between -d and -p either. But
> based on their descriptions I'd expect they both should work without
> enospc.
> 
Without any specific options, it forces allocation of any sparse regions 
in the file (that is, it gets rid of holes in the file).  On BTRFS, I 
believe the command also forcibly unshares all the extents in the file 
(for the system call, there's a special flag for doing this). 
Additionally, you can extend a file with fallocate this way by 
specifying a length longer than the current size of the file, which 
guarantees that writes into that region will succeed, unlike truncating 
the file to a larger size, which just creates a hole at the end of the 
file to bring it up to size.

As far as `-d` versus `-p`:  `-p` directly translates to the option for 
the system call that punches a hole.  It requires a length and possibly 
an offset, and will punch a hole at that exact location of that exact 
size.  `-d` is a special option that's only available for the command. 
It tells the `fallocate` command to search the file for zero-filled 
regions, and punch holes there.  Neither option should ever trigger an 
ENOSPC, except possibly if it has to split an extent for some reason and 
you are completely out of metadata space.
