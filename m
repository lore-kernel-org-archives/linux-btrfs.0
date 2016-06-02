Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34122 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbcFBBIb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 21:08:31 -0400
Subject: Re: [PATCH v10 08/21] btrfs: ordered-extent: Add support for dedupe
To: Mark Fasheh <mfasheh@suse.de>
References: <1459492512-31435-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1459492512-31435-9-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601220633.GN7633@wotan.suse.de>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5d04b06d-9d5d-bf8f-d555-8448a699301f@cn.fujitsu.com>
Date: Thu, 2 Jun 2016 09:08:23 +0800
MIME-Version: 1.0
In-Reply-To: <20160601220633.GN7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/02/2016 06:06 AM, Mark Fasheh wrote:
> On Fri, Apr 01, 2016 at 02:34:59PM +0800, Qu Wenruo wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Add ordered-extent support for dedupe.
>>
>> Note, current ordered-extent support only supports non-compressed source
>> extent.
>> Support for compressed source extent will be added later.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  fs/btrfs/ordered-data.c | 44 ++++++++++++++++++++++++++++++++++++++++----
>>  fs/btrfs/ordered-data.h | 13 +++++++++++++
>>  2 files changed, 53 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index 0de7da5..ef24ad1 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -26,6 +26,7 @@
>>  #include "extent_io.h"
>>  #include "disk-io.h"
>>  #include "compression.h"
>> +#include "dedupe.h"
>>
>>  static struct kmem_cache *btrfs_ordered_extent_cache;
>>
>> @@ -184,7 +185,8 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
>>   */
>>  static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>>  				      u64 start, u64 len, u64 disk_len,
>> -				      int type, int dio, int compress_type)
>> +				      int type, int dio, int compress_type,
>> +				      struct btrfs_dedupe_hash *hash)
>>  {
>>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>>  	struct btrfs_ordered_inode_tree *tree;
>> @@ -204,6 +206,31 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
>>  	entry->inode = igrab(inode);
>>  	entry->compress_type = compress_type;
>>  	entry->truncated_len = (u64)-1;
>> +	entry->hash = NULL;
>> +	/*
>> +	 * Hash hit must go through dedupe routine at all cost, even dedupe
>> +	 * is disabled. As its delayed ref is already increased.
>> +	 */
>
> Initially, I had a hard time understanding this comment but I'm pretty sure
> I know what you mean.
>
> /*
>  * A hash hit means we have already incremented the extents delayed ref.
>  * We must handle this even if another process raced to turn off dedupe
>  * otherwise we might leak a reference.
>  */
>
> might be better. Hope that helps.
> 	--Mark
>

Same meaning, much better grammar.

Thanks,
Qu
> --
> Mark Fasheh
>
>


