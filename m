Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27268 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab3DHOQD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 10:16:03 -0400
Date: Mon, 8 Apr 2013 22:16:26 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: online data deduplication
Message-ID: <20130408141625.GC27988@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1365340369-23537-1-git-send-email-bo.li.liu@oracle.com>
 <1365340369-23537-2-git-send-email-bo.li.liu@oracle.com>
 <20130408125450.GA2010@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130408125450.GA2010@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 08, 2013 at 08:54:50AM -0400, Josef Bacik wrote:
> On Sun, Apr 07, 2013 at 07:12:48AM -0600, Liu Bo wrote:
> > (NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data.)
> > 
> > This introduce the online data deduplication feature for btrfs.
> > 
> > (1) WHY do we need deduplication?
> >     To improve our storage effiency.
> > 
> > (2) WHAT is deduplication?
> >     Two key ways for practical deduplication implementations,
> >     *  When the data is deduplicated
> >        (inband vs background)
> >     *  The granularity of the deduplication.
> >        (block level vs file level)
> > 
> >     For btrfs, we choose
> >     *  inband(synchronous)
> >     *  block level
> > 
> >     We choose them because of the same reason as how zfs does.
> >     a)  To get an immediate benefit.
> >     b)  To remove redundant parts within a file.
> > 
> >     So we have an inband, block level data deduplication here.
> > 
> > (3) HOW does deduplication works?
> >     This makes full use of file extent back reference, the same way as
> >     IOCTL_CLONE, which lets us easily store multiple copies of a set of
> >     data as a single copy along with an index of references to the copy.
> > 
> >     Here we have
> >     a)  a new dedicated tree(DEDUP tree) and
> >     b)  a new key(BTRFS_DEDUP_ITEM_KEY), which consists of
> >         (stop 64bits of hash, type, disk offset),
> >         *  stop 64bits of hash
> >            It comes from sha256, which is very helpful on avoiding collision.
> >            And we take the stop 64bits as the index.
> >         *  disk offset
> >            It helps to find where the data is stored.
> > 
> >     So the whole deduplication process works as,
> >     1) write something,
> >     2) calculate the hash of this "something",
> >     3) try to find the match of hash value by searching DEDUP keys in
> >        a dedicated tree, DEDUP tree.
> >     4) if found, skip real IO and link to the existing copy
> >        if not, do real IO and insert a DEDUP key to the DEDUP tree.
> > 
> >     For now, we limit the deduplication unit to PAGESIZE, 4096, and we're
> >     going to increase this unit dynamically in the future.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.h        |   53 ++++++++
> >  fs/btrfs/disk-io.c      |   33 +++++-
> >  fs/btrfs/extent-tree.c  |   22 +++-
> >  fs/btrfs/extent_io.c    |    8 +-
> >  fs/btrfs/extent_io.h    |   11 ++
> >  fs/btrfs/file-item.c    |  186 ++++++++++++++++++++++++++
> >  fs/btrfs/file.c         |    6 +-
> >  fs/btrfs/inode.c        |  330 +++++++++++++++++++++++++++++++++++++++++++----
> >  fs/btrfs/ioctl.c        |   34 +++++-
> >  fs/btrfs/ordered-data.c |   25 +++-
> >  fs/btrfs/ordered-data.h |    9 ++
> >  fs/btrfs/print-tree.c   |    6 +-
> >  fs/btrfs/super.c        |    7 +-
> >  13 files changed, 685 insertions(+), 45 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 0d82922..59339bc 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -32,6 +32,7 @@
> >  #include <asm/kmap_types.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/btrfs.h>
> > +#include <crypto/hash.h>
> >  #include "extent_io.h"
> >  #include "extent_map.h"
> >  #include "async-thread.h"
> > @@ -94,6 +95,9 @@ struct btrfs_ordered_sum;
> >  /* holds quota configuration and tracking */
> >  #define BTRFS_QUOTA_TREE_OBJECTID 8ULL
> > 
> > +/* dedup tree(experimental) */
> > +#define BTRFS_DEDUP_TREE_OBJECTID 9ULL
> > +
> >  /* orhpan objectid for tracking unlinked/truncated files */
> >  #define BTRFS_ORPHAN_OBJECTID -5ULL
> > 
> > @@ -884,12 +888,31 @@ struct btrfs_file_extent_item {
> >          */
> >         __le64 num_bytes;
> > 
> > +       /*
> > +        * the stop 64bits of sha256 hash value, this helps us find the
> > +        * corresponding item in dedup tree.
> > +        */
> > +       __le64 dedup_hash;
> > +
> >  } __attribute__ ((__packed__));
> > 
> 
> Please don't do this, do like what we do with the crc tree, just lookup based on
> the disk bytenr when we free the extent and drop refs that way.  Don't further
> bloat the file extent item, we want it smaller not larger.  Thanks,
> 
> Josef

So the real trouble is that I take this hash value as the first field of
btrfs_key, and binary searching without the precise first field is not easy.

Otherwise we may have to add another key type which replaces hash value with
disk bytenr, ie. (disk bytenr, ANOTHER_KEY_TYPE, hash value), then we'll need to
search the tree twice to free this one or drop refs.

Either case is tradeoff, but as this is an initial version, we can try all of
these knobs and choose the better one :)

thanks,
liubo
