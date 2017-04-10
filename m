Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35734 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdDJToE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 15:44:04 -0400
Received: by mail-io0-f179.google.com with SMTP id r16so53645896ioi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 12:44:04 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id a128sm3978086itg.22.2017.04.10.12.44.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Apr 2017 12:44:01 -0700 (PDT)
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
 <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
 <20170410184444.08ced097@jupiter.sol.local>
 <20170410185437.235b3b86@jupiter.sol.kaishome.de>
 <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
 <20170410201842.216893be@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ce3ddbc7-da26-9fc7-e783-e9d566009ae8@gmail.com>
Date: Mon, 10 Apr 2017 15:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170410201842.216893be@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-10 14:18, Kai Krakow wrote:
> Am Mon, 10 Apr 2017 13:13:39 -0400
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> On 2017-04-10 12:54, Kai Krakow wrote:
>>> Am Mon, 10 Apr 2017 18:44:44 +0200
>>> schrieb Kai Krakow <hurikhan77@gmail.com>:
>>>
>>>> Am Mon, 10 Apr 2017 08:51:38 -0400
>>>> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>>>>
>>  [...]
>>  [...]
>>>>  [...]
>>  [...]
>>  [...]
>>>>
>>>> Did you put it in /etc/fstab only for the rootfs? If yes, it
>>>> probably has no effect. You would need to give it as rootflags on
>>>> the kernel cmdline.
>>>
>>> I did a "fgrep lazytime /usr/src/linux -ir" and it reveals only ext4
>>> and f2fs know the flag. Kernel 4.10.
>>>
>>> So probably you're seeing a placebo effect. If you put lazytime for
>>> rootfs just only into fstab, it won't have an effect because on
>>> initial mount this file cannot be opened (for obvious reasons), and
>>> on remount, btrfs seems to happily accept lazytime but it has no
>>> effect. It won't show up in /proc/mounts. Try using it in rootflags
>>> kernel cmdline and you should see that the kernel won't accept the
>>> flag lazytime.
>> The command-line also rejects a number of perfectly legitimate
>> arguments that BTRFS does understand too though, so that's not much
>> of a test.
>
> Which are those? I didn't encounter any...
I'm not sure there are any anymore, but I know that a handful (mostly 
really uncommon ones) used to (and BTRFS is not alone in this respect, 
some of the more esoteric ext4 options aren't accepted on the kernel 
command-line either).  I know at a minimum at some point in the past 
alloc-start, check_int, and inode_cache did not work from the kernel 
command-line.
>
>> I've just finished some quick testing though, and it looks
>> like you're right, BTRFS does not support this, which means I now
>> need to figure out what the hell was causing the IOPS counters in
>> collectd to change in rough correlation  with remounting (especially
>> since it appears to happen mostly independent of the options being
>> changed).
>
> I think that noatime (which I remember you also used?), lazytime, and
> relatime are mutually exclusive: they all handle the inode updates.
> Maybe that is the effect you see?
They're not exactly exclusive.  The lazytime option will prevent changes 
to the mtime or atime fields in a file from forcing inode write-out for 
up to 24 hours (if the inode would be written out for some other reason 
(such as a file-size change or the inode being evicted from the cache), 
then the timestamps will be too), but it does not change the value of 
the timestamps.  So if you have lazytime enabled and use touch to update 
the mtime on anotherwise idle file, the mtime will still be correct as 
far as userspace is concerned, as long as you don't crash before the 
update hits the disk (but userspace will only see the discrepancy 
_after_ the crash).

By comparison, relatime causes the atime not to updated at all if it's 
changed in the last 24 hours, and noatime completely prevents atime 
updates.  In both cases, the atime isn't correct at all in userspace as 
far as POSIX is concerned.

So, you have the following combinations:
* strictatime, nolazytime: Both atime and mtime updates happen, and are 
flushed to disk (almost) immediately.
* relatime, nolazytime (the upstream default): atime updates happen only 
if the atime hasn't changed in 24 hours, mtime updates happen as normal, 
and both types of update are flushed to disk (almost) immediately.
* noatime, nolazytime (the default on some specific kernels (this is 
easy to patch, so a lot of people who already carry custom patches and 
don't use mutt patch it)): atime updates never happen, mtime updates 
happen as normal and are flushed to disk (almost) immediately.
* strictatime, lazytime: Both atime and mtime updates happen, but they 
actual update may not hit the disk for up to 24 hours (this will let 
mutt work correctly as long as your system shuts down cleanly, but still 
improve performance noticeably on at least ext4).
* relatime, lazytime: atime updates happen only if the atime hasn't 
changed in 24 hours, mtime updates happen as normal, and both may not 
hit the disk for up to 24 hours.
* noatime, lazytime (what I'm trying to run): atime updates never 
happen, mtime updates happen as normal, but may not hit the disk for up 
to 24 hours.

In essence, lazytime only impacts inode writeback (deferring it under 
special circumstances), while {no,rel,strict}atime impacts the actual 
value of the time-stamps.
>
>> This is somewhat disappointing though, as supporting this would
>> probably help with the write-amplification issues inherent in COW
>> filesystems. --
>
> Well, relatime is mostly the same thus not perfectly resembling the
> POSIX standard. I think the only software that relies on atime is
> mutt...
This very much depends on what you're doing.  If you have a WORM 
workload, then yeah, it's pretty much the same.  If however you have 
something like a database workload where a specific set of files get 
internally rewritten regularly, then it actually has a measurable impact.

As a very specific example, I run collectd on my systems using RRD files 
as data storage.  An RRD file is essentially a really fancy circular 
buffer, so it remains fixed size but gets a _lot_ of internal rewrites 
(by the way, if anyone wants to test fragmentation behavior on BTRFS, 
RRD files are a great way to do it).  Because of how I have things set 
up, each file gets a batch of data points every 1-2 minutes.  This in 
turn means that the mtime is updating every 1-2 minutes for each of the 
1000+ RRD files.  In this case, writing out the timestamps results in an 
overhead of roughly 256 bytes per file, which is about 0.1% based on the 
average file size of roughly 169k.  If I use noatime on this filesystem, 
then it has near zero impact because the average number of times per 
hour that these files are read is near zero.  Turning on lazytime 
however, results in mtime updates getting deferred until the hourly 
forced fssync for this filesystem hits (this is something I'm doing, not 
the OS), that reduces the overhead by a factor of roughly 45 (the 
average number of writes per-file per-hour) to about 0.00003%, which is 
a pretty serious difference.
