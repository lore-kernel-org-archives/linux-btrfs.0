Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60887 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbbIKPX3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 11:23:29 -0400
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150911145638.GP8891@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <55F2F1E8.1000001@gmx.com>
Date: Fri, 11 Sep 2015 23:23:20 +0800
MIME-Version: 1.0
In-Reply-To: <20150911145638.GP8891@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年09月11日 22:56, David Sterba 写道:
> On Thu, Sep 10, 2015 at 10:34:13AM +0800, Qu Wenruo wrote:
>> Again the buggy btrfs-convert, even David tried to ban mixed-bg features
>> for btrfs-convert, it will still put data and metadata extents into the
>> same chunk, without marking the chunk mixed.
>>
>> So in the patchset, first add fsck support for such problem, and then
>> force btrfs-convert to use mixed block group.
>
> I don't think this is a good option for now.

I'm OK with the decision not to force mixed bg right now.
As you mentioned, it should be better to do it until we fix the whole 
problem.

> People convert
> many-terabytes filesystems.Unless there's a way how to convert such
> filesystem to the split data/metadata type I don't want to force mixed
> bg to convert.

But even for case of TB convert, I'm not sure if that will be a good 
idea to use sperate data/metadata chunk.
Even for ext4, I'm not sure if it does store extents/metadata in a good 
manaer.
IIRC, ext* will allocate space from the middle of free space to avoid 
fragment. (I'm not familiar with ext* anyway, so I can be totally wrong)
So ext* may cause a lot of small holes in its free space.

And for convert, all ext* data and metadata must be covered by btrfs 
DATA chunk, and then restore btrfs metadata into the resting space.
Either causing tons of small metadata chunks between scatterd data 
chunks, or almost no space left for metadata.

So IMHO, for converted case, mixed bg would be a quite good and generic 
choice.

> The bug you describe is there, but I wonder why didn't
> we notice problems that arise from it.

Personally speaking, COW nature of btrfs is doing a quite good job to 
hide the bug, and even self healing.

For metadata in non-mixed DATA chunk, for read case, kernel won't detect 
anything wrong as long as it can pass the generation/csum/backref check.

For writting metadata in non-mixed DATA chunk, COW will alloc new tree 
block from METADATA chunk.
And if we have enough metadata operation, the problem will just 
disappear after all metadata is COWed.

Only some corner case will trigger a WARNING or BUG.

We can add some extra check in check_tree_block() to check such case, 
but I think it will bring a bad impact on performance.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
