Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extern.sonoring.de ([212.23.155.200]:57227 "EHLO
	cmail.imagmbh.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751829AbbDFLqo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Apr 2015 07:46:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by cmail.imagmbh.de (Postfix) with ESMTP id CB3DBB4BF7
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2015 13:40:45 +0200 (CEST)
Received: from cipher1 ([10.1.33.12])
	by localhost (cmail.imagmbh.de [10.1.33.15]) (amavisd-new, port 10028)
	with ESMTP id SUYIG1ZXGanB for <linux-btrfs@vger.kernel.org>;
	Mon,  6 Apr 2015 13:40:45 +0200 (CEST)
Received: from cmail.imagmbh.de ([127.0.0.1])
	by localhost (cmail.imagmbh.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Etokw-dO6Atp for <linux-btrfs@vger.kernel.org>;
	Mon,  6 Apr 2015 13:40:36 +0200 (CEST)
Received: from malu-aspire-v3-771.localnet (b2b-94-79-178-150.unitymedia.biz [94.79.178.150])
	(Authenticated sender: martin.h.ludwig@imagmbh.de)
	by cmail.imagmbh.de (Postfix) with ESMTPSA id 829AFB4BF7
	for <linux-btrfs@vger.kernel.org>; Mon,  6 Apr 2015 13:40:36 +0200 (CEST)
From: Martin <develop@imagmbh.de>
To: linux-btrfs@vger.kernel.org
Subject: recover corrupt BTRFS
Date: Mon, 06 Apr 2015 13:40:37 +0200
Message-ID: <10997785.A11jaNpIP8@malu-aspire-v3-771>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have to recover a corrupt btrfs. The size is approx 4.5 TB. The fs became 
corrupt by failure of a hardware-raid. The BTRFS was created using the 
"compress"-option.

For the restore-process I made an image, btrfs-progs are version 3.19, kernel 
3.19.2-1, 64 bit.

The 0. superblock was corrupt (bad magic superblock), copy 1 and copy 2 seem 
do be ok (checksum OK, same generation).

First I did a "btrfs-select-super -s 1 /dev/vg0/opt" with the result:
bytenr mismatch, want=448577536, have=448512000
using SB copy 1, bytenr 67108864

Mount with
mount -o ro,recovery /dev/vg0/opt /1/
fails with some
BTRFS (device dm-2): bad tree block start 21086208 21020672
and finaly
BTRFS: Failed to read block groups: -5
BTRFS: open_ctree failed

btrfs check /dev/vg0/opt yields thousands of  "bytenr mismatch, want=..., 
have=..."

btrfs check --repair /dev/vg0/opt obvious yields to the same "bytenr mismatch, 
want=..., have=..."
and then fails with some
Failed to find [344853970944, 168, 16384]
btrfs unable to find ref byte nr 344853970944 parent 0 root 2  owner 1 offset 0
and then
btrfs unable to find ref byte nr 30736384 parent 0 root 1  owner 0 offset 1
extent-tree.c:1730: write_one_cache_group: Assertion `ret` failed.

mounting fails as feard (BTRFS: Failed to read block groups: -5, BTRFS: 
open_ctree failed).

My next try was a "btrfs check --init-csum-tree /dev/vg0/opt" but that fails 
with "extent-tree.c:2698: alloc_reserved_tree_block: Assertion `ret` failed."

Next try: "btrfs check --init-extent-tree /dev/vg0/opt" but it also fails: 
"transaction.h:39: btrfs_start_transaction: Assertion `fs_info-
>running_transaction` failed."

"btrfs rescue chunk-recover /dev/vg0/opt" fails with a core dump.

"btrfs restore -v /dev/vg0/opt /1/test/" fails with "Error searching -5"

"btrfs restore -v -i /dev/vg0/opt /1/test/" restores most files but while small 
files were OK (size smaller some k), nearly all larger files are corrupt.

I did a "btrfs-find-root /dev/vg0/opt" with the result
Superblock thinks the generation is 160096
Superblock thinks the level is 1
Found tree root at 30670848 gen 160096 level 1
Well block 29900800(gen: 160095 level: 1) seems good, but generation/level 
doesn't match, want gen: 160096 level: 1
Well block 4243456(gen: 3 level: 0) seems good, but generation/level doesn't 
match, want gen: 160096 level: 1
Well block 4194304(gen: 2 level: 0) seems good, but generation/level doesn't 
match, want gen: 160096 level: 1

So I did also a
btrfs restore -v -t 30670848 -i /dev/vg0/opt /1/test/
btrfs restore -v -t 29900800 -i /dev/vg0/opt /1/test/
btrfs restore -v -t 4194304 -i /dev/vg0/opt /1/test/
btrfs restore -v -t 160096 -i /dev/vg0/opt /1/test/

The 1. and the 2. one yield to the corrupt larger files, the 3. and the 4. one 
yield to
"
parent transid verify failed on 4194304 wanted 160096 found 2
parent transid verify failed on 4194304 wanted 160096 found 2
Ignoring transid failure
Reached the end of the tree searching the directory
"
and
"
checksum verify failed on 160096 found CD40BDC4 wanted 00000000
checksum verify failed on 160096 found CD40BDC4 wanted 00000000
bytenr mismatch, want=160096, have=0
Couldn't read tree root
Could not open root, trying backup super
"

I am so confused because nearly all (older and newer) small files are OK but 
nearly all (older and newer) larger files are corrupt. I never did a "btrfs 
balance" etc. on the filesystem.

Are there any options to recover the data?

Thanks

Martin




