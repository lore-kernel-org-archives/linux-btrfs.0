Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outgoing.tormail.org ([82.221.96.22]:34668 "EHLO
	outgoing.tormail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2L1Wmm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 17:42:42 -0500
Received: from localhost ([127.0.0.1] helo=internal.tormail.org)
	by outgoing.tormail.org with esmtp (Exim 4.72)
	(envelope-from <junlion@tormail.org>)
	id 1ToidU-0008H0-Dy
	for linux-btrfs@vger.kernel.org; Sat, 29 Dec 2012 01:42:40 +0300
Received: from junlion by internal.tormail.org with local (Exim 4.63)
	(envelope-from <junlion@tormail.org>)
	id 1ToibV-0001fD-SN
	for linux-btrfs@vger.kernel.org; Fri, 28 Dec 2012 22:40:39 +0000
Date: Fri, 28 Dec 2012 22:42:36 +0000
From: junlion@tormail.org
To: linux-btrfs@vger.kernel.org
Subject: Incremental btrfs receive in opposite direction fails
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <1ToibV-0001fD-SN@internal.tormail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone!

(I use kernel 3.7.1 and mason/btrfs-progs.git head + the receive
lchown patch [1]. Is there a more up to date btrfs-progs repo for
send/receive enthusiasts?)

What I'm trying is basically:

# Transfer a snapshot of my old system from a backup to the new system
btrfs send /mnt/bak/.snap | btrfs receive /                 # OK

# Merge the old system's files with the new system's files
btrfs subvolume snapshot /.snap /.snap-merge                # OK
mkdir /.snap-merge/.old                                     # OK
mv /.snap-merge/* /.snap-merge/.old                         # OK
cp -a --reflink /* /.snap-merge                             # OK
btrfs subvolume snapshot -r /.snap-merge /.snap-merge-done  # OK

# Incrementally transfer the merged files back to the backup drive
btrfs send -p /.snap /.snap-merge-done | btrfs receive -p /mnt/bak

The last step fails due to the changed direction of the transfer.
"ERROR: could not find parent subvolume". It seems like btrfs receive
cannot find the parent/clone source because it is searching for its UUID
only by looking through the /mnt/bak snapshots' received_uuid fields.

Is there a way for me to directly change the received_uuid of
/mnt/bak/.snap to make it identical to the UUID of /.snap? This looks
like the easiest way if I only need to do it once.

[1] https://patchwork.kernel.org/patch/1606091/
