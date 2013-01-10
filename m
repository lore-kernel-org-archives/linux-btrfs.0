Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:52902 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab3AJAiv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 19:38:51 -0500
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id D98CE16F136
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jan 2013 11:38:48 +1100 (EST)
From: Russell Coker <russell+btrfs@coker.com.au>
Reply-To: russell+btrfs@coker.com.au
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Subject: 2 errors on scrub
Date: Thu, 10 Jan 2013 11:38:45 +1100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201301101138.45428.russell+btrfs@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The below is from a system running the Debian kernel 3.2.0-4-amd64 on a 120G 
Intel SSD.  What would these 2 errors be?

scrub device /dev/disk/by-uuid/7939c405-c656-4e85-a6a0-29f17be09585 (id 1) 
done
        scrub started at Thu Jan 10 06:00:02 2013 and finished after 295 
seconds
        total bytes scrubbed: 25.42GB with 2 errors
        error details: super=2
        corrected errors: 0, uncorrectable errors: 0, unverified errors: 0

I know you all recommend later kernels, I'm upgrading things as fast as I can.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
