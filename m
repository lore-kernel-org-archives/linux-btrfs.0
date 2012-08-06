Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076Ab2HFXbn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Aug 2012 19:31:43 -0400
Date: Mon, 6 Aug 2012 16:31:41 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/3] btrfs: extended inode refs
Message-ID: <20120806233141.GB3141@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-3-git-send-email-mfasheh@suse.de> <4FF6FCCB.4050505@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF6FCCB.4050505@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 04:57:15PM +0200, Jan Schmidt wrote:
> Thought about this search_done once again, I'd like to repeat our May's
> conversation:
> 
> On Fri, May 04, 2012 at 01:12 (+0200), Mark Fasheh wrote:
> > > You moved this comment and assignment out of the "if (ret == 0)" case.
> > > I'm not sure if this is still doing exactly the same now (?).
> > > Previously, we were executing another btrfs_search_slot,
> > > btrfs_lookup_dir_index_item, ... after the "goto again" case, which
> > > would be skipped with this patch.
> > Hmm, ok you're definitely right that the search_done line there is broken.
> > Come to think of it, I'm not quite sure what the meaning of that tiny bit of
> > code was. I'll come back to this one once I've looked closer.
> 
> What's the result of looking closer?

Ok so to describe what, to the best of my understanding,
add_inode_ref() does before my patch (corrections are appreciated):

add_inode_ref() is iterating through a backref found in the tree log. As it
iterates though each log tree backref item it checks the following against
the subvolume tree:

1) Does a backref item with the logged key exist in the subvolume tree? If so
   each individual backref must be checked to make sure it exists in the log.
   If not, it is removed.

2) Does a directory index item for the log refs name exist in the parent? Remove
   it.

3) Does a directory item exist for the log refs name in the parent? Remove
   it.

The 'search_done' variable is set the first time step 1 is executed. We
never need to execute that step more than once since the key we're
processing never changes (so we'd always pull up the same ref item) and we
fully process the item we get from it the 1st time.

I'm not sure why Steps 2 and 3 are also skipped though if we found subvolume
refs. It seems to me that we would want to do those checks on every log
ref. In the case that the subvolume has no existing refs we'd certainly
exectute that once for every log ref.

Also to note is that the condition for step 1 either hits the first time we
execute or we'll never hit it. There's nothing in the code there that
*adds* a ref item to the subtree so if it exists we'll get it otherwise
we'll never see it.


So in order to preserve this behavior, I'll update the patch so that
search_done is set within the two blocks which look over (extended and
traditional) refs found in the subvolume. The goto can stay in the same
place, as can all the labels.


How does that sound?


> >  	/* look for a conflicting sequence number */
> >  	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
> > -					 btrfs_inode_ref_index(eb, ref),
> > -					 name, namelen, 0);
> > +					 ref_index, name, namelen, 0);
> >  	if (di && !IS_ERR(di)) {
> >  		ret = drop_one_dir_item(trans, root, path, dir, di);
> >  		BUG_ON(ret);
> > @@ -932,17 +1053,25 @@ again:
> >  
> >  insert:
> >  	/* insert our name */
> > -	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,
> > -			     btrfs_inode_ref_index(eb, ref));
> > +	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0, ref_index);
> >  	BUG_ON(ret);
> >  
> >  	btrfs_update_inode(trans, root, inode);
> >  
> >  out:
> > -	ref_ptr = (unsigned long)(ref + 1) + namelen;
> > +	ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
> >  	kfree(name);
> > -	if (ref_ptr < ref_end)
> > +	if (ref_ptr < ref_end) {
> > +		if (log_ref_ver) {
> > +			ret = extref_get_fields(eb, slot, &namelen, &name,
> > +						&ref_index, NULL);
> > +		} else {
> > +			ret = ref_get_fields(key, eb, slot, &namelen, &name,
> > +					     &ref_index, NULL);
> > +		}
> > +		BUG_ON(ret);
> 
> We return ret above and BUG_ON ret, here. Is that on purpose? May make sense, I
> just don't see the difference immediately.

Ahh, the first block we can return safely from since the function has not
done work yet. At this point though we've started the operation and it can
not be unrolled. The reason I say this "can not be unrolled" is because
almost every other call in between this and the start of the function has a
"BUG_ON(ret);" after it. As that was the case it seemed to make sense to put
this there.


> 
> >  		goto again;
> > +	}
> >  
> >  	/* finally write the back reference in the inode */
> >  	ret = overwrite_item(trans, root, path, eb, slot, key);
> > @@ -965,25 +1094,52 @@ static int insert_orphan_item(struct btrfs_trans_handle *trans,
> >  	return ret;
> >  }
> >  
> > +static int count_inode_extrefs(struct btrfs_root *root,
> > +			       struct inode *inode, struct btrfs_path *path)
> > +{
> > +	int ret;
> > +	int name_len;
> > +	unsigned int nlink = 0;
> > +	u32 item_size;
> > +	u32 cur_offset = 0;
> > +	u64 inode_objectid = btrfs_ino(inode);
> > +	u64 offset = 0;
> > +	unsigned long ptr;
> > +	struct btrfs_inode_extref *extref;
> > +	struct extent_buffer *leaf;
> >  
> > -/*
> > - * There are a few corners where the link count of the file can't
> > - * be properly maintained during replay.  So, instead of adding
> > - * lots of complexity to the log code, we just scan the backrefs
> > - * for any file that has been through replay.
> > - *
> > - * The scan will update the link count on the inode to reflect the
> > - * number of back refs found.  If it goes down to zero, the iput
> > - * will free the inode.
> > - */
> > -static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
> > -					   struct btrfs_root *root,
> > -					   struct inode *inode)
> > +	while (1) {
> > +		ret = btrfs_find_one_extref(root, inode_objectid, offset, path,
> > +					    &extref, &offset);
> > +		if (ret)
> > +			break;
> 
> Still looking strange. We should ask harder for an answer here.
> 
> On Fri, May 04, 2012 at 01:12 (+0200), Mark Fasheh wrote:
> > > Assume the first call to btrfs_find_ione_extref returns -EIO. Do we
> > > really want count_inode_extrefs return 0 here? I agree that the previous
> > > code suffers from the same problem, but still: it's a problem.
> > Yeah as you note, I'm just keeping the same behavior as before. This I think
> > is probably a question for Chris...
> 
> To me it seems the best choice would be to return a negative value on error and
> check for that in the caller.

There's no good back out as far as I can tell. You really want this changed
so I went ahead and did it your way. What will happen now is that the
BUG_ON(ret) in fixup_inode_link_counts() will get triggered. This diverges
from how count_inode_refs() handles the error (it doesn't). I don't think changing
count_inode_refs() is in the scope of a patch to introduce extended refs so
I did not touch it.

IMHO, the problem of handling errors where it's very difficult to back out
is bigger than this one tiny function, and I don't want to try to solve it
any more than what we've done already.


Btw, the rest of your review comments have been addressed AFAICT. I should be
sending patches to the list very soon for more review :)

Thanks,
	--Mark

--
Mark Fasheh
