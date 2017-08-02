Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33344 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752052AbdHBLSz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 07:18:55 -0400
Received: by mail-it0-f66.google.com with SMTP id m34so3640742iti.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 04:18:54 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id w207sm1885418itc.34.2017.08.02.04.18.52
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Aug 2017 04:18:52 -0700 (PDT)
Subject: Re: Massive loss of disk space
To: linux-btrfs@vger.kernel.org
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <pan$1f7fd$6c213f15$dbc4044e$d902814e@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0aa7b51e-7d4f-a193-06f8-3b5da65be80c@gmail.com>
Date: Wed, 2 Aug 2017 07:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <pan$1f7fd$6c213f15$dbc4044e$d902814e@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-02 00:14, Duncan wrote:
> Austin S. Hemmelgarn posted on Tue, 01 Aug 2017 10:47:30 -0400 as
> excerpted:
> 
>> I think I _might_ understand what's going on here.  Is that test program
>> calling fallocate using the desired total size of the file, or just
>> trying to allocate the range beyond the end to extend the file?  I've
>> seen issues with the first case on BTRFS before, and I'm starting to
>> think that it might actually be trying to allocate the exact amount of
>> space requested by fallocate, even if part of the range is already
>> allocated space.
> 
> If I've interpreted correctly (not being a dev, only a btrfs user,
> sysadmin, and list regular) previous discussions I've seen on this list...
> 
> That's exactly what it's doing, and it's _intended_ behavior.
> 
> The reasoning is something like this:  fallocate is supposed to pre-
> allocate some space with the intent being that writes into that space
> won't fail, because the space is already allocated.
> 
> For an existing file with some data already in it, ext4 and xfs do that
> counting the existing space.
> 
> But btrfs is copy-on-write, meaning it's going to have to write the new
> data to a different location than the existing data, and it may well not
> free up the existing allocation (if even a single 4k block of the
> existing allocation remains unwritten, it will remain to hold down the
> entire previous allocation, which isn't released until *none* of it is
> still in use -- of course in normal usage "in use" can be due to old
> snapshots or other reflinks to the same extent, as well, tho in these
> test cases it's not).
> 
> So in ordered to provide the writes to preallocated space shouldn't ENOSPC
> guarantee, btrfs can't count currently actually used space as part of the
> fallocate.
> 
> The different behavior is entirely due to btrfs being COW, and thus a
> choice having to be made, do we worst-case fallocate-reserve for writes
> over currently used data that will have to be COWed elsewhere, possibly
> without freeing the existing extents because there's still something
> referencing them, or do we risk ENOSPCing on write to a previously
> fallocated area?
> 
> The choice was to worst-case-reserve and take the ENOSPC risk at fallocate
> time, so the write into that fallocated space could then proceed without
> the ENOSPC risk that COW would otherwise imply.
> 
> Make sense, or is my understanding a horrible misunderstanding? =:^)
Your reasoning is sound, except for the fact that at least on older 
kernels (not sure if this is still the case), BTRFS will still perform a 
COW operation when updating a fallocate'ed region.
> 
> So if you're actually only appending, fallocate the /additional/ space,
> not the /entire/ space, and you'll get what you need.  But if you're
> potentially overwriting what's there already, better fallocate the entire
> space, which triggers the btrfs worst-case allocation behavior you see,
> in ordered to guarantee it won't ENOSPC during the actual write.
> 
> Of course the only time the behavior actually differs is with COW, but
> then there's a BIG difference, but that BIG difference has a GOOD BIG
> reason!  =:^)
> 
> Tho that difference will certainly necessitate some relearning the
> /correct/ way to do it, for devs who were doing it the COW-worst-case way
> all along, even if they didn't actually need to, because it didn't happen
> to make a difference on what they happened to be testing on, which
> happened not to be COW...
> 
> Reminds me of the way newer versions of gcc and/or trying to build with
> clang as well tends to trigger relearning, because newer versions are
> stricter in ordered to allow better optimization, and other
> implementations are simply different in what they're strict on, /because/
> they're a different implementation.  Well, btrfs is stricter... because
> it's a different implementation that /has/ to be stricter... due to COW.
Except that that strictness breaks userspace programs that are doing 
perfectly reasonable things.

