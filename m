Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34985 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbdHJIaU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 04:30:20 -0400
Date: Thu, 10 Aug 2017 01:30:17 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: Nick Terrell <terrelln@fb.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, kernel-team@fb.com,
        squashfs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Message-ID: <20170810083017.GA10462@zzz.localdomain>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170810023553.3200875-3-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:
>
> It can compress at speeds approaching lz4, and quality approaching lzma.

Well, for a very loose definition of "approaching", and certainly not at the
same time.  I doubt there's a use case for using the highest compression levels
in kernel mode --- especially the ones using zstd_opt.h.

> 
> The code was ported from the upstream zstd source repository.

What version?

> `linux/zstd.h` header was modified to match linux kernel style.
> The cross-platform and allocation code was stripped out. Instead zstd
> requires the caller to pass a preallocated workspace. The source files
> were clang-formatted [1] to match the Linux Kernel style as much as
> possible. 

It would be easier to compare to the upstream version if it was not all
reformatted.  There is a chance that bugs were introduced by Linux-specific
changes, and it would be nice if they could be easily reviewed.  (Also I don't
know what clang-format settings you used, but there are still a lot of
differences from the Linux coding style.)

> 
> I benchmarked zstd compression as a special character device. I ran zstd
> and zlib compression at several levels, as well as performing no
> compression, which measure the time spent copying the data to kernel space.
> Data is passed to the compresser 4096 B at a time. The benchmark file is
> located in the upstream zstd source repository under
> `contrib/linux-kernel/zstd_compress_test.c` [2].
> 
> I ran the benchmarks on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM.
> The VM is running on a MacBook Pro with a 3.1 GHz Intel Core i7 processor,
> 16 GB of RAM, and a SSD. I benchmarked using `silesia.tar` [3], which is
> 211,988,480 B large. Run the following commands for the benchmark:
> 
>     sudo modprobe zstd_compress_test
>     sudo mknod zstd_compress_test c 245 0
>     sudo cp silesia.tar zstd_compress_test
> 
> The time is reported by the time of the userland `cp`.
> The MB/s is computed with
> 
>     1,536,217,008 B / time(buffer size, hash)
> 
> which includes the time to copy from userland.
> The Adjusted MB/s is computed with
> 
>     1,536,217,088 B / (time(buffer size, hash) - time(buffer size, none)).
> 
> The memory reported is the amount of memory the compressor requests.
> 
> | Method   | Size (B) | Time (s) | Ratio | MB/s    | Adj MB/s | Mem (MB) |
> |----------|----------|----------|-------|---------|----------|----------|
> | none     | 11988480 |    0.100 |     1 | 2119.88 |        - |        - |
> | zstd -1  | 73645762 |    1.044 | 2.878 |  203.05 |   224.56 |     1.23 |
> | zstd -3  | 66988878 |    1.761 | 3.165 |  120.38 |   127.63 |     2.47 |
> | zstd -5  | 65001259 |    2.563 | 3.261 |   82.71 |    86.07 |     2.86 |
> | zstd -10 | 60165346 |   13.242 | 3.523 |   16.01 |    16.13 |    13.22 |
> | zstd -15 | 58009756 |   47.601 | 3.654 |    4.45 |     4.46 |    21.61 |
> | zstd -19 | 54014593 |  102.835 | 3.925 |    2.06 |     2.06 |    60.15 |
> | zlib -1  | 77260026 |    2.895 | 2.744 |   73.23 |    75.85 |     0.27 |
> | zlib -3  | 72972206 |    4.116 | 2.905 |   51.50 |    52.79 |     0.27 |
> | zlib -6  | 68190360 |    9.633 | 3.109 |   22.01 |    22.24 |     0.27 |
> | zlib -9  | 67613382 |   22.554 | 3.135 |    9.40 |     9.44 |     0.27 |
> 

Theses benchmarks are misleading because they compress the whole file as a
single stream without resetting the dictionary, which isn't how data will
typically be compressed in kernel mode.  With filesystem compression the data
has to be divided into small chunks that can each be decompressed independently.
That eliminates one of the primary advantages of Zstandard (support for large
dictionary sizes).

Eric
