Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:50052 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756193AbdGXRWH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 13:22:07 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170724142508.GW2866@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <92250c4b-f2ee-a7d5-b247-0e8d3bb7f81f@mendix.com>
Date: Mon, 24 Jul 2017 19:22:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170724142508.GW2866@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2017 04:25 PM, David Sterba wrote:
> On Fri, Jul 21, 2017 at 01:47:11PM +0200, Hans van Kranenburg wrote:
>> [...]
>>
>>     So what now...?
>>
>> The changes in here do the following:
>>
>> 1. Throw out the current ssd_spread behaviour.
>> 2. Move the current ssd behaviour to the ssd_spread option.
>> 3. Make ssd mode data allocation identical to tetris mode, like nossd.
>> 4. Adjust and clean up filesystem mount messages so that we can easily
>> identify if a kernel has this patch applied or not, when providing
>> support to end users.
>>
>> Instead of directly cutting out all code related to the data cluster, it
>> makes sense to take a gradual approach and allow users who are still
>> able to find a valid reason to prefer the current ssd mode the means to
>> do so by specifiying the additional ssd_spread option.
>>
>> Since there are other uses of the ssd mode, we keep the difference
>> between nossd and ssd mode. However, the usage of the rotational
>> attribute warrants some reconsideration in the future.
>>
>> [...]
>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> 
> Thanks for the extensive historical summary, this change really deserves
> it.
> 
> Decoupling the assumptions about the device's block management is really
> a good thing, mount option 'ssd' should mean that the device just has
> cheap seeks. Moving the the allocation tweaks to ssd_spread provides a
> way to keep the behaviour for anybody who wants it.
> 
> I'd like to push this change to 4.13-rc3, as I don't think we need more
> time to let other users to test this. The effects of current ssd
> implementation have been debated and debugged on IRC for a long time.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 

Ok, thanks. I'll send out a v2 tonight with the typo / commit id fixes
etc from the other feedback.

-- 
Hans van Kranenburg
