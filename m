From: manio <manio@skyboo.net>
Subject: making mirror
Date: Tue, 27 Apr 2010 21:44:03 +0200
Message-ID: <4BD73E83.60509@skyboo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello
I've created btrfs on single partition (/dev/sdc3) using:
mkfs.btrfs /dev/sdc3
So far  ... it is running fine - but i would like to switch to raid1 
configuration.
Unfortunately - i didn't pass any information about raid (-m raid1 -d 
raid1) when i created it :(

Now i would like to hot-add a /dev/sda3 (which is same size as currently 
used /dev/sdc3).
The problem is - that i don't have free space on other partitions - so i 
cannot move data away, create FS from start and copy data back to 
running mirror.
Perfect solution would be a hot-adding new partition - but can i do it 
with btrfs-vol? If so - how?

regards,
-- 
manio
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
