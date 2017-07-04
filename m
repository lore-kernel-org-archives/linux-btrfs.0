Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57524 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752430AbdGDRDO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Jul 2017 13:03:14 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A530BAAF2
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Jul 2017 17:03:12 +0000 (UTC)
Date: Tue, 4 Jul 2017 19:02:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, Edmund Nadolski <enadolski@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/13] btrfs: convert prelimary reference tracking to use
 rbtrees
Message-ID: <20170704170201.GF2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-9-enadolski@suse.com>
 <20170627164920.GZ2866@twin.jikos.cz>
 <8365c713-dd8a-6778-401e-45cd0fc43ef0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8365c713-dd8a-6778-401e-45cd0fc43ef0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 05:10:58PM -0400, Jeff Mahoney wrote:
> On 6/27/17 12:49 PM, David Sterba wrote:
> > On Tue, Jun 20, 2017 at 10:06:48AM -0600, Edmund Nadolski wrote:
> >> It's been known for a while that the use of multiple lists
> >> that are periodically merged was an algorithmic problem within
> >> btrfs.  There are several workloads that don't complete in any
> >> reasonable amount of time (e.g. btrfs/130) and others that cause
> >> soft lockups.
> >>
> >> The solution is to use a pair of rbtrees that do insertion merging
> >> for both indirect and direct refs, with the former converting
> >> refs into the latter.  The result is a btrfs/130 workload that
> >> used to take several hours now takes about half of that. This
> >> runtime still isn't acceptable and a future patch will address that
> >> by moving the rbtrees higher in the stack so the lookups can be
> >> shared across multiple calls to find_parent_nodes.
> >>
> >> Signed-off-by: Edmund Nadolski <enadolski@suse.com>
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> >> ---
> >>  fs/btrfs/backref.c | 415 ++++++++++++++++++++++++++++++++++-------------------
> >>  1 file changed, 267 insertions(+), 148 deletions(-)
> >>
> >> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> >> index 0d1e7cb..daae7b6 100644
> >> --- a/fs/btrfs/backref.c
> >> +++ b/fs/btrfs/backref.c
> >> @@ -129,7 +129,7 @@ static int find_extent_in_eb(const struct extent_buffer *eb,
> >>   * this structure records all encountered refs on the way up to the root
> >>   */
> >>  struct prelim_ref {
> >> -	struct list_head list;
> >> +	struct rb_node rbnode;
> >>  	u64 root_id;
> >>  	struct btrfs_key key_for_search;
> >>  	int level;
> >> @@ -139,6 +139,17 @@ struct prelim_ref {
> >>  	u64 wanted_disk_byte;
> >>  };
> >>  
> >> +struct preftree {
> >> +	struct rb_root root;
> >> +};
> >> +
> >> +#define PREFTREE_INIT	{ .root = RB_ROOT }
> >> +
> >> +struct preftrees {
> >> +	struct preftree direct;    /* BTRFS_SHARED_[DATA|BLOCK]_REF_KEY */
> >> +	struct preftree indirect;  /* BTRFS_[TREE_BLOCK|EXTENT_DATA]_REF_KEY */
> >> +};
> >> +
> >>  static struct kmem_cache *btrfs_prelim_ref_cache;
> >>  
> >>  int __init btrfs_prelim_ref_init(void)
> >> @@ -158,6 +169,108 @@ void btrfs_prelim_ref_exit(void)
> >>  	kmem_cache_destroy(btrfs_prelim_ref_cache);
> >>  }
> >>  
> >> +static void release_pref(struct prelim_ref *ref)
> >> +{
> >> +	kmem_cache_free(btrfs_prelim_ref_cache, ref);
> > 
> > This is a bit confusing, 'release' in btrfs code is used to release the
> > resources but not to actually free the memory. See eg.
> > btrfs_release_path and btrfs_free_path. As the helper is trivial and I
> > don't see any other additions to it in the followup patches, I suggest
> > to drop and opencode it.
> 
> I don't mind renaming it to free_pref, but free_pref(ref) is a whole lot
> easier to read and write than the alternative.
> 
> >> @@ -429,38 +560,58 @@ unode_aux_to_inode_list(struct ulist_node *node)
> >>  }
> >>  
> >>  /*
> >> - * resolve all indirect backrefs from the list
> >> + * We maintain two separate rbtrees: one for indirect refs and one for
> >> + * direct refs. Each tree does merge on insertion.  Once all of the
> >> + * refs have been located, we iterate over the indirect ref tree, resolve
> >> + * each reference and remove it from the indirect tree, and then insert
> >> + * the resolved reference into the direct tree, merging there too.
> >> + *
> >> + * New backrefs (i.e., for parent nodes) are added to the direct/indirect
> >> + * rbtrees as they are encountered.  The new, indirect backrefs are
> >> + * resolved as above.
> >>   */
> >>  static int resolve_indirect_refs(struct btrfs_fs_info *fs_info,
> >>  				 struct btrfs_path *path, u64 time_seq,
> >> -				 struct list_head *head,
> >> +				 struct preftrees *preftrees,
> >>  				 const u64 *extent_item_pos, u64 total_refs,
> >>  				 u64 root_objectid)
> >>  {
> >>  	int err;
> >>  	int ret = 0;
> >> -	struct prelim_ref *ref;
> >> -	struct prelim_ref *ref_safe;
> >> -	struct prelim_ref *new_ref;
> >>  	struct ulist *parents;
> >>  	struct ulist_node *node;
> >>  	struct ulist_iterator uiter;
> >> +	struct rb_node *rnode;
> >>  
> >>  	parents = ulist_alloc(GFP_NOFS);
> >>  	if (!parents)
> >>  		return -ENOMEM;
> >>  
> >>  	/*
> >> -	 * _safe allows us to insert directly after the current item without
> >> -	 * iterating over the newly inserted items.
> >> -	 * we're also allowed to re-assign ref during iteration.
> >> +	 * We could trade memory usage for performance here by iterating
> >> +	 * the tree, allocating new refs for each insertion, and then
> >> +	 * freeing the entire indirect tree when we're done.  In some test
> >> +	 * cases, the tree can grow quite large (~200k objects).
> >>  	 */
> >> -	list_for_each_entry_safe(ref, ref_safe, head, list) {
> >> -		if (ref->parent)	/* already direct */
> >> -			continue;
> >> -		if (ref->count == 0)
> >> +	while ((rnode = rb_first(&preftrees->indirect.root))) {
> >> +		struct prelim_ref *ref;
> >> +
> >> +		ref = rb_entry(rnode, struct prelim_ref, rbnode);
> >> +		if (WARN(ref->parent,
> >> +			 "BUG: direct ref found in indirect tree")) {
> > 
> > Is this meant as an assertion or do you expect this could also happen
> > during normal operation?
> 
> This one was mine.
> 
> It's not meant to be countered in normal operation, but I've been trying
> to (and not always succeeding at) taking Linus's advice about gracefully
> recovering from errors rather than crashing.  Our other two tools are
> BUG_ON, which will crash the kernel or ASSERT, which will crash the
> kernel only if the check is enabled and happily break otherwise.

Ok, so WARN is fine here.

> > Overall, the patch appears big but I don't see a good way to split it,
> > only to introduce the helpers separately, not much else seems to be
> > independent.
> 
> Is that a request to split the helpers out or an observation that doing
> so would be the only reason to make it smaller?

That was my impression from the review, if there's more code in one
patch, it takes time to see which parts are important. So if the helpers
are separated out, it (subjectively) reduces the cognitive load. As
there was no clear way how to split the patch it was not a request but a
feedback from the review side.
