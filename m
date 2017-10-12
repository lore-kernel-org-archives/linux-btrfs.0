Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:50765 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752485AbdJLV6Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 17:58:16 -0400
Received: by mail-oi0-f43.google.com with SMTP id q4so10703615oic.7
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Oct 2017 14:58:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi74m51khUNR0Q1VOKE0tZdOZ15_XZc6DEmQBfNrMNsmpfw@mail.gmail.com>
References: <CAGqmi74m51khUNR0Q1VOKE0tZdOZ15_XZc6DEmQBfNrMNsmpfw@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 13 Oct 2017 00:57:35 +0300
Message-ID: <CAGqmi75-+R=3=hyjkxQ-SHU=2cHfQf5FXGr9ijCimNBG0uZt0A@mail.gmail.com>
Subject: Re: [RFC] Btrfs: compression heuristic performance
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just info update.

I did some more benchmark, optimization and testing.
(Write kernel generalized version of radix sort (that can be ported to sort.c))
(Some memory allocating changes & etc)
(Also i'm stupid and make a mistake with inversion of percentage numbers)

New, more clean numbers (I disable useless printf and etc):
  Stats mode heap sort (in kernel):
    - average ... random data - ~3000 MiB/s
    - Zeroed - ~4400 MiB/s
  Stats mode radix sort:
    - average ... random data - ~4900 MiB/s +63%
    - Zeroed - ~4100 MiB/s -7%  # radix have some problems with
sorting zeroes :)

  Non stats mode heap sort:
    - average ... random data - ~3500 MiB/s
    - Zeroed - ~11500 MiB/s
  Non stats mode radix sort:
    - average ... random data - ~6000 MiB/s +71%
    - Zeroed - ~11500 MiB/s # as expected no diff, sorting do nothing
on that case

Another hot (and slow) path in heuristic, is simple ilog2 =\
i'm give up on porting in kernel ilog2 for x86, so i'm not sure that
happens in kernel with that,
so JFYI:
it's have a significant value only with radix, because heap sort are
much slower...
So numbers:
  Stats mode simple ilog2:
    - average ... random data - ~3000 MiB/s
    - Zeroed - ~4400 MiB/s
    Stats mode fast ilog2[1]:
    - average ... random data - ~3500 MiB/s +16%
    - Zeroed - ~4400 MiB/s  # ilog2 just do nothing on zeroes

  Non stats mode simple ilog2:
    - average ... random data - ~3500 MiB/s
    - Zeroed - ~11500 MiB/s
   Non stats mode fast ilog2:
    # Because byte_core_set_size avoid from too bad data
    - average ... random data - ~3600 MiB/s +2%
    - Zeroed - ~11500 MiB/s # as expected no diff, ilog2 do nothing on that case
    # with radix sort
    - average ... random data - ~6200 MiB/s +77%

So, as heuristic is try save CPU time from compression,
I think that acceptable to sacrifice 1KiB memory for buffered data
(general time/memory trade-off)
I will write a RFC with radix sort to compression.c in near time.
I'm hard to found other kernel places where that can be used for now.
IMHO, if someone also will want that, we will always can move that to lib later.

Thanks.

Notes:
1. Fast cross platform 64 bit ilog2 (found in the web)
const int tab64[64] = {
    63,  0, 58,  1, 59, 47, 53,  2,
    60, 39, 48, 27, 54, 33, 42,  3,
    61, 51, 37, 40, 49, 18, 28, 20,
    55, 30, 34, 11, 43, 14, 22,  4,
    62, 57, 46, 52, 38, 26, 32, 41,
    50, 36, 17, 19, 29, 10, 13, 21,
    56, 45, 25, 31, 35, 16,  9, 12,
    44, 24, 15,  8, 23,  7,  6,  5};

int ilog2_64 (uint64_t value)
{
    value |= value >> 1;
    value |= value >> 2;
    value |= value >> 4;
    value |= value >> 8;
    value |= value >> 16;
    value |= value >> 32;
    return tab64[((uint64_t)((value - (value >> 1))*0x07EDD5E59A4E28C2)) >> 58];
}

-- 
Have a nice day,
Timofey.
