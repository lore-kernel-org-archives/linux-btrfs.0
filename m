Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:58503 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbcCZNMZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 09:12:25 -0400
Subject: Re: [PATCH v8 10/27] btrfs: dedupe: Add basic tree structure for
 on-disk dedupe method
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1458610552-9845-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20160324205807.ctxig7c2r4rfoowp@floor.thefacebook.com>
 <56F49B8B.4000701@cn.fujitsu.com>
 <20160325151124.hhzpyymor6varucx@floor.thefacebook.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56F68A99.8010308@gmx.com>
Date: Sat, 26 Mar 2016 21:11:53 +0800
MIME-Version: 1.0
In-Reply-To: <20160325151124.hhzpyymor6varucx@floor.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/25/2016 11:11 PM, Chris Mason wrote:
> On Fri, Mar 25, 2016 at 09:59:39AM +0800, Qu Wenruo wrote:
>>
>>
>> Chris Mason wrote on 2016/03/24 16:58 -0400:
>>> Are you storing the entire hash, or just the parts not represented in
>>> the key?  I'd like to keep the on-disk part as compact as possible for
>>> this part.
>>
>> Currently, it's entire hash.
>>
>> More detailed can be checked in another mail.
>>
>> Although it's OK to truncate the last duplicated 8 bytes(64bit) for me,
>> I still quite like current implementation, as one memcpy() is simpler.
>
> [ sorry FB makes urls look ugly, so I delete them from replys ;) ]
>
> Right, I saw that but wanted to reply to the specific patch.  One of the
> lessons learned from the extent allocation tree and file extent items is
> they are just too big.  Lets save those bytes, it'll add up.

OK, I'll reduce the duplicated last 8 bytes.

And also, removing the "length" member, as it can be always fetched from 
dedupe_info->block_size.

The length itself is used to verify if we are at the transaction to a 
new dedupe size, but later we use full sync_fs(), such behavior is not 
needed any more.


>
>>
>>>
>>>> +
>>>> +/*
>>>> + * Objectid: bytenr
>>>> + * Type: BTRFS_DEDUPE_BYTENR_ITEM_KEY
>>>> + * offset: Last 64 bit of the hash
>>>> + *
>>>> + * Used for bytenr <-> hash search (for free_extent)
>>>> + * all its content is hash.
>>>> + * So no special item struct is needed.
>>>> + */
>>>> +
>>>
>>> Can we do this instead with a backref from the extent?  It'll save us a
>>> huge amount of IO as we delete things.
>>
>> That's the original implementation from Liu Bo.
>>
>> The problem is, it changes the data backref rules(originally, only
>> EXTENT_DATA item can cause data backref), and will make dedupe INCOMPACT
>> other than current RO_COMPACT.
>> So I really don't like to change the data backref rule.
>
> Let me reread this part, the cost of maintaining the second index is
> dramatically higher than adding a backref.  I do agree that's its nice
> to be able to delete the dedup trees without impacting the rest, but
> over the long term I think we'll regret the added balances.

Thanks for pointing the problem. Yes, I didn't even consider this fact.

But, on the other hand. such remove only happens when we remove the 
*last* reference of the extent.
So, for medium to high dedupe rate case, such routine is not that 
frequent, which will reduce the impact.
(Which is quite different for non-dedupe case)

And for low dedupe rate case, why use dedupe anyway. In that case, 
compression would be much more appropriate if user just wants to reduce 
disk usage IMO.


Another reason I don't want to touch delayed-ref codes is, it already 
has made us quite pain.
We were fighting with delayed-ref from the beginning.
The delayed ref, especially the ability to run delayed refs 
asynchronously, is the biggest problem we met.

And that's why we added ability to increase data ref while holding 
delayed_refs->lock in patch 5, and then uses a long lock-and-try-inc 
method to search hash in patch 6.

Any modification to delayed ref can easily lead to new bugs (Yes, I have 
proved it several times by myself).
So I choose to use current method.

>
>>
>> If only want to reduce ondisk space, just trashing the hash and making
>> DEDUPE_BYTENR_ITEM have no data would be good enough.
>>
>> As (bytenr, DEDEUPE_BYTENR_ITEM) can locate the hash uniquely.
>
> For the second index, the big problem is the cost of the btree
> operations.  We're already pretty expensive in terms of the cost of
> deleting an extent, with dedup its 2x higher, with dedup + extra index,
> its 3x higher.

The good news is, we only delete hash bytenr and its ref at the last 
de-reference.
And in normal (medium to high dedupe rate) case, it's not a frequent 
operation IMHO.

Thanks,
Qu

>
>>
>> In fact no code really checked the hash for dedupe bytenr item, they all
>> just swap objectid and offset, reset the type and do search for
>> DEDUPE_HASH_ITEM.
>>
>> So it's OK to emit the hash.
>
> If we have to go with the second index, I do agree here.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
