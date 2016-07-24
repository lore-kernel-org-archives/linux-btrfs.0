Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:41687 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752040AbcGXLDe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jul 2016 07:03:34 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>
Subject: [BTRFS-PROGS][PATCH] Add two new commands: 'btrfs insp physical-find' and 'btrfs insp physical-dump'
Date: Sun, 24 Jul 2016 13:03:24 +0200
Message-Id: <1469358209-9427-1-git-send-email-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

the following patches add two new commands: 
1) btrfs inspect-internal physical-find
2) btrfs inspect-internal physical-dump

The aim of these two new commands is to locate (1) and dump (2) the stripe elements
stored on the disks. I developed these two new command to simplify the
debugging of some RAID5 bugs (but this is another discussion).

An example of 'btrfs inspect-internal physical-find' is the following:

# btrfs inspect physical-find mnt/out.txt
mnt/out.txt: 0
        devid: 3 dev_name: /dev/loop2 offset: 61931520 type: DATA
        devid: 2 dev_name: /dev/loop1 offset: 61931520 type: OTHER
        devid: 1 dev_name: /dev/loop0 offset: 81854464 type: PARITY
        devid: 4 dev_name: /dev/loop3 offset: 61931520 type: PARITY

In the output above, DATA is the stripe elemnt conaining data. OTHER
is the sibling stripe elemnt: it contains data related to or other files
or to the same file but different position. The two stripe elements contain
the RAID6 parity (P and Q).

It is possible to pass the offset of the file to inspect.

An example of 'btrfs inspect-internal physical-dump' is the following

# btrfs insp physical-find mnt/out.txt 
mnt/out.txt: 0
devid: 5 dev_name: /dev/loop4 offset: 56819712 type: OTHER
devid: 4 dev_name: /dev/loop3 offset: 56819712 type: OTHER
devid: 3 dev_name: /dev/loop2 offset: 56819712 type: DATA
devid: 2 dev_name: /dev/loop1 offset: 56819712 type: PARITY
devid: 1 dev_name: /dev/loop0 offset: 76742656 type: PARITY

# btrfs insp physical-dump mnt/out.txt | xxd 
mnt/out.txt: 0
file: /dev/loop2 off=56819712
00000000: 6164 6161 6161 6161 6161 6161 6161 6161  adaaaaaaaaaaaaaa
00000010: 6161 6161 6161 6161 6161 6161 6161 6161  aaaaaaaaaaaaaaaa
00000020: 6161 6161 6161 6161 6161 6161 6161 6161  aaaaaaaaaaaaaaaa
00000030: 6161 6161 6161 6161 6161 6161 6161 6161  aaaaaaaaaaaaaaaa
00000040: 6161 6161 6161 6161 6161 6161 6161 6161  aaaaaaaaaaaaaaaa
[...]

In this case it is dumped the content of the first 4k of the file. It 
is possible to pass also an offset (at step of 4k). Moreover
it is possible to select to dump: which copy has to be dumped (switch -c,
only for RAID1/RAID10/DUP); which parity has to be dumped (switch -p,
only for RAID5/RAID6); which stripe element other than data (switch -s,
only for RAID5/RAID6).

BR
G.Baroncelli


