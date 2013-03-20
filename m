Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:46573 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3CTJJ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 05:09:59 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so672713eek.22
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2013 02:09:57 -0700 (PDT)
Message-ID: <51497CE2.308@statystyka.net>
Date: Wed, 20 Mar 2013 10:09:54 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Problem with building instructions for btrfs-tools in https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a missing dependency: liblzo2-dev

Without it, the make fails with:

~/tmp$ git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

~/tmp$ cd btrfs-progs

~/tmp/btrfs-progs$ sudo apt-get install uuid-dev libattr1-dev zlib 
1g-dev libacl1-dev e2fslibs-dev libblkid-dev

~/tmp/btrfs-progs$ make
     [CC]     ctree.o
     [CC]     disk-io.o
     [CC]     radix-tree.o
     [CC]     extent-tree.o
     [CC]     print-tree.o
     [CC]     root-tree.o
     [CC]     dir-item.o
     [CC]     file-item.o
     [CC]     inode-item.o
     [CC]     inode-map.o
     [CC]     extent-cache.o
     [CC]     extent_io.o
     [CC]     volumes.o
     [CC]     utils.o
     [CC]     btrfs-list.o
     [CC]     repair.o
     [CC]     send-stream.o
     [CC]     send-utils.o
     [CC]     qgroup.o
     [CC]     raid6.o
     [CC]     rbtree.o
     [CC]     crc32c.o
     [LN]     libbtrfs.so.0
     [LN]     libbtrfs.so
     [LD]     libbtrfs.so.0.1
/usr/bin/ld: cannot find -llzo2
collect2: error: ld returned 1 exit status
make: *** [libbtrfs.so.0.1] Error 1

I suggest to make amendment to the wiki and add a "liblzo2-dev" to the 
apt-get line for Ubuntu/Debian.

-- 

Adam Ryczkowski
+48505919892 <callto:+48505919892>
Skype:sisteczko <skype:sisteczko>

