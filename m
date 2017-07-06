Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:37177 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdGFM2A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Jul 2017 08:28:00 -0400
Received: by mail-it0-f41.google.com with SMTP id m84so450422ita.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Jul 2017 05:28:00 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Nick Terrell <terrelln@fb.com>, Adam Borowski <kilobyte@angband.pl>
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
 <44461d9f-f21f-c346-df0a-5ee4e7bf838d@gmail.com>
 <625a13d5-0a00-6505-99f2-00bc268e50d5@bouton.name>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2d62b4da-fe6e-6e4d-f868-95cad2dbafe8@gmail.com>
Date: Thu, 6 Jul 2017 08:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <625a13d5-0a00-6505-99f2-00bc268e50d5@bouton.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-06 08:09, Lionel Bouton wrote:
> Le 06/07/2017 à 13:59, Austin S. Hemmelgarn a écrit :
>> On 2017-07-05 20:25, Nick Terrell wrote:
>>> On 7/5/17, 12:57 PM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
>>> wrote:
>>>> It's the slower compression speed that has me arguing for the
>>>> possibility of configurable levels on zlib.  11MB/s is painfully slow
>>>> considering that most decent HDD's these days can get almost 5-10x that
>>>> speed with no compression.  There are cases (WORM pattern archival
>>>> storage for example) where slow writes to that degree may be
>>>> acceptable,
>>>> but for most users they won't be, and zlib at level 9 would probably be
>>>> a better choice.  I don't think it can beat zstd at level 15 for
>>>> compression ratio, but if they're even close, then zlib would still
>>>> be a
>>>> better option at that high of a compression level most of the time.
>>>
>>> I don't imagine the very high zstd levels would be useful to too many
>>> btrfs users, except in rare cases. However, lower levels of zstd should
>>> outperform zlib level 9 in all aspects except memory usage. I would
>>> expect
>>> zstd level 7 would compress as well as or better than zlib 9 with faster
>>> compression and decompression speed. It's worth benchmarking to
>>> ensure that
>>> it holds for many different workloads, but I wouldn't expect zlib 9 to
>>> compress better than zstd 7 often. zstd up to level 12 should
>>> compress as
>>> fast as or faster than zlib level 9. zstd levels 12 and beyond allow
>>> stronger compression than zlib, at the cost of slow compression and more
>>> memory usage.
>> While I generally agree that most people probably won't use zstd
>> levels above 3, it shouldn't be hard to support them if we're going to
>> have configurable compression levels, so I would argue that it's still
>> worth supporting anyway.
> 
> One use case for the higher compression levels would be manual
> defragmentation with recompression for a subset of data (files that
> won't be updated and are stored for long periods typically). The
> filesystem would be mounted with a low level for general usage low
> latencies and the subset of files would be recompressed with a high
> level asynchronously.
That's one of the cases I was thinking of, we actually do that on a 
couple of systems where I work that see mostly WORM access patterns, so 
zstd level 15's insanely good decompression speed would be great for this.

