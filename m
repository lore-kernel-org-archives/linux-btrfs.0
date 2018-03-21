Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58843 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751541AbeCUPxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 11:53:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2B9E1B036
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 15:53:40 +0000 (UTC)
Date: Wed, 21 Mar 2018 16:51:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 0/6] Fix long standing -EOPNOTSUPP problem caused by
 large inline extent
Message-ID: <20180321155115.GT6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180320064229.31493-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180320064229.31493-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 20, 2018 at 02:42:23PM +0800, Qu Wenruo wrote:
> The patch is based on v4.15.1, and is designed to replace the old patch
> in devel branch.
> 
> Kernel doesn't support dropping range inside inline extent, and prevents
> such thing happening by limiting max inline extent size to
> min(max_inline, sectorsize - 1) in cow_file_range_inline().
> 
> However btrfs-progs only inherit the BTRFS_MAX_INLINE_DATA_SIZE() macro,
> which doesn't have sectorsize check.
> And since btrfs-progs defaults to 16K nodesize, above macro allows large
> inline extent over 15K size.
> 
> This leads to unexpected kernel behavior.
> 
> The bug exists in several parts of btrfs-progs, any tool which creates
> file extent is involved, including:
> 1) btrfs-convert
> 2) mkfs --rootdir
> 
> This patchset fixes the problems in convert (both ext2 and reiserfs),
> mkfs --rootdir, then add check support for both original and lowmem
> mode, and finally adds 2 test cases, one for mkfs and one for convert.
> 
> For mkfs test case, it can already be exposed by misc/002, but a
> pin-point test case will be much better.
> 
> changelog:
> v2:
>   Don't modify BTRFS_MAX_INLINE_DATA_SIZE(), but add extra check to
>   callers who create file extents.
> v3:
>   Merge fixes for convert.
>   Add real commit message for convert fixes.
>   Use $TEST_TOP to replace cooperate with stand alone test cases.
>   Use for loops to make the new test case shorter.
> 
> Qu Wenruo (6):
>   btrfs-progs: convert: Fix inline file extent creation condition
>   btrfs-progs: mkfs/rootdir: Fix inline extent creation check
>   btrfs-progs: check/original mode: Check inline extent size
>   btrfs-progs: check/lowmem mode: Check inline extent size
>   btrfs-progs: test/convert: Add test case for invalid large inline data
>     extent
>   btrfs-progs: test/mkfs: Add test case for rootdir inline extent size

Applied, thanks. I had to fix the test, fallocate may fail, so a file of
given size is created directly.

I hope this bug is fixed. My plan was to release 4.15.2 with just
bugfixes but as this took some time to fix, there likely will be no
minor release before 4.16 as kernel is about to be released next week.
