Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41060 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbcFWNRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:17:12 -0400
Subject: Re: [RFC][PATCH] btrfs-progs: inspect: new subcommand to dump chunks
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1466616406-28087-1-git-send-email-dsterba@suse.com>
 <376fafee-8baa-2a49-7d77-892ceb419b83@mendix.com>
 <20160623131352.GC4915@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <576BE156.90007@mendix.com>
Date: Thu, 23 Jun 2016 15:17:10 +0200
MIME-Version: 1.0
In-Reply-To: <20160623131352.GC4915@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/23/2016 03:13 PM, David Sterba wrote:
> On Thu, Jun 23, 2016 at 12:20:38AM +0200, Hans van Kranenburg wrote:
>>> Printing 'usage' is not default as it's quite slow, it uses the search ioctl
>>> and probably not in the best way, or there's some other issue in the
>>> implementation.
>>
>> Interesting.
>>
>> So after reading this, I wrote a little test to test some scenarios:
>>
>> https://github.com/knorrie/python-btrfs/commit/1ca99880dfa0e14b148f3d9e2b6b381b781eb52d
>>
>> It's very clear that the most optimal way of doing this search is to
>> have nr_items=1 and if possible, specify the length in offset.
>
> And that solved it.
>
> [...]
>
>> It seems that searching in the empty space between
>>    (vaddr BLOCK_GROUP_ITEM length+1) and
>>    (vaddr BLOCK_GROUP_ITEM ULLONG_MAX)
>> is really expensive, while there's absolutely nothing to find.
>
> Yeah, the few BLOCK_GROUP_ITEMs are scattered among tons of EXTENT_ITEMs

On the same vaddr objectid, there should only be at most one extent, and 
EXTENT_ITEM_KEY < BLOCK_GROUP_ITEM_KEY, so the space after the block 
group item should always contain exactly 0 items?

Still it takes very long...

-- 
Hans van Kranenburg - System / Network Engineer
Mendix | Driving Digital Innovation | www.mendix.com
