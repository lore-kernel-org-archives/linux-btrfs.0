Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031346AbeCAOzr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Mar 2018 09:55:47 -0500
Date: Thu, 1 Mar 2018 15:53:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, peteryuchuang@gmail.com
Subject: Re: [PATCH 0/4] Fix long standing -EOPNOTSUPP problem caused by
Message-ID: <20180301145328.GB4817@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180301024747.26192-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180301024747.26192-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2018 at 10:47:43AM +0800, Qu Wenruo wrote:
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
> The bug exists from the very beginning of btrfs-convert, dating back to
> 2008 when btrfs-convert is first introduced.
> 
> Qu Wenruo (4):
>   btrfs-progs: Limit inline extent below page size
>   btrfs-progs: check/original mode: Check inline extent size
>   btrfs-progs: check/lowmem mode: Check inline extent size
>   btrfs-progs: test/convert: Add test case for invalid large inline data
>     extent

Thanks, added to devel. Fixes will be added to 4.15.2.
