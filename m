Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62867 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbaCTANs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 20:13:48 -0400
From: Chris Mason <clm@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Date: Thu, 20 Mar 2014 00:13:36 +0000
Message-ID: <CF4FA917.20FD%clm@fb.com>
In-Reply-To: <20140319223723.GU18959@merlins.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 3/19/14, 6:37 PM, "Marc MERLIN" <marc@merlins.org> wrote:

>On Wed, Mar 19, 2014 at 12:20:08PM -0400, Chris Mason wrote:
>> On 03/19/2014 11:45 AM, Marc MERLIN wrote:
>> >My server died last night during a btrfs send/receive to a btrfs radi5
>> >array
>> >
>> >Here are the logs. Is this anything known or with a possible
>>workaround?
>> >
>> >Thanks,
>> >Marc
>> >
>> >btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
>> 
>> This is an order 1 atomic allocation from the mvs driver, we really
>> should not be depending on that to get IO done.  A quick search and it
>> looks like we're allocating MVS_SLOT_BUF_SZ (8192) bytes.
>> 
>> You could try bumping the lowmem reserves.
>
>Thanks for the info.
>
>So for now, I have
>CONFIG_X86_RESERVE_LOW=64
>
>This is the option we're talking about, right?
>
>Should I double it?
>
>For now, I have the copy running again, and it's been going for 8 hours
>without failure on the old kernel but of course that doesn't mean my 2TB
>copy will complete without hitting the bug again.

Sorry, I misspoke, you should bump /proc/sys/vm/min_free_kbytes.  Honestly
though, it¹s just a bug in the mvs driver.  Atomic 8K allocations are
doomed to fail eventually.

The driver should either busy loop until the allocation completes (really
not a great choice), gracefully deal with the failure (looks tricky), or
preallocate the space (like the rest of the block layer).

-chris

