Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38047 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbaDTTqg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Apr 2014 15:46:36 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:50782 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1Wbxh6-0007A9-07 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Apr 2014 12:46:35 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wbxh5-0000ov-JX
	for linux-btrfs@vger.kernel.org; Sun, 20 Apr 2014 12:46:27 -0700
Date: Sun, 20 Apr 2014 12:46:27 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140420194627.GO7884@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Planning for subvolumes of subvolumes and btrfs send/receive
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Can you help me design this right?

Long story short, I'm wondering if I can use btrfs send to copy sub
subvolumes (by snapshotting a parent subvolume, and hopefully getting
all the children underneath). My reading so far, says no.

So, Ideally I would have:

/mnt/btrfs_pool/backup: backup is a subvolume of btrfs_pool

/mnt/btrfs_pool/backup/debian/machine1: 
/mnt/btrfs_pool/backup/debian/machine2: 
/mnt/btrfs_pool/backup/debian/machine3: 
machinex would be a subvolume ideally speaking for quota counting purposes

/mnt/btrfs_pool/backup/debian/machine1/current
/mnt/btrfs_pool/backup/debian/machine1/201401
/mnt/btrfs_pool/backup/debian/machine1/201308
...

current would be a subvolume, that would be snapshotted to 201401 with
an rsync of diffs on top
Same thing for 201308

In other words, they'd also be subvolumes, and I'm using snapshots so
that I can collapse the identical data (I'm currently using hardlinks
for that).

This would all work fine from what I can see, but from here, if I try to
do 
btrfs subvolume snapshot -r /mnt/btrfs_pool/backup/debian/machine1 /mnt/btrfs_pool/backup/debian/machine1_ro_send
do to a btrfs send next, my understanding is that /mnt/btrfs_pool/backup/debian/machine1_ro_send
will effectively have no data because all my data is in the subvolumes
under that.

As a result, I'd then need a complicated script that goes in each
subvolume and makes independent snapshots for btrfs send/receive.

(In this case, I'm copying my backup data to another backup backup
server)

Is there an easier way to do this, or you can really only btrfs send the
very last level of subvolume if I want the data in there?

I suppose I could use cp -a --reflink instead of snapshots to replicate
the identical data, but the reason I don't love this is that there is no
way I know to replicate that reflink relationship to another filesystem
unless I use btrfs send/receive. Is that correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
