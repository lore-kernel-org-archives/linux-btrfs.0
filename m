From: "Martin Fahr" <maf@gmx.eu>
Subject: another messed-up btrfs
Date: Fri, 01 Apr 2011 21:47:13 +0200
Message-ID: <20110401194713.6990@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 

I have put a linux system on an external SSD recently, using btrfs for both root (/) and /home. After a couple of hibernation cycles the system got stuck and I had to reboot it ignoring the memory image on disk. Unfortunately, even a normal reboot did not work anymore. The kernel complains about not being able to mount the root filesystem. 

I connected the disk to another system, where the two partitions were not mountable either. btrfsck gave:
> btrfsck /dev/sdc2        #this was root
btrfsck: disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
Aborted

Taking advice from some earlier emails I have found on this list, I downloaded the recent btrfsck code using git, compiled it, and did:
> btrfsck -s 1 /dev/sdc2
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
using SB copy 1, bytenr 67108864
Aborted
> btrfsck -s 2 /dev/sdc2
No valid Btrfs found on /dev/sdc2
using SB copy 2, bytenr 274877906944

The same commands for the other partition on the disk gives different messages, but still an unusable file system:

> btrfsck /dev/sdc4
parent transid verify failed on 59128545280 wanted 7937 found 7934
parent transid verify failed on 59128545280 wanted 7937 found 7934
parent transid verify failed on 59128545280 wanted 7937 found 7934
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
> btrfsck -s 1 /dev/sdc4
parent transid verify failed on 59128545280 wanted 7937 found 7934
parent transid verify failed on 59128545280 wanted 7937 found 7934
parent transid verify failed on 59128545280 wanted 7937 found 7934
btrfsck: disk-io.c:739: open_ctree_fd: Assertion `!(!tree_root->node)' failed.
using SB copy 1, bytenr 67108864
> btrfsck -s 2 /dev/sdc4
No valid Btrfs found on /dev/sdc4
using SB copy 2, bytenr 274877906944

The usual questions: Is there anything I could do to help analyze and fix the problem? Is there hope to restore the data any time soon, or should I better use the backup I have (and possibly move to an ext4 file system)?

Thx
Martin
