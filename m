Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:39793 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaJ0KnW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 06:43:22 -0400
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id EAB943DD09
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 11:34:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id D1FF53DCCF
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 11:34:41 +0100 (CET)
Date: Mon, 27 Oct 2014 03:34:41 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: linux-btrfs@vger.kernel.org
Subject: suspicious number of devices: 72057594037927936
Message-ID: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(somehow this message did not make it to the list)

Hi,

After upgrading from linux 3.17.0 to 3.18.0-rc2, I cannot mount my btrfs 
partition any more. It's just one btrfs partition, no raid, no 
compression, no fancy mount options:

# mount -t btrfs -o ro /dev/sda6 /usr/local/
mount: wrong fs type, bad option, bad superblock on /dev/sda6,
[...]
BTRFS: suspicious number of devices: 72057594037927936
BTRFS: super offset mismatch 1099511627776 != 65536
BTRFS: superblock contains fatal errors
BTRFS: open_ctree failed

The only thing fancy may be the machine: PowerBook G4 (powerpc 32 bit), 
running Debian/Linux (stable).

The message comes from the newly added fs/btrfs/disk-io.c:

if (sb->num_devices > (1UL << 31))
     printk(KERN_WARNING "BTRFS: suspicious number of devices: %llu\n",
              sb->num_devices);

And 72057594037927936 is 2^56, so maybe there's an endianess problem here?

Some details below, please let me know what other details may be needed.
Going back to 3.17 now...

Thanks,
Christian.

# file -Ls /dev/sda6
/dev/sda6: sticky BTRFS Filesystem sectorsize 4096, nodesize 4096, 
leafsize 4096)

# btrfsck /dev/sda6
checking extents
checking fs roots
checking root refs
found 2035929088 bytes used err is 0
total csum bytes: 1886920
total tree bytes: 102936576
total fs tree bytes: 94441472
btree space waste bytes: 30875964
file data blocks allocated: 1932992512
 referenced 1932849152
Btrfs Btrfs v0.19
# echo $?
0


-- 
BOFH excuse #427:

network down, IP packets delivered via UPS
