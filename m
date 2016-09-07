Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34146 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754666AbcIGVal (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 17:30:41 -0400
Date: Wed, 7 Sep 2016 14:36:02 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix BUG_ON in btrfs_mark_buffer_dirty
Message-ID: <20160907213601.GA15742@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <fe9b1bde-9069-b75f-eb53-83b729cde711@suse.com>
 <1472844934-32343-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5oCqgd9im-2AZA=zsOv+SCObon2f5wECA7hr58MNXTGw@mail.gmail.com>
 <20160906215151.GB31641@localhost.localdomain>
 <4c163cdc-e736-55b5-88b2-5d47bcd4f554@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4c163cdc-e736-55b5-88b2-5d47bcd4f554@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On Wed, Sep 07, 2016 at 10:25:54AM -0400, Jeff Mahoney wrote:
> On 9/6/16 5:51 PM, Liu Bo wrote:
> > Hi Filipe,
> > 
> > On Mon, Sep 05, 2016 at 04:28:09PM +0100, Filipe Manana wrote:
> >> On Fri, Sep 2, 2016 at 8:35 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >>> This can only happen with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y.
> >>>
> >>> Commit 1ba98d0 ("Btrfs: detect corruption when non-root leaf has zero item")
> >>> assumes that a leaf is its root when leaf->bytenr == btrfs_root_bytenr(root),
> >>> however, we should not use btrfs_root_bytenr(root) since it's mainly got
> >>> updated during committing transaction.  So the check can fail when doing
> >>> COW on this leaf while it is a root.
> >>>
> >>> This changes to use "if (leaf == btrfs_root_node(root))" instead, just like
> >>> how we check whether leaf is a root in __btrfs_cow_block().
> >>>
> >>> Reported-by: Jeff Mahoney <jeffm@suse.com>
> >>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>
> >> Hi Bo,
> >>
> >> Even with this patch applied against latest branch for-linus-4.8, at
> >> least on a build with CONFIG_BTRFS_FS_CHECK_INTEGRITY=y,
> >> the issue still happens for me when running fsstress with balance in parallel:
> > 
> > Thanks for the report.
> > 
> > This panic shows that we can have non-root btree leaf with 0 nritems during
> > split_leaf(), but a btrfs_search_slot which calls split_leaf() like this is
> > inserting an item, and while we set @right's nritems to 0, we also assign @disk_key
> > associated with @right in the parent node, so I think we're actually having
> >  nritem 0 temporarily and we can remove this btrfs_mark_buffer_dirty() like the
> > following quick patch.
> > 
> > Thanks,
> > 
> > -liubo
> > 
> > diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> > index d1c56c9..5e5ceb5 100644
> > --- a/fs/btrfs/ctree.c
> > +++ b/fs/btrfs/ctree.c
> > @@ -4341,7 +4341,11 @@ again:
> >  			if (path->slots[1] == 0)
> >  				fixup_low_keys(fs_info, path, &disk_key, 1);
> >  		}
> > -		btrfs_mark_buffer_dirty(right);
> > +		/*
> > +		 * We create a new leaf 'right' for the required ins_len and
> > +		 * we'll do btrfs_mark_buffer_dirty() on this leaf after copying
> > +		 * the content of ins_len to 'right'.
> > +		 */
> >  		return ret;
> >  	}
> >  
> > 
> > 
> 
> I think you're on the right track here.  I need to see if I still have
> the code lying around, but when I was debugging the btrfs_rename issue
> that ended up being a compiler bug, I hooked into check_leaf and ran
> into similar issues.  We mark the buffer dirty before it's in a
> consistent state.

That's right.

One thing that I'm not 100% sure is that if there is a
chance that this metadata leaf gets flushed by writeback throttle code
and we panic after it so that we get a 'nritem 0 non-root' leaf, no?

But anyway, even if we have it, we'd know it by the newly added check
in check_leaf.

Thanks,

-liubo
