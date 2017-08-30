Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21081 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdH3ObC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 10:31:02 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 2/4] btrfs: convert enum btrfs_compression_type to define
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170813040244.18841-1-anand.jain@oracle.com>
 <20170813040244.18841-3-anand.jain@oracle.com>
 <20170816135941.GE2866@twin.jikos.cz>
 <6117a0fa-b540-c31f-af10-805fce5b7cfc@oracle.com>
 <20170817115706.GS2866@twin.jikos.cz>
Message-ID: <34d203c9-f647-ea71-712b-74637abc8d2d@oracle.com>
Date: Wed, 30 Aug 2017 22:38:21 +0800
MIME-Version: 1.0
In-Reply-To: <20170817115706.GS2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/17/2017 07:57 PM, David Sterba wrote:
> On Thu, Aug 17, 2017 at 04:33:41AM +0800, Anand Jain wrote:
>>
>>
>> On 08/16/2017 09:59 PM, David Sterba wrote:
>>> On Sun, Aug 13, 2017 at 12:02:42PM +0800, Anand Jain wrote:
>>>> There isn't a huge list to manage the types, which can be managed
>>>> with defines. It helps to easily print the types in tracing as well.
>>>
>>> We use enums in a lot of places, I'd rather keep it as it is.
>>
>>    This patch converts all of them, and it was at only one place.
> 
> Yeah, but I mean the enum vs define style of constant definition.
> 
>>    I hope I didn't miss any. Further the next patch 3/4 needs it
>>    to be define instead of enums, handling enums in the tracing
>>    isn't as easy as define.
> 
> Interesting, in what way are defines better use in tracepoints? I see
> eg. show_flush_state using enum btrfs_flush_state in btrfs_flush_space,
> the same pattern applies to patch 3/4.

  As of now TRACE_DEFINE_ENUM() for show_flush_state is missing (patch 
sent) which is needed for the state= symbol in the user space as shown 
below,

perf record -e 'btrfs:btrfs_flush_space' -a fill_and_bal /btrfs/sv1 
10000 && perf script

::
kworker/u2:4  4220 [000] 19032.858184: btrfs:btrfs_flush_space: (nil)U: 
state=1() flags=4(METADATA) num_bytes=173015040 orig_bytes=173015040 ret=0

(%p does not work in user space, ignore it for now).

sysfs trace is fine.
cat ./trace_pipe
---
kworker/u2:3-4219  [000] .... 18952.145677: btrfs_flush_space: 
f0918b8d-88a6-4e9f-8ca6-02e2fc290380: state=1(FLUSH_DELAYED_ITEMS_NR) 
flags=4(METADATA) num_bytes
---

  So for BTRFS_COMPRESS.. its either TRADE_DEFINE_ENUM() and enum or 
just #define. I am ok either ways.

Thanks, Anand
