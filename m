Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mslow2.mail.gandi.net ([217.70.178.242]:47060 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727697AbeIUSfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 14:35:31 -0400
Received: from relay10.mail.gandi.net (unknown [217.70.178.230])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 4E6523AA541
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 14:30:39 +0200 (CEST)
Received: from localhost (wtsc4b153.netvigator.com [219.76.24.153])
        (Authenticated sender: leonard@lausen.nl)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 0A08424000D
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 12:30:36 +0000 (UTC)
From: Leonard Lausen <leonard@lausen.nl>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send receive ERROR: chown failed: No such file or directory
Date: Fri, 21 Sep 2018 12:30:32 +0000
Message-ID: <87a7obowwn.fsf@lausen.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I observe the following issue with btrfs send | btrfs receive in a setup
with 2 machines and 3 btrfs file-systems. All machines run Linux 4.18.9.
Machine 1 runs btrfs-progs 4.17.1, machine 2 runs btrfs-progs 4.17 (via
https://packages.debian.org/stretch-backports/btrfs-progs).

1) Machine 1 takes regular snapshots and sends them to machine 2. btrfs 
   btrfs send ... | ssh user@machine2 "btrfs receive /path1"
2) Machine 2 backups all subvolumes stored at /path1 to a second
   independent btrfs filesystem. Let /path1/rootsnapshot be the first
   snapshot stored at /path1 (ie. it has no Parent UUID). Let
   /path1/incrementalsnapshot be a snapshot that has /path1/rootsnapshot
   as a parent. Then
   btrfs send -v /path1/rootsnapshot | btrfs receive /path2
   works without issues, but
   btrfs send -v -p /path1/rootsnapshot /path1/incrementalsnapshot | btrfs receive /path2
   fails as follows:
   ERROR: chown o257-4639416-0 failed: No such file or directory

No error is shown in dmesg. /path1 and /path2 denote two independent
btrfs filesystems.

Note that there was no issue with transferring incrementalsnapshot from
machine 1 to machine 2. No error is shown in dmesg.

Best regards
Leonard
