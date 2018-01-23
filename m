Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:37421 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751173AbeAWMvr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 07:51:47 -0500
Received: by mail-io0-f195.google.com with SMTP id f89so807984ioj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 04:51:47 -0800 (PST)
Subject: Re: bad key ordering - repairable?
To: Chris Murphy <lists@colorremedies.com>,
        Claes Fransson <claes.v.fransson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com>
Date: Tue, 23 Jan 2018 07:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-22 21:35, Chris Murphy wrote:
> On Mon, Jan 22, 2018 at 2:06 PM, Claes Fransson
> <claes.v.fransson@gmail.com> wrote:
>> Hi!
>>
>> I really like the features of BTRFS, especially deduplication,
>> snapshotting and checksumming. However, when using it on my laptop the
>> last couple of years, it has became corrupted a lot of times.
>> Sometimes I have managed to fix the problems (at least so much that I
>> can continue to use the filesystem) with check --repair, but several
>> times I had to recreate the file system and reinstall the operating
>> system.
>>
>> I am guessing the corruptions might be the results of unclean
>> shutdowns, mostly after system hangs, but also because of running out
>> of battery sometimes?
> 
> I think it's something else because I intentionally and
> unintentionally do unclean shutdowns (I'm really impatient and I'm a
> saboteur) on my laptop and I never get corruptions. In 18 months with
> an HP Spectre which doesn't even have ECC memory, and has an NVMe
> drive, *and* really remarkable for almost half this time I used the
> discard mount option which pretty much instantly obliterates unused
> roots, even when referenced in the super block as backup roots - and
> yet still zero corruption. No complaints on mount, scrub, or readonly
> checks. *shrug*
> 
> Anyway I suspect hardware or power issue. Or even SSD firmware issue.
I would tend to agree here, with one caveat, if it's a laptop that's 
less than 3 years old, you can probably rule out power issues.  Some 
more info on the particular system might help identify what's wrong.
> 
>> Furthermore, the power-led has recently started blinking (also when
>> the power-cable is plugged in), I guess because of an old and bad
>> battery. Maybe the current corruption also can have something to do
>> with this? However I almost always run with power cable plugged in in
>> last year, only on battery a few seconds a few times when moving the
>> laptop.
>>
>> Currently, I can only mount the filesystem readonly, it goes readonly
>> automatically if I try to mount it normally.
> 
> Btrfs is confused and doesn't want to make the corruption worse. >
>>
>> Fstab mount options: noatime,autodefrag (I have been using the option
>> nossd with older kernels one period in the past on the filesystem).
>>
>> If it matters, I have been running duperemove many times on the
>> filesystem since creation.
> 
> I don't think it's related.
> 
> 
>>
>> To test the RAM, I have been running mprime Blend-test for 24 hours
>> after the corruption without any error or warning.
> 
> I'm not familiar with it, pretty sure you want this for UEFI:
> 
> https://www.memtest86.com/download.htm
> 
> Where you can use that or memtest86+ if the firmware is BIOS based.
Do keep in mind that just because it passes memory checks does not mean 
it's not an issue with the RAM.  Memory testers rarely throw false 
positives, but it's pretty common to get false negatives from them.>
>> I have never noticed any corruptions on the NTFS and Ext4 file systems
>> on the laptop, only on the Btrfs file systems.
> 
> NTFS and ext4 likely won't notice such corruptions either (although
> new ext4 volumes any day now will have checksummed metadata by
> default) as they're weren't designed with such detection in mind.
This is extremely important to understand.  BTRFS and ZFS are 
essentially the only filesystems available on Linux that actually 
validate things enough to notice this reliably (ReFS on Windows probably 
does, and I think whatever Apple is calling their new FS does too). 
Even if ext4 did notice it, it would just mark the filesystem for a 
check and then keep going without doing anything else about it 
(seriously, the default behavior for internal errors on ext4 is to just 
continue like nothing happened and mark the FS for fsck).
