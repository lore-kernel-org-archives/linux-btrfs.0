Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mbox.akmail.it ([213.21.176.227]:48338 "EHLO pop.aknet.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbcKISdf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 Nov 2016 13:33:35 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pop.aknet.it (8.12.8/8.12.8) with ESMTP id uA9Hu5WC030787
        for <linux-btrfs@vger.kernel.org>; Wed, 9 Nov 2016 18:56:05 +0100
Message-ID: <1478714157.5823632d5829d@webmail.adria.it>
Date: Wed,  9 Nov 2016 18:55:57 +0100
From: bepi@adria.it
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I'm making a script for managing btrfs.

To perform the scrub, to create and send (even to a remote system) of the backup
snapshot (or for one copy of the current state of the data).

The script is designed to:
- Be easy to use:
  - The preparation is carried out automatically.
  - Autodetect of the subvolume mounted.
- Be safe and robust:
  - Check that not exist a another btrfs managing already started.
  - Subvolume for created and received snapshot are mounted and accessible only
    for the time necessary to perform the requested operation.
  - Verify that the snapshot and sending snapshot are been executed completely.
  - Progressive numbering of the snapshots for identify with certainty
    the latest snapshot.

Are also available command for view the list of snaphost present, command for
delete the snapshots.

For example:

btrsfManage SCRUB /
btrsfManage SNAPSHOT /
btrsfManage SEND / /dev/sda1
btrsfManage SEND / root@gdb.exnet.it/dev/sda1
btrsfManage SNAPLIST /dev/sda1
btrsfManage SNAPDEL /dev/sda1 "root-2016-11*"

You are interested?

Gdb


----------------------------------------------------
This mail has been sent using Alpikom webmail system
http://www.alpikom.it

