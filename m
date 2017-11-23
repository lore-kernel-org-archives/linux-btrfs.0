Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55878 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752617AbdKWQbO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Nov 2017 11:31:14 -0500
MIME-Version: 1.0
Message-ID: <trinity-e19a6c0e-4264-4d24-9fac-7e21d7f036d4-1511454672385@3c-app-mailcom-bs01>
From: koller@caramail.com
To: linux-btrfs@vger.kernel.org
Subject: Issue in recovering and using the mirror superblock
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Nov 2017 17:31:12 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am trying to recover from a mistake I made by overwriting the first GBs of my Btrfs /home partition with a non-Btrfs filesystem.

I have already made a .dd image of the partition, and I am using it to try and find the mirror superblock, in particular the one at 256 GB.

When I run the "btrfs restore" command I get an error message, maybe because the mirror superblock -- I am not sure about the reason.

Using the dummy run option, from the command line I do

btrfs restore -D -u 2 /run/media/user01/SamsungHD/sda2.dd /run/media/user01/ToshibaHD/RecoveredData

The message is get is:

checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
bytenr mismatch, want=20971520, have=709
ERROR: cannot read chunk root
Could not open root, trying backup super

With the -u 1 option (instead of -u 2) I get:

checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
bytenr mismatch, want=20971520, have=709
ERROR: cannot read chunk root
Could not open root, trying backup super
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
checksum verify failed on 20971520 found 33D5DCDD wanted 0000016C
checksum verify failed on 20971520 found 01FA5E60 wanted 0000000E
bytenr mismatch, want=20971520, have=709
ERROR: cannot read chunk root
Could not open root, trying backup super

I have reason to believe that the mirror superblock at 256 GB is intact (I am assuming that only the initial sectors of the partition were overwritten), so I do not understand why it is not being recovered. BTW, the size of the partition is above 300 GBs, so there is supposed to be a mirror superblock at 256 GB.

Can anyone help me?

--------

Here is the btrfs info:

uname -a
Linux adfa-workstation 4.9.63-1-MANJARO #1 SMP PREEMPT Sat Nov 18 14:12:41 UTC 2017 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.13

Thanks

Terry
