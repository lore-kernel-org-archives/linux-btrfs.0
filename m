Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:50057 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaBNKG6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 05:06:58 -0500
Received: from [192.168.20.8] (unknown [192.168.20.8])
	by mail.synology.com (Postfix) with ESMTPA id E9166C9649
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 17:57:37 +0800 (CST)
Message-ID: <52FDE890.8060208@synology.com>
Date: Fri, 14 Feb 2014 17:57:36 +0800
From: EthanLien <ethanlien@synology.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: A WARN_ON running fsstress punch hole
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I used the command "fsstress -f punch=20 -d /volume1 -n 10000 -p 50"
to repeatedly stress my btrfs volume

After a few hours stress, I got a WARN_ON at fs/btrfs/file.c:553
It seems someone gave btrfs_drop_extent_cache a range to drop
where end < start

The call flow is btrfs_punch_hole , __btrfs_drop_extents , fill_holes , 
btrfs_drop_extent_cache. I found when the WARN_ON was hit,
__btrfs_drop_extents sent a range where cur_offset == drop_end
thus caused the WARN_ON

Now I think there may be some problems with __btrfs_drop_extents.
I set some logs in __btrfs_drop_extents and find it will return
*drop_end = start and the return value ret is still 0 in some situations.
In this situation, __btrfs_drop_extents intends to drop many extents.
The first extent is truncated, and the extent_end is set to start. The
following extents are entirely dropped. Finally, it loops back to the 
beginning
of the while loop and uses btrfs_next_leaf to search next leaf, but somehow
it gets the extent which is first truncated and thus return *drop_end = 
start

Has anyone ever met problem like this?

Thanks

