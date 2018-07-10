Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-7.server.virginmedia.net ([80.0.253.71]:49650
        "EHLO know-smtprelay-omc-7.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeGJHJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 03:09:51 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by phoenix.fire (8.15.2/8.15.2) with ESMTP id w6A74Fv2006263
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jul 2018 08:04:15 +0100
To: linux-btrfs@vger.kernel.org
From: Pete <pete@petezilla.co.uk>
Subject: Transaction aborted (error -28) btrfs_run_delayed_refs*0x163/0x190
Message-ID: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
Date: Tue, 10 Jul 2018 08:04:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just had the error in the subject which caused the file system to
go read-only.

Further part of error message:
WARNING: CPU: 14 PID: 1351 at fs/btrfs/extent-tree.c:3076
btrfs_run_delayed_refs*0x163/0x190

'Screenshot' here:
https://drive.google.com/file/d/1qw7TE1bec8BKcmffrOmg2LS15IOq8Jwc/view?usp=sharing

The kernel is 4.17.4.  There are three hard drives in the file system.
dmcrypt (luks) is used between btrfs and the disks.

I'm about to run a scrub.  On reboot the disks mounted fine.

Pete
