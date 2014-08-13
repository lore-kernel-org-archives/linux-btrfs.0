Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37798 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbaHMFfv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Aug 2014 01:35:51 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by gateway1.nyi.internal (Postfix) with ESMTP id 7D93827E68
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 01:35:50 -0400 (EDT)
Received: from Rosa.local (unknown [80.71.133.206])
	by mail.messagingengine.com (Postfix) with ESMTPA id 25291680228
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Aug 2014 01:35:50 -0400 (EDT)
Message-ID: <53EAF935.4040605@rasmusa.net>
Date: Wed, 13 Aug 2014 07:35:49 +0200
From: Rasmus Abrahamsen <me@rasmusa.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: delete missing /dev/sdd which is now added as /dev/sdd1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a BTRFS mirrored raid on three disks: 500 GB, 1000 GB, 1500 GB.
The 1500 GB is going bad.

I bought a 4000 GB and wanted to make a 1500 GB and also a 2500 GB
partition. By mistake I made a 1.5 GB and did not realize it until much
later.

I added the 1.5 GB to my raid and tried removing the 1500 GB, I
obviously coudn't. I ended up turning off the machine and unplugging the
1500 GB and tried the btrfs delete missing, but that failed too because
delete missing needs new space available otherwise it will fail.

So I reformatted my 1500 GB and added it to the raid again, it showed
up... but twice... I had one empty /dev/sdd and one non-empty /dev/sdd.

I figured I could fix it by removing and formatting it again, this time
creating a partition using fdisk, it would change the device to
/dev/sdd1.

I added the /dev/sdd1 to my raid and deleted the missing. Now the
/dev/sdd does not show up anymore and I have a /dev/sdd1. But I still
have the **** Some devices missing and the command btrfs delete missing
/mnt does not actually do anything. I tried btrfs delete /dev/sdd /mnt
but it said that /dev/sdd was busy.

How can I tell btrfs that it is NOT the same drive?

Here is a screenshot from the machine:
https://www.dropbox.com/s/f33l4ncsni7wd0s/2014-08-13%2007.31.42.jpg

I figured I could somehow change the /dev/ name, but I am not sure how.

Rasmus
