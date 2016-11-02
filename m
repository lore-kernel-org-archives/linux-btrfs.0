Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from virtualmin.buehlmann.net ([185.95.218.216]:35777 "EHLO
        virtualmin.buehlmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbcKBO3x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 10:29:53 -0400
Received: from [87.239.210.24] (nat13.ergon.ch [87.239.215.13])
        by virtualmin.buehlmann.net (Postfix) with ESMTPSA id 61E3816202C
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Nov 2016 15:23:46 +0100 (CET)
From: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>
Subject: Send/receive snapshot from/between backup
To: linux-btrfs@vger.kernel.org
Message-ID: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
Date: Wed, 2 Nov 2016 15:23:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a system running on btrfs which is backed up to two (one local
USB and one through SSH) external drives (also using btrfs) using
send/receive (with the help of btrbk). For each backup a snapshot is
created and transferred to the external drives. After some time, the
snapshot on the origin is removed but kept on the two backups.

Now my problem is, that the SSH-drive has not received any snapshots for
some time such that there is no snapshot any more which is on the origin
AND the SSH-drive. I would like to prevent transferring a full snapshot
over the network and am now trying to work around it.

Here the current situation (S? for a Snapshot):

Origin: S2 S3

USB: S1 S2

SSH: S1

Transferring S3 to USB is no problem as S2 is on both btrfs drives. But
how can I transfer S3 to SSH?

I tried to transfer...

1. S3 from Origin to SSH -> does not work as there is no common snapshot.

2. S2 from USB to SSH -> did not work.

3. S1 from USB to Origin (such that there is a common snapshot with SSH)
-> did not work.

Is it correct that 1. would work if a common snapshot is present on
Origin and SSH?

Is it expected that 2. and 3. do not work?

Is there some other way to achieve it?

Thanks for the help

René


