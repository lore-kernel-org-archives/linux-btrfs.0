Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37453 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752855Ab3I3O1j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 10:27:39 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:63395 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VQeRh-000iEk-TJ
	for linux-btrfs@vger.kernel.org; Mon, 30 Sep 2013 08:27:34 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Progress of device deletion?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com>
Date: Mon, 30 Sep 2013 08:27:30 -0600
Message-Id: <2E504581-FA34-425A-B14B-EF3F16FC655C@colorremedies.com>
References: <alpine.DEB.2.10.1309290902050.24007@shack.dolda2000.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 29, 2013, at 1:13 AM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
> 
> Is there any way I can find out what's going on?

For whatever reason, it started out with every drive practically full, in terms of chunk allocation.

e.g.        devid    5 size 2.73TB used 2.71TB path /dev/sdh1

I don't know if the code works this way, but it needs to do a balance (or partial one) to make room before it can start migrating actual complete chunks from 4 disks to 2 disks. And my guess is that it's not yet done balancing sdg1 still.

Post kernel version, btrfs-progs version, and dmesg from the time the delete command was initiated.


Chris Murphy