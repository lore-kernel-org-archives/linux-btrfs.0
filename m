Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31991 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752725AbcD0Ary (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 20:47:54 -0400
Subject: Re: [PATCH] btrfs-progs: fsck: Fix found bytes accounting error
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1461638989-5048-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160426100643.GF29353@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f4cde0b3-ff26-bbb7-4ff3-8dc1974553ff@cn.fujitsu.com>
Date: Wed, 27 Apr 2016 08:47:40 +0800
MIME-Version: 1.0
In-Reply-To: <20160426100643.GF29353@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/04/26 12:06 +0200:
> On Tue, Apr 26, 2016 at 10:49:49AM +0800, Qu Wenruo wrote:
>> In the new add_extent_rec_nolookup() function, we add bytes_used to
>> update found bytes accounting.
>>
>> However there is a typo that we used tmpl->nr, which should be rec->nr.
>> This will make us to add 1 for data backref, instead the correct size.
>
> I'm not able to trace that back to the original code, the value template
> is just filled from the parameters and I don't see where bytes_used
> would get set from the rec->nr value.

Then it would be a very old bug.

When iteration extent tree, when btrfsck found a data backref, it will 
fill tmpl->nr with 1 and max_size with real size.

And if following that code, we increase bytes_used by 1, not max_size.

This makes the final "Found XXX bytes" unaligned to sectorsize.
While not much people will check such output, until we introduce the new 
low-memory mode, and compare the output, finding the difference.

If checked manually (by adding all metadata and extent size from 
debug-tree output), one would find the result is always smaller than 
expected.

>
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -4550,7 +4550,7 @@ static int add_extent_rec_nolookup(struct cache_tree *extent_cache,
>>  	rec->cache.size = tmpl->nr;
>>  	ret = insert_cache_extent(extent_cache, &rec->cache);
>>  	BUG_ON(ret);
>> -	bytes_used += tmpl->nr;
>> +	bytes_used += rec->nr;
>
> ie. this would be just 'nr' before the refactoring.
>
>
Yes, I also checked v4.2 code, it is indeed "nr", so it's a long 
standing bug.

Thanks,
Qu


