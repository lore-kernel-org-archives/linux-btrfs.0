Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41040 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753342AbeGBXZg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 19:25:36 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 496D6ADDF
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 23:25:35 +0000 (UTC)
Date: Tue, 3 Jul 2018 01:25:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] btrfs-progs: Fixes inline ram_bytes related bugs
Message-ID: <20180702232529.GI3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180606072717.28854-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180606072717.28854-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 06, 2018 at 03:27:11PM +0800, Qu Wenruo wrote:
> The patchset can be fetched from github (*):
> https://github.com/adam900710/btrfs-progs/tree/inline_ram_bytes
> 
> It's based on David's devel branch, whose HEAD is:
> commit 0d1c5812e28e286648781c7b35b542311cc01aa4 (david/devel)
> Author: Matthias Benkard <matthias.benkard@egym.de>
> Date:   Wed Apr 25 16:34:54 2018 +0200
> 
>     btrfs-progs: mkfs: traverse_directory: Reset error code on continue
> 
> Reported-by Steve Leung <sjleung@shaw.ca>, his old btrfs (at least
> offending inodes are from 2014) has inline uncompressed extent, while
> its ram_bytes mismatch with item size.
> 
> Latest kernel tree check catches this bug, while we failed to detect by
> dump-tree.
> 
> It turns out that btrfs-progs is doing something evil to avoid reading
> ram_bytes from inline uncompressed extent.
> 
> 
> So this patchset will address all such ram_bytes related problems.

Thanks, series applied.

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

About that, I have a gitlab account and auto-synced the btrfs-progs
repository from github, so I guess it can be used to fork the code.  The
issues are disabled, that's kind of tied to github, but mail bugreports
work and I think technically we don't have to stick to just one issue
tracker though it's a bit of work on our side to update the status if
the reports are duplicated.
