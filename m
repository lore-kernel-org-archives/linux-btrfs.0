Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35386 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbbHZEmR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 00:42:17 -0400
Date: Tue, 25 Aug 2015 23:04:42 -0500
From: Jun He <jhe@cs.wisc.edu>
To: linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: btrfs -o discard bug in latest dev branches
Message-ID: <20150826040442.GC10927@Juns-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have been playing with btrfs discard for a while and found that btrfs may
fail to discard some extents with 'mount -o discard'. I am aware of Jeff
Mahoney's patches ( https://patchwork.kernel.org/patch/6609491/ ). It seems
that the patches do not fix the problem. I have seen the same problematic
behavior for the following versions 

- https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/
  integration-4.3 commit:477594f93c43b1ee685
- 3.16.0
- 4.2.0-rc7

The problem can be reproduced by writing and fsyncing a 4MB file for 50 times
on a 256MB empty FS (mount option: -o discard). You will find that some extents
are not discarded (my expected behavior is that, after overwriting, an old
version of a file extent should be discarded). I use several ways to confirm
this:

1. I created a loop device back by a sparse file in tmpfs. After running the
workload, I found the file is 29MB (ls -lsh). If you fstrim the file system,
the sparse file will become 4.1MB. This proves that there are a lot of data not
discarded.

2. I collected blktrace + blkparse output and plotted the write and discard
operations in a space-time graph, where you can intuitively see some extents
are overwritten but not discarded. Here is the space-time graph
https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/raw/825a3c2946b52a50c2b6032a98d637f5a32bc5c3/integration-4.3.png

Is it a known problem or is it not a problem? If it is a known problem and
there exists a patch that I am not aware of, can somebody direct me to it? If
it is specifically designed this way, can the designers give the rationale of
discarding some, but not all of, old extents?

The reproducer can be run by:
git clone https://gist.github.com/b6ce39eeb6de8887e66a.git
cd b6ce39eeb6de8887e66a
sudo python main.py

It also has a readme.

Thanks,
Jun



