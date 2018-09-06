Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38406 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeIFPup (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Sep 2018 11:50:45 -0400
Date: Thu, 6 Sep 2018 13:15:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Don't trace subtree if we're dropping
 tree reloc tree
Message-ID: <20180906111529.GY24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180905050339.5356-1-wqu@suse.com>
 <20180905131146.GX24025@twin.jikos.cz>
 <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c0767f62-5356-af80-c5b4-2e97be62e730@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 06, 2018 at 09:41:14AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/9/5 下午9:11, David Sterba wrote:
> > On Wed, Sep 05, 2018 at 01:03:39PM +0800, Qu Wenruo wrote:
> >> Tree reloc tree doesn't contribute to qgroup numbers, as we have
> > 
> > I think you can call it just 'reloc tree', I'm fixing that in all
> > changelogs and comments anyway.
> 
> But there is another tree called data reloc tree.
> That why I'm sticking to tree reloc tree to distinguish from data reloc
> tree.

So call it 'reloc tree' and 'data reloc tree', the naming of
BTRFS_TREE_RELOC_OBJECTID does not follow the other tree naming and I
don't know if the inention was to name it after the 'tree log' scheme or
the 'extent tree'. Or if there was an intention behind the naming at
all.

If this is going to bother us too much, I won't mind renaming it to
BTRFS_RELOC_TREE_OBJECTID everywhere. For consistency.

> >> accounted them at balance time (check replace_path()).
> >>
> >> Skip such unneeded subtree trace should reduce some performance
> >> overhead.
> > 
> > Please provide some numbers or description of the improvement. There are
> > several performance problems caused by qgroups so it would be good to
> > get a better idea how much this patch is going to help. Thanks.
> 
> That's the problem.
> For my internal test, with 3000+ tree blocks, metadata balance could
> save about 1~2%.
> But according to dump-tree, the tree layout is almost the worst case
> scenario, just one metadata block group owns all the tree blocks.

If you do such test, it's also a good example for the changelog. It
describes the worst case and this information can be used to prepare
testing environment on large data samples.
