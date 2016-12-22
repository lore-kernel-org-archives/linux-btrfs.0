Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61158 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750745AbcLVBx0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Dec 2016 20:53:26 -0500
Subject: Re: [PATCH v3 0/6] Convert rollback rework for v4.9
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161219065642.25078-1-quwenruo@cn.fujitsu.com>
 <20161221143558.GE12081@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5c647855-6065-1b4f-7f03-c0b39841bbc3@cn.fujitsu.com>
Date: Thu, 22 Dec 2016 09:53:14 +0800
MIME-Version: 1.0
In-Reply-To: <20161221143558.GE12081@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/21/2016 10:35 PM, David Sterba wrote:
> On Mon, Dec 19, 2016 at 02:56:36PM +0800, Qu Wenruo wrote:
>> Can be fetched from github:
>> https://github.com/adam900710/btrfs-progs.git convert_rework_for_4.9
>>
>> This is mainly to fix problems exposed by Chandan's fix for 64K nodesize.
>
> Thanks for the fix. That's a lot of new code that I don't feel
> comfortable to put to the upcomming release, so I'll merge 1 and 6 now
> and queue the rest for 4.9.1.

Feel free to delay them to 4.9.1.

But since we have regression, I think we'd better delay the following 
patches along with the rollback rework:

btrfs-progs: convert: Fix migrate_super_block() to work with 64k sectorsize

btrfs-progs: convert: Prevent accounting blocks beyond end of device

And the 6th patch of the patchset.


The 2 convert fixes are completely fine, but they slightly change the 
chunk layout, and makes 4K sectorsize convert test fails.
So is the 6th patch, which enhanced the testcases, to make them always 
fail if rollback rework is not applied.

So IMHO it's better to ensure the v4.9 release can pass self tests.
(Even we know it has bugs)

And fixes all the known convert bugs in v4.9.1.

How do you think about this idea?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


