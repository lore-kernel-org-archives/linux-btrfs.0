Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50057 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2GEUBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jul 2012 16:01:25 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id BDC69jdcp0vc8N0y (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 05 Jul 2012 14:01:24 -0600 (MDT)
Date: Thu, 5 Jul 2012 16:01:22 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs branch updated
Message-ID: <20120705200122.GE7159@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've updated the master branch with the pending stable btrfs-progs
commit that should make the 0.20 release.

Thanks to Hugh for helping to queue up a few of them.  We'll have more
frequent releases from here as we pull in the major new features going
into progs (raid5/6, send/receive, quotas, fsck improvements).

Please give it a shot and let me know if you see any problems.

-chris

