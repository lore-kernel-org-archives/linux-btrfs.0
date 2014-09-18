Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15661 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751099AbaIRFgw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 01:36:52 -0400
Message-ID: <541A6F6F.4010901@cn.fujitsu.com>
Date: Thu, 18 Sep 2014 13:36:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to insert
 best fitted extent map
References: <1410926015-26820-1-git-send-email-quwenruo@cn.fujitsu.com> <20140918042113.GA15092@localhost.localdomain>
In-Reply-To: <20140918042113.GA15092@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Fix and enhance merge_extent_mapping() to 
insert best fitted extent map
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年09月18日 12:21
> On Wed, Sep 17, 2014 at 11:53:35AM +0800, Qu Wenruo wrote:
>> The following commit enhanced the merge_extent_mapping() to reduce
>> fragment in extent map tree, but it can't handle case which existing
>> lies before map_start:
>> 51f39 btrfs: Use right extent length when inserting overlap extent map.
>>
>> [BUG]
>> When existing extent map's start is before map_start,
>> the em->len will be minus, which will corrupt the extent map and fail to
>> insert the new extent map.
>> This will happen when someone get a large extent map, but when it is
>> going to insert it into extent map tree, some one has already commit
>> some write and split the huge extent into small parts.
>>
>> [REPRODUCER]
>> It is very easy to tiger using filebench with randomrw personality.
>> It is about 100% to reproduce when using 8G preallocated file in 60s
>> randonrw test.
>>
>> [FIX]
>> This patch can now handle any existing extent position.
>> Since it does not directly use existing->start, now it will find the
>> previous and next extent around map_start.
>> So the old existing->start < map_start bug will never happen again.
>>
>> [ENHANCE]
>> This patch will insert the best fitted extent map into extent map tree,
>> other than the oldest [map_start, map_start + sectorsize) or the
>> relatively newer but not perfect [map_start, existing->start).
>>
>> The patch will first search existing extent that does not intersects with
>> the desired map range [map_start, map_start + len).
>> The existing extent will be either before or behind map_start, and based
>> on the existing extent, we can find out the previous and next extent
>> around map_start.
>>
>> So the best fitted extent would be [prev->end, next->start).
>> For prev or next is not found, em->start would be prev->end and em->end
>> wold be next->start.
>>
>> With this patch, the fragment in extent map tree should be reduced much
>> more than the 51f39 commit and reduce an unneeded extent map tree search.
>>
>> Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/inode.c | 79 ++++++++++++++++++++++++++++++++++++++++----------------
>>   1 file changed, 57 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 016c403..8039021 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -6191,21 +6191,60 @@ out_fail_inode:
>>   	goto out_fail;
>>   }
>>   
>> +/* Find next extent map of a given extent map, caller needs to ensure locks */
>> +static struct extent_map *next_extent_map(struct extent_map *em)
>> +{
>> +	struct rb_node *next;
>> +
>> +	next = rb_next(&em->rb_node);
>> +	if (!next)
>> +		return NULL;
>> +	return container_of(next, struct extent_map, rb_node);
>> +}
>> +
>> +static struct extent_map *prev_extent_map(struct extent_map *em)
>> +{
>> +	struct rb_node *prev;
>> +
>> +	prev = rb_prev(&em->rb_node);
>> +	if (!prev)
>> +		return NULL;
>> +	return container_of(prev, struct extent_map, rb_node);
>> +}
>> +
>>   /* helper for btfs_get_extent.  Given an existing extent in the tree,
>> + * the existing extent is the nearest extent to map_start,
>>    * and an extent that you want to insert, deal with overlap and insert
>> - * the new extent into the tree.
>> + * the best fitted new extent into the tree.
>>    */
>>   static int merge_extent_mapping(struct extent_map_tree *em_tree,
>>   				struct extent_map *existing,
>>   				struct extent_map *em,
>>   				u64 map_start)
>>   {
>> +	struct extent_map *prev;
>> +	struct extent_map *next;
>> +	u64 start;
>> +	u64 end;
>>   	u64 start_diff;
>>   
>>   	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
>> -	start_diff = map_start - em->start;
>> -	em->start = map_start;
>> -	em->len = existing->start - em->start;
>> +
>> +	if (existing->start > map_start) {
>> +		next = existing;
>> +		prev = prev_extent_map(next);
>> +	} else {
>> +		prev = existing;
>> +		next = next_extent_map(prev);
>> +	}
>> +
>> +	start = prev ? extent_map_end(prev) : em->start;
>> +	start = max_t(u64, start, em->start);
>> +	end = next ? next->start : extent_map_end(em);
>> +	end = min_t(u64, end, extent_map_end(em));
>> +	start_diff = start - em->start;
>> +	em->start = start;
>> +	em->len = end - start;
>>   	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
>>   	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
>>   		em->block_start += start_diff;
>> @@ -6482,25 +6521,21 @@ insert:
>>   
>>   		ret = 0;
>>   
>> -		existing = lookup_extent_mapping(em_tree, start, len);
>> -		if (existing && (existing->start > start ||
>> -		    existing->start + existing->len <= start)) {
>> +		existing = search_extent_mapping(em_tree, start, len);
>> +		/*
>> +		 * existing will always be non-NULL, since there must be
>> +		 * extent causing the -EEXIST.
>> +		 */
>> +		if (start >= extent_map_end(existing) ||
>> +		    start + len <= existing->start) {
> This will introduce something wrong, the 'else' part is 'em = existing;',
> and the condition is actually
> (start < extent_map_end(existing) && start + len > existing->start),
> which means the existing overlaps with [start, start+len).
Nope, the else part is doing the right thing.

Before the patch, going to the 'em = existing;' routine's condition is 
like the following:
1) existing returned by lookup_extent_mapping is not NULL
2) (existing->start > start || existing->start + existing->len <=start) 
is not met

1) implies the following condition: (in extent_map.c, 
__lookup_extent_mapping())
!!(end > existing->start && start < extent_map_end(existing)), which is 
equal to the following:
start + len > existing->start(1) && start < extent_map_end(existing) (2)

