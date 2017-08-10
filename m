Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35041 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752751AbdHJTBK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 15:01:10 -0400
Date: Thu, 10 Aug 2017 12:00:55 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Nick Terrell <terrelln@fb.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        kernel-team@fb.com, squashfs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170810190055.GA97400@gmail.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
 <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0ceeccb4-1a0f-cacb-dd2b-2913e1cf73ab@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 10, 2017 at 01:41:21PM -0400, Chris Mason wrote:
> On 08/10/2017 04:30 AM, Eric Biggers wrote:
> >On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:
> 
> >>The memory reported is the amount of memory the compressor requests.
> >>
> >>| Method   | Size (B) | Time (s) | Ratio | MB/s    | Adj MB/s | Mem (MB) |
> >>|----------|----------|----------|-------|---------|----------|----------|
> >>| none     | 11988480 |    0.100 |     1 | 2119.88 |        - |        - |
> >>| zstd -1  | 73645762 |    1.044 | 2.878 |  203.05 |   224.56 |     1.23 |
> >>| zstd -3  | 66988878 |    1.761 | 3.165 |  120.38 |   127.63 |     2.47 |
> >>| zstd -5  | 65001259 |    2.563 | 3.261 |   82.71 |    86.07 |     2.86 |
> >>| zstd -10 | 60165346 |   13.242 | 3.523 |   16.01 |    16.13 |    13.22 |
> >>| zstd -15 | 58009756 |   47.601 | 3.654 |    4.45 |     4.46 |    21.61 |
> >>| zstd -19 | 54014593 |  102.835 | 3.925 |    2.06 |     2.06 |    60.15 |
> >>| zlib -1  | 77260026 |    2.895 | 2.744 |   73.23 |    75.85 |     0.27 |
> >>| zlib -3  | 72972206 |    4.116 | 2.905 |   51.50 |    52.79 |     0.27 |
> >>| zlib -6  | 68190360 |    9.633 | 3.109 |   22.01 |    22.24 |     0.27 |
> >>| zlib -9  | 67613382 |   22.554 | 3.135 |    9.40 |     9.44 |     0.27 |
> >>
> >
> >Theses benchmarks are misleading because they compress the whole file as a
> >single stream without resetting the dictionary, which isn't how data will
> >typically be compressed in kernel mode.  With filesystem compression the data
> >has to be divided into small chunks that can each be decompressed independently.
> >That eliminates one of the primary advantages of Zstandard (support for large
> >dictionary sizes).
> 
> I did btrfs benchmarks of kernel trees and other normal data sets as
> well.  The numbers were in line with what Nick is posting here.
> zstd is a big win over both lzo and zlib from a btrfs point of view.
> 
> It's true Nick's patches only support a single compression level in
> btrfs, but that's because btrfs doesn't have a way to pass in the
> compression ratio.  It could easily be a mount option, it was just
> outside the scope of Nick's initial work.
> 

I am not surprised --- Zstandard is closer to the state of the art, both
format-wise and implementation-wise, than the other choices in BTRFS.  My point
is that benchmarks need to account for how much data is compressed at a time.
This is a common mistake when comparing different compression algorithms; the
algorithm name and compression level do not tell the whole story.  The
dictionary size is extremely significant.  No one is going to compress or
decompress a 200 MB file as a single stream in kernel mode, so it does not make
sense to justify adding Zstandard *to the kernel* based on such a benchmark.  It
is going to be divided into chunks.  How big are the chunks in BTRFS?  I thought
that it compressed only one page (4 KiB) at a time, but I hope that has been, or
is being, improved; 32 KiB - 128 KiB should be a better amount.  (And if the
amount of data compressed at a time happens to be different between the
different algorithms, note that BTRFS benchmarks are likely to be measuring that
as much as the algorithms themselves.)

Eric
