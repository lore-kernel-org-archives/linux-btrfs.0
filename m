Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61135 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754270AbcDFFW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 01:22:57 -0400
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160322133812.GK8095@twin.jikos.cz> <56F1FEAF.2070806@cn.fujitsu.com>
 <20160324134217.GP29764@twin.jikos.cz> <56F496AA.9000102@cn.fujitsu.com>
 <20160404165517.GD3412@twin.jikos.cz>
 <CAD=QJKjvKVZTdqVVZJGtve+9teRXgGpv4chY_NV7P5BuFwB1Gw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57049D24.80300@cn.fujitsu.com>
Date: Wed, 6 Apr 2016 13:22:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjvKVZTdqVVZJGtve+9teRXgGpv4chY_NV7P5BuFwB1Gw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Nicholas D Steeves wrote on 2016/04/05 23:47 -0400:
> On 4 April 2016 at 12:55, David Sterba <dsterba@suse.cz> wrote:
>>>>> Not exactly. If we are using unsafe hash, e.g MD5, we will use MD5 only
>>>>> for both in-memory and on-disk backend. No SHA256 again.
>>>>
>>>> I'm proposing unsafe but fast, which MD5 is not. Look for xxhash or
>>>> murmur. As they're both order-of-magnitutes faster than sha1/md5, we can
>>>> actually hash both to reduce the collisions.
>>>
>>> Don't quite like the idea to use 2 hash other than 1.
>>> Yes, some program like rsync uses this method, but this also involves a
>>> lot of details, like the order to restore them on disk.
>>
>> I'm considering fast-but-unsafe hashes for the in-memory backend, where
>> the speed matters and we cannot hide the slow sha256 calculations behind
>> the IO (ie. no point to save microseconds if the IO is going to take
>> milliseconds).
>>
>>>>> In that case, for MD5 hit case, we will do a full byte-to-byte
>>>>> comparison. It may be slow or fast, depending on the cache.
>>>>
>>>> If the probability of hash collision is low, so the number of needed
>>>> byte-to-byte comparisions is also low.
>
> It is unlikely that I will use dedupe, but I imagine your work will
> apply tot he following wishlist:
>
> 1. Allow disabling of memory-backend hash via a kernel argument,
> sysctl, or mount option for those of us have ECC RAM.
>      * page_cache never gets pushed to swap, so this should be safe, no?

Why not use current ioctl to disable dedupe?

And why it's related to ECC RAM? To avoid memory corruption which will 
finally lead to file corruption?
If so, it makes sense.

Also I didn't get the point when you mention page_cache.
For hash pool, we didn't use page cache. We just use kmalloc, which 
won't be swapped out.
For file page cache, it's not affected at all.


> 2. Implementing an intelligent cache so that it's possible to offset
> the cost of hashing the most actively read data.  I'm guessing there's
> already some sort of weighed cache eviction algorithm in place, but I
> don't yet know how to look into it, let alone enough to leverage it...

I not quite a fan of such intelligent but complicated cache design.
The main problem is we are putting police into kernel space.

Currently, either use last-recent-use in-memory backend, or use all-in 
ondisk backend.
For user want more precious control on which file/dir shouldn't go 
through dedupe, they have the btrfs prop to set per-file flag to avoid 
dedupe.

>      * on the topic of leaning on the cache, I've been thinking about
> ways to optimize reads, while minimizing seeks on multi-spindle raid1
> btrfs volumes.  I'm guessing that someone will commit a solution
> before I manage to teach myself enough about filesystems to contribute
> something useful.
>
> That's it, in terms of features I want ;-)
>
> It's probably a well-known fact, but sha512 is roughly 40 to 50%
> faster than sha256, and 40 to 50% slower than sha1 on my 1200-series
> Xeon v3 (Haswell), for 8192 size blocks.

Sadly I didn't know it until recent days. :(
Or I would have implemented SHA512 hash algorithm instead SHA256.

Anyway, it's not that hard to add a new hash algorithm.

Thanks for your comments.
Qu

>
> Wish I could do more right now!
> Nicholas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


