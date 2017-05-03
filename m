Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53478 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751118AbdECO5A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 10:57:00 -0400
Subject: Re: [PATCH] btrfs: always write superblocks synchronously
To: Jan Kara <jack@suse.cz>, Davidlohr Bueso <dave@stgolabs.net>
References: <20170502162813.4299-1-dave@stgolabs.net>
 <20170503083615.GC10084@quack2.suse.cz>
CC: <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Jan Kara <jack@suze.cz>, Davidlohr Bueso <dbueso@suse.de>
From: Chris Mason <clm@fb.com>
Message-ID: <4614b613-8cc6-1f58-09e1-066e97fc638a@fb.com>
Date: Wed, 3 May 2017 10:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <20170503083615.GC10084@quack2.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/03/2017 04:36 AM, Jan Kara wrote:
> On Tue 02-05-17 09:28:13, Davidlohr Bueso wrote:
>> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
>> synchronous" removed REQ_SYNC flag from WRITE_FUA implementation.
>> Since REQ_FUA and REQ_FLUSH flags are stripped from submitted IO
>> when the disk doesn't have volatile write cache and thus effectively
>> make the write async. This was seen to cause performance hits up
>> to 90% regression in disk IO related benchmarks such as reaim and
>> dbench[1].
>>
>> Fix the problem by making sure the first superblock write is also
>> treated as synchronous since they can block progress of the
>> journalling (commit, log syncs) machinery and thus the whole filesystem.
>>

>>
>> Fixes: b685d3d65ac (block: treat REQ_FUA and REQ_PREFLUSH as synchronous)
>> Cc: stable <stable@vger.kernel.org>
>> Cc: Jan Kara <jack@suze.cz>
>> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
>
> I wasn't patient enough and already sent the fix as part of my series
> fixing other filesystems [1]. It also fixes one more place in btrfs that
> needs REQ_SYNC to return to the original behavior.
>


Thanks guys.

-chris

