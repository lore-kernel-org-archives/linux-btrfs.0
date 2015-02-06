Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5092 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbbBFKvp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 05:51:45 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <fdmanana@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
References: <1423212122-12952-1-git-send-email-zhaolei@cn.fujitsu.com>	<1423212122-12952-2-git-send-email-zhaolei@cn.fujitsu.com> <CAL3q7H7J6jw=dq+UbXs+Mz-PQcy7x8xfuHgQR+iLdJgdBuiZAA@mail.gmail.com>
In-Reply-To: <CAL3q7H7J6jw=dq+UbXs+Mz-PQcy7x8xfuHgQR+iLdJgdBuiZAA@mail.gmail.com>
Subject: RE: [PATCH 1/2] btrfs: Fix out-of-space bug caused by searching commit_root in find_free_dev_extent()
Date: Fri, 6 Feb 2015 18:50:42 +0800
Message-ID: <006001d041fa$c0abac10$42030430$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Filipe

> > Reason:
> > Btrfs get free disk space by calling find_free_dev_extent() when
> > re-create chunk for write, but current code set search_commit_root
> > flag in searching tree, so disk spaces which was freed from dev_tree
> > but not commited can not get from find_free_dev_extent(), then
> > btrfs report NO_SPACE on above case.
> 
> Yes, and that is correct.
> If you re-use the same physical space within the same transaction,
> write to it and a crash happens before writing the next super block
> (transaction commit), the next time the fs is mounted it will have
> data or metadata corrupted.
> 
> With your change this could happen:
> 
> 1) Delete metadata block group X, which takes physical space [2G, 3G]
> (assuming single metadata profile);
> 
> 2) A chunk allocation for a data block group happens, and it gets that
> same physical space in the range [2G, 3G];
> 
> 3) Data is written into it - for e.g. due to memory pressure, the VM
> calls writepages() for some inodes;
> 
> 4) Crash/reboot happens before the transaction commits;
> 
> 5) On the next mount, you have metadata corrupted - there's now file
> data instead of btree nodes/leafs in metadata the block group at the
> physical range [2G, 3G]
> 
Thanks for notice.

Since above NO_SPACE bug is still exist and need to be fixed, maybe we
need to do a commit transaction after remove_bgs.
I'll test this way and resend.

Thanks
Zhaolei

> That said, unless I missed something, I disagree with this patch.
> 
> >
> > Fix:
> > Remove "path->search_commit_root = 1" in find_free_dev_extent().
> >
> > Tested by above script, and confirmed action with many printk.
> >
> > Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  fs/btrfs/volumes.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 50c5a87..5cd0930 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -1147,7 +1147,6 @@ again:
> >         }
> >
> >         path->reada = 2;
> > -       path->search_commit_root = 1;
> >         path->skip_locking = 1;
> >
> >         key.objectid = device->devid;
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


