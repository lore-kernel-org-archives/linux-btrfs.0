Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33152 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932621AbdKOPoz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:44:55 -0500
Date: Wed, 15 Nov 2017 16:43:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Filipe Manana <fdmanana@gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: tree-checker: Fix false panic for sanity
 test
Message-ID: <20171115154300.GP28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171108005426.17903-1-wqu@suse.com>
 <20171108005426.17903-2-wqu@suse.com>
 <fabe0bca-372b-699d-c418-42c55c04c539@suse.com>
 <8bf83e81-290d-7568-2d95-6fc7d1f209d2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8bf83e81-290d-7568-2d95-6fc7d1f209d2@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 08, 2017 at 04:03:35PM +0800, Qu Wenruo wrote:
> >> +int btrfs_check_leaf_full(struct btrfs_root *root, struct extent_buffer *leaf)
> >> +{
> >> +	return check_leaf(root, leaf, true);
> >> +}
> >> +
> >> +int btrfs_check_leaf_relaxed(struct btrfs_root *root,
> >> +			     struct extent_buffer *leaf)
> >> +{
> >> +	return check_leaf(root, leaf, false);
> >> +}
> > 
> > Presumably the compiler will figure it out but such trivial function are
> > usually defined straight into the header file so that the compiler
> > inlines them.
> 
> In that case, the function check_leaf() must be exported, so that we can
> inline it in header.
> 
> But exporting check_leaf() increases the possibility for caller to use
> it incorrectly, so I prefer no to export any internal used function.
> 
> 
> And compiler may or may not inline check_leaf() into
> btrfs_check_leaf_relaxed() function, but it doesn't matter.
> 
> If optimization can be done by compiler, then let compiler to do it.
> 
> What we should do is to ensure the abstraction/interface design is good
> enough, other than doing possible "over-optimization".

Though my original idea was closer to what Nikolay says, I'm fine with
the way you've actually implement it. We don't need the extended
check_leaf version that's hidden in the .c file.

The function inlining possibilities will be limited, but this is not a
performance critical code where the effects of inlining could be
observale in practice (I think, no numbers to back that).
