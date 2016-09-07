Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36397 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754028AbcIGBmE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 21:42:04 -0400
Date: Wed, 7 Sep 2016 09:41:56 +0800
From: Sean Fu <fxinrong@gmail.com>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: dsterba@suse.com, clm@fb.com, anand.jain@oracle.com, fdmanana@suse.com,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove unnecessary code of chunk_root
 assignment in btrfs_read_chunk_tree.
Message-ID: <20160907014155.GB3907@linux-zmni.apac.novell.com>
References: <1473133858-12230-1-git-send-email-fxinrong@gmail.com>
 <005301d207fe$447ebd50$cd7c37f0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <005301d207fe$447ebd50$cd7c37f0$@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 06, 2016 at 01:19:39PM +0800, Zhao Lei wrote:
> Hi, Sean Fu
> 
> > -----Original Message-----
> > From: Sean Fu [mailto:fxinrong@gmail.com]
> > Sent: Tuesday, September 06, 2016 11:51 AM
> > To: dsterba@suse.com
> > Cc: clm@fb.com; anand.jain@oracle.com; fdmanana@suse.com;
> > zhaolei@cn.fujitsu.com; linux-kernel@vger.kernel.org;
> > linux-btrfs@vger.kernel.org; Sean Fu <fxinrong@gmail.com>
> > Subject: [PATCH v2] Btrfs: remove unnecessary code of chunk_root assignment
> > in btrfs_read_chunk_tree.
> > 
> > The input argument root is already set with "fs_info->chunk_root".
> > "chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info)" in caller
> > "open_ctree".
> > "root->fs_info = fs_info” in "btrfs_alloc_root".
> > 
> > Signed-off-by: Sean Fu <fxinrong@gmail.com>
> > ---
> > Changes in v2:
> >   - Renaming root to chunk_root to make it clear.
> > 
> >  fs/btrfs/volumes.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 366b335..eb3d04a 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -6591,7 +6591,7 @@ out_short_read:
> >  	return -EIO;
> >  }
> > 
> > -int btrfs_read_chunk_tree(struct btrfs_root *root)
> > +int btrfs_read_chunk_tree(struct btrfs_root *chunk_root)
> 
> Maybe you also need to modify function body to make it
> pass compile, and the header file also need to be modified.
Sorry for my mistake. I have released v3 for it.
> 
> BTW, Qu Wenruo give us a better way in reply, we
> can use fs_info directly.
Sorry, I don't know why we should use fs_info directly.
I have asked Qu for more detail.
Thanks for your review.
> 
> Thanks
> Zhaolei
> 
> >  {
> >  	struct btrfs_path *path;
> >  	struct extent_buffer *leaf;
> > @@ -6600,8 +6600,6 @@ int btrfs_read_chunk_tree(struct btrfs_root *root)
> >  	int ret;
> >  	int slot;
> > 
> > -	root = root->fs_info->chunk_root;
> > -
> >  	path = btrfs_alloc_path();
> >  	if (!path)
> >  		return -ENOMEM;
> > --
> > 2.6.2
> > 
> 
> 
> 
> 
