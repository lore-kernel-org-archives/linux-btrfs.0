Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:41701 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbeAWNRr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 08:17:47 -0500
Received: by mail-pg0-f51.google.com with SMTP id 136so257418pgd.8
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 05:17:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
From: Claes Fransson <claes.v.fransson@gmail.com>
Date: Tue, 23 Jan 2018 14:17:46 +0100
Message-ID: <CAEY8F1q_dJVP6SUjP3ZCUXDcWuAkFgaFX5c1issJ=FvaQxpM=A@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-23 3:35 GMT+01:00 Chris Murphy <lists@colorremedies.com>:
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
Okay, thank you for sharing your experience


> Anyway I suspect hardware or power issue. Or even SSD firmware issue.
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
> Btrfs is confused and doesn't want to make the corruption worse.
>
>
>
>
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
Thanks, I will try this within the next days (I boot my laptop in UEFI mode),


> Where you can use that or memtest86+ if the firmware is BIOS based.
>
>
>> I have never noticed any corruptions on the NTFS and Ext4 file systems
>> on the laptop, only on the Btrfs file systems.
>
> NTFS and ext4 likely won't notice such corruptions either (although
> new ext4 volumes any day now will have checksummed metadata by
> default) as they're weren't designed with such detection in mind.
>
>
> --
> Chris Murphy
