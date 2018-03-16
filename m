Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48309 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934558AbeCPQOr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 12:14:47 -0400
Date: Fri, 16 Mar 2018 17:12:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/22] btrfs: assume that prev_em_start is always valid
 in __do_readpage
Message-ID: <20180316161218.GC16736@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1520518876.git.dsterba@suse.com>
 <f92bec1a7defa40fe7c51a4d570e45f419d0c9df.1520518876.git.dsterba@suse.com>
 <46bf43fc-6fd2-3199-9b5d-3bbb768bba2f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46bf43fc-6fd2-3199-9b5d-3bbb768bba2f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 13, 2018 at 11:03:31PM +0800, Anand Jain wrote:
> On 03/08/2018 10:33 PM, David Sterba wrote:
> > All callers pass a valid pointer, we can remove the redundant checks.
> > 
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > ---
> >   fs/btrfs/extent_io.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index d00d5a59ff21..36514baa661e 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -2875,6 +2875,8 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
> >    * handlers)
> >    * XXX JDM: This needs looking at to ensure proper page locking
> >    * return 0 on success, otherwise return error
> > + *
> > + * @prev_em_start:	return value of previous em start value; must be valid
> >    */
> >   static int __do_readpage(struct extent_io_tree *tree,
> >   			 struct page *page,
> > @@ -2903,6 +2905,8 @@ static int __do_readpage(struct extent_io_tree *tree,
> >   	size_t blocksize = inode->i_sb->s_blocksize;
> >   	unsigned long this_bio_flag = 0;
> >   
> > +	ASSERT(prev_em_start);
> > +
> 
> 
> mount is failing with this patch as in this stack below the 
> prev_em_start is NULL.

Right, I've removed the patch.
