Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3BYFbf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 00:31:35 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1P5VYfB029565
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:35 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1P5VX28006043
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:34 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1P5VXY5020084
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 23:31:33 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2 v4] Btrfs-progs: Add support for subvol label
Date: Mon, 25 Feb 2013 13:31:27 +0800
Message-Id: <1361770289-1165-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the Btrfs-progs changes to add support for the subvol label.
As discussed in the mailing-list there are two ways we could get the
label attached to the subvol, using kernel-ioctl method and the
other method is by using attributes.

I preferred kernel-ioctl method over the attribute since
there might be more than just the btrfs-progs which is reading and
writing the label, if used attributes, the keyword is defined and
used at the application level, which will be difficult to publicize
and maintain the consistent keyword across any application in the
long run.  In the kernel-ioctl method we don't have this problem.

For kernel-ioctl method you need the below two Btrfs-progs 
patches and the following kernel patch which is posted to
mailing-list

 --------
  Btrfs: ability to add label to snapshot and subvol

 fs/btrfs/ctree.h           | 12 +++++++++-
 fs/btrfs/ioctl.c           | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c     |  1 +
 include/uapi/linux/btrfs.h |  2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)
 --------

Still in any case if we decide to use the attributes method
over the kernel-ioctl method, then following btrfs-progs patch
  Btrfs-progs: add feature to label subvol and snapshot
should be replaced with
  Btrfs-progs: add attribute label for subvol and snapshot
  (also posted in the mailing-list)
and the above kernel patch should be removed.

v4: rebased to David's integration-20130219 branch

Anand Jain (2):
  Btrfs-progs: add feature to label subvol and snapshot
  Btrfs-progs: cmd option to show or set the subvol label

 btrfslabel.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
 btrfslabel.h     |  4 +++-
 cmds-subvolume.c | 37 +++++++++++++++++++++++++++++++++++++
 ctree.h          |  4 +++-
 ioctl.h          |  2 ++
 man/btrfs.8.in   |  6 ++++++
 print-tree.c     |  2 ++
 7 files changed, 98 insertions(+), 2 deletions(-)

-- 
1.8.1.227.g44fe835

