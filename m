Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:35322 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbaBMQOB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 11:14:01 -0500
Received: from [192.168.100.50] (cpe-024-088-095-145.sc.res.rr.com [24.88.95.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id B5D04D305
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 11:13:58 -0500 (EST)
Message-ID: <52FCEF46.3070306@jrs-s.net>
Date: Thu, 13 Feb 2014 11:13:58 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs-RAID(3 or 5/6/etc) like btrfs-RAID1?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This might be a stupid question but...

Are there any plans to make parity RAID levels in btrfs similar to the 
current implementation of btrfs-raid1?

It took me a while to realize how different and powerful btrfs-raid1 is 
from traditional raid1.  The ability to string together virtually any 
combination of "mutt" hard drives together in arbitrary ways and yet 
maintain redundancy is POWERFUL, and is seriously going to be a killer 
feature advancing btrfs adoption in small environments.

The one real drawback to btrfs-raid1 is that you're committed to n/2 
storage efficiency, since you're using pure redundancy rather than 
parity on the array.  I was thinking about that this morning, and 
suddenly it occurred to me that you ought to be able to create a striped 
parity array in much the same way as a btrfs-raid1 array.

Let's say you have five disks, and you arbitrarily want to define a 
stripe length of four data blocks plus one parity block per "stripe".  
Right now, what you're looking at effectively amounts to a RAID3 array, 
like FreeBSD used to use.  But, what if we add two more disks? Or three 
more disks? Or ten more?  Is there any reason we can't keep our stripe 
length of four blocks + one parity block, and just distribute them 
relatively ad-hoc in the same way btrfs-raid1 distributes redundant data 
blocks across an ad-hoc array of disks?

This could be a pretty powerful setup IMO - if you implemented something 
like this, you'd be able to arbitrarily define your storage efficiency 
(percentage of parity blocks / data blocks) and your fault-tolerance 
level (how many drives you can afford to lose before failure) WITHOUT 
tying it directly to your underlying disks, or necessarily needing to 
rebalance as you add more disks to the array.  This would be a heck of a 
lot more flexible than ZFS' approach of adding more immutable vdevs.

Please feel free to tell me why I'm dumb for either 1. not realizing the 
obvious flaw in this idea or 2. not realizing it's already being worked 
on in exactly this fashion. =)
