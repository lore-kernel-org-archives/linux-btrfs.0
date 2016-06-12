Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57177 "EHLO
	syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbcFLSxk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 14:53:40 -0400
Subject: Re: [PATCH] Btrfs-progs: add check-only option for balance
To: kreijack@inwind.it, Ashish Samant <ashish.samant@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
 <575B2760.30109@mendix.com> <cbd07ef0-83ba-e8af-fe6c-2ed5689965c2@inwind.it>
Cc: bo.li.liu@oracle.com
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <575DAFAE.10906@mendix.com>
Date: Sun, 12 Jun 2016 20:53:34 +0200
MIME-Version: 1.0
In-Reply-To: <cbd07ef0-83ba-e8af-fe6c-2ed5689965c2@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

On 06/12/2016 08:41 PM, Goffredo Baroncelli wrote:
> Hi All,
>
> On 2016-06-10 22:47, Hans van Kranenburg wrote:
>>> +        if (sk->min_objectid < sk->max_objectid) +
>>> sk->min_objectid += 1;
>>
>> ...and now it's (289406977 168 19193856), which means you're
>> continuing your search *after* the block group item!
>>
>> (289406976 168 19193856) is actually (289406976 << 72) + (168 <<
>> 64) + 19193856, which is 1366685806470112827871857008640
>>
>> The search is continued at 1366685811192479310741502222336, which
>> skips 4722366482869645213696 possible places where an object could
>> live in the tree.
>
> I am not sure to follow you. The extent tree (the tree involved in
> the search), contains only two kind of object:
>
> - BLOCK_GROUP_ITEM  where the key means (logical address, 0xc0, size
> in bytes)
> - EXTENT_ITEM, where the key means (logical address, 0xa8,
> size in bytes)
>
> So it seems that for each (possible) "logical address", only two
> items might exist; the two item are completely identified by
> (objectid, type, ). It should not possible (for the extent tree) to
> have two item with the same objectid,key and different offset. So,
> for the extent tree, it is safe to advance only the objectid field.
>
> I am wrong ?

When calling the search ioctl, the caller has to provide a memory buffer 
that the kernel is going to fill with results. For BTRFS_IOC_TREE_SEARCH 
used here, this buffer has a fixed size of 4096 bytes. Without some 
headers etc, this leaves a bit less than 4000 bytes of space for the 
kernel to write search result objects to.

If I do a search that will result in far more objects to be returned 
than possible to fit in those <4096 bytes, the kernel will just put a 
few in there until the next one does not fit any more.

It's the responsibility of the caller to change the start of the search 
to point just after the last received object and do the search again, in 
order to retrieve a few extra results.

So, the important line here was: "...when the extent_item just manages 
to squeeze in as last result into the current result buffer from the 
ioctl..."

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
