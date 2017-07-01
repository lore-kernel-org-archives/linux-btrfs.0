Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35784 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751877AbdGAQ4P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Jul 2017 12:56:15 -0400
Received: by mail-wm0-f48.google.com with SMTP id w126so134101300wme.0
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Jul 2017 09:56:14 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH v4 0/2] Btrfs: add compression heuristic
Date: Sat,  1 Jul 2017 19:56:00 +0300
Message-Id: <20170701165602.31189-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today btrfs use simple logic to make decision
compress data or not:
Selected compression algorithm try compress
data and if this save some space
store that extent as compressed.

It's Reliable way to detect uncompressible data
but it's will waste/burn cpu time for
bad/un-compressible data and add latency.

This way also add additional pressure on
memory subsystem as for every compressed write
btrfs need to allocate pages and
reuse compression workspace.

This is quite efficient, but not free.

So let's implement heuristic.
Heuristic will analize data on the fly
before call of compression code,
detect uncompressible data and advice to skip it.

Several levels needed for detect data type ASAP.

I leave comments with description in code,
but i also will try describe that logic short.
Heuristic have several internal steps:
1. Get sample data - this is cpu expensive
   to analize whole stream, so let's get some
   big enough sample from input data
   Scaling:
   In data: 128K  64K   32K   4K
   Sample:  4096b 3072b 2048b 1024b

2. For performance reason and for reuse it in 8th level
   copy selected data to sample buffer

3. Check if all bytes in sample are zeroed
   (Detect zeroed blocks, if yes return)

4. Count every byte type in sample buffer

5. Count how many types of bytes we find
   If it's not many - data will be easy compressible

6. Count character core set size, i.e.
   which characters use 90% of input stream
   If core set small (1-50 different types)
   Data easy compressible
   If big (200-256) - data probably can't be compressed

7. If above methods are fail to make decision,
   try compute shannon entropy
   If entropy are small - data will be easy compressible
   If not - go to 7th

8. Entropy can't detect repeated strings of bytes
   So try look at the data for detect repeated bytes
   Compute a difference between frequency of bytes from
   coreset and between frequency of pair of that bytes
   If sum of that different from zero and entropy not
   big, give compression code a try
   If entropy are High 7.2/8 - 8/8 (> 90%), and if we find BIG enough
   difference between frequency of a pairs and characters
   Give compression code a try

   8th level needed for decreasing false negative returns,
   where data can be compressed (like ~131072b -> ~87000b ~ 0.66),
   but not so easy.

That code, as i see, forbidden compression like:
- 131072b -> ~110000b
If compression ratio are better, it's allow that.

Shannon entropy use log2(a/b) function,
I did a try replace that with int_log2(a)-int_log2(b), but
integer realization of log2 show a lack of accuracy (+-7-10%) in our case.
So i precalculate some input/output values (1/131072 - 1/1) and create log2_lshift16();
I already decrease lines of that function from 1200 -> 200
for save memory (and lose some accuracy), so with precomputed function
I get +- 0.5-2% of accuracy (in compare to normal "true" float log2 shannon)
--
Patches based on latest mainline: v4.12-rc7

Stability:
I've made some tests with compiling kernel/copy data
to partition with enabled compression with that patch.
And didn't find any stability issues.

Performance:
In theory (by userspace tests, mmaped file, 128KiB blocks)
Code can detect data type at speed (for i5-4200M && DDR3):
  random   Text    Zeroes
  ~4GiB/s  ~8GiB/s ~18 GiB/s
On kernel side,
At now i just can't do some reliable tests

Tuning:
In theory this code can be tuned for zlib/lzo compression
Or return decision with additional info
Because for some data, where heuristic say
That can't be compressed, zlib show small compression
lzo can't compress that data

I've also duplicate patch set to:
https://github.com/Nefelim4ag/linux/tree/master

log2_lshift() - tested by log2_generator
https://github.com/Nefelim4ag/Entropy_Calculation

Thanks.
--
Changes:
v1 -> v2:
  - Fixes of checkpatch.pl warnings/errors
  - Use div64_u64() instead of "/"
  - Make log2_lshift16() more like binary tree as suggested by:
    Adam Borowski <kilobyte@angband.pl>

v2 -> v3:
  - Fix page read address overflow in heuristic.c
  - Make "bucket" dynamically allocated, for fix warnings about big stack.
  - Small cleanups

v3 -> v4:
  - Split: btrfs_compress_heuristic() to simplify code
  - Drop BUG_ON(!page),
    this already checked in extent_range_clear_dirty_for_io()
  - Add zero detection
  - Add more macros for tuning
  - Fix several typos

Timofey Titovets (2):
  Btrfs: add precomputed log2()
  Btrfs: add heuristic method for make decision compress or not compress

 fs/btrfs/Makefile        |   2 +-
 fs/btrfs/heuristic.c     | 336 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/heuristic.h     |  14 ++
 fs/btrfs/inode.c         |  36 +++--
 fs/btrfs/log2_lshift16.c | 278 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/log2_lshift16.h |  11 ++
 6 files changed, 662 insertions(+), 15 deletions(-)
 create mode 100644 fs/btrfs/heuristic.c
 create mode 100644 fs/btrfs/heuristic.h
 create mode 100644 fs/btrfs/log2_lshift16.c
 create mode 100644 fs/btrfs/log2_lshift16.h

--
2.13.2
