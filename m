From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: check return value of kmalloc()
Date: Fri, 22 Apr 2011 10:23:14 +0900
Message-ID: <4DB0D882.4010207@jp.fujitsu.com>
References: <201104190527.AA00014@T-ITOH1.jp.fujitsu.com> <20110419111240.GV31675@twin.jikos.cz> <4DAE2E12.7060002@jp.fujitsu.com> <20110421121810.GC31675@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110421121810.GC31675@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

(2011/04/21 21:18), David Sterba wrote:
> On Wed, Apr 20, 2011 at 09:51:30AM +0900, Tsutomu Itoh wrote:
>>> 2030        delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
>>
>> I think that it doesn't fail ordinary when __GFP_NOFAIL is specified...
> 
> yes I agree with you, my oversight. However, from linux/gfp.h
> 
>  * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the
>  * caller cannot handle allocation failures.  This modifier is
>  * deprecated and no new users should be added.
> 
> in long-term, redoing without NOFAIL would be probably wise. Currently
> the btrfs_add_delayed_iput is called at places which do not seem to
> like failure, I'm not sure whether possibly blocking indefinetely is
> better than occasional failure with chance to do recovery ...
> 
>>
>>>
>>> and in extent-tree.c:relocate_one_extent()
>>>
>>> 7992        new_extents = kmalloc(sizeof(*new_extents),
>>> 7993                                                 GFP_NOFS);
>>>
>>> the value is checked later, new_extents is passed to get_new_locations
>>> and there it's checked, but no other callers pass potential NULL and the
>>> check fits here and can be dropped from get_new_locations;
> 
>>> there's a
>>> little chance that get_new_locations will be able to succesfully
>>> allocate the same data a jiffy later.
>>
>> Yes, therefore I did not check 'new_extents'.
> 

> heh reading it again after myself, it sounds quite the opposite than I
> wanted: I'd rather see the kmalloc checked right at the callsite, easier
> to read and understand, than diving into get_new_locations and there
> seeing checking extents for NULL and doing own alloc/free.

OK, I understand.
But, reading code again, I noticed nobody use relocate_one_extent() now. ;-)

However, because there is a possibility to be going to be used in the future,
I'll add the check of 'new_extents' for the readability.

Thanks,
Tsutomu
 

> 
> 
> david
> 
> 

