Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbcKRSMA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 13:12:00 -0500
Date: Fri, 18 Nov 2016 19:11:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 0/6] btrfs-progs: better space_cache=v2 support
Message-ID: <20161118181155.GC12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1479148594.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1479148594.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 14, 2016 at 10:43:17AM -0800, Omar Sandoval wrote:
> Cover letter from v1:
> 
> This series implements some support for space_cache=v2 in btrfs-progs.
> In particular, this adds support for `btrfs check --clear-space-cache v2`,
> proper printing of the free space tree flags for `btrfs inspect-internal
> dump-super`, and better documentation.
> 
> We'd previously talked about always making btrfs-progs always invalidate
> the free space tree when doing write operations, but I decided that this
> should be an action explicitly requested by the user. It'd also be
> unsafe if using a kernel without the free space tree valid bit support,
> which is why I didn't implement a `btrfs check --invalidate-free-space-cache`
> option. Doing the full clear is always safe.
> 
> Still missing is full read-write support, but this should hopefully
> cover most btrfs-progs usage.
> 
> Changes since v1:
> 
> - Change unsigned -> unsigned int argument to
>   btrfs_check_fs_compatability() in patch 3
> - Remove BUG_ON() in btrfs_del_root() in patch 4
> - Return error from btrfs_free_tree_block() in patch 4
> - Handle errors from btrfs_free_tree_block() and clean_tree_block() in
>   patch 4
> - Add Qu Wenruo's Reviewed-by to patches 3, 4, and 5
> 
> Thanks!
> 
> Omar Sandoval (6):
>   btrfs-progs: add the FREE_SPACE_TREE_VALID compat_ro bit definition
>   btrfs-progs: format FREE_SPACE_TREE{,_VALID} nicely in dump-super
>   btrfs-progs: add OPEN_CTREE_INVALIDATE_FST flag
>   btrfs-progs: add btrfs_clear_free_space_tree() from the kernel
>   btrfs-progs: implement btrfs check --clear-space-cache v2
>   btrfs-progs: document space_cache=v2 more thoroughly

Applied, thanks.
