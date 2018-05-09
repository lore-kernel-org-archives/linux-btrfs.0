Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeEIMAN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 08:00:13 -0400
Date: Wed, 9 May 2018 13:57:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: print-tree: Enhance btrfs_print_tree()
 check to avoid out-of-boundary memory access
Message-ID: <20180509115734.GU6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180430031545.29891-1-wqu@suse.com>
 <20180430031545.29891-3-wqu@suse.com>
 <747b3412-e111-8075-20fd-656e76cdb2b0@cn.fujitsu.com>
 <3d5df980-bd16-e28c-f342-922db55f63f2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <3d5df980-bd16-e28c-f342-922db55f63f2@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 30, 2018 at 11:51:19AM +0800, Qu Wenruo wrote:
> >>           btrfs_print_leaf(eb);
> >>           return;
> >>       }
> >> +    /* We are crossing eb boundary, this node must be corrupted */
> >> +    if (nr > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
> >> +        warning(
> >> +        "node nr_items corrupted, has %u limit %u, continue print
> >> anyway",
> >> +            nr, BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb));
> >>       printf("node %llu level %d items %d free %u generation %llu
> >> owner ",
> >>              (unsigned long long)eb->start,
> >>               btrfs_header_level(eb), nr,
> >> @@ -1386,7 +1391,11 @@ void btrfs_print_tree(struct extent_buffer *eb,
> >> int follow)
> >>       print_uuids(eb);
> >>       fflush(stdout);
> >>          
> >> -        u64 blocknr = btrfs_node_blockptr(eb, i);
> >> +        u64 blocknr;
> >> +
> >> +        if (i > BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb))
> >> +            break;
> > 
> > Should it be i >= BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb)?
> 
> BTRFS_NODEPTRS_PER_EXTENT_BUFFER() provides the maximum valid number.
> So it 's >=.
> 
> > 
> > Here BTRFS_NODEPTRS_PER_EXTENT_BUFFER() is called during iterations.
> > The judement can be calculated in advance like:
> > 
> >     ptr_num = BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb);
> >     ...
> >     for (i = 0; i < nr && i < ptr_num  ; i++) {
> 
> Indeed looks better.

Please resend this patch with the suggested updates, thanks.
