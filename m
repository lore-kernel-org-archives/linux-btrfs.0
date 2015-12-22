Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41818 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbbLVCNE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 21:13:04 -0500
Date: Mon, 21 Dec 2015 21:13:03 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Btrfs bug fixes for 4.5
Message-ID: <20151222021303.GA51885@clm-mbp.thefacebook.com>
References: <1450720786-16839-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1450720786-16839-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 21, 2015 at 05:59:46PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> Please consider the following fixes for the 4.5 merge window.
> Nothing outstanding, they are just the usual bug fixes (races, deadlocks,
> error paths, etc). These were all sent previously to the mailing list and
> rebased last week against your integration-4.4 branch (since there isn't
> any 4.5 integration branch yet).

Thanks Filipe, I'll get these in.  I've been testing Omar's free space
cache pretty hard, but I'll put his stuff on top of everything else just
in case, and send out for -integration before xmas along with other
queued items.

-chris

> 
> Thanks.
> 
> The following changes since commit 1d3a5a82fe724c53c472a18a31fb0bbf33dfaba2:
> 
>   Merge branch 'for-chris-4.4' of git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux into for-linus-4.4 (2015-12-15 09:09:59 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.5
> 
> for you to fetch changes up to e44081ef611832b47a86abf4e36dc0ed2e950884:
> 
>   Btrfs: fix unprotected list operations at btrfs_write_dirty_block_groups (2015-12-21 17:51:22 +0000)
> 
> ----------------------------------------------------------------
> Filipe Manana (7):
>       Btrfs: fix race when finishing dev replace leading to transaction abort
>       Btrfs: fix memory leaks after transaction is aborted
>       Btrfs: fix error path when failing to submit bio for direct IO write
>       Btrfs: fix deadlock between direct IO write and defrag/readpages
>       Btrfs: fix leaking of ordered extents after direct IO write error
>       Btrfs: fix locking bugs when defragging leaves
>       Btrfs: fix unprotected list operations at btrfs_write_dirty_block_groups
> 
>  fs/btrfs/extent-tree.c |  19 +++++++++++++++++--
>  fs/btrfs/inode.c       | 127 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
>  fs/btrfs/transaction.c |  17 +++++++++++++++++
>  fs/btrfs/tree-defrag.c |  27 ++++++++++++++++++++++++---
>  fs/btrfs/volumes.c     |  17 +++++++++++++++--
>  5 files changed, 151 insertions(+), 56 deletions(-)
> 
> -- 
> 2.1.3
> 
