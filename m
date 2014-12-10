Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53747 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaLJAKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 19:10:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XyUrg-00023Z-JI
	for linux-btrfs@vger.kernel.org; Wed, 10 Dec 2014 01:10:48 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 01:10:48 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Dec 2014 01:10:48 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Why do I have to remount to receive?
Date: Tue, 09 Dec 2014 19:10:29 -0500
Message-ID: <87k320mkju.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Version information:

  # btrfs --version
  Btrfs v3.17
  # uname -a
  Linux maru2 3.16.0-4-amd64 #1 SMP Debian 3.16.7-2 (2014-11-06) x86_64 GNU/Linux

In the following system, /backup is a mounted subvolume.  The initial
send/receive worked, but when trying to send an incremental I get the
following warning:

  # btrfs send -p /snapshots/2014-12-09 /snapshots/test | btrfs receive -vvv /backup/snapshots/root/
  At subvol /snapshots/test
  At snapshot test
  receiving snapshot test uuid=9c72c30a-04c0-6442-9a9a-7ee9c56014e2, ctransid=1030360 parent_uuid=4eb30116-2c1a-f94d-b964-98cd41262dfb, parent_ctransid=1030202
  It seems that you have changed your default subvolume or you specify other subvolume to
  mount btrfs, try to remount this btrfs filesystem with fs tree, and run btrfs receive again!

I understand what it is saying, but I have to ask, why?  Why does it or
should it need me to remount the root fs to do an incremental receive?

-- 
Michael Welsh Duggan
(md5i@md5i.com)

