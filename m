Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:40799 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbcJYObP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 10:31:15 -0400
Received: by mail-qk0-f177.google.com with SMTP id d23so9813517qke.7
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Oct 2016 07:31:15 -0700 (PDT)
MIME-Version: 1.0
From: George Chlipala <gchlip2@uic.edu>
Date: Tue, 25 Oct 2016 09:30:34 -0500
Message-ID: <CABaAYfRcZ5L_hU+J7DLyuLrGtHB0u+5YKSm7CQS4N08B0K3X_w@mail.gmail.com>
Subject: Replace missing drive in RAID56 BTRFS without mounting.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We had a major failure in one drive in a RAID56 BTRFS volume and that
drive is no longer accessible.   How can I replace the drive without
mounting the filesystem?  I have tried using a degraded mount but I
receive the following error messages

ROOT [prometheus:/root] # mount -v -t btrfs -o
compress=zlib,space_cache,noatime,degraded,ro,recovery
/dev/mapper/crypt10 /mnt2/new_pool/
mount: wrong fs type, bad option, bad superblock on /dev/mapper/crypt10,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

Here is the output from dmesg...

[938397.877203] BTRFS info (device dm-16): allowing degraded mounts
[938397.879023] BTRFS info (device dm-16): disk space caching is enabled
[938397.880817] BTRFS: has skinny extents
[938397.898619] BTRFS: failed to read chunk tree on dm-16
[938397.911256] BTRFS: open_ctree failed

I have tried a btrfs check...

ROOT [prometheus:/root] # btrfs check -p /dev/mapper/crypt10
warning, device 3 is missing
checksum verify failed on 21561344 found 01354400 wanted E5D6F9B6
checksum verify failed on 21561344 found 790DBB66 wanted 6B6043A7
checksum verify failed on 21561344 found 790DBB66 wanted 6B6043A7
bytenr mismatch, want=21561344, have=3637706752
Couldn't read chunk tree
Couldn't open file system

I have also tried btrfs restore...

ROOT [prometheus:/root] # btrfs restore -l /dev/mapper/crypt10
warning, device 3 is missing
checksum verify failed on 21561344 found 01354400 wanted E5D6F9B6
checksum verify failed on 21561344 found 790DBB66 wanted 6B6043A7
checksum verify failed on 21561344 found 790DBB66 wanted 6B6043A7
bytenr mismatch, want=21561344, have=3637706752
Couldn't read chunk tree
Could not open root, trying backup super
warning, device 12 is missing
warning, device 11 is missing
warning, device 10 is missing
warning, device 9 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 21020672 found 4EE9E0C6 wanted 7BF0006E
checksum verify failed on 21020672 found 4EE9E0C6 wanted 7BF0006E
bytenr mismatch, want=21020672, have=3637709824
ERROR: cannot read chunk root
Could not open root, trying backup super
warning, device 12 is missing
warning, device 11 is missing
warning, device 10 is missing
warning, device 9 is missing
warning, device 8 is missing
warning, device 7 is missing
warning, device 6 is missing
warning, device 5 is missing
warning, device 4 is missing
warning, device 3 is missing
warning, device 2 is missing
checksum verify failed on 21020672 found 4EE9E0C6 wanted 7BF0006E
checksum verify failed on 21020672 found 4EE9E0C6 wanted 7BF0006E
bytenr mismatch, want=21020672, have=3637709824
ERROR: cannot read chunk root
Could not open root, trying backup super

Is there anything I can do?  Even a partial recovery would be helpful.

Thanks!

- George Chlipala
