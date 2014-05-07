Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaEGK4y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:56:54 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s47AurvT026885
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:54 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s47Aurp6007083
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:53 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s47AuhWT027024
	for <linux-btrfs@vger.kernel.org>; Wed, 7 May 2014 10:56:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 0/3] Btrfs: add xxhash algorithm
Date: Wed,  7 May 2014 18:56:29 +0800
Message-Id: <1399460193-1713-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"xxHash is an extremely fast non-cryptographic Hash algorithm, working at speeds
close to RAM limits."[1]  And xxhash is 32-bits hash, same as crc32.

Here is the hash comparsion extracted from the link[1]:
(single thread, Windows Seven 32 bits, using Open Source's SMHasher on a Core 2
Duo @3GHz)

--------------------------------------------
Name            Speed       Q.Score   Author
xxHash          5.4 GB/s     10
CRC32           0.43 GB/s     9
--------------------------------------------


This patch set adds xxhash into linux kernel and then modifies btrfs's checksum
API a bit and adopts xxhash as an alternative checksum algorithm.

At the very first stage of RFC, I only ran xfstests through to make sure it
can work.  A bunch of performance tests will be made in the future.

Note:

We need to update btrfs-progs side as well to set it up, I attach a hacky
patch just for users to play with ;-)



[1]: https://code.google.com/p/xxhash/

Liu Bo (3):
  Crypto: add xxhash algorithm
  Crypto: xxhash: add tests
  Btrfs: add another checksum algorithm xxhash

 crypto/Kconfig              |   7 +
 crypto/Makefile             |   1 +
 crypto/testmgr.c            |  10 ++
 crypto/testmgr.h            |  33 ++++
 crypto/xxhash.c             | 383 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/Kconfig            |  22 +++
 fs/btrfs/compression.c      |   6 +-
 fs/btrfs/ctree.h            |  12 +-
 fs/btrfs/dir-item.c         |  10 +-
 fs/btrfs/disk-io.c          | 126 ++++++++-------
 fs/btrfs/disk-io.h          |   2 -
 fs/btrfs/extent-tree.c      |  43 +++--
 fs/btrfs/file-item.c        |   9 +-
 fs/btrfs/free-space-cache.c |  15 +-
 fs/btrfs/hash.c             |  75 +++++++--
 fs/btrfs/hash.h             |  22 ++-
 fs/btrfs/inode-item.c       |   6 +-
 fs/btrfs/inode.c            |  16 +-
 fs/btrfs/props.c            |  37 ++++-
 fs/btrfs/props.h            |   3 +-
 fs/btrfs/scrub.c            |  70 ++++++--
 fs/btrfs/send.c             |   7 +-
 fs/btrfs/super.c            |   9 +-
 fs/btrfs/tree-log.c         |   2 +-
 include/crypto/xxhash.h     | 209 ++++++++++++++++++++++++
 25 files changed, 974 insertions(+), 161 deletions(-)
 create mode 100644 crypto/xxhash.c
 create mode 100644 include/crypto/xxhash.h

-- 
1.8.1.4

