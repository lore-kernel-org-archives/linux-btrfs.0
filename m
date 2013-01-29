Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab3A2LNJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 06:13:09 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r0TBD6bb023454
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Jan 2013 19:13:06 +0800
Message-ID: <5107AEEB.2030106@cn.fujitsu.com>
Date: Tue, 29 Jan 2013 19:13:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: About Chunk Tree recover
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, everyone.

About 1 years ago, we implemented the chunk tree recover function,
but it has not been applied till now because that implementation
need change the disk format.
(http://marc.info/?l=linux-btrfs&m=129914269932543&w=2
 http://marc.info/?l=linux-btrfs&m=130976668006281&w=2
 http://marc.info/?l=linux-btrfs&m=129914269932543&w=2)

Recently, I reconsidered the implementation of this function, and
found a new approach that needn't change the disk format. That is
the external chunk tree backup, just like external journal device
of ext4. The basic idea is:

- specify a external file or device which is used to backup the
  chunk tree when mount.
- When mount, compare the super block in the external file/device
  with the super block of the btrfs, if the checksum of the super
  block in the externel file/device is right, and the FS UUID and
  generation are the same as the fs, it means the chunk tree in
  the external file/device is valid, needn't rebuild it. Otherwise,
  we will rebuild the chunk tree in the external file/device
  according to the chunk tree of the fs.
- When we allocate a new chunk, we will log the new chunk
  information into the external file/device
- sync the external file/device when committing the transaction
- If the chunk tree of the fs is corrupted, we use the information
  in the external file/device to recover it.
  
By this way, we needn't change disk format and also needn't do a
block device scan which need lots of time, and is very hard to
find the start address and length of a chunk.

Any comment for this idea?

Thanks
Miao
