Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34439 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GPLox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 07:44:53 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa11so696253pad.33
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 04:44:53 -0700 (PDT)
MIME-Version: 1.0
From: Martin Hierholzer <hier@beta-centauri.de>
Date: Tue, 16 Jul 2013 13:44:33 +0200
Message-ID: <CAK-gwOwTtHwjnS5c96etrDa8t6YdWH+=wXj9v-jVMmjxa14ffg@mail.gmail.com>
Subject: Bug in btrfs check
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have found (probably) a bug in btrfs check. I have a file system
with errors (potentially a broken disk, although smartctl and
badblocks didn't reveal any errors I keep getting file system
corruptions). When I try to repair it using "btrfs check /dev/sdb1",
the tool aborts after a while:

[root@lheppc88 ~]# btrfs check /dev/sdb1
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to stat /dev/dm-0
failed to stat /dev/dm-1
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to open /dev/btrfs-control skipping device registration: No
such file or directory
failed to stat /dev/dm-0
failed to stat /dev/dm-1
warning devid 2 not found already
Checking filesystem on /dev/sdb1
UUID: 2b0b1e5b-71ee-460e-a0f0-9300153039da
checking extents
incorrect offsets 2931 1073744755
bad block 13000034267136
owner ref check failed [13000034267136 4096]
Errors found in extent allocation tree or chunk allocation
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
incorrect offsets 2931 1073744755
btrfs: cmds-check.c:1006: count_csum_range: Assertion `!(ret < 0)' failed.
Aborted

In this case, I removed one of the disks so it prints "warning devid 2
not found already", but I reproduced this also with all disks.
Strangely, any disk missing will give me exactly the same error
including the same bad block (which I though would be only on one of
the disks?).

Please let me know in case you need more information. Also any hint
how to recover from such situation would be really welcome...

Cheers,
Martin
