Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752120AbeAaQOX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:14:23 -0500
Date: Wed, 31 Jan 2018 17:12:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 7/7] btrfs-progs: Cleanup use of root in leaf_data_end
Message-ID: <20180131161210.GF18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
 <1516951566-21777-8-git-send-email-gujx@cn.fujitsu.com>
 <532054be-f016-67e3-93b2-5adcc191bef3@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <532054be-f016-67e3-93b2-5adcc191bef3@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 03:36:28PM +0800, Qu Wenruo wrote:
> On 2018年01月26日 15:26, Gu Jinxiang wrote:
> > In function leaf_data_end, root is just used to get fs_info,
> > so change the parameter of this function from btrfs_root to
> > btrfs_fs_info.
> > And also make it consistent with kernel.
> > 
> > Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> > ---
> >  ctree.c | 32 +++++++++++++++++---------------
> >  1 file changed, 17 insertions(+), 15 deletions(-)
> > 
> > diff --git a/ctree.c b/ctree.c
> > index 11d207e7..2417483d 100644
> > --- a/ctree.c
> > +++ b/ctree.c
> > @@ -410,12 +410,12 @@ static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
> >   * this returns the address of the start of the last item,
> >   * which is the stop of the leaf data stack
> >   */
> > -static inline unsigned int leaf_data_end(struct btrfs_root *root,
> > -					 struct extent_buffer *leaf)
> > +static inline unsigned int leaf_data_end(const struct btrfs_fs_info *fs_info,
> > +					 const struct extent_buffer *leaf)
> 
> Here leaf is const, which is fine.
> 
> >  {
> >  	u32 nr = btrfs_header_nritems(leaf);
> >  	if (nr == 0)
> > -		return BTRFS_LEAF_DATA_SIZE(root->fs_info);
> > +		return BTRFS_LEAF_DATA_SIZE(fs_info);
> >  	return btrfs_item_offset_nr(leaf, nr - 1);
> 
> But btrfs_item_offset_nr() doesn't have const prefix for leaf.
> Leaving the following warning:
> 
> passing argument 1 of ‘btrfs_item_offset_nr’ discards ‘const’ qualifier
> from pointer target type [-Wdiscarded-qualifiers]
>   return btrfs_item_offset_nr(leaf, nr - 1);
>                               ^~~~

I don't want to add the warning, so I'll skip this patch for now. The
constification of arguments will likely propagate to more helpers so
it's not a trivial fix to this patch.

Gu Jinxiang, please fix the warning and resend with possibly more
preparatory cleanups if necessary. Thanks.
