Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:53480 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbcCPGk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 02:40:27 -0400
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Robert White <rwhite@pobox.com>
Subject: Stupid (?) Idea about extent lifetimes.
Message-ID: <56E8FDE5.90401@pobox.com>
Date: Tue, 15 Mar 2016 23:32:05 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It occurs to me that it would be desirable to mark extents as "least 
favoured nations" and so all new writes would like to not be written 
there and any data written there would have a desire to be somewhere else.

So lets say the wholly unallocated space has a natural status of 100.

Allocated blocks would normally have statuses less than that by a 
trivial amount, such as 99.

One could then marks blocks with higher numbers for being less favoured, 
or lower numbers for being more favoured as desired.

Basically this would create a gravity map of sorts that would be 
factored into allocation decisions.

So say you just converted an ext4 to btrfs. It's got all those oddly 
sized and placed extents. You could give them all higher numbers in 
hopes that the data would naturally migrate away. Say just number them 
really large with no two numbers the same. Now the largest number would 
naturally become vacant and likely to be freed.

Likewise you could weight your data to migrate spindle-ward or such in 
the weeks before a reorg.

Similarly changes in geometry could simply mark segments as ill-favoured 
where the old geometry doesn't match the new and data would migrate 
under pressure.

One could reverse the age induced entropy of a file system by just 
periodically increasing the disfavour values of all the blocks, causing 
the oldest blocks to be the least favoured of all, and so creating a 
slowly rolling pattern.

So say new blocks start life as 50s by default. And empty space is 100. 
And every so often every block gets an increment (say 3 so that 100 is 
naturally skipped over.

Young blocks are now very magnetic. As they age they lose favour. 
Eventually they pass the value for unallocated space. Then they start 
losing data and eventually, in a system with 100 percent turnover the 
blocks get deallocated.

defragging and occasional balancing take care of the files that "never" 
change.

Very high numbers could also be reserved for pinning. Specially flagged 
files would have reverse gravity. A desire to stay put. So say a NOCOW 
files or Swap Files might have reverse gravity and one could use some 
tool to allocate blocks at the cold end of the disk with those sorts of 
numbers. Effectively segregating the the static from the churning data.

Fresh files would thereby tend to vacate extents full of snapshot data 
and freeing static (Read only) snapshot data would tend to release 
contiguous space.

As the disk runs out of space the system naturally breaks down into the 
existing best-fit allocation.

It's less than a defrag or autodefrag, or balance, and it would tend to 
be more like digestive peristalsis, at the extreme end (where people are 
taking way too many snapshots) it becomes an elevator sort by extent age.

(If this is a tired idea, my apologies. I took cough medicine a little 
while ago and this thought that's been rattling around in my head for 
months bubbled out of its cauldron.)
