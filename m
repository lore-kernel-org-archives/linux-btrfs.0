Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:56679 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858Ab2IMM4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 08:56:21 -0400
Date: Thu, 13 Sep 2012 08:56:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.ru>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: "Task blocked for more than 120 seconds" on file copy
Message-ID: <20120913125618.GD12994@localhost.localdomain>
References: <20120913031623.1e2d18f5@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120913031623.1e2d18f5@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2012 at 03:16:23PM -0600, Roman Mamedov wrote:
> Hello,
> 
> I was copying a 60 GB file onto btrfs, and at the same time tried to stop/restart Squid,
> which has its cache on the same partition. Squid locked up until the copying was finished.
> This filesystem was resized by about +100% just before, if this could matter.
> The kernel is 3.6.0-rc5. From dmesg:
> 

When you get these sort of lockups we need sysrq+w to get all of the blocked
tasks, not just hte ones that the hung task timer catches.  Thanks,

Josef
