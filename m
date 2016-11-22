Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:34450 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755430AbcKVNT0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:19:26 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pop.aknet.it (8.12.8/8.12.8) with ESMTP id uAMDJNWC026472
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 14:19:23 +0100
Message-ID: <1479820757.583445d54ca77@webmail.adria.it>
Date: Tue, 22 Nov 2016 14:19:17 +0100
From: bepi@adria.it
To: linux-btrfs@vger.kernel.org
Subject: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

My system: Fedora 23, kernel-4.7.10-100.fc23.x86_64 btrfs-progs-4.4.1-1.fc23.x86_64

Testing the remote differential receive (via ssh and in local network) of 24
sequential snapshots, and simultaneously deleting the snapshot, (in the same
file system, but in a different subvolume), there has been an file access error,
and the file system has corrupt.

Both scrub, both recovery and clear_cache mount options, both btrfsck, have
failed, the file system is left in a state unusable.

After reformatting the filesystem, remote receive of 24 snapshots worked properly.

The file system is used exclusively for receive the snapshot, it is composed of
a single device.
The initial snapshot is a linux installation of 50Gb.


I think that there was a race condition between the receive and deletion of
snapshots (that were performed on two different subvolume).


Best regards.

gdb



----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it

