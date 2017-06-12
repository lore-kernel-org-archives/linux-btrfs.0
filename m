Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45607 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752639AbdFLQDY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 12:03:24 -0400
Subject: Re: [PATCH v2] Btrfs: btrfs_ioctl_search_key documentation
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170605152733.25441-1-hans.van.kranenburg@mendix.com>
 <20170605222032.9207-1-hans.van.kranenburg@mendix.com>
 <20170612153846.GP25451@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <0555ff61-2c1d-1de2-0978-fb82f1a64979@mendix.com>
Date: Mon, 12 Jun 2017 18:03:15 +0200
MIME-Version: 1.0
In-Reply-To: <20170612153846.GP25451@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/12/2017 05:38 PM, David Sterba wrote:
> On Tue, Jun 06, 2017 at 12:20:32AM +0200, Hans van Kranenburg wrote:
>> A programmer who is trying to implement calling the btrfs SEARCH
>> or SEARCH_V2 ioctl will probably soon end up reading this struct
>> definition.
>>
>> Properly document the input fields to prevent common misconceptions:
>>  1. The search space is linear, not 3 dimensional. The invidual min/max
>>  values for objectid, type and offset cannot be used to filter the
>>  result, they only define the endpoints of an interval.
>>  2. The transaction id (a.k.a. generation) filter applies only on
>>  transaction id of the last COW operation on a whole metadata page, not
>>  on individual items.
>>
>> Ad 1. The first misunderstanding was helped by the previous misleading
>> comments on min/max type and offset:
>>   "keys returned will be >= min and <= max".
>>
>> Ad 2. For example, running btrfs balance will happily cause rewriting of
>> metadata pages that contain a filesystem tree of a read only subvolume,
>> causing transids to be increased.
>>
>> Also, improve descriptions of tree_id and nr_items and add in/out
>> annotations.
>>
>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> 
> Looks good to me, thanks. I've realigned the comments so they don't
> overflow 80 columns and aligned the /* in */ hints.

Ah, I see, thanks. My vim takes 4 chars for a tab, that's the problem.
I'll get the vim C settings in order for the next time. :-)

>> Most interesting changes since v1:
>>  - mention the special tree_id input value 0
>>  - rewrite the part about min_key and max_key, trying to be more concise
> 
> I find the description instructive enough so the expanded expression to
> describe the whole range is not IMHO needed.

You mean drop the extra line "All metadata..." ? Yeah, it's a bit
redudant, stressing the fact, yes.

The main purpose is to stop users from thinking that setting min_type
and max_type will filter the returned objects (like, only getting
BLOCK_GROUP_ITEM_KEY or so). So as long as you think that's clear
enough, I'm ok with anything.

-- 
Hans van Kranenburg
