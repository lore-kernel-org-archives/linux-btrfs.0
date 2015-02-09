Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56606 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752391AbbBIFgz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 00:36:55 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
References: <1423317228-5307-1-git-send-email-zhaolei@cn.fujitsu.com> <CAL3q7H5WRP3AaF_xXJXBDHKn9LvUUByfpzC5PJpTwmar_YV0Hw@mail.gmail.com>
In-Reply-To: <CAL3q7H5WRP3AaF_xXJXBDHKn9LvUUByfpzC5PJpTwmar_YV0Hw@mail.gmail.com>
Subject: RE: [PATCH v2] btrfs: Fix out-of-space bug
Date: Mon, 9 Feb 2015 13:35:54 +0800
Message-ID: <000c01d0442a$464de690$d2e9b3b0$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Filipe

> > Changelog v1->v2:
> >  V1 will introduce a new bug when create a metadata bg in space of
> >  old data bg which was just removed, noticed by:
> >  Filipe David Manana <fdmanana@gmail.com>
> >  V2 fix this bug by commit transaction after remove block grops.
> 
> Well it's not specific to reusing the space from a deleted metadata
> block group for a new data block group. This is true for any other
> combination, even "data -> data". When using COW for both metadata and
> data, if a crash happens before the transaction commits, it is
> guaranteed that all data and metadata committed in the previous
> transaction are available on the next mount (and all new data in the
> current transaction if it was fsync'ed) - this applies to any COW
> system, be it a filesystem or a database for example.
> 
Yes, wil change above description.

> >
> > Tested for severial times by above script.
> >
> > Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  fs/btrfs/extent-tree.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index a684086..67c85ff 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -9653,6 +9653,10 @@ next:
> >                 spin_lock(&fs_info->unused_bgs_lock);
> >         }
> >         spin_unlock(&fs_info->unused_bgs_lock);
> > +       trans = btrfs_join_transaction(root);
> > +       if (!IS_ERR(trans))
> > +               btrfs_commit_transaction(trans, root);
> > +
> 
> At the very least, before doing the commit, you should verify if any
> block groups were actually deleted - under some conditions we skip
> their deletion in the loop. 
Good suggestion, it can reduce useless committing.

> Plus, it would be good to check if the sum
> of the sizes of the deleted block groups exceeds some minimum
> threshold (lets say 1G or 2G, whatever), so that we don't get the
> overhead of committing a transaction for little or no gains.
>
Chunks are large enough in normal-size btrfs filesystem(size > 10G), or
worthed to be deleted in small-size filesystem, which have chunk
size <= 128M but large percent of total size.

And it is easy to trigger above problem in case that we ignore
deleting 128M chunks when fs is empty.

So I think always commit transaction when delete empty chunks
will make logic simple, but ... , see below.

> I would also consider doing the commit only if the fs is really
> running out of free space or close to being out of free space.
> 
Maybe the better way is to delay deleting-chunks.

The patch of "delete empty bgs" is used to fix problem that
"no space for allocate metadata chunks but data chunks are free".
It is to say, we only need to free data chunks when we have no space
for metadata(or conversely), and need not always delete free chunks.
Do delete-bg in allow_chunk() will be better.

But it is complex than current method, I want to avoid new bugs in rc,
to give users a stable version in 3.19.

> You can get into many similar cases of space not being released until
> the transaction commits.
> For example, create 10 files with a size of 1Gb each (via fallocate
> for e.g.), and then truncate them all to a size of 1M in the same
> transaction for example. You'll get 999Mb * 10 of space that won't be
> available for use until the current transaction commits - it's exactly
> the same problem you found, it just doesn't imply deleting whole block
> groups/chunks.
> 
This bug is more serious than above.

In my test, when NO_SPACE happened, we can not write into filesystem
forever(may be something with space_info->full), so I wish to solve it
before 3.19.

Thanks
Zhaolei

> Thanks
> 
> >  }
> >
> >  int btrfs_init_space_info(struct btrfs_fs_info *fs_info)
> > --
> > 1.8.5.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> --
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


