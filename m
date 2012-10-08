Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2JHOQq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 10:16:46 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q98EGjhI006989
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Oct 2012 10:16:45 -0400
Received: from localhost (vpn1-6-178.ams2.redhat.com [10.36.6.178])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q98EGiaB002737
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Oct 2012 10:16:45 -0400
Date: Mon, 8 Oct 2012 15:16:42 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121008141642.GC24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm tracking this bug here:

https://bugzilla.redhat.com/show_bug.cgi?id=863978

Since approx. last week I'm seeing lots of failures in btrfs.  The
common factor seems to be that the filesystem is created (mkfs.btrfs
/dev/sda1) and then it is immediately used -- eg.  mounted or some
btrfs subtool is run on it.  There is no pause or sync between the
operations.

Typical errors include:

mkfs.btrfs /dev/sda1
mount -o  /dev/sda1 /sysroot/
[   96.384211] device fsid 962db3c0-4153-450b-9ca7-c9216e81afe3 devid 1 transid 3 /dev/sda1
[   96.385314] device fsid 962db3c0-4153-450b-9ca7-c9216e81afe3 devid 1 transid 3 /dev/sda1
[   96.394158] btrfs: disk space caching is enabled
[   96.428656] btrfs: failed to recover relocation
[   96.437190] btrfs: open_ctree failed

and:

btrfsck /dev/sda1
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
read block failed check_tree_block
Couldn't read chunk root

(There are plenty of others, see the above bug link)

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://et.redhat.com/~rjones/virt-top
