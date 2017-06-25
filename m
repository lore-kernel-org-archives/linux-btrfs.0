Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33625 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdFYVCV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Jun 2017 17:02:21 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so26437842wrb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 25 Jun 2017 14:02:20 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [RFC PATCH 0/2] Btrfs: add compression heuristic
Date: Mon, 26 Jun 2017 00:02:08 +0300
Message-Id: <20170625210210.24383-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Today btrfs use simple logic to make decision
compress data or not:
Selected compression
algorithm try compress data and if this save some space
store that extent as compressed.

It's Reliable way to detect uncompressible data
but it's will waste/burn cpu time for
bad/un-compressible data and add latency.

This way also add additional pressure on
memory subsustem as for every compressed write
btrfs need to allocate some buffered pages and
reuse compression workspace.

This is quite efficient, but not free.

So, try create basic heuristic framework,
this heuristic code will analizy data on the fly
before call of compression code,
can detect uncompressible data and advice to skip it.

I leave comments with description in code,
but i will try describe that short.
Heuristic have several internal layers:
1. Get sample data - this is cpu expensive
to analize whole stream, so let's get some
big enough sample from input data
Scaling:
In data: 128K  64K   32K   4K
Sample:  4096b 3072b 2048b 1024b
2. For performance reason and for reuse it in 7th level
copy selected data to sample buffer
3. Count every byte type in sample buffer
4. Count how many types of bytes we find
If it's not many - data will be easy compressible
5. Count character core set size, i.e.
which characters use 90% of input stream
If core set small (1-50 different types)
Data easy compressible
If big (200-256) - data probably can't be compressed
6. If above methods are fail to make decision,
try compute shannon entropy
If entropy are small - data will be easy compressible
If not - go to 7th
7. Entropy can't detect repeated strings of bytes
So try look at the data for detect repeated bytes
Compute a difference between frequency of bytes from
coreset and between frequency of pair of that bytes
If sum of that defferent from zero and entropy and not
big, give compression code a try
If entropy are High 7.2/8 - 8/8 (> 90%), and if we find BIG enough
difference between frequency of a pairs and characters
Give compression code a try

7th level needed for decreasing false negative returns,
where data can be compressed, (~131072b -> ~87000b), but not
so easy.

(this above code as i see it's forbidden compression like:
131072b -> ~110000b)

Shannon entropy use log2(a/b) function,
i try before replace that with int_log2(a)-int_log2(b), but
integer realization of log2  show a lack of accuracy (+-7-10%) in our case.
So i precalculate some input/output values (1/131072 - 1/1) and create log2_lshift16();
I already decrease lines of that function from 1200 -> 200 for save memory (and lose some accuracy), so with precomputed function
i get +- 0.5-2% of accuracy (in compare to normal "true" float log2 shannon)

Thanks.

P.S.
I made only stability tests at now, all works stable.
For userspace realization of that algorithm, which
iterate over data by 128kb block and read it by Mmap()
show ~4GiB/s over in memory (cached) data in one stream.
For i5-4200M && DDR3.

So i expect to not hurt compression performance.

P.S.S.
Sorry for my bad english and may be for ugly code.
I do my best, thanks.

Timofey Titovets (2):
  Btrfs: add precomputed log2()
  Btrfs: add heuristic method for make decision compress or not compress

 fs/btrfs/Makefile        |   2 +-
 fs/btrfs/heuristic.c     | 258 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/heuristic.h     |  13 +++
 fs/btrfs/inode.c         |  47 +++++----
 fs/btrfs/log2_lshift16.c | 232 ++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/log2_lshift16.h |  10 ++
 6 files changed, 542 insertions(+), 20 deletions(-)
 create mode 100644 fs/btrfs/heuristic.c
 create mode 100644 fs/btrfs/heuristic.h
 create mode 100644 fs/btrfs/log2_lshift16.c
 create mode 100644 fs/btrfs/log2_lshift16.h

--
2.13.1
