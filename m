Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37128 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdHARe4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:34:56 -0400
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Odd fallocate behavior on BTRFS.
Message-ID: <80c607b1-8798-8b86-8657-df2c1992186c@gmail.com>
Date: Tue, 1 Aug 2017 13:34:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A recent thread on the BTRFS mailing list [1] brought up some odd 
behavior in BTRFS that I've long suspected but not had prior reason to 
test.  I've put the fsdevel mailing list on CC since I'm curious to hear 
what people there think about this.

Apparently, if you call fallocate() on a file with an offset of 0 and a 
length longer than the length of the file itself, BTRFS will allocate 
that exact amount of space, instead of just filling in holes in the file 
and allocating space to extend it.  If there isn't enough space on the 
filesystem for this, then it will fail, even though it would succeed on 
ext4, XFS, and F2FS.  The following script demonstrates this:

     #!/bin/bash
     touch ./test-fs
     truncate --size=4G ./test-fs
     mkfs.btrfs ./test-fs
     mkdir ./test
     mount -t auto ./test-fs ./test
     dd if=/dev/zero of=./test/test bs=65536 count=32768
     fallocate -l 2147483650 ./test/test && echo "Success!"
     umount ./test
     rmdir ./test
     rm -f ./test-fs

This will spit out a -ENOSPC error from the fallocate call, but if you 
change the mkfs call to ext4, XFS, or F2FS, it will instead succeed 
without error.  If the fallocate call is changed to `fallocate -o 
2147483648 -l 2 ./test/test`, it will succeed on all filesystems.

I have not yet done any testing to determine if this also applies for 
offsets other than 0, but I suspect it does (it would be kind of odd if 
it didn't).

My thought on this is that the behavior that BTRFS exhibits is incorrect 
in this case, at a minimum because it does not follow the apparent 
de-facto standard, and because it keeps some things from working (the OP 
in the thread that resulted in me finding this was having issues trying 
to extend a SnapRAID parity file that was already larger than half the 
size of the BTRFS volume it was stored on).

I'm curious to hear anybody's thoughts on this, namely:
1. Is this behavior that should be considered implementation defined?
2. If not, is my assessment that BTRFS is behaving incorrectly in this 
case accurate?


[1] https://marc.info/?l=linux-btrfs&m=150158963921123&w=2
