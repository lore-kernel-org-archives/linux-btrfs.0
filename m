Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25088 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbcFWRik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 13:38:40 -0400
Date: Thu, 23 Jun 2016 10:38:32 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: error out if generic_bin_search get invalid
 arguments
Message-ID: <20160623173832.GA13924@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1466645539-27296-1-git-send-email-bo.li.liu@oracle.com>
 <20160623085152.GU4915@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160623085152.GU4915@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 10:51:52AM +0200, David Sterba wrote:
> On Wed, Jun 22, 2016 at 06:32:19PM -0700, Liu Bo wrote:
> > With btrfs-corrupt-block, one can set btree node/leaf's field, if
> > we assign a negative value to node/leaf, we can get various hangs,
> > eg. if extent_root's nritems is -2ULL, then we get stuck in
> >  btrfs_read_block_groups() because it has a while loop and
> > btrfs_search_slot() on extent_root will always return the first
> >  child.
> > 
> > This lets us know what's happening and returns a EINVAL to callers
> > instead of returning the first item.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index c49a500..915d224 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -1770,6 +1770,14 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
> >  	unsigned long map_len = 0;
> >  	int err;
> >  
> > +	if (low > high) {
> > +		btrfs_err(eb->fs_info,
> > +		 "%s: low (%d) < high (%d) eb %llu owner %llu level %d",
> 
> Why is it '<' in the error message?

Err, my typo error.

Thanks,

-liubo
