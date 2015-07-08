Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f52.google.com ([209.85.216.52]:41518 "EHLO
	mail-vn0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbbGHOBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 10:01:43 -0400
Received: by vnbf62 with SMTP id f62so15176419vnb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 07:01:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2015 08:01:42 -0600
Message-ID: <CAJCQCtSyf+ADvupbAoVi3BPN-TxdYr0n=-6gykWVe-U33rUNAQ@mail.gmail.com>
Subject: [BUG] BTRFS: error in btrfs_run_delayed_refs:2821: errno=-5 IO failure
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The short version: btrfs convert and subsequent balance will eat an
ext4 file system. I've reproduced this 6 for 6 times with both kernel
4.1 and 4.2rc1, but I get different back traces for the two kernels.

Kernel 4.1.0
Btrfs-progs 4.1

New ext4 file system populated with several thousand files (Fedora 22
installation) and a 1.5GB ISO.

Conversion succeeds with no user space or kernel errors. Btrfs check
comes up clean. Deletion of ext2_saved subvolume happens without
error, as does defragment. After this btrfs check is still clean. Then
major problems on btrfs balance and the file system is totally broken
afterward.


balance failure following ext4 to btrfs conversion, BTRFS: error in
btrfs_run_delayed_refs:2821: errno=-5 IO failure
https://bugzilla.kernel.org/show_bug.cgi?id=101191



-- 
Chris Murphy
