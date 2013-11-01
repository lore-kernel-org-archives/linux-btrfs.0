Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3KAW3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Nov 2013 18:29:48 -0400
Message-ID: <52742B59.3060405@friedels.name>
Date: Fri, 01 Nov 2013 23:29:45 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfsck errors is it save to fix?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have noticed that my server experiences high load average when writing 
to it. So I checked the file-system and found errors:

./btrfsck /dev/sdc1
Checking filesystem on /dev/sdc1
UUID: 989306aa-d291-4752-8477-0baf94f8c42f
checking extents
checking free space cache
checking fs roots
root 256 inode 9579 errors 100
root 256 inode 9580 errors 100
root 256 inode 14258 errors 100
root 256 inode 14259 errors 100
root 4444 inode 9579 errors 100
root 4444 inode 9580 errors 100
root 4444 inode 14258 errors 100
root 4444 inode 14259 errors 100
found 1478386534452 bytes used err is 1
total csum bytes: 3207847732
total tree bytes: 3902853120
total fs tree bytes: 38875136
total extent tree bytes: 135856128
btree space waste bytes: 411653937
file data blocks allocated: 3426722545664
  referenced 3426000965632
Btrfs v0.20-rc1-358-g194aa4a

It is a system striped over two physical disks.
Now, what concerns me is that I found no indications of problems except 
for the performance whatsoever. Nothing in the syslog.

Now that I am searching, I see this in dmesg:
[95764.899359]  [<ffffffffa00d9a59>] free_fs_root+0x99/0xa0 [btrfs]
[95764.899384]  [<ffffffffa00dd653>] 
btrfs_drop_and_free_fs_root+0x93/0xc0 [btrfs]
[95764.899408]  [<ffffffffa00dd74f>] del_fs_roots+0xcf/0x130 [btrfs]
[95764.899433]  [<ffffffffa00ddac6>] close_ctree+0x146/0x270 [btrfs]
[95764.899461]  [<ffffffffa00b4eb9>] btrfs_put_super+0x19/0x20 [btrfs]
[95764.899493]  [<ffffffffa00b754a>] btrfs_kill_super+0x1a/0x90 [btrfs]

Now the fact that the load went up indicates to me that the system 
struggled reading or writing. Can't this "struggeling" be detected and 
reported? Wouldn't this contribute to data-safety?

An the for me now more pressing question:

How can I fix the problem?


Greetings,
Hendrik
