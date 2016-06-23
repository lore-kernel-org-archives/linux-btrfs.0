Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41789 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbcFWVAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 17:00:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bGBjH-0001VI-Oo
	for linux-btrfs@vger.kernel.org; Thu, 23 Jun 2016 23:00:03 +0200
Received: from bl13-157-91.dsl.telepac.pt ([85.246.157.91])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 23:00:03 +0200
Received: from vascomalmeida by bl13-157-91.dsl.telepac.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 23:00:03 +0200
To: linux-btrfs@vger.kernel.org
From: Vasco Almeida <vascomalmeida@sapo.pt>
Subject: Bad hard drive - checksum verify failure forces readonly mount
Date: Thu, 23 Jun 2016 20:30:18 +0000 (UTC)
Message-ID: <loom.20160623T205347-371@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was running OpenSuse Leap 42.1 with btrfs and
LVM (Logical Volume Management).
Last time I've checked smartd log, I noticed there were
30 sector pending reallocation and 1 unrecoverable bad
sector on hard drive.
I think my hard drive got some sector corrupted and now btrfs fails
some checksum and forces mount readonly.
The device is successfully mounted readonly.

OpenSuse dmesg reported:

BTRFS: dm-1 checksum verify failed on 437944320 wanted 39F45669 found
8BF8C752 leval 0
(more 2 times)
BTRFS: error (device dm-1) in btrfs_drop_snapshot:???: error=-5 IO failure
BTRFS: info (device dm-1): forced readonly

Now I'm on System Rescue CD and that is not reported.
I've written down those log line on paper, so there may be some typo.
Seemingly there is no journalctl installed on this system to check
OpenSuse logs again.

All the following logs are on System Rescue CD.
mount -o ro,recovery /dev/mapper/vg_pupu-lv_opensuse_root /mnt/opensuse
https://bpaste.net/show/263e5f7ae9d4

After mounting and umounting several times with and without "-o ro,recovery"
https://bpaste.net/show/43eb64decb63

btrfs check --readonly /dev/mapper/vg_pupu-lv_opensuse_root
https://bpaste.net/show/7ecf422c73a2


Would it be apropriate to run any of "btrfs check --repair /device" or
"btrfs check --init-csum-tree /device" to be able to mount readwrite again?

smartctl --all /dev/disk/by-id/ata-SAMSUNG_HD154UI_S1Y6JDWSC01351
https://bpaste.net/show/a6c132618974

btrfs check manpage: https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-check
btrfsck page: https://btrfs.wiki.kernel.org/index.php/Btrfsck

