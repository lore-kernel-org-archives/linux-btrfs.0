Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.rocketinternet.net ([66.159.52.141]:57721 "EHLO
	smtp.rocketinternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3JDXO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Oct 2013 19:14:59 -0400
Message-ID: <524EE99A.8000603@mminternet.com>
Date: Fri, 04 Oct 2013 16:15:22 +0000
From: ray clancy <n6re@mminternet.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs raid0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How can I verify the read speed of a btrfs raid0 pair in archlinux.?

I assume raid0 means striped activity in a paralleled mode at lease 
similar to raid0 in mdadm.

How can I measure the btrfs read speed since it is copy-on-write which 
is not the norm in mdadm raid0.?

Perhaps I cannot use the same approach in btrfs to determine the 
performance.

Secondly, I see a methodology for raid10 using the command....mkfs.btrfs 
-m raid10 -d raid10 /dev/sda/dev/sdb /dev/sdc /dev/sdd...

Can I apply the parameters above for -m and -d for raid0?

If using raid0 for two devices and add another device, is it striped as 
raid0 also or does the system change it to raid1.

What happens to the speed of the system when a new device is added? Is 
it increased ?

Much I have at hand for mdadm software raido and it doubles the read 
speed.  What parallel exists in raid0 btrfs?  Or is it completely off 
base to expect a speed increase?
