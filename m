Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:48250 "EHLO datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbaIJW3E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Sep 2014 18:29:04 -0400
Date: Thu, 11 Sep 2014 00:22:41 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: <linux-btrfs@vger.kernel.org>, Anand Jain <anand.jain@oracle.com>
Subject: "Btrfs: device_list_add() should not update list when mounted"
 breaks subvol mount
Message-ID: <20140911002241.201bc6c2@datenkhaos.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

commit b96de000bc8bc9688b3a2abea4332bd57648a49f breaks subvolume mount
on one of my systems. I've bisected a mount problem to this commit.
Situation is:

- one hdd with btrfs
- default subvolume (rootfs) is different from subovlid=0
- at boot, several subvols are mounted at /home/$DIR

after commit b96de000bc8bc9688b3a2abea4332bd57648a49f this is not
possible anymore. Trying to mount results in (example):

mount: /dev/sda1 is already mounted or /home/video busy

The output of btrfs show is curious too:

btrfs fi show
Label: none  uuid: 43438ef5-adac-46a9-823e-14951ee6866a
        Total devices 1 FS bytes used 150.05GiB
        *** Some devices missing

Btrfs v3.16

As this is a laptop with only one drive bay, this was never a multi
device setup. I've two more systems with kernel version >3.17-rc3
running and no problem like this.

regards,
  Johannes
