Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab3DVQBz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 12:01:55 -0400
Message-ID: <51755EC5.7080706@redhat.com>
Date: Mon, 22 Apr 2013 11:01:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH] btrfs: make static code static & remove dead code
References: <51719932.6010406@redhat.com> <20130422150511.GP16427@twin.jikos.cz> <5175561C.90709@redhat.com> <20130422155545.GS16427@twin.jikos.cz>
In-Reply-To: <20130422155545.GS16427@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/22/13 10:55 AM, David Sterba wrote:
> On Mon, Apr 22, 2013 at 10:24:12AM -0500, Eric Sandeen wrote:
>>>> btrfs_reada_detach()
>>>
>>> That's an API for readahead, thhugh maybe not used now as RA is not used
>>> and at all scenarios where it could.
>>
>> Ok, if it's useful to keep it around just for symmetry I could
>> understand that.  
> 
> reada.c:
> /*
>  * This is the implementation for the generic read ahead framework.
>  *
>  * To trigger a readahead, btrfs_reada_add must be called. It will start
>  * a read ahead for the given range [start, end) on tree root. The returned
>  * handle can either be used to wait on the readahead to finish
>  * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
> 
>>>> btrfs_scrub_cancel_devid()
>>>
>>> Looks like there's a missing userspace counterpart, cancelling scrub by
>>> device is possible by design.
>>
>> Maybe one for Arne to answer?  Yeah, I don't see it in the manpage
>> or in userspace, so *shrug* where is the design?
> 
> Scrub can be started on one device, cancel is just part of the command set.
> 
> $ ./btrfs scrub cancel --help
> usage: btrfs scrub cancel <path>|<device>
>     Cancel a running scrub

Right, but device is different from devid, no?

i.e. btrfs replace start can take a devid or a device, and checks for
if (is_numerical(srcdev)); this doesn't look implemented for
scrub cancel.   I guess it could be.

>>>> btrfs_start_transaction_lflush()
>>>
>>> Transcaction API, removing the func does not make sense without removing
>>> BTRFS_RESERVE_FLUSH_LIMIT at the same time.
>>
>> Not sure I understand that, btrfs_block_rsv_refill() still uses that macro,
>> but I'm probably not understanding the code or missing your point.
> 
> The function wraps usage of the macro/enum in the transaction_start_* functions
> and it has been used at some point, we may want to use it again as allows to
> start a transaction in some limited context. It's been added by Miao, 
> 
>> I'll admit to doing the removal mechanically, hopefully those with
>> particular affinity to any of the removed functions can speak
>> up.  :)
> 
> Removing dead code sometimes points out bugs, it's always good to do a quick
> review and do patch archeology first. Which makes it less appealing as a
> low-hanging fruit :)

Fair enough, I'm appropriately chastised. :)

-Eric

> david
> 

