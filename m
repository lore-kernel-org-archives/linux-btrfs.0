Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:38895 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754471AbcKQSvW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 13:51:22 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
 <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <68eecdb7-90e4-a5ba-ca63-f714faf88ede@mendix.com>
Date: Thu, 17 Nov 2016 19:51:17 +0100
MIME-Version: 1.0
In-Reply-To: <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On 11/17/2016 02:27 AM, Qu Wenruo wrote:
> 
> At 11/17/2016 04:30 AM, Hans van Kranenburg wrote:
>> In the last two days I've added the --blockgroup option to btrfs heatmap
>> to let it create pictures of block group internals.
>>
>> Examples and more instructions are to be found in the README at:
>> https://github.com/knorrie/btrfs-heatmap/blob/master/README.md
>>
>> To use the new functionality it needs a fairly recent python-btrfs for
>> the 'skinny' METADATA_ITEM_KEY to be present. Latest python-btrfs
>> release is v0.3, created yesterday.
>>
> Wow, really cool!

Thanks!

> I always dream about a visualizing tool to represent the chunk and
> extent level of btrfs.
> 
> This should really save me from reading the boring dec numbers from
> btrfs-debug-tree.
> 
> Although IMHO the full fs output is mixing extent and chunk level
> together, which makes it a little hard to represent multi-device case,
> it's still an awesome tool!

The picture of a full filesystem just appends all devices together into
one big space, and then walks the dev_extent tree and associated
chunk/blockgroup items for the %used/greyscale value.

I don't see what displaying a blockgroup-level aggregate usage number
has to do with multi-device, except that the same %usage will appear
another time when using RAID1*.

When generating a picture of a file system with multiple devices,
boundaries between the separate devices are not visible now.

If someone has a brilliant idea about how to do this without throwing
out actual usage data...

-- 
Hans van Kranenburg
