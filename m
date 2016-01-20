Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758424AbcATVtd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 16:49:33 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>
Subject: [PATCH] btrfs-progs: add 'du' command
Date: Wed, 20 Jan 2016 13:49:24 -0800
Message-Id: <1453326567-20454-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

This patch adds a 'du' subcommand to btrfs. 'btrfs fi du' will
calculate disk usage of the target files using fiemap. For individual
files, it will report a count of total bytes, and exclusive (not
shared) bytes. We also calculate a 'set shared' value which is
described below.

Each argument to 'btrfs fi du' will have a 'set shared' value
calculated for it. We define each 'set' as those files found by a
recursive search of an argument to btrfs fi du. The 'set shared' value
then is a sum of all shared space referenced by the set.

'set shared' takes into account overlapping shared extents, hence it
isn't as simple as adding up shared extents. To efficiently find
overlapping regions, we store them in an interval tree. When the scan
of a file set is complete, we can walk the tree and calculate our
actual shared bytes while also taking into account any duplicate or
overlapping extents.

The interval tree implementation is taken from Linux v4.0. I went
ahead and made some small comment updates to rbtree.h and
rbtree_augmented.h while I was importing this code as both are used by
the interval tree and I needed to check for any code changes in those
headers.

Following this paragraph is a very simple example. I started with a
clean btrfs fs in which i copied vmlinuz from /boot. I then made a
snapshot of the fs root in 'snap1'. After the snapshot, I made a 2nd
copy of vmlinuz into the main fs to give us some not-shared data. The
output below shows a sum of all the space, and a 'set shared' with len
exactly equal to that of the single shared file.

# btrfs fi du .
total	exclusive	set shared	filename
76386304	0			./vmlinuz
76386304	0			./snap1/vmlinuz
76386304	0			./snap1
0	0			./vmlinuz.copy
152772608	0	76386304	.


A git tree of the patches can be found here:

https://github.com/markfasheh/btrfs-progs-patches/tree/du

or if you prefer to pull:

git pull https://github.com/markfasheh/btrfs-progs-patches du

Comments/feedback appreciated.
    --Mark
