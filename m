Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55851 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751238AbdIKTZQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 15:25:16 -0400
Subject: [GIT PULL v2] zstd support (lib, btrfs, squashfs, nocrypto)
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nick Terrell <terrelln@fb.com>,
        Phillip Lougher <phillip@squashfs.org.uk>, Sean Purcell <me@seanp.xyz>
CC: David Sterba <dsterba@suse.cz>
References: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
Message-ID: <459700c1-4fb9-1e66-bc9a-b2322119e8e4@fb.com>
Date: Mon, 11 Sep 2017 15:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <de155140-8773-1a78-2dab-1d722ede3dc1@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

Nick Terrell's patch series to add zstd support to the kernel has been
floating around for a while.  After talking with Dave Sterba, Herbert
and Phillip, we decided to send the whole thing in as one pull request.

Herbert had asked about the crypto patch when we discussed the pull, but
I didn't realize he really meant not-right-now.  I've rebased it out of
this branch, and none of the other patches depended on it.

I have things in my zstd-minimal branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git zstd-minimal

There's a trivial conflict with the main btrfs pull from last week.
Dave's pull deletes BTRFS_COMPRESS_LAST in fs/btrfs/compression.h, and
I've put the sample resolution in a branch named zstd-4.14-merge.

zstd is a big win in speed over zlib and in compression ratio over lzo,
and the compression team here at FB has gotten great results using it in
production.  Nick will continue to update the kernel side with new
improvements from the open source zstd userland code.

Nick has a number of benchmarks for the main zstd code in his lib/zstd
commit:

============
I ran the benchmarks on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM.
The VM is running on a MacBook Pro with a 3.1 GHz Intel Core i7 processor,
16 GB of RAM, and a SSD. I benchmarked using `silesia.tar` [3], which is
211,988,480 B large. Run the following commands for the benchmark:

    sudo modprobe zstd_compress_test
    sudo mknod zstd_compress_test c 245 0
    sudo cp silesia.tar zstd_compress_test

The time is reported by the time of the userland `cp`.
The MB/s is computed with

    1,536,217,008 B / time(buffer size, hash)

which includes the time to copy from userland.
The Adjusted MB/s is computed with

    1,536,217,088 B / (time(buffer size, hash) - time(buffer size, none)).

The memory reported is the amount of memory the compressor requests.

| Method   | Size (B) | Time (s) | Ratio | MB/s    | Adj MB/s | Mem (MB) |
|----------|----------|----------|-------|---------|----------|----------|
| none     | 11988480 |    0.100 |     1 | 2119.88 |        - |        - |
| zstd -1  | 73645762 |    1.044 | 2.878 |  203.05 |   224.56 |     1.23 |
| zstd -3  | 66988878 |    1.761 | 3.165 |  120.38 |   127.63 |     2.47 |
| zstd -5  | 65001259 |    2.563 | 3.261 |   82.71 |    86.07 |     2.86 |
| zstd -10 | 60165346 |   13.242 | 3.523 |   16.01 |    16.13 |    13.22 |
| zstd -15 | 58009756 |   47.601 | 3.654 |    4.45 |     4.46 |    21.61 |
| zstd -19 | 54014593 |  102.835 | 3.925 |    2.06 |     2.06 |    60.15 |
| zlib -1  | 77260026 |    2.895 | 2.744 |   73.23 |    75.85 |     0.27 |
| zlib -3  | 72972206 |    4.116 | 2.905 |   51.50 |    52.79 |     0.27 |
| zlib -6  | 68190360 |    9.633 | 3.109 |   22.01 |    22.24 |     0.27 |
| zlib -9  | 67613382 |   22.554 | 3.135 |    9.40 |     9.44 |     0.27 |

I benchmarked zstd decompression using the same method on the same machine.
The benchmark file is located in the upstream zstd repo under
`contrib/linux-kernel/zstd_decompress_test.c` [4]. The memory reported is
the amount of memory required to decompress data compressed with the given
compression level. If you know the maximum size of your input, you can
reduce the memory usage of decompression irrespective of the compression
level.

