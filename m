Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbeC0XZu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 19:25:50 -0400
Subject: Re: [PATCH] btrfs-progs: wipe copies of the stale superblock beyond
 -b size
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <bfb139b5-930d-a383-8de3-1fed66a70553@oracle.com>
Date: Wed, 28 Mar 2018 07:27:39 +0800
MIME-Version: 1.0
In-Reply-To: <ee590729-52d7-bd05-4c08-c829cb86757a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20180326082742.9235-10-anand.jain@oracle.com>
 <142e5830-3692-ddac-81d9-c29448969c63@suse.com>
 <b2987bff-ad58-4fcd-bda3-baa05ae7f8d6@oracle.com>
 <ee590729-52d7-bd05-4c08-c829cb86757a@suse.com>



On 03/27/2018 02:19 PM, Nikolay Borisov wrote:
> 
> 
> On 27.03.2018 02:50, Anand Jain wrote:
>>
>>
>>> I told you this code can be made a lot simpler, simply by modifying the
>>> last argument passed to zero_dev_clamped. I even posted the resulting
>>> diff which was just 3 lines changed.
>>>
>>> I agree that it's a good idea to wipe all available superblock when we
>>> use -b. However I don't agree with your approach - it adds a loop, it
>>> adds a bunch of checks and makes the complexity orders of magnitude
>>> higher than it could be. So I'm asking again - is there any inherent
>>> benefit which I'm missing in your newly added 35 lines of code against
>>> just passing the block device to zero_dev_clamped and letting the
>>> existing logic take care of everything?
>>
>> I had that idea for v1 as well, but I didn't do it because it would
>> zero bytenr_copy#2 even when there is no btrfs superblock, (which is
>> fine only with in block_count).
>>
>> Some might view it as corrupting the usr data (for which they have
>> specified -b option?)? I am just discussing I don't have any usecase
>> to prove it though. Do you have any idea?
>> If you think it should be ok, I shall go ahead and zero without
>> checking for the btrfs superblock beyond block_count.
> 
> Right, so the pertinent question is - is anyone expecting to do mkfs on
> a volume irrespective of the options and expect to be able to recover
> data prior to the mkfs? I think the answer is 'no', but let's see what
> the community says.

  Writing zero even if there is no superblock is not a question of
  recovering btrfs, its a question whether there was any other good
  data that is intersting to the user, for which they have specified
  -b option.

  Asking community is a good idea, lets take a conservative approach
  to zero stale superblock only if we find a valid superblock, atleast
  for now, we can add cleanups later.

Thanks, Aannd

>>
>> Thanks, Anand
>>
