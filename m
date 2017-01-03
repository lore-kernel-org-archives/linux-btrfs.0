Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:33557 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935615AbdACTYr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 14:24:47 -0500
Received: by mail-yw0-f180.google.com with SMTP id r204so296972392ywb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 11:24:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 3 Jan 2017 20:24:36 +0100
Message-ID: <CAEtw4r2hU74Qfa_6X=y5hNQSq-yN9y=9wpAF7CjRgVP2p=ns-w@mail.gmail.com>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All invocations are justified, but not relevant in (offline) backup
and archive scenarios.

For example you have multiple version of append-only log-files or
append-only db-files (each more then 100GB in size), like this:

> Snapshot_01_01_2017
-> file1.log .. 201 GB

> Snapshot_02_01_2017
-> file1.log .. 205 GB

> Snapshot_03_01_2017
-> file1.log .. 221 GB

The first 201 GB would be every time the same.
Files a copied at night from windows, linux or bsd systems and
snapshoted after copy.

So a fast way to dedupe this is needed. Using 128KB blocks would
result in 1646592 extends per Snapshot. 1MB blocksize results in
205.824 extends (not bad, but still terrible speed).
I will test it at night with a patched version of duperemove with
100MB blocksize, but I have no hope that the throughput increases
thereby.

For backup and archive scenarios the checksum-feature and the
dub-data/metadata-feature of btrfs is realy nice. In particular if one
considers the 7 years legally prescribed storage time.

2017-01-03 13:40 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2016-12-30 15:28, Peter Becker wrote:
>>
>> Hello, i have a 8 TB volume with multiple files with hundreds of GB each.
>> I try to dedupe this because the first hundred GB of many files are
>> identical.
>> With 128KB blocksize with nofiemap and lookup-extends=no option, will
>> take more then a week (only dedupe, previously hashed). So i tryed -b
>> 100M but this returned me an error: "Blocksize is bounded ...".
>>
>> The reason is that the blocksize is limit to
>>
>> #define MAX_BLOCKSIZE (1024U*1024)
>>
>> But i can't found any description why.
>
> Beyond what Xin mentioned (namely that 1MB is a much larger block than will
> be duplicated in most data-sets), there are a couple of other reasons:
> 1. Smaller blocks will actually get you better deduplication on average
> because they're more likely to match.  As an example, assume you have 2
> files with the same 8 4k blocks in different orders:
>   FileA: 1 2 3 4 5 6 7 8
>   FileB: 7 8 5 6 3 4 1 2
> In such a case, deduplicating at any block size above 8k would result in
> zero deduplication between these files, while 8k or less would completely
> deduplicate them.  This is of course a highly specific and somewhat
> contrived example (in most cases it will be scattered duplicate blocks over
> dozens of files), but it does convey this specific point.
> 2. The kernel will do a byte-wise comparison of all ranges you pass into the
> ioctl at the same time.  Larger block sizes here mean that:
>         a) The extents will be locked longer, which will prevent any I/O to
> the files being deduplicated for the duration of the comparison, which may
> in turn cause other issues on the system.
>         b) The deduplication process will be stuck in uninterruptible sleep
> longer, which on many systems will trigger hung task detection, which will
> in turn either spam the system log or panic the system depending on how it's
> configured.
>
