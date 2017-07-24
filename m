Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50111 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754040AbdGXSBY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 14:01:24 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: <dsterba@suse.cz>, Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <20170724142508.GW2866@twin.jikos.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <25d92d3d-52a8-8763-0936-c891d903c588@fb.com>
Date: Mon, 24 Jul 2017 14:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <20170724142508.GW2866@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/24/2017 10:25 AM, David Sterba wrote:

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

The description is great, but I'd love to see many more benchmarks.  At 
Facebook we use the current ssd_spread mode in production on top of 
hardware raid5/6 (spinning storage) because it dramatically reduces the 
read/modify/write cycles done for metadata writes.

If we're going to play around with these, we need a good way to measure 
free space fragmentation as part of benchmarks, as well as the IO 
patterns coming out of the allocator.

At least for our uses, ssd_spread matters much more for metadata than 
data (the data writes are large and metadata is small).

Thanks again,
Chris
