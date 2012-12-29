Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:55650 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab2L2BlO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 20:41:14 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: corrupt filesystem after snapshots on 3.2
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201212291031.44745.russell+btrfs@coker.com.au>
Date: Fri, 28 Dec 2012 18:41:12 -0700
Message-Id: <E14A2E56-6517-4634-ACDD-099C4D2AE315@colorremedies.com>
References: <201212291031.44745.russell+btrfs@coker.com.au>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 28, 2012, at 4:31 PM, Russell Coker <russell+btrfs@coker.com.au> wrote:

> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=695886
> 
> The above bug concerns a RAID-1 filesystem that got corrupt when it ran out of 
> disk space due to too many snapshots while running a 3.2.x kernel.  Running it 
> with a 3.7.1-1~experimental.1 kernel from Debian still doesn't work (I've 
> attached dmesg output after a du on the filesystem caused a kernel panic).  
> This particular test run was done with the filesystem mounted -o recovery.
> 
> Also btrfsck doesn't seem to help things.
> 
> Any suggestions?

Add another disk, or disk partition, to the Btrfs volume. That'll give it more space and hopefully you can back out at that point.


Chris Murphy