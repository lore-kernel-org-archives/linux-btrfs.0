Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37476 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab3F2Nsw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 09:48:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UsvWE-0008AC-Bm
	for linux-btrfs@vger.kernel.org; Sat, 29 Jun 2013 15:48:50 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 15:48:50 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 15:48:50 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: btrfsck output: What does it all mean?
Date: Sat, 29 Jun 2013 14:48:40 +0100
Message-ID: <kqmoji$hv5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the btrfsck output for a real-world rsync backup onto a btrfs
raid1 mirror across 4 drives (yes, I know at the moment for btrfs raid1
there's only ever two copies of the data...)


checking extents
checking fs roots
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
root 256 inode 18446744073709551604 errors 2000
root 256 inode 18446744073709551605 errors 1
found 3183604633600 bytes used err is 1
total csum bytes: 3080472924
total tree bytes: 28427821056
total fs tree bytes: 23409475584
btree space waste bytes: 4698218231
file data blocks allocated: 3155176812544
 referenced 3155176812544
Btrfs Btrfs v0.19
Command exited with non-zero status 1


So: What does that little lot mean?

The drives were mounted and active during an unexpected power-plug pull :-(


Safe to mount again or are there other checks/fixes needed?

Thanks,
Martin

