Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35835 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbeILEv4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 00:51:56 -0400
Subject: Re: [PATCH] btrfs-progs: dump-tree: Introduce --breadth-first option
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180823073107.17016-1-wqu@suse.com>
 <2d6c65be-6b54-95d7-29a7-fa24f98989fb@suse.com>
 <26f5f933-7b8d-40e8-16bb-5269867bbc71@gmx.com>
 <b881113c-197e-76d0-7c44-73f8ae598dab@gmx.com>
 <20180911155208.GE2154@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bdadc6a0-b220-cfdc-f140-869c0322689f@gmx.com>
Date: Wed, 12 Sep 2018 07:50:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180911155208.GE2154@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/11 下午11:52, David Sterba wrote:
> On Tue, Sep 04, 2018 at 08:39:55PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018/8/23 下午3:45, Qu Wenruo wrote:
>>>
>>>
>>> On 2018/8/23 下午3:36, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 23.08.2018 10:31, Qu Wenruo wrote:
>>>>> Introduce --breadth-first option to do breadth-first tree dump.
>>>>> This is especially handy to inspect high level trees, e.g. comparing
>>>>> tree reloc tree with its source tree.
>>>>
>>>> Will it make sense instead of exposing another option to just have a
>>>> heuristics check that will switch to the BFS if the tree is higher than,
>>>> say, 2 levels?
>>>
>>> BFS has one obvious disadvantage here, so it may not be a good idea to
>>> use it for default.
>>
>> Well, this is only true for my implementation.
>>
>> But there are other solutions to do BFS without that heavy memory usage.
>>
>>>
>>>>> More memory usage <<
>>>    It needs to alloc heap memory, and this can be pretty large for
>>>    leaves.
>>>    At level 1, it will need to alloc nr_leaves * sizeof(bfs_entry)
>>>    memory at least.
>>>    Compared to DFS, it only needs to iterate at most 8 times, and all of
>>>    its memory usage is function call stack memory.
>>>
>>> It only makes sense for my niche use case (compare tree reloc tree with
>>> its source).
>>> For real world use case the default DFS should works fine without all
>>> the memory allocation burden.
>>
>> Since we have btrfs_path to show where our parents are, it's possible to
>> use btrfs_path and avoid current memory burden.
>>
>> And in that case, your idea of using BFS default for tree higher than 2
>> levels completely make sense.
> 
> No such games please, keep the default predictable.

The problem I found using dump-tree for high trees is, default dfs is
rather unpredictable.

For 2 level trees, it's pretty OK as it's the same as BFS, showing high
level tree blocks first, then leaves.
But for 3 level trees, it's nearly impossible to locate level 1 nodes.

It makes searching for the same level tree blocks pretty hard.

And since the output of each tree block is still the same, changing the
order won't really affect cases using grep.

So, I really like to replace the DFS with BFS.

Thanks,
Qu

> 
> As DFS and BFS are quite well-known abbreviations, I'd rather add 2
> options to set the the mode, ie --dfs and --bfs. Alternatively there
> could be a --traverse=bfs --traverse=dfs but for now I think the two
> options should be sufficient.
> 
