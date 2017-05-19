Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755458AbdESSLk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 14:11:40 -0400
Date: Fri, 19 May 2017 20:10:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: jeffm@suse.com, linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: fix race with relocation recovery and fs_root
 setup
Message-ID: <20170519181041.GZ4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1495035516-3217-1-git-send-email-jeffm@suse.com>
 <20170518235819.GD23822@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518235819.GD23822@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 18, 2017 at 04:58:19PM -0700, Liu Bo wrote:
> On Wed, May 17, 2017 at 11:38:34AM -0400, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > If we have to recover relocation during mount, we'll ultimately have to
> > evict the orphan inode.  That goes through the reservation dance, where
> > priority_reclaim_metadata_space and flush_space expect fs_info->fs_root
> > to be valid.  That's the next thing to be set up during mount, so we
> > crash, almost always in flush_space trying to join the transaction
> > but priority_reclaim_metadata_space is possible as well.  This call
> > path has been problematic in the past WRT whether ->fs_root is valid
> > yet.  Commit 957780eb278 (Btrfs: introduce ticketed enospc
> > infrastructure) added new users that are called in the direct path
> > instead of the async path that had already been worked around.
> > 
> > The thing is that we don't actually need the fs_root, specifically, for
> > anything.  We either use it to determine whether the root is the
> > chunk_root for use in choosing an allocation profile or as a root to pass
> > btrfs_join_transaction before immediately committing it.  Anything that
> > isn't the chunk root works in the former case and any root works in
> > the latter.
> > 
> > A simple fix is to use a root we know will always be there: the
> > extent_root.
> > 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

2-3 added to 4.13 queue, 1 will go to 4.12. Thanks.
