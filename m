Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50252 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbeIKU6C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:58:02 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2EE7FAED5
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 15:58:05 +0000 (UTC)
Date: Tue, 11 Sep 2018 17:58:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] btrfs-progs: Detect compressed extent without csum
Message-ID: <20180911155803.GF2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180514065444.26313-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180514065444.26313-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 02:54:41PM +0800, Qu Wenruo wrote:
> Patches can be fetch from github:
> https://github.com/adam900710/btrfs-progs/tree/compress_nodatasum
> 
> It's based on v4.16 stable branch.
> 
> James Harvey from mail list reports a strange kernel panic, whichs show
> obviously kernel memory corruption, while after btrfs decompression
> failure.
> 
> It turns out that, some compressed extent get corrupted on-disk, while
> the inode has NODATASUM set, there is no csum to prevent corrupted
> mirror being used.
> 
> Although the root cause should be buggy lzo implementation, it still
> shows that btrfs is not following the behavior defined in btrfs(5):
> 
>      Note
>      If nodatacow or nodatasum are enabled, compression is disabled.
> 
> So at least make btrfs check to detect such problem.
> 
> Qu Wenruo (3):
>   btrfs-progs: check/lowmem: Add checks for compressed extent without
>     csum
>   btrfs-progs: check/original: Add checks for compressed extent without
>     csum
>   btrfs-progs: fsck-tests: Add test case for detecting compressed extent
>     without csum

Sorry for late reply, can you please refresh the patches on top of a
more recent progs? Thanks.
