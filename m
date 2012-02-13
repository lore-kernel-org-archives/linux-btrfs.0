From: David Sterba <dave@jikos.cz>
Subject: [RFB] add LZ4 compression method to btrfs
Date: Mon, 13 Feb 2012 20:03:25 +0100
Message-ID: <20120213190325.GJ15350@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

so here it is, LZ4 compression method inside btrfs. The patchset is based on
top of current Chris' for-linus + Andi's snappy implementation + the fixes from
Li Zefan. Passes xfstests and stresstests.

I haven't measured performance on wide range of hardware or workloads, rather
wanted to publish the patches before I get distracted again.  I'd like to ask
anyone willing and able to test this to share your results with us.

At least an example from standalone benchmarks of
snappy-c/snappy(upstream)/lzo/lz4:

Silesia corpus (avg of 10 runs), AMD bulldozer box, 12G ram, 1Ghz cpu:

lz4              =   739860 us ( 286 MB/s)   195930 us (1081 MB/s) 211957760 -> 101630873 47.9%
snappy 1.0.4     =     1050 ms ( 201 MB/s)      248 ms ( 853 MB/s) 211957760 -> 104739310 49.4%
snappy-c         =   940111 us ( 225 MB/s)   299690 us ( 707 MB/s) 211957760 -> 131060567 61.8%
lzo 2.06 1x_1    =   739421 us ( 286 MB/s)   436542 us ( 485 MB/s) 211957760 -> 100576151 47.5%

Silesia corpus (avg of 10 runs), Nehalem X7560, 2.3Ghz cpu:

lz4              =   624170 us ( 339 MB/s)   200622 us (1056 MB/s) 211957760 -> 101630873 47.9%
snappy 1.0.4     =     1047 ms ( 202 MB/s)      265 ms ( 797 MB/s) 211957760 -> 104739310 49.4%
snappy-c         =   836415 us ( 253 MB/s)   300567 us ( 705 MB/s) 211957760 -> 131060567 61.8%
lzo 2.06 1x_1    =   639305 us ( 331 MB/s)   470840 us ( 450 MB/s) 211957760 -> 100576151 47.5%

* snappy 1.0.4 svn r58
* snappy-c as Andi sent it to mailinglist
* lzo 2.0.6 1x_1 variant
* lz4 r55 (r54 + bugfix in the hash table entry type)
* compiled by gcc 4.7, -O2

pullable from:
  git://repo.or.cz/linux-2.6/btrfs-unstable.git dev/compression-squad

david
