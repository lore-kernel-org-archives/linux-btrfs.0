Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155AbaKUQPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:12 -0500
Date: Fri, 21 Nov 2014 17:15:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: danieru.dressler@gmail.c, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: disk-io: replace root args iff only fs_info used
Message-ID: <20141121161509.GD8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <danieru.dressler@gmail.com>
 <1416557707-9243-1-git-send-email-danieru.dressler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416557707-9243-1-git-send-email-danieru.dressler@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 21, 2014 at 05:15:07PM +0900, Daniel Dressler wrote:
> This is the 3rd independent patch of a larger
> project to cleanup btrfs's internal usage of
> btrfs_root. Many functions take btrfs_root
> only to grab the fs_info struct.
> 
> By requiring a root these functions cause
> programmer overhead. That these functions can
> accept any valid root is not obvious until
> inspection.
> 
> This patch reduces the specificity of such
> functions to accept the fs_info directly.
> 
> These patches can be applied independently
> and thus are not being submitted as a patch
> series. There should be about 26 patches by
> the project's completion. Each patch will
> cleanup between 1 and 34 functions apiece.
> Each patch covers a single file's functions.

It's good to have this kind of introduction but it really belongs ot the
cover letter not the individual patches.
> 
> This patch affects the following function(s):
>   1) csum_tree_block
>   2) csum_dirty_buffer
>   3) check_tree_block_fsid
>   4) btrfs_find_tree_block
>   5) clean_tree_block

Now that I see that, I'm not sure that my previous comment about 'one
patch per function' is the right way to go. This patch looks good as it
stands. The change is simple enough that I won't be opposed to grouping
even more functions together as long as it stays revieweable.

The patches are likely to clash with a lot of pending patches, so you
may want to base it on the integration branch next time. This would make
maintainers' life easier and also raises chances to merge the patches.

Reviewed-by: David Sterba <dsterba@suse.cz>
