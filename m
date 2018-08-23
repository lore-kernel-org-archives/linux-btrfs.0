Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:46995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727044AbeHWLNk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 07:13:40 -0400
Subject: Re: [PATCH] btrfs-progs: dump-tree: Introduce --breadth-first option
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180823073107.17016-1-wqu@suse.com>
 <2d6c65be-6b54-95d7-29a7-fa24f98989fb@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <26f5f933-7b8d-40e8-16bb-5269867bbc71@gmx.com>
Date: Thu, 23 Aug 2018 15:45:07 +0800
MIME-Version: 1.0
In-Reply-To: <2d6c65be-6b54-95d7-29a7-fa24f98989fb@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/8/23 下午3:36, Nikolay Borisov wrote:
> 
> 
> On 23.08.2018 10:31, Qu Wenruo wrote:
>> Introduce --breadth-first option to do breadth-first tree dump.
>> This is especially handy to inspect high level trees, e.g. comparing
>> tree reloc tree with its source tree.
> 
> Will it make sense instead of exposing another option to just have a
> heuristics check that will switch to the BFS if the tree is higher than,
> say, 2 levels?

BFS has one obvious disadvantage here, so it may not be a good idea to
use it for default.

>> More memory usage <<
   It needs to alloc heap memory, and this can be pretty large for
   leaves.
   At level 1, it will need to alloc nr_leaves * sizeof(bfs_entry)
   memory at least.
   Compared to DFS, it only needs to iterate at most 8 times, and all of
   its memory usage is function call stack memory.

It only makes sense for my niche use case (compare tree reloc tree with
its source).
For real world use case the default DFS should works fine without all
the memory allocation burden.

So I still prefer to keep DFS as default and only provides BFS as a
niche option for weird guys like me.

Thanks,
Qu
