Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751255AbdINREd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 13:04:33 -0400
Date: Thu, 14 Sep 2017 19:02:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Btrfs: remove bio_flags which indicates a meta
 block of log-tree
Message-ID: <20170914170225.GV29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170821215000.2987-2-bo.li.liu@oracle.com>
 <20170913181822.26992-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170913181822.26992-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 12:18:22PM -0600, Liu Bo wrote:
> Since both committing transaction and writing log-tree are doing
> plugging on metadata IO, we can unify to use %sync_writers to benefit
> both cases, instead of checking bio_flags while writing meta blocks of
> log-tree.
> 
> We can remove this bio_flags because in order to write dirty blocks,
> log tree also uses btrfs_write_marked_extents(), inside which we
> has enabled %sync_writers, therefore, every write goes in a
> synchronous way, so does checksuming.
> 
> Please also note that, bio_flags is applied per-context while
> %sync_writers is applied per-inode, so this might incur some overhead, ie.
> 
> 1) while log tree is flushing its dirty blocks via
>    btrfs_write_marked_extents(), in which %sync_writers is increased
>    by one.
> 
> 2) in the meantime, some writeback operations may happen upon btrfs's
>    metadata inode, so these writes go synchronously, too.
> 
> However, AFAICS, the overhead is not a big one while the win is that
> we unify the two places that needs synchronous way and remove a
> special hack/flag.
> 
> This removes the bio_flags related stuff for writing log-tree.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Much better, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
