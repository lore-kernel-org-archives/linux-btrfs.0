Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44821 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752525AbdJKR6A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:58:00 -0400
Date: Wed, 11 Oct 2017 19:56:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v4 3/5] btrfs: tree-checker: Enhance output for
 btrfs_check_leaf
Message-ID: <20171011175615.GA3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171009015106.9711-1-quwenruo.btrfs@gmx.com>
 <20171009015106.9711-4-quwenruo.btrfs@gmx.com>
 <ddcf3b2b-5c56-055a-4a6d-6bc4ba76d4eb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ddcf3b2b-5c56-055a-4a6d-6bc4ba76d4eb@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 06:41:32PM +0300, Nikolay Borisov wrote:
> 
> 
> On  9.10.2017 04:51, Qu Wenruo wrote:
> > Enhance the output to print:
> > 1) Reason
> > 2) Bad value
> >    If reason can't explain enough
> > 3) Good value (range)
> > 
> > Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
> > ---
> >  fs/btrfs/tree-checker.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> > index b4ced8d3ce2a..7bba195ecc8b 100644
> > --- a/fs/btrfs/tree-checker.c
> > +++ b/fs/btrfs/tree-checker.c
> > @@ -233,8 +233,9 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
> >  			eb = btrfs_root_node(check_root);
> >  			/* if leaf is the root, then it's fine */
> >  			if (leaf != eb) {
> > -				CORRUPT("non-root leaf's nritems is 0",
> > -					leaf, check_root, 0);
> > +				generic_err(check_root, leaf, 0,
> > +					"invalid nritems, have %u shouldn't be 0 for non-root leaf",
> > +					nritems);
> 
> I'm a bit confused by what this error messages wants to convey. Even
> reading the previous version with CORRUPT() it still didn't make sense.
> So what we want to say here is we shouldn't have empty leaf nodes. So
> Something along the line of "Unexpected empty leaf".
> 
> Why would the (leaf != eb) check not trigger, given that we call
> btrfs_check_leaf when we now that the item is a leaf (level is 0 )?

I've merged the patches, with more adjusmtents to the wording, so any
updates please send as separate patches.

> 
> 
> >  				free_extent_buffer(eb);
> >  				return -EUCLEAN;
> >  			}
> > @@ -265,7 +266,11 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
> >  
> >  		/* Make sure the keys are in the right order */
> >  		if (btrfs_comp_cpu_keys(&prev_key, &key) >= 0) {
> > -			CORRUPT("bad key order", leaf, root, slot);
> > +			generic_err(root, leaf, slot,
> > +				"bad key order, prev key (%llu %u %llu) current key (%llu %u %llu)",
> > +				prev_key.objectid, prev_key.type,
> > +				prev_key.offset, key.objectid, key.type,
> > +				key.offset);
> >  			return -EUCLEAN;
> >  		}
> >  
> > @@ -280,7 +285,10 @@ int btrfs_check_leaf(struct btrfs_root *root, struct extent_buffer *leaf)
> >  			item_end_expected = btrfs_item_offset_nr(leaf,
> >  								 slot - 1);
> >  		if (btrfs_item_end_nr(leaf, slot) != item_end_expected) {
> > -			CORRUPT("slot offset bad", leaf, root, slot);
> > +			generic_err(root, leaf, slot,
> > +				"discontinious item end, have %u expect %u",
> 
> s/discontinious/unexpected ?

I've changed that to 'unexpected item end, ...'
