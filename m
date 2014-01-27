Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37617 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753241AbaA0CYe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 21:24:34 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55953 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W7bsH-000JMg-HY
	for linux-btrfs@vger.kernel.org; Sun, 26 Jan 2014 19:24:33 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: RFE: proactive "marginally bad" block detection during scrubs
Message-Id: <E71DD6C6-524F-4DFC-B136-BAC906668D47@colorremedies.com>
Date: Sun, 26 Jan 2014 19:24:32 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Most consumer drives have bad sector timeouts that aren't configurable, and are in the ~120 second realm. The kernel puts a SCSI command timer on each command, which by default is 30 seconds. This mismatch means drives can develop bad sectors that can't be recovered, because the kernel resets the device before the drive gives up and reports a media error along with the affected LBA.

Would it be possible for Btrfs scrubs to put a timer on each LBA read request, and if there's a delay, overwrite the delayed LBAs? That way latent sector errors won't get so bad that they take more than 30 seconds to recover. Overwriting slow sectors should fix the problem.

Yes? No? Other?


Chris Murphy