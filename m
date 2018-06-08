Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:48216 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbeFHEhV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jun 2018 00:37:21 -0400
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180606072717.28854-1-wqu@suse.com>
From: Steve Leung <sjleung@shaw.ca>
Message-ID: <d0ab3c91-3f19-49ee-165c-4dd11a74c4de@shaw.ca>
Date: Thu, 7 Jun 2018 22:37:16 -0600
MIME-Version: 1.0
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/06/2018 01:27 AM, Qu Wenruo wrote:
> The patchset can be fetched from github (*):
> https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes
> 
> It's based on David's devel branch, whose HEAD is:
> commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
> Author: Matthias Benkard <matthias.benkard@egym.de>
> Date:   Wed Apr 25 16:34:54 2018 +0200
> 
>      btrfs-progs: mkfs: traverse_directory: Reset error code on continue
> 
> Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
> offending inodes are from 2014) has inline uncompressed extent, while
> its ram_bytes mismatch with item size.

Took a while to run, but:

Tested-by: Steve Leung <sjleung@shaw.ca>

Verifying everything against backups now, but things look good so far.

I'm not 100% sure how to interpret the "btrfs check" output, but it 
sounded like it was going over each subvolume.  And since the corruption 
was referenced by many subvolumes, the same work essentially had to be 
duplicated many times.

Is that a correct assessment?  Would it have saved time to remove a 
bunch of snapshots first before doing "btrfs check"?

Either way, many thanks for getting everything going again!

Steve


> Latest kernel tree check catches this bug, while we failed to detect by
> dump-tree.
> 
> It turns out that btrfs-progs is doing something evil to avoid reading
> ram_bytes from inline uncompressed extent.
> 
> 
> So this patchset will address all such ram_bytes related problems.
> 
> The 1st patch is a not-so-relative fix for restore, which is using
> ram_bytes for decompress. Although thanks to the compression header, we
> won't read out-of-boundary, but fixing it is never a bad thing.
> 
> The 2nd patch will get rid of the evil btrfs_file_extent_inline_len()
> which hides raw ram_bytes from us, and fooling us for a long long time.
> 
> The 3rd~5th patches introduce check/repair function for both original
> and lowmem mode (although lowmem mode can detect it even before this patch).
> 
> The last one is the test case for it as usual.
> 
> *: Or should I just migrate to gitlab after M$ acquired github?
> 
> Qu Wenruo (6):
>    btrfs-progs: restore: Fix wrong compressed item size for decompress()
>    btrfs-progs: Get rid of the confusing btrfs_file_extent_inline_len()
>    btrfs-progs: check/original: Detect and repair wrong inline ram_bytes
>    btrfs-progs: check/lowmem: Prepare check_file_extent() to handle
>      repair
>    btrfs-progs: check/lowmem: Repair wrong inlien ram_bytes for
>      uncompressed extent
>    btrfs-progs: fsck-tests: Add test case for corrupted inline ram_bytes
> 
>   check/main.c                                  |  46 ++++++-
>   check/mode-lowmem.c                           | 120 ++++++++++++++----
>   check/mode-original.h                         |   1 +
>   cmds-restore.c                                |   5 +-
>   ctree.h                                       |  22 ----
>   file.c                                        |   3 +-
>   print-tree.c                                  |   4 +-
>   .../offset_by_one.img                         | Bin 0 -> 3072 bytes
>   .../035-inline-bad-ram-bytes/test.sh          |  11 ++
>   9 files changed, 157 insertions(+), 55 deletions(-)
>   create mode 100644 tests/fsck-tests/035-inline-bad-ram-bytes/offset_by_one.img
>   create mode 100755 tests/fsck-tests/035-inline-bad-ram-bytes/test.sh
> 

