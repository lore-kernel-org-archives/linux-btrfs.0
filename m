Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:54936 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdJKKmO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 06:42:14 -0400
Received: by mail-ua0-f171.google.com with SMTP id n38so795073uai.11
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 03:42:14 -0700 (PDT)
MIME-Version: 1.0
From: Ian Kumlien <ian.kumlien@gmail.com>
Date: Wed, 11 Oct 2017 12:41:50 +0200
Message-ID: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
Subject: Fatal failure, btrfs raid with duplicated metadata
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was running a btrfs raid with 6 disks, metadata: dup and data: raid 6

Two of the disks started behaving oddly:
[436823.570296] sd 3:1:0:4: [sdf] Unaligned partial completion
(resid=244, sector_sz=512)
[436823.578604] sd 3:1:0:4: [sdf] Unaligned partial completion
(resid=52, sector_sz=512)                             [436823.617593]
sd 3:1:0:4: [sdf] Unaligned partial completion (resid=56,
sector_sz=512)
[436823.617771] sd 3:1:0:4: [sdf] Unaligned partial completion
(resid=222, sector_sz=512)
[436823.618386] sd 3:1:0:4: [sdf] Unaligned partial completion
(resid=246, sector_sz=512)
[436823.618463] sd 3:1:0:4: [sdf] Unaligned partial completion
(resid=56, sector_sz=512)
[436977.701944] scsi_io_completion: 68 callbacks suppressed
[436977.701973] sd 3:1:0:4: [sdf] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[436977.701982] sd 3:1:0:4: [sdf] tag#0 Sense Key : Hardware Error
[current]
[436977.701991] sd 3:1:0:4: [sdf] tag#0 Add. Sense: Logical unit
failure
[436977.702000] sd 3:1:0:4: [sdf] tag#0 CDB: Read(10) 28 00 02 fb fb
80 00 00 28 00
[436977.702005] print_req_error: 68 callbacks suppressed
[436977.702010] print_req_error: critical target error, dev sdf,
sector 50068352
[498132.144319] print_req_error: 450 callbacks suppressed
[498132.144324] print_req_error: critical target error, dev sdf,
sector 41777640
[498132.144590] btrfs_dev_stat_print_on_error: 540 callbacks
suppressed
[498132.144600] BTRFS error (device sdb1): bdev /dev/sdf1 errs: wr
632, rd 1526, flush 0, corrupt 0, gen 0

Eventually the filesystem becomes read-only and everything is odd...

Trying to run btrfs check on the disks results in:
btrfs check -b /dev/disk/by-uuid/8d431da9-dad4-481c-a5ad-5e6844f31da0
bytenr mismatch, want=912228352, have=0
Couldn't read tree root
ERROR: cannot open file system

(For backup and normal)

So even if the data is duplicated on all disks, something in the above
errors seemed to cause it to abort
(These disks are seagate sshd disks, never ever buying them again)
