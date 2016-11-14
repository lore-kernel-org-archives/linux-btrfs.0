Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:56270
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935195AbcKNUH4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 15:07:56 -0500
Subject: Re: Announcing btrfs-dedupe
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <CAAXPY_LJshM+W+xinabu_-=-E6J8UBMRpy7VPLt8tNihpO68Lw@mail.gmail.com>
 <345b3aa4-6644-6730-09dd-549d320f58cb@wellbehavedsoftware.com>
 <20161114180714.GF21290@hungrycats.org>
 <a4e42724-d84a-e4f9-a3ea-d1fec31a5629@wellbehavedsoftware.com>
 <dfb1372d-8bff-93ff-1ba7-d636e6c7fe4d@gmail.com>
 <20161114195102.GI21290@hungrycats.org>
Cc: Mark Fasheh <mfasheh@versity.com>, linux-btrfs@vger.kernel.org
From: James Pharaoh <james@wellbehavedsoftware.com>
Message-ID: <ab787485-c6ba-cada-07c5-f226d1c395e2@wellbehavedsoftware.com>
Date: Mon, 14 Nov 2016 21:07:51 +0100
MIME-Version: 1.0
In-Reply-To: <20161114195102.GI21290@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/11/16 20:51, Zygo Blaxell wrote:
> On Mon, Nov 14, 2016 at 01:39:02PM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-11-14 13:22, James Pharaoh wrote:
>>> One thing I am keen to understand is if BTRFS will automatically ignore
>>> a request to deduplicate a file if it is already deduplicated? Given the
>>> performance I see when doing a repeat deduplication, it seems to me that
>>> it can't be doing so, although this could be caused by the CPU usage you
>>> mention above.
 >>
>> What's happening is that the dedupe ioctl does a byte-wise comparison of the
>> ranges to make sure they're the same before linking them.  This is actually
>> what takes most of the time when calling the ioctl, and is part of why it
>> takes longer the larger the range to deduplicate is.  In essence, it's
>> behaving like an OS should and not trusting userspace to make reasonable
>> requests (which is also why there's a separate ioctl to clone a range from
>> another file instead of deduplicating existing data).
>
> 	- the extent-same ioctl could check to see which extents
> 	are referenced by the src and dst ranges, and return success
> 	immediately without reading data if they are the same (but
> 	userspace should already know this, or it's wasting a huge amount
> 	of time before it even calls the kernel).

Yes, this is what I am talking about. I believe I should be able to read 
data about the BTRFS data structures and determine if this is the case. 
I don't care if there are false matches, due to concurrent updates, but 
there'll be a /lot/ of repeat deduplications unless I do this, because 
even if the file is identical, the mtime etc hasn't changed, and I have 
a record of previously doing a dedupe, there's no guarantee that the 
file hasn't been rewritten in place (eg by rsync), and no way that I 
know of to reliably detect if a file has been changed.

I am sure there are libraries out there which can look into the data 
structures of a BTRFS file system, I haven't researched this in detail 
though. I imagine that with some kind of lock on a BTRFS root, this 
could be achieved by simply reading the data from the disk, since I 
believe that everything is copy-on-write, so no existing data should be 
overwritten until all roots referring to it are updated. Perhaps I'm 
missing something though...

James
