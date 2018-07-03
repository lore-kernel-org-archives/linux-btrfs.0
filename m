Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:34085 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932388AbeGCIrx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 04:47:53 -0400
Subject: Re: [PATCH v2 1/2] btrfs: Check each block group has corresponding
 chunk at mount time
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180703080830.8300-1-wqu@suse.com>
 <034ca6af-0f07-f9b8-86c0-463333bb41f5@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e606ab9c-f855-b237-2426-56f3f100bae9@gmx.com>
Date: Tue, 3 Jul 2018 16:47:40 +0800
MIME-Version: 1.0
In-Reply-To: <034ca6af-0f07-f9b8-86c0-463333bb41f5@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月03日 16:33, Nikolay Borisov wrote:
> 
> 
> On  3.07.2018 11:08, Qu Wenruo wrote:
>> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199837, if a
>> crafted btrfs with incorrect chunk<->block group mapping, it could leads
>> to a lot of unexpected behavior.
>>
>> Although the crafted image can be catched by block group item checker
>> added in "[PATCH] btrfs: tree-checker: Verify block_group_item", if one
>> crafted a valid enough block group item which can pass above check but
>> still mismatch with existing chunk, it could cause a lot of undefined
>> behavior.
>>
>> This patch will add extra block group -> chunk mapping check, to ensure
>> we have a completely matching (start, len, flags) chunk for each block
>> group at mount time.
>>
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> changelog:
>> v2:
>>   Add better error message for each mismatch case.
>>   Rename function name, to co-operate with later patch.
>>   Add flags mismatch check.
>> ---
> 
> It's getting really hard to keep track of the various validation patches
> you sent with multiple versions + new checks. Please batch everything in
> a topic series i.e "Making checks stricter" or some such and send
> everything again nicely packed, otherwise the risk of mis-merging is
> increased.

Indeed, I'll send the branch and push it to github.

> I now see that Gu Jinxiang from fujitsu also started sending
> validation fixes.

No need to worry, that will be the only patch related to that thread of
bugzilla from Fujitsu.
As all the other cases can be addressed by my patches, sorry Fujitsu guys :)

> Also for evry patch which fixes a specific issue from one of the
> reported on bugzilla.kernel.org just use the Link: tag to point to the
> original report on bugzilla that will make it easier to relate the
> fixes to the original report.

Never heard of "Link:" tag.
Maybe it's a good idea to added it to "submitting-patches.rst"?

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
