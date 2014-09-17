Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48448 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756162AbaIQTK3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 15:10:29 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:56440 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XUKcW-003uXb-Ls
	for linux-btrfs@vger.kernel.org; Wed, 17 Sep 2014 13:10:29 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs balance enospc
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5419CA37.1070608@intellasoft.net>
Date: Wed, 17 Sep 2014 13:10:30 -0600
Message-Id: <4601FF0D-31C3-48EA-8BD8-D789086336F0@colorremedies.com>
References: <54186A4B.60902@intellasoft.net> <54186A82.7070801@intellasoft.net>,<5760D61A-8550-4386-8125-0A29A81ADE3A@colorremedies.com> <BAY172-W49807D9D79231B7B004F04B0C90@phx.gbl> <5419CA37.1070608@intellasoft.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 17, 2014, at 11:51 AM, Mark Murawski <markm-lists@intellasoft.net> wrote:

> > Does/should a balance imply removal of missing devices (as long as the minimum number of devices are still available)?
> 
> That's a really good question.  As a user I would expect it to balance over remaining devices assuming you still have a complete picture. Doing a device delete missing after a balance should be just some pool metadata updates at that point.
> 
> Anyway... I solved my problem by moving/deleting files to free up space to the point that balance no longer complained about enospc.

Another option in such a case is to add a new device. It can be small, even a 2GB loop device or USB stick would do it in a bind. Then delete the device when you're done.


Chris Murphy

