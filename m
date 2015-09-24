Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41817 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756147AbbIXBS7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 21:18:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 0/4] Fix for btrfs-convert chunk type and fsck support
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1441852458-10289-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150911145638.GP8891@twin.jikos.cz>
Message-ID: <56034F7B.5050107@cn.fujitsu.com>
Date: Thu, 24 Sep 2015 09:18:51 +0800
MIME-Version: 1.0
In-Reply-To: <20150911145638.GP8891@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

After some ext* lecture given by my teammate, Wang Xiaoguang, I'm more 
convinced that, at least for convert from ext*, separate chunk type will 
not be a good idea.

[[Ext* file system struct]]

Unlike pure extent based file, ext* is block group based.
0		128M		256M		384M	...
| Group 0       | Group 1	| Group 2	|       ...

And in each group, the beginning part is always taken by its metadata.

So even for a empty group, it will have some used space:
For Group 1:
128M   128+4M				256M
|\\\\\\|				|

Fro Group 0, it has journal taken more space at beginning, for about 30+M.

So even for newly created ext4 fs, its available space map will be like 
the fowlloing:
0		128M		256M		384M	...
|\\\\|		|\\|		|\\|		|\\|	...

For separate chunk type, we must ensure all above used space be covered 
by DATA chunk.
On the other hand, we must alloc other METADATA/DATA chunk for btrfs 
metadata/data.

So the bad news is, if we follow that behavior, we will end up 
allocating at most 100+M metadata chunk.

For above almost empty ext4 case, it will cause less problem, as
we can batch several groups and put a large data chunk to cover them,
then allocate a 100+M metadata chunk.

0		128M		256M		384M	...
|\\\\|		|\\|		|\\|		|\\|	...
|<-----------DATA------------------->|<--META-->|
     (256 + 16)			       (128-16)

But if the filesystem is used and most group only has scattered 
available space, we may ended up unable to alloc any metadata chunk.

This will make the usage of limited block group quite limited.
Although I'll continue add such support for btrfs-convert, I'm quite 
concerned about the usage...

Thanks,
Qu

David Sterba wrote on 2015/09/11 16:56 +0200:
> On Thu, Sep 10, 2015 at 10:34:13AM +0800, Qu Wenruo wrote:
>> Again the buggy btrfs-convert, even David tried to ban mixed-bg features
>> for btrfs-convert, it will still put data and metadata extents into the
>> same chunk, without marking the chunk mixed.
>>
>> So in the patchset, first add fsck support for such problem, and then
>> force btrfs-convert to use mixed block group.
>
> I don't think this is a good option for now. People convert
> many-terabytes filesystems. Unless there's a way how to convert such
> filesystem to the split data/metadata type I don't want to force mixed
> bg to convert. The bug you describe is there, but I wonder why didn't
> we notice problems that arise from it.
>
