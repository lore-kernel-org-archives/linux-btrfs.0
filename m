Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40665 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754987AbeEAOFL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 May 2018 10:05:11 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BBAEBAB3E
        for <linux-btrfs@vger.kernel.org>; Tue,  1 May 2018 14:05:09 +0000 (UTC)
Date: Tue, 1 May 2018 16:02:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix delalloc inodes leaking on btrfs unmount
Message-ID: <20180501140234.GT21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1524820914-30864-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524820914-30864-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 12:21:49PM +0300, Nikolay Borisov wrote:
> After investigating crashes on generic/176 it turned that the culprit in fact
> is the random failure induced by generic/019. As it happens, if on unmount the 
> filesystem is in BTRFS_FS_STATE_ERROR then btrfs_error_commit_super is called. 
> This unveiled 2 bugs:
>  1. btrfs_destroy_delalloc_inodes's implementation was completely bogus, since
>  it only called btrfs_invalidate_inodes which only pruned dentries and didn't 
>  do anything to free any inodes with pending delalloc bytes. Once this is fixed 
>  with the use of invalide_inode_pages2 the second bug transpired. 
>  2. The last call ot run_delayed_iputs is made before btrfs_cleanup_transaction
>  is called. The latter in turn could queue up more delayed iputs resulting from 
>  invalidates_inode_pages2. 
> 
> This series fixes the problem by first fixing btrfs_destroy_delalloc_inode to 
> properly cleanup delalloc inodes and as a result cleans up the code a bit. 
> 
> I've given it a good bashing through xfstest (4 full xfstest cycles + 100 
> iterations of generic/475 since it was hitting some early assertion failures,
> which are fixed in the final version) so am pretty confident in the change. 

Thanks. I'll add it as topic branch to next, this needs some testing
exposure. The plan is to push the core patches to some rc, possibly rc5.

Review of patch 3 is required.
