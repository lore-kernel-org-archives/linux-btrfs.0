Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50354 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755905AbaCTBCJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 21:02:09 -0400
From: Chris Mason <clm@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Date: Thu, 20 Mar 2014 01:01:35 +0000
Message-ID: <CF4FB5F3.2116%clm@fb.com>
In-Reply-To: <20140320002007.GY18959@merlins.org>
Content-Type: text/plain; charset="euc-kr"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 3/19/14, 8:20 PM, "Marc MERLIN" <marc@merlins.org> wrote:

>On Thu, Mar 20, 2014 at 12:13:36AM +0000, Chris Mason wrote:
>> >Should I double it?
>> >
>> >For now, I have the copy running again, and it's been going for 8 hours
>> >without failure on the old kernel but of course that doesn't mean my
>>2TB
>> >copy will complete without hitting the bug again.
>> 
>> Sorry, I misspoke, you should bump /proc/sys/vm/min_free_kbytes.
>>Honestly
>> though, it©ös just a bug in the mvs driver.  Atomic 8K allocations are
>> doomed to fail eventually.
>
>Gotcha
>polgara:/mnt/btrfs_backupcopy# cat /proc/sys/vm/min_free_kbytes
>45056
>polgara:/mnt/btrfs_backupcopy# echo 100000 > /proc/sys/vm/min_free_kbytes
>polgara:/mnt/btrfs_backupcopy# cat /proc/sys/vm/min_free_kbytes
>100000
>polgara:/mnt/btrfs_backupcopy#
> 
>> The driver should either busy loop until the allocation completes
>>(really
>> not a great choice), gracefully deal with the failure (looks tricky), or
>> preallocate the space (like the rest of the block layer).
>
>Gotcha. I'll report this to the folks maintaining the marvel driver.
>
>So just to make sure I got you right, although the page allocation failure
>was shown in btrfs, it's really the underlying marvel driver at fault
>here,
>and there isn't really anything to change on the btrfs side, correct?

The process is a btrfs worker, and the IO was started by btrfs, but the
allocation failure is all inside the mvs driver.  There¡¯s even the printk
in there from mvs about the allocation failing.

The only reason it¡¯s btrfs instead of a regular process is because for
raid5/6 the rmw is farmed out to helper threads.

-chris

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
