Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50913 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaHNQJE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 12:09:04 -0400
Date: Thu, 14 Aug 2014 09:09:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com
Cc: takeuchi_satoru@jp.fujitsu.com
Subject: btrfs-zero-log fails, can't mount FS
Message-ID: <20140814160902.GA25370@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Running 3.15.5, laptop hung overnight, I was forced to reboot with sysrq.

After that, it wouldn't mount anymore:
[  689.366125] BTRFS: device label btrfs_pool1 devid 1 transid 237214 /dev/dm-1
[  716.384377] BTRFS info (device dm-1): disk space caching is enabled
[  716.566974] BTRFS: detected SSD devices, enabling SSD mode
[  716.567106] BTRFS: bad tree block start 8622613565695139001 49500766208
[  716.567220] BTRFS: bad tree block start 10955809011958619003 49500766208
[  716.567224] BTRFS: failed to read log tree
[  716.638634] BTRFS: open_ctree failed

Ok, btrfs-zero-log usually helps with this, but not this time:
legolas:~# btrfs-zero-log /dev/mapper/disk1 
Check tree block failed, want=49500766208, have=8622613565695139001
Check tree block failed, want=49500766208, have=8622613565695139001
Check tree block failed, want=49500766208, have=10955809011958619003
Check tree block failed, want=49500766208, have=10955809011958619003
Check tree block failed, want=49500766208, have=10955809011958619003
read block failed check_tree_block
Couldn't setup log root tree
legolas:~# 

It's recent:
legolas:~# btrfs-zero-log 
usage: btrfs-zero-log dev
Btrfs v3.14.1

mount -o ro,recovery /dev/mapper/disk1 /mnt/mnt
does not work either, but that's expected.

I can probably use some recovery tools to get data off it, but I already
have a backup.
I'd much rather not have to destroy and rebuild this partition.

Worst thing is that it happened with 3.15 and I had just changed it to
compress=none (although there was existing data was compresssed).

Do you have any suggestions on how to repair this partition so that it's
mountable again?

This is a good SSD (samsung evo 840), I'm not sure it's to blame for
corrupting data or writing it out of order and lying to the OS about it.
If that is not the case, does it mean btrfs is still getting into states
where it mangles the filesystem in a way that it can't mount it anymore?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
