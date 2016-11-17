Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46090 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S933805AbcKQB1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 20:27:34 -0500
Subject: Re: Btrfs Heatmap - v2 - block group internals!
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
References: <e69c35cc-d693-da18-5aba-e78ae42262cd@mendix.com>
 <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fda30533-068c-69d8-064f-fbbec06a6d22@cn.fujitsu.com>
Date: Thu, 17 Nov 2016 09:27:29 +0800
MIME-Version: 1.0
In-Reply-To: <7a297aaa-f273-fb15-8e97-8c781e25f06a@mendix.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/17/2016 04:30 AM, Hans van Kranenburg wrote:
> In the last two days I've added the --blockgroup option to btrfs heatmap
> to let it create pictures of block group internals.
>
> Examples and more instructions are to be found in the README at:
> https://github.com/knorrie/btrfs-heatmap/blob/master/README.md
>
> To use the new functionality it needs a fairly recent python-btrfs for
> the 'skinny' METADATA_ITEM_KEY to be present. Latest python-btrfs
> release is v0.3, created yesterday.
>
> Yay,
>
Wow, really cool!

I always dream about a visualizing tool to represent the chunk and 
extent level of btrfs.

This should really save me from reading the boring dec numbers from 
btrfs-debug-tree.

Although IMHO the full fs output is mixing extent and chunk level
together, which makes it a little hard to represent multi-device case,
it's still an awesome tool!

And considering the "show-block" tool in btrfs-progs is quite old,
I think if the tool get further polished it may have a chance get into 
btrfs-progs.

Thanks,
Qu


