Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34350 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQVxJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 17:53:09 -0400
Received: by mail-oi0-f65.google.com with SMTP id v11so7686609oif.1
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 14:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170729133655.31260-1-nefelim4ag@gmail.com>
References: <20170729133655.31260-1-nefelim4ag@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 18 Aug 2017 00:52:27 +0300
Message-ID: <CAGqmi772TYJ0P7F3gmN-GfXhv1=cRpgKJUFKUfv9JN0VGoKiBg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Btrfs: populate heuristic with detection logic
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-07-29 16:36 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Based on kdave for-next
> As heuristic skeleton already merged
> Populate heuristic with basic code.
>
> First patch: add simple sampling code
> It's get 16 byte samples with 256 bytes shifts
> over input data. Collect info about how many
> different bytes (symbols) has been found in sample data
>
> Second patch: add code for calculate
> how many unique bytes has been
> found in sample data
> That can fast detect easy compressible data
>
> Third patch: add code for calculate byte core set size
> i.e. how many unique bytes use 90% of sample data
> That code require that numbers in bucket must be sorted
> That can detect easy compressible data with many repeated bytes
> That can detect not compressible data with evenly distributed bytes
>
> Changes v1 -> v2:
>   - Change input data iterator shift 512 -> 256
>   - Replace magic macro numbers with direct values
>   - Drop useless symbol population in bucket
>     as no one care about where and what symbol stored
>     in bucket at now
>
> Changes v2 -> v3 (only update #3 patch):
>   - Fix u64 division problem by use u32 for input_size
>   - Fix input size calculation start - end -> end - start
>   - Add missing sort.h header
>
> Timofey Titovets (3):
>   Btrfs: heuristic add simple sampling logic
>   Btrfs: heuristic add byte set calculation
>   Btrfs: heuristic add byte core set calculation
>
>  fs/btrfs/compression.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/compression.h |  13 ++++++
>  2 files changed, 120 insertions(+), 2 deletions(-)
>
> --
> 2.13.3

Hi, may be any thoughts on that patches? (i know you are busy)

---
small offtop:
I think that in future that will change:
from:
struct heuristic_bucket_item {
        u8  padding;
        u8  symbol;
        u16 count;
};

To:
struct heuristic_bucket_item {
        u32  symbol;
        u32 count;
};

This will cause some memory overhead (1024b -> 2048b (768b useless))
But that allow support *big* samples
At now max sample size 2^16-1b and heuristic usable only over 4KiB <->
1MiB-256b range (thats of course enough for 128KiB btrfs compression
window).
And that needed for aligned memory access =\
(if that needed at now of course)

Also, may be heuristic must use btrfs_compression workspaces?
I of course can't imagine performance difference on find_workspace()
vs kcalloc(), and heuristic safe to fail on memory allocation.
IMHO for using compression workspace (if i understand code correctly)
Heuristic code must move to external file (heuristic.c?) to correctly
avoid name clashes with struct workspace & etc
And may be for avoid code misunderstanding name refactoring of
workspace code needed,
because that created for compression workspaces and heuristic itself
is not compression

Thanks!

-- 
Have a nice day,
Timofey.
