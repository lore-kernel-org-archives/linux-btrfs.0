Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49564 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932508AbaHGPbz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Aug 2014 11:31:55 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:54255 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XFPfW-000LNe-05
	for linux-btrfs@vger.kernel.org; Thu, 07 Aug 2014 09:31:54 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [BUG] btrfs send/receive, page allocation failure
Message-Id: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
Date: Thu, 7 Aug 2014 09:31:53 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs send /mnt/320G/2012april_HDD_fullbackup.ro.0/ | btrfs receive /mnt/500G/
At subvol /mnt/320G/2012april_HDD_fullbackup.ro.0/
At subvol 2012april_HDD_fullbackup.ro.0
ERROR: send ioctl failed with -12: Cannot allocate memory
ERROR: unexpected EOF in stream.


kernel-3.16.0-1.fc21.x86_64
btrfs-progs-3.14.2-3.fc21.x86_64


Both the source and destination were recently (< 24 hours) created with the above versions.

Bug report here:
https://bugzilla.kernel.org/show_bug.cgi?id=81781

dmesg excerpt with debug kernel here:
https://bugzilla.kernel.org/attachment.cgi?id=145331


Chris Murphy