Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54418 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbbIJAul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 20:50:41 -0400
Subject: Re: Btrfs progs release 4.1
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <20150622150023.GX6761@twin.jikos.cz>
 <55EF8CBD.3020105@cn.fujitsu.com> <55EFA661.2050102@cn.fujitsu.com>
 <20150909132544.GH8891@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F0D3DC.5090901@cn.fujitsu.com>
Date: Thu, 10 Sep 2015 08:50:36 +0800
MIME-Version: 1.0
In-Reply-To: <20150909132544.GH8891@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/09/09 15:25 +0200:
> On Wed, Sep 09, 2015 at 11:24:17AM +0800, Qu Wenruo wrote:
>> The problem is that, for converted image, it's quite possible that data
>> and metadata extent are stored in one chunk even the chunk is not mixed.
>>
>> I'll add fsck support for it soon.
>
> That would be great, I have no idea how the data/metadata can get mixed.
> Does this involve inlied file data that come from ext4?
>
Not completely sure yet, but in my case, I didn't put any data into the 
ext4 fs, just newly created one and convert.
And no inline data extent in converted btrfs, checked by debug-tree.

So I think the problem is the chunk allocation algorithm for btrfs-convert.
The algorithm just doesn't check whether the allocated chunk will cover 
ext* data or not, and determine chunk type by a strange data/metadata 
threshold.

To fix it, we'd better rework the algorithm to add more flexibility to 
handle scattered ext* data.
But at the bottom line, every ext* used space should be covered by DATA 
chunk.

Like the following case:
0		1G		2G		3G
|//|		|///|	|//| |//|
Here For range 0~1G, the beginning is some ext* data, but doesn't take 
too much space.
And in range 1G~2G, some ext* extents are scattered there.
Lastly 2G~3G is not used.

For 0~1G, we only need to ensure the beginning part(including the ext* 
range) be covered by a data chunk, the resting part can be either 
allocated for metadata or data of newer btrfs chunk.

For 1G~2G, better to allocate the whole 1G into data chunk, as too many 
scattered ext* space.
For 2G~3G, either DATA or METADATA is OK for further allocation.

But for now, as a hot fix, I prefer the quick but dirty fix that I 
already submitted, just to force btrfs-convert to use mixed-bg patchset
(with fsck support).

The roadmap for convert fix will follow then:
1) Add kernel balance support to convert mixed-bg.
    Seems easier than 2) for me.
2) Add btrfs-convert support to use correct non mixed-bg mode.


But I'm still not sure about whether the bug mail list reported is 
related to the bug we exposed.

Thanks,
Qu
