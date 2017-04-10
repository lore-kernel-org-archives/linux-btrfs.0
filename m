Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752395AbdDJQ0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 12:26:30 -0400
Date: Mon, 10 Apr 2017 18:26:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix segment fault when doing dio read
Message-ID: <20170410162627.GC4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1491595870-9633-1-git-send-email-bo.li.liu@oracle.com>
 <5afa50b0-2e6c-d3fa-4dd8-dedbdf1af8b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5afa50b0-2e6c-d3fa-4dd8-dedbdf1af8b4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 09, 2017 at 08:08:05PM +0300, Nikolay Borisov wrote:
> 
> 
> On  7.04.2017 23:11, Liu Bo wrote:
> > Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> > introduced this bug during iterating bio pages in dio read's endio hook,
> > and it could end up with segment fault of the dio reading task.
> > 
> > So the reason is 'if (nr_sectors--)', and it makes the code assume that
> > there is one more block in the same page, so page offset is increased and
> > the bio which is created to repair the bad block then has an incorrect
> > bvec.bv_offset, and a later access of the page content would throw a
> > segment fault.
> > 
> > This also adds ASSERT to check page offset against page size.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index c875e68..5e71f1e 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7972,8 +7972,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
> >  
> >  		start += sectorsize;
> >  
> > -		if (nr_sectors--) {
> > +		nr_sectors--;
> Why not if(--nr_sectors)? I know it's more of a style issue but it will
> reduce the size of the diff ?

I don't think diff size is a problem here. Actually, this instance is
the only one I can find [1] that uses the decrement inside if, so the
change makes it consistent

<smpl>
@@
expression E;
@@

(
* if (E--)
  { ... }
|
* if (E++)
  { ... }
)
</smp>

(run as: spatch -sp_file smpl.cocci -dir fs/btrfs/)
