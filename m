Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:33033 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdGFL74 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 07:59:56 -0400
Received: by mail-it0-f48.google.com with SMTP id 188so19272920itx.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 04:59:56 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>, Adam Borowski <kilobyte@angband.pl>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, E V <eliventer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Yann Collet <cyan@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
 <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
 <15B9D85B-F8AF-44B3-B644-7E4F13A3764C@fb.com>
 <0cf10bfd-8631-7542-be31-7cc04379b0a9@gmail.com>
 <20170705181854.a4d35h2dgp4t3hlt@angband.pl>
 <eb05605b-e3e5-2312-437e-4ae1fafa8bab@gmail.com>
 <B19A0CF8-3CB8-4EA1-AC6A-2383B4BD944A@fb.com>
 <a5672463-f06f-a902-73e3-b101bcb2b3c3@gmail.com>
 <3457CD72-ECD7-4E07-A297-7AE426BF39C1@fb.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <44461d9f-f21f-c346-df0a-5ee4e7bf838d@gmail.com>
Date: Thu, 6 Jul 2017 07:59:53 -0400
MIME-Version: 1.0
In-Reply-To: <3457CD72-ECD7-4E07-A297-7AE426BF39C1@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-05 20:25, Nick Terrell wrote:
> On 7/5/17, 12:57 PM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
>> It's the slower compression speed that has me arguing for the
>> possibility of configurable levels on zlib.  11MB/s is painfully slow
>> considering that most decent HDD's these days can get almost 5-10x that
>> speed with no compression.  There are cases (WORM pattern archival
>> storage for example) where slow writes to that degree may be acceptable,
>> but for most users they won't be, and zlib at level 9 would probably be
>> a better choice.  I don't think it can beat zstd at level 15 for
>> compression ratio, but if they're even close, then zlib would still be a
>> better option at that high of a compression level most of the time.
> 
> I don't imagine the very high zstd levels would be useful to too many
> btrfs users, except in rare cases. However, lower levels of zstd should
> outperform zlib level 9 in all aspects except memory usage. I would expect
> zstd level 7 would compress as well as or better than zlib 9 with faster
> compression and decompression speed. It's worth benchmarking to ensure that
> it holds for many different workloads, but I wouldn't expect zlib 9 to
> compress better than zstd 7 often. zstd up to level 12 should compress as
> fast as or faster than zlib level 9. zstd levels 12 and beyond allow
> stronger compression than zlib, at the cost of slow compression and more
> memory usage.
While I generally agree that most people probably won't use zstd levels 
above 3, it shouldn't be hard to support them if we're going to have 
configurable compression levels, so I would argue that it's still worth 
supporting anyway.

Looking at it another way, ZFS (at least, ZFS on FreeBSD) supports zlib 
compression (they call it gzip) with selectable compression levels, but 
95% of the time nobody uses anything but levels 1, 3, and 9.  Despite 
this, they still support other levels, and I have seen cases where other 
levels have been better than one of those three 'normal' ones.
> 
> Supporting multiple zlib compression levels could be intersting for older
> kernels, lower memory usage, or backwards compatibility with older btrfs
> versions. But for every zlib level, zstd has a level that provides better
> compression ratio, compression speed, and decompression speed.
Just the memory footprint is a remarkably strong argument in many cases. 
  It appears to be one of the few things that zlib does better than zstd 
(although I'm not 100% certain about that), and can make a very big 
difference when dealing with small systems.
