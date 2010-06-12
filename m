From: Jim Ursetto <jim@3e8.org>
Subject: reflinked file size incorrect
Date: Sat, 12 Jun 2010 11:48:48 -0500
Message-ID: <20100612164848.GB16863@3e8.org>
Reply-To: Jim Ursetto <jim@3e8.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Both `cp --reflink` and `bcp` sometimes round the file size up to the next
4k boundary, with the balance consisting of null bytes.  At first glance
this behavior occurs for source file size > 3916 bytes.  I have tried this
with stock btrfs from kernel 2.6.35-rc2 and 2.6.35-rc1 -- specifically,
Ubuntu 2.6.35-2.3~lucid1-server and 2.6.35-1.1~lucid1-server.
Any ideas?

$ rm -f abc; dd if=/dev/urandom of=abc bs=1 count=3917; \
  cp --reflink abc abc.1; ll abc*
3917 bytes (3.9 kB) copied, 0.0380613 s, 103 kB/s
-rw-r----- 1 root root 3917 2010-06-12 04:22 abc
-rw-r----- 1 root root 4096 2010-06-12 04:22 abc.1

$ rm -f abc; dd if=/dev/urandom of=abc bs=1 count=3916; \
  cp --reflink abc abc.1; ll abc*
3916 bytes (3.9 kB) copied, 0.0299729 s, 131 kB/s
-rw-r----- 1 root root 3916 2010-06-12 04:22 abc
-rw-r----- 1 root root 3916 2010-06-12 04:22 abc.1

$ rm -f abc; dd if=/dev/urandom of=abc bs=1 count=4097; \
  cp --reflink abc abc.1; ll abc*
4097 bytes (4.1 kB) copied, 0.0258441 s, 159 kB/s
-rw-r----- 1 root root 4097 2010-06-12 11:08 abc
-rw-r----- 1 root root 8192 2010-06-12 11:08 abc.1

$ uname -a
Linux allie 2.6.35-2-server #3~lucid1-Ubuntu SMP Thu Jun 10 17:52:32 UTC 2010 x86_64 GNU/Linux

Jim
