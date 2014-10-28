Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42834 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754071AbaJ1Qkw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 12:40:52 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56609 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Xj9pA-0043A2-RF
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 10:40:49 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: kworker/dying during scrubs
Message-Id: <73AC627A-83C4-45E2-B202-7A65515F4557@colorremedies.com>
Date: Tue, 28 Oct 2014 10:40:49 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

3.16.6-203.fc20.x86_64+debug
Doing a scrub on a raid1 volume, directly formatted 2 plain unpartitioned HDDs.

Every now and then I get a message:
[  613.056923] kworker/dying (6) used greatest stack depth: 10600 bytes left

This doesn't happen when I'm not doing scrubs. It doesn't happen with kernel 3.14.22. There doesn't seem to be an immediate consequence of this but it's unexpected.

Chris Murphy