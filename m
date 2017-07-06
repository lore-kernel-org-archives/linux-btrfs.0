Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36146 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751914AbdGFAZy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Jul 2017 20:25:54 -0400
From: Nick Terrell <terrelln@fb.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>
CC: "dsterba@suse.cz" <dsterba@suse.cz>, E V <eliventer@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Yann Collet <cyan@fb.com>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
Date: Thu, 6 Jul 2017 00:25:40 +0000
Message-ID: <3457CD72-ECD7-4E07-A297-7AE426BF39C1@fb.com>
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
In-Reply-To: <a5672463-f06f-a902-73e3-b101bcb2b3c3@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/5/17, 12:57 PM, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:
> It's the slower compression speed that has me arguing for the 
> possibility of configurable levels on zlib.  11MB/s is painfully slow 
> considering that most decent HDD's these days can get almost 5-10x that 
> speed with no compression.  There are cases (WORM pattern archival 
> storage for example) where slow writes to that degree may be acceptable, 
> but for most users they won't be, and zlib at level 9 would probably be 
> a better choice.  I don't think it can beat zstd at level 15 for 
> compression ratio, but if they're even close, then zlib would still be a 
> better option at that high of a compression level most of the time.

I don't imagine the very high zstd levels would be useful to too many
btrfs users, except in rare cases. However, lower levels of zstd should
outperform zlib level 9 in all aspects except memory usage. I would expect
zstd level 7 would compress as well as or better than zlib 9 with faster
compression and decompression speed. It's worth benchmarking to ensure that
it holds for many different workloads, but I wouldn't expect zlib 9 to
compress better than zstd 7 often. zstd up to level 12 should compress as
fast as or faster than zlib level 9. zstd levels 12 and beyond allow
stronger compression than zlib, at the cost of slow compression and more
memory usage. 

Supporting multiple zlib compression levels could be intersting for older
kernels, lower memory usage, or backwards compatibility with older btrfs
versions. But for every zlib level, zstd has a level that provides better
compression ratio, compression speed, and decompression speed.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
