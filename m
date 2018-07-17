Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37994 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728288AbeGQJEy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 05:04:54 -0400
Subject: Re: [PATCH] btrfs: extent-tree: Check if the newly reserved tree
 block is already in use
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
References: <20180717074658.22331-1-wqu@suse.com>
 <64ca7ccd-64d2-b5a4-e5fa-4ead145dcd17@suse.com>
 <1ca2ca79-0f76-2ac7-b4b6-5266338a053f@gmx.com>
 <3d7b535f-5466-3a6b-7a04-99e88b75f0fc@suse.com>
From: Qu Wenruo <wqu@suse.de>
Message-ID: <6226ce7b-924d-2de1-a607-c4ac661af1c8@suse.de>
Date: Tue, 17 Jul 2018 16:33:20 +0800
MIME-Version: 1.0
In-Reply-To: <3d7b535f-5466-3a6b-7a04-99e88b75f0fc@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月17日 16:28, Nikolay Borisov wrote:
> 
> 
> On 17.07.2018 11:24, Qu Wenruo wrote:
>> And it's causing problem for certain test cases.
>> Please ignore this (at least for now).
>>
>> But on the other hand, we indeed have a lot of reports on corrupted
>> extent tree, it's possible to hit some corrupted extent tree (Su is
>> already exhausted by the corrupted tree reported by Marc)
>>
>> So I'm not completely fine with current extent tree error handling.
>> I'll try to find some balance in next version.
> 
> 
> I agree we need a better OVERALL error handling/detection. Your
> tree-checker work IMO is a step in the right direction. What I want is
> to prevent ad-hoc checks being sprinkled in the code.

Yep, I also don't like what I'm doing.
But the problem and the limit of tree-checker is, it's static check.

For things doing tons of cross-check like extent tree, it's not really
as useful.

> Sorry, but that's
> not fine. The thing with working on a lot of corruption reports is the
> fact each one of them is looked at in isolation so it produces isolated
> fixes. Whereas if a step back is taken and the overall error
> handling/detection is considered it might turn out a whole class of
> corruption could be detected by a single change, otherwise checks upon
> checks will be added which just add technical debt.
> 
> Considering this, I'm more in favor of extending the tree-checker to be
> the central place where errors are detected (of course this is easier
> said than done).

For this report itself, tree checker can detect it indirectly by reject
the leaf for the unknown key type.

But one can easily create a valid image by just removing the valid
METADATA_ITEM, and tree-checker can't do anything to detect the problem.

So unfortunately, we will eventually need some runtime check anyway.

Thanks,
Qu

> 
