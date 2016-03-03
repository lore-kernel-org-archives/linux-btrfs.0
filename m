Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41375 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751243AbcCCB1F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 20:27:05 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D63CB1.5070202@cn.fujitsu.com> <56D6ADB6.7020701@oracle.com>
CC: <clm@fb.com>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D792DB.7020608@cn.fujitsu.com>
Date: Thu, 3 Mar 2016 09:26:51 +0800
MIME-Version: 1.0
In-Reply-To: <56D6ADB6.7020701@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Anand Jain wrote on 2016/03/02 17:09 +0800:
>
> Hi Qu,
>
>> Not only move, but also reflink/inband dedup.
>
>   oh yes thanks. I shall add those.
>
>> Yes, but in fact, you can use another method, just like in-band de-dup,
>> by adding new hook into async_cow_start() and async_cow_end(), allowing
>> compression and encryption can be done at the same time.
>> (We are already testing the patch to allow dedup to cooperate with
>> compression)
>>
>> So no need to find a encryption with can compress.
>> (Never mix 2 different work together)
>
>   I am not too sure about this. But logically if one encoding engine
>   can do both that seems to be better than using two separate encoding
>   engines.

That's right, if can be done in one iteration, that's best.

Maybe I'm ignorant about encryption, but it seems the design goal of 
current block encryption is safety (confusion and diffusion), and 
normally same plaintext and ciphertext size.
So it may be a little difficult to find such encryption/compression 
algorithm.
And even found, we may need to implement it in kernel, if we're the only 
user, Linus may not be happy with that though.

Another concern is, if using that method, encryption and compression 
must be bond together, make things a little unflex, especially for 
subvolume level encryption.

But that's all my assumption.
Maybe current encryption and compression conflicts method is the best, 
as it's so easy for user to compression a file in user space.

>
>> And maybe I just missed something, but the filename seems not touched,
>> meaning it will leak a lot of information.
>> Just like default eCryptfs behavior.
>  >
>> I understand that's an easy design and it's not a high priority thing,
>> but I hope we can encrypt the subvolume tree blocks too, if using
>> per-subvolume policy.
>> To provide a feature near block-level encryption.
>
>   No you didn't miss about filename, its not there yet. Will add more
>   depth, as I obtain feedback/confirmed on the approach concerns if any.

OK, I'll just forgot this corner and focus on current implement.

Good job on bringing encryption to the view of most developers.

Thanks,
Qu

>
> Thanks, Anand
>
>


