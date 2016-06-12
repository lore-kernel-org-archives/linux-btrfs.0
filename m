Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:56829 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932081AbcFLSlG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 14:41:06 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] Btrfs-progs: add check-only option for balance
References: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
 <575B2760.30109@mendix.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Ashish Samant <ashish.samant@oracle.com>, linux-btrfs@vger.kernel.org
Cc: bo.li.liu@oracle.com
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cbd07ef0-83ba-e8af-fe6c-2ed5689965c2@inwind.it>
Date: Sun, 12 Jun 2016 20:41:01 +0200
MIME-Version: 1.0
In-Reply-To: <575B2760.30109@mendix.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

On 2016-06-10 22:47, Hans van Kranenburg wrote:
>> +        if (sk->min_objectid < sk->max_objectid) 
>> + 		sk->min_objectid += 1;
> 
> ...and now it's (289406977 168 19193856), which means you're
> continuing your search *after* the block group item!
> 
> (289406976 168 19193856) is actually (289406976 << 72) + (168 << 64) 
> + 19193856, which is 1366685806470112827871857008640
> 
> The search is continued at 1366685811192479310741502222336, which
> skips 4722366482869645213696 possible places where an object could
> live in the tree.

I am not sure to follow you. The extent tree (the tree involved in the search), contains only two kind of object:

- BLOCK_GROUP_ITEM  where the key means (logical address, 0xc0, size in bytes) 
- EXTENT_ITEM, where the key means (logical address, 0xa8, size in bytes) 

So it seems that for each (possible) "logical address", only two items might exist; the two item are completely identified by (objectid, type, ). It should not possible (for the extent tree) to have two item with the same objectid,key and different offset.
So, for the extent tree, it is safe to advance only the objectid field.

I am wrong ?

BR

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
