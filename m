From: Christian Kujau <lists@nerdbynature.de>
Subject: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 5 Feb 2010 10:36:52 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: davem@davemloft.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


When writing to a newly created btrfs (vanilla 2.6.33-rc6, sparc64) the 
following messages are printed:

[28617.650231] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[28617.745783] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[28654.589492] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[28654.685036] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[28689.595394] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]

...and so on. I've seen these "unaligned access at TPC" on sparc64 
before[0], but they were not btrfs related. Btw, *reading* does not cause 
these messages.

At one point and when lots of I/O was going on, the following appeared once, inbetween
the other messages:

[31419.847052] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]
[31447.243224] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]
[31447.338727] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]
[33888.613296] btrfs: loop0 checksum verify failed on 39084032 wanted EAFC29EA found BBFFFFFF level 0
[34421.508271] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]
[34421.603872] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]
[34452.965546] Kernel unaligned access at TPC[102a3f18] btrfs_csum_final+0x38/0x60 [btrfs]

No messages from the backing device have been reported though, but I'm 
not so sure about the system's RAM, so it might be a hardware issue after 
all. I was not able to reproduce the "checksum verify failed" yet.

Full dmesg and .config: http://nerdbynature.de/bits/2.6.33-rc6/btrfs/

Christian.


[0] http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-02/msg01327.html
-- 
BOFH excuse #369:

Virus transmitted from computer to sysadmins.
