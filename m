Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33085 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1948437AbdEZRJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 13:09:32 -0400
Date: Fri, 26 May 2017 19:08:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Layton <jlayton@redhat.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH] btrfs: btrfs_wait_tree_block_writeback can be void return
Message-ID: <20170526170831.GF30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525103952.7173-1-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525103952.7173-1-jlayton@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 06:39:52AM -0400, Jeff Layton wrote:
> Nothing checks its return value.

I think we don't need to check the return value of
filemap_fdatawait_range, because the errors are tracked by other means
(attached to the btree_inode mapping that represents the metadata), in
set_btree_ioerr.

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

To Liu Bo:

May I ask if you did a review that matches the above understanding? It's
trivial to see that nothing really checks the return value of
btrfs_wait_tree_block_writeback but my question is if it's really safe
not to so. Thanks.
