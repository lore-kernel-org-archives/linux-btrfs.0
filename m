Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:54017 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2JHROv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 13:14:51 -0400
Received: from campbell-lange.net ([93.191.37.68])
	by mx1.workshopit.co.uk with esmtp (Exim 4.72)
	(envelope-from <rory@campbell-lange.net>)
	id 1TLGCp-0000ZP-Bx
	for linux-btrfs@vger.kernel.org; Mon, 08 Oct 2012 17:29:23 +0100
Received: from 46-65-49-47.zone16.bethere.co.uk ([46.65.49.47] helo=orchard)
	by campbell-lange.net with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <rory@campbell-lange.net>)
	id 1TLGDh-0008NN-2h
	for linux-btrfs@vger.kernel.org; Mon, 08 Oct 2012 17:30:17 +0100
Received: from rory by orchard with local (Exim 4.80)
	(envelope-from <rory@roryt42os.office.campbell-lange.net>)
	id 1TLGDb-0005wd-1Y
	for linux-btrfs@vger.kernel.org; Mon, 08 Oct 2012 17:30:11 +0100
Date: Mon, 8 Oct 2012 17:30:10 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs receive to subdirectory
Message-ID: <20121008163010.GA22763@campbell-lange.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can send snapshots to <volume>, but not <volume>/<dir>. Please advise
if what I am doing is incorrect.

Rory

Format usb3 disk and mount
	root@orchard:/bkp# mkfs.btrfs /dev/sdb1
	> WARNING! - Btrfs v0.20-rc1-37-g91d9eec IS EXPERIMENTAL
	> WARNING! - see http://btrfs.wiki.kernel.org before using
	> fs created label (null) on /dev/sdb1
	> 	nodesize 4096 leafsize 4096 sectorsize 4096 size 698.64GB
	> Btrfs v0.20-rc1-37-g91d9eec
	mount /dev/sdb1 /mnt


Create snapshots on /bkp share
	root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/snap_081012_1715
	> Create a readonly snapshot of 'subvol' in 'snaps/snap_081012_1715'
	root@orchard:/bkp# mutt -f subvol/INBOX/
    > 1561 kept, 18 deleted.
	root@orchard:/bkp# btrfs subvolume snapshot -r subvol snaps/snap_081012_1716
    > Create a readonly snapshot of 'subvol' in 'snaps/snap_081012_1716'

Send base backup to /mnt
	root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt
	> At subvol snaps/snap_081012_1715
	> At subvol snap_081012_1715

Send incremental backup to /mnt
	root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
                       snaps/snap_081012_1716 | btrfs receive /mnt
	> At subvol snaps/snap_081012_1716
	> At snapshot snap_081012_1716

	root@orchard:/bkp# ls /mnt
	snap_081012_1715  snap_081012_1716

Results:
	root@orchard:/bkp# btrfs subvolume list /bkp 
	> ID 259 gen 62 top level 5 path subvol
	> ID 278 gen 60 top level 5 path snaps/snap_081012_1715
	> ID 279 gen 62 top level 5 path snaps/snap_081012_1716
	root@orchard:/bkp# btrfs subvolume list /mnt 
	> ID 256 gen 8 top level 5 path snap_081012_1715
	> ID 259 gen 9 top level 5 path snap_081012_1716

Restart:
	root@orchard:/bkp# btrfs subvolume del /mnt/snap_081012_171*
	> Delete subvolume '/mnt/snap_081012_1715'
	> Delete subvolume '/mnt/snap_081012_1716'

Try and snap to /mnt/<subdir>
	root@orchard:/bkp# mkdir /mnt/snaps
	root@orchard:/bkp# btrfs send snaps/snap_081012_1715 | btrfs receive /mnt/snaps
	> At subvol snaps/snap_081012_1715
	> At subvol snap_081012_1715
	root@orchard:/bkp# btrfs send -p snaps/snap_081012_1715 \
	                   snaps/snap_081012_1716 | btrfs receive /mnt/snaps
	> At subvol snaps/snap_081012_1716
	> At snapshot snap_081012_1716
	> ERROR: open snaps/snap_081012_1715 failed. No such file or directory
    root@orchard:/bkp# ls /mnt/snaps
    > snap_081012_1715



-- 
Rory Campbell-Lange
rory@campbell-lange.net
