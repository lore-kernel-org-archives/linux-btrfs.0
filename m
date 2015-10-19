Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7432 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbbJSJaT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 05:30:19 -0400
To: David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [devel branch]Btrfs-convert assert at volumes.c:1846
Message-ID: <5624B828.80405@cn.fujitsu.com>
Date: Mon, 19 Oct 2015 17:30:16 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David and all,

Recently I'm reworking the btrfs-convert chunk allocater to make it able 
to separate data and meta chunk.

But when I was testing, I found that, your devel branch, with the 
following commit just fails to convert an empty ext4 filesystem:

commit 0002085c53a5ac9ad1c538bfc3e39c80891c4a1a
Author: Zhao Lei <zhaolei@cn.fujitsu.com>
Date:   Mon Oct 12 21:23:04 2015 +0800

     btrfs-progs: fragments: use btrfs_open_dir for btrfs-fragments command

     We can use btrfs_open_dir() to check whether target dir is
     in btrfs's mount point before open, instead of checking it in
     deeper code, and return fuzzy error message.

     Before patch:
       ./btrfs-fragments -o 123 /mnt/tmp1
       ERROR: can't perform the search

     After patch:
       # ./btrfs-fragments -o 123 /mnt/tmp1
       ERROR: not a btrfs filesystem: /mnt/tmp1

     Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
     Signed-off-by: David Sterba <dsterba@suse.com>


The error output is:
create btrfs filesystem:
	blocksize: 4096
	nodesize:  16384
	features:  extref, skinny-metadata (default)
volumes.c:1846: btrfs_read_sys_array: Assertion failed.
./btrfs-convert(btrfs_read_sys_array+0x1b8)[0x42422c]
./btrfs-convert(btrfs_setup_chunk_tree_and_device_map+0x41)[0x41176b]
./btrfs-convert[0x411a22]
./btrfs-convert(open_ctree_fd+0x10)[0x411b59]
./btrfs-convert(main+0x1814)[0x4382d7]
/usr/lib/libc.so.6(__libc_start_main+0xf0)[0x7f5571479610]
./btrfs-convert(_start+0x29)[0x407979]

Any ideas?
I hope it won't block me too long to test my rework.

Thanks,
Qu
