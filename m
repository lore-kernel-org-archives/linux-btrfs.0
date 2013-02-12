Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933825Ab3BLSyx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 13:54:53 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r1CIsq0P012676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 13:54:53 -0500
Received: from localhost (vpn1-6-182.ams2.redhat.com [10.36.6.182])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r1CIspxA026600
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 13:54:52 -0500
Date: Tue, 12 Feb 2013 18:54:49 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: What can I do to make btrfs work?
Message-ID: <20130212185449.GA16773@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs has been broken for me for ages.  I first reported it on this
list 5 months ago[1].  Below is a very simple reproducer that anyone
can run.

*NB* before you run this, adjust /dev/sda & /dev/sda1 to point to an
unused block device!

----------------------------------------------------------------------
#!/bin/sh -
set -e
while true; do
  parted -s -- /dev/sda mklabel msdos
  parted -s -- /dev/sda mkpart primary 64s -64s
  wipefs -a /dev/sda1
  mkfs.btrfs --label TEST /dev/sda1
  mount /dev/sda1 /sysroot
  touch /sysroot/foo
  mkdir /sysroot/bar
  umount /sysroot
done
----------------------------------------------------------------------

On the latest 3.8.0 kernel, this fails immediately (at the mount), and
on 3.7.x it usually fails after a very few iterations.  I see a
variety of errors, but the latest kernel error is:

[    8.474934] device label ROOT devid 1 transid 2 /dev/sda2
[    8.570619] device label ROOT devid 1 transid 2 /dev/sda2
[    8.581891] btrfs: disk space caching is enabled
[    8.594146] btrfs bad tree block start 0 4194304
[    8.595144] btrfs: failed to read tree root on sda2
[    8.605308] btrfs: open_ctree failed

I would really like btrfs to work.  What can I do?

Rich.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/20257

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
