Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbaEGUHZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 16:07:25 -0400
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 0/3] btrfs-progs: add quota group verify to btrfsck
Date: Wed,  7 May 2014 13:07:14 -0700
Message-Id: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
	The following 3 patches add support to btrfsck to check the counts
in subvolume quota groups. With these patches a user can run btrfsck against
a volume and if quota is enabled, qgroup data will be checked against the
actual space used on disk. I also added a --qgroup-report option that will
run the qgroup checker (only) and print out a full report of all qgroups.

The patches can be pulled from the following branch:
git://github.com/markfasheh/btrfs-progs-patches.git qgroup-verify

The patches can also be viewed:
https://github.com/markfasheh/btrfs-progs-patches/tree/qgroup-verify

The first two patches set up for qgroups:

- The change in patch #1 is optional. It corrects the print of qgroup bytes
to be %llu as they are unsigned values.  This means however that corrupted
groups will no longer show a negative value but instead an unrealistically
large one.  It's my opinion that '-1' and '18446744073709551615' both look
pretty obviously broken when put in 'qgroup show' output so I'm going for
correctness. Here's the difference in output:

qgroupid rfer       excl                 
-------- ----       ----                 
0/5      16384      16384                
0/257    4109430784 -1429504             

qgroupid rfer       excl                 
-------- ----       ----                 
0/5      16384      16384                
0/257    4109430784 18446744073708122112 


- Patch 2 imports the ulist code from kernel. Any qgroup code that deals
with resolving refs to roots needs this so that it can insert into a 'list'
that guarantees unique items.

- Patch 3 adds the actual code to do the work of adding up referenced and
exclusive bytecounts.

This involves walking the extent tree and recording refs. We then resolve
implied refs by walking down from each interior node. Finally, shared ref
roots are found and each extent is accounted to any roots that reference it.

Here's what it looks like now if you run btrfsck against a filesystem with
a couple corrupted qgroups:

Checking filesystem on /dev/vdb2
UUID: 8203ca66-9858-4e3f-b447-5bbaacf79c02
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
checking quota groups
Counts for qgroup id: 257 are different
our:            referenced 4124762112 referenced compressed 4124762112
disk:           referenced 4109430784 referenced compressed 4109430784
diff:           referenced 15331328 referenced compressed 15331328
our:            exclusive 901120 exclusive compressed 901120
disk:           exclusive 18446744073708122112 exclusive compressed 18446744073708122112
diff:           exclusive 2330624 exclusive compressed 2330624
Counts for qgroup id: 280 are different
our:            referenced 3750768640 referenced compressed 3750768640
disk:           referenced 3750768640 referenced compressed 3750768640
our:            exclusive 14749696 exclusive compressed 14749696
disk:           exclusive 11882496 exclusive compressed 11882496
diff:           exclusive 2867200 exclusive compressed 2867200
found 1009512957 bytes used err is 0
total csum bytes: 3955388
total tree bytes: 346292224
total fs tree bytes: 331939840
total extent tree bytes: 9338880
btree space waste bytes: 48141929
file data blocks allocated: 6477553664
 referenced 6062055424
Btrfs v3.14.1-3-gc8c1814

There's a minor issue in that we'll also print out qgroups for deleted
subvolumes as they still persist on disk (not shown here). I'm pretty sure
we can fix that with a followup patch to just check them against existing
subvolumes when we initially read our qgroup info from disk.

Thanks,
	--Mark
