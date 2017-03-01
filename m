Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751102AbdCAQnm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 11:43:42 -0500
Date: Wed, 1 Mar 2017 17:30:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/12] lowmem mode fixes
Message-ID: <20170301163025.GI4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 21, 2017 at 04:34:26PM +0800, Qu Wenruo wrote:
> Patches can be fetch from github:
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes
> 
> Thanks for reports from Chris Murphy and Christoph Anton Mitterer,
> several new bugs are exposed for lowmem mode fsck.
> 
> Special thank to Christoph, who did rounds of test during the patch
> development.
> 
> The following bugs are fixed in lowmem mode:
> 
> 1) Block group used space false alert
>    If a BLOCK_GROUP_ITEM or its first EXTENT/METADATA_ITEM is located at
>    the first slot of a leaf, search_slot() used by lowmem mode can
>    point to previous leaf, with path->slots[0] beyond valid leaf slots.
> 
>    This makes us to read out uninitialized data, and can abort block
>    group used space check loop, causing a false alert.
> 
>    Fix it with a test case image inside fsck-tests/020/extent-ref-cases
>    Also fix all possible backward search.
>    Reported by Christoph.
> 
> 2) Partly written prealloc extent false alert
>    If a prealloc extent gets partily written, lowmem mode will report
>    prealloc extent shouldn't have csum.
> 
>    Lowmem mode passed wrong variable to csum checking code, causing it
>    to check the whole range of the prealloc extent, making the bug
>    happens.
> 
>    Fix it with a test case inside fsck-tests/020/extent-ref-cases.
>    Reported by Chirs Murphy And Christoph.
> 
> 3) Extent item size false alert.
>    Under certain case, btrfs lowmem mode check reports data backref
>    lost.
>    It's because newly introduced extent item size check aborts normal
>    check routine.
> 
>    It can happen if a data/metadata extent item has no inline ref.
> 
>    Fix it, test case already submitted before and merged, but due to
>    fsck-tests framework bugs, it never get called for lowmem mode.
> 
> 4) Compressed inline data extent
>    The extra check on inline data extent length doesn't take compression
>    into consideration and will cause false alert without outputting any
>    error message.
> 
>    Fix it and add correct error message output for it.
>    Also fix all possible silent error.
>    Reported by Christoph.
> 
> 5) fsck-tests Lowmem mode override fixes
>    Allow lowmem mode override to get called for all tests, and allow
>    them all to pass lowmem mode except fsck-tests/006, which is a
>    original repair mode bug.
> 
> 
> changelog:
>   v2:
>     More generic forward search bug fix, not restricted to block group
>     item.
>     Compressed inline extent false alert fix.
>     Lowmem fsck-test enhance, to allow it really work.
>     Fix walk_down_tree_v2() to continue after non-fatal errors detected
>   v3:
>     Update the last patch to make it works better for incoming lowmem
>     mode repair patchset.

Thanks for the fixes, applied with a few minor fixups in changelogs.
