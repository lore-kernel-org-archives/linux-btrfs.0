Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33205 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdF3SZt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 14:25:49 -0400
Received: by mail-io0-f195.google.com with SMTP id z62so3680670ioi.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Jun 2017 11:25:48 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] btrfs: Add zstd support
To: dsterba@suse.cz, E V <eliventer@gmail.com>, Nick Terrell <terrelln@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20170629194108.1674498-1-terrelln@fb.com>
 <20170629194108.1674498-4-terrelln@fb.com>
 <CAJtFHUQvmnf7Ggawb4UDfoU8MK37q3rxiWdUmYJE8h1huQZfFQ@mail.gmail.com>
 <20170630142133.GU2866@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e66729e8-0256-745f-53d0-e89241ab524c@gmail.com>
Date: Fri, 30 Jun 2017 14:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <20170630142133.GU2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-30 10:21, David Sterba wrote:
> On Fri, Jun 30, 2017 at 08:16:20AM -0400, E V wrote:
>> On Thu, Jun 29, 2017 at 3:41 PM, Nick Terrell <terrelln@fb.com> wrote:
>>> Add zstd compression and decompression support to BtrFS. zstd at its
>>> fastest level compresses almost as well as zlib, while offering much
>>> faster compression and decompression, approaching lzo speeds.
>>>
>>> I benchmarked btrfs with zstd compression against no compression, lzo
>>> compression, and zlib compression. I benchmarked two scenarios. Copying
>>> a set of files to btrfs, and then reading the files. Copying a tarball
>>> to btrfs, extracting it to btrfs, and then reading the extracted files.
>>> After every operation, I call `sync` and include the sync time.
>>> Between every pair of operations I unmount and remount the filesystem
>>> to avoid caching. The benchmark files can be found in the upstream
>>> zstd source repository under
>>> `contrib/linux-kernel/{btrfs-benchmark.sh,btrfs-extract-benchmark.sh}`
>>> [1] [2].
>>>
>>> I ran the benchmarks on a Ubuntu 14.04 VM with 2 cores and 4 GiB of RAM.
>>> The VM is running on a MacBook Pro with a 3.1 GHz Intel Core i7 processor,
>>> 16 GB of RAM, and a SSD.
>>>
>>> The first compression benchmark is copying 10 copies of the unzipped
>>> Silesia corpus [3] into a BtrFS filesystem mounted with
>>> `-o compress-force=Method`. The decompression benchmark times how long
>>> it takes to `tar` all 10 copies into `/dev/null`. The compression ratio is
>>> measured by comparing the output of `df` and `du`. See the benchmark file
>>> [1] for details. I benchmarked multiple zstd compression levels, although
>>> the patch uses zstd level 1.
>>>
>>> | Method  | Ratio | Compression MB/s | Decompression speed |
>>> |---------|-------|------------------|---------------------|
>>> | None    |  0.99 |              504 |                 686 |
>>> | lzo     |  1.66 |              398 |                 442 |
>>> | zlib    |  2.58 |               65 |                 241 |
>>> | zstd 1  |  2.57 |              260 |                 383 |
>>> | zstd 3  |  2.71 |              174 |                 408 |
>>> | zstd 6  |  2.87 |               70 |                 398 |
>>> | zstd 9  |  2.92 |               43 |                 406 |
>>> | zstd 12 |  2.93 |               21 |                 408 |
>>> | zstd 15 |  3.01 |               11 |                 354 |
>>>
>>
>> As a user looking at this graph the zstd 3 seems like the sweet spot to me,
>> more then twice as fast as zlib with a bit better compression. Is this
>> going to be
>> configurable?
> 
> If we're going to make that configurable, there are some things to
> consider:
> 
> * the underlying compressed format -- does not change for different
>    levels
> 
> * the configuration interface -- mount options, defrag ioctl
> 
> * backward compatibility
There is also the fact of deciding what to use for the default when 
specified without a level.  This is easy for lzo and zlib, where we can 
just use the existing level, but for zstd we would need to decide how to 
handle a user just specifying 'zstd' without a level.  I agree with E V 
that level 3 appears to be the turnover point, and would suggest using 
that for the default.
> 
> For the mount option specification, sorted from the worst to best per my
> preference:
> 
> * new option, eg. clevel=%d or compress-level=%d
> * use existing options, extend the compression name
>    * compress=zlib3
>    * compress=zlib/3
>    * compress=zlib:3
I think it makes more sense to make the level part of the existing 
specification.  ZFS does things that way (although they use a - to 
separate the name from the level), and any arbitrary level does not mean 
the same thing across different algorithms (for example, level 15 means 
nothing for zlib, but is the highest level for zstd).
> 
> The defrag ioctl args have some reserved space for extension or we can
> abuse btrfs_ioctl_defrag_range_args::compress_type that's unnecessarily
> u32. Either way we don't need to introduce a new ioctl number and struct
> (which is good of course).
> 
> Regarding backward compatibility, older kernel would probably not
> recognize the extended spec format. We use strcmp, so the full name must
> match. Had we used strncmp, we could have compared just the prefix of
> known length and the level part would be ignored. A patch for that would
> not be intrusive and could be ported to older stable kernels, if there's
> enough user demand.
TBH, I would think that that's required if this is going to be 
implemented, but it may be tricky because 'lzo' and 'zlib' are not the 
same length.
> 
> So, I don't see any problem making the level configurable.
I would actually love to see this, I regularly make use of varying 
compression both on BTRFS (with separate filesystems) and on the 
ZFS-based NAS systems we have at work (where it can be set per-dataset) 
to allow better compression on less frequently accessed data.
