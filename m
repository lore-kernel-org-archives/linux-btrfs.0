Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33327 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751899AbdF3MQV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 08:16:21 -0400
Received: by mail-ua0-f195.google.com with SMTP id w19so8600722uac.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 05:16:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170629194108.1674498-4-terrelln@fb.com>
References: <20170629194108.1674498-1-terrelln@fb.com> <20170629194108.1674498-4-terrelln@fb.com>
From: E V <eliventer@gmail.com>
Date: Fri, 30 Jun 2017 08:16:20 -0400
Message-ID: <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
To: Nick Terrell <terrelln@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 29, 2017 at 3:41 PM, Nick Terrell <terrelln@fb.com> wrote:
> Add zstd compression and decompression support to BtrFS. zstd at its
> fastest level compresses almost as well as zlib, while offering much
> faster compression and decompression, approaching lzo speeds.
>
> I benchmarked btrfs with zstd compression against no compression, lzo
> compression, and zlib compression. I benchmarked two scenarios. Copying
> a set of files to btrfs, and then reading the files. Copying a tarball
> to btrfs, extracting it to btrfs, and then reading the extracted files.
> After every operation, I call `sync` and include the sync time.
> Between every pair of operations I unmount and remount the filesystem
> to avoid caching. The benchmark files can be found in the upstream
> zstd source repository under
> `contrib/linux-kernel/{btrfs-benchmark.sh,btrfs-extract-benchmark.sh}`
> [1] [2].
>
> I ran the benchmarks on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM.
> The VM is running on a MacBook Pro with a 3.1 GHz Intel Core i7 processor,
> 16 GB of RAM, and a SSD.
>
> The first compression benchmark is copying 10 copies of the unzipped
> Silesia corpus [3] into a BtrFS filesystem mounted with
> `-o compress-force=Method`. The decompression benchmark times how long
> it takes to `tar` all 10 copies into `/dev/null`. The compression ratio is
> measured by comparing the output of `df` and `du`. See the benchmark file
> [1] for details. I benchmarked multiple zstd compression levels, although
> the patch uses zstd level 1.
>
> | Method  | Ratio | Compression MB/s | Decompression speed |
> |---------|-------|------------------|---------------------|
> | None    |  0.99 |              504 |                 686 |
> | lzo     |  1.66 |              398 |                 442 |
> | zlib    |  2.58 |               65 |                 241 |
> | zstd 1  |  2.57 |              260 |                 383 |
> | zstd 3  |  2.71 |              174 |                 408 |
> | zstd 6  |  2.87 |               70 |                 398 |
> | zstd 9  |  2.92 |               43 |                 406 |
> | zstd 12 |  2.93 |               21 |                 408 |
> | zstd 15 |  3.01 |               11 |                 354 |
>

As a user looking at this graph the zstd 3 seems like the sweet spot to me,
more then twice as fast as zlib with a bit better compression. Is this
going to be
configurable?
