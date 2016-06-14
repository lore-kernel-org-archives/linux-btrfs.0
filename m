Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:55068 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932125AbcFNSz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 14:55:57 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] Btrfs-progs: add check-only option for balance
References: <1465508801-14163-1-git-send-email-ashish.samant@oracle.com>
 <575B2760.30109@mendix.com> <cbd07ef0-83ba-e8af-fe6c-2ed5689965c2@inwind.it>
 <575DAFAE.10906@mendix.com> <580d1242-6698-a977-9008-6ac743f205e4@inwind.it>
 <20160614181607.GM5437@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Ashish Samant <ashish.samant@oracle.com>, linux-btrfs@vger.kernel.org,
        bo.li.liu@oracle.com
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <d8ca90b3-3eca-1cb0-07db-d5f280b184e5@inwind.it>
Date: Tue, 14 Jun 2016 20:55:53 +0200
MIME-Version: 1.0
In-Reply-To: <20160614181607.GM5437@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-14 20:16, Hugo Mills wrote:
[....]
>>
>> You are right. If the last item in the buffer is a EXTENT_ITEM, and the 
>> next item in the disk is a BLOCK_GROUP_ITEM with the same object id,
>> the latter would be skipped.
>>
>> I was find always terrible the BTRFS_IOC_TREE_SEARCH; if the min_*
>> fields was separate from the key, the use of this ioctl would
>> be a lot simpler. Moreover in most case (like this one), it would be 
>> reduced the context switches, because the ioctl would return
>> only valid data.
> 
>    There's an argument for implementing it. However, given the way the
> indexing works (concatenation of the key elements, resulting in
> lexical ordering of keys), you'd still have to do exactly the same
> work, only in the kernel instead. The only thing you really win is the
> number of context switches.
> 
>    It would really have to be a new ioctl, too. You can't change the
> behaviour of the existing one.
> 
>    Hugo.

It was 2010...

http://www.spinics.net/lists/linux-btrfs/msg07636.html


> 
>>>
>>> So, the important line here was: "...when the extent_item just
>>> manages to squeeze in as last result into the current result buffer
>>> from the ioctl..."
>>>
>>
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
