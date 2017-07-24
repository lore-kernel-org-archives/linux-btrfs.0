Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59717 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753542AbdGXTSv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 15:18:51 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, <dsterba@suse.cz>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170724142508.GW2866@twin.jikos.cz>
 <25d92d3d-52a8-8763-0936-c891d903c588@fb.com>
 <20170724184135.GA2866@twin.jikos.cz>
 <f4b9d041-6c07-fc31-91d2-b4f2f034df61@fb.com>
 <779fdedf-1318-bf2d-414d-693168d994d6@gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <a510b7cf-f8c3-ceb7-6a04-dfc21ea495b6@fb.com>
Date: Mon, 24 Jul 2017 15:18:31 -0400
MIME-Version: 1.0
In-Reply-To: <779fdedf-1318-bf2d-414d-693168d994d6@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2017 03:06 PM, Austin S. Hemmelgarn wrote:
> On 2017-07-24 14:53, Chris Mason wrote:
>> On 07/24/2017 02:41 PM, David Sterba wrote:
>>>
>>> would it be ok for you to keep ssd_working as before?
>>>
>>> I'd really like to get this patch merged soon because "do not use ssd
>>> mode for ssd" has started to be the recommended workaround. Once this
>>> sticks, we won't need to have any ssd mode anymore ...
>>
>> Works for me.  I do want to make sure that commits in this area 
>> include the workload they were targeting, how they were measured and 
>> what impacts they had.  That way when we go back to try and change 
>> this again we'll understand what profiles we want to preserve.
> Just thinking long term here, but might it make sense to (eventually) 
> allow the user to tune how big a chunk of space to look for?  I know 
> that ext* have options to do this kind of thing, and I think XFS does 
> too (but they do it at filesystem creation time), and I do know people 
> who make use of those to make sure things are working at their absolute 
> best.

Agreed, we have space in the on-disk format to record those preferences, 
but we haven't done it in the past.

-chris
