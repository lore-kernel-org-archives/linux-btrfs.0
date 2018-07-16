Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728359AbeGPNnx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 09:43:53 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8074EAD89
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 13:16:27 +0000 (UTC)
Date: Mon, 16 Jul 2018 15:16:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Verify every chunk has corresponding block
 group at mount time
Message-ID: <20180716131622.GI3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-6-wqu@suse.com>
 <20180705151804.GH3126@twin.jikos.cz>
 <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fc9a063d-27d9-dbe7-db6f-b780cf59a6f6@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2018 at 07:44:37AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月05日 23:18, David Sterba wrote:
> > On Tue, Jul 03, 2018 at 05:10:09PM +0800, Qu Wenruo wrote:
> >> If a crafted btrfs has missing block group items, it could cause
> >> unexpected behavior and breaks our expectation on 1:1
> >> chunk<->block group mapping.
> >>
> >> Although we added block group -> chunk mapping check, we still need
> >> chunk -> block group mapping check.
> >>
> >> This patch will do extra check to ensure each chunk has its
> >> corresponding block group.
> >>
> >> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199847
> >> Reported-by: Xu Wen <wen.xu@gatech.edu>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  fs/btrfs/extent-tree.c | 52 +++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 51 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >> index 82b446f014b9..746095034ca2 100644
> >> --- a/fs/btrfs/extent-tree.c
> >> +++ b/fs/btrfs/extent-tree.c
> >> @@ -10038,6 +10038,56 @@ static int check_exist_chunk(struct btrfs_fs_info *fs_info, u64 start, u64 len,
> >>  	return ret;
> >>  }
> >>  
> >> +/*
> >> + * Iterate all chunks and verify each of them has corresponding block group
> >> + */
> >> +static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
> >> +{
> >> +	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> >> +	struct extent_map *em;
> >> +	struct btrfs_block_group_cache *bg;
> >> +	u64 start = 0;
> >> +	int ret = 0;
> >> +
> >> +	while (1) {
> >> +		read_lock(&map_tree->map_tree.lock);
> >> +		em = lookup_extent_mapping(&map_tree->map_tree, start,
> >> +					   (u64)-1 - start);
> > 
> > This needs a comment.
> 
> For the @len part?

Yes, for the expression how it's calculated.

> > 
> >> +		read_unlock(&map_tree->map_tree.lock);
> >> +		if (!em)
> >> +			break;
> >> +
> >> +		bg = btrfs_lookup_block_group(fs_info, em->start);
> >> +		if (!bg) {
> >> +			btrfs_err_rl(fs_info,
> >> +	"chunk start=%llu len=%llu doesn't have corresponding block group",
> >> +				     em->start, em->len);
> >> +			ret = -ENOENT;
> > 
> > -EUCLEAN ?
> 
> Either works for me.

That's not just a cosmetic change, there's a semantic difference between
the error codes, I maybe make that more explicit and not expect that this
is obvious.

ENOENT does not make much sense in this context, the caller (mount in
this case) cannot do anything about a code that says 'some internal
structure not found'.
