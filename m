Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54548 "EHLO
	homiemail-a46.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbaDWRY5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 13:24:57 -0400
Received: from homiemail-a46.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a46.g.dreamhost.com (Postfix) with ESMTP id 4C3A53E4073
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 10:24:57 -0700 (PDT)
Received: from bheem.localnet (unknown [49.248.64.37])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ghodechhap@ghodechhap.net)
	by homiemail-a46.g.dreamhost.com (Postfix) with ESMTPSA id DAAE13E406E
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 10:24:56 -0700 (PDT)
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: linux-btrfs@vger.kernel.org
Subject: inode cache rebuild problem
Date: Wed, 23 Apr 2014 23:07:13 +0630
Message-ID: <2497757.A2A0fxBM0J@bheem>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a desktop system with 2 disks, all btrfs, single partition. All of 
these partitions had 
space_cache,inode_cache enabled.

Linux 3.14 has broken resume on my desktop, hence I need to shutdown and 
restart the 
machine every time. 

But even on clean reboot, inode_cache was constantly being rebuilt on each 
boot. It 
caused kdm/X to timeout, even getty weren't spawned. I had to reboot it with 
ctrl-alt-delete, 
just to make it usable again. 2 out of 3 times, I had to reboot more than 
once, to make it 
usable.

While the disk was constantly grinding in the boot process, I ssh'ed into it 
from another 
machine and observed the inode cache overhead.

Hence I disabled both the caches on all the partition(yes, I know, space_cache 
will stick 
around), and the machine is lot more snappier and responsive than ever before.

I am running archlinux with 3.14.1 kernel.

Thanks,
-- 
Regards
 Shridhar
