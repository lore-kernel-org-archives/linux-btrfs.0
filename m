Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35917 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760183AbcDFAA4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 20:00:56 -0400
Received: by mail-oi0-f49.google.com with SMTP id y204so37902853oie.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 17:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jaa6ukFBu=Mx5bd+5ix21Np+rX7dGZiadnC5mGmgHkNtA@mail.gmail.com>
References: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
	<pan$603b6$4c4f876d$1daf06de$ec75378d@cox.net>
	<CAPmG0jaa6ukFBu=Mx5bd+5ix21Np+rX7dGZiadnC5mGmgHkNtA@mail.gmail.com>
Date: Wed, 6 Apr 2016 10:00:45 +1000
Message-ID: <CA+WRLO_xLa96+fepY1d_SFkQkEn0a6vzbuydHZ13Sw9UU=-1tQ@mail.gmail.com>
Subject: Re: Scrub priority, am I using it wrong?
From: Gareth Pye <gareth@cerberos.id.au>
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah, RAID5. I'm now doing pause and resume on it to let it take
multiple nights, the idle should let other processes complete in
reasonable time.

On Wed, Apr 6, 2016 at 3:34 AM, Henk Slager <eye1tm@gmail.com> wrote:
> On Tue, Apr 5, 2016 at 4:37 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Gareth Pye posted on Tue, 05 Apr 2016 09:36:48 +1000 as excerpted:
>>
>>> I've got a btrfs file system set up on 6 drbd disks running on 2Tb
>>> spinning disks. The server is moderately loaded with various regular
>>> tasks that use a fair bit of disk IO, but I've scheduled my weekly btrfs
>>> scrub for the best quiet time in the week.
>>>
>>> The command that is run is:
>>> /usr/local/bin/btrfs scrub start -Bd -c idle /data
>>>
>>> Which is my best attempt to try and get it to have a low impact on user
>>> operations
>>>
>>> But iotop shows me:
>>>
>>> 1765 be/4 root       14.84 M/s    0.00 B/s  0.00 % 96.65 % btrfs scrub
>>> start -Bd -c idle /data
>>>  1767 be/4 root       14.70 M/s    0.00 B/s  0.00 % 95.35 % btrfs
>>> scrub start -Bd -c idle /data
>>>  1768 be/4 root       13.47 M/s    0.00 B/s  0.00 % 92.59 % btrfs
>>> scrub start -Bd -c idle /data
>>>  1764 be/4 root       12.61 M/s    0.00 B/s  0.00 % 88.77 % btrfs
>>> scrub start -Bd -c idle /data
>>>  1766 be/4 root       11.24 M/s    0.00 B/s  0.00 % 85.18 % btrfs
>>> scrub start -Bd -c idle /data
>>>  1763 be/4 root        7.79 M/s    0.00 B/s  0.00 % 63.30 % btrfs
>>> scrub start -Bd -c idle /data
>>> 28858 be/4 root        0.00 B/s  810.50 B/s  0.00 % 61.32 % [kworker/
>> u16:25]
>>>
>>>
>>> Which doesn't look like an idle priority to me. And the system sure
>>> feels like a system with a lot of heavy io going on. Is there something
>>> I'm doing wrong?
>
> When I see the throughput numbers, it lets me think that the
> filesystem is raid5 or raid6. On single or raid1 or raid10 one easily
> gets around 100M/s without the notice/feeling of heavy IO ongoing,
> mostly independent of scrub options.
>
>> Two points:
>>
>> 1) It appears btrfs scrub start's -c option only takes numeric class, so
>> try -c3 instead of -c idle.
>
> Thanks to Duncan for pointing this out. I don't remember exactly, but
> I think I also had issues with this in the past, but did not realize
> or have a further look at it.
>
>> Works for me with the numeric class (same results as you with spelled out
>> class), tho I'm on ssd with multiple independent btrfs on partitions, the
>> biggest of which is 24 GiB, 18.something GiB used, which scrubs in all of
>> 20 seconds, so I don't need and hadn't tried the -c option at all until
>> now.
>>
>> 2) What a difference an ssd makes!
>>
>> $$ sudo btrfs scrub start -c3 /p
>> scrub started on /p, [...]
>>
>> $$ sudo iotop -obn1
>> Total DISK READ :     626.53 M/s | Total DISK WRITE :       0.00 B/s
>> Actual DISK READ:     596.93 M/s | Actual DISK WRITE:       0.00 B/s
>>  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN      IO    COMMAND
>>  872 idle root      268.40 M/s    0.00 B/s  0.00 %  0.00 % btrfs scrub
>> start -c3 /p
>>  873 idle root      358.13 M/s    0.00 B/s  0.00 %  0.00 % btrfs scrub
>> start -c3 /p
>>
>> CPU bound, 0% IOWait even at idle IO priority, in addition to the
>> hundreds of M/s values per thread/device, here.  You OTOH are showing
>> under 20 M/s per thread/device on spinning rust, with an IOWait near 90%,
>> thus making it IO bound.
>
> This low M/s and high IOWait is the kind of behavior I noticed with 3x
> 2TB raid5 when scrubbing or balancing (no bcache activated, kernel
> 4.3.3).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
