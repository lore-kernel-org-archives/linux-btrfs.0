Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:41260 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdFHSDD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Jun 2017 14:03:03 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 4178F60016
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Jun 2017 19:57:11 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: Re: About free space fragmentation, metadata write amplification and
 (no)ssd
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
 <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
Message-ID: <3e8876c3-b8b9-0922-8962-17f6cf38b81d@knorrie.org>
Date: Thu, 8 Jun 2017 19:57:10 +0200
MIME-Version: 1.0
In-Reply-To: <d5ebd421-52a1-5b91-72a3-f97a2fb9628f@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ehrm,

On 05/28/2017 02:59 AM, Hans van Kranenburg wrote:
> A small update...
> 
> Original (long) message:
> https://www.spinics.net/lists/linux-btrfs/msg64446.html
> 
> On 04/08/2017 10:19 PM, Hans van Kranenburg wrote:
>> [...]
>>
>> == But! The Meta Mummy returns! ==
>>
>> After changing to nossd, another thing happened. The expiry process,
>> which normally takes about 1.5 hour to remove ~2500 subvolumes (keeping
>> it queued up to a 100 orphans all the time), suddenly took the entire
>> rest of the day, not being done before the nightly backups had to start
>> again at 10PM...
>>
>> And the only thing it seemed to do is writing, writing, writing 100MB/s
>> all day long.
> 
> This behaviour was observed with a 4.7.5 linux kernel.
> 
> When running 4.9.25 now with -o nossd, this weird behaviour is gone. I
> have no idea what change between 4.7 and 4.9 is responsible for this,
> but it's good.

Ok, that hooray was a bit too early...

---- ----

There is an improvement with subvolume delete + nossd that is visible
between 4.7 and 4.9.

This example that I saved shows what happened when doing remount,nossd
on 4.7.8:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-06-08-xvdb-nossd-sub-del.png

That example filesystem has about 1.5TiB of small files (subversion
repositories) on it, and every 15 minutes, using send/receive (helped by
btrbk) incremental changes are being sent to another location, and
snapshots older than a day are removed.

When switching to nossd, the snapshot removals (also every 15 mins)
suddenly showed quite a lot more disk writes happening (metadata).

With 4.9.25, that effect on this one and smaller filesystems is gone.
The graphs look the same when switching to nossd.

---- ----

But still, on the large filesystem (>30TiB), removing
subvolumes/snapshots takes like >10x the time (and metadata write IO)
with nossd than with ssd.

An example:

https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-06-08-big-expire-ssd-nossd.png

With -o nossd, I was able to remove 900 subvolumes (varying fs tree
sizes) in about 17 hours, doing sustained 100MB/s writes to disk.

When switching to -o ssd, I was able to remove 4300 of them within 4
hours, with way less disk write activity.

So, I'm still suspecting it's simply the SZ_64K vs SZ_2M difference for
metadata *empty_cluster that is making this huge difference, and that
the absurd metadata overhead is generated because of the fact that the
extent tree is tracked inside the extent tree itself.

To gather proof of this, and to research the effect of different
settings, applying different patches (like playing with the
empty_cluster values, the shift to left page patch, bulk csum etc,) I
need to be able to measure some things first.

So, my current idea is to put per tree (all fs trees combined under 5)
cow counters in, exposed via sysfs, so that I can create munin cow rate
graphs per filesystem. Currently, I put the python-to-C btrfs-progs
bindings project aside again, and am teaching myself enough to get this
done first. :) Free time is a bit limited nowadays, but progress is steady.

To be continued...

>> == So, what do we want? ssd? nossd? ==
>>
>> Well, both don't do it for me. I want my expensive NetApp disk space to
>> be filled up, without requiring me to clean up after it all the time
>> using painful balance actions and I want to quickly get rid of old
>> snapshots.
>>
>> So currently, there's two mount -o remount statements before and after
>> doing the expiries...
> 
> With 4.9+ now, it stays on nossd for sure, everywhere. :)

Nope, the daily remounts are back again, well only on the biggest
filesystems. :@

-- 
Hans van Kranenburg
