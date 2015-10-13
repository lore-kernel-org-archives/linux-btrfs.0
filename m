Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36166 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbbJMXZz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 19:25:55 -0400
Received: by iodz80 with SMTP id z80so2283113iod.3
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 16:25:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Oct 2015 18:25:54 -0500
Message-ID: <CAMVDA=xRykyzftfXckGZGOfqnYr8XyyxvjoqKcwQwa0eKku_LQ@mail.gmail.com>
Subject: Can't mount btrfs: corrupt leaf, slot offset bad
From: EJ Parker <ejparker12@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I rebooted my server last night and discovered that my btrfs
filesystem (3 disk raid1) would not mount anymore. After doing some
research and getting nowhere I went to IRC and user darkling asked me
a few questions and asked for output of btrfs-debug-tree and
ultimately sent me here saying I should include a handful of things:

Before I go further, let's get required info out of the way:

uname -a:
        Linux archhost1 4.2.3-1-ARCH #1 SMP PREEMPT Sat Oct 3 18:52:50
CEST 2015 x86_64 GNU/Linux
btrfs --version:
        btrfs-progs v4.2.1
output from "btrfs fi show":
    Label: none  uuid: 5470630f-39f4-4d39-90a2-277d7991722a
        Total devices 3 FS bytes used 3.10TiB
        devid    1 size 3.64TiB used 2.12TiB path /dev/sdd
        devid    2 size 3.64TiB used 2.12TiB path /dev/sde
        devid    3 size 3.64TiB used 2.12TiB path /dev/sdc

First, I am able to mount with -o ro,recovery, but not with just -o
recovery. When I attempt to mount w/o ro, I get this in dmesg:
[44478.800613] BTRFS critical (device sde): corrupt leaf, slot offset
bad: block=5674754899968,root=1, slot=147
[44478.802489] BTRFS critical (device sde): corrupt leaf, slot offset
bad: block=5674754899968,root=1, slot=147
[44478.804072] BTRFS error (device sde): Error removing orphan entry,
stopping orphan cleanup
[44478.805856] BTRFS error (device sde): could not do orphan cleanup -22
[44482.635498] BTRFS: open_ctree failed

Running "btrfs-debug-tree -b 5674754899968 /dev/sde" gave me this:
leaf 5674754899968 items 207 free space 30 generation 884595 owner 5
fs uuid 5470630f-39f4-4d39-90a2-277d7991722a
chunk uuid c269615e-7397-41bc-95d0-dfdb2a696b23
[...]
        item 145 key (273094 EXTENT_DATA 364924928) itemoff 8545 itemsize 53
                extent data disk byte 8658465382400 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0
        item 146 key (273094 EXTENT_DATA 364929024) itemoff 8492 itemsize 53
                extent data disk byte 8658465378304 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0
        item 147 key (273094 EXTENT_DATA 364933120) itemoff 8439 itemsize 53
                extent data disk byte 8677950173184 nr 24576
                extent data offset 0 nr 20480 ram 24576
                extent compression 0
        item 148 key (273094 EXTENT_DATA 364953600) itemoff 8333 itemsize 53
                extent data disk byte 8677990363136 nr 20480
                extent data offset 0 nr 16384 ram 20480
                extent compression 0
        item 149 key (273094 EXTENT_DATA 364957696) itemoff 8386 itemsize 53
                extent data disk byte 0 nr 0
                extent data offset 0 nr 18446744073709514752 ram
18446744073709514752
                extent compression 0
        item 150 key (273094 EXTENT_DATA 364969984) itemoff 8280 itemsize 53
                extent data disk byte 8678063341568 nr 20480
                extent data offset 0 nr 16384 ram 20480
                extent compression 0
        item 151 key (273094 EXTENT_DATA 365002752) itemoff 8227 itemsize 53
                extent data disk byte 8678025232384 nr 36864
                extent data offset 0 nr 32768 ram 36864
                extent compression 0
        item 152 key (273094 EXTENT_DATA 365019136) itemoff 8174 itemsize 53
                extent data disk byte 8678112104448 nr 36864
                extent data offset 0 nr 32768 ram 36864
                extent compression 0
        item 153 key (273094 EXTENT_DATA 365051904) itemoff 8121 itemsize 53
                extent data disk byte 8678052835328 nr 53248
                extent data offset 0 nr 49152 ram 53248
                extent compression 0
        item 154 key (273094 EXTENT_DATA 365101056) itemoff 8068 itemsize 53
                extent data disk byte 8678090510336 nr 20480
                extent data offset 0 nr 16384 ram 20480
                extent compression 0
        item 155 key (273094 EXTENT_DATA 365117440) itemoff 8015 itemsize 53
                extent data disk byte 8678117130240 nr 20480
                extent data offset 0 nr 16384 ram 20480
                extent compression 0
[...]


Output from "btrfs check --readonly /dev/sde":
Checking filesystem on /dev/sde
UUID: 5470630f-39f4-4d39-90a2-277d7991722a
checking extents
incorrect offsets 8439 8386
bad block 5674754899968
Errors found in extent allocation tree or chunk allocation
checking free space cache
checking fs roots

Output from (failed) "btrfs check --repair /dev/sdc" (which I tried
prior to seeking help):
enabling repair mode
Checking filesystem on /dev/sdc
UUID: 5470630f-39f4-4d39-90a2-277d7991722a
checking extents
incorrect offsets 8439 8386
shifting item nr 148 by bytes in block 5674754899968
items overlap, can't fix
cmds-check.c:4059: fix_item_offset: Assertion `ret` failed.


darklink also mentioned that btrfs-zero-log might help too, but that I
should get confirmation from one of the devs on that.
