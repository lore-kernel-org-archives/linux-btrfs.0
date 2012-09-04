Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53597 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab2IDOXa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2012 10:23:30 -0400
Received: by eekc1 with SMTP id c1so2468352eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2012 07:23:28 -0700 (PDT)
Message-ID: <1346768600.27224.29.camel@lapoo.opensvc.com>
Subject: [ANNOUNCE] opensvc btrfs send/receive driver
From: Christophe Varoqui <christophe.varoqui@gmail.com>
Reply-To: christophe.varoqui@opensvc.com
To: linux-btrfs@vger.kernel.org
Date: Tue, 04 Sep 2012 16:23:20 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

OpenSVC >= 120904.1516 now contains a replication driver for the btrfs
send/receive mecanism. This new driver adds up to the zfs, rsync, dds,
netapp, datacore and drbd existing drivers.

It is no more mature than btrfs send/receive itself, so don't use in
production clusters for now.


--- background ---

OpenSVC is a GPLv2 cluster resource manager which handles replication to
peer nodes and disaster recovery nodes. More information about it at
http://www.opensvc.com and http://docs.opensvc.com (and specifically
about btrfs here : http://docs.opensvc.com/storage.btrfs.html)

--- background ---


Concerning this btrfs driver, the logic implemented is :

- create @tosent readonly snapshots on sender
- for each subvol-remote pair:
 * send/receive the @tosent snap
 * rotate @tosent to @sent on remote
 * recursive clean-up of the destination final location on remote
 * install the @sent subvol as rw snapshots on remotes
- rotate @tosent to @sent on sender


I'm interested on your opinion on the sanity of this logic.


Meanwhile, here are the caveats I encountered while developping this
driver :

- no recursive snapshot/delete/send : for now you have to declare one
sync resource per subvol, even if they are organised as a tree. Not a
big deal, but would make the life of users easier and would solve the
multi-snapshot atomocity issue. 

- btrfs receive is easily confused when looking for a subvol parent id :
for now opensvc has to mount the ID5 root vol
on /opt/opensvc/var/btrfs/<label> and uses a flat/root-level snapshot
hosting. If the btrfs feature matures we want to move to a .osvcsnap/
dedicated subvol mounted in /opt/opensvc/var/btrfs/<label>.osvcnap/
instead to not expose the whole btrfs structure. Some failure scenarios
I tested included "receive in a subvol" and "receive in a subdir"

- some kernel stacks and hangs when off-roading (trying to delete a
parent subvol for example) ... most on btrfs_get_token_64+0x90/0xca .
Let me know if you are interested in the details.


Anyway, thank you for this much needed feature. This is great work.

Best regards,
Christophe Varoqui
OpenSVC


