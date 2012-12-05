Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:63325 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2LEUvB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2012 15:51:01 -0500
Message-ID: <50BFB3B2.8040405@friedels.name>
Date: Wed, 05 Dec 2012 21:50:58 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: segmentation-fault in btrfsck (git-version)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

thanks for developing btrfsck!
Now, I'd like to contribute -as far as I can. I'm not a developer, but I 
do have some linux-experience.
I've been using btrfsck on two 3TB HDDs (mirrored) for a while now under 
Kernel 3.0. Now it's corrupt. I had some hard resets of the machine 
-which might have contributed. I do have a backup of the data -at least 
of the important stuff. Some TV-Recordings are missing. The reason I am 
writing is, to support the development.

Unfortunately, btrfsck (latest git-version) crashes with a segmentation 
fault, when trying to repair this.

Here's the backtrace:
root 261 inode 64375 errors 400
root 261 inode 64376 errors 400
btrfsck: disk-io.c:382: __commit_transaction: Assertion `!(!eb || 
eb->start != start)' failed.

Program received signal SIGABRT, Aborted.
0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
(gdb)
(gdb) backtrace
#0  0x00007ffff784c425 in raise () from /lib/x86_64-linux-gnu/libc.so.6
#1  0x00007ffff784fb8b in abort () from /lib/x86_64-linux-gnu/libc.so.6
#2  0x00007ffff78450ee in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#3  0x00007ffff7845192 in __assert_fail () from 
/lib/x86_64-linux-gnu/libc.so.6
#4  0x000000000040d3ae in __commit_transaction (trans=0x62e010, 
root=0xb66ae0) at disk-io.c:382
#5  0x000000000040d4d8 in btrfs_commit_transaction (trans=0x62e010, 
root=0xb66ae0) at disk-io.c:415
#6  0x000000000040743d in main (ac=<optimized out>, av=<optimized out>) 
at btrfsck.c:3587


Now, here's where my debugging knowledge ends. Are you interested in 
debugging this further, or is it a known bug?

Regards,
Hendrik
-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