2) is actually the following
start >= existing->start (3) && start < extent_map_end(existing) (4)

And the hidden condition len > 0(5)
combining 1) and 2), you will find the real condition to go to 'em = 
existing' routine is what the patch does.
Due to (5), (1) and (3) is the same condition, and (2) (4) is the same too.
So the patch is OK. 'em = existing' condition is not broken.

>
> And one of overlapping cases is (existing->start > start), ie. em->start > start, this is
> against our rule of btrfs_get_extent,
Nope again, this overlapping in fact is quite normal in multithread 
random read/write.
The files's [0~16) is a preallocated one,
Thread A:
     write [4K, 8K) into the file, but not committed yet.
     extent map tree contains [0,16K) only
Thread B:
btrfs_get_extent()
     the map_start is 8K, len is 4K as an example
     grab a large em, take [0,16K), since [4K,8K) write is not committed.
     comes to insert: btrfs_release_path(path);

Thread A:
     [4K, 8K) is not committed
     the extent map is now [0, 4K) [4K, 8K) [8K, 16K).

Thread B:
     goes to insert: add_extent_mapping()
     the [0,16K) is overlapping, and the returned existing one is [8K, 16K).
     which contains the [map_start, map_start +  len).

> struct extent_map *btrfs_get_extent(...)
> {
> 	[...]
> 	insert:
> 		btrfs_release_path(path);
> 		if (em->start > start || extent_map_end(em) <= start) {
> 			btrfs_err(root->fs_info, "bad extent! em: [%llu %llu] passed
> 	[%llu %llu]",
> 				em->start, em->len, start, len);
> 			err = -EIO;
>                  goto out;
>          }
>          [...]
> }
>
> thanks,
> -liubo
>
>> +			/*
>> +			 * The existing extent map is the one nearest to
>> +			 * the [start, start + len) range which overlaps
>> +			 */
>> +			err = merge_extent_mapping(em_tree, existing,
>> +						   em, start);
>>   			free_extent_map(existing);
>> -			existing = NULL;
>> -		}
>> -		if (!existing) {
>> -			existing = lookup_extent_mapping(em_tree, em->start,
>> -							 em->len);
>> -			if (existing) {
>> -				err = merge_extent_mapping(em_tree, existing,
>> -							   em, start);
>> -				free_extent_map(existing);
>> -				if (err) {
>> -					free_extent_map(em);
>> -					em = NULL;
>> -				}
>> -			} else {
>> -				err = -EIO;
>> +			if (err) {
>>   				free_extent_map(em);
>>   				em = NULL;
>>   			}
>> -- 
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

