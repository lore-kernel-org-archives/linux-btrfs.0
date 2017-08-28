Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:32933 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750873AbdH1Lap (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Aug 2017 07:30:45 -0400
Received: by mail-it0-f46.google.com with SMTP id a141so8410471itd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Aug 2017 04:30:45 -0700 (PDT)
Subject: Re: status of inline deduplication in btrfs
To: Adam Borowski <kilobyte@angband.pl>,
        shally verma <shallyvermacavium@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
 <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
 <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
 <pan$e34b7$dc9b9508$835301e3$9a80c4d6@cox.net>
 <20170826161524.xz5xylimnqfucdte@angband.pl>
 <CAP9W88geH+nqhjb=qRkU2WSfXG0x9dz-O_6QC-zfdc31UQ3-CA@mail.gmail.com>
 <20170828103222.bvdsjpzloo4yubzb@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d9689a8d-2e14-e3de-f5d3-656136b42ad7@gmail.com>
Date: Mon, 28 Aug 2017 07:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <20170828103222.bvdsjpzloo4yubzb@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-28 06:32, Adam Borowski wrote:
> On Mon, Aug 28, 2017 at 12:49:10PM +0530, shally verma wrote:
>> Am bit confused over here, is your description based on offline-dedupe
>> here Or its with inline deduplication?
> 
> It doesn't matter _how_ you get to excessive reflinking, the resulting
> slowdown is the same.
> 
> By the way, you can try "bees", it does nearline-dedupe which is for
> practical purposes as good as fully online, and unlike the latter, has no
> way to damage your data in case of bugs (mistaken userland dedupe can at
> most make the kernel pointlessly read and compare data).
> 
> I haven't tried it myself, but what it does is dedupe using FILE_EXTENT_SAME
> asynchronously right after a write gets put into the page cache, which in
> most cases is quick enough to avoid writeout.
I would also recommend looking at 'bees'.  If you absolutely _must_ have 
online or near-online deduplication, then this is your best option 
currently from a data safety perspective.

That said, it's worth pointing out that in-line deduplication is not 
always the best answer.  In fact, it's quite often a sub-optimal answer 
compared to a combination of compression, sparse files, and batch 
deduplication.  Compression and usage of sparse files will get you about 
the same space savings most of the time as in-line deduplication (I've 
tested this on ZFS on FreeBSD using native in-line deduplication, and 
with BTRFS on Linux using bees) while using much less memory, and about 
the same amount of processor time.  In the event that you need better 
space savings than that, you're better off using batch deduplication 
because it gives you better control over when you're using more system 
resources and will often get better overall results than in-line 
deduplication.
