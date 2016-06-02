Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbcFBAiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 20:38:11 -0400
Subject: Re: [PATCH] btrfs-progs: convert: Insert needed holes for superblock
 migration
To: <dsterba@suse.cz>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20160601082943.10364-1-quwenruo@cn.fujitsu.com>
 <20160601134949.GZ29147@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <6893954b-48d9-21c9-9e65-59821de855fa@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 08:38:03 +0800
MIME-Version: 1.0
In-Reply-To: <20160601134949.GZ29147@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 09:49 PM, David Sterba wrote:
> On Wed, Jun 01, 2016 at 04:29:43PM +0800, Qu Wenruo wrote:
>> New convert doesn't insert holes for superblock migration range.
>>
>> Unlike old design, which only relocate 4K(superblock size) to other
>> places.
>> In new design, to make sure convert can handle different page size and
>> align chunk bytenr, we relocate the whole 64K range.
>
> This looks like a potential backward compatibility problem. In the
> unlikely scenario, mixing old and new convert to do conversion and
> rollback. Did you try that?

Tried, old convert + new rollback is fine.
Although for new convert + old rollback, it may fail to rollback some 
converted case.

But I didn't consider new convert + old rollback will be a normal use case.

For old converted fs, it's pretty strict for may_rollback().
Almost all ext2 image file extent must be 1:1 mapped, except the first 
1M and backup superblocks.

While for new convert, it exception range is larger, 0~1M is the same, 
while for backup superblocks, its range is extended from 4K to 64K.

So new convert is compatible with old convert and is able to rollback 
old converted fs.

Although old convert can't rollback new converted fs.
>
>> And if there is only a 4K used block inside 64K superblock migration range, it
>> will make converted fs has discontinuous file extents.
>>
>> This patch will fix it by inserting needed holes to avoid such
>> discontinuous error.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> David, I'm very sorry, all these recently exposed bugs are related to
>> superblock migration range, and will only be triggered by special build
>> ext* images(Needs special space range be allocated in ext*)
>>
>> I'll try my best to create the minimal trigger e2image dump, our current
>> image is too large for test cases.
>
> Well, given the amount of last minute fixes I'm now hesitant to do 4.6
> release with this patchset.

I'm really sorry for that.

Thanks,
Qu



