Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33833 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaJ1NIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 09:08:42 -0400
Date: Tue, 28 Oct 2014 14:08:39 +0100
From: Petr Janecek <janecek@ucw.cz>
To: Filipe Manana <fdmanana@suse.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race that makes btrfs_lookup_extent_info miss
 skinny extent items
Message-ID: <20141028130839.GC24064@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>On Mon, 27 Oct 2014 13:44:22 +0000, Filipe David Manana wrote:
>> On Mon, Oct 27, 2014 at 12:11 PM, Filipe David Manana
>> <fdmanana@gmail.com> wrote:
>>> On Mon, Oct 27, 2014 at 11:08 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>>>> On Mon, 27 Oct 2014 09:19:52 +0000, Filipe Manana wrote:
>>>>> We have a race that can lead us to miss skinny extent items in the function
>>>>> btrfs_lookup_extent_info() when the skinny metadata feature is enabled.
>>>>> So basically the sequence of steps is:
>>>>>
>>>>> 1) We search in the extent tree for the skinny extent, which returns > 0
>>>>>    (not found);
>>>>>
>>>>> 2) We check the previous item in the returned leaf for a non-skinny extent,
>>>>>    and we don't find it;
>>>>>
>>>>> 3) Because we didn't find the non-skinny extent in step 2), we release our
>>>>>    path to search the extent tree again, but this time for a non-skinny
>>>>>    extent key;
>>>>>
>>>>> 4) Right after we released our path in step 3), a skinny extent was inserted
>>>>>    in the extent tree (delayed refs were run) - our second extent tree search
>>>>>    will miss it, because it's not looking for a skinny extent;
>>>>>
>>>>> 5) After the second search returned (with ret > 0), we look for any delayed
>>>>>    ref for our extent's bytenr (and we do it while holding a read lock on the
>>>>>    leaf), but we won't find any, as such delayed ref had just run and completed
>>>>>    after we released out path in step 3) before doing the second search.
>>>>>
>>>>> Fix this by removing completely the path release and re-search logic. This is
>>>>> safe, because if we seach for a metadata item and we don't find it, we have the
>>>>> guarantee that the returned leaf is the one where the item would be inserted,
>>>>> and so path->slots[0] > 0 and path->slots[0] - 1 must be the slot where the
>>>>> non-skinny extent item is if it exists. The only case where path->slots[0] is
>>>>
>>>> I think this analysis is wrong if there are some independent shared ref metadata for
>>>> a tree block, just like:
>>>> +------------------------+-------------+-------------+
>>>> | tree block extent item | shared ref1 | shared ref2 |
>>>> +------------------------+-------------+-------------+
>> 
>> Trying to guess what's in your mind.
>> 
>> Is the concern that if after a non-skinny extent item we have
>> non-inlined references, the assumption that path->slots[0] - 1 points
>> to the extent item would be wrong when searching for a skinny extent?
>> 
>> That wouldn't be the case because BTRFS_EXTENT_ITEM_KEY == 168 and
>> BTRFS_METADATA_ITEM_KEY == 169, with BTRFS_SHARED_BLOCK_REF_KEY ==
>> 182. So in the presence of such non-inlined shared tree block
>> reference items, searching for a skinny extent item leaves us at a
>> slot that points to the first non-inlined ref (regardless of its type,
>> since they're all > 169), and therefore path->slots[0] - 1 is the
>> non-skinny extent item.
> 
> You are right. I forget to check the value of key type. Sorry.
> 
> This patch seems good for me.

  This patch seems to fix https://bugzilla.kernel.org/show_bug.cgi?id=64961
for me: I've been testing it together with
[PATCH] Btrfs: fix invalid leaf slot access in btrfs_lookup_extent()
on top of 3.18-rc2 since yesterday, and so far no crashes during balance
or device remove.


Thanks,

Petr
