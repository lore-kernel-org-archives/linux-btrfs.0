Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55656 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751130AbeFURu3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 13:50:29 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.cz>
CC: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] btrfs: Remove V0 extent support
Date: Thu, 21 Jun 2018 13:50:03 -0400
Message-ID: <BC2C78B9-20F5-4C14-A9DE-E4DA8D9C3B7E@fb.com>
In-Reply-To: <20180621092205.GJ24375@twin.jikos.cz>
References: <1529563500-1714-1-git-send-email-nborisov@suse.com>
 <20180621092205.GJ24375@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 21 Jun 2018, at 5:22, David Sterba wrote:

> On Thu, Jun 21, 2018 at 09:45:00AM +0300, Nikolay Borisov wrote:
>> The v0 compat code was introduced in commit 5d4f98a28c7d
>> ("Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE)") 9
>> years ago, which was merged in 2.6.31. This means that the code is
>> there to support filesystems which are _VERY_ old and if you are 
>> using
>> btrfs on such an old kernel, you have much bigger problems. This 
>> coupled
>> with the fact that no one is likely testing/maintining this code 
>> likely
>> means it has bugs lurking. All things considered I think 43 kernel
>> releases later it's high time this remnant of the past got removed.
>
> Ack. Given the age of the format and nearly zero chance of such
> filesystem to be still in use it should be ok to remove it directly 
> and
> not add some sort of warning when such filesystem is found.

Agreed, it seems very unlikely to me that we have happy v0 users.

>
>> This patch removes all code wrapped in #ifdefs but leaves the BUG_ONs 
>> in case
>> we have a v0 with no support intact as a sort of safety-net.
>
> I think there should be some verbose way to report what happened and
> possibly do proper error handling and go to read-only eventually.
> The type of checks for v0 do not seem to be something that could be 
> done
> at mount time.

Yeah, with the code we have right now, it's really obvious the BUG()s 
are for V0 extents.  With all the ifdefs removed its much less clear.  
I'd swap them out for a transaction abort with a message about the v0 
extents.

Also, there's at least one ASSERT() left over in a #else, which I would 
also turn into a more explicit abort or at least comment.

-chris
