Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45765 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752945AbeC1O6J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 10:58:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF7D8B02E
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Mar 2018 14:58:08 +0000 (UTC)
Date: Wed, 28 Mar 2018 16:55:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs/rootdir: Don't follow symbolic link
 when calcuating size
Message-ID: <20180328145542.GM30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180328063909.937-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180328063909.937-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2018 at 02:39:09PM +0800, Qu Wenruo wrote:
> [BUG]
> If we have a symbolic link in rootdir pointing to non-existing location,
> mkfs.btrfs --rootdir will just fail:
> ------
> $ mkfs.btrfs  -f --rootdir /tmp/rootdir/ /dev/data/btrfs
> btrfs-progs v4.15.1
> See http://btrfs.wiki.kernel.org for more information.
> 
> ERROR: ftw subdir walk of /tmp/rootdir/ failed: No such file or directory
> ------
> 
> [CAUSE]
> Commit 599a0abed564 ("btrfs-progs: mkfs/rootdir: Use over-reserve method
> to make size estimate easier") add extra ftw walk to estimate the
> filesystem size.
> 
> Such default ftw walk will follow symbolic link and gives ENOENT error.
> 
> [FIX]
> Use nftw() to specify FTW_PHYS so we won't follow symbolic link for size
> calculation.
> 
> Reported-by: Alexander Kanavin <alexander.kanavin@intel.com>
> Fixes: 599a0abed564 ("btrfs-progs: mkfs/rootdir: Use over-reserve method to make size estimate easier")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Applied, thanks. Can you please write a testcase for that?
