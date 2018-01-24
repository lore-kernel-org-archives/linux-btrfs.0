Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:43712 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932072AbeAXXyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 18:54:16 -0500
Received: by mail-oi0-f50.google.com with SMTP id 4so507675ois.10
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jan 2018 15:54:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1ad78ca9-f0bd-1420-4a92-27a453ea7540@gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com>
 <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com> <CAJCQCtSTeNmL=uk_j6Wt1CXC9HOdRDCKGiO+U-9ovt0CHNijFg@mail.gmail.com>
 <1ad78ca9-f0bd-1420-4a92-27a453ea7540@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 Jan 2018 16:54:14 -0700
Message-ID: <CAJCQCtRNx6pbk1b0fgTS8HU18svQ7Z_a5dQjtfOL_=1ah-srQg@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Claes Fransson <claes.v.fransson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 24, 2018 at 5:30 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>> APFS is really vague on this front, it may be checksumming metadata,
>> it's not checksumming data and with no option to. Apple proposes their
>> branded storage devices do not return bogus data. OK so then why
>> checksum the metadata?
>
> Even aside from the fact that it might be checksumming data, Apple's storage
> engineers are still smoking something pretty damn strong if they think that
> they can claim their storage devices _never_ return bogus data.  Either
> they're running some kind of checksumming _and_ replication below the block
> layer in the storage device itself (which actually might explain the insane
> cost of at least one piece of their hardware), or they think they've come up
> with some fail-safe way to detect corruption and return errors reliably, and
> in either case things can still fail.  I smell a potential future lawsuit in
> the works.


I read somewhere the hardware (or more correctly their flash firmware)
supposedly uses 128 bytes of checksum per 4KB data. That's a lot, I
wonder if it's actually some kind of parity. But regardless, this kind
of in-hardware checksumming won't account for things like misdirected
or torn writes or literally any sort of corruption happening prior to
the flash firmware computing those checksums.

On flash storage, maybe they're just concerned about bit rot or even
the most superficial bit flips, and having just enough information to
detect and correct for 1 or 2 flips per 4KB, not totally dissimilar to
ECC memory. But that they don't use ECC memory, leave them open to
corruption in the storage stack happening outside the literal storage
device.


> Actually, I forgot about the (newer) metadata checksumming feature in ext4,
> and was just basing my statement on behavior the last time I used it for
> anything serious.  Having just checked mkfs.ext4, it appears that the
> metadata in the SB that tells the kernel what to do when it runs into an
> error for the FS still defaults to continuing on as if nothing happens, even
> if you enable metadata checksumming (which still seems to be disabled by
> default).  Whether or not that actually is honored by modern kernels, I
> don't know, but I've seen no evidence to suggest that it isn't.


Depending on the corruption, Btrfs continues as well. If I corrupt a
deadend leaf that contains file metadata (like names or security
contexts), I just get some complaints of corruption. The file system
remains rw mounted though. I don't know the metric by which metadata
can be damaged and Btrfs says "whoooaa!!" and puts on the brakes by
going read only. XFS certainly has its limits and goes read only when
it detects certain metadata corruption via checksum fail. I'd guess
ext4 will do the same thing, otherwise whats the point if it's going
to knowingly eat itself alive?


-- 
Chris Murphy
