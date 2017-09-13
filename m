Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37276 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdIMSMe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 14:12:34 -0400
Date: Wed, 13 Sep 2017 11:11:03 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: remove bio_flags which indicates a meta block
 of log-tree
Message-ID: <20170913171103.GC22943@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20170821215000.2987-1-bo.li.liu@oracle.com>
 <20170821215000.2987-2-bo.li.liu@oracle.com>
 <20170913164330.GQ29043@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170913164330.GQ29043@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 06:43:30PM +0200, David Sterba wrote:
> On Mon, Aug 21, 2017 at 03:50:00PM -0600, Liu Bo wrote:
> > Since both committing transaction and writing log-tree are doing
> > plugging on metadata IO, we can unify to use %sync_writers to benefit
> > both cases, instead of checking bio_flags while writing meta blocks of
> > log-tree.
> > 
> > This removes the bio_flags related stuff for writing log-tree.
> 
> I'm not sure if this preserves the intentions introduced in
> de0022b9da616b95ea5, as it's meant to do the checksums synchronously
> (without offloading to other threads), if it's for the tree-log. So now
> it depends on the sync_writers count to do that, while with the bio flag
> it was independent.
>
> The sync_writers is per-inode, while the bio flag is from the
> submit_bio hook, so it's per-context.


Again, blame me for not making the commit log clear enough.

We can remove this bio_flags because in order to write dirty blocks,
log tree also uses btrfs_write_marked_extents(), inside which PATCH 1
has enabled %sync_writers, therefore, every write goes in a
synchronous way, so does checksuming.

WRT per-inode vs per-context, yes, they're a bit different, but the
only overhead I could think of is that

1) while log tree is flushing its dirty blocks via
   btrfs_write_marked_extents(), in which %sync_writers is increased by one.

2) in the meantime, some writeback operations may happen upon btrfs's
   metadata inode, so these writes go synchronously, too.

However, AFAICS, the overhead is not a big one while the win is that
we unify the two places that needs synchronous way and remove a
special hack/flag.


Thanks,

-liubo
