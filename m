Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34049 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab3F1PeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 11:34:21 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5E71B9A06AC
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 09:34:21 -0600 (MDT)
Date: Fri, 28 Jun 2013 11:34:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin <m_btrfs@ml1.co.uk>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: raid1 inefficient unbalanced filesystem reads
Message-ID: <20130628153418.GW4288@localhost.localdomain>
References: <kqk4sc$t5d$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <kqk4sc$t5d$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 28, 2013 at 02:59:45PM +0100, Martin wrote:
> On kernel 3.8.13:
> 
> Using two equal performance SATAII HDDs, formatted for btrfs raid1 for
> both data and metadata and:
> 
> The second disk appears to suffer about x8 the read activity of the
> first disk. This causes the second disk to quickly get maxed out whilst
> the first disk remains almost idle.
> 
> Total writes to the two disks is equal.
> 
> This is noticeable for example when running "emerge --sync" or running
> compiles on Gentoo.
> 
> 
> Is this a known feature/problem or worth looking/checking further?

So we balance based on pids, so if you have one process that's doing a lot of
work it will tend to be stuck on one disk, which is why you are seeing that kind
of imbalance.  Thanks,

Josef
