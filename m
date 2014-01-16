Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaAPPpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 10:45:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W3p7v-0006ed-Nu
	for linux-btrfs@vger.kernel.org; Thu, 16 Jan 2014 16:45:03 +0100
Received: from exa2-in-fw-01-epn.hns.com ([139.85.223.11])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 16:45:03 +0100
Received: from ndbecker2 by exa2-in-fw-01-epn.hns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Jan 2014 16:45:03 +0100
To: linux-btrfs@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: [newb] btrfs send problem
Date: Thu, 16 Jan 2014 10:38:52 -0500
Message-ID: <lb8ue0$hic$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hope this is an appropriate place to ask user questions.

I'm trying out snapshot and replication.  I have

/dev/sda3 on / type btrfs (rw,relatime,ssd,space_cache)
/dev/sda3 on /home type btrfs (rw,relatime,ssd,space_cache)

create a subvolume for snapshots:

#btrfs sub create /.snapshots
Create subvolume '//.snapshots'

[root@nbecker1 nbecker]# btrfs subvolume list /
ID 256 gen 563396 top level 5 path home
ID 258 gen 563396 top level 5 path root
ID 372 gen 563396 top level 258 path .snapshots

[root@nbecker1 nbecker]# btrfs sub snapshot -r /home /.snapshots
Create a readonly snapshot of '/home' in '/.snapshots/home'

[root@nbecker1 nbecker]# btrfs subvolume list /
ID 256 gen 563398 top level 5 path home
ID 258 gen 563398 top level 5 path root
ID 372 gen 563398 top level 258 path .snapshots
ID 373 gen 563398 top level 258 path .snapshots/home

[root@nbecker1 nbecker]# btrfs send /.snapshots/home > /dev/null
At subvol /.snapshots/home
ERROR: open root/.snapshots/home failed. No such file or directory


