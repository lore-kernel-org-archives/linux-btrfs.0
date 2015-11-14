Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:58786 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750773AbbKNLFa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 06:05:30 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <5644E6B5.9070405@inwind.it> <5645B953.7080202@oracle.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56471576.4080803@inwind.it>
Date: Sat, 14 Nov 2015 12:05:26 +0100
MIME-Version: 1.0
In-Reply-To: <5645B953.7080202@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-13 11:20, Anand Jain wrote:
> 
> Thanks for comments.
> 
> On 11/13/2015 03:21 AM, Goffredo Baroncelli wrote:
>> On 2015-11-09 11:56, Anand Jain wrote:
>>> These set of patches provides btrfs hot spare and auto replace support
>>> for you review and comments.
>>
>> Hi Anand,
>>
>> is there any reason to put this kind of logic in the kernel space ?
[...]
> 
>> Another feature of this daemon could be to add a disk when the disk
>> space is too low,
> 
>  That will be at the cost of a spare device which user should review
>  the trade-offs and do it manually ? I am not sure.

If you have more than one spare, you can do automatically both: a new disk is added when the space is low, and a disk is replaced in case of failure. If you have only one spare: you may decide to reserve it only for replacing a failed disk. But this should be a configurable option: a low space leads to a not available filesystem, a failed disk means a higher likelihood to loosing all the filesystem. I am not sure which should be the more critical.

>> or to start a balance when there is no space to
>> allocate further chunk.....
> 
>  Yep. As you notice, the thread created here is casualty_kthread()
>  (instead of replace_kthread()) over the long run I wish to provide
>  that feature in this thread, as it is a mutually exclusive operations
>  with replace.

A disk replacing should be an higher priority operation. In case of disk failure during a balance/defrag, these operation should be stopped to allow a replace.
If you want to start a replace, you should stop others (long time) operations like balance and defrag.

> 
>> Of course all these logic could be implemented in kernel space,
>> but I think that we should avoid that when possible.
> 
>  Easy to handle the mutually_exclusive parts with in the kernel
>  and Its better to have the important logic at one place. Two heads
>  operating on an org looking and feeling different things will lead
>  to wrong decisions.

Which is the other logic which you are referring ?

> 
>> Moreover in  user space the logging is more easy....
> 
> Thanks, Anand


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
