Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:46560 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbeBWLVZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 06:21:25 -0500
Received: by mail-ot0-f179.google.com with SMTP id g97so1498568otg.13
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 03:21:25 -0800 (PST)
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 23 Feb 2018 16:51:24 +0530
Message-ID: <CANT5p=q76WRoc8VHdLKqb8zZrGm3h4qpt2o4-zv=M-Mmd3rtBQ@mail.gmail.com>
Subject: Btrfs occupies more space than du reports...
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Can someone explain me why there is a difference in the number of
blocks reported by df and du commands below?

=====================
# df -h /dc
Filesystem      Size  Used Avail Use% Mounted on
/dev/drbd1      746G  519G  225G  70% /dc

# btrfs filesystem df -h /dc/
Data, single: total=518.01GiB, used=516.58GiB
System, DUP: total=8.00MiB, used=80.00KiB
Metadata, DUP: total=2.00GiB, used=1019.72MiB
GlobalReserve, single: total=352.00MiB, used=0.00B

# du -sh /dc
467G    /dc
=====================

df shows 519G is used. While recursive check using du shows only 467G.
The filesystem doesn't contain any snapshots/extra subvolumes.
Neither does it contain any mounted filesystem under /dc.
I also considered that it could be a void left behind by one of the
open FDs held by a process. So I rebooted the system. Still no
changes.

The situation is even worse on a few other systems with similar configuration.

-- 
-Shyam
