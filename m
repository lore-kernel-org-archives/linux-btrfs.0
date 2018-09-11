Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726897AbeIKUwF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:52:05 -0400
Date: Tue, 11 Sep 2018 17:52:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: dump-tree: Introduce --breadth-first option
Message-ID: <20180911155208.GE2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180823073107.17016-1-wqu@suse.com>
 <2d6c65be-6b54-95d7-29a7-fa24f98989fb@suse.com>
 <26f5f933-7b8d-40e8-16bb-5269867bbc71@gmx.com>
 <b881113c-197e-76d0-7c44-73f8ae598dab@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b881113c-197e-76d0-7c44-73f8ae598dab@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 04, 2018 at 08:39:55PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/8/23 下午3:45, Qu Wenruo wrote:
> > 
> > 
> > On 2018/8/23 下午3:36, Nikolay Borisov wrote:
> >>
> >>
> >> On 23.08.2018 10:31, Qu Wenruo wrote:
> >>> Introduce --breadth-first option to do breadth-first tree dump.
> >>> This is especially handy to inspect high level trees, e.g. comparing
> >>> tree reloc tree with its source tree.
> >>
> >> Will it make sense instead of exposing another option to just have a
> >> heuristics check that will switch to the BFS if the tree is higher than,
> >> say, 2 levels?
> > 
> > BFS has one obvious disadvantage here, so it may not be a good idea to
> > use it for default.
> 
> Well, this is only true for my implementation.
> 
> But there are other solutions to do BFS without that heavy memory usage.
> 
> > 
> >>> More memory usage <<
> >    It needs to alloc heap memory, and this can be pretty large for
> >    leaves.
> >    At level 1, it will need to alloc nr_leaves * sizeof(bfs_entry)
> >    memory at least.
> >    Compared to DFS, it only needs to iterate at most 8 times, and all of
> >    its memory usage is function call stack memory.
> > 
> > It only makes sense for my niche use case (compare tree reloc tree with
> > its source).
> > For real world use case the default DFS should works fine without all
> > the memory allocation burden.
> 
> Since we have btrfs_path to show where our parents are, it's possible to
> use btrfs_path and avoid current memory burden.
> 
> And in that case, your idea of using BFS default for tree higher than 2
> levels completely make sense.

No such games please, keep the default predictable.

As DFS and BFS are quite well-known abbreviations, I'd rather add 2
options to set the the mode, ie --dfs and --bfs. Alternatively there
could be a --traverse=bfs --traverse=dfs but for now I think the two
options should be sufficient.
