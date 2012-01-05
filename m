From: Michael Andreen <harv@ruin.nu>
Subject: Filesystem not mountable after reset, bad tree block
Date: Thu, 5 Jan 2012 23:59:47 +0100
Message-ID: <201201052359.47932.harv@ruin.nu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Today one of my machines (running kernel 3.0.6) locked up, sadly the monitor 
was stuck in power saving mode and no access over network so not sure exactly 
what happened. After restarting the machine, the root filesystem is no longer 
mountable the following output appears: 

device label SSD devid 1 transid 507930 /dev/sdb2
btrfs bad tree block start 0 188205998080
btrfs bad tree block start 0 188205998080
btrfs bad tree block start 0 188205998080
btrfs: open_ctree failed

I downloaded the latest btrfs-progs, but getting similar output from several 
of the programs:

# ./btrfs-debug-tree /dev/sdb2
Check tree block failed, want=188205998080, have=0
Check tree block failed, want=188205998080, have=0
Check tree block failed, want=188205998080, have=0
Check tree block failed, want=188205998080, have=0
Check tree block failed, want=188205998080, have=0
read block failed check_tree_block
btrfs-debug-tree: disk-io.c:447: find_and_setup_root: Assertion `!(!root-
>node)' failed.
Aborted

The find-root program seems to think there is a root (and poentially some 
older roots?), but not sure how to use that information.

# ./find-root /dev/sdb2 
Super think's the tree root is at 131212083200, chunk root 20983808
Well block 13856997376 seems great, but generation doesn't match, have=321485, 
want=507930
Well block 16362573824 seems great, but generation doesn't match, have=317992, 
want=507930
Well block 16367947776 seems great, but generation doesn't match, have=321490, 
want=507930
Well block 36317024256 seems great, but generation doesn't match, have=195981, 
want=507930
Well block 39698722816 seems great, but generation doesn't match, have=273675, 
want=507930
Well block 39714439168 seems great, but generation doesn't match, have=320627, 
want=507930
Well block 43016519680 seems great, but generation doesn't match, have=272156, 
want=507930
Well block 43031748608 seems great, but generation doesn't match, have=302652, 
want=507930
Well block 47617982464 seems great, but generation doesn't match, have=274708, 
want=507930
Found tree root at 131212083200

Anything else I can do to debug this or potentially recover a few bits before 
reformatting?

/Michael
