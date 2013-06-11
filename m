Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44375 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3FKQVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 12:21:32 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A3CB09A0371
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 10:21:31 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
In-Reply-To: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
Message-ID: <20130611162129.4914.54461@localhost.localdomain>
Subject: Re: hang on 3.9, 3.10-rc5
Date: Tue, 11 Jun 2013 12:21:29 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Sage Weil (2013-06-11 11:43:30)
> I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this
> is a known problem?  In this case there is no powercycling; just a regular
> ceph-osd workload.

Everyone here is waiting for the root node, but it isn't immediately
clear who has the lock.  log_one_extent is the most likely suspect, but
I can't see how it would be scheduling with the root lock held.

Could you please sysrq-w?

-chris
