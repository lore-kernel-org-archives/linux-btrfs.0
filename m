Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53361 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab3I3PgG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 11:36:06 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E0E8F9A0365
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Sep 2013 09:36:04 -0600 (MDT)
Date: Mon, 30 Sep 2013 11:36:02 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't delete ordered roots from list during
 cleanup
Message-ID: <20130930153602.GN18681@localhost.localdomain>
References: <1380314266-28871-1-git-send-email-jbacik@fusionio.com>
 <20130927231814.GB30372@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130927231814.GB30372@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 04:18:14PM -0700, Zach Brown wrote:
> On Fri, Sep 27, 2013 at 04:37:46PM -0400, Josef Bacik wrote:
> > During transaction cleanup after an abort we are just removing roots from the
> > ordered roots list which is incorrect.  We have a BUG_ON() to make sure that the
> > root is still part of the ordered roots list when we put our ordered extent
> > which we were tripping in this case.  So do like we do everywhere else and just
> > move it to the tail of the ordered roots list and allow the normal cleanup to
> > take care of stuff.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  fs/btrfs/disk-io.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index f38211f..872b4ce 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -3835,7 +3835,8 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
> >  	while (!list_empty(&splice)) {
> >  		root = list_first_entry(&splice, struct btrfs_root,
> >  					ordered_root);
> > -		list_del_init(&root->ordered_root);
> > +		list_move_tail(&root->ordered_root,
> > +			       &fs_info->ordered_roots);
> 
> This function basically only does:
> 
> 	lock
> 	list_for_each
> 		lock
> 		list_for_each
> 			set_bit
> 
> Could we instead add a bit to the root or trans or fs_info or anything
> else that could be trivialy set in _destroy_all_ordered_extents and
> tested in _finish_ordered_io()?  It'd remove a bunch of tedious locking
> and iteration here.
> 
> The similar metaphor in the core page cache is (address_space->flags |
> AS_EIO).
> 
> Would that be too coarse or racey?

So I _think_ we may need to truncate the ordered range in the inode as well, but
I haven't had a consistent reproducer for this case.  I want to leave it like
this for now until I'm sure we don't need the truncate and then we could
probably just replace this with a test for FS_ERROR in finish_ordered_io.
Thanks,

Josef
