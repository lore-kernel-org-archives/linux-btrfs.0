Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56014 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2HGRks (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Aug 2012 13:40:48 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1Synlv-0003xK-MV
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Aug 2012 10:40:47 -0700
Date: Tue, 7 Aug 2012 10:40:47 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs panic in 3.5.0
Message-ID: <20120807174047.GE24635@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately I only have a screenshot.

Apparently the panic was in 
btrfs_set_lock_blocking_rw
with a RIP in btrfs_cow_block

Screenshot here:
http://marc.merlins.org/tmp/btrfs_oops.jpg

Because the display looks a bit messed up, I can't tell if the ata error
happened before or after the oops.

System rebooted ok.

Was there a better way to get this ooops if I didn't have serial console?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
