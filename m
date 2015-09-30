Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56346 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752526AbbI3D4b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 23:56:31 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>
References: <09827c6fe97dbbeb585e6214f7e40699061b8fc6.1441178370.git.zhaolei@cn.fujitsu.com> <20150929142134.GC11442@twin.jikos.cz>
In-Reply-To: <20150929142134.GC11442@twin.jikos.cz>
Subject: RE: [PATCH] btrfs: fix a compiler warning of may be used uninitialized
Date: Wed, 30 Sep 2015 11:55:13 +0800
Message-ID: <00d701d0fb33$cfbc6a80$6f353f80$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for reviewing.

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, September 29, 2015 10:22 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs: fix a compiler warning of may be used uninitialized
> 
> On Wed, Sep 02, 2015 at 03:19:59PM +0800, Zhao Lei wrote:
> > Not real problem, just avoid warning of:
> >  fs/btrfs/inode-map.c: In function 'btrfs_unpin_free_ino':
> >  fs/btrfs/inode-map.c:252: warning: 'count' may be used uninitialized
> > in this function In gcc 4.8.3
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  fs/btrfs/inode-map.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c index
> > d4a582a..e094e3b 100644
> > --- a/fs/btrfs/inode-map.c
> > +++ b/fs/btrfs/inode-map.c
> > @@ -249,7 +249,7 @@ void btrfs_unpin_free_ino(struct btrfs_root *root)
> >  	spinlock_t *rbroot_lock = &root->free_ino_pinned->tree_lock;
> >  	struct btrfs_free_space *info;
> >  	struct rb_node *n;
> > -	u64 count;
> > +	u64 count = 0;
> 
> AFAICS the codepath that would use uninitialized value of count is not
> reachable:
> 
> 		    add_to_ctl = true
> 
> 270                 if (info->offset > root->ino_cache_progress)
> 271                         add_to_ctl = false;
> 272                 else if (info->offset + info->bytes >
> root->ino_cache_progress)
> 273                         count = root->ino_cache_progress -
> info->offset + 1;
> 274                 else
> 275                         count = info->bytes;
> 276
> 277                 rb_erase(&info->offset_index, rbroot);
> 278                 spin_unlock(rbroot_lock);
> 279                 if (add_to_ctl)
> 280                         __btrfs_add_free_space(ctl, info->offset,
> count);
> 
> count is defined iff add_to_ctl == true, so the patch is not necessary. And I'm
> not quite sure that 0 passed down to __btrfs_add_free_space as 'bytes' makes
> sense at all.

Agree above all.

So I write following description in changelog:
  "Not real problem, just avoid warning of: ..."

It is just to avoid complier warning, no function changed.
A warning in compiler output is not pretty:)

Thanks
Zhaolei


