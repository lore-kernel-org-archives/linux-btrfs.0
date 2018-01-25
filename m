Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:44262 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbeAYMlp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 07:41:45 -0500
Received: by mail-it0-f45.google.com with SMTP id b5so9099116itc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 04:41:45 -0800 (PST)
Subject: Re: bad key ordering - repairable?
To: Chris Murphy <lists@colorremedies.com>
Cc: Claes Fransson <claes.v.fransson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
 <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com>
 <CAJCQCtSTeNmL=uk_j6Wt1CXC9HOdRDCKGiO+U-9ovt0CHNijFg@mail.gmail.com>
 <1ad78ca9-f0bd-1420-4a92-27a453ea7540@gmail.com>
 <CAJCQCtRNx6pbk1b0fgTS8HU18svQ7Z_a5dQjtfOL_=1ah-srQg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8af003c2-1ac4-d773-0588-edcffed54fbe@gmail.com>
Date: Thu, 25 Jan 2018 07:41:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRNx6pbk1b0fgTS8HU18svQ7Z_a5dQjtfOL_=1ah-srQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-24 18:54, Chris Murphy wrote:
> On Wed, Jan 24, 2018 at 5:30 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> 
>>> APFS is really vague on this front, it may be checksumming metadata,
>>> it's not checksumming data and with no option to. Apple proposes their
>>> branded storage devices do not return bogus data. OK so then why
>>> checksum the metadata?
>>
>> Even aside from the fact that it might be checksumming data, Apple's storage
>> engineers are still smoking something pretty damn strong if they think that
>> they can claim their storage devices _never_ return bogus data.  Either
>> they're running some kind of checksumming _and_ replication below the block
>> layer in the storage device itself (which actually might explain the insane
>> cost of at least one piece of their hardware), or they think they've come up
>> with some fail-safe way to detect corruption and return errors reliably, and
>> in either case things can still fail.  I smell a potential future lawsuit in
>> the works.
> 
> 
> I read somewhere the hardware (or more correctly their flash firmware)
> supposedly uses 128 bytes of checksum per 4KB data. That's a lot, I
> wonder if it's actually some kind of parity. But regardless, this kind
> of in-hardware checksumming won't account for things like misdirected
> or torn writes or literally any sort of corruption happening prior to
> the flash firmware computing those checksums.
It's most likely more generic erasure coding (parity as most people 
think of it in the storage sense (RAID5 and RAID6) is a special case of 
(n, n-1) or (n, n-2) erasure coding that happens to be optimal), so in 
theory they could correct up to 1024 bits of errors, which is all well 
and good, but as you say doesn't really protect against much (more 
specifically, it only protects reliably against cell discharges from 
various sources, or more generic read-disturb errors).
> 
> On flash storage, maybe they're just concerned about bit rot or even
> the most superficial bit flips, and having just enough information to
> detect and correct for 1 or 2 flips per 4KB, not totally dissimilar to
> ECC memory. But that they don't use ECC memory, leave them open to
> corruption in the storage stack happening outside the literal storage
> device.
They also don't appear to use T.10 DIF (or whatever the T.13 equivalent 
that I can never remember the name of is), which means even if they did 
use ECC RAM they would still have a period of time where the data is 
unprotected.
> 
>> Actually, I forgot about the (newer) metadata checksumming feature in ext4,
>> and was just basing my statement on behavior the last time I used it for
>> anything serious.  Having just checked mkfs.ext4, it appears that the
>> metadata in the SB that tells the kernel what to do when it runs into an
>> error for the FS still defaults to continuing on as if nothing happens, even
>> if you enable metadata checksumming (which still seems to be disabled by
>> default).  Whether or not that actually is honored by modern kernels, I
>> don't know, but I've seen no evidence to suggest that it isn't.
> 
> 
> Depending on the corruption, Btrfs continues as well. If I corrupt a
> deadend leaf that contains file metadata (like names or security
> contexts), I just get some complaints of corruption. The file system
> remains rw mounted though. I don't know the metric by which metadata
> can be damaged and Btrfs says "whoooaa!!" and puts on the brakes by
> going read only. XFS certainly has its limits and goes read only when
> it detects certain metadata corruption via checksum fail. I'd guess
> ext4 will do the same thing, otherwise whats the point if it's going
> to knowingly eat itself alive?
I'm pretty sure the ext4 behavior is a hold-over from the original ext 
filesystem, and I think even as far back as the version of the MINIX 
filesystem that Linux originally used (which ext evolved out of).  At a 
minimum, all three error behaviors (panic, go read-only, or flag and 
ignore) have been around since the early days of ext2.

FWIW, there are some cases where it does make sense to just not care and 
ignore the errors.  As a pretty specific example, one of the last 
remaining places I still use ext4 is on top of compressed ramdisks when 
I need some quick ephemeral storage that I want to be more memory 
efficient than tmpfs.  In such cases, the FS gets mounted exactly once, 
and is usually used only for a very short period of time, and as a 
result, the 'on-disk' data doesn't really matter much, so there's not 
much point in worrying about it.
