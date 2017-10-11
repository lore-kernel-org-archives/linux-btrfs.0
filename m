Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:53089 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751964AbdJKWih (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 18:38:37 -0400
Received: by mail-oi0-f67.google.com with SMTP id c202so5459622oih.9
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 15:38:37 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 12 Oct 2017 01:37:56 +0300
Message-ID: <CAGqmi74m51khUNR0Q1VOKE0tZdOZ15_XZc6DEmQBfNrMNsmpfw@mail.gmail.com>
Subject: [RFC] Btrfs: compression heuristic performance
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David, (and list folks in CC of course).

TL;DR
Sorting is a slowest part of heuristic for now (in worst case ~55% of run time).
Kernel use heap sort, i.e. heuristic also use that.
Radix sort speedup heuristic a lot (~+30-40%).
But radix have some tradeoffs (i.e. need more memory, but that can be
easy fixed in theory),
does that a normal idea to port radix sort for kernel?

Long read version below.
---
I already mentioned that i reverse port heuristic code from kernel to
userspace [1],
to make some experiments and profiling easy for me.

(So i spend about a week with some experiments and testings.)

(I firstly profiling with Valgrind)
So i found heuristic bottleneck for now, is a kernel heap sort()
(sort uses about 55% of runtime, that look crazy for me)

And as sort used in byte_core_set_size(), all not text data, sort will
be called.
i.e. from my point of view in 90% cases.

(Tool have 2 mods in main, stats and non stats %) )
For show the scale of a problem:
  Stats mode:
    - For average and worst case data (random) ~2600 MiB/s
    - Zeroed data - ~3400 MiB/s
  Non stats (kernel like)
    - For average and worst case data (random) ~3000 MiB/s
    - Zeroed data - ~8000 MiB/s


I spend several days try to beat that by different way =\
Only way that i found (i.e. that show good profit)
Is replace kernel heap sort with radix_sort() [2]   =\

With radix sort:
  Stats mode:
    - For average and worst case data (random) ~3800 MiB/s ~+31%
    - Zeroed data - ~3400 MiB/s (not sure why performance are same)
  Non stats (kernel like)
    - For average and worst case data (random) ~4800 MiB/s ~+37%
    - Zeroed data - ~8000 MiB/s

(Inline Radix get additional show +200MiB/s)

That seems cool, but please, wait a second nothing come free.

Radix sort need a 2 buffers, one for counters, and one for output array.

So in our case, (i use 4 bit as radix base),
16 * 4 bytes for counters (stored at stack of sort function)
+ 4*256 bytes for bucket_buffer. (stored at heuristic workspace).

So, in theory, that make a heuristic workspace weight more, i.e. +1KiB per CPU.

As heuristic have some assumptions, i.e. we really care only about sample size.
And sample size in our case are 8KiB max (i.e. 8KiB per CPU).
That possible to replace u32 counters in buckets with u16 counters.

And get same:
8KiB sample per CPU
1KiB buckets per CPU

But main question:
does that make a sense?

Thanks!

Links:
1. https://github.com/Nefelim4ag/companalyze
2. https://github.com/Nefelim4ag/companalyze/commit/1cd371eac5056927e5f567c6bd32e179ba859629
-- 
Have a nice day,
Timofey.
