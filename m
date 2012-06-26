Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:59520 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab2FZNmO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 09:42:14 -0400
Date: Tue, 26 Jun 2012 09:42:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dave@jikos.cz>
CC: Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: [PATCH] Btrfs: check return value of btrfs_set_extent_delalloc()
Message-ID: <20120626134211.GC2046@localhost.localdomain>
References: <201206260322.AA00002@FM-323941448.jp.fujitsu.com>
 <20120626132653.GS28144@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120626132653.GS28144@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 07:26:53AM -0600, David Sterba wrote:
> On Tue, Jun 26, 2012 at 12:22:10PM +0900, Tsutomu Itoh wrote:
> > btrfs_set_extent_delalloc() has the possibility of returning the error.
> > So I add the code in which the return value of btrfs_set_extent_delalloc()
> > is checked.
> 
> The caller is cluster_pages_for_defrag, the only error I see returned
> via __set_extent_bit is -EEXIST, other errors BUG directly or via
> extent_io_tree_panic() .
> 
> If the error happens, then the [page_start,page_end-1] is already set
> for delalloc, that's probably a bug and should be caught.
> 
> There are two more unchecked calls to btrfs_set_extent_delalloc:
> 
> inode.c:btrfs_writepage_fixup_worker
> 
> 1729         btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
> 1730         ClearPageChecked(page);
> 1731         set_page_dirty(page);
> 
> IIRC from the days full of fixup worker fun, the reason why this is safe
> to ignore is because the call chain leading here is exactly due to missing
> delalloc bits on the page.
> 
> relocation.c:relocate_file_extent_cluster
> 
> 3034                 btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
> 3035                 set_page_dirty(page);
> 
> hmm relocation ... :)
> 
> 
> Anyway, I'd like to let Josef take another look at your patch.
>

Even better, we clear delalloc right before doing the set and we have the pages
locked, so theres no way we can get EEXIST here, so I'll just drop this patch.
Thanks Dave,

Josef 
