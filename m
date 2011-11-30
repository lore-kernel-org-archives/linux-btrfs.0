From: Sten Spans <sten@blinkenlights.nl>
Subject: mkfs.btrfs failure on ARM
Date: Wed, 30 Nov 2011 21:30:46 +0100 (CET)
Message-ID: <alpine.DEB.0.99999.1111302114210.15548@zem.blinkenlights.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I'm hitting an error with the default mkfs.btrfs in debian wheezy:
ford:~# uname -a
Linux ford.blinkenlights.nl 3.1.0-1-kirkwood #1 Tue Nov 15 00:17:24 UTC 
2011 armv5tel GNU/Linux
ford:~/btrfs-progs# dpkg -l | grep btrfs
ii  btrfs-tools                           0.19+20111105-1 
Checksumming Copy on Write Filesystem utilities
ford:~# mkfs.btrfs /dev/vgroot/home
WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

mkfs.btrfs: volumes.c:1575: btrfs_read_chunk_tree: Assertion `!(ret)' 
failed.

A fresh clone gives me:

ford:~/btrfs-progs# ./mkfs.btrfs /dev/vgroot/home
WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

mkfs.btrfs: volumes.c:846: btrfs_alloc_chunk: Assertion `!(ret)' failed.
Aborted

Tested with gcc 4.4 and 4.6.

I did a git bisect and ended up here:

ford:~/btrfs-progs# git bisect bad
4e64e05c6b8d9a1ed30bb6eda30ef8e93c6af260 is the first bad commit
commit 4e64e05c6b8d9a1ed30bb6eda30ef8e93c6af260
Author: Donggeun Kim <dg77.kim@samsung.com>
Date:   Thu Jul 8 09:17:59 2010 +0000

     btrfs-progs: Add new feature to mkfs.btrfs to make file system image 
file from source directory


Anybody got a clue as to what the problem might be?

-- 
Sten Spans

"There is a crack in everything, that's how the light gets in."
Leonard Cohen - Anthem
