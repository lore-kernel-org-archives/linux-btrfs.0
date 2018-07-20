Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f54.google.com ([209.85.208.54]:33637 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbeGTFsT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 01:48:19 -0400
Received: by mail-ed1-f54.google.com with SMTP id x5-v6so8758543edr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 22:01:55 -0700 (PDT)
Subject: Re: Healthy amount of free space?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Nikolay Borisov <nborisov@suse.com>, Wolf <wolf@wolfsden.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20180716205809.42jywfvuxwuuqixd@wolfsden.cz>
 <2197534.TZSffJRfLT@merkaba> <9ea19b13-3c46-666f-fa79-f40bd1ae7658@suse.com>
 <1736761.B5nO4FXixV@merkaba> <33396c10-33ef-b8ff-0041-c94d87c67722@gmail.com>
 <CAJCQCtSZruKeM117EfQNQnEFuk_bswhhKnEnFVD2i7MHWU65RQ@mail.gmail.com>
 <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <f0c978ec-ca06-af17-cc1b-e82bc80aff8e@gmail.com>
Date: Fri, 20 Jul 2018 08:01:52 +0300
MIME-Version: 1.0
In-Reply-To: <d42d5c79-46df-4e11-0ba2-1adb9e073ed9@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

18.07.2018 16:30, Austin S. Hemmelgarn пишет:
> On 2018-07-18 09:07, Chris Murphy wrote:
>> On Wed, Jul 18, 2018 at 6:35 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>
>>> If you're doing a training presentation, it may be worth mentioning that
>>> preallocation with fallocate() does not behave the same on BTRFS as
>>> it does
>>> on other filesystems.  For example, the following sequence of commands:
>>>
>>>      fallocate -l X ./tmp
>>>      dd if=/dev/zero of=./tmp bs=1 count=X
>>>
>>> Will always work on ext4, XFS, and most other filesystems, for any
>>> value of
>>> X between zero and just below the total amount of free space on the
>>> filesystem.  On BTRFS though, it will reliably fail with ENOSPC for
>>> values
>>> of X that are greater than _half_ of the total amount of free space
>>> on the
>>> filesystem (actually, greater than just short of half).  In essence,
>>> preallocating space does not prevent COW semantics for the first write
>>> unless the file is marked NOCOW.
>>
>> Is this a bug, or is it suboptimal behavior, or is it intentional?
> It's been discussed before, though I can't find the email thread right
> now.  Pretty much, this is _technically_ not incorrect behavior, as the
> documentation for fallocate doesn't say that subsequent writes can't
> fail due to lack of space.  I personally consider it a bug though
> because it breaks from existing behavior in a way that is avoidable and
> defies user expectations.
> 
> There are two issues here:
> 
> 1. Regions preallocated with fallocate still do COW on the first write
> to any given block in that region.  This can be handled by either
> treating the first write to each block as NOCOW, or by allocating a bit

How is it possible? As long as fallocate actually allocates space, this
should be checksummed which means it is no more possible to overwrite
it. May be fallocate on btrfs could simply reserve space. Not sure
whether it complies with fallocate specification, but as long as
intention is to ensure write will not fail for the lack of space it
should be adequate (to the extent it can be ensured on btrfs of course).
Also hole in file returns zeros by definition which also matches
fallocate behavior.

> of extra space and doing a rotating approach like this for writes:
>     - Write goes into the extra space.
>     - Once the write is done, convert the region covered by the write
>       into a new block of extra space.
>     - When the final block of the preallocated region is written,
>       deallocate the extra space.
> 2. Preallocation does not completely account for necessary metadata
> space that will be needed to store the data there.  This may not be
> necessary if the first issue is addressed properly.
>>
>> And then I wonder what happens with XFS COW:
>>
>>       fallocate -l X ./tmp
>>       cp --reflink ./tmp ./tmp2
>>       dd if=/dev/zero of=./tmp bs=1 count=X
> I'm not sure.  In this particular case, this will fail on BTRFS for any
> X larger than just short of one third of the total free space.  I would
> expect it to fail for any X larger than just short of half instead.
> 
> ZFS gets around this by not supporting fallocate (well, kind of, if
> you're using glibc and call posix_fallocate, that _will_ work, but it
> will take forever because it works by writing out each block of space
> that's being allocated, which, ironically, means that that still suffers
> from the same issue potentially that we have).

What happens on btrfs then? fallocate specifies that new space should be
initialized to zero, so something should still write those zeros?
