Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35967 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753581AbdEZSOF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 14:14:05 -0400
Date: Fri, 26 May 2017 20:13:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] Btrfs: add a helper to retrive extent inline ref type
Message-ID: <20170526181305.GJ30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
 <20170526002631.8546-2-bo.li.liu@oracle.com>
 <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cb0f4c50-3871-b688-161a-912628f7dcdb@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 10:09:54AM +0300, Nikolay Borisov wrote:
> 
> 
> On 26.05.2017 03:26, Liu Bo wrote:
> > An invalid value of extent inline ref type may be read from a
> > malicious image which may force btrfs to crash.
> > 
> > This adds a helper which does sanity check for the ref type, so we can
> > know if it's sane, return type if so, otherwise return an error.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/ctree.h       |  4 ++++
> >  fs/btrfs/extent-tree.c | 35 +++++++++++++++++++++++++++++++++++
> >  2 files changed, 39 insertions(+)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index c411590..206ae8c 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -2542,6 +2542,10 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
> >  
> >  /* extent-tree.c */
> >  
> > +int btrfs_get_extent_inline_ref_type(struct extent_buffer *eb,
> > +				     struct btrfs_extent_inline_ref *iref,
> > +				     int is_data);
> > +
> >  u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
> >  
> >  static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index be54776..fba8ca0 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -1117,6 +1117,41 @@ static int convert_extent_item_v0(struct btrfs_trans_handle *trans,
> >  }
> >  #endif
> >  
> > +/*
> > + * is_data == 0, tree block type is required,
> > + * is_data == 1, data type is requried,
> > + * is_data == 2, either type is OK.
> > + */
> 
> Can you change those numbers to either #defines or better an enum type?
> Looking at one call site the last argument being a number says nothing
> and one has to context switch to the function definition. E.g. from
> patch2 :
> 
> *out_type = btrfs_get_extent_inline_ref_type(eb, *out_eiref, 2);
> 
> possible names:
> 
> BTRFS_BLOCK_REF_TYPE
> BTRFS_DATA_REF_TYPE
> BTRFS_ANY_TYPE

Can we please keep the namespace, BTRFS_ANY_TYPE is way too generic.

Suggested: BTRFS_REF_TYPE_BLOCK, BTRFS_REF_TYPE_DATA,
BTRFS_REF_TYPE_ANY.