| Method   | Time (s) | MB/s    | Adjusted MB/s | Memory (MB) |
|----------|----------|---------|---------------|-------------|
| none     |    0.025 | 8479.54 |             - |           - |
| zstd -1  |    0.358 |  592.15 |        636.60 |        0.84 |
| zstd -3  |    0.396 |  535.32 |        571.40 |        1.46 |
| zstd -5  |    0.396 |  535.32 |        571.40 |        1.46 |
| zstd -10 |    0.374 |  566.81 |        607.42 |        2.51 |
| zstd -15 |    0.379 |  559.34 |        598.84 |        4.61 |
| zstd -19 |    0.412 |  514.54 |        547.77 |        8.80 |
| zlib -1  |    0.940 |  225.52 |        231.68 |        0.04 |
| zlib -3  |    0.883 |  240.08 |        247.07 |        0.04 |
| zlib -6  |    0.844 |  251.17 |        258.84 |        0.04 |
| zlib -9  |    0.837 |  253.27 |        287.64 |        0.04 |

=======================

I ran a long series of tests and benchmarks on the btrfs side and
the gains are very similar to the core benchmarks Nick ran.

Nick Terrell (3) commits (+14222/-12):
    btrfs: Add zstd support (+468/-12)
    lib: Add zstd modules (+13014/-0)
    lib: Add xxhash module (+740/-0)

Sean Purcell (1) commits (+178/-0):
    squashfs: Add zstd support

Total: (4) commits (+14400/-12)

 fs/btrfs/Kconfig           |    2 +
 fs/btrfs/Makefile          |    2 +-
 fs/btrfs/compression.c     |    1 +
 fs/btrfs/compression.h     |    6 +-
 fs/btrfs/ctree.h           |    1 +
 fs/btrfs/disk-io.c         |    2 +
 fs/btrfs/ioctl.c           |    6 +-
 fs/btrfs/props.c           |    6 +
 fs/btrfs/super.c           |   12 +-
 fs/btrfs/sysfs.c           |    2 +
 fs/btrfs/zstd.c            |  432 ++++++
 fs/squashfs/Kconfig        |   14 +
 fs/squashfs/Makefile       |    1 +
 fs/squashfs/decompressor.c |    7 +
 fs/squashfs/decompressor.h |    4 +
 fs/squashfs/squashfs_fs.h  |    1 +
 fs/squashfs/zstd_wrapper.c |  151 ++
 include/linux/xxhash.h     |  236 +++
 include/linux/zstd.h       | 1157 +++++++++++++++
 include/uapi/linux/btrfs.h |    8 +-
 lib/Kconfig                |   11 +
 lib/Makefile               |    3 +
 lib/xxhash.c               |  500 +++++++
 lib/zstd/Makefile          |   18 +
 lib/zstd/bitstream.h       |  374 +++++
 lib/zstd/compress.c        | 3484 ++++++++++++++++++++++++++++++++++++++++++++
 lib/zstd/decompress.c      | 2528 ++++++++++++++++++++++++++++++++
 lib/zstd/entropy_common.c  |  243 +++
 lib/zstd/error_private.h   |   53 +
 lib/zstd/fse.h             |  575 ++++++++
 lib/zstd/fse_compress.c    |  795 ++++++++++
 lib/zstd/fse_decompress.c  |  332 +++++
 lib/zstd/huf.h             |  212 +++
 lib/zstd/huf_compress.c    |  770 ++++++++++
 lib/zstd/huf_decompress.c  |  960 ++++++++++++
 lib/zstd/mem.h             |  151 ++
 lib/zstd/zstd_common.c     |   75 +
 lib/zstd/zstd_internal.h   |  263 ++++
 lib/zstd/zstd_opt.h        | 1014 +++++++++++++
 39 files changed, 14400 insertions(+), 12 deletions(-)
