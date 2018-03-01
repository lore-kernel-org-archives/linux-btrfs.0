Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:46243 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030328AbeCAMZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Mar 2018 07:25:38 -0500
Received: by mail-io0-f178.google.com with SMTP id p78so6878494iod.13
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Mar 2018 04:25:38 -0800 (PST)
Subject: Re: btrfs space used issue
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        vinayak hegde <vinayakhegdev@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
 <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
 <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
 <CAFmraXhRtUh-HPV4vpeE3-0B=vCeK40b2HfsOk_boSFu+EjQhg@mail.gmail.com>
 <CAA91j0W86k-ZqzypvM=4GKxZu2Zvjkfjd0FDrEUWxAvZnJiOqg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <044dd443-694f-2380-c1dc-1bfa9dc5df0d@gmail.com>
Date: Thu, 1 Mar 2018 07:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAA91j0W86k-ZqzypvM=4GKxZu2Zvjkfjd0FDrEUWxAvZnJiOqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-01 05:18, Andrei Borzenkov wrote:
> On Thu, Mar 1, 2018 at 12:26 PM, vinayak hegde <vinayakhegdev@gmail.com> wrote:
>> No, there is no opened file which is deleted, I did umount and mounted
>> again and reboot also.
>>
>> I think I am hitting the below issue, lot of random writes were
>> happening and the file is not fully written and its sparse file.
>> Let me try with disabling COW.
>>
>>
>> file offset 0                                               offset 302g
>> [-------------------------prealloced 302g extent----------------------]
>>
>> (man it's impressive I got all that lined up right)
>>
>> On disk you have 2 things. First your file which has file extents which says
>>
>> inode 256, file offset 0, size 302g, offset0, disk bytenr 123, disklen 302g
>>
>> and then in the extent tree, who keeps track of actual allocated space has this
>>
>> extent bytenr 123, len 302g, refs 1
>>
>> Now say you boot up your virt image and it writes 1 4k block to offset
>> 0. Now you have this
>>
>> [4k][--------------------302g-4k--------------------------------------]
>>
>> And for your inode you now have this
>>
>> inode 256, file offset 0, size 4k, offset 0, diskebytenr (123+302g),
>> disklen 4k inode 256, file offset 4k, size 302g-4k, offset 4k,
>> diskbytenr 123, disklen 302g
>>
>> and in your extent tree you have
>>
>> extent bytenr 123, len 302g, refs 1
>> extent bytenr whatever, len 4k, refs 1
>>
>> See that? Your file is still the same size, it is still 302g. If you
>> cp'ed it right now it would copy 302g of information. But what you
>> have actually allocated on disk? Well that's now 302g + 4k. Now lets
>> say your virt thing decides to write to the middle, lets say at offset
>> 12k, now you have thisinode 256, file offset 0, size 4k, offset 0,
>> diskebytenr (123+302g), disklen 4k
>>
>> inode 256, file offset 4k, size 3k, offset 4k, diskbytenr 123, disklen 302g
>>
>> inode 256, file offset 12k, size 4k, offset 0, diskebytenr whatever,
>> disklen 4k inode 256, file offset 16k, size 302g - 16k, offset 16k,
>> diskbytenr 123, disklen 302g
>>
>> and in the extent tree you have this
>>
>> extent bytenr 123, len 302g, refs 2
>> extent bytenr whatever, len 4k, refs 1
>> extent bytenr notimportant, len 4k, refs 1
>>
>> See that refs 2 change? We split the original extent, so we have 2
>> file extents pointing to the same physical extents, so we bumped the
>> ref count. This will happen over and over again until we have
>> completely overwritten the original extent, at which point your space
>> usage will go back down to ~302g.
> 
> Sure, I just mentioned the same in another thread. But you said you
> performed full defragmentation and I expect it to "fix" this condition
> by relocating data and freeing original big extent. If this did not
> happen, I wonder what are conditions when defragment decides to (not)
> move data.
> 
While I'm not certain exactly how it works, defragmentation tries to 
make all extents at least as large as a target extent size.  By default, 
this target size is 32MB (I believe it used to be 20, but I'm not 100% 
certain about that).  For files less than that size, they will always be 
fully defragmented if there is any fragmentation.  For files larger than 
that size, defrag may ignore extents larger than that size.  The `-t` 
option for the defrag command can be used to control this aspect.  It 
may also avoid given extents for other more complicated reasons 
involving free space fragmentation, but the primary one is the target 
extent size.
