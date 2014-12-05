Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38403 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaLEG6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 01:58:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xwmq8-0005Ri-H5
	for linux-btrfs@vger.kernel.org; Fri, 05 Dec 2014 07:58:08 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 07:58:08 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 07:58:08 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
Date: Fri, 5 Dec 2014 06:57:55 +0000 (UTC)
Message-ID: <pan$e8a0d$4c65d3df$b96b30fa$cda09308@cox.net>
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
	<54806C19.4090503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 04 Dec 2014 09:13:45 -0500 as
excerpted:

> Also, for future reference, you can use the switch -mprofiles=single to
> just balance out those chunks.

FWIW, the way I do it has the same effect on those left-over chunks, but 
uses a slightly different method and may be a bit more useful:

-musage=0

And to get rid of the single data chunk as well since I normally use 
raid1 for both data and metadata:

-dusage=0

Of course they can be combined in the same balance command.


This approach rebalances only those chunks with zero usage.  Since they 
have no usage, they aren't rewritten, simply deleted.

Of course that removes the empty single-profile chunks, but on systems 
with usage over a longer period, either where the filesystem was filled 
before the command was run or when the command was run for this reason 
instead of the single-profile chunks reason, there may be additional 
empty chunks of the desired profile (raid1 in my case).  Removing these 
empty chunks by rebalancing only them is a very quick way to return their 
allocation to unallocated space, thus freeing them for allocation on 
demand as either data or metadata, instead of keeping them pinned as one 
or the other which is what an empty chunk is effectively doing.

Of course on the most recent kernels (I think only 3.18 has it and of 
course it's not yet released tho the release is getting close) that's 
less of an issue since the kernel will now rebalance when data/metadata 
chunk usage gets too unbalanced, but previous to that, a bunch of empty 
data chunks hogging all the space so no more chunks could be allocated, 
while metadata was full and a new metadata chunk was needed, was a 
relatively common ENOSPC trigger, and the reverse (empty or nearly empty 
metadata chunks hogging all the otherwise free space, a new data chunk 
needed), while rarer, was known to happen on occasion as well.

But at least until that new auto-rebalancer has a bit more testing, 
knowing how to rebalance empty chunks and thus eliminate them, especially 
when a balance to free up space is otherwise unable to run due to no free 
space to allocate a new chunk to write the partial chunks into, can come 
in handy. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

