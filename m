Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:59832 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2L2FFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Dec 2012 00:05:08 -0500
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 33B5E155E46
	for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2012 16:04:56 +1100 (EST)
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: determining filesystem mount points
Date: Sat, 29 Dec 2012 16:04:52 +1100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201212291604.52597.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What's a good way of determining the mount point for a BTRFS filesystem in a 
shell script?

/home/user might be a filesystem, a directory under a filesystem /home, a 
directory under a subvol /home of /, a subvol of /, or a subvol of the /home 
filesystem.  How do I determine which it is?

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
