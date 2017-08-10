Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60379 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752882AbdHJTRA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 15:17:00 -0400
From: Nick Terrell <terrelln@fb.com>
To: Eric Biggers <ebiggers3@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Kernel Team <Kernel-team@fb.com>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v5 2/5] lib: Add zstd modules
Date: Thu, 10 Aug 2017 19:16:45 +0000
Message-ID: <A38BC5B4-7951-4045-B3F0-F1D923C08EB7@fb.com>
References: <20170810023553.3200875-1-terrelln@fb.com>
 <20170810023553.3200875-3-terrelln@fb.com>
 <20170810083017.GA10462@zzz.localdomain>
In-Reply-To: <20170810083017.GA10462@zzz.localdomain>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/10/17, 1:30 AM, "Eric Biggers" <ebiggers3@gmail.com> wrote:
> On Wed, Aug 09, 2017 at 07:35:53PM -0700, Nick Terrell wrote:
>>
>> It can compress at speeds approaching lz4, and quality approaching lzma.
> 
> Well, for a very loose definition of "approaching", and certainly not at the
> same time.  I doubt there's a use case for using the highest compression levels
> in kernel mode --- especially the ones using zstd_opt.h.
> 
>> 
>> The code was ported from the upstream zstd source repository.
> 
> What version?

zstd-1.1.4 with patches applied from upstream. I'll include it in the
next patch version.

>> `linux/zstd.h` header was modified to match linux kernel style.
>> The cross-platform and allocation code was stripped out. Instead zstd
>> requires the caller to pass a preallocated workspace. The source files
>> were clang-formatted [1] to match the Linux Kernel style as much as
>> possible. 
> 
> It would be easier to compare to the upstream version if it was not all
> reformatted.  There is a chance that bugs were introduced by Linux-specific
> changes, and it would be nice if they could be easily reviewed.  (Also I don't
> know what clang-format settings you used, but there are still a lot of
> differences from the Linux coding style.)

The clang-format settings I used are available in the zstd repo [1]. I left
the line length long, since it looked terrible otherwise.I set up a branch
in my zstd GitHub fork called "original-formatted" [2]. I've taken the source
I based the kernel patches off of [3] and ran clang-format without any other
changes. If you have any suggestions to improve the clang-formatting
please let me know.

>> 
>> I benchmarked zstd compression as a special character device. I ran zstd
>> and zlib compression at several levels, as well as performing no
>> compression, which measure the time spent copying the data to kernel space.
>> Data is passed to the compresser 4096 B at a time. The benchmark file is
>> located in the upstream zstd source repository under
>> `contrib/linux-kernel/zstd_compress_test.c` [2].
>> 
>> I ran the benchmarks on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM.
>> The VM is running on a MacBook Pro with a 3.1 GHz Intel Core i7 processor,
>> 16 GB of RAM, and a SSD. I benchmarked using `silesia.tar` [3], which is
>> 211,988,480 B large. Run the following commands for the benchmark:
>> 
>>     sudo modprobe zstd_compress_test
>>     sudo mknod zstd_compress_test c 245 0
>>     sudo cp silesia.tar zstd_compress_test
>> 
>> The time is reported by the time of the userland `cp`.
>> The MB/s is computed with
>> 
>>     1,536,217,008 B / time(buffer size, hash)
>> 
>> which includes the time to copy from userland.
>> The Adjusted MB/s is computed with
>> 
>>     1,536,217,088 B / (time(buffer size, hash) - time(buffer size, none)).
>> 
>> The memory reported is the amount of memory the compressor requests.
>> 
>> | Method   | Size (B) | Time (s) | Ratio | MB/s    | Adj MB/s | Mem (MB) |
>> |----------|----------|----------|-------|---------|----------|----------|
>> | none     | 11988480 |    0.100 |     1 | 2119.88 |        - |        - |
>> | zstd -1  | 73645762 |    1.044 | 2.878 |  203.05 |   224.56 |     1.23 |
>> | zstd -3  | 66988878 |    1.761 | 3.165 |  120.38 |   127.63 |     2.47 |
>> | zstd -5  | 65001259 |    2.563 | 3.261 |   82.71 |    86.07 |     2.86 |
>> | zstd -10 | 60165346 |   13.242 | 3.523 |   16.01 |    16.13 |    13.22 |
>> | zstd -15 | 58009756 |   47.601 | 3.654 |    4.45 |     4.46 |    21.61 |
>> | zstd -19 | 54014593 |  102.835 | 3.925 |    2.06 |     2.06 |    60.15 |
>> | zlib -1  | 77260026 |    2.895 | 2.744 |   73.23 |    75.85 |     0.27 |
>> | zlib -3  | 72972206 |    4.116 | 2.905 |   51.50 |    52.79 |     0.27 |
>> | zlib -6  | 68190360 |    9.633 | 3.109 |   22.01 |    22.24 |     0.27 |
>> | zlib -9  | 67613382 |   22.554 | 3.135 |    9.40 |     9.44 |     0.27 |
>> 
> 
> Theses benchmarks are misleading because they compress the whole file as a
> single stream without resetting the dictionary, which isn't how data will
> typically be compressed in kernel mode.  With filesystem compression the data
> has to be divided into small chunks that can each be decompressed independently.
> That eliminates one of the primary advantages of Zstandard (support for large
> dictionary sizes).

This benchmark isn't meant to be representative of a filesystem scenario. I
wanted to show off zstd without anything else going on. Even in filesystems
where the data is chunked, zstd uses the whole chunk as the window (128 KB
in BtrFS and SquashFS by default), where zlib uses 32 KB. I have benchmarks
for BtrFS and SquashFS in their respective patches [4][5], and I've copied
the BtrFS table below (which was run with 2 threads).

| Method  | Ratio | Compression MB/s | Decompression speed |
|---------|-------|------------------|---------------------|
| None    |  0.99 |              504 |                 686 |
| lzo     |  1.66 |              398 |                 442 |
| zlib    |  2.58 |               65 |                 241 |
| zstd 1  |  2.57 |              260 |                 383 |
| zstd 3  |  2.71 |              174 |                 408 |
| zstd 6  |  2.87 |               70 |                 398 |
| zstd 9  |  2.92 |               43 |                 406 |
| zstd 12 |  2.93 |               21 |                 408 |
| zstd 15 |  3.01 |               11 |                 354 |

> 
> Eric
> 

[1] https://github.com/facebook/zstd/blob/dev/contrib/linux-kernel/lib/zstd/.clang-format
[2] https://github.com/terrelln/zstd/tree/original-formatted/contrib/linux-kernel/original-formatted
[3] https://github.com/facebook/zstd/commit/b1c6bb87022404da56cc3015c85494c0ffcec520
[4] https://lkml.kernel.org/r/20170810023902.3231324-1-terrelln@fb.com
[5] https://lkml.kernel.org/r/20170810024236.3243941-1-terrelln@fb.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
