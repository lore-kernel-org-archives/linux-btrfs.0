Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2GIUYw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 16:24:52 -0400
Date: Mon, 9 Jul 2012 13:24:50 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 3/3] btrfs: extended inode refs
Message-ID: <20120709202450.GC8323@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-4-git-send-email-mfasheh@suse.de> <4FF6FCD9.907@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF6FCD9.907@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 04:57:29PM +0200, Jan Schmidt wrote:
> On Mon, May 21, 2012 at 23:46 (+0200), Mark Fasheh wrote:
> > From: Mark Fasheh <mfasheh@suse.com>
> > 
> > The iterate_irefs in backref.c is used to build path components from inode
> > refs. This patch adds code to iterate extended refs as well.
> > 
> > I had modify the callback function signature to abstract out some of the
> > differences between ref structures. iref_to_path() also needed similar
> > changes.
> > 
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> > ---
> >  fs/btrfs/backref.c |  144 +++++++++++++++++++++++++++++++++++++++++++---------
> >  fs/btrfs/backref.h |    2 -
> >  2 files changed, 119 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> > index c97240a..d88fa49 100644
> > --- a/fs/btrfs/backref.c
> > +++ b/fs/btrfs/backref.c
> > @@ -22,6 +22,7 @@
> >  #include "ulist.h"
> >  #include "transaction.h"
> >  #include "delayed-ref.h"
> > +#include "locking.h"
> 
> This + line tells me it's not based on top of linux-3.4 or newer. I see that the
> changes made in between are now included in your patch set. It might have been
> better to rebase it before sending them. Anyway, that only makes review a bit
> harder, should affect applying the patches.

Yes, it's all based on Linux 3.3 (when I started). I can rebase of course
but have avoided it so far in order to keep a stable base upon which to test
/ fix. I can rebase however, especially if that makes life easier for Chris.


> >  /*
> >   * this structure records all encountered refs on the way up to the root
> > @@ -940,34 +941,35 @@ int btrfs_find_one_extref(struct btrfs_root *root, u64 inode_objectid,
> >   * value will be smaller than dest. callers must check this!
> >   */
> >  static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> > -				struct btrfs_inode_ref *iref,
> > -				struct extent_buffer *eb_in, u64 parent,
> > -				char *dest, u32 size)
> > +			  u32 name_len, unsigned long name_off,
> > +			  struct extent_buffer *eb_in, u64 parent,
> > +			  char *dest, u32 size)
> >  {
> > -	u32 len;
> >  	int slot;
> >  	u64 next_inum;
> >  	int ret;
> >  	s64 bytes_left = size - 1;
> >  	struct extent_buffer *eb = eb_in;
> >  	struct btrfs_key found_key;
> > +	struct btrfs_inode_ref *iref;
> >  
> >  	if (bytes_left >= 0)
> >  		dest[bytes_left] = '\0';
> >  
> >  	while (1) {
> > -		len = btrfs_inode_ref_name_len(eb, iref);
> > -		bytes_left -= len;
> > +		bytes_left -= name_len;
> >  		if (bytes_left >= 0)
> >  			read_extent_buffer(eb, dest + bytes_left,
> > -						(unsigned long)(iref + 1), len);
> > +					   name_off, name_len);
> >  		if (eb != eb_in)
> >  			free_extent_buffer(eb);
> > +
> >  		ret = inode_ref_info(parent, 0, fs_root, path, &found_key);
> >  		if (ret > 0)
> >  			ret = -ENOENT;
> >  		if (ret)
> >  			break;
> > +
> >  		next_inum = found_key.offset;
> >  
> >  		/* regular exit ahead */
> > @@ -980,8 +982,11 @@ static char *iref_to_path(struct btrfs_root *fs_root, struct btrfs_path *path,
> >  		if (eb != eb_in)
> >  			atomic_inc(&eb->refs);
> >  		btrfs_release_path(path);
> > -
> >  		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> > +
> > +		name_len = btrfs_inode_ref_name_len(eb, iref);
> > +		name_off = (unsigned long)(iref + 1);
> > +
> >  		parent = next_inum;
> >  		--bytes_left;
> >  		if (bytes_left >= 0)
> > @@ -1294,9 +1299,12 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
> >  	return ret;
> >  }
> >  
> > -static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> > -				struct btrfs_path *path,
> > -				iterate_irefs_t *iterate, void *ctx)
> > +typedef int (iterate_irefs_t)(u64 parent, u32 name_len, unsigned long name_off,
> > +			      struct extent_buffer *eb, void *ctx);
> > +
> > +static int iterate_inode_refs(u64 inum, struct btrfs_root *fs_root,
> > +			      struct btrfs_path *path,
> > +			      iterate_irefs_t *iterate, void *ctx)
> >  {
> >  	int ret;
> >  	int slot;
> > @@ -1312,7 +1320,7 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> >  
> >  	while (1) {
> >  		ret = inode_ref_info(inum, parent ? parent+1 : 0, fs_root, path,
> > -					&found_key);
> > +				     &found_key);
> >  		if (ret < 0)
> >  			break;
> >  		if (ret) {
> > @@ -1326,8 +1334,11 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> >  		eb = path->nodes[0];
> >  		/* make sure we can use eb after releasing the path */
> >  		atomic_inc(&eb->refs);
> > +		btrfs_tree_read_lock(eb);
> > +		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> >  		btrfs_release_path(path);
> >  
> > +
> 
> I realized you like adding new lines, but we really don't need two of them here.

;)


> >  		item = btrfs_item_nr(eb, slot);
> >  		iref = btrfs_item_ptr(eb, slot, struct btrfs_inode_ref);
> >  
> > @@ -1338,15 +1349,81 @@ static int iterate_irefs(u64 inum, struct btrfs_root *fs_root,
> >  				 "tree %llu\n", cur,
> >  				 (unsigned long long)found_key.objectid,
> >  				 (unsigned long long)fs_root->objectid);
> > -			ret = iterate(parent, iref, eb, ctx);
> > -			if (ret) {
> > -				free_extent_buffer(eb);
> > +			ret = iterate(parent, name_len,
> > +				      (unsigned long)(iref + 1),eb, ctx);
> 
> There's a space missing before "eb".

Ooop, will fix that.

> 
> > +			if (ret)
> >  				break;
> > -			}
> >  			len = sizeof(*iref) + name_len;
> >  			iref = (struct btrfs_inode_ref *)((char *)iref + len);
> >  		}
> > +		btrfs_tree_read_unlock_blocking(eb);
> > +		free_extent_buffer(eb);
> > +	}
> > +
> > +	btrfs_release_path(path);
> > +
> > +	return ret;
> > +}

> >  /*
> > diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
> > index 8586d1b..649a220 100644
> > --- a/fs/btrfs/backref.h
> > +++ b/fs/btrfs/backref.h
> > @@ -30,8 +30,6 @@ struct inode_fs_paths {
> >  
> >  typedef int (iterate_extent_inodes_t)(u64 inum, u64 offset, u64 root,
> >  		void *ctx);
> > -typedef int (iterate_irefs_t)(u64 parent, struct btrfs_inode_ref *iref,
> > -				struct extent_buffer *eb, void *ctx);
> >  
> >  int inode_item_info(u64 inum, u64 ioff, struct btrfs_root *fs_root,
> >  			struct btrfs_path *path);
> 
> Almost ready for a reviewed-by tag :-)

Yes, it seems like that last issues left which aren't cosmetic / patch
guideline fixups have to do with patch 2. Let me know if you disagree :)

Thanks again Jan,
	--Mark

--
Mark Fasheh
