Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:32901 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbcHIM4p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 08:56:45 -0400
Received: by mail-qk0-f172.google.com with SMTP id t7so11200649qkh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 05:56:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fbfac514-924e-215e-a81f-c0a39d69db77@gmail.com>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
 <CAEtw4r2hsCd1+bFNcXn_s5jj-8x6qer+x0gLx8wTgNi1=nAXhw@mail.gmail.com>
 <CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
 <CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
 <CAE8gLhkR4XzNx9tarhzD2LdsCRJ3e+BPcWYpE-qA4jnJsvSrLg@mail.gmail.com>
 <CAPmG0jZj6S6TXe0xLdiJWMto=VX7NM7WhSc5T3MLf=HWvsR7+Q@mail.gmail.com>
 <0b6a094b-ccf0-36c4-aafb-12a4e9cd424d@gmail.com> <CAE8gLh=N9dP0aj+oHxGosaTNG45rvQpx=U_Mx1KT0a6MWN2o=w@mail.gmail.com>
 <fbfac514-924e-215e-a81f-c0a39d69db77@gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 9 Aug 2016 08:56:03 -0400
Message-ID: <CADfjVrg1frbePC8NKGrmdtYT2TNkbuNxA6qy85o+LSc5-8QPhQ@mail.gmail.com>
Subject: Re: "No space left on device" and balance doesn't work
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: MegaBrutal <megabrutal@gmail.com>, Henk Slager <eye1tm@gmail.com>,
        Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 7:16 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-08-09 05:50, MegaBrutal wrote:
>>
>> 2016-06-03 14:43 GMT+02:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>>>
>>>
>>> Also, since you're on a new enough kernel, try 'lazytime' in the mount
>>> options as well, this defers all on-disk timestamp updates for up to 24
>>> hours or until the inode gets written out anyway, but keeps the updated info
>>> in memory.  The only downside to this is that mtimes might not be correct
>>> after an unclean shutdown, but most software will have no issues with this.
>>>
>>
>> Hi all,
>>
>> Sorry for reviving this old thread, and probably it's not the best
>> place to ask about this... but I added the "noatime" option in fstab,
>> restarted the system, and now I think I should try "lazytime" too (as
>> I like the idea to have proper atimes with delayed writing to disk).
>> So now I'd just like to test the "lazytime" mount option without
>> restart.
>>
>> I remounted the file system like this:
>>
>> mount -o remount,lazytime /
>>
>> But now the FS still has the "noatime" mount option, which I guess
>> renders "lazytime" ineffective. I thought they are supposed to be
>> mutually exclusive, so I'm actually surprised that I can have both
>> mount options at the same time.
>
> No, lazytime also affects mtime handling, not just atime, so they aren't
> mutually exclusive, and it does make sense to have both.
>>
>>
>> Now my mount looks like this:
>>
>> /dev/mapper/centrevg-rootlv on / type btrfs
>> (rw,noatime,lazytime,space_cache,subvolid=257,subvol=/@)
>>
>> I also tried to explicitly add "atime" to negate "noatime" (man mount
>> says "atime" is the option to disable "noatime"), like this:
>>
>> mount -o remount,atime,lazytime /
>>
>> But the "noatime" option still stays. Why? Is it a BTRFS specific
>> issue, or does it reside in another layer?
>>
>> By the way, is it valid to mount BTRFS subvolumes with different atime
>> policies? Then how do child subvolumes behave?
>
> I'm not entirely certain (I have my kernel patched so noatime is the
> default, and rarely if ever use anything else, so I don't have much in the
> way of experience with this), but my guess would be that it can't be done,
> and that changing atime handling on remount isn't really handled. I do know
> that adding lazytime on remount doesn't always work, but that kind of makes
> sense, since it causes significant changes in how mtimes and atimes are
> handled internally.
>

TLDR:

try 'mount -o remount,strictatime / && mount -o remount,relatime /'

This seems strange, but on my unpatched system:

$ uname -r
4.7.0

$ mount -o loop,noatime,lazytime /var/tmp/test.dd /mnt
$ grep ^/dev/loop0 /proc/mounts
/dev/loop0 /mnt btrfs rw,lazytime,noatime,space_cache,subvolid=5,subvol=/ 0 0

$ mount -o remount,relatime /mnt
$ grep ^/dev/loop0 /proc/mounts
/dev/loop0 /mnt btrfs rw,lazytime,noatime,space_cache,subvolid=5,subvol=/ 0 0

^^^ No change to noatime option

$ mount -o remount,strictatime /mnt
$ grep ^/dev/loop0 /proc/mounts
/dev/loop0 /mnt btrfs rw,lazytime,space_cache,subvolid=5,subvol=/ 0 0

^^^ that updated it...

$ mount -o remount,relatime /mnt
$ grep ^/dev/loop0 /proc/mounts

/dev/loop0 /mnt btrfs rw,lazytime,relatime,space_cache,subvolid=5,subvol=/ 0 0

^^^ now it changes

~ Noah
