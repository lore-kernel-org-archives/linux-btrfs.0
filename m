Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52681 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751034AbdE2NbK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 09:31:10 -0400
Date: Mon, 29 May 2017 15:30:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, Jeff Layton <jlayton@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] btrfs: btrfs_wait_tree_block_writeback can be void return
Message-ID: <20170529133008.GD14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525103952.7173-1-jlayton@redhat.com>
 <20170526170831.GF30842@twin.jikos.cz>
 <20170526194925.GA7859@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526194925.GA7859@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 12:49:25PM -0700, Liu Bo wrote:
> On Fri, May 26, 2017 at 07:08:31PM +0200, David Sterba wrote:
> > On Thu, May 25, 2017 at 06:39:52AM -0400, Jeff Layton wrote:
> > > Nothing checks its return value.
> > 
> > I think we don't need to check the return value of
> > filemap_fdatawait_range, because the errors are tracked by other means
> > (attached to the btree_inode mapping that represents the metadata), in
> > set_btree_ioerr.
> > 
> > > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > To Liu Bo:
> > 
> > May I ask if you did a review that matches the above understanding? It's
> > trivial to see that nothing really checks the return value of
> > btrfs_wait_tree_block_writeback but my question is if it's really safe
> > not to so. Thanks.
> 
> About the question if it's safe not to do so, I think yes, it's used in
> walk_log_tree which is called in two places, free_log_tree and log replay.  For
> free_log_tree, it waits for any running writeback of the extent buffer under
> freeing to finish in case we need to access the eb pointer from page->private,
> and it's OK to not check the return value, while for log replay, it's doesn't
> wait because wc->wait is not set. So neither cares about the writeback error.

Thanks, I'll update the changelog.
