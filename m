Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:64504 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758244Ab3D3DUT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 23:20:19 -0400
Message-ID: <517F386B.8050308@q5comm.com>
Date: Mon, 29 Apr 2013 20:20:11 -0700
From: Stephen Weinberg <stephen@q5comm.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Panic while running defrag
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran into a panic while running find -xdev | xargs brtfs fi defrag 
'{}'. I don't remember the exact command because the history was not 
saved. I also started and stopped it a few times however.

The kernel logs were on a different filesystem. Here is the 
kern.log:http://fpaste.org/9383/36729191/

My setup is two 2TB hard drives in raid 1. They are both sata drives so 
as far as I know the USB disconnect line isn't referring to btrfs.

output of df -h:
/dev/sdb1 3.7T 3.2T 371G 90% /mount/point

I haven't figured out how to reproduce the bug.

-- Stephen
