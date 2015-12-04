Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:50562 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbbLDKBF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 05:01:05 -0500
Received: from wheezy.localnet (ns-local [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 337BDEB72
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Dec 2015 21:01:01 +1100 (AEDT)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Subject: 3.16.0 Debian kernel hang
Date: Fri, 4 Dec 2015 21:00:58 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201512042100.58127.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of my test laptops started hanging on mounting the root filesystem.  I 
think that it had experience an unexpected power outage prior to that which 
may have caused corruption.

When I tried to mount the root filesystem the mount process would stick in D 
state, there would be no disk IO, and the computer would get hot - presumably 
due to kernel CPU use even though "top" didn't seem to indicate that.

When I mounted the filesystem with a 4.2.0 kernel it said "The free space cache 
file (1103101952) is invalid, skip it" and then things worked.  Now that the 
machine is running 4.2.0 everything is fine.

I know that there are no plans to backport things to 3.16 and I don't think 
the Debian people are going to be very interested in this.  So this message is 
a FYI for users, maybe consider not using the Debian/Jessie kernel for BTRFS 
systems.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
