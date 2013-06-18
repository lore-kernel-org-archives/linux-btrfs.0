Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41508 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756312Ab3FRQhK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Jun 2013 12:37:10 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 62D967C06A2
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 10:37:09 -0600 (MDT)
Date: Tue, 18 Jun 2013 12:37:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: hang on 3.9, 3.10-rc5
Message-ID: <20130618163706.GC19183@localhost.localdomain>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 11:43:30AM -0400, Sage Weil wrote:
> I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this 
> is a known problem?  In this case there is no powercycling; just a regular 
> ceph-osd workload.
> 

Have you gotten sysrq+w?  Can you tell me where

log_one_extent.isra.22+0x485

is on your box?  Thanks,

Josef
