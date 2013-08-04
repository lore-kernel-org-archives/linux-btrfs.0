Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45955 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752792Ab3HDSj2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 14:39:28 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:61636 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1V63DD-000SqH-H3
	for linux-btrfs@vger.kernel.org; Sun, 04 Aug 2013 12:39:27 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: building btrfs corrupt block
Message-Id: <45469DAE-A90B-4E66-A03B-F35EBF92FDB8@colorremedies.com>
Date: Sun, 4 Aug 2013 12:39:28 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I must be doing something wrong, but I can't figure out what. I have btrfs-progs source installed from here:
http://koji.fedoraproject.org/koji/buildinfo?buildID=441375

make produces no errors. Yet btrfs-corrupt-block.c isn't built. Suggestions?


Chris Murphy