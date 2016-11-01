Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965174AbcKABVZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 21:21:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3714ABC3
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Nov 2016 01:21:22 +0000 (UTC)
Date: Tue, 1 Nov 2016 02:21:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: repair: Trickle down EEXISTS while freeing
Message-ID: <20161101012121.GU12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161027180508.8721-1-rgoldwyn@suse.de>
 <20161028144202.GH12522@twin.jikos.cz>
 <211e0109-1ce7-44fd-1e73-a1f1a96c44e2@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <211e0109-1ce7-44fd-1e73-a1f1a96c44e2@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 01:43:20PM -0500, Goldwyn Rodrigues wrote:
> Hi David,
> 
> On 10/28/2016 09:42 AM, David Sterba wrote:
> > On Thu, Oct 27, 2016 at 01:05:08PM -0500, Goldwyn Rodrigues wrote:
> >> While deleting pending extents, we insert extents to the 
> >> extent_tree. However, because of corruption, this might already be
> >> freed. We trickle the EEXISTS error and let the caller decide what
> >> needs to be done with it. In this case, ignore, so the repair may
> >> proceed.
> >> 
> >> The primary motivation of this is to resolve this BUG_ON: 
> >> extent-tree.c:2731: alloc_reserved_tree_block: Assertion `ret`
> >> failed, value 0
> >> 
> >> #2  assert_trace (val=0, line=2728, func=0x489510 <__func__.11558>
> >> "alloc_reserved_tree_block", filename=0x489065 "extent-tree.c",
> >> assertion=0x48cfb5 "ret") at kerncompat.h:102 #3
> >> alloc_reserved_tree_block (trans=trans@entry=0x7e7240,
> >> root=root@entry=0x6a88a0, root_objectid=2, generation=175654,
> >> flags=0, key=key@entry=0x2bc5c70, level=0,
> >> ins=ins@entry=0x7fffffffcf30) at extent-tree.c:2728 #4
> >> finish_current_insert (trans=trans@entry=0x7e7240,
> >> extent_root=extent_root@entry=0x6a88a0) at extent-tree.c:2108 #5
> >> __free_extent (trans=trans@entry=0x7e7240,
> >> root=root@entry=0x6a88a0, bytenr=57127387136, num_bytes=<optimized
> >> out>, parent=parent@entry=0, root_objectid=<optimized out>,
> >> owner_objectid=0, owner_offset=owner_offset@entry=0,
> >> refs_to_drop=refs_to_drop@entry=1) at extent-tree.c:2410 #6
> >> del_pending_extents (trans=trans@entry=0x7e7240,
> >> extent_root=0x6a88a0) at extent-tree.c:2448
> > 
> > Do you have a reproducer for that?
> 
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > Applied, thanks.
> > 
> 
> While working on a reproducer (and further testing), I found this leaves
> the tree in a worse condition than before. Please leave this out for now.

Done, thanks for letting me know.
