Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39901 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751067AbaB0VGB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 16:06:01 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:61387 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WJ89Y-002wxn-B6
	for linux-btrfs@vger.kernel.org; Thu, 27 Feb 2014 14:06:00 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: BUG: >16TB Btrfs volumes are mountable on 32 bit kernels
Message-Id: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com>
Date: Thu, 27 Feb 2014 14:05:59 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

User reports successfully formatting and using an ~18TB Btrfs volume on hardware raid5 using i686 kernel for over a year, and then suddenly the file system starts behaving weirdly:

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31856.html


I think this is due to the kernel page cache address space being 16TB limited on 32-bit kernels, as mentioned by Dave Chinner in this thread:

http://oss.sgi.com/pipermail/xfs/2014-February/034588.html

So it sounds like it shouldn't be possible to mount a Btrfs volume larger than 16TB on 32-bit kernels. This is consistent with ext4 and XFS which refuse to mount large file systems.



Chris Murphy